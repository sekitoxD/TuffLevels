//! Compares the model's shortlist against the hand-authored item lists
//! (`Rogue.upgrades` in Rogue.lua and the progression tables in
//! `plans/classes/notable_rogue_items.md`). Read-only: it reports disagreements
//! for a human to resolve and never edits either list.

use crate::data::Item;
use crate::report::{windows, Cell, RunOptions};
use crate::search::{tier_of, Tier};
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::fmt::Write as _;

/// One name from a hand-authored list.
#[derive(Debug, Clone, PartialEq)]
pub struct Listed {
    pub list: String,
    pub level: u32,
    pub name: String,
}

/// `{ level = 45, item = "Thrash Blade", ...` lines from the Lua table.
pub fn parse_lua(text: &str) -> Vec<Listed> {
    let mut out = Vec::new();
    for line in text.lines() {
        let Some(l) = line.split("level =").nth(1) else { continue };
        let Some(level) = l.trim().split(|c: char| !c.is_ascii_digit()).next().and_then(|n| n.parse().ok()) else { continue };
        let Some(name) = line.split("item = \"").nth(1).and_then(|r| r.split('"').next()) else { continue };
        out.push(Listed { list: "Rogue.upgrades".into(), level, name: name.to_string() });
    }
    out
}

/// Rows of the form `| <level> | <item> | ...` under the `## ...progression...` headings.
pub fn parse_markdown(text: &str) -> Vec<Listed> {
    let mut out = Vec::new();
    let mut list = String::new();
    for line in text.lines() {
        if let Some(h) = line.strip_prefix("## ") {
            list = h.trim().to_string();
            continue;
        }
        if !line.starts_with('|') || !list.contains("progression") {
            continue;
        }
        let cols: Vec<&str> = line.split('|').map(|c| c.trim().trim_matches('*').trim()).collect();
        if cols.len() < 4 {
            continue;
        }
        let Ok(level) = cols[1].parse::<u32>() else { continue };
        out.push(Listed { list: list.replace(" progression", ""), level, name: cols[2].to_string() });
    }
    out
}

/// Loose key so "Electrocutioner's Leg" meets "Electrocutioner Leg" and
/// "Sword of the Hammerfall" meets "Sword of Hammerfall".
pub fn norm(name: &str) -> String {
    name.to_lowercase()
        .replace(['\'', '\u{2019}'], "")
        .split(|c: char| !c.is_alphanumeric())
        .filter(|t| !t.is_empty() && *t != "the")
        .map(|t| if t.len() > 3 { t.strip_suffix('s').unwrap_or(t) } else { t })
        .collect::<Vec<_>>()
        .join(" ")
}

pub fn describe_source(i: &Item) -> String {
    let mut parts: Vec<String> = Vec::new();
    for q in i.sources.quest.iter().take(2) {
        parts.push(format!("quest \"{}\"", q.title));
    }
    for v in i.sources.vendor.iter().take(1) {
        match &v.requires {
            Some(r) => parts.push(format!("vendor {} (requires {r})", v.name)),
            None if v.limited_stock => parts.push(format!("vendor {} (limited stock)", v.name)),
            None => parts.push(format!("vendor {}", v.name)),
        }
    }
    for c in i.sources.craft.iter().take(1) {
        parts.push(format!("crafted ({})", c.name));
    }
    for c in i.sources.chest.iter().take(1) {
        parts.push(match c.instance.as_ref().map(|v| v.join("/")).filter(|s| !s.is_empty()) {
            Some(p) => format!("chest {} ({p})", c.name),
            None => format!("chest {}", c.name),
        });
    }
    for d in i.sources.drop.iter().take(2) {
        let place = d.instance.as_ref().map(|v| v.join("/")).filter(|s| !s.is_empty());
        parts.push(match (d.world_drop, place) {
            (Some(true), _) => "world drop".to_string(),
            (_, Some(p)) => format!("{} ({p})", d.name),
            _ => d.name.clone(),
        });
    }
    if parts.is_empty() {
        "no source in DB".into()
    } else {
        parts.join("; ")
    }
}

/// Distinct-name rank of `dps` within a cell (1 = best).
fn rank_in(cell: &Cell, names: &HashMap<u32, String>, dps: f64) -> usize {
    let better: BTreeSet<String> = cell.all.iter().filter(|(_, &d)| d > dps + 1e-9).filter_map(|(id, _)| names.get(id)).map(|n| norm(n)).collect();
    better.len() + 1
}

pub fn audit_md(cells: &[Cell], items: &[Item], lua: &str, notes: &str, o: &RunOptions) -> String {
    let mut listed = parse_lua(lua);
    listed.extend(parse_markdown(notes));

    let names: HashMap<u32, String> = items.iter().filter(|i| i.weapon.is_some()).map(|i| (i.id, i.name.clone())).collect();
    let mut ids_by_key: HashMap<String, Vec<&Item>> = HashMap::new();
    for i in items.iter().filter(|i| i.weapon.is_some()) {
        ids_by_key.entry(norm(&i.name)).or_default().push(i);
    }

    // Model shortlist windows per item name (across builds), long-enough ones only.
    let mut builds: Vec<&str> = Vec::new();
    for c in cells {
        if !builds.contains(&c.build.as_str()) {
            builds.push(&c.build);
        }
    }
    let mut model_windows: BTreeMap<String, Vec<(String, u32, u32, f64)>> = BTreeMap::new();
    for b in &builds {
        for (name, a, z, _rank, peak) in windows(cells, b, o.top_n) {
            model_windows.entry(norm(&name)).or_default().push((b.to_string(), a, z, peak));
        }
    }

    // Collapse the lists to one row per item.
    let mut merged: BTreeMap<String, (String, u32, BTreeSet<String>)> = BTreeMap::new();
    for l in &listed {
        let e = merged.entry(norm(&l.name)).or_insert((l.name.clone(), l.level, BTreeSet::new()));
        e.1 = e.1.min(l.level);
        e.2.insert(l.list.clone());
    }

    let mut s = String::from("# Audit: model shortlist vs hand-authored lists\n\n");
    let _ = writeln!(
        s,
        "Lists read: `Rogue.upgrades` (Horde-only) and the progression tables in `notable_rogue_items.md`. Nothing was edited.\n\n\
Caveats: the model scores DPS only (no stamina, armor, utility or convenience), ranks weapons in either hand across all five builds, and does not model \
faction-specific quest availability, so an Alliance-only reward can show up for a Horde list. Read the gap column before the verdict: a weapon within ~1% of the best is a tie, not a miss. A `*` after a shortlist window means it is shorter than the demotion threshold.\n"
    );

    // --- Part A: listed items, scored -------------------------------------
    let mut rows = String::new();
    let mut missing: Vec<&str> = Vec::new();
    let mut counts = [0usize; 3]; // in shortlist, near, behind
    for (key, (name, level, lists)) in &merged {
        let Some(cands) = ids_by_key.get(key) else {
            missing.push(name);
            continue;
        };
        let gate = cands.iter().map(|i| i.gate_level).min().unwrap_or(1);
        let max_level = cells.iter().map(|c| c.level).max().unwrap_or(0);
        let eval_level = (*level).max(gate).min(max_level);
        // Best build for this item at the evaluation level.
        let mut best: Option<(&Cell, f64)> = None;
        for c in cells.iter().filter(|c| c.level == eval_level) {
            let d = cands.iter().filter_map(|i| c.all.get(&i.id)).copied().fold(f64::MIN, f64::max);
            if d > f64::MIN && best.map_or(true, |(bc, bd)| d / c.dps > bd / bc.dps) {
                best = Some((c, d));
            }
        }
        let ns = cands.iter().flat_map(|i| i.not_scored()).collect::<std::collections::BTreeSet<_>>().into_iter().collect::<Vec<_>>().join(", ");
        let list_txt = lists.iter().cloned().collect::<Vec<_>>().join(", ");
        let win = model_windows
            .get(key)
            .map(|w| w.iter().map(|(b, a, z, _)| format!("{b} {a}-{z}{}", if z - a + 1 < o.min_window { "*" } else { "" })).collect::<Vec<_>>().join("; "))
            .unwrap_or_else(|| "-".into());
        match best {
            None => {
                let why = if eval_level < o.min_level {
                    format!("below min level {}", o.min_level)
                } else if cands.iter().all(|i| tier_of(i) == Tier::None) {
                    "no source in the DB export, so excluded by the tier filter (rerun with --max-tier none)".to_string()
                } else {
                    format!("not a candidate (gated above L{max_level} or filtered)")
                };
                let _ = writeln!(rows, "| {name} | {list_txt} | {level} | - | - | - | - | {why} | {win} | {ns} |");
            }
            Some((c, d)) => {
                let gap = (d / c.dps - 1.0) * 100.0;
                let rank = rank_in(c, &names, d);
                let (verdict, bucket) = if rank <= o.top_n {
                    ("in shortlist", 0)
                } else if gap >= -2.0 {
                    ("within 2%", 1)
                } else {
                    ("behind", 2)
                };
                counts[bucket] += 1;
                let shown = if eval_level != *level { format!("{eval_level} (gate)") } else { eval_level.to_string() };
                let _ = writeln!(rows, "| {name} | {list_txt} | {level} | {shown} | {} | {gap:+.1}% | {rank} | {verdict} | {win} | {ns} |", c.build);
            }
        }
    }
    let _ = writeln!(s, "## A. Listed weapons, scored by the model\n");
    let _ = writeln!(s, "{} in the model's top {}, {} within 2% of a top loadout, {} behind by more than 2%, {} not found in the DB export.\n", counts[0], o.top_n, counts[1], counts[2], missing.len());
    let _ = writeln!(s, "| weapon | list | listed level | evaluated at | best build | gap to that build's best | rank | verdict | model shortlist windows | not scored |");
    let _ = writeln!(s, "|---|---|---|---|---|---|---|---|---|---|");
    s.push_str(&rows);
    if !missing.is_empty() {
        let _ = writeln!(s, "\nNot matched to a DB weapon (spelling, or not a weapon): {}.", missing.join(", "));
    }

    // --- Part B: model favours, lists lack --------------------------------
    let _ = writeln!(s, "\n## B. In the model's shortlist but on neither list\n");
    let _ = writeln!(s, "| weapon | tier | source | gate | shortlist windows | peak dps | not scored |");
    let _ = writeln!(s, "|---|---|---|---|---|---|---|");
    let mut extra: Vec<(u32, String)> = Vec::new();
    for (key, all_w) in &model_windows {
        if merged.contains_key(key) {
            continue;
        }
        let w: Vec<_> = all_w.iter().filter(|x| x.2 - x.1 + 1 >= o.min_window).cloned().collect();
        if w.is_empty() {
            continue;
        }
        let Some(cands) = ids_by_key.get(key) else { continue };
        let first_level = w.iter().map(|x| x.1).min().unwrap_or(0);
        // Same-named items exist at several level gates; describe the one usable at the window's start.
        let it = cands.iter().filter(|i| i.gate_level <= first_level).max_by_key(|i| i.gate_level).unwrap_or(&cands[0]);
        let first = w.iter().map(|x| x.1).min().unwrap_or(0);
        let peak = w.iter().map(|x| x.3).fold(f64::MIN, f64::max);
        let wins = w.iter().map(|(b, a, z, _)| format!("{b} {a}-{z}")).collect::<Vec<_>>().join("; ");
        extra.push((first, format!("| {} | {:?} | {} | {} | {wins} | {peak:.1} | {} |", it.name, tier_of(it), describe_source(it), it.gate_level, it.not_scored().join(", "))));
    }
    extra.sort();
    for (_, row) in &extra {
        let _ = writeln!(s, "{row}");
    }
    let _ = writeln!(s, "\n{} weapons.", extra.len());
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_lua_and_markdown_rows() {
        let lua = "    { level = 45, item = \"Thrash Blade\",\n      how = \"x\" },\n    { level = 4,  item = \"Jagged Dagger\",";
        let l = parse_lua(lua);
        assert_eq!(l.iter().map(|x| (x.level, x.name.as_str())).collect::<Vec<_>>(), vec![(45, "Thrash Blade"), (4, "Jagged Dagger")]);

        let md = "## Sword progression — Alliance\n\n| Level | Item | DPS |\n|---|---|---|\n| **34** | **Sword of Serenity** | 30.0 | **Q** | x |\n\n## Open items\n| 1 | Nope | 2 | 3 |";
        let m = parse_markdown(md);
        assert_eq!(m.len(), 1);
        assert_eq!((m[0].level, m[0].name.as_str(), m[0].list.as_str()), (34, "Sword of Serenity", "Sword — Alliance"));
    }

    #[test]
    fn norm_bridges_spelling_differences() {
        assert_eq!(norm("Electrocutioner's Leg"), norm("Electrocutioner Leg"));
        assert_eq!(norm("Sword of the Hammerfall"), norm("Sword of Hammerfall"));
        assert_ne!(norm("Thrash Blade"), norm("Thorn Blade"));
    }
}
