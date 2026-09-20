#!/usr/bin/env python3
"""Export rogue-usable items from the local cmangos DB as normalized JSON.

Feeds tools/tuffweights (the offline stat-weight calculator). The output is a
scratch file under tools/.cache/ and is gitignored: nothing from the DB may be
copied into this repo (GPL, see the qdb.py header). Only the human-reviewed
notes under plans/ may carry facts from it.

The schema is deliberately source-agnostic (no cmangos column names leak into
it) so a Forever export from an in-game addon can be dropped in later.

Usage:
    python tools/export_items.py
    python tools/export_items.py --out /tmp/items.json --max-level 60

Connection settings are the same QDB_* ones qdb.py uses.
"""

import argparse
import json
import os
import sys
import time
from collections import defaultdict

import qdb

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.join(HERE, ".cache", "items.json")

# item_template.subclass for class 2 (weapons) -> weapon skill key.
# Axes are exported even though Classic Era rogues cannot use them: whether a
# type is usable is the ruleset's call (rules/*.toml), not the exporter's.
WEAPON_SKILL = {0: "axe", 4: "mace", 7: "sword", 13: "fist", 15: "dagger",
                2: "bow", 3: "gun", 16: "thrown", 18: "crossbow"}

# InventoryType -> slot key.
WEAPON_SLOT = {13: "one_hand", 21: "main_hand", 22: "off_hand",
               15: "ranged", 26: "ranged", 25: "thrown"}
ARMOR_SLOT = {1: "head", 2: "neck", 3: "shoulder", 5: "chest", 20: "chest",
              6: "waist", 7: "legs", 8: "feet", 9: "wrist", 10: "hands",
              11: "finger", 12: "trinket", 16: "back"}

STAT_KEY = {3: "agi", 4: "str", 5: "int", 6: "spi", 7: "sta"}

# Aura types (cmangos SPELL_AURA_*) for equip-effect spells, checked against
# the DB by the survey in the export summary.
AURA_AP = 99
AURA_RANGED_AP = 124
AURA_CRIT = 52
AURA_HIT = 54
AURA_SKILL = 30
AURA_STAT = 29          # EffectMiscValue: 0 str, 1 agi, 2 sta, 3 int, 4 spi
AURA_ALL_STATS = None   # misc -1 handled inline
STAT_MISC = {0: "str", 1: "agi", 2: "sta", 3: "int", 4: "spi"}

# MOD_SKILL misc value -> skill key (SkillLine ids).
SKILL_ID = {43: "sword", 44: "axe", 54: "mace", 173: "dagger", 473: "fist",
            172: "2h_axe", 55: "2h_sword", 160: "2h_mace", 136: "staff",
            229: "polearm", 176: "thrown", 45: "bow", 46: "gun", 226: "crossbow",
            95: "defense", 356: "fishing"}

# Auras seen on equip effects that do not move a leveling rogue's damage.
IGNORED_AURAS = {
    13: "spell damage", 135: "healing", 71: "spell crit", 55: "spell hit",
    85: "mana regen", 161: "health regen", 49: "dodge", 47: "parry",
    51: "block", 158: "block value", 22: "resistance/armor", 42: "guardian",
    4: "reputation", 23: "stone passive", 8: "regen", 15: "thorns",
    123: "spell penetration", 102: "creature-type AP", 131: "creature-type",
    107: "ability tweak", 31: "run speed",
}

EFFECT_SCHOOL_DAMAGE = 2
EFFECT_APPLY_AURA = 6
EFFECT_EXTRA_ATTACKS = 19

TRIGGER_USE, TRIGGER_EQUIP, TRIGGER_PROC = 0, 1, 2

INSTANCE_MAPS = {
    33: "Shadowfang Keep", 34: "The Stockade", 36: "The Deadmines",
    43: "Wailing Caverns", 47: "Razorfen Kraul", 48: "Blackfathom Deeps",
    70: "Uldaman", 90: "Gnomeregan", 109: "Sunken Temple",
    129: "Razorfen Downs", 189: "Scarlet Monastery", 209: "Zul'Farrak",
    229: "Blackrock Spire", 230: "Blackrock Depths", 249: "Onyxia's Lair",
    289: "Scholomance", 309: "Zul'Gurub", 329: "Stratholme", 349: "Maraudon",
    389: "Ragefire Chasm", 409: "Molten Core", 429: "Dire Maul",
    469: "Blackwing Lair", 509: "Ruins of Ahn'Qiraj", 531: "Temple of Ahn'Qiraj",
    533: "Naxxramas",
}
OPEN_WORLD_MAPS = (0, 1)

JUNK_PREFIXES = ("test", "deprecated", "monster -", "zz", "old ", "[ph]", "(old)")


def chunks(seq, n=800):
    seq = list(seq)
    for i in range(0, len(seq), n):
        yield seq[i:i + n]


def in_list(ids):
    return ",".join(str(int(i)) for i in ids)


def is_junk(name):
    low = name.lower().strip()
    return (low.startswith(JUNK_PREFIXES) or "(test)" in low or "[test]" in low
            or " test " in low or low.endswith(" test") or "deprecated" in low)


def spell_value(s, n):
    """Average rolled value of effect n (1-3) of a spell_template row."""
    bp = s["EffectBasePoints%d" % n]
    sides = s["EffectDieSides%d" % n]
    dice = s["EffectBaseDice%d" % n] or 1
    lo, hi = bp + dice, bp + dice * max(sides, 1)
    return (lo + hi) / 2.0, lo, hi


def decode_effects(s):
    """List of raw effect dicts for a spell row (only real effects)."""
    out = []
    for n in (1, 2, 3):
        eff = s["Effect%d" % n]
        if not eff:
            continue
        avg, lo, hi = spell_value(s, n)
        out.append({
            "effect": eff,
            "aura": s["EffectApplyAuraName%d" % n],
            "misc": s["EffectMiscValue%d" % n],
            "value": avg, "min": lo, "max": hi,
            "trigger_spell": s["EffectTriggerSpell%d" % n],
            "period_ms": s["EffectAmplitude%d" % n],
        })
    return out


def classify_equip(spell, unmodelled):
    """Turn an equip spell into a dict of modelled bonuses, noting the rest."""
    bonus = {}
    for e in decode_effects(spell):
        if e["effect"] != EFFECT_APPLY_AURA:
            unmodelled.append("equip spell %d %s: effect %d" % (spell["Id"], spell["SpellName"], e["effect"]))
            continue
        aura, v, misc = e["aura"], e["value"], e["misc"]
        if aura == AURA_AP:
            bonus["ap"] = bonus.get("ap", 0) + v
        elif aura == AURA_RANGED_AP:
            bonus["ranged_ap"] = bonus.get("ranged_ap", 0) + v
        elif aura == AURA_CRIT:
            bonus["crit_pct"] = bonus.get("crit_pct", 0) + v
        elif aura == AURA_HIT:
            bonus["hit_pct"] = bonus.get("hit_pct", 0) + v
        elif aura == AURA_SKILL:
            key = SKILL_ID.get(misc)
            if key is None:
                unmodelled.append("equip spell %d %s: skill %d" % (spell["Id"], spell["SpellName"], misc))
            elif key not in ("defense", "fishing"):
                bonus.setdefault("skill", {})
                bonus["skill"][key] = bonus["skill"].get(key, 0) + v
        elif aura == AURA_STAT:
            keys = list(STAT_MISC.values()) if misc == -1 else [STAT_MISC.get(misc)]
            for k in keys:
                if k:
                    bonus.setdefault("stats", {})
                    bonus["stats"][k] = bonus["stats"].get(k, 0) + v
        elif aura in IGNORED_AURAS:
            pass
        else:
            unmodelled.append("equip spell %d %s: aura %d misc %d" % (spell["Id"], spell["SpellName"], aura, misc))
    return bonus


def classify_proc(spell, item_row, n):
    """Describe a chance-on-hit spell so the calculator can value it."""
    effs = []
    for e in decode_effects(spell):
        if e["effect"] == EFFECT_EXTRA_ATTACKS:
            effs.append({"kind": "extra_attack", "count": max(int(round(e["value"])), 1)})
        elif e["effect"] == EFFECT_SCHOOL_DAMAGE:
            effs.append({"kind": "direct_damage", "min": e["min"], "max": e["max"],
                         "school": spell["School"]})
        elif e["effect"] == EFFECT_APPLY_AURA:
            aura = {"kind": "aura", "aura": e["aura"], "misc": e["misc"], "value": e["value"],
                    "school": spell["School"]}
            if e["period_ms"]:
                aura["period_ms"] = e["period_ms"]
            # Index into SpellDuration.dbc, which the DB does not carry; the calculator maps the
            # few indices it needs to seconds in its ruleset file.
            aura["duration_index"] = spell["DurationIndex"]
            effs.append(aura)
        else:
            effs.append({"kind": "other", "effect": e["effect"]})
    return {
        "spell": spell["Id"], "name": spell["SpellName"],
        "ppm": item_row["spellppmRate_%d" % n] or None,
        "proc_chance": spell["ProcChance"],
        "cooldown_ms": item_row["spellcooldown_%d" % n] if item_row["spellcooldown_%d" % n] > 0 else 0,
        "effects": effs,
    }


def load_items(conn, max_level):
    weapon_sub = ",".join(str(s) for s in WEAPON_SKILL)
    weapon_inv = ",".join(str(s) for s in WEAPON_SLOT)
    armor_inv = ",".join(str(s) for s in ARMOR_SLOT)
    sql = ("SELECT * FROM item_template WHERE Quality >= 1 AND RequiredLevel <= %d "
           "AND (AllowableClass <= 0 OR (AllowableClass & 8) <> 0) AND ("
           "(class = 2 AND subclass IN (" + weapon_sub + ") AND InventoryType IN (" + weapon_inv + ")) OR "
           "(class = 4 AND subclass IN (0, 1, 2) AND InventoryType IN (" + armor_inv + ")))"
           ) % max_level
    return [r for r in qdb.query(conn, sql) if not is_junk(r["name"])]


def build_item(row, spells, unmodelled):
    is_weapon = row["class"] == 2
    item = {
        "id": row["entry"], "name": row["name"], "quality": row["Quality"],
        "slot": (WEAPON_SLOT if is_weapon else ARMOR_SLOT)[row["InventoryType"]],
        "req_level": row["RequiredLevel"], "item_level": row["ItemLevel"],
        "bonding": row["bonding"], "req_skill": row["RequiredSkill"] or None,
        "honor_rank": row["requiredhonorrank"] or None,
        "class_mask": row["AllowableClass"] if row["AllowableClass"] > 0 else 0,
        "race_mask": row["AllowableRace"] if row["AllowableRace"] > 0 else 0,
        "buy_price": row["BuyPrice"], "sell_price": row["SellPrice"],
        "armor": row["armor"], "itemset": row["itemset"] or None,
        "random_property": row["RandomProperty"] or None,
        "stats": {}, "sources": {},
    }
    for n in range(1, 11):
        v = row["stat_value%d" % n]
        if v:
            k = STAT_KEY.get(row["stat_type%d" % n])
            if k:
                item["stats"][k] = item["stats"].get(k, 0) + v
    if is_weapon:
        item["weapon"] = {
            "skill": WEAPON_SKILL[row["subclass"]],
            "min": row["dmg_min1"], "max": row["dmg_max1"], "speed_ms": row["delay"],
            "extra_damage": [{"min": row["dmg_min%d" % i], "max": row["dmg_max%d" % i],
                              "school": row["dmg_type%d" % i]}
                             for i in (2, 3, 4, 5) if row["dmg_max%d" % i]],
        }
    equip, procs, on_use = {}, [], []
    for n in range(1, 6):
        sid, trig = row["spellid_%d" % n], row["spelltrigger_%d" % n]
        if not sid:
            continue
        spell = spells.get(sid)
        if spell is None:
            unmodelled.append("item %d %s: spell %d not in DB" % (row["entry"], row["name"], sid))
        elif trig == TRIGGER_EQUIP:
            for k, v in classify_equip(spell, unmodelled).items():
                if isinstance(v, dict):
                    tgt = equip.setdefault(k, {})
                    for kk, vv in v.items():
                        tgt[kk] = tgt.get(kk, 0) + vv
                else:
                    equip[k] = equip.get(k, 0) + v
        elif trig == TRIGGER_PROC:
            procs.append(classify_proc(spell, row, n))
        elif trig == TRIGGER_USE:
            on_use.append(spell["SpellName"])
    if equip:
        item["equip"] = equip
    if procs:
        item["procs"] = procs
    if on_use:
        item["on_use"] = on_use
    return item


def load_spells(conn, rows):
    ids = {r["spellid_%d" % n] for r in rows for n in range(1, 6) if r["spellid_%d" % n]}
    spells = {}
    for ch in chunks(ids):
        for s in qdb.query(conn, "SELECT * FROM spell_template WHERE Id IN (%s)" % in_list(ch)):
            spells[s["Id"]] = s
    return spells


# quest_template.Type in this DB: 1 elite, 41 PvP, 62 raid, 81 dungeon (0 normal, 84 escort, 82 event).
TYPE_EFFORT = {1: "group", 41: "pvp", 62: "raid", 81: "dungeon"}
EFFORT_ORDER = ["solo", "group", "dungeon", "raid", "pvp"]


def quest_efforts(conn):
    """quest id -> (effort, chain_len).

    Effort is how the quest has to be done: solo, group (elite quest or an elite/boss
    objective mob, or 2+ suggested players), dungeon, raid or pvp. A quest inherits the
    hardest effort in its prerequisite chain (PrevQuestId either sign, and whoever offers
    it through NextQuestInChain), because you have to do those first.
    """
    rows = qdb.query(conn, "SELECT entry, Type, SuggestedPlayers, PrevQuestId, NextQuestInChain, "
                           "ReqCreatureOrGOId1, ReqCreatureOrGOId2, ReqCreatureOrGOId3, ReqCreatureOrGOId4 "
                           "FROM quest_template")
    mobs = {r["entry"]: [r["ReqCreatureOrGOId%d" % n] for n in range(1, 5) if r["ReqCreatureOrGOId%d" % n] > 0]
            for r in rows}
    ranks = {}
    ids = sorted({m for v in mobs.values() for m in v})
    for ch in chunks(ids):
        for r in qdb.query(conn, "SELECT Entry, Rank FROM creature_template WHERE Entry IN (%s)" % in_list(ch)):
            ranks[r["Entry"]] = r["Rank"]
    own, parents = {}, defaultdict(set)
    for r in rows:
        e = TYPE_EFFORT.get(r["Type"])
        if e is None:
            elite = any(1 <= ranks.get(m, 0) <= 3 for m in mobs[r["entry"]])
            e = "group" if elite or r["SuggestedPlayers"] >= 2 else "solo"
        own[r["entry"]] = e
        if r["PrevQuestId"]:
            parents[r["entry"]].add(abs(r["PrevQuestId"]))
        if r["NextQuestInChain"]:
            parents[r["NextQuestInChain"]].add(r["entry"])
    memo = {}

    def walk(q, seen=()):
        if q in memo:
            return memo[q]
        if q not in own or q in seen:
            return ("solo", 0)
        effort, depth = own[q], 1
        for p in parents.get(q, ()):
            pe, pd = walk(p, seen + (q,))
            if EFFORT_ORDER.index(pe) > EFFORT_ORDER.index(effort):
                effort = pe
            depth = max(depth, pd + 1)
        memo[q] = (effort, min(depth, 12))
        return memo[q]

    return {q: walk(q) for q in own}


def quest_sources(conn, item_ids, efforts):
    """item id -> [quest reward sources], both 'choose one' and guaranteed."""
    cols = (["RewChoiceItemId%d" % i for i in range(1, 7)], ["RewItemId%d" % i for i in range(1, 5)])
    sel = ["entry", "Title", "MinLevel", "QuestLevel", "RequiredRaces", "RequiredClasses", "ZoneOrSort"]
    sel += cols[0] + cols[1]
    rows = qdb.query(conn, "SELECT " + ", ".join(sel) + " FROM quest_template")
    out = defaultdict(list)
    for q in rows:
        for kind, group in (("choice", cols[0]), ("reward", cols[1])):
            for c in group:
                iid = q[c]
                if iid in item_ids:
                    out[iid].append({
                        "quest": q["entry"], "title": q["Title"], "kind": kind,
                        "min_level": q["MinLevel"], "quest_level": q["QuestLevel"],
                        "race_mask": q["RequiredRaces"], "class_mask": q["RequiredClasses"],
                        "zone": q["ZoneOrSort"],
                        "effort": efforts[q["entry"]][0], "chain": efforts[q["entry"]][1],
                    })
    return out


def why_unusable(r):
    """Short reason a rogue cannot use an item that the item export left out."""
    cls, sub, inv = r["class"], r["subclass"], r["InventoryType"]
    if r["AllowableClass"] > 0 and not r["AllowableClass"] & 8:
        return "other class only"
    if cls == 4:
        return {3: "mail", 4: "plate", 6: "shield", 7: "relic"}.get(sub, "armor a rogue cannot wear")
    if cls == 2:
        if inv == 17 or sub in (1, 5, 6, 8, 10):
            return "two-handed"
        return "weapon type a rogue cannot use"
    return {0: "consumable", 1: "bag", 6: "ammo", 7: "trade good", 12: "quest item"}.get(cls, "not equipment")


def quest_choices(conn, item_ids, max_level, efforts):
    """Quests that offer a choice of reward, and the items those choices name.

    Returns (quests, others): `quests` lists every choice (rogue-usable or not,
    so the advisor can say why one was skipped); `others` describes the choice
    items missing from the item export.
    """
    cid = ["RewChoiceItemId%d" % i for i in range(1, 7)]
    cnt = ["RewChoiceItemCount%d" % i for i in range(1, 7)]
    sel = ["entry", "Title", "MinLevel", "QuestLevel", "RequiredRaces", "RequiredClasses", "ZoneOrSort"] + cid + cnt
    rows = qdb.query(conn, "SELECT " + ", ".join(sel) + " FROM quest_template WHERE RewChoiceItemId2 <> 0 "
                           "AND MinLevel <= %d" % max_level)
    quests, wanted = [], set()
    for q in rows:
        choices = [{"item": q[c], "count": max(q[n], 1)} for c, n in zip(cid, cnt) if q[c]]
        wanted.update(c["item"] for c in choices)
        quests.append({"quest": q["entry"], "title": q["Title"], "min_level": q["MinLevel"],
                       "quest_level": q["QuestLevel"], "race_mask": q["RequiredRaces"],
                       "class_mask": q["RequiredClasses"], "zone": q["ZoneOrSort"],
                       "effort": efforts[q["entry"]][0], "chain": efforts[q["entry"]][1], "choices": choices})
    others = {}
    for ch in chunks(wanted - set(item_ids)):
        for r in qdb.query(conn, "SELECT entry, name, class, subclass, InventoryType, AllowableClass, SellPrice "
                                 "FROM item_template WHERE entry IN (%s)" % in_list(ch)):
            others[r["entry"]] = {"name": r["name"], "sell_price": r["SellPrice"], "why": why_unusable(r)}
    return quests, others


def group_chances(rows):
    """{(entry, groupid): (sum_of_explicit, count_of_zero_rows)} for loot rows."""
    acc = defaultdict(lambda: [0.0, 0])
    for r in rows:
        if r["groupid"] > 0:
            key = (r["entry"], r["groupid"])
            c = abs(r["ChanceOrQuestChance"])
            if c > 0:
                acc[key][0] += c
            else:
                acc[key][1] += 1
    return acc


def row_chance(r, groups):
    """Per-roll drop probability (0-1) of one loot row."""
    c = abs(r["ChanceOrQuestChance"])
    if r["groupid"] > 0 and c == 0:
        total, zeros = groups[(r["entry"], r["groupid"])]
        return max(100.0 - total, 0.0) / max(zeros, 1) / 100.0
    return c / 100.0


def spawn_maps(conn, creature_ids):
    """creature entry -> set of map ids it is spawned on.

    Spawns live in two places: creature.id, and creature_spawn_entry for
    spawns that can be one of several entries (creature.id is 0/NULL there).
    """
    maps = defaultdict(set)
    for ch in chunks(creature_ids):
        for r in qdb.query(conn, "SELECT id, map FROM creature WHERE id IN (%s) GROUP BY id, map" % in_list(ch)):
            maps[r["id"]].add(r["map"])
        for r in qdb.query(conn, "SELECT e.entry AS id, c.map FROM creature_spawn_entry e "
                                 "JOIN creature c ON c.guid = e.guid WHERE e.entry IN (%s) "
                                 "GROUP BY e.entry, c.map" % in_list(ch)):
            maps[r["id"]].add(r["map"])
    return maps


def drop_sources(conn, item_ids):
    loot = qdb.query(conn, "SELECT entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, comments "
                           "FROM creature_loot_template")
    refs = qdb.query(conn, "SELECT entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, comments "
                           "FROM reference_loot_template")
    lgroups, rgroups = group_chances(loot), group_chances(refs)

    def is_world(r):
        return "world drop" in (r["comments"] or "").lower()

    # (loot table entry) -> [(item, chance, approx, world_drop)]
    per_loot = defaultdict(list)
    for r in loot:
        if r["mincountOrRef"] >= 0 and r["item"] in item_ids:
            per_loot[r["entry"]].append((r["item"], row_chance(r, lgroups), False, False))
    direct_ref = defaultdict(list)         # ref entry -> [(item, per-roll chance)]
    nested_ref = defaultdict(list)         # ref entry -> [(child ref entry, per-roll chance, rolls)]
    for r in refs:
        if r["mincountOrRef"] < 0:
            nested_ref[r["entry"]].append((-r["mincountOrRef"], row_chance(r, rgroups), max(r["maxcount"], 1)))
        elif r["item"] in item_ids:
            direct_ref[r["entry"]].append((r["item"], row_chance(r, rgroups)))
    memo = {}

    def ref_items_of(entry, seen=()):
        """Wanted items reachable from a reference table, following nested references."""
        if entry in memo:
            return memo[entry]
        if entry in seen:
            return []
        out = list(direct_ref.get(entry, []))
        for child, p, rolls in nested_ref.get(entry, []):
            for item, q in ref_items_of(child, seen + (entry,)):
                out.append((item, p * (1 - (1 - q) ** rolls)))
        memo[entry] = out
        return out

    for r in loot:
        if r["mincountOrRef"] < 0:
            hits = ref_items_of(-r["mincountOrRef"])
            if hits:
                roll = row_chance(r, lgroups)
                rolls = max(r["maxcount"], 1)
                world = is_world(r)
                for item, p in hits:
                    per_loot[r["entry"]].append((item, roll * (1 - (1 - p) ** rolls), True, world))

    loot_ids = list(per_loot)
    creatures = defaultdict(list)          # loot entry -> creature rows
    for ch in chunks(loot_ids):
        for c in qdb.query(conn, "SELECT entry, Name, MinLevel, MaxLevel, Rank, LootId "
                                 "FROM creature_template WHERE LootId IN (%s)" % in_list(ch)):
            creatures[c["LootId"]].append(c)
    cids = {c["entry"] for cs in creatures.values() for c in cs}
    maps = spawn_maps(conn, cids)

    out = defaultdict(list)
    world_out = defaultdict(list)
    unspawned = defaultdict(list)  # kept only if an item has no spawned source
    for lid, entries in per_loot.items():
        for c in creatures.get(lid, []):
            cmaps = sorted(maps.get(c["entry"], []))
            place = [INSTANCE_MAPS.get(m, "map %d" % m) for m in cmaps if m not in OPEN_WORLD_MAPS]
            for item, chance, approx, world in entries:
                rec = {
                    "creature": c["entry"], "name": c["Name"],
                    "level": [c["MinLevel"], c["MaxLevel"]], "rank": c["Rank"],
                    "chance": round(chance, 6), "approx": approx,
                    "instance": place or None,
                    "open_world": any(m in OPEN_WORLD_MAPS for m in cmaps),
                }
                if not cmaps:
                    # Script-summoned bosses (Gahz'rilla, Rend, ...) and dead templates
                    # have no spawn rows. Location unknown; the calculator treats these
                    # as dungeon-tier.
                    if not world:
                        rec["unspawned"] = True
                        rec["open_world"] = False
                        unspawned[item].append(rec)
                    continue
                (world_out if world else out)[item].append(rec)
    for item, recs in unspawned.items():
        if item not in out and item not in world_out:
            out[item].extend(recs)
    # World-drop tables put an item on every mob in a level band; one line says that.
    for item, recs in world_out.items():
        out[item].append({
            "creature": None, "name": "any mob (world drop)", "world_drop": True,
            "level": [min(r["level"][0] for r in recs), max(r["level"][1] for r in recs)],
            "rank": 0, "chance": max(r["chance"] for r in recs), "approx": True,
            "instance": None, "open_world": True,
        })
    for item in out:
        out[item].sort(key=lambda d: -d["chance"])
    return out


def vendor_sources(conn, item_ids):
    direct = qdb.query(conn, "SELECT entry, item, maxcount, condition_id FROM npc_vendor WHERE item IN (%s)" % in_list(item_ids))
    tmpl = qdb.query(conn, "SELECT entry, item, maxcount, condition_id FROM npc_vendor_template WHERE item IN (%s)" % in_list(item_ids))
    # A vendor row with a condition is not freely buyable (reputation, quest, ...): keep its text.
    cids = {r["condition_id"] for r in list(direct) + list(tmpl) if r["condition_id"]}
    conditions = {}
    if cids:
        for r in qdb.query(conn, "SELECT condition_entry, comments FROM conditions WHERE condition_entry IN (%s)" % in_list(cids)):
            conditions[r["condition_entry"]] = r["comments"]

    def req(r):
        return (conditions.get(r["condition_id"]) or "condition %d" % r["condition_id"]) if r["condition_id"] else None

    by_creature = defaultdict(list)        # creature id -> [(item, maxcount, requires)]
    for r in direct:
        by_creature[r["entry"]].append((r["item"], r["maxcount"], req(r)))
    tids = defaultdict(list)
    for r in tmpl:
        tids[r["entry"]].append((r["item"], r["maxcount"], req(r)))
    if tids:
        for c in qdb.query(conn, "SELECT entry, VendorTemplateId FROM creature_template "
                                 "WHERE VendorTemplateId IN (%s)" % in_list(tids)):
            by_creature[c["entry"]].extend(tids[c["VendorTemplateId"]])
    if not by_creature:
        return {}
    info = {}
    for ch in chunks(by_creature):
        for c in qdb.query(conn, "SELECT entry, Name, MinLevel FROM creature_template WHERE entry IN (%s)" % in_list(ch)):
            info[c["entry"]] = c
    maps = spawn_maps(conn, by_creature)
    out = defaultdict(list)
    for cid, items in by_creature.items():
        if cid not in info or cid not in maps:
            continue
        for item, maxcount, requires in items:
            v = {"creature": cid, "name": info[cid]["Name"],
                 "limited_stock": bool(maxcount), "maps": sorted(maps[cid])}
            if requires:
                v["requires"] = requires
            out[item].append(v)
    return out


SPELL_ATTR_TRADESPELL = 0x20
EFFECT_CREATE_ITEM = 24


def craft_sources(conn, item_ids):
    """item id -> [profession recipes that create it].

    A recipe is a create-item spell flagged as a trade spell; that leaves out
    proc/summon/quest-script spells that happen to name an item.
    """
    out = defaultdict(list)
    for n in (1, 2, 3):
        rows = qdb.query(
            conn, "SELECT Id, SpellName, Reagent1, Reagent2, Reagent3, Reagent4, EffectItemType%d AS item "
                  "FROM spell_template WHERE Effect%d = %d AND (Attributes & %d) <> 0 "
                  "AND EffectItemType%d IN (%s)" % (n, n, EFFECT_CREATE_ITEM, SPELL_ATTR_TRADESPELL, n, in_list(item_ids)))
        for r in rows:
            if r["SpellName"].startswith("zz") or "DND" in r["SpellName"]:
                continue
            out[r["item"]].append({"spell": r["Id"], "name": r["SpellName"],
                                   "reagents": [r["Reagent%d" % i] for i in (1, 2, 3, 4) if r["Reagent%d" % i]]})
    return out


def chest_sources(conn, item_ids):
    """item id -> [world chests (gameobject type 3) that hold it]."""
    loot = defaultdict(set)
    for ch in chunks(item_ids):
        for r in qdb.query(conn, "SELECT entry, item FROM gameobject_loot_template WHERE item IN (%s)" % in_list(ch)):
            loot[r["entry"]].add(r["item"])
    if not loot:
        return {}
    objs = defaultdict(list)                # loot id -> [(gameobject entry, name)]
    for ch in chunks(loot):
        for o in qdb.query(conn, "SELECT entry, name, data1 FROM gameobject_template WHERE type = 3 "
                                 "AND data1 IN (%s)" % in_list(ch)):
            objs[o["data1"]].append((o["entry"], o["name"]))
    gmaps = defaultdict(set)
    oids = [e for os_ in objs.values() for e, _ in os_]
    for ch in chunks(oids):
        for r in qdb.query(conn, "SELECT id, map FROM gameobject WHERE id IN (%s) GROUP BY id, map" % in_list(ch)):
            gmaps[r["id"]].add(r["map"])
    out = defaultdict(list)
    for lid, items in loot.items():
        for oid, name in objs.get(lid, []):
            ms = sorted(gmaps.get(oid, []))
            if not ms:
                continue
            place = [INSTANCE_MAPS.get(m, "map %d" % m) for m in ms if m not in OPEN_WORLD_MAPS]
            for item in items:
                out[item].append({"object": oid, "name": name, "instance": place or None,
                                  "open_world": any(m in OPEN_WORLD_MAPS for m in ms)})
    return out


# Rogue special attacks the calculator models. Ranks come from the DB so the
# per-level flat bonuses are never typed into the repo.
ABILITIES = ("Sinister Strike", "Backstab", "Ambush", "Hemorrhage", "Eviscerate")
EFFECT_NORMALIZED_WEAPON = 121
EFFECT_WEAPON_PERCENT = 31
EFFECT_WEAPON_NOSCHOOL = 17


def load_abilities(conn):
    """{ability: [rank rows sorted by level]} for the modelled specials."""
    out = {}
    for name in ABILITIES:
        rows = qdb.query(
            conn, "SELECT * FROM spell_template WHERE SpellName = %s AND SpellFamilyName = 8 "
                  "AND Rank1 LIKE 'Rank %%' AND Effect1 IN (2, 17, 31, 58, 121) ORDER BY SpellLevel, Id", (name,))
        ranks = []
        for r in rows:
            rec = {"spell": r["Id"], "rank": int(r["Rank1"].split()[1]), "level": r["SpellLevel"],
                   "energy": r["ManaCost"]}
            if name == "Eviscerate":
                bp, sides = r["EffectBasePoints1"], max(r["EffectDieSides1"], 1)
                rec["base_avg"] = (bp + 1 + bp + sides) / 2.0
                rec["per_cp"] = r["EffectPointsPerComboPoint1"]
            else:
                rec["flat"] = r["EffectBasePoints1"] + 1 if r["Effect1"] == EFFECT_NORMALIZED_WEAPON else 0
                # A second weapon-percent effect scales the whole hit (Backstab 150%, Ambush 250%).
                rec["weapon_pct"] = (r["EffectBasePoints2"] + 1) / 100.0 if r["Effect2"] == EFFECT_WEAPON_PERCENT else 1.0
                rec["normalized"] = r["Effect1"] == EFFECT_NORMALIZED_WEAPON
            ranks.append(rec)
        out[name] = ranks
    return out


def load_world(conn, max_level):
    """Per-level aggregates the ruleset needs but must not hard-code (GPL rule).

    base_str/base_agi: unbuffed rogue attributes, mean over the races the DB lists.
    mob_armor: median Armor of normal (Rank 0) creatures with armor, by MinLevel.
    Each is a list of [level, value] rows; sparse levels (< 10 mobs) are omitted
    and the consumer interpolates.
    """
    stats = defaultdict(lambda: [[], []])
    for r in qdb.query(conn, "SELECT level, `str`, agi FROM player_levelstats WHERE class = 4 AND level <= %d" % max_level):
        stats[r["level"]][0].append(r["str"])
        stats[r["level"]][1].append(r["agi"])
    armor = defaultdict(list)
    for r in qdb.query(conn, "SELECT MinLevel AS lvl, Armor FROM creature_template "
                             "WHERE Rank = 0 AND Armor > 0 AND MinLevel BETWEEN 1 AND %d" % max_level):
        armor[r["lvl"]].append(r["Armor"])

    def median(v):
        v = sorted(v)
        n = len(v)
        return float(v[n // 2]) if n % 2 else (v[n // 2 - 1] + v[n // 2]) / 2.0

    return {
        "base_str": [[l, round(sum(v[0]) / len(v[0]), 2)] for l, v in sorted(stats.items())],
        "base_agi": [[l, round(sum(v[1]) / len(v[1]), 2)] for l, v in sorted(stats.items())],
        "mob_armor": [[l, median(v)] for l, v in sorted(armor.items()) if len(v) >= 10],
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--out", default=DEFAULT_OUT)
    ap.add_argument("--max-level", type=int, default=60)
    args = ap.parse_args()

    conn = qdb.connect()
    t0 = time.time()
    rows = load_items(conn, args.max_level)
    spells = load_spells(conn, rows)
    unmodelled = []
    items = [build_item(r, spells, unmodelled) for r in rows]
    ids = {i["id"] for i in items}

    efforts = quest_efforts(conn)
    quests = quest_sources(conn, ids, efforts)
    drops = drop_sources(conn, ids)
    vendors = vendor_sources(conn, ids)
    crafts = craft_sources(conn, ids)
    chests = chest_sources(conn, ids)
    for it in items:
        src = {}
        if it["id"] in quests:
            src["quest"] = quests[it["id"]]
        if it["id"] in drops:
            src["drop"] = drops[it["id"]][:8]
        if it["id"] in vendors:
            src["vendor"] = vendors[it["id"]][:6]
        if it["id"] in crafts:
            src["craft"] = crafts[it["id"]][:3]
        if it["id"] in chests:
            src["chest"] = chests[it["id"]][:4]
        it["sources"] = src
        # The DB often leaves RequiredLevel at 0 and gates a quest reward on the
        # quest's MinLevel instead. Use that when the item is quest-only.
        gate = it["req_level"]
        if gate == 0 and "quest" in src and not ({"drop", "vendor", "craft", "chest"} & set(src)):
            gate = min(q["min_level"] for q in src["quest"])
        it["gate_level"] = gate

    meta = {
        "source": "cmangos classic-db (patch 1.12.1)",
        "ruleset_hint": "era-1.12",
        "db": os.environ.get("QDB_DB", "see ~/.config/tuff/qdb.env"),
        "max_level": args.max_level,
        "exported_at": time.strftime("%Y-%m-%d %H:%M:%S"),
        "note": "DB-derived scratch data. Do not commit (GPL, see tools/qdb.py).",
    }
    reward_quests, reward_others = quest_choices(conn, ids, args.max_level, efforts)
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump({"meta": meta, "items": items, "abilities": load_abilities(conn),
                   "world": load_world(conn, args.max_level),
                   "quest_choices": reward_quests, "choice_others": reward_others},
                  f, indent=None, separators=(",", ":"))
    print("quests with a reward choice: %d (%d choice items are not rogue-usable)" % (
        len(reward_quests), len(reward_others)))

    weapons = [i for i in items if "weapon" in i]
    by_skill = defaultdict(int)
    for w in weapons:
        by_skill[w["weapon"]["skill"]] += 1
    no_source = [w for w in weapons if not w["sources"]]
    print("exported %d items (%d weapons) in %.1fs -> %s" % (
        len(items), len(weapons), time.time() - t0, args.out))
    print("weapons by skill:", dict(sorted(by_skill.items())))
    print("items with equip bonuses: %d, with procs: %d" % (
        sum(1 for i in items if "equip" in i), sum(1 for i in items if "procs" in i)))
    print("weapons with no quest/drop/vendor/craft/chest source in DB: %d (test items, PvP, events, ...)" % len(no_source))
    if unmodelled:
        from collections import Counter
        print("unmodelled equip effects (%d, top 15):" % len(unmodelled))
        for msg, n in Counter(unmodelled).most_common(15):
            print("  %3d  %s" % (n, msg))


if __name__ == "__main__":
    main()
