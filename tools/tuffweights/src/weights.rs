//! Stat weights by finite differences around a fixed loadout.
//!
//! For each stat we add a small amount through `Extra`, re-run the model and take
//! (perturbed - base) / amount. Normalizing by the AP result gives the usual
//! "equivalent AP" weights (1 AP = 1.0).

use crate::data::Item;
use crate::model::{Extra, Prepared};

pub struct Weight {
    pub stat: &'static str,
    /// Perturbation size used, in the stat's own unit.
    pub delta: f64,
    /// DPS gained per unit of the stat.
    pub dps_per_unit: f64,
    /// `dps_per_unit` divided by DPS per point of Attack Power.
    pub ep: f64,
}

pub struct Weights {
    pub base_dps: f64,
    pub weights: Vec<Weight>,
}

/// The perturbations, as (name, delta, how to apply it).
fn perturbations() -> [(&'static str, f64, fn(&mut Extra, f64)); 8] {
    [
        ("strength", 10.0, |x, d| x.strength = d),
        ("agility", 10.0, |x, d| x.agi = d),
        ("attack_power", 10.0, |x, d| x.ap = d),
        ("crit_pct", 1.0, |x, d| x.crit_pct = d),
        ("hit_pct", 1.0, |x, d| x.hit_pct = d),
        ("weapon_skill", 1.0, |x, d| x.skill = d),
        ("mh_dps", 1.0, |x, d| x.mh_dps = d),
        ("oh_dps", 1.0, |x, d| x.oh_dps = d),
    ]
}

/// Weights around `mh`/`oh`. Off-hand DPS is skipped (weight 0) when no off-hand is worn.
pub fn compute(prep: &Prepared, mh: &Item, oh: Option<&Item>) -> Weights {
    let base = prep.evaluate(mh, oh, &Extra::default()).dps;
    let mut raw: Vec<(&'static str, f64, f64)> = Vec::new();
    for (name, delta, apply) in perturbations() {
        let mut x = Extra::default();
        apply(&mut x, delta);
        let d = if name == "oh_dps" && oh.is_none() { 0.0 } else { (prep.evaluate(mh, oh, &x).dps - base) / delta };
        raw.push((name, delta, d));
    }
    let ap = raw.iter().find(|r| r.0 == "attack_power").map(|r| r.2).unwrap_or(0.0);
    let weights = raw
        .into_iter()
        .map(|(stat, delta, d)| Weight { stat, delta, dps_per_unit: d, ep: if ap > 0.0 { d / ap } else { 0.0 } })
        .collect();
    Weights { base_dps: base, weights }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::load_items;

    #[test]
    fn weights_are_sane() {
        let mut rules = crate::rules::load_rules("rules/era-1.12.toml").unwrap();
        let builds = crate::rules::load_builds("builds").unwrap();
        let f = load_items("../.cache/items.json").unwrap();
        rules.apply_world(&f.world).unwrap();
        let build = builds.iter().find(|b| b.name == "combat_swords").unwrap();
        let mh = f.items.iter().find(|i| i.name == "Sword of Serenity").unwrap();
        let p = Prepared::new(&rules, &f.abilities, build, 45, None, None);
        let w = compute(&p, mh, Some(mh));
        let get = |n: &str| w.weights.iter().find(|x| x.stat == n).unwrap();
        assert!((get("attack_power").ep - 1.0).abs() < 1e-9);
        // Every stat helps, and Strength is worth about one AP (rogue Str -> 1 AP).
        assert!(w.weights.iter().all(|x| x.dps_per_unit >= 0.0));
        assert!(get("strength").ep > 0.9 && get("strength").ep < 1.3);
        // Agility gives AP plus crit, so it beats Strength.
        assert!(get("agility").ep > get("strength").ep);
    }
}
