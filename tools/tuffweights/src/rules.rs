//! Ruleset and build definitions, all loaded from TOML so the game rules live
//! in data files and never in the Rust code (the Forever ruleset is a sibling
//! file, not a fork).

use serde::Deserialize;
use std::collections::HashMap;
use std::path::Path;

#[derive(Debug, Deserialize)]
pub struct Rules {
    pub name: String,
    pub usable_weapon_types: Vec<String>,
    pub dual_wield_level: u32,
    pub max_level: u32,
    #[serde(default)]
    pub exclude_spells: Vec<u32>,
    pub fight: Fight,
    pub player: Player,
    pub reference_gear: RefGear,
    pub combat: Combat,
    #[serde(default)]
    pub racial_skill: HashMap<String, HashMap<String, f64>>,
    pub talents: HashMap<String, Talent>,
    /// SpellDuration.dbc index -> seconds, see the ruleset file.
    #[serde(default)]
    pub spell_duration_s: HashMap<String, f64>,
}

impl Rules {
    /// Fill `ProcEffect::duration_s` from the duration table so DoT procs can be valued.
    pub fn resolve_durations(&self, items: &mut [crate::data::Item]) {
        for it in items {
            for p in &mut it.procs {
                for e in &mut p.effects {
                    e.duration_s = e.duration_index.and_then(|i| self.spell_duration_s.get(&i.to_string()).copied());
                }
            }
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct Fight {
    pub seconds: f64,
    pub start_energy: f64,
    pub energy_per_sec: f64,
    pub mob_level_delta: i32,
    /// Typical armor of a normal mob, by level (piecewise linear).
    /// Filled from the items export's `world` section (`Rules::apply_world`).
    #[serde(default)]
    pub mob_armor: Vec<[f64; 2]>,
    pub mob_armor_c0: f64,
    pub mob_armor_c1: f64,
    pub magic_taken_factor: f64,
    #[serde(default = "hundred")]
    pub energy_cap: f64,
    /// Seconds between ability decisions (the global cooldown).
    #[serde(default = "one")]
    pub gcd: f64,
}

fn hundred() -> f64 {
    100.0
}

#[derive(Debug, Deserialize)]
pub struct Player {
    pub ap_per_level: f64,
    pub ap_flat: f64,
    pub ap_per_str: f64,
    pub ap_per_agi: f64,
    pub crit_base_pct: f64,
    pub crit_agi_per_pct: Vec<[f64; 2]>,
    /// Filled from the items export's `world` section (`Rules::apply_world`).
    #[serde(default)]
    pub base_str: Vec<[f64; 2]>,
    #[serde(default)]
    pub base_agi: Vec<[f64; 2]>,
}

#[derive(Debug, Deserialize)]
pub struct RefGear {
    pub str_per_level: f64,
    pub agi_per_level: f64,
    pub ap_per_level: f64,
    pub crit_pct: f64,
    pub hit_pct: f64,
}

#[derive(Debug, Deserialize)]
pub struct Combat {
    pub miss_base_pct: f64,
    pub miss_per_skill_low: f64,
    pub miss_per_skill_below: f64,
    pub miss_high_offset: f64,
    pub miss_per_skill_high: f64,
    pub dual_wield_miss_pct: f64,
    pub dodge_base_pct: f64,
    pub dodge_per_skill: f64,
    pub dodge_per_skill_below: f64,
    pub glance_base_pct: f64,
    pub glance_per_skill: f64,
    pub glance_max_pct: f64,
    pub crit_suppression_per_skill: f64,
    pub crit_mult: f64,
    pub oh_damage_mult: f64,
    pub normalized_speed_dagger: f64,
    pub normalized_speed_other: f64,
    pub evis_ap_per_cp: f64,
    pub builder_miss_energy_refund: f64,
    pub default_item_ppm: f64,
}

/// Per-rank talent effects. Every field is optional; absent means 0.
#[derive(Debug, Deserialize, Default, Clone)]
#[serde(default)]
pub struct Talent {
    pub max: u32,
    pub hit_pct: f64,
    pub crit_pct: f64,
    pub crit_pct_dagger: f64,
    pub crit_pct_fist: f64,
    pub crit_dmg_add: f64,
    pub ss_energy_reduction: Vec<f64>,
    pub special_dmg_pct: f64,
    pub evis_dmg_pct: f64,
    pub bs_dmg_pct: f64,
    pub oh_dmg_pct: f64,
    pub sword_extra_attack_pct: f64,
    pub mace_skill: f64,
    pub ap_pct: f64,
    pub energy_bonus_avg: f64,
    pub haste_bonus_avg: f64,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Build {
    pub name: String,
    #[serde(default)]
    pub description: String,
    /// Weapon types this build considers, in addition to the ruleset's usable set.
    pub weapon_types: Vec<String>,
    /// Ordered action-priority list. At each decision point (one per global
    /// cooldown) the first entry that applies (its `when` holds, the ability is
    /// known and usable with the main-hand weapon) IS the action; if its energy
    /// cost is not yet affordable the rogue pools energy and casts nothing this
    /// slot. Use `energy >= N` to let a later entry fire opportunistically.
    /// Authored per build, never searched or optimized.
    pub rotation: Vec<Action>,
    #[serde(default = "one")]
    pub position_fraction: f64,
    pub talents: Vec<String>,
}

/// One line of a build's priority list.
#[derive(Debug, Deserialize, Clone)]
pub struct Action {
    pub ability: Ability,
    #[serde(default)]
    pub when: Option<Cond>,
}

#[derive(Debug, Deserialize, Clone, Copy, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum Ability {
    SinisterStrike,
    Backstab,
    Hemorrhage,
    Eviscerate,
}

/// The whole condition vocabulary, kept deliberately tiny. Written in TOML as
/// `"cp >= 5"`, `"energy >= 40"`, `"positional"` or `"talent:<name>"`.
/// `positional` means "the mob is not facing you"; the analytic model weights it
/// by the build's `position_fraction`, the Monte Carlo rolls it per fight.
#[derive(Debug, Deserialize, Clone, PartialEq)]
#[serde(try_from = "String")]
pub enum Cond {
    CpAtLeast(u32),
    EnergyAtLeast(f64),
    Positional,
    Talent(String),
}

impl TryFrom<String> for Cond {
    type Error = String;

    fn try_from(s: String) -> Result<Self, String> {
        let s = s.trim();
        if s == "positional" {
            return Ok(Cond::Positional);
        }
        if let Some(name) = s.strip_prefix("talent:") {
            return Ok(Cond::Talent(name.trim().to_string()));
        }
        let bad = || format!("unknown condition {s:?} (expected `cp >= N`, `energy >= N`, `positional`, `talent:<name>`)");
        if let Some((lhs, rhs)) = s.split_once(">=") {
            let n = rhs.trim();
            return match lhs.trim() {
                "cp" => n.parse().map(Cond::CpAtLeast).map_err(|_| bad()),
                "energy" => n.parse().map(Cond::EnergyAtLeast).map_err(|_| bad()),
                _ => Err(bad()),
            };
        }
        Err(bad())
    }
}

fn one() -> f64 {
    1.0
}

pub fn load_rules(path: &str) -> anyhow::Result<Rules> {
    let text = std::fs::read_to_string(path)?;
    Ok(toml::from_str(&text)?)
}

impl Rules {
    /// Merge the DB-derived per-level tables from the items export. They are
    /// deliberately absent from the committed TOML (GPL rule, see tools/qdb.py).
    pub fn apply_world(&mut self, w: &crate::data::World) -> anyhow::Result<()> {
        if w.base_str.is_empty() || w.base_agi.is_empty() || w.mob_armor.is_empty() {
            anyhow::bail!("items export has no `world` tables; re-run `python3 tools/export_items.py`");
        }
        self.player.base_str = w.base_str.clone();
        self.player.base_agi = w.base_agi.clone();
        self.fight.mob_armor = w.mob_armor.clone();
        Ok(())
    }
}

/// Rules with small fixed `world` tables, for tests that use synthetic items.
#[cfg(test)]
pub fn test_rules() -> Rules {
    let mut r = load_rules(concat!(env!("CARGO_MANIFEST_DIR"), "/rules/era-1.12.toml")).unwrap();
    r.player.base_str = vec![[1.0, 21.0], [60.0, 80.0]];
    r.player.base_agi = vec![[1.0, 23.0], [60.0, 130.0]];
    r.fight.mob_armor = vec![[1.0, 15.0], [10.0, 510.0], [30.0, 1200.0], [60.0, 3790.0]];
    r
}

pub fn load_builds(dir: &str) -> anyhow::Result<Vec<Build>> {
    let mut out = Vec::new();
    let mut paths: Vec<_> = std::fs::read_dir(Path::new(dir))?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().map(|x| x == "toml").unwrap_or(false))
        .collect();
    paths.sort();
    for p in paths {
        let text = std::fs::read_to_string(&p)?;
        out.push(toml::from_str::<Build>(&text).map_err(|e| anyhow::anyhow!("{}: {e}", p.display()))?);
    }
    Ok(out)
}

impl Build {
    /// Catch authoring typos at load time: empty rotation, or a `talent:` condition
    /// or talent-list entry that the ruleset does not define.
    pub fn validate(&self, rules: &Rules) -> anyhow::Result<()> {
        if self.rotation.is_empty() {
            anyhow::bail!("build {}: rotation is empty", self.name);
        }
        for t in &self.talents {
            if !rules.talents.contains_key(t) {
                anyhow::bail!("build {}: unknown talent {t:?}", self.name);
            }
        }
        for a in &self.rotation {
            if let Some(Cond::Talent(t)) = &a.when {
                if !rules.talents.contains_key(t) {
                    anyhow::bail!("build {}: rotation condition names unknown talent {t:?}", self.name);
                }
            }
        }
        Ok(())
    }
}

/// Piecewise-linear interpolation over `[x, y]` anchors (clamped at the ends).
pub fn interp(table: &[[f64; 2]], x: f64) -> f64 {
    if table.is_empty() {
        return 0.0;
    }
    if x <= table[0][0] {
        return table[0][1];
    }
    for w in table.windows(2) {
        if x <= w[1][0] {
            let t = (x - w[0][0]) / (w[1][0] - w[0][0]);
            return w[0][1] + t * (w[1][1] - w[0][1]);
        }
    }
    table[table.len() - 1][1]
}

/// Spend `level - 9` talent points down the build's list, ignoring tier gating.
pub fn allocate_talents(build: &Build, rules: &Rules, level: u32) -> HashMap<String, u32> {
    let mut left = level.saturating_sub(9);
    let mut out = HashMap::new();
    for name in &build.talents {
        if left == 0 {
            break;
        }
        if let Some(t) = rules.talents.get(name) {
            let n = t.max.min(left);
            out.insert(name.clone(), n);
            left -= n;
        }
    }
    out
}
