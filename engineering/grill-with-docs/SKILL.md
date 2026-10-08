---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADRs and glossary) as we go.
disable-model-invocation: true
---

# Grill with Docs

Call the Skill tool twice, for "grilling" and "domain-modeling".

Run them together, in the same session, so the two work as one loop rather than two back-to-back passes:

- **grilling** drives the interview — rounds of questions at the frontier of what isn't yet pinned down, facts as the agent's job, decisions as the user's.
- **domain-modeling** runs *inline*: every resolution lands in `GLOSSARY.md` and the ADRs the moment it crystallises, so the plan and its documentation never diverge.

The point of the pairing: a sharpened plan you can't hand off and a doc trail that records the reasoning, not just the outcome. This is the stateful build on the stateless `/grilling` primitive — prefer it whenever you're working in a working directory, because it leaves a paper trail.

Before the first round, read `GLOSSARY.md` (if it exists) and check ADRs in the area you're likely to touch, so the interview asks questions in the project's language rather than importing your own.