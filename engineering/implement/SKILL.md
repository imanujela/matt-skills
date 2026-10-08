---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

# Implement

Implement the work described by the user in the spec or tickets.

## Before writing any code

1. **Anchor the ticket.** If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask. Resolve a bare `#42` per the tracker config (it may be an issue or a PR).
2. **Read the domain docs.** Pick up `GLOSSARY.md` (if it exists) so names and vocabulary in your code and commit match the project's language, and respect ADRs in the area you're touching. If the spec or ticket disagrees with an ADR, surface the conflict before building on it.
3. **Know where the seams are.** The ticket, or a `/to-spec`, fixed the seams this work is meant to test at. If none are stated, propose your seams and confirm them before writing tests (the `/tdd` skill makes this explicit).

## The loop

The core of the work is driving `/tdd` at pre-agreed seams: one red → green vertical slice at a time, each slice a **tracer bullet** that builds on what the last one taught. Call the Skill tool with "tdd" where possible, and reuse the seams you agreed up front rather than inventing new ones mid-build.

- **Run typechecking regularly.** Type-correct code is a smaller surface for each slice to go wrong on; don't let errors accumulate to the end.
- **Run single test files regularly** as you add slices; the tight loop catches a break almost as it lands.
- **Run the full test suite once at the end** — the slices were green individually, but only the whole suite proves the integration branch is green too.

## Closing out

- Call the Skill tool with "code-review" to review the work before committing — both axes: Standards (does it follow the repo's conventions) and Spec (does it do what the ticket asked). Trivial, purely mechanical edits can skip this, but when in doubt, review.
- Fix everything the review raises; an unanswered review finding is the work not being done.
- **Commit your work to the current branch.** Write a commit message that states the ticket number (so the spec review can find it) and a one-line behavioural summary of what the ticket delivered. If the work was built by `/tdd`, say what it implements, not how.

Commit often enough that each commit is a coherent unit and the branch tells a readable story — a reviewer (human or `/code-review`) reads the branch, not the working directory.