//! "Is this item worth the effort?" report, for weapons and for armor.
//!
//! The question is not an item's absolute DPS but how much it adds over what you would be
//! wearing anyway, and that depends on how you get it. Each item is judged against the best
//! gear you could plan on that is easier to get (see `Tier::baseline_cap`): a vendor belt against
//! other vendor belts, a group quest reward against vendor and solo-quest gear, a dungeon reward
//! against everything short of a dungeon (crafting and drops are never assumed). That uplift, per level, and the
//! item's acquisition method combine into a `Verdict` (see `verdict.rs`).
//!
//! Weapons are scored by re-running the loadout search with and without the item; armor,
//! jewelry and cloaks by their stats times the stat weights (`armor.rs`). Thresholds are
//! judgement calls, exposed as options. The model does not know quest-chain lengths beyond
//! what the export records, so a verdict is a candidate for a human to confirm.

use crate::armor::{slot_count, wearable, StatValue};
use crate::audit::{describe_source, norm, parse_lua, parse_markdown};
use crate::data::Item;
use crate::model::{AbilityTable, Prepared};
use crate::report::{Cell, RunOptions};
use crate::rules::{Build, Rules};
use crate::search::{best_drop_chance, search, tier_of, Filter, Tier};
use crate::verdict::{classify, Verdict, VerdictOptions};
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::fmt::Write as _;

pub struct WorthOptions {
    pub verdict: VerdictOptions,
    /// How many of each cell's best weapons to consider as subjects.
    pub top_subjects: usize,
}

impl Default for WorthOptions {
    fn default() -> Self {
        WorthOptions { verdict: VerdictOptions::default(), top_subjects: 30 }
    }
}

#[derive(Debug, Clone)]
pub struct Row {
    pub id: u32,
    pub name: String,
    pub slot: String,
    pub weapon: bool,
    pub tier: Tier,
    pub first: u32,
    pub last: u32,
    pub mean: f64,
    pub peak: f64,
    pub build: String,
    pub verdict: Verdict,
}

/// Best loadout per (build index, level, baseline cap): DPS and the item ids used.
type Bases = HashMap<(usize, u32, Tier), (f64, Vec<u32>)>;

fn build_bases(rules: &Rules, abilities: &AbilityTable, builds: &[Build], items: &[Item], o: &RunOptions, caps: &BTreeSet<Tier>) -> Bases {
    let mut bases = Bases::new();
    for &cap in caps {
        let filter = Filter { max_tier: cap, ..o.filter.clone() };
        for (bi, b) in builds.iter().enumerate() {
            for level in o.min_level..=o.max_level {
                let r = search(rules, abilities, b, items, level, o.race, &filter, 1);
                if let Some(l) = r.best() {
                    bases.insert((bi, level, cap), (l.dps, std::iter::once(l.mh.id).chain(l.oh.map(|x| x.id)).collect()));
                }
            }
        }
    }
    bases
}

/// Longest run of consecutive levels with `uplift >= min`: (first, last, mean uplift over the run).
fn best_run(by_level: &BTreeMap<u32, f64>, min: f64) -> Option<(u32, u32, f64)> {
    let mut best: Option<(u32, u32, f64)> = None;
    let mut cur: Option<(u32, u32, f64, u32)> = None; // first, last, sum, n
    let mut flush = |cur: &mut Option<(u32, u32, f64, u32)>, best: &mut Option<(u32, u32, f64)>| {
        if let Some((a, z, sum, n)) = cur.take() {
            let mean = sum / n as f64;
            let longer = best.map_or(true, |(ba, bz, bm)| (z - a, (mean * 1000.0) as i64) > (bz - ba, (bm * 1000.0) as i64));
            if longer {
                *best = Some((a, z, mean));
            }
        }
    };
    for (&l, &u) in by_level {
        if u >= min {
            cur = match cur.take() {
                Some((a, z, sum, n)) if z + 1 == l => Some((a, l, sum + u, n + 1)),
                other => {
                    let mut o = other;
                    flush(&mut o, &mut best);
                    Some((l, l, u, 1))
                }
            };
        } else {
            flush(&mut cur, &mut best);
        }
    }
    flush(&mut cur, &mut best);
    best
}

/// Weapons worth scoring: each cell's best few, plus everything on the hand-authored lists.
fn subjects<'a>(cells: &[Cell], items: &'a [Item], listed: &BTreeSet<String>, top: usize) -> Vec<&'a Item> {
    let mut ids: BTreeSet<u32> = BTreeSet::new();
    for c in cells {
        let mut v: Vec<(u32, f64)> = c.all.iter().map(|(&i, &d)| (i, d)).collect();
        v.sort_by(|a, b| b.1.total_cmp(&a.1).then(a.0.cmp(&b.0)));
        ids.extend(v.into_iter().take(top).map(|x| x.0));
    }
    items
        .iter()
        .filter(|i| i.weapon.is_some() && tier_of(i) != Tier::None)
        .filter(|i| ids.contains(&i.id) || listed.contains(&norm(&i.name)))
        .collect()
}


/// Turn per-level uplifts into a row: the longest window over `min_uplift`, its mean, the peak and the verdict.
fn make_row(item: &Item, uplift: &BTreeMap<u32, f64>, who: &BTreeMap<u32, String>, w: &WorthOptions) -> Row {
    let tier = tier_of(item);
    let peak = uplift.values().copied().fold(0.0_f64, f64::max);
    let (first, last, mean) = best_run(uplift, w.verdict.min_uplift).unwrap_or((0, 0, 0.0));
    let build = who
        .iter()
        .filter(|(l, _)| (first..=last).contains(l))
        .fold(BTreeMap::<&str, usize>::new(), |mut m, (_, b)| {
            *m.entry(b.as_str()).or_default() += 1;
            m
        })
        .into_iter()
        .max_by_key(|x| x.1)
        .map(|x| x.0.to_string())
        .unwrap_or_default();
    let run_len = if first == 0 { 0 } else { last - first + 1 };
    let verdict = classify(tier, run_len, mean, peak, best_drop_chance(item, tier), &w.verdict);
    Row { id: item.id, name: item.name.clone(), slot: item.slot.clone(), weapon: item.weapon.is_some(), tier, first, last, mean, peak, build, verdict }
}

/// Variants sharing a name (level-scaled copies): keep the one with the largest peak.
fn dedupe(rows: Vec<Row>) -> Vec<Row> {
    let mut by_name: BTreeMap<(bool, String), Row> = BTreeMap::new();
    for r in rows {
        let key = (r.weapon, r.name.clone());
        match by_name.get(&key) {
            Some(old) if old.peak >= r.peak => {}
            _ => {
                by_name.insert(key, r);
            }
        }
    }
    by_name.into_values().collect()
}

fn weapon_rows(
    rules: &Rules,
    abilities: &AbilityTable,
    builds: &[Build],
    items: &[Item],
    cells: &[Cell],
    listed: &BTreeSet<String>,
    bases: &Bases,
    o: &RunOptions,
    w: &WorthOptions,
) -> Vec<Row> {
    let full: HashMap<(&str, u32), &Cell> = cells.iter().map(|c| ((c.build.as_str(), c.level), c)).collect();
    let mut rows = Vec::new();
    for item in subjects(cells, items, listed, w.top_subjects) {
        let tier = tier_of(item);
        let cap = tier.baseline_cap();
        let in_pool = tier <= cap;
        let base_filter = Filter { max_tier: cap, ..o.filter.clone() };
        let mut uplift: BTreeMap<u32, f64> = BTreeMap::new();
        let mut who: BTreeMap<u32, (f64, String)> = BTreeMap::new();
        for level in item.gate_level.max(o.min_level)..=o.max_level {
            // Per build: best DPS with and without the item, then the player's best across builds.
            let mut with_max = f64::MIN;
            let mut without_max = f64::MIN;
            for (bi, b) in builds.iter().enumerate() {
                let Some((bdps, bids)) = bases.get(&(bi, level, cap)) else { continue };
                // The full pool's best DPS with this item bounds what it can add.
                let bound = full.get(&(b.name.as_str(), level)).and_then(|c| c.all.get(&item.id)).copied();
                let no_gain = bound.map_or(true, |d| d <= *bdps + 1e-9);
                let best_of = |f: &Filter| search(rules, abilities, b, items, level, o.race, f, 1).best().map_or(f64::MIN, |l| l.dps);
                let (with, without) = match (in_pool, no_gain) {
                    (_, true) => (*bdps, *bdps),
                    (true, false) if !bids.contains(&item.id) => (*bdps, *bdps),
                    (true, false) => (*bdps, best_of(&Filter { exclude: vec![item.id], ..base_filter.clone() })),
                    (false, false) => (best_of(&Filter { also: Some(item.id), ..base_filter.clone() }), *bdps),
                };
                if with > who.get(&level).map_or(f64::MIN, |x| x.0) {
                    who.insert(level, (with, b.name.clone()));
                }
                with_max = with_max.max(with);
                without_max = without_max.max(without);
            }
            if with_max > f64::MIN && without_max > 0.0 {
                uplift.insert(level, (with_max / without_max - 1.0) * 100.0);
            }
        }
        let who: BTreeMap<u32, String> = who.into_iter().map(|(l, (_, b))| (l, b)).collect();
        rows.push(make_row(item, &uplift, &who, w));
    }
    rows
}

/// Armor, jewelry and cloaks: stats valued around the best loadout at each (build, level), minus
/// the slot's baseline among items as easy or easier. Only items that clear the minimum uplift are kept.
fn armor_rows(rules: &Rules, abilities: &AbilityTable, builds: &[Build], items: &[Item], bases: &Bases, o: &RunOptions, w: &WorthOptions) -> Vec<Row> {
    let by_id: HashMap<u32, &Item> = items.iter().map(|i| (i.id, i)).collect();
    let pool: Vec<&Item> = items.iter().filter(|i| wearable(i, &o.filter) && tier_of(i) != Tier::None && i.gate_level <= o.max_level).collect();
    let mut uplift: HashMap<u32, BTreeMap<u32, f64>> = HashMap::new();
    let mut who: HashMap<u32, BTreeMap<u32, String>> = HashMap::new();
    for (bi, b) in builds.iter().enumerate() {
        for level in o.min_level..=o.max_level {
            let Some((_, ids)) = bases.get(&(bi, level, Tier::QuestGroup)) else { continue };
            let refs: Vec<&Item> = ids.iter().filter_map(|id| by_id.get(id).copied()).collect();
            let Some(&mh) = refs.first() else { continue };
            let prep = Prepared::new(rules, abilities, b, level, o.race, None);
            let value = StatValue::around(&prep, mh, refs.get(1).copied());
            // Per slot, every wearable item's gain, best first, with its tier for the baseline lookup.
            let mut lists: HashMap<&str, Vec<(f64, Tier, u32)>> = HashMap::new();
            for i in pool.iter().filter(|i| i.gate_level <= level) {
                lists.entry(i.slot.as_str()).or_default().push((value.gain(i), tier_of(i), i.id));
            }
            for l in lists.values_mut() {
                l.sort_by(|a, b| b.0.total_cmp(&a.0));
            }
            for i in pool.iter().filter(|i| i.gate_level <= level) {
                let cap = tier_of(i).baseline_cap();
                let n = slot_count(&i.slot);
                let base = lists[i.slot.as_str()].iter().filter(|(_, t, id)| *t <= cap && *id != i.id).nth(n - 1).map_or(0.0, |x| x.0.max(0.0));
                let gain = lists[i.slot.as_str()].iter().find(|x| x.2 == i.id).map_or(0.0, |x| x.0);
                let u = (gain - base) / value.base_dps * 100.0;
                let e = uplift.entry(i.id).or_default().entry(level).or_insert(f64::MIN);
                if u > *e {
                    *e = u;
                    who.entry(i.id).or_default().insert(level, b.name.clone());
                }
            }
        }
    }
    pool.iter()
        .filter_map(|i| {
            let up = uplift.get(&i.id)?;
            let peak = up.values().copied().fold(0.0_f64, f64::max);
            (peak >= w.verdict.min_uplift).then(|| make_row(i, up, &who[&i.id], w))
        })
        .collect()
}

pub fn compute_rows(
    rules: &Rules,
    abilities: &AbilityTable,
    builds: &[Build],
    items: &[Item],
    cells: &[Cell],
    listed: &BTreeSet<String>,
    o: &RunOptions,
    w: &WorthOptions,
) -> Vec<Row> {
    // Baselines are needed at each subject's cap, and at the group-quest cap for armor weights.
    let mut caps: BTreeSet<Tier> = subjects(cells, items, listed, w.top_subjects).iter().map(|i| tier_of(i).baseline_cap()).collect();
    caps.insert(Tier::QuestGroup);
    let bases = build_bases(rules, abilities, builds, items, o, &caps);
    let mut rows = weapon_rows(rules, abilities, builds, items, cells, listed, &bases, o, w);
    rows.extend(armor_rows(rules, abilities, builds, items, &bases, o, w));
    let mut out = dedupe(rows);
    out.sort_by(|a, b| a.verdict.cmp(&b.verdict).then(a.first.cmp(&b.first)).then(b.peak.total_cmp(&a.peak)));
    out
}

pub fn worth_md(
    rules: &Rules,
    abilities: &AbilityTable,
    builds: &[Build],
    items: &[Item],
    cells: &[Cell],
    lua: &str,
    notes: &str,
    o: &RunOptions,
    w: &WorthOptions,
) -> String {
    let mut lists: HashMap<String, BTreeSet<String>> = HashMap::new();
    for l in parse_lua(lua).into_iter().chain(parse_markdown(notes)) {
        lists.entry(norm(&l.name)).or_default().insert(l.list);
    }
    let listed: BTreeSet<String> = lists.keys().cloned().collect();
    let rows = compute_rows(rules, abilities, builds, items, cells, &listed, o, w);
    let by_id: HashMap<u32, &Item> = items.iter().map(|i| (i.id, i)).collect();
    let v = &w.verdict;

    let mut s = String::from("# Worth: which items justify the effort\n\n");
    let _ = write!(
        s,
        "Every weapon, armor piece, ring, neck and cloak a rogue can obtain is judged the same way. **Uplift** is percent DPS the item adds over the best gear you could plan on that is easier to get: a vendor item is compared with the other vendor items, a solo-quest reward with vendor and other solo-quest gear, a group-quest reward with vendor and solo-quest gear, and a dungeon reward, crafted piece or drop with everything doable without a dungeon (vendor, solo and group quests; crafting and drops are never assumed). Weapons are scored by re-running the loadout search with and without the item; armor by its stats times the model's stat weights around the best loadout (Stamina and armor value are not scored). Best across builds. `window` is the longest run of levels where uplift is at least {:.1}%; `mean` is the average over it, `peak` the largest at any level.\n\n\
**Method**, from the item's easiest source: *vendor*; *solo quest* (normal quest, no elite or boss objective, none of its prerequisite quests is harder); *group quest* (elite quest, elite/boss objective mob, or 2+ suggested players, or a group quest earlier in its chain); *dungeon* (a dungeon quest, or a drop inside an instance); *crafted*; *open-world drop*; *world drop*. Raid and PvP rewards are left out.\n\n\
**Verdicts:** vendor and solo-quest items count once they add {:.1}%. A group quest is *worth the extra time* at a mean of {:.1}% and {:.0} percent-levels (mean x window), otherwise *only if a group is already formed*. A dungeon item is *very worth it* at {:.1}% mean and {:.0} percent-levels, *kinda* at {:.1}% and {:.0}, otherwise *not worth it*; a dungeon drop below a {:.0}% chance drops one step, below {:.0}% never counts. Anything under {:.1}% at every level is *not worth it*. The vendor/quest baseline is thin below level 25, so early uplifts are overstated.\n\n\
The model does not see how long a quest chain takes beyond the chain length shown, or whether a mob is a group boss, and it is Classic Era 1.12 data. Treat each verdict as a candidate for a human to confirm.\n",
        v.min_uplift, v.min_uplift, v.detour_uplift, v.detour_gain, v.dungeon_very.0, v.dungeon_very.1, v.dungeon_kinda.0, v.dungeon_kinda.1, v.min_drop_chance * 100.0, v.min_drop_chance * 20.0, v.min_uplift
    );

    s.push_str("\n## Summary\n\n| verdict | weapons | armor & jewelry |\n|---|---|---|\n");
    for vd in Verdict::ALL {
        let (wn, an) = rows.iter().filter(|r| r.verdict == vd).fold((0, 0), |(w, a), r| if r.weapon { (w + 1, a) } else { (w, a + 1) });
        let _ = writeln!(s, "| {} | {wn} | {an} |", vd.label());
    }

    for vd in Verdict::ALL {
        let group: Vec<&Row> = rows.iter().filter(|r| r.verdict == vd).collect();
        let _ = write!(s, "\n## {} ({})\n\n", vd.label(), group.len());
        if group.is_empty() {
            continue;
        }
        if vd == Verdict::NotWorth {
            // Armor that never clears the bar is not listed at all (it never enters `rows`); weapons that fail are.
            s.push_str("| item | slot | method | peak uplift | on list |\n|---|---|---|---|---|\n");
            for r in group {
                let on = lists.get(&norm(&r.name)).map(|l| l.iter().cloned().collect::<Vec<_>>().join(", ")).unwrap_or_default();
                let _ = writeln!(s, "| {} | {} | {:?} | {:+.1}% | {on} |", r.name, r.slot, r.tier, r.peak);
            }
            continue;
        }
        s.push_str("| window | item | slot | mean / peak | best build | how to get it | on list |\n|---|---|---|---|---|---|---|\n");
        for r in group {
            let on = lists.get(&norm(&r.name)).map(|l| l.iter().cloned().collect::<Vec<_>>().join(", ")).unwrap_or_default();
            let it = by_id.get(&r.id);
            let src = it.map(|i| describe_source(i)).unwrap_or_default();
            let chain = it
                .and_then(|i| i.sources.quest.iter().filter(|q| Tier::of_quest(&q.effort) == Some(r.tier)).map(|q| q.chain).min())
                .filter(|&c| c > 1)
                .map(|c| format!(" (chain of {c} quests)"))
                .unwrap_or_default();
            let chance = it
                .filter(|_| matches!(r.tier, Tier::DungeonDrop | Tier::OpenDrop))
                .and_then(|i| best_drop_chance(i, r.tier))
                .map(|c| if c >= 0.1 { format!(" [{:.0}% drop]", c * 100.0) } else { format!(" [{:.1}% drop]", c * 100.0) })
                .unwrap_or_default();
            let _ = writeln!(s, "| {}-{} | {} | {} | {:+.1}% / {:+.1}% | {} | {src}{chain}{chance} | {on} |", r.first, r.last, r.name, r.slot, r.mean, r.peak, r.build);
        }
    }
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn best_run_picks_longest_and_averages() {
        let m: BTreeMap<u32, f64> = [(10, 0.2), (11, 3.0), (12, 5.0), (13, 0.0), (14, 2.0), (15, 2.0), (16, 2.0)].into();
        assert_eq!(best_run(&m, 1.0), Some((14, 16, 2.0)));
        assert_eq!(best_run(&m, 10.0), None);
    }
}
