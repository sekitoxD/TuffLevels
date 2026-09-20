//! Items and ability ranks as exported by tools/export_items.py.
//!
//! The JSON is DB-derived scratch data and never committed; this module only
//! knows the normalized schema, not where the numbers came from.

#![allow(dead_code)] // mirrors the exporter schema; not every field is consumed yet

use serde::Deserialize;
use std::collections::HashMap;

#[derive(Debug, Deserialize)]
pub struct ItemsFile {
    pub meta: Meta,
    pub items: Vec<Item>,
    #[serde(default)]
    pub abilities: HashMap<String, Vec<AbilityRank>>,
    #[serde(default)]
    pub world: World,
}

/// Per-level aggregates from the DB (`[level, value]` rows), see the exporter.
#[derive(Debug, Deserialize, Default)]
pub struct World {
    #[serde(default)]
    pub base_str: Vec<[f64; 2]>,
    #[serde(default)]
    pub base_agi: Vec<[f64; 2]>,
    #[serde(default)]
    pub mob_armor: Vec<[f64; 2]>,
}

#[derive(Debug, Deserialize)]
pub struct Meta {
    pub source: String,
    #[serde(default)]
    pub exported_at: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Item {
    pub id: u32,
    pub name: String,
    #[serde(default)]
    pub quality: u8,
    pub slot: String,
    #[serde(default)]
    pub req_level: u32,
    #[serde(default)]
    pub gate_level: u32,
    #[serde(default)]
    pub bonding: u8,
    #[serde(default)]
    pub req_skill: Option<u32>,
    #[serde(default)]
    pub honor_rank: Option<u32>,
    #[serde(default)]
    pub race_mask: i64,
    #[serde(default)]
    pub class_mask: i64,
    #[serde(default)]
    pub weapon: Option<Weapon>,
    #[serde(default)]
    pub stats: HashMap<String, f64>,
    #[serde(default)]
    pub equip: Option<Equip>,
    #[serde(default)]
    pub procs: Vec<Proc>,
    #[serde(default)]
    pub on_use: Vec<String>,
    #[serde(default)]
    pub sources: Sources,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Weapon {
    pub skill: String,
    pub min: f64,
    pub max: f64,
    pub speed_ms: f64,
    #[serde(default)]
    pub extra_damage: Vec<ExtraDamage>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ExtraDamage {
    pub min: f64,
    pub max: f64,
    #[serde(default)]
    pub school: u32,
}

impl Item {
    /// Effects the model scores as zero: on-use abilities and proc effects other
    /// than extra attacks / direct damage. Short human-readable labels.
    pub fn not_scored(&self) -> Vec<String> {
        let mut v: Vec<String> = self.on_use.iter().map(|n| format!("on-use {n}")).collect();
        for p in &self.procs {
            let mut label = None;
            for e in p.effects.iter().filter(|e| !matches!(e.kind.as_str(), "extra_attack" | "direct_damage") && e.dot().is_none()) {
                // Periodic damage (aura 3) with no known duration: show per-tick size only.
                let detail = match (e.aura, e.value, e.period_ms) {
                    (Some(3), Some(v), Some(ms)) => format!(" (DoT {v:.0} per {:.0}s)", ms / 1000.0),
                    _ => String::new(),
                };
                label.get_or_insert_with(|| format!("proc {}{detail}", p.name));
            }
            v.extend(label);
        }
        v
    }
}

impl Weapon {
    pub fn speed(&self) -> f64 {
        self.speed_ms / 1000.0
    }
    /// Average physical hit, before Attack Power.
    pub fn avg(&self) -> f64 {
        (self.min + self.max) / 2.0
    }
    /// Average non-physical bonus damage lines (elemental "+5 fire" style).
    pub fn avg_extra(&self) -> f64 {
        self.extra_damage.iter().map(|e| (e.min + e.max) / 2.0).sum()
    }
    /// Tooltip damage per second (main damage line only).
    pub fn dps(&self) -> f64 {
        self.avg() / self.speed()
    }
}

#[derive(Debug, Deserialize, Clone, Default)]
pub struct Equip {
    #[serde(default)]
    pub ap: f64,
    #[serde(default)]
    pub crit_pct: f64,
    #[serde(default)]
    pub hit_pct: f64,
    #[serde(default)]
    pub skill: HashMap<String, f64>,
    #[serde(default)]
    pub stats: HashMap<String, f64>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Proc {
    pub spell: u32,
    pub name: String,
    #[serde(default)]
    pub ppm: Option<f64>,
    #[serde(default)]
    pub effects: Vec<ProcEffect>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ProcEffect {
    pub kind: String,
    #[serde(default)]
    pub count: Option<u32>,
    #[serde(default)]
    pub min: Option<f64>,
    #[serde(default)]
    pub max: Option<f64>,
    #[serde(default)]
    pub aura: Option<u32>,
    #[serde(default)]
    pub value: Option<f64>,
    #[serde(default)]
    pub period_ms: Option<f64>,
    #[serde(default)]
    pub school: Option<u32>,
    /// Raw SpellDuration.dbc index from the export.
    #[serde(default)]
    pub duration_index: Option<u32>,
    /// Filled by `Rules::resolve_durations` when the index is in the ruleset's table.
    #[serde(skip)]
    pub duration_s: Option<f64>,
}

impl ProcEffect {
    /// A periodic-damage aura the model can value: `(damage per tick, tick seconds, tick count, school)`.
    pub fn dot(&self) -> Option<(f64, f64, u32, u32)> {
        if self.kind != "aura" || self.aura != Some(3) {
            return None;
        }
        let (v, period, dur) = (self.value?, self.period_ms? / 1000.0, self.duration_s?);
        (v > 0.0 && period > 0.0 && dur > 0.0).then(|| (v, period, (dur / period).round().max(1.0) as u32, self.school.unwrap_or(0)))
    }
}

#[derive(Debug, Deserialize, Clone, Default)]
pub struct Sources {
    #[serde(default)]
    pub quest: Vec<QuestSrc>,
    #[serde(default)]
    pub drop: Vec<DropSrc>,
    #[serde(default)]
    pub vendor: Vec<VendorSrc>,
    #[serde(default)]
    pub craft: Vec<CraftSrc>,
    #[serde(default)]
    pub chest: Vec<ChestSrc>,
}

/// A profession recipe that creates the item.
#[derive(Debug, Deserialize, Clone)]
pub struct CraftSrc {
    pub name: String,
}

/// A world chest that holds the item.
#[derive(Debug, Deserialize, Clone)]
pub struct ChestSrc {
    pub name: String,
    #[serde(default)]
    pub instance: Option<Vec<String>>,
    #[serde(default)]
    pub open_world: Option<bool>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct QuestSrc {
    pub quest: u32,
    pub title: String,
    #[serde(default)]
    pub min_level: u32,
    #[serde(default)]
    pub race_mask: i64,
}

#[derive(Debug, Deserialize, Clone)]
pub struct DropSrc {
    pub name: String,
    #[serde(default)]
    pub level: Vec<u32>,
    #[serde(default)]
    pub chance: f64,
    #[serde(default)]
    pub instance: Option<Vec<String>>,
    #[serde(default)]
    pub world_drop: Option<bool>,
    #[serde(default)]
    pub open_world: Option<bool>,
    /// The creature has no spawn rows (script-summoned boss or dead template).
    #[serde(default)]
    pub unspawned: Option<bool>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct VendorSrc {
    pub name: String,
    #[serde(default)]
    pub limited_stock: bool,
    /// Vendor condition (reputation, quest...), when the item is not freely buyable.
    #[serde(default)]
    pub requires: Option<String>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct AbilityRank {
    #[serde(default)]
    pub rank: u32,
    pub level: u32,
    pub spell: u32,
    pub energy: f64,
    /// Weapon damage part scales AP by normalized weapon speed (true) or by the
    /// weapon's own speed (false, e.g. Hemorrhage).
    #[serde(default = "yes")]
    pub normalized: bool,
    #[serde(default)]
    pub flat: Option<f64>,
    #[serde(default)]
    pub weapon_pct: Option<f64>,
    #[serde(default)]
    pub base_avg: Option<f64>,
    #[serde(default)]
    pub per_cp: Option<f64>,
}

fn yes() -> bool {
    true
}

pub fn load_items(path: &str) -> anyhow::Result<ItemsFile> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| anyhow::anyhow!("cannot read {path}: {e} (run tools/export_items.py first)"))?;
    Ok(serde_json::from_str(&text)?)
}
