# Skill mechanics

The skill-specific branch of [`writing-for-agents`](SKILL.md): what changes when the document is a skill (frontmatter, the invocation choice, and router skills). Everything else about writing it is the universal reference in `SKILL.md`.

## Invocation

Two choices, trading the two loads:

- A **model-invoked** skill keeps a `description`, so the agent can fire it autonomously, and other skills can reach it. You can still type its name: model-invocation always _includes_ user reach; a description only ever adds agent discovery, never removes the human's. The description is the skill's top-level context pointer, forced to stay loaded at all times: permanent context load in exchange for discoverability. A model-invoked skill whose content is all reference is also one home for shared reference: another skill can invoke it, so reference needed by several skills lives in one place. Mechanics: omit `disable-model-invocation`, and write a model-facing description carrying the trigger branches (the pointer-writing rules in `SKILL.md` apply in full).
- A **user-invoked** skill strips the description from the agent's reach: only the human typing its name can invoke it, and no other skill can. Zero context load, but it spends cognitive load: you are the index that must remember it exists. Mechanics: set `disable-model-invocation: true`; the `description` becomes human-facing: a one-line summary, trigger lists stripped.

Pick model-invocation only when the agent must reach the skill on its own, or another skill must. If it only ever fires by hand, make it user-invoked and pay no context load.

A three-question flow settles the choice:

1. **Must the agent fire this on its own** — a trigger you actually say in your prompts, or the same reference needed at several sites? If no, make it user-invoked.
2. **Must another skill reach it?** If yes, model-invoked; a user-invoked skill can't be reached by anything but the human.
3. **Is the always-loaded description worth its context load?** A rarely-fired skill keeps a permanently-loaded pointer on every turn. If it fires rarely, a model-invoked slot overpays — consider external reference instead.

Changing a skill's invocation later means changing two halves at once: the `disable-model-invocation` flag and the description's audience (human-facing one-liner vs model-facing trigger branches). Let them disagree and the skill becomes reachable in ways half the pointers assume — keep them updated together.

A worked user-invoked skill:

```md
---
name: retro
description: Run a retrospective on the last coding session.
disable-model-invocation: true
---
```

The description is human-facing: a one-line summary, triggers stripped, because the human already knows when they want a retro.

Shared reference that two user-invoked skills both need can live in neither: with no descriptions, neither can fire the other. Push it to a plain file outside the skill system: external reference any skill can point at.

## Splitting by invocation

The invocation cut of splitting (the sequence cut lives in `SKILL.md`): split off a model-invoked skill when you have a distinct leading word that should trigger it on its own (a trigger word you actually use in your prompts), or another skill must reach it. You pay context load for the new always-loaded description, so that independent reach has to be worth it.

## Router skills

When user-invoked skills multiply past what you can remember, that piled-up cognitive load is cured by a **router skill**: one user-invoked skill that names the others and when to reach for each, so the human has one skill to remember instead of many. It can only hint, never fire them: user-invoked skills have no description, so nothing but the human can reach them.

A router's body is a decision list, one skill per case:

```md
When to reach for which skill:

- **grill-me** — before committing to a plan or decision you want stress-tested.
- **to-questionnaire** — when you need to pull knowledge out of one specific person.
- **handoff** — before ending a session, to let a fresh agent continue.
```

Router skills buy cognitive load for the human at the price of this one always-loaded body; prune it the same way `SKILL.md` prunes any document.
