---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows) — not the current workspace, so the next session starts clean and the doc is easy to find.

## Shape of the document

Use the sections below; adapt headings to the work, keep the substance. Aim for a document a fresh agent can read in one pass and immediately continue the work. It is a *map of where the work stands* — not a transcript of how it got here.

```md
# Handoff — <one-line summary of the work>

## Goal
<What the work is ultimately for. One or two sentences; enough that the next agent knows why it exists.>

## Current state
<Where the work stands right now: what is done, what is in progress, what is unstarted. Concrete — "X is merged, Y is half-written, Z not started" — not "mostly finished.">

## Decisions and their reasons
<The choices already made and *why*, so the next agent doesn't relitigate them. One line per decision.>

## Open questions / blockers
<What is unresolved, and what would unblock it. If a decision is waiting on a person or another task, name it.>

## Uncommitted / in-flight work
<Changes not yet committed, files half-written, experiments still running. A handoff is where half-finished work gets announced, not buried.>

## How to resume
<The single next action, in imperative form. "Open `X`, then do Y." Be exact enough that a fresh agent knows where to look.>

## Suggested skills
<Which skills the next agent should call the Skill tool for, and one line on what each is for.>
```

- **Write the "How to resume" step in the imperative.** "Open `src/main.ts` and add the retry" beats "you should probably look at the entry point."
- **Lead with what the next agent can't infer.** A command, a path, a person to talk to — spell out anything that would otherwise cost a long rediscovery.

## What to include vs. exclude

- **Include** the one or two facts that would take the next agent a long time to rediscover: non-obvious constraints, environment quirks, a name or path only this session knew.
- **Do not duplicate** content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead. The handoff is the *diff* between those artifacts and the agent's context, never a copy of the artifacts.
- **Summary over dialogue.** Capture decisions, state, and next steps. If the next agent needs to know *how* a decision was reached, that's one line, not a transcript.
- **Keep it short.** A handoff that reads like a spec is too long. If it runs past a couple of screens it has stopped being a map and become a transcript — cut the narrating.

## Redact sensitive information

Redact any sensitive information — API keys, passwords, tokens, and personally identifiable information. If a secret matters to the next session, say *where* it lives (config file, vault, env var), never its value.

## Tailor to arguments

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly: lead with that focus, and pour most of the detail into making *that* resumable.