---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

# Research

Spin up a **background agent** to do the research, so you keep working while it reads.

Its job:

1. Investigate the question against **primary sources** (official docs, source code, specs, first-party APIs), not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it where the repo already keeps such notes; match the existing convention, and if there is none, put it somewhere sensible and say where.

## Scope the question tightly, then hand it over cleanly

The question is the contract. Write it down before launching, with:

- **The decision the research feeds.** A line stating what will be done differently depending on the answer keeps the agent pointed at signal and away from breadth.
- **Explicit boundaries**: what to investigate, and just as importantly what *not* to (past a stated cut-off, another library, internal vs external). Research without boundaries drifts until it fills a file with everything.
- **How much to write.** If the consumer is a decision you'll make in a session, a tight cited summary wins over an exhaustive one; say so.

Then hand over the *question and boundaries*, not the answers you hope to find. The agent reads primary sources; it should be free to conclude the premise is wrong if the sources say so.

## What the output must have

- **A citation for every non-trivial claim.** Follow the `grounded-citations` discipline: the claim links to the source that owns it. An uncited engineering claim is an unverified one.
- **A clear "bottom line"** at the top: what the research concludes, so the consumer gets the answer before the evidence. The evidence follows.
- **Conflicts surfaced, not smoothed.** If primary sources disagree (docs vs code, v1 vs v2), say so and note which the agent trusts and why — a research file that papers over a discrepancy has deleted a real finding.
- **Confidence markers** where the source base is thin, dated, or second-hand-translated. "No primary source found; based on a community write-up" is information a downstream decision needs.

## Feed the findings back, don't bury them

The file in the repo is the durable artifact, but the consumer is a decision nearby (usually `/grill-with-docs` or `/to-spec`). Summarise the bottom line and any conflicts *in this conversation* too, so the findings actually shape the thinking rather than waiting to be rediscovered in a file.