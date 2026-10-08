---
name: claude-handoff
description: Hand the current conversation off to a fresh background agent that picks up the work immediately.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff summary of the current conversation so a fresh agent can continue the work. Save it to the temporary directory of the user's OS, then launch a background agent seeded with it as its prompt: `claude --bg --name "<descriptive name>" -- "$(cat <summary file>)"`. Passing the file keeps the shell from running backticks or expanding `$` in the summary. It starts in the current working directory and returns immediately; the user manages it with `claude agents`.

Always pass `-n`/`--name` with a descriptive name (e.g. `--name "Fix login bug"`); it sets the display name shown in the job list, session picker, and terminal title.

## Shape of the summary

A handoff is not a transcript — it is a brief that lets a fresh agent start working in seconds. Write it in the bare form the receiving agent wants: a stated task first, the constraints, then the pointers. Suggested structure:

1. **Task** — one or two sentences: what must be accomplished, and what "done" looks like. The agent should never have to infer its own job.
2. **State of the world** — what's already been done, what's known, what's open. Prefer "facts as of now" over "history of how we got here."
3. **Next step** — the single concrete first action the fresh agent should take. Remove the cold-start friction entirely.
4. **Constraints and gotchas** — anything the agent must respect: don't touch X, watch for Y, a flaky command, a known trap.
5. **Suggested skills** — naming which skills the next agent should call the Skill tool for.
6. **Open questions** — anything unresolved the agent may need to decide, with a recommendation where you have one.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead — a pointer is worth more than a pasted copy, and it can't drift out of date.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information, since the summary becomes the agent's prompt. Double-check command strings and references for secrets before writing the file.

## Verify before you hand off

- Confirm the summary file actually exists on disk before launching the agent (a failed write means the agent gets an empty prompt).
- Confirm the command resolves: if there's doubt that `claude` is on `PATH` in this shell, use the full path.
- After launching, tell the user the name you gave the job so they can find it in `claude agents`.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the summary (especially the Task and Next-step sections) accordingly.