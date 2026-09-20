//! Loadout search: for one (level, build), evaluate every legal main-hand x
//! off-hand pairing and keep the best ones.
//!
//! The candidate filter is the only place that decides "can this rogue use and
//! obtain this weapon"; the model itself just scores whatever it is handed.

use crate::data::Item;
use crate::model::{Extra, Prepared};
use crate::rules::{Build, Rules};
use rayon::prelude::*;
use std::collections::HashMap;

/// Rogue's bit in an item's `class_mask` (class id 4 -> 1 << 3).
const ROGUE_CLASS_BIT: i64 = 1 << 3;

/// How hard an item is to get, easiest first. Derived from the item's sources
/// only; the DB has no open-world/dungeon flag on quests, so quest rewards are
/// a single tier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, clap::ValueEnum)]
pub enum Tier {
    Vendor,
    Quest,
    /// Needs a profession and its materials; deterministic once you have them.
    Crafted,
    OpenDrop,
    DungeonDrop,
    WorldDrop,
    /// No known source (PvP, event, unexported); excluded by every `--max-tier` below `None`.
    None,
}

pub fn tier_of(item: &Item) -> Tier {
    let s = &item.sources;
    let mut best = Tier::None;
    // A vendor entry with a condition (typically a reputation rank) is not a normal purchase.
    for v in s.vendor.iter().filter(|v| v.requires.is_none()) {
        best = best.min(if v.limited_stock { Tier::Quest } else { Tier::Vendor });
    }
    if !s.quest.is_empty() {
        best = best.min(Tier::Quest);
    }
    for d in &s.drop {
        let t = if d.world_drop == Some(true) {
            Tier::WorldDrop
        } else if d.unspawned == Some(true) {
            // No spawn rows: a script-summoned boss, almost always an instance encounter.
            Tier::DungeonDrop
        } else if d.open_world.unwrap_or(d.instance.is_none()) {
            Tier::OpenDrop
        } else {
            Tier::DungeonDrop
        };
        best = best.min(t);
    }
    if !s.craft.is_empty() {
        best = best.min(Tier::Crafted);
    }
    for c in &s.chest {
        best = best.min(if c.open_world.unwrap_or(c.instance.is_none()) { Tier::OpenDrop } else { Tier::DungeonDrop });
    }
    best
}

/// Race-mask of a faction, for `Filter::faction`.
pub fn faction_mask(name: &str) -> Option<i64> {
    match name {
        "horde" => Some(2 | 16 | 32 | 128),
        "alliance" => Some(1 | 4 | 8 | 64),
        _ => None,
    }
}

/// False when the item can only come from quests and none of them is open to `mask`.
/// Vendor and drop sources carry no faction data, so those items always pass.
fn faction_ok(i: &Item, mask: i64) -> bool {
    let s = &i.sources;
    let quest_only = !s.quest.is_empty() && s.vendor.is_empty() && s.drop.is_empty() && s.craft.is_empty() && s.chest.is_empty();
    !quest_only || s.quest.iter().any(|q| q.race_mask == 0 || q.race_mask & mask != 0)
}

/// Race name (as used in `racial_skill`) to its bit in an item's `race_mask`.
pub fn race_bit(race: &str) -> Option<i64> {
    Some(match race {
        "human" => 1,
        "orc" => 2,
        "dwarf" => 4,
        "nightelf" => 8,
        "undead" => 16,
        "tauren" => 32,
        "gnome" => 64,
        "troll" => 128,
        _ => return None,
    })
}

#[derive(Debug, Clone)]
pub struct Filter {
    pub race: Option<String>,
    pub max_tier: Tier,
    /// Keep PvP-rank and profession-skill-gated items (off by default).
    pub include_gated: bool,
    /// Admit this item regardless of `max_tier` (used to ask what one extra weapon is worth).
    pub also: Option<u32>,
    /// Remove this item from the pool.
    pub exclude: Option<u32>,
    /// Race-mask of a faction (`faction_mask`); drops items whose only source is a quest that faction cannot take.
    pub faction: Option<i64>,
}

impl Default for Filter {
    fn default() -> Self {
        Filter { race: None, max_tier: Tier::WorldDrop, include_gated: false, also: None, exclude: None, faction: None }
    }
}

/// Weapons a (level, build) may put in a hand, split by slot.
pub struct Candidates<'a> {
    pub mh: Vec<&'a Item>,
    pub oh: Vec<&'a Item>,
}

pub fn candidates<'a>(items: &'a [Item], rules: &Rules, build: &Build, level: u32, f: &Filter) -> Candidates<'a> {
    let race_bit = f.race.as_deref().and_then(race_bit);
    let ok = |i: &&Item| -> bool {
        let Some(w) = i.weapon.as_ref() else { return false };
        rules.usable_weapon_types.contains(&w.skill)
            && build.weapon_types.contains(&w.skill)
            && i.gate_level <= level
            && (i.class_mask == 0 || i.class_mask & ROGUE_CLASS_BIT != 0)
            && race_bit.map_or(true, |b| i.race_mask == 0 || i.race_mask & b != 0)
            && (f.include_gated || (i.honor_rank.is_none() && i.req_skill.is_none()))
            && (tier_of(i) <= f.max_tier || Some(i.id) == f.also)
            && Some(i.id) != f.exclude
            && f.faction.map_or(true, |m| faction_ok(i, m))
    };
    let pool: Vec<&Item> = items.iter().filter(ok).collect();
    Candidates {
        mh: pool.iter().copied().filter(|i| matches!(i.slot.as_str(), "one_hand" | "main_hand")).collect(),
        oh: pool.iter().copied().filter(|i| matches!(i.slot.as_str(), "one_hand" | "off_hand")).collect(),
    }
}

#[derive(Debug, Clone)]
pub struct Loadout<'a> {
    pub mh: &'a Item,
    pub oh: Option<&'a Item>,
    pub dps: f64,
}

pub struct SearchResult<'a> {
    pub level: u32,
    pub build: &'a Build,
    /// Best loadouts, highest DPS first.
    pub top: Vec<Loadout<'a>>,
    /// Best DPS reachable with each weapon in either hand, keyed by item id.
    pub item_best: HashMap<u32, f64>,
    pub evaluated: usize,
}

impl<'a> SearchResult<'a> {
    pub fn best(&self) -> Option<&Loadout<'a>> {
        self.top.first()
    }
}

/// Evaluate every MH x OH pairing (or every MH alone below the dual-wield level).
/// Same-id pairs are skipped because item skill bonuses are summed over both hands.
pub fn search<'a>(
    rules: &'a Rules,
    abilities: &crate::model::AbilityTable,
    build: &'a Build,
    items: &'a [Item],
    level: u32,
    race: Option<&'a str>,
    filter: &Filter,
    keep: usize,
) -> SearchResult<'a> {
    let prep = Prepared::new(rules, abilities, build, level, race, None);
    let c = candidates(items, rules, build, level, filter);
    let none = Extra::default();
    let dual = level >= rules.dual_wield_level;

    let mut all: Vec<Loadout<'a>> = c
        .mh
        .par_iter()
        .flat_map_iter(|&mh| {
            let prep = &prep;
            let oh_list: Vec<Option<&Item>> = if dual {
                c.oh.iter().filter(|o| o.id != mh.id).map(|&o| Some(o)).collect()
            } else {
                vec![None]
            };
            oh_list.into_iter().map(move |oh| Loadout { mh, oh, dps: prep.evaluate(mh, oh, &none).dps })
        })
        .collect();
    let evaluated = all.len();

    let mut item_best: HashMap<u32, f64> = HashMap::new();
    for l in &all {
        for id in std::iter::once(l.mh.id).chain(l.oh.map(|o| o.id)) {
            let e = item_best.entry(id).or_insert(f64::MIN);
            *e = e.max(l.dps);
        }
    }

    all.sort_by(|a, b| b.dps.total_cmp(&a.dps).then(a.mh.id.cmp(&b.mh.id)));
    all.truncate(keep);
    SearchResult { level, build, top: all, item_best, evaluated }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::{load_items, Sources, VendorSrc};

    fn bare(id: u32, slot: &str, skill: &str) -> Item {
        serde_json::from_value(serde_json::json!({
            "id": id, "name": format!("i{id}"), "slot": slot, "gate_level": 1,
            "weapon": { "skill": skill, "min": 5.0, "max": 9.0, "speed_ms": 2000 }
        }))
        .unwrap()
    }

    #[test]
    fn tiers_order_and_derive_from_sources() {
        let mut i = bare(1, "one_hand", "sword");
        assert_eq!(tier_of(&i), Tier::None);
        i.sources = Sources { vendor: vec![VendorSrc { name: "v".into(), limited_stock: false, requires: None }], ..Default::default() };
        assert_eq!(tier_of(&i), Tier::Vendor);
        assert!(Tier::Vendor < Tier::Quest && Tier::Quest < Tier::Crafted && Tier::Crafted < Tier::OpenDrop && Tier::DungeonDrop < Tier::WorldDrop);
    }

    #[test]
    fn candidates_respect_slot_type_and_build() {
        let rules = crate::rules::test_rules();
        let builds = crate::rules::load_builds("builds").unwrap();
        let items = vec![
            bare(1, "one_hand", "sword"),
            bare(2, "main_hand", "sword"),
            bare(3, "off_hand", "dagger"),
            bare(4, "one_hand", "axe"), // not usable in Era
            bare(5, "ranged", "bow"),
        ];
        let f = Filter { max_tier: Tier::None, ..Default::default() };
        let c = candidates(&items, &rules, &builds[0], 30, &f);
        let ids = |v: &Vec<&Item>| v.iter().map(|i| i.id).collect::<Vec<_>>();
        assert_eq!(ids(&c.mh), vec![1, 2]);
        assert_eq!(ids(&c.oh), vec![1, 3]);
    }

    #[test]
    fn search_finds_a_loadout_and_skips_same_id_pairs() {
        let rules = crate::rules::test_rules();
        let builds = crate::rules::load_builds("builds").unwrap();
        let f = load_items("../.cache/items.json").unwrap();
        let filt = Filter { max_tier: Tier::None, ..Default::default() };
        let r = search(&rules, &f.abilities, &builds[0], &f.items, 40, None, &filt, 10);
        assert!(r.evaluated > 1000);
        assert!(r.top.windows(2).all(|w| w[0].dps >= w[1].dps));
        assert!(r.top.iter().all(|l| l.oh.map_or(true, |o| o.id != l.mh.id)));
        // Below dual-wield level there is no off-hand.
        let low = search(&rules, &f.abilities, &builds[0], &f.items, 5, None, &filt, 3);
        assert!(low.top.iter().all(|l| l.oh.is_none()));
    }
}
