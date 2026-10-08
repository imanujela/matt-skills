# Engineering

Skills I use daily for code work. One router — [`ask-matt`](./ask-matt/SKILL.md) — points you at the right flow; everything else in here is reachable directly.

Run [`setup-matt-pocock-skills`](./setup-matt-pocock-skills/SKILL.md) once per repo before your first flow: it configures the issue tracker, triage labels, and domain-doc layout the other skills assume.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[ask-matt](./ask-matt/SKILL.md)**: Ask which skill or flow fits your situation. A router over the user-invoked skills in this repo, with a disambiguation table for the easy-to-confuse pairs.
- **[grill-with-docs](./grill-with-docs/SKILL.md)**: Grilling session that also builds your project's domain model, sharpening terminology and updating `GLOSSARY.md` and ADRs inline.
- **[triage](./triage/SKILL.md)**: Move issues and external PRs through a state machine of triage roles: categorise, verify the claim, grill if needed, and write durable agent briefs.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick.
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**: Configure this repo for the engineering skills (issue tracker, triage labels, domain doc layout). Run once per repo.
- **[to-spec](./to-spec/SKILL.md)**: Turn the current conversation into a spec — no interview, just synthesis — and publish it to the issue tracker with the `ready-for-agent` label.
- **[to-tickets](./to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges, whether as text in a local file or as native blocking links on a real tracker.
- **[implement](./implement/SKILL.md)**: Build the work described by a spec or set of tickets, driving `/tdd` at pre-agreed seams and closing out with `/code-review` before committing.
- **[implement-spec](./implement-spec/SKILL.md)**: Implement a whole spec on one integration branch. Works the tickets as a task graph, running implementer subagents across the ready frontier for maximum concurrency, then closes out with `/code-review`.
- **[wayfinder](./wayfinder/SKILL.md)**: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on the issue tracker, resolved one at a time until the way to the destination is clear. Produces decisions, not deliverables.
- **[retro](./retro/SKILL.md)**: Suggest improvements to the coding agent's environment (navigation, automated checks, coding standards, steering files, tooling) after a session, most severe first.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[prototype](./prototype/SKILL.md)**: Build a throwaway prototype to answer a design question: a single shareable HTML file for state/logic, or several toggleable UI variations.

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions: build a feedback loop that goes red on this bug → minimise → hypothesise → instrument → fix → regression-test.
- **[research](./research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time, only at pre-agreed seams.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Actively build and sharpen a project's domain model by challenging terms, stress-testing with scenarios, and updating `GLOSSARY.md` and ADRs inline.
- **[codebase-design](./codebase-design/SKILL.md)**: Shared discipline and vocabulary for designing deep modules: small interfaces, clean seams, testable through the interface.
- **[code-review](./code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: **Standards** (does it follow the repo's coding standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?), run as parallel sub-agents.
- **[pr](./pr/SKILL.md)**: The shape a pull request body should take: a summary as the smallest visual that makes the change clear, before/after evidence that it works, and a merge-danger call (one-way or two-way door, plus blast radius).
- **[wizard](./wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover.

## How the flows fit together

The main path is idea → ship: [`grill-with-docs`](./grill-with-docs/SKILL.md) sharpens the idea → (prototype detour via `/handoff` and [`prototype`](./prototype/SKILL.md) when the question needs a runnable answer) → [`to-spec`](./to-spec/SKILL.md) → [`to-tickets`](./to-tickets/SKILL.md) → [`implement`](./implement/SKILL.md) or [`implement-spec`](./implement-spec/SKILL.md) (both driven by [`tdd`](./tdd/SKILL.md), closed out by [`code-review`](./code-review/SKILL.md) and [`pr`](./pr/SKILL.md)) → [`retro`](./retro/SKILL.md). Two on-ramps merge in: [`triage`](./triage/SKILL.md) for raw arrivals, [`diagnosing-bugs`](./diagnosing-bugs/SKILL.md) for hard bugs. [`wayfinder`](./wayfinder/SKILL.md) is the heavyweight planner for efforts too big for one session; it hands off to `/to-spec` when the map clears. [`improve-codebase-architecture`](./improve-codebase-architecture/SKILL.md) is the upkeep survey that generates candidates for the main flow. [`domain-modeling`](./domain-modeling/SKILL.md) and [`codebase-design`](./codebase-design/SKILL.md) are the vocabulary layers running beneath the process skills.