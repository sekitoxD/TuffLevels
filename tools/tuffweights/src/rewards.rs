//! Quest-reward advisor: for every quest that offers a choice of reward, which choice
//! does a levelling rogue gain the most from?
//!
//! Everything is scored as percent DPS gained over what the player would otherwise wear,
//! so a weapon and a ring in the same choice list are comparable:
//!
//! - **Weapons**: the best loadout (per build) with the reward added to the pool, against
//!   the best loadout built only from gear you could plan on that is easier to get than the quest
//!   (`Tier::baseline_cap`), with this quest's other rewards taken out.
//! - **Armor, jewelry, cloaks**: the item's stats valued by the model's finite-difference
//!   stat weights around that baseline loadout, minus the best item in the same slot that is
//!   in that same baseline pool (the second best for rings and trinkets).
//!
//! Each pick carries the same verdict `worth.md` uses (solo quest, group quest, dungeon...),
//! taken from the quest's effort. The DPS model does not know about survival: armor value and
//! Stamina are shown as a tie-breaker column, never scored. Like `worth.md`, the baseline is
//! thin at low levels, so early uplifts are overstated. The output is a candidate list for a
//! human to confirm.

use crate::data::{Item, ItemsFile, QuestChoice};
use crate::armor::{slot_baseline, StatValue};
use crate::model::Prepared;
use crate::rules::{Build, Rules};
use crate::search::{race_bit, search, Filter, Tier, ROGUE_CLASS_BIT};
use crate::verdict::{classify, Verdict, VerdictOptions, POINT_WINDOW};
use std::collections::{BTreeMap, HashMap};
use std::fmt::Write as _;

pub struct RewardOptions<'a> {
    pub min_level: u32,
    pub max_level: u32,
    /// Percent DPS below which no choice counts as a real pick.
    pub min_uplift: f64,
    /// Percent DPS within which two choices are called a tie.
    pub tie: f64,
    pub race: Option<&'a str>,
    /// Race-mask of a faction (`search::faction_mask`).
    pub faction: Option<i64>,
    /// Score one build only (default: the best across all builds).
    pub build: Option<&'a str>,
    /// Thresholds behind each pick's verdict; `min_uplift` here overrides its own.
    pub verdict: VerdictOptions,
}

struct Scored<'a> {
    item: &'a Item,
    /// Level the reward scored best at (start, middle or end of the range the quest can be done in).
    at: u32,
    /// Percent DPS over what you would otherwise wear (the slot's best vendor/quest item, or the best loadout).
    uplift: f64,
    /// Percent DPS the item adds by itself, ignoring what it replaces; equals `uplift` for weapons.
    raw: f64,
    build: String,
    /// How worth doing the quest is for this item, from the quest's effort and `uplift`.
    verdict: Verdict,
}

enum Outcome<'a> {
    Scored(Scored<'a>),
    Skipped { name: String, sell: u64, why: String },
}

/// Copper as "1g 20s 5c".
pub fn money(copper: u64) -> String {
    let (g, s, c) = (copper / 10_000, copper / 100 % 100, copper % 100);
    let mut out = Vec::new();
    if g > 0 {
        out.push(format!("{g}g"));
    }
    if s > 0 {
        out.push(format!("{s}s"));
    }
    if c > 0 || out.is_empty() {
        out.push(format!("{c}c"));
    }
    out.join(" ")
}

fn stat_line(i: &Item) -> String {
    let mut v = Vec::new();
    if let Some(w) = &i.weapon {
        v.push(format!("{:.0}-{:.0} @{:.1} ({:.1} dps {})", w.min, w.max, w.speed(), w.dps(), w.skill));
    }
    if i.armor > 0.0 {
        v.push(format!("armor {:.0}", i.armor));
    }
    for (k, label) in [("str", "Str"), ("agi", "Agi"), ("sta", "Sta"), ("int", "Int"), ("spi", "Spi")] {
        if let Some(x) = i.stats.get(k).filter(|x| **x != 0.0) {
            v.push(format!("{x:+.0} {label}"));
        }
    }
    if let Some(e) = &i.equip {
        for (x, label) in [(e.ap, "AP"), (e.crit_pct, "% crit"), (e.hit_pct, "% hit")] {
            if x != 0.0 {
                v.push(format!("{x:+.0} {label}"));
            }
        }
        let mut sk: Vec<_> = e.skill.iter().collect();
        sk.sort_by(|a, b| a.0.cmp(b.0));
        v.extend(sk.into_iter().map(|(k, x)| format!("{x:+.0} {k} skill")));
    }
    v.extend(i.not_scored().into_iter().map(|n| format!("NOT SCORED: {n}")));
    v.join(", ")
}

/// Why a reward cannot be scored for this ruleset and filter, or `None` if it can.
fn blocked(i: &Item, rules: &Rules, builds: &[&Build], o: &RewardOptions) -> Option<String> {
    if i.class_mask != 0 && i.class_mask & ROGUE_CLASS_BIT == 0 {
        return Some("other class only".into());
    }
    if let Some(b) = o.race.and_then(race_bit) {
        if i.race_mask != 0 && i.race_mask & b == 0 {
            return Some("not for your race".into());
        }
    }
    if i.honor_rank.is_some() {
        return Some("needs a PvP rank".into());
    }
    if i.req_skill.is_some() {
        return Some("needs a profession skill".into());
    }
    if let Some(w) = &i.weapon {
        if matches!(i.slot.as_str(), "ranged" | "thrown") {
            return Some("ranged weapon (not modelled)".into());
        }
        if !rules.usable_weapon_types.contains(&w.skill) {
            return Some(format!("{} not usable by rogues in this ruleset", w.skill));
        }
        if !builds.iter().any(|b| b.weapon_types.contains(&w.skill)) {
            return Some(format!("no build wields {}", w.skill));
        }
    }
    if i.gate_level > o.max_level {
        return Some(format!("needs level {}", i.gate_level));
    }
    None
}

fn score_quest<'a>(
    q: &QuestChoice,
    quest_tier: Tier,
    level: u32,
    rules: &Rules,
    file: &'a ItemsFile,
    builds: &[&Build],
    by_id: &HashMap<u32, &'a Item>,
    o: &RewardOptions,
) -> Vec<Outcome<'a>> {
    let mut out: Vec<Outcome> = Vec::new();
    let mut to_score: Vec<&Item> = Vec::new();
    for c in &q.choices {
        match by_id.get(&c.item) {
            Some(&i) => match blocked(i, rules, builds, o) {
                Some(why) => out.push(Outcome::Skipped { name: i.name.clone(), sell: i.sell_price, why }),
                None => to_score.push(i),
            },
            None => {
                let (name, sell, why) = file
                    .choice_others
                    .get(&c.item)
                    .map(|x| (x.name.clone(), x.sell_price, x.why.clone()))
                    .unwrap_or((format!("item {}", c.item), 0, "not in the export".into()));
                out.push(Outcome::Skipped { name, sell, why });
            }
        }
    }
    let choice_ids: Vec<u32> = q.choices.iter().map(|c| c.item).collect();
    let mut best: HashMap<u32, (f64, f64, String, u32)> = HashMap::new();
    // A quest can be done anywhere from its minimum level to a bit past its quest level, and a reward
    // is usually most useful early in that range, so each item is scored at the start, middle and end
    // of it and keeps its best. Otherwise a dungeon reward is judged after better gear has appeared.
    let levels_of = |i: &Item| {
        let hi = level.max(i.gate_level).min(o.max_level);
        let lo = q.min_level.max(i.gate_level).max(o.min_level).min(hi);
        [lo, (lo + hi) / 2, hi]
    };
    let mut by_level: BTreeMap<u32, Vec<&Item>> = BTreeMap::new();
    for &i in &to_score {
        let mut ls = levels_of(i).to_vec();
        ls.dedup();
        for l in ls {
            by_level.entry(l).or_default().push(i);
        }
    }
    for b in builds {
        for (&at, group) in &by_level {
            let base_filter = Filter {
                race: o.race.map(String::from),
                max_tier: quest_tier.baseline_cap(),
                include_gated: false,
                also: None,
                exclude: choice_ids.clone(),
                faction: o.faction,
            };
            let r = search(rules, &file.abilities, b, &file.items, at, o.race, &base_filter, 1);
            let Some(base) = r.best() else { continue };
            let prep = Prepared::new(rules, &file.abilities, b, at, o.race, None);
            let value = StatValue::around(&prep, base.mh, base.oh);
            for &item in group {
                let (uplift, raw) = if item.weapon.is_some() {
                    let f = Filter { also: Some(item.id), exclude: choice_ids.iter().copied().filter(|&x| x != item.id).collect(), ..base_filter.clone() };
                    let with = search(rules, &file.abilities, b, &file.items, at, o.race, &f, 1).best().map_or(base.dps, |l| l.dps);
                    let u = (with / base.dps - 1.0) * 100.0;
                    (u, u)
                } else {
                    let gain = value.gain(item);
                    let net = gain - slot_baseline(&file.items, item, at, quest_tier.baseline_cap(), &choice_ids, &base_filter, &value);
                    (net / base.dps * 100.0, gain / base.dps * 100.0)
                };
                if best.get(&item.id).map_or(true, |(u, _, _, _)| uplift > *u) {
                    best.insert(item.id, (uplift, raw, b.name.clone(), at));
                }
            }
        }
    }
    for i in to_score {
        match best.remove(&i.id) {
            Some((uplift, raw, build, at)) => {
                let verdict = classify(quest_tier, POINT_WINDOW, uplift, uplift, None, &o.verdict);
                out.push(Outcome::Scored(Scored { item: i, at, uplift, raw, build, verdict }))
            }
            None => out.push(Outcome::Skipped { name: i.name.clone(), sell: i.sell_price, why: "no baseline loadout at that level".into() }),
        }
    }
    out
}

fn race_tag(mask: i64) -> &'static str {
    let horde = crate::search::faction_mask("horde").unwrap_or(0);
    let alliance = crate::search::faction_mask("alliance").unwrap_or(0);
    match mask {
        0 => "",
        m if m & !horde == 0 => "Horde",
        m if m & !alliance == 0 => "Alliance",
        _ => "race-locked",
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Kind {
    /// Beats the gear you would otherwise wear by at least `min_uplift`.
    Clear,
    /// Adds DPS by itself but not over what other quests and vendors offer for the slot.
    Marginal,
    /// Adds under `min_uplift` even into an empty slot.
    NoGain,
    /// Nothing a rogue can use and the model can score.
    NoneScorable,
}

/// The pick, its kind and a note for one quest, from its scored choices (best first) and its skipped ones.
fn verdict(scored: &[&Scored], skipped: &[(&str, u64)], o: &RewardOptions) -> (Kind, String, String) {
    let sell = || {
        skipped
            .iter()
            .max_by_key(|s| s.1)
            .filter(|s| s.1 > 0)
            .map(|s| format!("highest vendor value: {} ({})", s.0, money(s.1)))
            .unwrap_or_else(|| "nothing to pick".into())
    };
    // Survival is not scored, so the sturdiest choice (armor, then Stamina) is offered beside the DPS pick.
    let sturdy = scored.iter().max_by_key(|s| (s.item.armor as i64, s.item.stats.get("sta").copied().unwrap_or(0.0) as i64));
    let sta = |s: &Scored| s.item.stats.get("sta").copied().unwrap_or(0.0);
    let sturdy = sturdy.filter(|s| s.item.armor > 0.0 || sta(s) > 0.0);
    let sturdy_note = |t: &Scored| match sturdy {
        Some(s) if s.item.id != t.item.id => format!("; sturdiest: {} (armor {:.0}, {:+.0} Sta)", s.item.name, s.item.armor, s.item.stats.get("sta").copied().unwrap_or(0.0)),
        _ => String::new(),
    };
    let Some(top) = scored.first() else { return (Kind::NoneScorable, "none scorable".into(), sell()) };
    if top.uplift >= o.min_uplift {
        let tied: Vec<&str> = scored[1..].iter().filter(|s| top.uplift - s.uplift < o.tie).map(|s| s.item.name.as_str()).collect();
        let note = match scored.get(1) {
            _ if !tied.is_empty() => format!("tie with {}", tied.join(", ")),
            Some(next) => format!("{:+.1} pts over {}", top.uplift - next.uplift, next.item.name),
            None => "only scorable choice".into(),
        };
        return (Kind::Clear, format!("{} ({:+.1}%): {}", top.item.name, top.uplift, top.verdict.label()), note + &sturdy_note(top));
    }
    if top.raw >= o.min_uplift {
        return (
            Kind::Marginal,
            format!("{} (net {:+.1}%, {:+.1}% alone)", top.item.name, top.uplift, top.raw),
            format!("no better than easier sources give the slot; worth it only if the slot is empty{}", sturdy_note(top)),
        );
    }
    let pick = match sturdy {
        Some(s) => format!("no DPS gain; sturdiest: {} (armor {:.0}, {:+.0} Sta)", s.item.name, s.item.armor, sta(s)),
        None => "no DPS gain".into(),
    };
    (Kind::NoGain, pick, sell())
}

pub fn rewards_md(rules: &Rules, builds: &[Build], file: &ItemsFile, o: &RewardOptions) -> anyhow::Result<String> {
    let builds: Vec<&Build> = builds.iter().filter(|b| o.build.map_or(true, |n| b.name == n)).collect();
    anyhow::ensure!(!builds.is_empty(), "no build named {:?}", o.build);
    let by_id: HashMap<u32, &Item> = file.items.iter().map(|i| (i.id, i)).collect();
    let rb = o.race.and_then(race_bit);

    let mut quests: Vec<(u32, &QuestChoice)> = file
        .quest_choices
        .iter()
        .filter(|q| q.class_mask == 0 || q.class_mask & ROGUE_CLASS_BIT != 0)
        .filter(|q| rb.map_or(true, |b| q.race_mask == 0 || q.race_mask & b != 0))
        .filter(|q| o.faction.map_or(true, |m| q.race_mask == 0 || q.race_mask & m != 0))
        .filter(|q| Tier::of_quest(&q.effort).is_some())
        .map(|q| (q.quest_level.max(q.min_level).max(o.min_level), q))
        .filter(|(l, _)| *l <= o.max_level)
        .collect();
    quests.sort_by(|a, b| a.0.cmp(&b.0).then(a.1.title.cmp(&b.1.title)));

    let mut summary = String::new();
    let mut detail = String::new();
    let (mut clear, mut marginal, mut no_gain, mut none) = (0, 0, 0, 0);
    for (level, q) in &quests {
        let quest_tier = Tier::of_quest(&q.effort).unwrap_or(Tier::QuestSolo);
        let outcomes = score_quest(q, quest_tier, *level, rules, file, &builds, &by_id, o);
        let mut scored: Vec<&Scored> = outcomes.iter().filter_map(|x| if let Outcome::Scored(s) = x { Some(s) } else { None }).collect();
        // Order by uplift to a tenth of a point, then by armor value and sell price as tie-breakers.
        scored.sort_by(|a, b| {
            let k = |s: &Scored| ((s.uplift * 10.0).round() as i64, s.item.armor as i64, s.item.stats.get("sta").copied().unwrap_or(0.0) as i64, s.item.sell_price);
            k(b).cmp(&k(a))
        });
        let skipped: Vec<(&str, u64)> = outcomes.iter().filter_map(|x| if let Outcome::Skipped { name, sell, .. } = x { Some((name.as_str(), *sell)) } else { None }).collect();
        let (kind, pick, why) = verdict(&scored, &skipped, o);
        match kind {
            Kind::Clear => clear += 1,
            Kind::Marginal => marginal += 1,
            Kind::NoGain => no_gain += 1,
            Kind::NoneScorable => none += 1,
        }
        let tag = race_tag(q.race_mask);
        let _ = writeln!(summary, "| {level} | {} (#{}) | {} | {pick} | {why} |", q.title, q.quest, tag);

        let chain = if q.chain > 1 { format!(", chain of {}", q.chain) } else { String::new() };
        let _ = write!(detail, "\n### L{level} {} (#{}, zone {}{}, {} quest{chain})\n\n**{pick}**: {why}\n\n", q.title, q.quest, q.zone, if tag.is_empty() { String::new() } else { format!(", {tag}") }, q.effort);
        detail.push_str("| item | slot | scored at | uplift | best build | stats |\n|---|---|---|---|---|---|\n");
        for s in &scored {
            let _ = writeln!(detail, "| {} | {} | L{} | {:+.1}% | {} | {} |", s.item.name, s.item.slot, s.at, s.uplift, s.build, stat_line(s.item));
        }
        for out in &outcomes {
            if let Outcome::Skipped { name, sell, why } = out {
                let _ = writeln!(detail, "| {name} | | | skipped | | {why}; sells {} |", money(*sell));
            }
        }
    }

    let mut s = String::from("# Quest reward advisor\n\n");
    let _ = write!(
        s,
        "For each quest with a choice of reward, the choice that adds the most DPS for a levelling rogue. Uplift is percent DPS over the gear you could otherwise plan on that is easier to get than this quest (vendor items for a group quest's baseline plus solo quests; everything short of a dungeon for a dungeon quest; this quest's other rewards are left out): for a weapon, the best loadout with it against the best loadout without; for armor, jewelry and cloaks, the item's stats valued by the model's stat weights minus the best item already in that slot. The label after each pick is the same verdict `worth.md` uses, from the quest's effort (solo, group or dungeon, including the hardest quest earlier in its chain). The pick is the best across builds{}.\n\n\
A choice must beat that baseline by {:.1}% to count as a clear pick. Below that, the report still names the best choice: \"net\" is the gain over the baseline (negative means easier sources give the slot something better), \"alone\" is the gain if the slot is empty. With no gain even then it suggests the sturdiest choice and the vendor value; choices within {:.2} points count as a tie. Survival is not modelled: armor value and Stamina are shown but never scored, so break ties with them. \"Scored at\" is the best of the start, middle and end of the levels the quest can be done at (its minimum level to its quest level, or the item's required level if higher). The baseline is thin at low levels, so early uplifts are overstated. Candidate list for a human to confirm, not a verdict.\n\n\
{} quests scored: {} with a clear DPS pick, {} where the best choice only helps an empty slot, {} where nothing adds DPS, {} with nothing a rogue can use.\n\n\
## Picks\n\n| L | quest | side | pick | note |\n|---|---|---|---|---|\n",
        o.build.map(|b| format!(" (only {b})")).unwrap_or_default(),
        o.min_uplift,
        o.tie,
        quests.len(),
        clear,
        marginal,
        no_gain,
        none
    );
    s.push_str(&summary);
    s.push_str("\n## Detail\n");
    s.push_str(&detail);
    Ok(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn item(json: serde_json::Value) -> Item {
        serde_json::from_value(json).unwrap()
    }

    #[test]
    fn money_formats_coins() {
        assert_eq!(money(0), "0c");
        assert_eq!(money(105), "1s 5c");
        assert_eq!(money(12_0000 + 3_00 + 4), "12g 3s 4c");
    }

    #[test]
    fn verdict_reports_ties_thresholds_and_vendor_fallback() {
        let o = RewardOptions { min_level: 1, max_level: 59, min_uplift: 0.5, tie: 0.15, race: None, faction: None, build: None, verdict: VerdictOptions::default() };
        let a = item(serde_json::json!({"id": 1, "name": "A", "slot": "head"}));
        let b = item(serde_json::json!({"id": 2, "name": "B", "slot": "head"}));
        fn mk(i: &Item, u: f64) -> Scored<'_> {
            Scored { item: i, at: 10, uplift: u, raw: u, build: "x".into(), verdict: Verdict::SoloQuest }
        }
        let (sa, sb) = (mk(&a, 3.0), mk(&b, 2.9));
        let (kind, pick, note) = verdict(&[&sa, &sb], &[], &o);
        assert_eq!((kind, pick.as_str(), note.as_str()), (Kind::Clear, "A (+3.0%): Solo quest: do it", "tie with B"));
        let (sa, sb) = (mk(&a, 3.0), mk(&b, 1.0));
        assert_eq!(verdict(&[&sa, &sb], &[], &o).2, "+2.0 pts over B");
        // Beaten by gear already available, but useful in an empty slot.
        let net = Scored { uplift: -1.0, raw: 1.4, ..mk(&a, 0.0) };
        let (kind, pick, _) = verdict(&[&net], &[], &o);
        assert_eq!((kind, pick.as_str()), (Kind::Marginal, "A (net -1.0%, +1.4% alone)"));
        // No gain at all: fall back to vendor value.
        let weak = mk(&a, 0.1);
        let (kind, pick, note) = verdict(&[&weak], &[("Junk", 250), ("Better junk", 900)], &o);
        assert_eq!((kind, pick.as_str()), (Kind::NoGain, "no DPS gain")); // A has no armor or Stamina to recommend
        assert!(note.contains("Better junk (9s)"), "{note}");
        assert_eq!(verdict(&[], &[], &o).0, Kind::NoneScorable);
    }
}
