//! tuffweights: offline stat-weight and weapon-ranking calculator for rogue leveling.
//!
//! Reads the gitignored `tools/.cache/items.json` (from `tools/export_items.py`),
//! a ruleset and build definitions (TOML), and writes reports to a gitignored
//! directory. Run from `tools/tuffweights/`.

mod armor;
mod audit;
mod data;
mod mc;
mod model;
mod report;
mod rewards;
mod rules;
mod search;
mod weights;
mod verdict;
mod worth;

use clap::{Parser, Subcommand};
use rules::Ability;
use std::path::PathBuf;

#[derive(Parser)]
#[command(version, about)]
struct Cli {
    #[arg(long, default_value = "rules/era-1.12.toml", global = true)]
    rules: String,
    #[arg(long, default_value = "builds", global = true)]
    builds: String,
    #[arg(long, default_value = "../.cache/items.json", global = true)]
    items: String,
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    /// Search every build at every level and write the reports.
    Run {
        #[arg(long, default_value_t = 10)]
        min_level: u32,
        #[arg(long, default_value_t = 59)]
        max_level: u32,
        /// Race name as in `racial_skill` (human, dwarf, orc, ...); also filters race-locked items.
        #[arg(long)]
        race: Option<String>,
        /// horde or alliance: drops items whose only source is a quest that faction cannot take.
        #[arg(long)]
        faction: Option<String>,
        /// Hardest acceptable source: vendor, quest-solo, crafted, quest-group, open-drop, quest-dungeon, dungeon-drop, world-drop, none.
        #[arg(long, value_enum, default_value = "world-drop")]
        max_tier: search::Tier,
        /// Shortlist size per build and level.
        #[arg(long, default_value_t = 5)]
        top: usize,
        /// Windows shorter than this many levels are demoted.
        #[arg(long, default_value_t = 5)]
        min_window: u32,
        /// Monte Carlo fights per top loadout, used to compare builds (0 = analytic only; the
        /// analytic model now matches MC, so this is a spot check, see `crosscheck`).
        #[arg(long, default_value_t = 0)]
        mc_fights: usize,
        #[arg(long, default_value = "out")]
        out: PathBuf,
        /// Rogue.lua, read for `Rogue.upgrades` when writing audit.md.
        #[arg(long, default_value = "../../Rogue.lua")]
        lua: PathBuf,
        /// notable_rogue_items.md, read for its progression tables when writing audit.md.
        #[arg(long, default_value = "../../plans/classes/notable_rogue_items.md")]
        notes: PathBuf,
        /// worth.md: uplift (percent over the best equally-easy gear) below which an item is not worth having.
        #[arg(long, default_value_t = 1.0)]
        min_uplift: f64,
        /// worth.md: mean uplift (percent) over its window that makes a group quest worth the extra time.
        #[arg(long, default_value_t = 2.5)]
        detour_uplift: f64,
        /// worth.md: mean uplift x window length (percent-levels) a group quest must reach.
        #[arg(long, default_value_t = 20.0)]
        detour_gain: f64,
    },
    /// Quest-reward advisor: rank the choices of every choose-one quest by DPS gained.
    Rewards {
        #[arg(long, default_value_t = 1)]
        min_level: u32,
        #[arg(long, default_value_t = 59)]
        max_level: u32,
        #[arg(long)]
        race: Option<String>,
        /// horde or alliance: skips quests that faction cannot take.
        #[arg(long)]
        faction: Option<String>,
        /// Score one build only instead of the best across builds.
        #[arg(long)]
        build: Option<String>,
        /// Percent DPS below which no choice counts as a real pick.
        #[arg(long, default_value_t = 0.5)]
        min_uplift: f64,
        /// Percent DPS within which two choices are a tie.
        #[arg(long, default_value_t = 0.15)]
        tie: f64,
        #[arg(long, default_value = "out")]
        out: PathBuf,
    },
    /// Break down one loadout: DPS parts, attack table, casts and stat weights.
    Explain {
        #[arg(long)]
        build: String,
        #[arg(long)]
        level: u32,
        /// Main-hand weapon, by exact name or item id.
        #[arg(long)]
        mh: String,
        #[arg(long)]
        oh: Option<String>,
        #[arg(long)]
        race: Option<String>,
    },
    /// Monte Carlo one loadout and compare it with the analytic DPS.
    Mc {
        #[arg(long)]
        build: String,
        #[arg(long)]
        level: u32,
        #[arg(long)]
        mh: String,
        #[arg(long)]
        oh: Option<String>,
        #[arg(long)]
        race: Option<String>,
        #[arg(long, default_value_t = 200_000)]
        fights: usize,
        #[arg(long, default_value_t = 1)]
        seed: u64,
    },
    /// Monte Carlo the analytic top loadouts of every build at sample levels.
    Crosscheck {
        /// Comma-separated levels to check.
        #[arg(long, value_delimiter = ',', default_value = "15,25,35,45,55")]
        levels: Vec<u32>,
        #[arg(long)]
        race: Option<String>,
        #[arg(long, value_enum, default_value = "world-drop")]
        max_tier: search::Tier,
        /// Loadouts per (build, level) to simulate.
        #[arg(long, default_value_t = 5)]
        top: usize,
        #[arg(long, default_value_t = 100_000)]
        fights: usize,
        #[arg(long, default_value_t = 1)]
        seed: u64,
        /// Also write the table here (e.g. out/crosscheck.md).
        #[arg(long)]
        out: Option<PathBuf>,
    },
}

fn find_item<'a>(items: &'a [data::Item], q: &str) -> anyhow::Result<&'a data::Item> {
    let by_id = q.parse::<u32>().ok();
    items
        .iter()
        .find(|i| i.weapon.is_some() && (Some(i.id) == by_id || i.name.eq_ignore_ascii_case(q)))
        .ok_or_else(|| anyhow::anyhow!("no weapon named or numbered {q:?}"))
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let mut rules = rules::load_rules(&cli.rules)?;
    let builds = rules::load_builds(&cli.builds)?;
    for b in &builds {
        b.validate(&rules)?;
    }
    let mut file = data::load_items(&cli.items)?;
    rules.apply_world(&file.world)?;
    rules.resolve_durations(&mut file.items);

    match cli.cmd {
        Cmd::Run { min_level, max_level, race, faction, max_tier, top, min_window, mc_fights, out, lua, notes, min_uplift, detour_uplift, detour_gain } => {
            let faction = faction
                .as_deref()
                .map(|f| search::faction_mask(f).ok_or_else(|| anyhow::anyhow!("--faction must be horde or alliance")))
                .transpose()?;
            let opts = report::RunOptions {
                min_level,
                max_level: max_level.min(rules.max_level),
                race: race.as_deref(),
                filter: search::Filter { race: race.clone(), max_tier, include_gated: false, faction, ..Default::default() },
                top_n: top,
                min_window,
                mc_fights,
            };
            let t = std::time::Instant::now();
            let cells = report::compute_cells(&rules, &file.abilities, &builds, &file.items, &opts);
            report::write_all(&cells, &file.items, &out, &opts)?;
            match (std::fs::read_to_string(&lua), std::fs::read_to_string(&notes)) {
                (Ok(l), Ok(n)) => {
                    std::fs::write(out.join("audit.md"), audit::audit_md(&cells, &file.items, &l, &n, &opts))?;
                    let wo = worth::WorthOptions { verdict: verdict::VerdictOptions { min_uplift, detour_uplift, detour_gain, ..Default::default() }, ..Default::default() };
                    let md = worth::worth_md(&rules, &file.abilities, &builds, &file.items, &cells, &l, &n, &opts, &wo);
                    std::fs::write(out.join("worth.md"), md)?;
                }
                _ => eprintln!("skipping audit.md: could not read {} and {}", lua.display(), notes.display()),
            }
            println!("{} cells in {:?}; reports in {}", cells.len(), t.elapsed(), out.display());
        }
        Cmd::Rewards { min_level, max_level, race, faction, build, min_uplift, tie, out } => {
            let faction = faction
                .as_deref()
                .map(|f| search::faction_mask(f).ok_or_else(|| anyhow::anyhow!("--faction must be horde or alliance")))
                .transpose()?;
            let o = rewards::RewardOptions { min_level, max_level: max_level.min(rules.max_level), min_uplift, tie, race: race.as_deref(), faction, build: build.as_deref(), verdict: verdict::VerdictOptions { min_uplift, ..Default::default() } };
            let t = std::time::Instant::now();
            let md = rewards::rewards_md(&rules, &builds, &file, &o)?;
            std::fs::create_dir_all(&out)?;
            std::fs::write(out.join("rewards.md"), md)?;
            println!("rewards.md written to {} in {:?}", out.display(), t.elapsed());
        }
        Cmd::Explain { build, level, mh, oh, race } => {
            let b = builds
                .iter()
                .find(|b| b.name == build)
                .ok_or_else(|| anyhow::anyhow!("unknown build {build:?} (have: {})", builds.iter().map(|b| b.name.as_str()).collect::<Vec<_>>().join(", ")))?;
            let mh = find_item(&file.items, &mh)?;
            let oh = oh.as_deref().map(|q| find_item(&file.items, q)).transpose()?;
            let prep = model::Prepared::new(&rules, &file.abilities, b, level, race.as_deref(), None);
            let e = prep.evaluate(mh, oh, &model::Extra::default());
            println!("{} L{level}: {} / {}", b.name, mh.name, oh.map_or("-", |o| o.name.as_str()));
            println!("  dps {:.1}  (white MH {:.1}, white OH {:.1}, specials {:.1}, extra swings {:.1}, procs {:.1})", e.dps, e.white_mh, e.white_oh, e.specials, e.extra_swings, e.procs);
            println!("  AP {:.0}  crit {:.1}%  hit {:.1}%  yellow miss {:.1}%", e.ap, e.crit_pct, e.hit_pct, e.yellow_miss_pct);
            println!(
                "  casts per fight: SS {:.1}  BS {:.1}  Hemo {:.1}  Evis {:.1}",
                e.casts_of(Ability::SinisterStrike),
                e.casts_of(Ability::Backstab),
                e.casts_of(Ability::Hemorrhage),
                e.casts_of(Ability::Eviscerate)
            );
            if !e.unmodelled.is_empty() {
                println!("  UNMODELLED procs (spell ids, scored as 0): {:?}", e.unmodelled);
            }
            let w = weights::compute(&prep, mh, oh);
            println!("  weights (AP = 1.00):");
            for x in &w.weights {
                println!("    {:<13} {:6.2}   ({:+.3} dps per unit)", x.stat, x.ep, x.dps_per_unit);
            }
        }
        Cmd::Mc { build, level, mh, oh, race, fights, seed } => {
            let b = builds.iter().find(|b| b.name == build).ok_or_else(|| anyhow::anyhow!("unknown build {build:?}"))?;
            let mh = find_item(&file.items, &mh)?;
            let oh = oh.as_deref().map(|q| find_item(&file.items, q)).transpose()?;
            let prep = model::Prepared::new(&rules, &file.abilities, b, level, race.as_deref(), None);
            let x = model::Extra::default();
            let a = prep.evaluate(mh, oh, &x);
            let m = mc::simulate(&prep, mh, oh, &x, fights, seed).ok_or_else(|| anyhow::anyhow!("main hand is not a weapon"))?;
            println!("{} L{level}: {} / {}", b.name, mh.name, oh.map_or("-", |o| o.name.as_str()));
            println!("  analytic {:.2}   monte carlo {:.2} +/- {:.2} ({} fights)   diff {:+.2}%", a.dps, m.mean, m.sem, m.fights, (m.mean / a.dps - 1.0) * 100.0);
            let an = [a.white_mh, a.white_oh, a.specials, a.extra_swings, a.procs];
            println!("    casts per fight: builders {:.2} (analytic {:.2})   Evis {:.2} (analytic {:.2})", m.parts[5], a.casts.iter().take(3).sum::<f64>(), m.parts[6], a.casts[3]);
            for (i, name) in ["white MH", "white OH", "specials", "extra swings", "procs"].iter().enumerate() {
                println!("    {name:<13} analytic {:7.2}   MC {:7.2}   {:+.2}", an[i], m.parts[i], m.parts[i] - an[i]);
            }
        }
        Cmd::Crosscheck { levels, race, max_tier, top, fights, seed, out } => {
            let filter = search::Filter { race: race.clone(), max_tier, include_gated: false, ..Default::default() };
            let md = mc::crosscheck_md(&rules, &file.abilities, &builds, &file.items, &levels, race.as_deref(), &filter, top, fights, seed);
            print!("{md}");
            if let Some(p) = out {
                std::fs::write(p, md)?;
            }
        }
    }
    Ok(())
}
