# How to use TuFFlevels

You don't need to type anything. Install it and play.

---

## 1. Install

Find your WoW folder, then the folder for the version you play:

- `_classic_beta_` — WoW Forever
- `_classic_era_` — Classic Era
- `_retail_` — Midnight

Go into `Interface`, then `AddOns`, and unzip `TuFFlevels` in there. It should
end up as:

```
World of Warcraft/_classic_beta_/Interface/AddOns/TuFFlevels/TuFFlevels.toc
```

Fully quit the game and start it again. On character select, click **AddOns**
bottom-left and make sure TuFFlevels is ticked.

---

## 2. First login

A welcome box appears. Click **Got it**. That's the setup.

Behind that click the addon has already turned on friendly nameplates (needed
for the NPC markers) and started recording. Nothing else to configure.

---

## 3. Just play

Level however you think is fastest. Take the quests you'd take, skip what you'd
skip, grind where you'd grind.

You shouldn't need to look anything up. Three things point you:

- An **arrow** with a distance under it. Purple when you're facing the right
  way, red when you're not. Drag it anywhere.
- A **!** or **?** over the head of the NPC your step needs.
- **Purple diamonds** over mobs your active quests need dead. These come
  straight from your quest log, so they work for any quest, in any route,
  even ones the addon has never seen.

Every quest you accept or turn in gets written down — the quest, the NPC, your
exact position, your level. You never see it happen.

When a step needs a specific NPC, a **!** or **?** floats over their head.

---

## 4. The tracker window

| Button | Does |
|---|---|
| **Next / Back** | Manual step control, for travel steps it can't detect |
| **Waypoint** | Puts an arrow on the current step's location |
| **Menu** | Everything else |

Under **Menu**:

| Button | Does |
|---|---|
| **Stop / Start recording** | Toggle. Shows how many steps you've captured |
| **Progress / completed** | Checklist of the whole route — what's done, what's left |
| **Recover past quests** | Pulls quests you finished before installing the addon |
| **Arrow** | The big pointer. Purple when you're facing right, red when not |
| **Objective mobs** | Purple diamonds over things your quests need dead |
| **Where to go next** | Zone guide for your level — where to be now, what's next |
| **Import a guide** | Convert a community guide in Guidelime format into a route |
| **Save this as a route** | Opens a window with your route written out |
| **Add a note here** | Type advice that gets attached to your last step |
| **Mark this spot** | Drops a travel waypoint exactly where you stand |
| **NPC markers** | Turn the head icons off |
| **Friendly nameplates** | Toggle, in case they interfere with something else |
| **Available Guides** | Switch between installed routes |

---

## 4b. Seeing what you've finished

Click the step counter in the top-right of the tracker, or **Menu > Progress**.

You get the whole route as a list. A green **v** means done, a yellow **>** is
where you are, a grey dash is still to come. Click any line to jump there —
useful if your progress resets on Forever.

The **All / Done / To do** buttons filter it, and the header shows how many
steps and quests you've finished, plus the total quests completed on that
character if the client will tell us.

---

## 4c. Already levelled before installing this?

**Menu > Recover past quests.**

Your character carries a flag for every quest it ever completed, so the addon
can pull that list back and look up the names. You get a route file containing
real quest IDs for everything you've already done.

What it *can't* recover: the order you did them in, where the NPCs stood, or
who handed them to you. The game never stored any of that — it isn't hidden,
it doesn't exist.

So what you get is a correct skeleton, not a finished route. Two ways to
finish it:

- Reorder the lines into the order you actually ran them, then walk the zone
  once with recording on to pick up coordinates and NPC names.
- Or just keep it as a record of what you did and record properly from here on.

The lines come out sorted by quest ID. That isn't completion order, but vanilla
IDs cluster by zone, so it lands closer than random and gives you less to
reshuffle.

---

## 4d. Where to go next

**Menu > Where to go next.**

Tells you which zones suit your level right now, where to base yourself in
each, and what opens up next. At 12 that's Durotar wrapping up, the Barrens
and Silverpine open, Hillsbrad at 18.

Where several zones overlap, pick by what's least crowded on your realm.
A thinner zone you have to yourself beats a dense one where you're fighting
over spawns.

---

## 4e. Using community guides

There's a large body of free leveling guides written in a format called
**Guidelime**. Freezy3's Horde 1-44 is a well-known one, free on CurseForge,
routed by CauthonLuck.

**Menu > Import a guide.** Paste a guide in that format, click Convert, and
you get a TuFFlevels route.

The addon ships none of these guides and copies none of them. It only knows
how to *read* the format — the same arrangement it has with the quest
database. You install what you want, from whoever published it.

**If you publish a route you built from someone else's guide, credit them and
check their terms.** Being able to read a format isn't permission to
redistribute what's written in it.

Imported routes live in memory for that session. Use **Save this as a route**
to keep one.

---

## 4f. Markers and the arrow

You shouldn't have to look anything up. Two things handle that:

**Markers.** A yellow **!** over the NPC you accept from, a **?** over the one
you turn in to, and a purple diamond over every mob your current quests need
killed. The mob markers come from reading your quest objectives — if a quest
wants ten Mottled Boars, every Mottled Boar on screen gets flagged.

**The arrow.** Points at your current step with a distance readout, so you
never open the map. Independent of TomTom.

Both need friendly nameplates on, which the addon switched on for you at
first login.

---

## Rogue tab

**Menu > Rogue.** Three tabs, rogue-only, hidden on other classes.

**Training** — milestone levels worth planning a trainer trip around, coloured
by whether you've passed them. Below that, every ability you've learned and the
level you learned it at. That list builds itself as you play rather than being
hand-written, so it's accurate to your client rather than to a guide.

**Upgrades** — weapons worth routing around, level by level, Horde-obtainable
only. Jagged Dagger at 4, Blade of Cunning from the rogue class quest at 10,
Tail Spike from Wailing Caverns, through to Dal'Rend's at 58. Colour-coded by
whether you've passed the level, and you get a chat prompt when one comes up.

**Weapons** — what you can hold and why. Includes the Forever axe situation and
what it means for Orc specifically.

**Grinding** — when killing beats questing, by level band, with the rogue angle:
stealth means you pick your pulls, and humanoids pay twice because you can
pickpocket them.

You also get a chat prompt at milestone levels so a trainer visit doesn't slide.

---

## Importing your spreadsheet

**Menu > Import spreadsheet.**

In Google Sheets: **File > Download > Comma-separated values**. Open the
downloaded file in Notepad, select all, copy. Paste into the box, name the
route, click **Import**. Or just select the cells in the browser and paste
directly — tab-separated works too.

It reads the columns by their headers rather than by position, so adding or
moving columns won't break it. It understands ACCEPT, TURN IN, COMPLETE,
PROGRESS, NOTE, TRAINER, SPIRIT REZ, SET HEARTH, HEARTHSTONE and ITEM ACCEPT.

**Chapter rows become section boundaries.** The "Chapter N End: Quest log
audit" rows are what split the route into sections, and the quest-log count on
them gets shown as a check — if your log doesn't match, something was missed.

**Quest names resolve to IDs automatically.** The sheet has names, not IDs.
The addon looks up the ID the moment the quest enters your log and caches it
permanently, so tracking works from then on. Steps it hasn't resolved yet
still display, you just advance them yourself.

**Import and save as file** does the same thing and then hands you a route
file to paste into your Routes folder, so it survives a reload.

Do each tab separately — they're separate routes.

---

## The 1-60 skeleton

**Menu > Available Guides > Horde 1-60 (Orc/Troll).**

25 sections covering every zone from the Valley of Trials to 60, with level
bands, which hub to base in, and where quest density drops off enough that
grinding wins.

It contains **no quest IDs**, on purpose. I don't have a quest database for
Forever, and inventing IDs would give you an addon that looks finished and
quietly lies. What's in there is factual — zone bands, hub names, where
Kalimdor runs thin.

To fill it in: load the skeleton, turn recording on, and play it. Read
whatever guide you like on a second monitor. Every quest you accept and turn
in gets recorded with its real ID and coordinates, filed into whichever
section you were in. Export and you have a complete route — structure from
the skeleton, data from your own client, judgement from you.

---

## Sections

Routes are chunked into sections with level bands, like RestedXP. The current
section shows above your step, and the progress list uses them as headers.

While recording, a new section starts automatically whenever you change zone —
so a recorded route comes out organised by area instead of as one long wall.

---

## Look and feel

Near-black with deep red, purple accents. Set in `Theme.lua` if you want to
change it — the palette is at the top of the file, one table, plain numbers.

---

## 5. Saving what you played

Click **Menu**, then **Save this as a route**. A window opens with your whole
route already written out. Press **Ctrl+C**.

Open Notepad, paste, and save it into your `TuFFlevels/Routes/` folder with a
name ending in `.lua` — something like `MyDurotar.lua`.

Then open `TuFFlevels.toc` in Notepad and add one line at the bottom:

```
Routes\MyDurotar.lua
```

Type `/reload` in game. It'll show up under **Menu > Available Guides**.

That's the only place you touch a file, and it's copy and paste.

---

## 6. Two buttons worth using while you play

**Add a note here** is what makes a route good rather than just accurate. The
recording captures *what* you did. A note captures *why* — "pull him away from
the adds", "skip this if you're under 8", "don't bother with the cave".

**Mark this spot** is for anything that isn't a quest. Flight paths, shortcuts,
where to hearth, a cave entrance that's easy to miss.

---

## 7. If something goes wrong

**On WoW Forever**, the beta client has a bug where it forgets addon settings
between sessions. If your progress resets when you log back in, that's the
client, not you. The tracker shows your step number — note it before you log
out and use Back/Next to get there. Blizzard will likely fix this.

**If you were recording when this happened**, the same bug can make it look
like your recording vanished. It didn't — the client still *writes* your
SavedVariables file on exit, it just never reads it back in. Two ways to get
it back:

- If it was mid-session (you `/reload`ed, didn't fully exit the game), just
  click **Start recording** again — the addon keeps its own copy for exactly
  this case and picks up where you left off.
- If you fully logged out or exited the client first, run
  `python tools/extract_recording.py "<path to>/WTF/Account/<ACCOUNT>/SavedVariables/TuFFlevels.lua"`
  from the addon folder. It reads the file straight off disk and prints the
  same route text the export window would have — redirect it into a file
  under `Routes/` to use it. Fill in the faction/race/level placeholders it
  leaves at the top; those aren't in the recording, only in your character.

Either way, the cheapest fix is prevention: while recording, the tracker and
chat will nudge you to export every 25 steps and again as you log out, on any
Forever client. Export early and often rather than trusting the SavedVariables
to still be there next time.

For anything else, `/tuff client` prints what the addon thinks is going on. That
one's worth copying to me if you hit a problem.

---

Commands are `/tuff` or `/tufflevels`. `/sl` still works as a short alias.
