---
name: wait-what
description: "Stop. That last message did not land: re-pitch it."
disable-model-invocation: true
---

Wait, I don't understand where you've got to here. Re-pitch that: give me a little bit of context, talk in ASD-STE100 Simplified Technical English, and use the ubiquitous language from `GLOSSARY.md` (follow `GLOSSARY-MAP.md` to the right one if the repo has more than one).

## What this fires on

Fire the moment a message doesn't land — the user is lost. Treat that as a fact about *your* last message, not about them. The user doesn't need more of the same explanation; they need a different one.

## Figure out what didn't land

Before re-pitching, diagnose the gap. Was the last message lost because it:

- **Presupposed context** the user doesn't have (a term, a decision, an earlier step they never saw)?
- **Used jargon or a shared vocabulary they don't own yet**?
- **Jumped several steps** from where the user actually is?

Locate the earliest step where the user lost the thread. The re-pitch starts *there*, not from wherever the previous message ended.

## How to re-pitch

Structure the re-pitch as three short moves, in order:

1. **One line of context** — where this sits in the bigger picture, so it's anchored: "We're deciding whether to move the build step into CI."
2. **The plain-English pitch** — restate the point in ASD-STE100 Simplified Technical English: short sentences, one idea each, active voice, concrete words, no idioms, no subordinate clauses stacked three deep.
3. **The term up front** — if a glossary term is unavoidable, lead *with* it, define it in one line, then use it consistently. Prefer the domain's own term (the `GLOSSARY.md` word) over an approximation; consistency beats ad-hoc synonyms.

A template:

> **Where we are:** {one line of context}
>
> **The point:** {one or two sentences in plain, concrete English}
>
> **What that means for you / next:** {in your glossary's language, defining any term on first use}

## Rules

- **Shorter this time.** If the re-pitch is as long as the message that failed, you haven't re-pitched, you've repeated. Cut ruthlessly.
- **One idea per sentence.** Long, clause-heavy sentences are usually what triggered this in the first place.
- **No jargon without a definition.** Every glossary term either gets a one-line definition on first use or is dropped in favour of a plain word.
- **Check it's simpler before sending.** If you can't point at any way the new version is easier, rewrite it again.
- **Stay on the same answer.** The goal is to make the *existing* message land, not to change the substance or pick a new topic.