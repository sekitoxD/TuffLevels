//! One vocabulary for "is this item worth the effort", shared by weapons, armor and the
//! quest-reward advisor.
//!
//! An item's acquisition method (its `Tier`) says how you get it; how much DPS it adds over
//! what you would wear anyway says whether that is worth doing. Together they give a verdict:
//!
//! | method | verdict |
//! |---|---|
//! | vendor | pick it up from a vendor |
//! | solo quest | do the solo quest |
//! | group quest | worth the extra time / only if a group is already formed |
//! | dungeon (quest or drop) | very worth it / kinda worth it / not worth it |
//! | crafted, drops | if you have the profession / use it if it drops / luck only |
//!
//! Anything that adds under `min_uplift` is "not worth it" whatever its method. The thresholds
//! are judgement calls exposed as options; a verdict is a candidate for a human to confirm.

use crate::search::Tier;

pub struct VerdictOptions {
    /// Uplift (percent) below which an item is not worth having at all.
    pub min_uplift: f64,
    /// Mean uplift (percent) over its window that makes a group quest worth the extra time.
    pub detour_uplift: f64,
    /// Mean uplift x window length (percent-levels) a group quest must also reach.
    pub detour_gain: f64,
    /// Dungeon "very worth it": mean uplift and percent-levels.
    pub dungeon_very: (f64, f64),
    /// Dungeon "kinda worth it": mean uplift and percent-levels.
    pub dungeon_kinda: (f64, f64),
    /// A dungeon drop below this chance (0-1) is downgraded one step; below a fifth of it, never worth it.
    pub min_drop_chance: f64,
}

impl Default for VerdictOptions {
    fn default() -> Self {
        VerdictOptions {
            min_uplift: 1.0,
            detour_uplift: 2.5,
            detour_gain: 20.0,
            dungeon_very: (4.0, 30.0),
            dungeon_kinda: (2.0, 12.0),
            min_drop_chance: 0.10,
        }
    }
}

/// Levels a single-level score stands in for when there is no window (quest rewards are
/// scored at one level): 8 levels x the mean is what a typical gain lasts.
pub const POINT_WINDOW: u32 = 8;

/// Ordered as reported: the easy, clearly worthwhile ones first.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum Verdict {
    Vendor,
    SoloQuest,
    GroupQuestWorth,
    GroupQuestIfFormed,
    DungeonVery,
    DungeonKinda,
    DungeonNot,
    Crafted,
    OpenDrop,
    WorldDrop,
    NotWorth,
}

impl Verdict {
    pub const ALL: [Verdict; 11] = [
        Verdict::Vendor,
        Verdict::SoloQuest,
        Verdict::GroupQuestWorth,
        Verdict::GroupQuestIfFormed,
        Verdict::DungeonVery,
        Verdict::DungeonKinda,
        Verdict::DungeonNot,
        Verdict::Crafted,
        Verdict::OpenDrop,
        Verdict::WorldDrop,
        Verdict::NotWorth,
    ];

    pub fn label(self) -> &'static str {
        match self {
            Verdict::Vendor => "Vendor: pick it up",
            Verdict::SoloQuest => "Solo quest: do it",
            Verdict::GroupQuestWorth => "Group quest: worth the extra time",
            Verdict::GroupQuestIfFormed => "Group quest: only if a group is already formed",
            Verdict::DungeonVery => "Dungeon: very worth it",
            Verdict::DungeonKinda => "Dungeon: kinda worth it",
            Verdict::DungeonNot => "Dungeon: not worth it",
            Verdict::Crafted => "Crafted: if you already have the profession",
            Verdict::OpenDrop => "Open-world drop: use it if it drops, never farm it",
            Verdict::WorldDrop => "World drop: luck only, never plan around it",
            Verdict::NotWorth => "Not worth it",
        }
    }
}

/// Verdict for an item reached by `tier`, given its uplift over the window it applies in
/// (`run_len` levels, `mean` percent, `peak` percent) and, for drops, its best drop chance.
pub fn classify(tier: Tier, run_len: u32, mean: f64, peak: f64, chance: Option<f64>, o: &VerdictOptions) -> Verdict {
    if peak < o.min_uplift || tier == Tier::None {
        return Verdict::NotWorth;
    }
    let total = mean * run_len as f64;
    match tier {
        Tier::Vendor => Verdict::Vendor,
        Tier::QuestSolo => Verdict::SoloQuest,
        Tier::Crafted => Verdict::Crafted,
        Tier::QuestGroup => {
            if mean >= o.detour_uplift && total >= o.detour_gain {
                Verdict::GroupQuestWorth
            } else {
                Verdict::GroupQuestIfFormed
            }
        }
        Tier::OpenDrop => Verdict::OpenDrop,
        Tier::WorldDrop => Verdict::WorldDrop,
        Tier::QuestDungeon | Tier::DungeonDrop => {
            let mut v = if mean >= o.dungeon_very.0 && total >= o.dungeon_very.1 {
                Verdict::DungeonVery
            } else if mean >= o.dungeon_kinda.0 && total >= o.dungeon_kinda.1 {
                Verdict::DungeonKinda
            } else {
                Verdict::DungeonNot
            };
            if tier == Tier::DungeonDrop {
                let c = chance.unwrap_or(1.0);
                if c < o.min_drop_chance * 0.2 {
                    v = Verdict::DungeonNot;
                } else if c < o.min_drop_chance {
                    v = match v {
                        Verdict::DungeonVery => Verdict::DungeonKinda,
                        _ => Verdict::DungeonNot,
                    };
                }
            }
            v
        }
        Tier::None => Verdict::NotWorth,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn methods_map_to_the_requested_labels() {
        let o = VerdictOptions::default();
        assert_eq!(classify(Tier::Vendor, 5, 1.5, 2.0, None, &o), Verdict::Vendor);
        assert_eq!(classify(Tier::QuestSolo, 5, 1.5, 2.0, None, &o), Verdict::SoloQuest);
        assert_eq!(classify(Tier::QuestGroup, 8, 4.0, 6.0, None, &o), Verdict::GroupQuestWorth);
        assert_eq!(classify(Tier::QuestGroup, 2, 3.0, 4.0, None, &o), Verdict::GroupQuestIfFormed); // too little in total
        assert_eq!(classify(Tier::QuestGroup, 10, 1.5, 2.0, None, &o), Verdict::GroupQuestIfFormed);
        assert_eq!(classify(Tier::WorldDrop, 10, 9.0, 12.0, None, &o), Verdict::WorldDrop);
        assert_eq!(classify(Tier::QuestSolo, 8, 0.5, 0.8, None, &o), Verdict::NotWorth);
        assert_eq!(classify(Tier::None, 8, 9.0, 9.0, None, &o), Verdict::NotWorth);
    }

    #[test]
    fn dungeon_steps_and_drop_chance() {
        let o = VerdictOptions::default();
        assert_eq!(classify(Tier::QuestDungeon, 10, 5.0, 7.0, None, &o), Verdict::DungeonVery);
        assert_eq!(classify(Tier::QuestDungeon, 6, 2.5, 3.0, None, &o), Verdict::DungeonKinda);
        assert_eq!(classify(Tier::QuestDungeon, 3, 1.5, 2.0, None, &o), Verdict::DungeonNot);
        // The same big gain, from a boss that rarely drops it.
        assert_eq!(classify(Tier::DungeonDrop, 10, 5.0, 7.0, Some(0.33), &o), Verdict::DungeonVery);
        assert_eq!(classify(Tier::DungeonDrop, 10, 5.0, 7.0, Some(0.05), &o), Verdict::DungeonKinda);
        assert_eq!(classify(Tier::DungeonDrop, 10, 2.5, 3.0, Some(0.05), &o), Verdict::DungeonNot);
        assert_eq!(classify(Tier::DungeonDrop, 10, 5.0, 7.0, Some(0.01), &o), Verdict::DungeonNot);
    }
}
