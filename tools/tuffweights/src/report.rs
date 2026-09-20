//! Runs the search + weights for every (build, level) and writes the report files.
//!
//! Output goes to a gitignored directory: it is derived from DB data, so a human
//! curates it into `plans/classes/notable_rogue_items.md` rather than committing it.

use crate::data::Item;
use crate::model::{AbilityTable, Prepared};
use crate::rules::{Build, Rules};
use crate::search::{self, Filter};
use crate::weights;
use serde::Serialize;
use std::collections::{BTreeMap, HashMap};
use std::fmt::Write as _;
use std::path::Path;

#[derive(Serialize, Clone)]
pub struct LoadoutRow {
    pub mh: String,
    pub oh: Option<String>,
    pub dps: f64,
    /// Monte Carlo DPS of the same loadout (None when `--mc-fights 0`).
    pub mc_dps: Option<f64>,
}

#[derive(Serialize, Clone)]
pub struct ItemRow {
    pub id: u32,
    pub name: String,
    pub dps: f64,
    pub rank: usize,
}

#[derive(Serialize, Clone)]
pub struct WeightRow {
    pub stat: String,
    pub dps_per_unit: f64,
    pub ep: f64,
}

#[derive(Serialize, Clone)]
pub struct Cell {
    pub build: String,
    pub level: u32,
    pub dps: f64,
    /// Best Monte Carlo DPS among the analytic top loadouts; used to compare builds.
    pub mc_dps: Option<f64>,
    pub top: Vec<LoadoutRow>,
    pub items: Vec<ItemRow>,
    pub weights: Vec<WeightRow>,
    /// Best DPS reachable with each candidate weapon (by id); kept in memory for the audit.
    #[serde(skip)]
    pub all: HashMap<u32, f64>,
}

pub struct RunOptions<'a> {
    pub min_level: u32,
    pub max_level: u32,
    pub race: Option<&'a str>,
    pub filter: Filter,
    /// Shortlist size (1-5 is the intended range).
    pub top_n: usize,
    /// Items shorter-lived than this many consecutive levels are demoted.
    pub min_window: u32,
    /// Monte Carlo fights per top loadout, used to compare builds (0 = analytic only).
    pub mc_fights: usize,
}

pub fn compute_cells(
    rules: &Rules,
    abilities: &AbilityTable,
    builds: &[Build],
    items: &[Item],
    o: &RunOptions,
) -> Vec<Cell> {
    let mut cells = Vec::new();
    for b in builds {
        for level in o.min_level..=o.max_level {
            let r = search::search(rules, abilities, b, items, level, o.race, &o.filter, 5);
            let Some(best) = r.best() else { continue };
            let prep = Prepared::new(rules, abilities, b, level, o.race, None);
            let w = weights::compute(&prep, best.mh, best.oh);

            let mut ranked: Vec<(u32, f64)> = r.item_best.iter().map(|(&id, &d)| (id, d)).collect();
            ranked.sort_by(|a, b| b.1.total_cmp(&a.1).then(a.0.cmp(&b.0)));
            let name_of = |id: u32| items.iter().find(|i| i.id == id).map(|i| i.name.clone()).unwrap_or_default();

            let x = crate::model::Extra::default();
            let top: Vec<LoadoutRow> = r
                .top
                .iter()
                .enumerate()
                .map(|(i, l)| {
                    let mc_dps = (o.mc_fights > 0)
                        .then(|| crate::mc::simulate(&prep, l.mh, l.oh, &x, o.mc_fights, level as u64 * 1000 + i as u64))
                        .flatten()
                        .map(|m| m.mean);
                    LoadoutRow { mh: l.mh.name.clone(), oh: l.oh.map(|o| o.name.clone()), dps: l.dps, mc_dps }
                })
                .collect();
            let mc_dps = top.iter().filter_map(|l| l.mc_dps).fold(None, |a: Option<f64>, v| Some(a.map_or(v, |a| a.max(v))));
            cells.push(Cell {
                build: b.name.clone(),
                level,
                dps: best.dps,
                mc_dps,
                top,
                items: ranked
                    .iter()
                    .take(10)
                    .enumerate()
                    .map(|(i, &(id, dps))| ItemRow { id, name: name_of(id), dps, rank: i + 1 })
                    .collect(),
                weights: w
                    .weights
                    .iter()
                    .map(|x| WeightRow { stat: x.stat.to_string(), dps_per_unit: x.dps_per_unit, ep: x.ep })
                    .collect(),
                all: r.item_best.clone(),
            });
        }
    }
    cells
}

pub fn write_all(cells: &[Cell], items: &[Item], dir: &Path, o: &RunOptions) -> anyhow::Result<()> {
    std::fs::create_dir_all(dir)?;
    std::fs::write(dir.join("results.json"), serde_json::to_string_pretty(cells)?)?;
    std::fs::write(dir.join("weights.md"), weights_md(cells))?;
    std::fs::write(dir.join("ranking.md"), ranking_md(cells))?;
    std::fs::write(dir.join("best_by_level.md"), best_by_level_md(cells))?;
    std::fs::write(dir.join("shortlist.md"), shortlist_md(cells, items, o))?;
    Ok(())
}

fn builds_in_order(cells: &[Cell]) -> Vec<&str> {
    let mut v: Vec<&str> = Vec::new();
    for c in cells {
        if !v.contains(&c.build.as_str()) {
            v.push(&c.build);
        }
    }
    v
}

/// Every fifth level plus the ends, to keep the tables readable.
fn is_sample(level: u32, cells: &[Cell]) -> bool {
    let lo = cells.iter().map(|c| c.level).min().unwrap_or(0);
    let hi = cells.iter().map(|c| c.level).max().unwrap_or(0);
    level % 5 == 0 || level == lo || level == hi
}

fn weights_md(cells: &[Cell]) -> String {
    let mut s = String::from("# Stat weights (equivalent AP; 1 AP = 1.0)\n\nFinite differences around each build's best loadout. `mh_dps`/`oh_dps` are per +1 weapon DPS.\n");
    for b in builds_in_order(cells) {
        let rows: Vec<&Cell> = cells.iter().filter(|c| c.build == b && is_sample(c.level, cells)).collect();
        let Some(first) = rows.first() else { continue };
        let _ = write!(s, "\n## {b}\n\n| level |");
        for w in &first.weights {
            let _ = write!(s, " {} |", w.stat);
        }
        let _ = write!(s, "\n|---|");
        for _ in &first.weights {
            s.push_str("---|");
        }
        s.push('\n');
        for c in rows {
            let _ = write!(s, "| {} |", c.level);
            for w in &c.weights {
                let _ = write!(s, " {:.2} |", w.ep);
            }
            s.push('\n');
        }
    }
    s
}

fn ranking_md(cells: &[Cell]) -> String {
    let mut s = String::from("# Weapon ranking\n\nEach weapon's best DPS reachable in either hand, top 10 per build at sampled levels. Off-hand choice moves DPS very little, so many weapons sit within a fraction of a percent of #1; read the percentage, not the rank.\n");
    for b in builds_in_order(cells) {
        let _ = write!(s, "\n## {b}\n");
        for c in cells.iter().filter(|c| c.build == b && is_sample(c.level, cells)) {
            let _ = write!(s, "\n**L{}** (best loadout {:.1} dps)\n\n", c.level, c.dps);
            for i in &c.items {
                let _ = writeln!(s, "{}. {} ({:.1}, {:+.1}% vs #1)", i.rank, i.name, i.dps, (i.dps / c.dps - 1.0) * 100.0);
            }
        }
    }
    s
}

/// Score used to compare builds: Monte Carlo when available, else analytic.
fn score(c: &Cell) -> f64 {
    c.mc_dps.unwrap_or(c.dps)
}

fn loadout_key(c: &Cell) -> String {
    let t = c
        .top
        .iter()
        .max_by(|a, b| a.mc_dps.unwrap_or(a.dps).total_cmp(&b.mc_dps.unwrap_or(b.dps)))
        .unwrap_or(&c.top[0]);
    format!("{} / {}", t.mh, t.oh.as_deref().unwrap_or("-"))
}

fn best_by_level_md(cells: &[Cell]) -> String {
    let mut by_level: BTreeMap<u32, Vec<&Cell>> = BTreeMap::new();
    for c in cells {
        by_level.entry(c.level).or_default().push(c);
    }
    let mut s = String::from("# Best build and loadout by level\n\n`B` = the best build changed, `L` = the best loadout changed. The previous level's build is kept while it is within 0.5% of the top, so ties are not reported as switches. Builds are compared by Monte Carlo DPS of each build's analytic top loadouts when available (the analytic model's expected-combo-point shortcut is biased about 1-4% and unevenly across builds, see crosscheck); `analytic` is the closed-form number for the same build.\n\n| level | build | dps | analytic | loadout | runner-up build | flag |\n|---|---|---|---|---|---|---|\n");
    let mut prev: Option<(String, String)> = None;
    for (level, mut row) in by_level {
        row.sort_by(|a, b| score(b).total_cmp(&score(a)));
        let top = row[0];
        let sticky = prev.as_ref().and_then(|p| row.iter().find(|c| c.build == p.0 && score(c) >= score(top) * 0.995));
        let best = sticky.copied().unwrap_or(top);
        let second = row.iter().find(|c| c.build != best.build).map(|c| format!("{} ({:+.1})", c.build, score(c) - score(best))).unwrap_or_default();
        let key = (best.build.clone(), loadout_key(best));
        let flag = match &prev {
            None => String::new(),
            Some(p) => format!("{}{}", if p.0 != key.0 { "B" } else { "" }, if p.1 != key.1 { "L" } else { "" }),
        };
        let _ = writeln!(s, "| {level} | {} | {:.1} | {:.1} | {} | {second} | {flag} |", best.build, score(best), best.dps, key.1);
        prev = Some(key);
    }
    s
}

/// Runs of consecutive levels an item stays in the shortlist: (item, first, last, best rank, peak dps).
pub fn windows(cells: &[Cell], build: &str, top_n: usize) -> Vec<(String, u32, u32, usize, f64)> {
    let mut by_item: BTreeMap<u32, Vec<(u32, usize, f64, String)>> = BTreeMap::new();
    for c in cells.iter().filter(|c| c.build == build) {
        for i in c.items.iter().filter(|i| i.rank <= top_n) {
            by_item.entry(i.id).or_default().push((c.level, i.rank, i.dps, i.name.clone()));
        }
    }
    let mut out = Vec::new();
    for (_, mut lv) in by_item {
        lv.sort_by_key(|x| x.0);
        let mut start = 0;
        for k in 1..=lv.len() {
            if k == lv.len() || lv[k].0 != lv[k - 1].0 + 1 {
                let run = &lv[start..k];
                let rank = run.iter().map(|x| x.1).min().unwrap_or(0);
                let peak = run.iter().map(|x| x.2).fold(f64::MIN, f64::max);
                out.push((run[0].3.clone(), run[0].0, run[run.len() - 1].0, rank, peak));
                start = k;
            }
        }
    }
    out.sort_by(|a, b| a.1.cmp(&b.1).then(a.3.cmp(&b.3)).then(a.0.cmp(&b.0)));
    out
}

/// Item name -> effects the model does not score, joined; only names that have any.
/// Items sharing a name (level-scaled variants) are merged.
pub fn not_scored_by_name(items: &[Item]) -> std::collections::HashMap<String, String> {
    let mut m: std::collections::BTreeMap<String, std::collections::BTreeSet<String>> = Default::default();
    for it in items {
        for n in it.not_scored() {
            m.entry(it.name.clone()).or_default().insert(n);
        }
    }
    m.into_iter().map(|(k, v)| (k, v.into_iter().collect::<Vec<_>>().join(", "))).collect()
}

fn shortlist_md(cells: &[Cell], items: &[Item], o: &RunOptions) -> String {
    let ns = not_scored_by_name(items);
    let note = |name: &str| ns.get(name).cloned().unwrap_or_default();
    let mut s = format!(
        "# Shortlist: top {} weapons per level window\n\nA window is a run of consecutive levels where the weapon is in the build's top {} (by best DPS in either hand). Windows shorter than {} levels are demoted to the bottom of each build. `not scored` lists on-use abilities and proc effects the model counts as zero DPS, so they can only make the weapon better than shown.\n",
        o.top_n, o.top_n, o.min_window
    );
    for b in builds_in_order(cells) {
        let all = windows(cells, b, o.top_n);
        let _ = write!(s, "\n## {b}\n\n| levels | weapon | best rank | peak dps | not scored |\n|---|---|---|---|---|\n");
        for (name, a, z, rank, peak) in all.iter().filter(|w| w.2 - w.1 + 1 >= o.min_window) {
            let _ = writeln!(s, "| {a}-{z} | {name} | {rank} | {peak:.1} | {} |", note(name));
        }
        let brief: Vec<_> = all.iter().filter(|w| w.2 - w.1 + 1 < o.min_window).collect();
        if !brief.is_empty() {
            let _ = write!(s, "\nDemoted (under {} levels):\n\n", o.min_window);
            for (name, a, z, rank, peak) in brief {
                let n = note(name);
                let _ = writeln!(s, "- {a}-{z} {name} (rank {rank}, {peak:.1}){}", if n.is_empty() { String::new() } else { format!(" [not scored: {n}]") });
            }
        }
    }
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    fn cell(build: &str, level: u32, ids: &[(u32, &str)]) -> Cell {
        Cell {
            build: build.into(),
            level,
            dps: 100.0,
            mc_dps: None,
            top: vec![LoadoutRow { mh: "m".into(), oh: None, dps: 100.0, mc_dps: None }],
            items: ids
                .iter()
                .enumerate()
                .map(|(i, &(id, n))| ItemRow { id, name: n.into(), dps: 100.0 - i as f64, rank: i + 1 })
                .collect(),
            weights: vec![],
            all: HashMap::new(),
        }
    }

    #[test]
    fn windows_split_on_gaps() {
        let cells = vec![
            cell("b", 10, &[(1, "A")]),
            cell("b", 11, &[(1, "A")]),
            cell("b", 12, &[(2, "B")]),
            cell("b", 13, &[(1, "A")]),
        ];
        let w = windows(&cells, "b", 1);
        let a: Vec<_> = w.iter().filter(|x| x.0 == "A").map(|x| (x.1, x.2)).collect();
        assert_eq!(a, vec![(10, 11), (13, 13)]);
    }
}
