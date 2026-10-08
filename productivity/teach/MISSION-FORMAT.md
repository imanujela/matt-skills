# MISSION.md Format

`MISSION.md` lives at the workspace root. It captures the _reason_ the user is learning this topic. Every teaching decision (what to teach next, which resources to surface, which exercises to design) should trace back to this document. It is the compass for the whole workspace.

## Template

```md
# Mission: {Topic}

## Why
{1-3 sentences. The concrete real-world goal the user is chasing. What changes in their life or work when they have this skill? Avoid abstract framings like "to understand X"; push for the underlying outcome.}

## Success looks like
- {A specific, observable thing the user will be able to do}
- {Another specific thing}
- {…}

## Constraints
- {Time, budget, prior commitments, learning preferences, anything that bounds the approach}

## Out of scope
- {Adjacent topics the user explicitly does not want to chase right now, protecting the zone of proximal development}
```

## A filled example

```md
# Mission: Strength Training

## Why
Run a half marathon in October without injury, and add 20kg to my squat by New Year. Training sessions have to fit into weekday mornings before work.

## Success looks like
- Run 21.1km continuously on race day, comfortable enough to hold a conversation at pace.
- Squat 120kg for 3x5 with a spotter.
- Recover fast enough to train 4x a week without burnout.

## Constraints
- ~45 minutes per session, 4 mornings a week.
- No gym budget beyond the current membership.
- Prefers bodyweight + barbell compound lifts over machines.

## Out of scope
- Olympic lifting technique.
- Bodybuilding/hypertrophy body-part splits.
```

This is a mission you can steer lessons toward: every "what next" question has a testable answer.

## Rules

- **One mission per workspace.** If the user wants to learn two unrelated things, that is two workspaces.
- **Concrete over abstract.** "Run a half marathon by October" beats "get fitter." "Ship a Rust CLI to my team" beats "learn Rust."
- **Push back on vagueness.** If the user cannot articulate why, interview them before writing anything. A bad mission is worse than no mission. Keep asking "what will you do differently once you have this?" until the answer is a specific, observable change.
- **Revise when reality shifts.** Missions change. When the user's goal moves, update this file: don't leave a stale mission steering future sessions. Record the change as a learning record and confirm it with the user.
- **Keep it short.** If `MISSION.md` runs past a screen, it has stopped being a compass and started being a plan.
- **Make success observable.** Every "Success looks like" line should be something you can check off from the outside — a time, a distance, a weight, a deliverable. If you can't tell done from not-done, neither can the user.