//! Armor, jewelry and cloaks valued in the same currency as weapons: percent DPS.
//!
//! An item's stats are valued with the model's finite-difference stat weights around a
//! reference loadout ([`StatValue`]). What it adds is then measured against the best item
//! that you could plan on and that is easier to get (`Tier::baseline_cap`; the second best for
//! rings and trinkets), so a vendor belt is judged against other vendor belts and a dungeon
//! reward against everything you could have picked up without a dungeon.

use crate::data::Item;
use crate::model::Prepared;
use crate::search::{faction_ok, race_bit, tier_of, Filter, Tier, ROGUE_CLASS_BIT};
use crate::weights;
use std::collections::HashMap;

/// DPS per unit of each stat around one reference loadout, plus how weapon-skill bonuses split.
pub struct StatValue {
    pub base_dps: f64,
    dpu: HashMap<&'static str, f64>,
    mh_skill: Option<String>,
    oh_skill: Option<String>,
    single_hand: bool,
}

impl StatValue {
    pub fn around(prep: &Prepared, mh: &Item, oh: Option<&Item>) -> StatValue {
        let w = weights::compute(prep, mh, oh);
        StatValue {
            base_dps: w.base_dps,
            dpu: w.weights.iter().map(|x| (x.stat, x.dps_per_unit)).collect(),
            mh_skill: mh.weapon.as_ref().map(|w| w.skill.clone()),
            oh_skill: oh.and_then(|o| o.weapon.as_ref()).map(|w| w.skill.clone()),
            single_hand: oh.is_none(),
        }
    }

    fn dpu(&self, stat: &str) -> f64 {
        self.dpu.get(stat).copied().unwrap_or(0.0)
    }

    /// Item skill bonuses are per weapon type; credit the share of damage from hands using that type.
    fn skill_share(&self, k: &str) -> f64 {
        let hit = |s: &Option<String>| s.as_deref().is_some_and(|s| s == k || (s == "fist" && k == "unarmed"));
        (if hit(&self.mh_skill) { 0.6 } else { 0.0 }) + (if hit(&self.oh_skill) || (self.single_hand && hit(&self.mh_skill)) { 0.4 } else { 0.0 })
    }

    /// DPS an armor-slot item adds through its stats.
    pub fn gain(&self, i: &Item) -> f64 {
        armor_gain(i, &|k| self.dpu(k), &|k| self.skill_share(k))
    }
}

/// DPS an armor-slot item adds through its stats, given DPS per unit of each stat.
pub fn armor_gain(i: &Item, dpu: &dyn Fn(&str) -> f64, skill_share: &dyn Fn(&str) -> f64) -> f64 {
    let s = |k: &str| i.stats.get(k).copied().unwrap_or(0.0);
    let e = i.equip.as_ref();
    let es = |k: &str| e.and_then(|e| e.stats.get(k)).copied().unwrap_or(0.0);
    let mut g = (s("str") + es("str")) * dpu("strength") + (s("agi") + es("agi")) * dpu("agility");
    if let Some(e) = e {
        g += e.ap * dpu("attack_power") + e.crit_pct * dpu("crit_pct") + e.hit_pct * dpu("hit_pct");
        g += e.skill.iter().map(|(k, v)| v * skill_share(k)).sum::<f64>() * dpu("weapon_skill");
    }
    g
}

/// Slots that hold two items, so the baseline is the second best.
pub fn slot_count(slot: &str) -> usize {
    if matches!(slot, "finger" | "trinket") {
        2
    } else {
        1
    }
}

/// Armor-slot items a rogue could wear at all, before any level check.
pub fn wearable(i: &Item, f: &Filter) -> bool {
    i.weapon.is_none()
        && (i.class_mask == 0 || i.class_mask & ROGUE_CLASS_BIT != 0)
        && f.race.as_deref().and_then(race_bit).map_or(true, |b| i.race_mask == 0 || i.race_mask & b != 0)
        && (f.include_gated || (i.honor_rank.is_none() && i.req_skill.is_none()))
        && f.faction.map_or(true, |m| faction_ok(i, m))
}

/// DPS the slot's baseline would add for `item`: the best (second best for two-slot gear) wearable
/// item at `level` that is `tier <= cap`, is not `item` itself and is not in `exclude`.
pub fn slot_baseline(items: &[Item], item: &Item, level: u32, cap: Tier, exclude: &[u32], f: &Filter, value: &StatValue) -> f64 {
    let n = slot_count(&item.slot);
    let mut gains: Vec<f64> = items
        .iter()
        .filter(|i| i.slot == item.slot && i.id != item.id && i.gate_level <= level && wearable(i, f) && tier_of(i) <= cap && !exclude.contains(&i.id))
        .map(|i| value.gain(i))
        .collect();
    gains.sort_by(|a, b| b.total_cmp(a));
    gains.get(n - 1).copied().unwrap_or(0.0).max(0.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn item(json: serde_json::Value) -> Item {
        serde_json::from_value(json).unwrap()
    }

    #[test]
    fn armor_gain_values_stats_by_weight() {
        let ring = item(serde_json::json!({
            "id": 1, "name": "Ring", "slot": "finger",
            "stats": {"agi": 5.0, "sta": 9.0}, "equip": {"ap": 10.0, "crit_pct": 1.0, "skill": {"dagger": 2.0}}
        }));
        let dpu = |n: &str| match n {
            "agility" => 2.0,
            "attack_power" => 1.0,
            "crit_pct" => 10.0,
            "weapon_skill" => 3.0,
            _ => 0.0,
        };
        // 5 Agi x 2 + 10 AP x 1 + 1 crit x 10 + (2 dagger skill x 0.5 share) x 3; Stamina is not scored.
        let g = armor_gain(&ring, &dpu, &|k| if k == "dagger" { 0.5 } else { 0.0 });
        assert!((g - 33.0).abs() < 1e-9, "{g}");
    }

    #[test]
    fn baseline_uses_only_items_as_easy_or_easier() {
        let mut vendor = item(serde_json::json!({"id": 1, "name": "V", "slot": "waist", "gate_level": 1, "stats": {"agi": 2.0}}));
        vendor.sources.vendor = vec![crate::data::VendorSrc { name: "v".into(), limited_stock: false, requires: None }];
        let mut dungeon = item(serde_json::json!({"id": 2, "name": "D", "slot": "waist", "gate_level": 1, "stats": {"agi": 10.0}}));
        dungeon.sources.quest = vec![crate::data::QuestSrc { quest: 9, title: "q".into(), min_level: 1, race_mask: 0, effort: "dungeon".into(), chain: 1 }];
        let subject = item(serde_json::json!({"id": 3, "name": "S", "slot": "waist", "gate_level": 1, "stats": {"agi": 5.0}}));
        let items = vec![vendor, dungeon, subject.clone()];
        let value = StatValue { base_dps: 100.0, dpu: HashMap::from([("agility", 1.0)]), mh_skill: None, oh_skill: None, single_hand: true };
        let f = Filter::default();
        // Against vendor gear only the +2 Agi belt counts; against dungeon gear the +10 belt does.
        assert!((slot_baseline(&items, &subject, 10, Tier::QuestSolo, &[], &f, &value) - 2.0).abs() < 1e-9);
        assert!((slot_baseline(&items, &subject, 10, Tier::QuestDungeon, &[], &f, &value) - 10.0).abs() < 1e-9);
        // Items the quest itself hands out are left out.
        assert!((slot_baseline(&items, &subject, 10, Tier::QuestDungeon, &[2], &f, &value) - 2.0).abs() < 1e-9);
    }
}
