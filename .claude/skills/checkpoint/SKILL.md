---
name: checkpoint
description: Save or resume a working session so it can move between Claude Code threads without losing context. Use when the user says "checkpoint", "save progress", "pick this up later", "start a new thread", or when a thread has grown large (user reports high numbers from /context or /usage) and should hand off before it gets summarized or hits limits. Also use at the start of a new thread when the user says "resume" or points at a checkpoint file.
---

# Checkpoint

Claude Code has no native way to carry state between separate conversation
threads — `/context` and `/usage` show token usage, but only to the human,
in that one thread, and nothing here lets the assistant read its own
context-window fill level. This skill is the deliberate replacement: a
markdown handoff file good enough that a fresh thread can resume without
re-deriving what this one already worked out.

There are two modes. Infer which one from the user's request; ask if it's
genuinely ambiguous rather than guessing on a destructive write.

## When to checkpoint (guidance, not something this skill can measure)

The assistant cannot see live token counts. Usage thresholds only work if
the user reports the number from `/context` or `/usage`, or asks to
checkpoint on their own judgment. As a rule of thumb for this repo's normal
thread sizes:

- **~150k tokens into a thread**: treat it as a warning zone. Mention it if
  the user asks how the thread is doing, and suggest checkpointing soon if
  there's a natural stopping point (a plan finished, a bug fixed, a route
  file completed).
- **~300k tokens**: checkpoint now and start a new thread. Long threads
  degrade — more of the window is old tool output and less is headroom for
  new work, and eventually the harness auto-summarizes older turns anyway,
  which loses detail a deliberate checkpoint would have kept.

If the user hasn't mentioned a number and doesn't ask, don't nag about this
on every turn — bring it up once when a natural break appears, not
repeatedly.

## Mode 1: Save

1. Gather state, not opinions:
   - `git status --short` and `git diff --stat` (staged + unstaged) —
     what's actually changed on disk.
   - `git log --oneline -5` — where the branch is.
   - The task or goal this thread was working on, in the user's own terms.
   - Decisions made and **why** (the why is the part a diff can't recover —
     a rejected alternative, a constraint from `CLAUDE.md` that shaped a
     choice, a bug root-caused earlier in the thread).
   - Open questions or blockers — anything still waiting on the user.
   - Concrete next steps, ordered, specific enough that a cold reader could
     start on step 1 without re-reading the whole thread.
   - Dead ends: approaches tried and abandoned, so the next thread doesn't
     re-attempt them. This is as valuable as the "what worked" list.

2. Write it to `.claude/checkpoints/<YYYY-MM-DD>-<slug>.md` (slug = a few
   words for the task, kebab-case). Use this structure:

   ```markdown
   # Checkpoint: <slug>

   Saved: <date/time>
   Branch: <branch> @ <short sha>

   ## Goal
   <1-3 sentences: what this thread was trying to accomplish>

   ## State
   <git status/diff summary — what's changed and whether it's committed>

   ## Decisions made
   - <decision> — <why, including anything rejected and why>

   ## Dead ends
   - <thing tried> — <why it didn't work, so it isn't retried>

   ## Open questions
   - <anything still waiting on the user>

   ## Next steps
   1. <concrete, ordered>

   ## Relevant files
   <paths a resuming thread should read first — not everything touched,
   just what's load-bearing>
   ```

3. Also write/overwrite `.claude/checkpoints/LATEST.md` with the same
   content (or a pointer: `See <filename>.` is fine if you want dated files
   kept as history) so a new thread can find the most recent checkpoint
   without the user hunting for a filename.

4. Tell the user, briefly, where it was saved and that they can start a new
   thread and say "resume" there.

## Mode 2: Resume

1. Read `.claude/checkpoints/LATEST.md` (or the file the user names).
2. Reconcile it against current reality before trusting it — `git status`,
   `git log`, and a quick look at the "Relevant files" list. A checkpoint
   is a snapshot; if the user or someone else touched the repo since it was
   written, say so rather than presenting stale state as current.
3. Summarize back to the user in 3-6 lines: goal, what's done, what's next.
   Confirm before taking any action that the checkpoint's "next steps"
   still make sense given current repo state.
4. Continue the work — don't re-do anything listed under "Decisions made"
   or "Dead ends" without a reason.

## Notes

- Checkpoint files are commit-able (nothing here is gitignored) — treat
  them as durable, not scratch. Delete or archive old ones only when the
  user says the work is done.
- This skill never guesses at git state — it always re-reads it fresh
  rather than trusting what an earlier part of the conversation claimed,
  since the whole point of a checkpoint is surviving a context reset.
