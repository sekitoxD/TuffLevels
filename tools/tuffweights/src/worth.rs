//! "Is this weapon worth a detour?" report.
//!
//! For each candidate weapon the question is not its absolute DPS but how much it adds over
//! what you would be wearing anyway: the best loadout built only from vendor and quest weapons
//! (the things you pick up while levelling normally), with the weapon itself taken out of that
//! pool if it belongs there. That uplift, per level, is combined with how hard the weapon is to
//! get (its source tier) to sort it into one of three classes:
//!
//! - **Detour**: a deterministic source (vendor/quest) that adds a solid, lasting DPS gain.
//! - **If convenient**: worth having if you are already at the source, or it drops; never chase it.
//! - **Skip**: adds under `min_uplift` percent, i.e. inside the model's noise.
//!
//! Thresholds are judgement calls, exposed as options. The model does not know how long a quest
//! chain takes, whether a quest needs a group, or which faction can do it, so the class is a
//! candidate for a human to confirm, not a verdict.

use crate::audit::{describe_source, norm, parse_lua, parse_markdown};
use crate::data::Item;
use crate::model::AbilityTable;
use crate::report::{Cell, RunOptions};
use crate::rules::{Build, Rules};
use crate::search::{search, tier_of, Filter, Tier};
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::fmt::Write as _;

pub struct WorthOptions {
    /// Uplift (percent) below which a weapon is not worth having at all.
    pub min_uplift: f64,
    /// Mean uplift (percent) over its window that makes a deterministic source a detour.
    pub detour_uplift: f64,
    /// Mean uplift x window length (percent-levels) a detour must reach, so a short spike can qualify too.
    pub detour_gain: f64,
    /// How many of each cell's best weapons to consider as subjects.
    pub top_subjects: usize,
}

impl Default for WorthOptions {
    fn default() -> Self {
        WorthOptions { min_uplift: 1.0, detour_uplift: 2.5, detour_gain: 20.0, top_subjects: 30 }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Class {
    Detour,
    IfConvenient,
    Skip,
}

impl Class {
    fn title(self) -> &'static str {
        match self {
            Class::Detour => "Worth a detour",
            Class::IfConvenient => "Worth it if convenient (never chase it)",
            Class::Skip => "Not worth it",
        }
    }
}

#[derive(Debug, Clone)]
pub struct Row {
    pub id: u32,
    pub name: String,
    pub tier: Tier,
    pub first: u32,
    pub last: u32,
    pub mean: f64,
    pub peak: f64,
    pub build: String,
    pub class: Class,
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

pub fn classify(tier: Tier, run_len: u32, mean: f64, peak: f64, o: &WorthOptions) -> Class {
    if peak < o.min_uplift {
        return Class::Skip;
    }
    let deterministic = matches!(tier, Tier::Vendor | Tier::Quest);
    if deterministic && mean >= o.detour_uplift && mean * run_len as f64 >= o.detour_gain {
        Class::Detour
    } else {
        Class::IfConvenient
    }
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
    let base_filter = Filter { max_tier: Tier::Quest, ..o.filter.clone() };
    // Best loadout from the no-detour pool per (build, level): (dps, ids used).
    let mut base: HashMap<(usize, u32), (f64, Vec<u32>)> = HashMap::new();
    for (bi, b) in builds.iter().enumerate() {
        for level in o.min_level..=o.max_level {
            let r = search(rules, abilities, b, items, level, o.race, &base_filter, 1);
            if let Some(l) = r.best() {
                base.insert((bi, level), (l.dps, std::iter::once(l.mh.id).chain(l.oh.map(|x| x.id)).collect()));
            }
        }
    }
    let full: HashMap<(&str, u32), &Cell> = cells.iter().map(|c| ((c.build.as_str(), c.level), c)).collect();

    let mut rows = Vec::new();
    for item in subjects(cells, items, listed, w.top_subjects) {
        let tier = tier_of(item);
        let in_base = tier <= Tier::Quest;
        let mut uplift: BTreeMap<u32, f64> = BTreeMap::new();
        let mut who: BTreeMap<u32, (f64, &str)> = BTreeMap::new();
        for level in item.gate_level.max(o.min_level)..=o.max_level {
            // Per build: best DPS with and without the item, then the player's best across builds.
            let mut with_max = f64::MIN;
            let mut without_max = f64::MIN;
            for (bi, b) in builds.iter().enumerate() {
                let Some((bdps, bids)) = base.get(&(bi, level)) else { continue };
                // The full pool's best DPS with this item bounds what it can add.
                let bound = full.get(&(b.name.as_str(), level)).and_then(|c| c.all.get(&item.id)).copied();
                let no_gain = bound.map_or(true, |d| d <= *bdps + 1e-9);
                let best_of = |f: &Filter| search(rules, abilities, b, items, level, o.race, f, 1).best().map_or(f64::MIN, |l| l.dps);
                let (with, without) = match (in_base, no_gain) {
                    (_, true) => (*bdps, *bdps),
                    (true, false) if !bids.contains(&item.id) => (*bdps, *bdps),
                    (true, false) => (*bdps, best_of(&Filter { exclude: vec![item.id], ..base_filter.clone() })),
                    (false, false) => (best_of(&Filter { also: Some(item.id), ..base_filter.clone() }), *bdps),
                };
                if with > who.get(&level).map_or(f64::MIN, |x| x.0) {
                    who.insert(level, (with, b.name.as_str()));
                }
                with_max = with_max.max(with);
                without_max = without_max.max(without);
            }
            if with_max > f64::MIN && without_max > 0.0 {
                uplift.insert(level, (with_max / without_max - 1.0) * 100.0);
            }
        }
        let peak = uplift.values().copied().fold(0.0_f64, f64::max);
        let (first, last, mean) = best_run(&uplift, w.min_uplift).unwrap_or((0, 0, 0.0));
        let build = who
            .iter()
            .filter(|(l, _)| (first..=last).contains(l))
            .map(|(_, v)| v.1)
            .fold(BTreeMap::<&str, usize>::new(), |mut m, b| {
                *m.entry(b).or_default() += 1;
                m
            })
            .into_iter()
            .max_by_key(|x| x.1)
            .map(|x| x.0.to_string())
            .unwrap_or_default();
        let run_len = if first == 0 { 0 } else { last - first + 1 };
        rows.push(Row { id: item.id, name: item.name.clone(), tier, first, last, mean, peak, build, class: classify(tier, run_len, mean, peak, w) });
    }
    // Variants sharing a name (level-scaled copies): keep the one with the largest peak.
    let mut by_name: BTreeMap<String, Row> = BTreeMap::new();
    for r in rows {
        match by_name.get(&r.name) {
            Some(old) if old.peak >= r.peak => {}
            _ => {
                by_name.insert(r.name.clone(), r);
            }
        }
    }
    let mut out: Vec<Row> = by_name.into_values().collect();
    out.sort_by(|a, b| a.class.cmp(&b.class).then(a.first.cmp(&b.first)).then(b.peak.total_cmp(&a.peak)));
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
    let by_name: HashMap<&str, &Item> = items.iter().filter(|i| i.weapon.is_some()).map(|i| (i.name.as_str(), i)).collect();

    let mut s = String::from("# Worth: which weapons justify effort\n\n");
    let _ = write!(
        s,
        "Uplift is how much DPS the weapon adds over the best loadout built only from vendor and quest weapons (the ones you pick up while levelling normally), with the weapon itself removed from that pool if it is a vendor/quest item. It is the best across builds. `window` is the longest run of levels where uplift is at least {:.1}%; `mean` is the average uplift over that run and `peak` the largest at any level.\n\n\
Classes: **Detour** = vendor/quest source, mean uplift of at least {:.1}% and mean x window length (percent-levels) of at least {:.0}, so a big short spike or a modest long one both count. **If convenient** = adds at least {:.1}% at some level but is chancy to get (drop) or only a modest gain. **Not worth it** = under {:.1}% at every level, i.e. inside the model's noise.\n\n\
The model does not know how long a quest chain takes, whether it needs a group, or which faction can do it, and the baseline includes both factions' quest rewards. Treat the class as a candidate for a human to confirm.\n",
        w.min_uplift, w.detour_uplift, w.detour_gain, w.min_uplift, w.min_uplift
    );
    for class in [Class::Detour, Class::IfConvenient, Class::Skip] {
        let group: Vec<&Row> = rows.iter().filter(|r| r.class == class).collect();
        let _ = write!(s, "\n## {} ({})\n\n", class.title(), group.len());
        if group.is_empty() {
            continue;
        }
        if class == Class::Skip {
            s.push_str("| weapon | tier | peak uplift | on list |\n|---|---|---|---|\n");
            for r in group {
                let on = lists.get(&norm(&r.name)).map(|l| l.iter().cloned().collect::<Vec<_>>().join(", ")).unwrap_or_default();
                let _ = writeln!(s, "| {} | {:?} | {:+.1}% | {on} |", r.name, r.tier, r.peak);
            }
            continue;
        }
        s.push_str("| window | weapon | tier | mean / peak | best build | source | on list |\n|---|---|---|---|---|---|---|\n");
        for r in group {
            let on = lists.get(&norm(&r.name)).map(|l| l.iter().cloned().collect::<Vec<_>>().join(", ")).unwrap_or_default();
            let src = by_name.get(r.name.as_str()).map(|i| describe_source(i)).unwrap_or_default();
            let _ = writeln!(s, "| {}-{} | {} | {:?} | {:+.1}% / {:+.1}% | {} | {src} | {on} |", r.first, r.last, r.name, r.tier, r.mean, r.peak, r.build);
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

    #[test]
    fn classes_follow_tier_and_size() {
        let w = WorthOptions::default();
        assert_eq!(classify(Tier::Quest, 8, 4.0, 6.0, &w), Class::Detour);
        assert_eq!(classify(Tier::Quest, 4, 6.0, 8.0, &w), Class::Detour); // short but big
        assert_eq!(classify(Tier::Quest, 2, 3.0, 4.0, &w), Class::IfConvenient); // too little in total
        assert_eq!(classify(Tier::WorldDrop, 10, 9.0, 12.0, &w), Class::IfConvenient); // lottery
        assert_eq!(classify(Tier::Quest, 8, 0.5, 0.8, &w), Class::Skip);
    }
}
