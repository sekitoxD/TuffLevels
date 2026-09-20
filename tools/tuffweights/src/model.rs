//! Expected-DPS model for one fight at one level.
//!
//! Everything numeric comes from `Rules` (game constants), `Build` (talent order and
//! the priority list) and the item/ability tables; nothing game-specific is typed here.
//!
//! Shape of one evaluation:
//!   * White hits: single-roll attack table (miss, dodge, glance, crit, hit) per hand.
//!   * Specials: two-roll table (miss/dodge first, then crit), driven by the build's
//!     priority list, one decision per global cooldown, energy-limited, with combo
//!     points tracked as an expected (fractional) value.
//!   * Extra attacks (Sword Specialization, item procs) as additional swings of the
//!     hand that triggered them; they do not chain.
//!   * Direct-damage procs as ppm x average damage. Periodic-damage aura procs (DoTs) are valued from their duration; other aura procs are not modelled and
//!     are reported in `Eval::unmodelled` so they are never silently scored as zero.

use crate::data::{AbilityRank, Item, Weapon};
use crate::rules::{interp, Ability, Build, Combat, Cond, Fight, Rules, Talent};
use std::collections::HashMap;
use std::sync::{Arc, RwLock};

pub type AbilityTable = HashMap<String, Vec<AbilityRank>>;

const ABILITIES: [Ability; 4] = [
    Ability::SinisterStrike,
    Ability::Backstab,
    Ability::Hemorrhage,
    Ability::Eviscerate,
];

fn idx(a: Ability) -> usize {
    match a {
        Ability::SinisterStrike => 0,
        Ability::Backstab => 1,
        Ability::Hemorrhage => 2,
        Ability::Eviscerate => 3,
    }
}

fn table_key(a: Ability) -> &'static str {
    match a {
        Ability::SinisterStrike => "Sinister Strike",
        Ability::Backstab => "Backstab",
        Ability::Hemorrhage => "Hemorrhage",
        Ability::Eviscerate => "Eviscerate",
    }
}

/// A small perturbation applied on top of a loadout; this is how weights are
/// derived (finite differences) and how "what if" queries are asked.
#[derive(Debug, Clone, Copy, Default)]
pub struct Extra {
    pub strength: f64,
    pub agi: f64,
    pub ap: f64,
    pub crit_pct: f64,
    pub hit_pct: f64,
    /// Weapon skill added to every weapon type.
    pub skill: f64,
    /// Added to the main-hand / off-hand weapon's damage per second at fixed speed.
    pub mh_dps: f64,
    pub oh_dps: f64,
}

#[derive(Debug, Clone, Default)]
pub struct Eval {
    pub dps: f64,
    pub white_mh: f64,
    pub white_oh: f64,
    pub specials: f64,
    pub extra_swings: f64,
    pub procs: f64,
    pub ap: f64,
    /// Crit chance before weapon-type talents and suppression, percent.
    pub crit_pct: f64,
    pub hit_pct: f64,
    pub yellow_miss_pct: f64,
    /// Expected casts per fight, indexed like `ABILITIES` (SS, BS, HM, Evis).
    pub casts: [f64; 4],
    /// Spell ids of item procs the model could not value (auras and the like).
    pub unmodelled: Vec<u32>,
}

impl Eval {
    pub fn casts_of(&self, a: Ability) -> f64 {
        self.casts[idx(a)]
    }
}

// ---------------------------------------------------------------------------
// Pure formula helpers (unit-tested against the public formula documentation)
// ---------------------------------------------------------------------------

/// `(weapon + AP/14 * normalized speed + flat) * weapon_pct`. Covers Sinister
/// Strike (pct 1.0), Backstab (1.5), Ambush (2.5) and Hemorrhage.
pub fn weapon_ability_damage(rank: &AbilityRank, weapon_avg: f64, ap: f64, norm_speed: f64) -> f64 {
    (weapon_avg + ap / 14.0 * norm_speed + rank.flat.unwrap_or(0.0)) * rank.weapon_pct.unwrap_or(1.0)
}

/// `base_avg + per_cp * CP + ap_per_cp * AP * CP`.
pub fn eviscerate_damage(rank: &AbilityRank, cp: f64, ap: f64, ap_per_cp: f64) -> f64 {
    rank.base_avg.unwrap_or(0.0) + rank.per_cp.unwrap_or(0.0) * cp + ap_per_cp * ap * cp
}

/// Base chance (percent) for a white/yellow attack to miss a mob whose defense is
/// `diff` skill points above your weapon skill (may be negative), before hit bonus.
pub fn miss_table(c: &Combat, diff: f64) -> f64 {
    let m = if diff <= 0.0 {
        c.miss_base_pct + c.miss_per_skill_below * diff
    } else if diff <= 10.0 {
        c.miss_base_pct + c.miss_per_skill_low * diff
    } else {
        c.miss_base_pct + c.miss_high_offset + c.miss_per_skill_high * (diff - 10.0)
    };
    m.max(0.0)
}

/// Chance (percent) a mob dodges, `diff` skill points above your weapon skill.
pub fn dodge_table(c: &Combat, diff: f64) -> f64 {
    let slope = if diff > 0.0 { c.dodge_per_skill } else { c.dodge_per_skill_below };
    (c.dodge_base_pct + slope * diff).max(0.0)
}

/// Glancing-blow chance (percent) and average damage multiplier for `diff` >= 0.
pub fn glancing(c: &Combat, diff: f64) -> (f64, f64) {
    let d = diff.max(0.0);
    let chance = (c.glance_base_pct + c.glance_per_skill * d).min(c.glance_max_pct);
    // Chance uses skill capped at the level cap, but the damage penalty uses raw
    // skill: out-skilling the mob (racial/item skill) makes glances full damage.
    if diff < 0.0 {
        return (chance, 1.0);
    }
    let low = (1.3 - 0.05 * d).min(0.91);
    let high = (1.2 - 0.03 * d).min(0.99);
    (chance, (low + high) / 2.0)
}

/// Fraction of physical damage removed by mob armor.
pub fn armor_dr(f: &Fight, player_level: f64, mob_level: f64) -> f64 {
    let armor = interp(&f.mob_armor, mob_level);
    (armor / (armor + f.mob_armor_c0 + f.mob_armor_c1 * player_level)).clamp(0.0, 0.75)
}

// ---------------------------------------------------------------------------
// Per-(level, build) precomputation
// ---------------------------------------------------------------------------

/// Summed per-rank talent effects for one talent allocation.
#[derive(Debug, Default, Clone)]
pub(crate) struct TalentSums {
    hit: f64,
    crit: f64,
    crit_dagger: f64,
    crit_fist: f64,
    pub(crate) lethality: f64,
    special_dmg: f64,
    evis_dmg: f64,
    bs_dmg: f64,
    oh_dmg: f64,
    pub(crate) sword_extra: f64,
    mace_skill: f64,
    ap_pct: f64,
    pub(crate) energy_bonus: f64,
    pub(crate) haste: f64,
    ss_energy_reduction: f64,
    /// Ranks spent per talent name, for `talent:<name>` conditions.
    ranks: HashMap<String, u32>,
}

impl TalentSums {
    fn new(rules: &Rules, build: &Build, level: u32) -> Self {
        let ranks = crate::rules::allocate_talents(build, rules, level);
        let mut s = TalentSums::default();
        for (name, &r) in &ranks {
            let Some(t) = rules.talents.get(name) else { continue };
            let n = r as f64;
            let Talent { hit_pct, crit_pct, crit_pct_dagger, crit_pct_fist, crit_dmg_add, special_dmg_pct, evis_dmg_pct, bs_dmg_pct, oh_dmg_pct, sword_extra_attack_pct, mace_skill, ap_pct, energy_bonus_avg, haste_bonus_avg, .. } = t;
            s.hit += hit_pct * n;
            s.crit += crit_pct * n;
            s.crit_dagger += crit_pct_dagger * n;
            s.crit_fist += crit_pct_fist * n;
            s.lethality += crit_dmg_add * n;
            s.special_dmg += special_dmg_pct * n;
            s.evis_dmg += evis_dmg_pct * n;
            s.bs_dmg += bs_dmg_pct * n;
            s.oh_dmg += oh_dmg_pct * n;
            s.sword_extra += sword_extra_attack_pct * n;
            s.mace_skill += mace_skill * n;
            s.ap_pct += ap_pct * n;
            s.energy_bonus += energy_bonus_avg * n;
            s.haste += haste_bonus_avg * n;
            if r > 0 {
                if let Some(v) = t.ss_energy_reduction.get(r as usize - 1) {
                    s.ss_energy_reduction += v;
                }
            }
        }
        s.ranks = ranks;
        s
    }

    fn spec_crit(&self, weapon_skill: &str) -> f64 {
        match weapon_skill {
            "dagger" => self.crit_dagger,
            "fist" => self.crit_fist,
            _ => 0.0,
        }
    }
}

/// Highest known rank of an ability at `level`, skipping later-patch ranks.
fn pick_rank(table: &AbilityTable, a: Ability, level: u32, exclude: &[u32]) -> Option<AbilityRank> {
    table
        .get(table_key(a))?
        .iter()
        .filter(|r| r.level <= level && !exclude.contains(&r.spell))
        .max_by_key(|r| (r.rank, r.level))
        .cloned()
}

pub struct Prepared<'a> {
    rules: &'a Rules,
    build: &'a Build,
    level: u32,
    mob_level: f64,
    race: Option<&'a str>,
    t: TalentSums,
    ranks: [Option<AbilityRank>; 4],
    dual_wield_ok: bool,
    dr: f64,
    base_str: f64,
    base_agi: f64,
    /// Rotation distributions by (special landing chance, dagger main hand); see `rotation_stats`.
    rot_cache: RwLock<HashMap<(u64, bool), Arc<RotStats>>>,
}

/// Expected casts of one fight, from the exact rotation distribution.
pub(crate) struct RotStats {
    /// Builder casts, indexed like `ABILITIES` (the Eviscerate slot is unused).
    pub builder_casts: [f64; 4],
    /// Eviscerate casts by combo points spent (index 0 is never used).
    pub evis_by_cp: [f64; 6],
    /// Builder casts of all kinds in each global-cooldown slot; the opening energy burst front-loads them.
    pub builder_by_slot: Vec<f64>,
}

/// Values shared by every attack in one evaluation.
struct Stats {
    ap: f64,
    crit_base: f64,
    hit: f64,
}

/// One weapon's white-hit results.
pub(crate) struct Hand {
    pub exp_swing: f64,
    pub swings_ps: f64,
    /// Chance a swing lands (not missed or dodged), 0..1.
    pub land: f64,
    /// Single-roll outcome chances among landed swings' complement (miss/dodge is `1 - land`).
    pub p_glance: f64,
    pub p_crit: f64,
    /// Average glancing damage multiplier.
    pub g_mult: f64,
    /// Physical damage of a normal hit after armor and off-hand penalty.
    pub phys: f64,
    /// Extra elemental damage of a landed hit (already resist-averaged).
    pub magic: f64,
    pub speed: f64,
}

impl<'a> Prepared<'a> {
    pub fn new(
        rules: &'a Rules,
        abilities: &AbilityTable,
        build: &'a Build,
        level: u32,
        race: Option<&'a str>,
        mob_delta: Option<i32>,
    ) -> Self {
        let l = level as f64;
        let mob_level = l + mob_delta.unwrap_or(rules.fight.mob_level_delta) as f64;
        let ranks = ABILITIES.map(|a| pick_rank(abilities, a, level, &rules.exclude_spells));
        Prepared {
            rules,
            build,
            level,
            mob_level,
            race,
            t: TalentSums::new(rules, build, level),
            ranks,
            dual_wield_ok: level >= rules.dual_wield_level,
            dr: armor_dr(&rules.fight, l, mob_level),
            base_str: interp(&rules.player.base_str, l) + rules.reference_gear.str_per_level * l,
            base_agi: interp(&rules.player.base_agi, l) + rules.reference_gear.agi_per_level * l,
            rot_cache: RwLock::new(HashMap::new()),
        }
    }

    pub fn level(&self) -> u32 {
        self.level
    }

    /// Whether a `talent:<name>` condition currently holds.
    pub(crate) fn has_talent(&self, name: &str) -> bool {
        self.t.ranks.get(name).copied().unwrap_or(0) > 0
    }

    /// Total skill bonus over the level cap for weapons of `skill_type`.
    fn skill_bonus(&self, skill_type: &str, items: &[&Item], x: &Extra) -> f64 {
        let racial = self
            .race
            .and_then(|r| self.rules.racial_skill.get(r))
            .and_then(|m| m.get(skill_type))
            .copied()
            .unwrap_or(0.0);
        let from_items: f64 = items
            .iter()
            .filter_map(|i| i.equip.as_ref())
            .filter_map(|e| e.skill.get(skill_type))
            .sum();
        let spec = if skill_type == "mace" { self.t.mace_skill } else { 0.0 };
        racial + from_items + spec + x.skill
    }

    /// Mob defense minus your weapon skill, in skill points (weapon skill is
    /// assumed trained to the level cap of 5 per level).
    fn skill_diff(&self, skill_type: &str, items: &[&Item], x: &Extra) -> f64 {
        5.0 * self.mob_level - (5.0 * self.level as f64 + self.skill_bonus(skill_type, items, x))
    }

    fn hand(&self, s: &Stats, w: &Weapon, dps_extra: f64, is_oh: bool, dual: bool, diff: f64) -> Hand {
        let c = &self.rules.combat;
        let miss = ((miss_table(c, diff) + if dual { c.dual_wield_miss_pct } else { 0.0 }) - s.hit).max(0.0) / 100.0;
        let dodge = dodge_table(c, diff) / 100.0;
        let (g_pct, g_mult) = glancing(c, diff);
        let p_glance = (g_pct / 100.0).min((1.0 - miss - dodge).max(0.0));
        let crit = (s.crit_base + self.t.spec_crit(&w.skill) - c.crit_suppression_per_skill * diff).clamp(0.0, 100.0) / 100.0;
        let p_crit = crit.min((1.0 - miss - dodge - p_glance).max(0.0));
        let p_norm = (1.0 - miss - dodge - p_glance - p_crit).max(0.0);
        let land = (1.0 - miss - dodge).max(0.0);

        let speed = w.speed();
        let avg = w.avg() + dps_extra * speed;
        let mult = if is_oh { c.oh_damage_mult * (1.0 + self.t.oh_dmg / 100.0) } else { 1.0 };
        let phys = (avg + s.ap / 14.0 * speed) * mult * (1.0 - self.dr);
        let magic = w.avg_extra() * mult * self.rules.fight.magic_taken_factor;
        let exp_swing = phys * (p_glance * g_mult + p_crit * c.crit_mult + p_norm) + land * magic;
        Hand { exp_swing, swings_ps: (1.0 + self.t.haste) / speed, land, p_glance, p_crit, g_mult, phys, magic, speed }
    }

    /// Everything one evaluation derives from a loadout before it plays a fight;
    /// shared by the analytic `evaluate` and the Monte Carlo `mc::simulate`.
    pub(crate) fn context<'i>(&self, mh: &'i Item, oh: Option<&'i Item>, x: &Extra) -> Option<Ctx<'i>> {
        let mhw = mh.weapon.as_ref()?;
        let oh = oh.filter(|i| self.dual_wield_ok && i.weapon.is_some());
        let mut items: Vec<&Item> = vec![mh];
        items.extend(oh);

        let rules = self.rules;
        let l = self.level as f64;
        let sum_stat = |k: &str| -> f64 {
            items.iter().map(|i| i.stats.get(k).copied().unwrap_or(0.0) + i.equip.as_ref().and_then(|e| e.stats.get(k)).copied().unwrap_or(0.0)).sum()
        };
        let sum_equip = |f: fn(&crate::data::Equip) -> f64| -> f64 { items.iter().filter_map(|i| i.equip.as_ref()).map(f).sum() };

        let strength = self.base_str + sum_stat("str") + x.strength;
        let agi = self.base_agi + sum_stat("agi") + x.agi;
        let ap_raw = rules.player.ap_per_level * l
            + rules.player.ap_flat
            + strength * rules.player.ap_per_str
            + agi * rules.player.ap_per_agi
            + rules.reference_gear.ap_per_level * l
            + sum_equip(|e| e.ap)
            + x.ap;
        let ap = ap_raw * (1.0 + self.t.ap_pct / 100.0);
        let crit_base = rules.player.crit_base_pct
            + agi / interp(&rules.player.crit_agi_per_pct, l)
            + rules.reference_gear.crit_pct
            + sum_equip(|e| e.crit_pct)
            + self.t.crit
            + x.crit_pct;
        let hit = rules.reference_gear.hit_pct + sum_equip(|e| e.hit_pct) + self.t.hit + x.hit_pct;
        let stats = Stats { ap, crit_base, hit };

        let dual = oh.is_some();
        let mh_diff = self.skill_diff(&mhw.skill, &items, x);
        let mh_hand = self.hand(&stats, mhw, x.mh_dps, false, dual, mh_diff);
        let oh_hand = oh.map(|i| {
            let w = i.weapon.as_ref().unwrap();
            self.hand(&stats, w, x.oh_dps, true, true, self.skill_diff(&w.skill, &items, x))
        });

        // Specials use the yellow table and the main-hand weapon's skill.
        let c = &rules.combat;
        let miss_y = (miss_table(c, mh_diff) - hit).max(0.0) / 100.0;
        let dodge_y = dodge_table(c, mh_diff) / 100.0;
        let crit_supp = c.crit_suppression_per_skill * mh_diff;
        Some(Ctx {
            mh,
            oh,
            mhw,
            ap,
            crit_base,
            hit,
            mh_hand,
            oh_hand,
            p_land: (1.0 - miss_y - dodge_y).max(0.0),
            crit_weapon: ((crit_base + self.t.spec_crit(&mhw.skill) - crit_supp).clamp(0.0, 100.0)) / 100.0,
            crit_plain: ((crit_base - crit_supp).clamp(0.0, 100.0)) / 100.0,
            mh_dagger: mhw.skill == "dagger",
            mh_avg: mhw.avg() + x.mh_dps * mhw.speed(),
            armor: 1.0 - self.dr,
        })
    }

    /// Energy cost and damage-if-it-lands (crit-averaged) of a weapon builder.
    pub(crate) fn builder(&self, cx: &Ctx, a: Ability) -> Option<(f64, f64)> {
        let (cost, raw, crit_mult) = self.builder_parts(cx, a)?;
        Some((cost, raw * (1.0 + cx.crit_weapon * (crit_mult - 1.0))))
    }

    /// Energy cost, non-crit damage and crit multiplier of a weapon builder.
    pub(crate) fn builder_parts(&self, cx: &Ctx, a: Ability) -> Option<(f64, f64, f64)> {
        let c = &self.rules.combat;
        let rank = self.ranks[idx(a)].as_ref()?;
        let norm = if rank.normalized {
            if cx.mh_dagger { c.normalized_speed_dagger } else { c.normalized_speed_other }
        } else {
            cx.mhw.speed()
        };
        let talent_mult = match a {
            Ability::SinisterStrike => 1.0 + self.t.special_dmg / 100.0,
            Ability::Backstab => 1.0 + self.t.bs_dmg / 100.0,
            _ => 1.0,
        };
        let raw = weapon_ability_damage(rank, cx.mh_avg, cx.ap, norm) * talent_mult * cx.armor;
        let cost = if a == Ability::SinisterStrike { (rank.energy - self.t.ss_energy_reduction).max(0.0) } else { rank.energy };
        Some((cost, raw, c.crit_mult + self.t.lethality))
    }

    /// Exact expected casts of a fight: a Markov walk over (combo points, energy) through the
    /// build's priority list, one decision per global cooldown. Only landing chance and whether
    /// Backstab is usable matter (not weapon damage), so results are cached per Prepared.
    fn rotation_stats(&self, cx: &Ctx) -> Arc<RotStats> {
        let key = (cx.p_land.to_bits(), cx.mh_dagger);
        if let Some(r) = self.rot_cache.read().unwrap().get(&key) {
            return r.clone();
        }
        let r = Arc::new(self.compute_rotation(cx));
        self.rot_cache.write().unwrap().insert(key, r.clone());
        r
    }

    fn compute_rotation(&self, cx: &Ctx) -> RotStats {
        let fight = &self.rules.fight;
        let refund = self.rules.combat.builder_miss_energy_refund;
        let pl = cx.p_land;
        let slots = ((fight.seconds / fight.gcd).floor() as usize).max(1);
        let regen = fight.energy_per_sec * (1.0 + self.t.energy_bonus) * fight.gcd;
        let pf = self.build.position_fraction.clamp(0.0, 1.0);
        let q = |e: f64| (e * 1e6).round() as i64;
        let mut out = RotStats { builder_casts: [0.0; 4], evis_by_cp: [0.0; 6], builder_by_slot: vec![0.0; slots] };
        let mut states: HashMap<(u8, i64), f64> = HashMap::new();
        states.insert((0, q(fight.start_energy.min(fight.energy_cap))), 1.0);
        for k in 0..slots {
            let mut next: HashMap<(u8, i64), f64> = HashMap::new();
            let mut push = |cp: u8, e: f64, p: f64| {
                if p > 0.0 {
                    *next.entry((cp, q(e))).or_insert(0.0) += p;
                }
            };
            for (&(cp, ek), &pr) in &states {
                let mut energy = ek as f64 / 1e6;
                if k > 0 {
                    energy = (energy + regen).min(fight.energy_cap);
                }
                for (positional, pp) in [(true, pf), (false, 1.0 - pf)] {
                    let p = pr * pp;
                    if p <= 0.0 {
                        continue;
                    }
                    let chosen = self.build.rotation.iter().find(|act| {
                        if !self.usable(cx, act.ability) {
                            return false;
                        }
                        match &act.when {
                            None => true,
                            Some(Cond::CpAtLeast(n)) => cp as u32 >= *n,
                            Some(Cond::EnergyAtLeast(n)) => energy >= *n,
                            Some(Cond::Positional) => positional,
                            Some(Cond::Talent(name)) => self.has_talent(name),
                        }
                    });
                    let Some(act) = chosen else {
                        push(cp, energy, p);
                        continue;
                    };
                    if act.ability == Ability::Eviscerate {
                        let cost = self.evis_cost().unwrap_or(0.0);
                        if cp < 1 || energy < cost {
                            push(cp, energy, p); // pool
                        } else {
                            out.evis_by_cp[cp as usize] += p;
                            push(0, energy - cost, p * pl);
                            push(0, energy - cost * (1.0 - refund), p * (1.0 - pl));
                        }
                    } else if let Some((cost, _, _)) = self.builder_parts(cx, act.ability) {
                        if energy < cost {
                            push(cp, energy, p); // pool
                        } else {
                            out.builder_casts[idx(act.ability)] += p;
                            out.builder_by_slot[k] += p;
                            push((cp + 1).min(5), energy - cost, p * pl);
                            push(cp, energy - cost * (1.0 - refund), p * (1.0 - pl));
                        }
                    }
                }
            }
            states = next;
        }
        out
    }

    /// Eviscerate energy cost, or None when the rank is unknown.
    pub(crate) fn evis_cost(&self) -> Option<f64> {
        self.ranks[idx(Ability::Eviscerate)].as_ref().map(|r| r.energy)
    }

    /// Non-crit Eviscerate damage at `cp` combo points (0 when unknown).
    pub(crate) fn evis_raw(&self, cx: &Ctx, cp: f64) -> f64 {
        let c = &self.rules.combat;
        let mult = 1.0 + (self.t.special_dmg + self.t.evis_dmg) / 100.0;
        self.ranks[idx(Ability::Eviscerate)]
            .as_ref()
            .map(|r| eviscerate_damage(r, cp, cx.ap, c.evis_ap_per_cp) * mult * cx.armor)
            .unwrap_or(0.0)
    }

    /// Whether the rotation entry may be used by this loadout at all.
    pub(crate) fn usable(&self, cx: &Ctx, a: Ability) -> bool {
        self.ranks[idx(a)].is_some() && !(a == Ability::Backstab && !cx.mh_dagger)
    }

    pub(crate) fn rules(&self) -> &Rules {
        self.rules
    }

    pub(crate) fn build(&self) -> &Build {
        self.build
    }

    pub(crate) fn talents(&self) -> &TalentSums {
        &self.t
    }

    pub fn evaluate(&self, mh: &Item, oh: Option<&Item>, x: &Extra) -> Eval {
        let Some(cx) = self.context(mh, oh, x) else { return Eval::default() };
        let (oh, mh_hand, oh_hand, mhw) = (cx.oh, &cx.mh_hand, &cx.oh_hand, cx.mhw);
        let rules = self.rules;
        let c = &rules.combat;
        let fight = &rules.fight;
        let (p_land, mh_dagger) = (cx.p_land, cx.mh_dagger);

        let mut ev = Eval {
            ap: cx.ap,
            crit_pct: cx.crit_base,
            hit_pct: cx.hit,
            white_mh: mh_hand.swings_ps * mh_hand.exp_swing,
            white_oh: oh_hand.as_ref().map(|h| h.swings_ps * h.exp_swing).unwrap_or(0.0),
            yellow_miss_pct: (1.0 - p_land) * 100.0,
            ..Eval::default()
        };

        let evis_crit = 1.0 + cx.crit_plain * (c.crit_mult - 1.0);
        let dmg_evis = |cp: f64| -> f64 { self.evis_raw(&cx, cp) * evis_crit };

        // Exact distribution of the rotation over integer combo points and energy
        // (see `rotation_stats`), then damage per cast from the loadout.
        let rs = self.rotation_stats(&cx);
        let mut spec_damage = 0.0;
        let mut landed_weapon_hits = 0.0; // landed weapon-based specials (can trigger procs)
        for a in [Ability::SinisterStrike, Ability::Backstab, Ability::Hemorrhage] {
            let casts = rs.builder_casts[idx(a)];
            if casts > 0.0 {
                if let Some((_, dmg)) = self.builder(&cx, a) {
                    spec_damage += casts * p_land * dmg;
                    landed_weapon_hits += casts * p_land;
                }
            }
            ev.casts[idx(a)] = casts;
        }
        for (cp, &casts) in rs.evis_by_cp.iter().enumerate() {
            if casts > 0.0 {
                spec_damage += casts * p_land * dmg_evis(cp as f64);
            }
        }
        ev.casts[idx(Ability::Eviscerate)] = rs.evis_by_cp.iter().sum();
        ev.specials = spec_damage / fight.seconds;
        let special_hits_ps = landed_weapon_hits / fight.seconds;

        // ---- extra attacks and procs -------------------------------------------------
        let mut extra_swing_ps = [0.0_f64; 2];
        let hands: [(Option<&Item>, Option<&Hand>, bool); 2] = [(Some(cx.mh), Some(mh_hand), true), (oh, oh_hand.as_ref(), false)];
        for (n, (item, hand, is_mh)) in hands.iter().enumerate() {
            let (Some(item), Some(hand)) = (item, hand) else { continue };
            let w = item.weapon.as_ref().unwrap();
            // Landing weapon hits per second from this hand (MH also lands its specials).
            let landed_ps = hand.swings_ps * hand.land + if *is_mh { special_hits_ps } else { 0.0 };
            if w.skill == "sword" {
                extra_swing_ps[n] += landed_ps * self.t.sword_extra / 100.0;
            }
            for p in &item.procs {
                let ppm = p.ppm.filter(|v| *v > 0.0).unwrap_or(rules.combat.default_item_ppm);
                let rate = landed_ps * ppm * w.speed() / 60.0;
                for e in &p.effects {
                    if let Some((tick, period, count, school)) = e.dot() {
                        // Proc rate over the fight: white hits are uniform, weapon specials (main hand only)
                        // follow the rotation, so a DoT started in the opening burst gets more ticks in.
                        let per_hit = ppm * w.speed() / 60.0;
                        let white = hand.swings_ps * hand.land * per_hit;
                        let by_slot: Vec<f64> = (0..rs.builder_by_slot.len())
                            .map(|s| white + if *is_mh { rs.builder_by_slot[s] * p_land / fight.gcd * per_hit } else { 0.0 })
                            .collect();
                        ev.procs += dot_ticks(&by_slot, fight.gcd, period, count, fight.seconds) * tick * dot_factor(rules, school) / fight.seconds;
                        continue;
                    }
                    match e.kind.as_str() {
                        "extra_attack" => extra_swing_ps[n] += rate * e.count.unwrap_or(1) as f64,
                        "direct_damage" => {
                            let avg = (e.min.unwrap_or(0.0) + e.max.unwrap_or(0.0)) / 2.0;
                            ev.procs += rate * avg * fight.magic_taken_factor;
                        }
                        _ => {
                            if !ev.unmodelled.contains(&p.spell) {
                                ev.unmodelled.push(p.spell);
                            }
                        }
                    }
                }
            }
        }
        let _ = mhw;
        let _ = mh_dagger;
        ev.extra_swings = extra_swing_ps[0] * mh_hand.exp_swing + extra_swing_ps[1] * oh_hand.as_ref().map(|h| h.exp_swing).unwrap_or(0.0);
        ev.dps = ev.white_mh + ev.white_oh + ev.specials + ev.extra_swings + ev.procs;
        ev
    }
}

/// Expected DoT ticks landing in one fight from a proc source whose rate per second is `rates[i]`
/// during the i-th `slot` seconds of the fight. A new proc replaces the running DoT (the old one
/// stops ticking), so tick `k` of a proc at time `t0` lands only if `t0 + k*period` is inside the
/// fight and no other proc came in between: `sum_k int rate(t0) exp(-int_{t0}^{t0+k*period} rate) dt0`.
/// Known bias: weapon specials fire on slot boundaries but are integrated at slot midpoints, so this
/// undercounts a large DoT by ~5% of its own term (+0.1% total DPS in the Monte Carlo cross-check).
pub(crate) fn dot_ticks(rates: &[f64], slot: f64, period: f64, count: u32, fight: f64) -> f64 {
    const SUB: usize = 8; // integration steps per slot
    let h = slot / SUB as f64;
    let steps = ((fight / h).round() as usize).max(1);
    let rate_at = |i: usize| rates.get(i / SUB).copied().unwrap_or(0.0);
    // Cumulative proc hazard at each step boundary, linear inside a step.
    let mut cum = vec![0.0; steps + 1];
    for i in 0..steps {
        cum[i + 1] = cum[i] + rate_at(i) * h;
    }
    let cum_at = |t: f64| {
        let x = (t / h).clamp(0.0, steps as f64);
        let i = (x.floor() as usize).min(steps - 1);
        cum[i] + (cum[i + 1] - cum[i]) * (x - i as f64)
    };
    let mut ticks = 0.0;
    for i in 0..steps {
        let t0 = (i as f64 + 0.5) * h;
        for k in 1..=count {
            let t1 = t0 + k as f64 * period;
            if t1 > fight {
                break;
            }
            ticks += rate_at(i) * h * (-(cum_at(t1) - cum_at(t0))).exp();
        }
    }
    ticks
}

/// The same for a constant rate, in closed form (`sum_k rate * (fight - k*period)+ * exp(-rate*k*period)`).
#[cfg(test)]
fn dot_ticks_flat(rate: f64, period: f64, count: u32, fight: f64) -> f64 {
    (1..=count).map(|k| rate * (fight - k as f64 * period).max(0.0) * (-rate * k as f64 * period).exp()).sum()
}

/// Physical DoTs (bleeds) are taken as-is; spell schools lose `magic_taken_factor` to resists.
pub(crate) fn dot_factor(rules: &Rules, school: u32) -> f64 {
    if school == 0 {
        1.0
    } else {
        rules.fight.magic_taken_factor
    }
}

/// A loadout's derived numbers for one level/build, see `Prepared::context`.
pub(crate) struct Ctx<'i> {
    pub mh: &'i Item,
    pub oh: Option<&'i Item>,
    pub mhw: &'i Weapon,
    pub ap: f64,
    pub crit_base: f64,
    pub hit: f64,
    pub mh_hand: Hand,
    pub oh_hand: Option<Hand>,
    /// Chance a special lands (not missed or dodged).
    pub p_land: f64,
    /// Special crit chance with / without the weapon-type talents (0..1).
    pub crit_weapon: f64,
    pub crit_plain: f64,
    pub mh_dagger: bool,
    pub mh_avg: f64,
    /// Damage kept after mob armor.
    pub armor: f64,
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rules::load_builds;
    use serde_json::json;

    const BUILDS: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/builds");
    const ITEMS: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../.cache/items.json");

    fn rank(flat: f64, pct: f64) -> AbilityRank {
        serde_json::from_value(json!({"rank": 8, "level": 60, "spell": 1, "energy": 60.0, "flat": flat, "weapon_pct": pct})).unwrap()
    }

    /// Rank values copied from the DB export's `abilities` table (see checkpoint).
    fn abilities() -> AbilityTable {
        let mut t = AbilityTable::new();
        let mk = |v: serde_json::Value| -> Vec<AbilityRank> { serde_json::from_value(v).unwrap() };
        t.insert("Sinister Strike".into(), mk(json!([
            {"rank": 5, "spell": 1760, "level": 30, "energy": 45, "flat": 22, "weapon_pct": 1.0},
            {"rank": 8, "spell": 11294, "level": 54, "energy": 45, "flat": 68, "weapon_pct": 1.0}])));
        t.insert("Backstab".into(), mk(json!([
            {"rank": 4, "spell": 2591, "level": 28, "energy": 60, "flat": 46, "weapon_pct": 1.5},
            {"rank": 8, "spell": 11281, "level": 60, "energy": 60, "flat": 140, "weapon_pct": 1.5}])));
        t.insert("Eviscerate".into(), mk(json!([
            {"rank": 4, "spell": 6762, "level": 24, "energy": 35, "base_avg": 20.0, "per_cp": 31.0},
            {"rank": 8, "spell": 11300, "level": 56, "energy": 35, "base_avg": 96.0, "per_cp": 151.0},
            {"rank": 9, "spell": 31016, "level": 60, "energy": 35, "base_avg": 108.0, "per_cp": 170.0}])));
        t
    }

    fn wpn(id: u32, skill: &str, min: f64, max: f64, speed_ms: u32) -> Item {
        serde_json::from_value(json!({
            "id": id, "name": format!("t{id}"), "slot": "one_hand",
            "weapon": {"skill": skill, "min": min, "max": max, "speed_ms": speed_ms}
        }))
        .unwrap()
    }

    fn with_proc(mut i: Item, ppm: f64, effect: serde_json::Value) -> Item {
        i.procs = serde_json::from_value(json!([{"spell": 1, "name": "p", "ppm": ppm, "effects": [effect]}])).unwrap();
        i
    }

    fn setup() -> (Rules, Vec<Build>, AbilityTable) {
        (crate::rules::test_rules(), load_builds(BUILDS).unwrap(), abilities())
    }

    fn build<'a>(b: &'a [Build], name: &str) -> &'a Build {
        b.iter().find(|x| x.name == name).unwrap()
    }

    #[test]
    fn backstab_matches_classicroguecraft() {
        // ((wpn + AP/14*1.7)*1.5 + 210)
        let (w, ap) = (100.0, 560.0);
        let want = (w + ap / 14.0 * 1.7) * 1.5 + 210.0;
        assert!((weapon_ability_damage(&rank(140.0, 1.5), w, ap, 1.7) - want).abs() < 1e-9);
    }

    #[test]
    fn sinister_strike_matches_classicroguecraft() {
        // ((wpn + AP/14*2.4) + 68), 1.7 for daggers
        let (w, ap) = (75.0, 420.0);
        assert!((weapon_ability_damage(&rank(68.0, 1.0), w, ap, 2.4) - (w + ap / 14.0 * 2.4 + 68.0)).abs() < 1e-9);
        assert!((weapon_ability_damage(&rank(68.0, 1.0), w, ap, 1.7) - (w + ap / 14.0 * 1.7 + 68.0)).abs() < 1e-9);
    }

    #[test]
    fn eviscerate_matches_formula() {
        let r: AbilityRank = serde_json::from_value(json!({"rank": 8, "level": 56, "spell": 1, "energy": 35, "base_avg": 96.0, "per_cp": 151.0})).unwrap();
        assert!((eviscerate_damage(&r, 5.0, 700.0, 0.03) - (96.0 + 5.0 * 151.0 + 0.03 * 700.0 * 5.0)).abs() < 1e-9);
    }

    #[test]
    fn attack_table_helpers() {
        let (r, _, _) = setup();
        assert!((miss_table(&r.combat, 0.0) - 5.0).abs() < 1e-9);
        assert!((miss_table(&r.combat, 10.0) - 6.0).abs() < 1e-9);
        assert!((miss_table(&r.combat, 15.0) - 9.0).abs() < 1e-9);
        assert!((miss_table(&r.combat, -5.0) - 4.8).abs() < 1e-9);
        assert!((dodge_table(&r.combat, 5.0) - 5.5).abs() < 1e-9);
        assert!((dodge_table(&r.combat, -5.0) - 4.8).abs() < 1e-9);
        let (chance, mult) = glancing(&r.combat, 0.0);
        assert!((chance - 10.0).abs() < 1e-9 && (mult - 0.95).abs() < 1e-9);
        assert_eq!(glancing(&r.combat, -5.0), (10.0, 1.0));
        let (chance, mult) = glancing(&r.combat, 15.0);
        assert!((chance - 40.0).abs() < 1e-9 && (mult - 0.65).abs() < 1e-9);
        assert!(armor_dr(&r.fight, 60.0, 60.0) > armor_dr(&r.fight, 20.0, 20.0));
        assert!(armor_dr(&r.fight, 60.0, 60.0) < 0.75);
    }

    #[test]
    fn excluded_spell_never_picked() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 60, None, None);
        assert_eq!(p.ranks[idx(Ability::Eviscerate)].as_ref().unwrap().spell, 11300);
    }

    #[test]
    fn stats_never_lower_dps() {
        let (r, b, a) = setup();
        for name in ["combat_swords", "dagger_assassination"] {
            for level in [10, 30, 45, 60] {
                let p = Prepared::new(&r, &a, build(&b, name), level, None, None);
                let (mh, oh) = (wpn(1, "dagger", 40.0, 70.0, 1800), wpn(2, "sword", 30.0, 60.0, 2400));
                let base = p.evaluate(&mh, Some(&oh), &Extra::default()).dps;
                assert!(base.is_finite() && base > 0.0, "{name} L{level}");
                for x in [
                    Extra { strength: 5.0, ..Default::default() },
                    Extra { agi: 5.0, ..Default::default() },
                    Extra { ap: 20.0, ..Default::default() },
                    Extra { crit_pct: 1.0, ..Default::default() },
                    Extra { hit_pct: 1.0, ..Default::default() },
                    Extra { mh_dps: 1.0, ..Default::default() },
                    Extra { oh_dps: 1.0, ..Default::default() },
                ] {
                    let d = p.evaluate(&mh, Some(&oh), &x).dps;
                    assert!(d >= base - 1e-9, "{name} L{level} {x:?}: {d} < {base}");
                }
            }
        }
    }

    #[test]
    fn better_weapon_never_ranks_lower() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 40, None, None);
        let oh = wpn(2, "sword", 30.0, 60.0, 2400);
        let (weak, strong) = (wpn(1, "sword", 40.0, 80.0, 2600), wpn(3, "sword", 50.0, 90.0, 2600));
        assert!(p.evaluate(&strong, Some(&oh), &Extra::default()).dps > p.evaluate(&weak, Some(&oh), &Extra::default()).dps);
    }

    #[test]
    fn extra_attack_proc_adds_dps() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 45, None, None);
        let plain = wpn(1, "sword", 66.0, 124.0, 2700);
        let proc = with_proc(wpn(1, "sword", 66.0, 124.0, 2700), 1.0, json!({"kind": "extra_attack", "count": 1}));
        assert!(p.evaluate(&proc, None, &Extra::default()).dps > p.evaluate(&plain, None, &Extra::default()).dps);
    }

    #[test]
    fn aura_proc_is_reported_not_scored() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 45, None, None);
        let plain = wpn(1, "sword", 66.0, 124.0, 2700);
        let aura = with_proc(wpn(1, "sword", 66.0, 124.0, 2700), 1.0, json!({"kind": "aura"}));
        let (e0, e1) = (p.evaluate(&plain, None, &Extra::default()), p.evaluate(&aura, None, &Extra::default()));
        assert!((e0.dps - e1.dps).abs() < 1e-9);
        assert_eq!(e1.unmodelled, vec![1]);
    }

    #[test]
    fn dot_ticks_match_closed_forms() {
        let flat = |rate: f64, period: f64, count: u32| dot_ticks(&[rate; 20], 1.0, period, count, 20.0);
        // A rare proc: every proc lands all its ticks, so ticks = rate * sum of (fight - k*period).
        let rare = flat(1e-6, 3.0, 5);
        assert!((rare - 1e-6 * (17.0 + 14.0 + 11.0 + 8.0 + 5.0)).abs() < 1e-8, "{rare}");
        // A DoT that runs past the end of the fight only counts the ticks inside it.
        assert_eq!(flat(1.0, 30.0, 3), 0.0);
        // The numeric integral tracks the closed form for a flat rate.
        for (rate, period, count) in [(0.03, 3.0, 10), (0.2, 3.0, 5), (0.5, 2.0, 10), (0.1, 5.0, 4)] {
            let (a, b) = (flat(rate, period, count), dot_ticks_flat(rate, period, count, 20.0));
            assert!((a / b - 1.0).abs() < 0.01, "rate {rate}: {a} vs {b}");
        }
        // Refreshing costs ticks per proc, and early procs are worth more than late ones.
        assert!(flat(0.2, 3.0, 5) > flat(0.1, 3.0, 5));
        assert!(flat(0.2, 3.0, 5) / 0.2 < flat(0.1, 3.0, 5) / 0.1);
        let (mut early, mut late) = ([0.0; 20], [0.0; 20]);
        early[..5].fill(0.04);
        late[15..].fill(0.04);
        assert!(dot_ticks(&early, 1.0, 3.0, 10, 20.0) > 2.0 * dot_ticks(&late, 1.0, 3.0, 10, 20.0));
    }

    #[test]
    fn dot_proc_adds_dps_and_is_scored() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 45, None, None);
        let plain = wpn(1, "sword", 66.0, 124.0, 2700);
        let mut dot = with_proc(wpn(1, "sword", 66.0, 124.0, 2700), 1.0, json!({"kind": "aura", "aura": 3, "value": 12.0, "period_ms": 3000.0, "school": 0}));
        dot.procs[0].effects[0].duration_s = Some(15.0);
        let (e0, e1) = (p.evaluate(&plain, None, &Extra::default()), p.evaluate(&dot, None, &Extra::default()));
        assert!(e1.dps > e0.dps);
        assert!(e1.unmodelled.is_empty());
        assert!(dot.not_scored().is_empty());
    }

    #[test]
    fn backstab_needs_a_dagger_main_hand() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "dagger_assassination"), 30, None, None);
        let sword = p.evaluate(&wpn(1, "sword", 40.0, 70.0, 2400), None, &Extra::default());
        let dagger = p.evaluate(&wpn(2, "dagger", 30.0, 50.0, 1600), None, &Extra::default());
        assert_eq!(sword.casts_of(Ability::Backstab), 0.0);
        assert!(dagger.casts_of(Ability::Backstab) > 0.0);
    }

    #[test]
    fn single_wield_before_dual_wield_level() {
        let (r, b, a) = setup();
        let p = Prepared::new(&r, &a, build(&b, "combat_swords"), 5, None, None);
        let (mh, oh) = (wpn(1, "sword", 10.0, 20.0, 2000), wpn(2, "sword", 10.0, 20.0, 2000));
        let e = p.evaluate(&mh, Some(&oh), &Extra::default());
        assert_eq!(e.white_oh, 0.0);
        assert!(e.dps.is_finite() && e.dps > 0.0);
    }

    #[test]
    fn exported_items_evaluate() {
        // Skipped when the (gitignored, DB-derived) export has not been generated.
        let Ok(file) = crate::data::load_items(ITEMS) else { return };
        let (r, b, _) = setup();
        let thrash = file.items.iter().find(|i| i.name == "Thrash Blade").unwrap().weapon.as_ref().unwrap();
        assert!((thrash.dps() - 35.185).abs() < 0.01, "Thrash Blade is 66-124 @ 2.7");
        let p = Prepared::new(&r, &file.abilities, build(&b, "combat_swords"), 60, None, None);
        for it in file.items.iter().filter(|i| i.weapon.is_some() && matches!(i.slot.as_str(), "one_hand" | "main_hand")) {
            let d = p.evaluate(it, None, &Extra::default()).dps;
            assert!(d.is_finite() && d > 0.0, "{} -> {d}", it.name);
        }
    }
}
