//! Monte Carlo cross-check of the analytic model.
//!
//! Plays the same fight the analytic `Prepared::evaluate` describes, but stochastically:
//! every swing and special rolls the attack table, combo points are integers, energy is
//! spent for real, procs and Sword Specialization roll per landed hit, and white swings
//! run on their own timers. Both models share `Prepared::context` (attack-table chances,
//! damage per hit, stats), so a gap between them is a gap in the *fight logic* (expected
//! combo points, pooling, extra-attack accounting), not in the game constants.
//!
//! Deliberate matches with the analytic model, so differences stay attributable:
//! Adrenaline Rush / Blade Flurry are their averaged bonuses (not timed cooldowns), extra
//! swings and procs do not chain, and a finisher consumes its combo points even on a miss.
//! The `positional` condition is rolled per decision with the build's `position_fraction`.

use crate::data::Item;
use crate::model::{dot_factor, AbilityTable, Ctx, Extra, Hand, Prepared};
use crate::rules::{Ability, Build, Cond, Rules};
use crate::search::{self, Filter};
use std::fmt::Write as _;
use rayon::prelude::*;

/// xoshiro256** seeded through splitmix64: small, fast, reproducible, no dependencies.
pub struct Rng([u64; 4]);

impl Rng {
    pub fn new(seed: u64) -> Self {
        let mut z = seed;
        let mut next = || {
            z = z.wrapping_add(0x9E37_79B9_7F4A_7C15);
            let mut x = z;
            x = (x ^ (x >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
            x = (x ^ (x >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
            x ^ (x >> 31)
        };
        Rng([next(), next(), next(), next()])
    }

    fn u64(&mut self) -> u64 {
        let s = &mut self.0;
        let r = s[1].wrapping_mul(5).rotate_left(7).wrapping_mul(9);
        let t = s[1] << 17;
        s[2] ^= s[0];
        s[3] ^= s[1];
        s[1] ^= s[2];
        s[0] ^= s[3];
        s[2] ^= t;
        s[3] = s[3].rotate_left(45);
        r
    }

    /// Uniform in [0, 1).
    pub fn f64(&mut self) -> f64 {
        (self.u64() >> 11) as f64 / (1u64 << 53) as f64
    }

    fn chance(&mut self, p: f64) -> bool {
        self.f64() < p
    }
}

#[derive(Debug, Clone, Copy)]
pub struct McResult {
    pub mean: f64,
    /// Standard error of the mean, over fights.
    pub sem: f64,
    pub fights: usize,
    /// Mean DPS by source (white MH, white OH, specials, extra swings, procs).
    pub parts: Parts,
}

/// One landed weapon hit's side effects: Sword Specialization and item procs. Returns the
/// extra swings earned per hand `[mh, oh]`, and adds direct-damage procs to `dmg`.
fn on_hit(p: &Prepared, item: &Item, hand: &Hand, is_mh: bool, extra: &mut [u32; 2], dmg: &mut f64, dots: &mut Vec<Dot>, t: f64, rng: &mut Rng) {
    let rules = p.rules();
    let n = if is_mh { 0 } else { 1 };
    let w = item.weapon.as_ref().unwrap();
    if w.skill == "sword" && rng.chance(p.talents().sword_extra / 100.0) {
        extra[n] += 1;
    }
    for (pi, pr) in item.procs.iter().enumerate() {
        let ppm = pr.ppm.filter(|v| *v > 0.0).unwrap_or(rules.combat.default_item_ppm);
        if !rng.chance(ppm * hand.speed / 60.0) {
            continue;
        }
        for (ei, e) in pr.effects.iter().enumerate() {
            if let Some((tick, period, count, school)) = e.dot() {
                // A new proc replaces the running DoT: bank its ticks so far, then restart it.
                let key = (n, pi, ei);
                let fresh = Dot { key, t0: t, tick: tick * dot_factor(rules, school), period, count };
                match dots.iter_mut().find(|d| d.key == key) {
                    Some(d) => {
                        *dmg += d.ticks_until(t);
                        *d = fresh;
                    }
                    None => dots.push(fresh),
                }
                continue;
            }
            match e.kind.as_str() {
                "extra_attack" => extra[n] += e.count.unwrap_or(1),
                "direct_damage" => *dmg += (e.min.unwrap_or(0.0) + e.max.unwrap_or(0.0)) / 2.0 * rules.fight.magic_taken_factor,
                _ => {}
            }
        }
    }
}

/// A running periodic-damage effect from a weapon proc.
struct Dot {
    key: (usize, usize, usize),
    t0: f64,
    tick: f64,
    period: f64,
    count: u32,
}

impl Dot {
    /// Damage of the ticks that have landed by `until` (call once, when the DoT ends or is replaced).
    fn ticks_until(&self, until: f64) -> f64 {
        let landed = ((until - self.t0) / self.period).floor().clamp(0.0, self.count as f64);
        landed * self.tick
    }
}

/// Damage of one white swing (0 on a miss/dodge); reports whether it landed.
fn swing(p: &Prepared, h: &Hand, rng: &mut Rng) -> (f64, bool) {
    let u = rng.f64();
    let miss = 1.0 - h.land;
    if u < miss {
        return (0.0, false);
    }
    let crit_mult = p.rules().combat.crit_mult;
    let v = u - miss;
    let d = if v < h.p_glance {
        h.phys * h.g_mult
    } else if v < h.p_glance + h.p_crit {
        h.phys * crit_mult
    } else {
        h.phys
    };
    (d + h.magic, true)
}

/// Damage per second by source (white MH, white OH, specials, extra swings, procs),
/// then builder casts and Eviscerate casts per fight.
pub type Parts = [f64; 7];

fn one_fight(p: &Prepared, cx: &Ctx, rng: &mut Rng) -> Parts {
    let rules = p.rules();
    let fight = &rules.fight;
    let c = &rules.combat;
    let mh_speed = cx.mh_hand.speed / (1.0 + p.talents().haste);
    let oh_speed = cx.oh_hand.as_ref().map(|h| h.speed / (1.0 + p.talents().haste));
    // Random swing phase so a fight holds T/speed swings on average, like the analytic rate.
    let mut mh_t = rng.f64() * mh_speed;
    let mut oh_t = oh_speed.map_or(f64::INFINITY, |s| rng.f64() * s);
    let regen = fight.energy_per_sec * (1.0 + p.talents().energy_bonus) * fight.gcd;
    let slots = ((fight.seconds / fight.gcd).floor() as usize).max(1);
    let mut slot = 0usize;
    let mut energy = fight.start_energy.min(fight.energy_cap);
    let mut cp = 0u32;
    let mut parts: Parts = [0.0; 7];
    let mut dots: Vec<Dot> = Vec::new();
    let evis_crit_mult = c.crit_mult;
    let builders_crit = c.crit_mult + p.talents().lethality;

    loop {
        let slot_t = if slot < slots { slot as f64 * fight.gcd } else { f64::INFINITY };
        let t = mh_t.min(oh_t).min(slot_t);
        if t >= fight.seconds || !t.is_finite() {
            break;
        }
        let mut extra = [0u32; 2];
        if t == slot_t {
            if slot > 0 {
                energy = (energy + regen).min(fight.energy_cap);
            }
            slot += 1;
            let positional = rng.chance(p.build().position_fraction.min(1.0));
            let chosen = p.build().rotation.iter().find(|act| {
                if !p.usable(cx, act.ability) {
                    return false;
                }
                match &act.when {
                    None => true,
                    Some(Cond::CpAtLeast(n)) => cp >= *n,
                    Some(Cond::EnergyAtLeast(n)) => energy >= *n,
                    Some(Cond::Positional) => positional,
                    Some(Cond::Talent(name)) => p.has_talent(name),
                }
            });
            if let Some(act) = chosen {
                if act.ability == Ability::Eviscerate {
                    let cost = p.evis_cost().unwrap_or(0.0);
                    if cp >= 1 && energy >= cost {
                        let landed = rng.chance(cx.p_land);
                        energy -= if landed { cost } else { cost * (1.0 - c.builder_miss_energy_refund) };
                        if landed {
                            let crit = if rng.chance(cx.crit_plain) { evis_crit_mult } else { 1.0 };
                            parts[2] += p.evis_raw(cx, cp as f64) * crit;
                        }
                        cp = 0;
                        parts[6] += 1.0;
                    }
                } else if let Some((cost, raw, _)) = p.builder_parts(cx, act.ability) {
                    if energy >= cost {
                        let landed = rng.chance(cx.p_land);
                        parts[5] += 1.0;
                        energy -= if landed { cost } else { cost * (1.0 - c.builder_miss_energy_refund) };
                        if landed {
                            let crit = if rng.chance(cx.crit_weapon) { builders_crit } else { 1.0 };
                            parts[2] += raw * crit;
                            cp = (cp + 1).min(5);
                            on_hit(p, cx.mh, &cx.mh_hand, true, &mut extra, &mut parts[4], &mut dots, t, rng);
                        }
                    }
                }
            }
        } else if t == mh_t {
            mh_t += mh_speed;
            let (d, landed) = swing(p, &cx.mh_hand, rng);
            parts[0] += d;
            if landed {
                on_hit(p, cx.mh, &cx.mh_hand, true, &mut extra, &mut parts[4], &mut dots, t, rng);
            }
        } else {
            let (Some(h), Some(item), Some(s)) = (cx.oh_hand.as_ref(), cx.oh, oh_speed) else { break };
            oh_t += s;
            let (d, landed) = swing(p, h, rng);
            parts[1] += d;
            if landed {
                on_hit(p, item, h, false, &mut extra, &mut parts[4], &mut dots, t, rng);
            }
        }
        // Extra swings resolve at once and never chain (no on-hit effects).
        for _ in 0..extra[0] {
            parts[3] += swing(p, &cx.mh_hand, rng).0;
        }
        if let Some(h) = cx.oh_hand.as_ref() {
            for _ in 0..extra[1] {
                parts[3] += swing(p, h, rng).0;
            }
        }
    }
    parts[4] += dots.iter().map(|d| d.ticks_until(fight.seconds)).sum::<f64>();
    let mut out = parts.map(|v| v / fight.seconds);
    out[5] = parts[5];
    out[6] = parts[6];
    out
}

/// Mean DPS over `fights` independent fights (parallel, reproducible for a given seed).
pub fn simulate(p: &Prepared, mh: &Item, oh: Option<&Item>, x: &Extra, fights: usize, seed: u64) -> Option<McResult> {
    let cx = p.context(mh, oh, x)?;
    const BATCH: usize = 1000;
    let batches = fights.div_ceil(BATCH);
    // (sum, sum of squares, count) per batch, combined below.
    let parts: Vec<(f64, f64, usize, Parts)> = (0..batches)
        .into_par_iter()
        .map(|b| {
            let mut rng = Rng::new(seed ^ (b as u64).wrapping_mul(0x9E37_79B9_7F4A_7C15));
            let n = BATCH.min(fights - b * BATCH);
            let (mut s, mut q, mut ps) = (0.0, 0.0, [0.0; 7]);
            for _ in 0..n {
                let f = one_fight(p, &cx, &mut rng);
                let d: f64 = f[..5].iter().sum();
                s += d;
                q += d * d;
                for (a, b) in ps.iter_mut().zip(f) {
                    *a += b;
                }
            }
            (s, q, n, ps)
        })
        .collect();
    let n: usize = parts.iter().map(|x| x.2).sum();
    let s: f64 = parts.iter().map(|x| x.0).sum();
    let q: f64 = parts.iter().map(|x| x.1).sum();
    let mut parts_mean = [0.0; 7];
    for b in &parts {
        for (a, v) in parts_mean.iter_mut().zip(b.3) {
            *a += v / n as f64;
        }
    }
    let mean = s / n as f64;
    let var = (q / n as f64 - mean * mean).max(0.0) * n as f64 / (n as f64 - 1.0).max(1.0);
    Some(McResult { mean, sem: (var / n as f64).sqrt(), fights: n, parts: parts_mean })
}

/// Markdown table: the analytic top loadouts of each build at `levels`, replayed by Monte Carlo.
/// `rank` columns show whether the stochastic order agrees with the analytic one.
#[allow(clippy::too_many_arguments)]
pub fn crosscheck_md(
    rules: &Rules,
    abilities: &AbilityTable,
    builds: &[Build],
    items: &[Item],
    levels: &[u32],
    race: Option<&str>,
    filter: &Filter,
    top: usize,
    fights: usize,
    seed: u64,
) -> String {
    let mut s = format!(
        "# Monte Carlo cross-check\n\n{fights} fights per loadout, seed {seed}. `diff` is MC vs analytic; `z` is the gap in standard errors (|z| > 3 is a real disagreement, not noise). `order` compares the MC ranking of the loadouts with the analytic one.\n"
    );
    let mut worst = (0.0_f64, String::new());
    let (mut rows, mut order_bad, mut groups) = (0usize, 0usize, 0usize);
    for &level in levels {
        for b in builds {
            let r = search::search(rules, abilities, b, items, level, race, filter, top);
            if r.top.is_empty() {
                continue;
            }
            let prep = Prepared::new(rules, abilities, b, level, race, None);
            let x = Extra::default();
            let _ = write!(s, "\n## {} L{level}\n\n| loadout | analytic | MC | +/- | diff | z |\n|---|---|---|---|---|---|\n", b.name);
            let mut mcs = Vec::new();
            for (i, l) in r.top.iter().enumerate() {
                let Some(m) = simulate(&prep, l.mh, l.oh, &x, fights, seed.wrapping_add(i as u64 * 7919)) else { continue };
                let diff = (m.mean / l.dps - 1.0) * 100.0;
                let z = (m.mean - l.dps) / m.sem.max(1e-9);
                if diff.abs() > worst.0.abs() {
                    worst = (diff, format!("{} L{level} {}", b.name, l.mh.name));
                }
                let _ = writeln!(s, "| {} / {} | {:.2} | {:.2} | {:.2} | {:+.2}% | {:+.1} |", l.mh.name, l.oh.map_or("-", |o| o.name.as_str()), l.dps, m.mean, m.sem, diff, z);
                mcs.push(m.mean);
                rows += 1;
            }
            // Only flag order changes larger than the noise: analytic gaps under 2 SE are ties.
            let bad = mcs.windows(2).zip(r.top.windows(2)).any(|(m, a)| m[1] > m[0] * 1.002 && a[0].dps > a[1].dps * 1.002);
            groups += 1;
            if bad {
                order_bad += 1;
            }
            let _ = writeln!(s, "\norder: {}", if bad { "MC reorders these loadouts (gap > 0.2%)" } else { "agrees" });
        }
    }
    let _ = write!(s, "\n## Summary\n\n{rows} loadouts, worst diff {:+.2}% ({}); MC reorders {order_bad} of {groups} groups.\n", worst.0, worst.1);
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rng_is_uniform_and_reproducible() {
        let mut a = Rng::new(7);
        let mut b = Rng::new(7);
        let xs: Vec<f64> = (0..20000).map(|_| a.f64()).collect();
        assert!(xs.iter().zip((0..20000).map(|_| b.f64())).all(|(x, y)| *x == y));
        let mean = xs.iter().sum::<f64>() / xs.len() as f64;
        assert!((mean - 0.5).abs() < 0.01, "mean {mean}");
        assert!(xs.iter().all(|x| (0.0..1.0).contains(x)));
    }

    /// The analytic model and the simulation share their inputs, so they must agree to within
    /// noise; a gap means the closed-form rotation or extra-attack accounting drifted.
    #[test]
    fn simulation_matches_analytic() {
        // Requires the (gitignored, DB-derived) export; fails loudly rather than
        // silently passing when it is absent (`tools/export_items.py` generates it).
        let mut file = crate::data::load_items("../.cache/items.json").unwrap();
        let mut rules = crate::rules::load_rules("rules/era-1.12.toml").unwrap();
        rules.apply_world(&std::mem::take(&mut file.world)).unwrap();
        rules.resolve_durations(&mut file.items);
        let builds = crate::rules::load_builds("builds").unwrap();
        let find = |n: &str| file.items.iter().find(|i| i.name == n).unwrap();
        let cases = [("combat_swords", 45, "Thrash Blade", "Blade of Reckoning"), ("dagger_assassination", 50, "Barman Shanker", "Shadowblade"), ("combat_fist", 45, "Bloodrazor", "Blackvenom Blade")];
        for (b, level, mh, oh) in cases {
            let build = builds.iter().find(|x| x.name == b).unwrap();
            let p = Prepared::new(&rules, &file.abilities, build, level, None, None);
            let x = Extra::default();
            let a = p.evaluate(find(mh), Some(find(oh)), &x).dps;
            let m = simulate(&p, find(mh), Some(find(oh)), &x, 100_000, 3).unwrap();
            assert!((m.mean - a).abs() < 5.0 * m.sem + 0.002 * a, "{b} L{level}: analytic {a:.2} vs MC {:.2} +/- {:.2}", m.mean, m.sem);
        }
    }
}
