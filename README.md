# Changes — skills/ folder rewrite

**Date:** 2026-10-08
**Scope:** All 45 skills across the 5 categories in `skills/` (engineering, in-progress, productivity, misc + deprecated index), rewritten in place — same filenames, same file structure, YAML frontmatter preserved, core intent preserved.
**Volume:** 107 files changed, **+1413 / −319** lines. No files added, removed, or renamed.

Every skill was upgraded to be genuinely more useful, not cosmetically edited: guidance deepened, concrete missing steps added, rules sharpened, gaps fixed, structure and clarity improved, worked examples added. All `agents/openai.yaml` configs remain valid YAML (38/38 validated); all shell scripts pass `bash -n`; the `dependency-cruiser.config.cjs` passes `node --check`; all 38 `SKILL.md` frontmatter blocks intact.

---

## Engineering

- **README.md** — refreshed every skill description to match the upgrades; added a "How the flows fit together" overview.
- **ask-matt** — added a disambiguation table for easy-to-confuse skill pairs, a "stateful beats stateless" fallback rule, preserved the idea→ship router; PHASE-BOUNDARIES gained a "Worked examples" section (3 concrete boundaries) and the note that the tree decides this boundary, not the next.
- **code-review** — added review file-scoping for noisy diffs, spec body+comments fetching, briefs passing the file scope, and a "Close the loop" step covering the zero-findings and no-standards cases.
- **codebase-design** — promoted four principles to a priority-ordered "Sacred principles" section; added a 4th testability rule (model the domain in the interface); added "when to consult"; DEEPENING gained stand-in fidelity caveats, a "when NOT to deepen" section, per-category test strategies incl. real-adapter connectivity checks; DESIGN-IT-TWICE gained "the brief is a bribe for divergence" and comparison/ownership rules.
- **diagnosing-bugs** — "missing seam is itself a finding", a Phase 1 effort budget, a tighter completion gate, a multi-cause "bug genuinely too hard" section, a retro pointer; the hitl-loop template gained a `capture_yesno` helper (bash -n clean).
- **domain-modeling** — sharpened inline-capture payoffs, added the "what it excludes" tell and code-cross-reference framing, a "what it is not" guard; ADR-FORMAT gained "'Writing the why' tests"; GLOSSARY-FORMAT gained "what it IS not does" and the "_Avoid_ list is part of the definition" rule.
- **grill-with-docs** — expanded from a thin dispatcher into guidance on running grilling+domain-modeling as one loop, reading the glossary before the first round.
- **implement** — added pre-build anchors (fetch/state the ticket, read domain docs, confirm seams) and closing discipline: review-then-commit with a ticket-referencing message.
- **implement-spec** — added "Discipline for the subagent swarm": one ticket/one worktree, corruption containment, verify seams before the swarm fans out, keep the frontier fresh.
- **improve-codebase-architecture** — candidate-list cap with a ranking rule; closing note that grilling hands off to the main flow; HTML-REPORT gained offline/self-contained requirement and reinforced glossary-term discipline.
- **pr** — framed the three reader questions, added "evidence must be yours", sharpened the Merge Danger to name the door and its rollback cost; CREDITS note on provenance.
- **prototype** — branded the question as the spec, added "when the prototype is the wrong tool"; LOGIC gained "let the module's shape encode the model" and reject-visibly guidance; UI gained "encourage the hybrid explicitly".
- **research** — tight scoping (decision + boundaries), explicit output contract, feed-findings-back step.
- **retro** — severity-ordering rule and a "promise, then execute the handoff" closure.
- **setup-matt-pocock-skills** — prior-install preservation, label-existence check before creating, verify-what-you-wrote readback; tracker docs gained reliability notes (verify writes, bare-#42 resolution, one-state-line discipline); triage-labels.md is now the single source of truth.
- **tdd** — added "Running the loop" with the three signs a cycle went wrong, and a seams-are-a-contract note for the reviewer; tests.md/mocking.md gained seam-lens naming and boundary-line glosses.
- **to-spec** — cold re-read before publishing, "good story names actor and benefit", seams echoed into Testing Decisions.
- **to-tickets** — graph verification after publishing, a "Refining the breakdown" section on merge/split/hidden-dependency decisions.
- **triage** — "Discipline under concurrency" (re-read before write, one comment per change, verify the write); AGENT-BRIEF gained binary criteria and a Self-contained principle; OUT-OF-SCOPE gained trust-and-append guidance.
- **wayfinder** — deepened one-ticket-per-session rationale, "Handing off, not building", end-to-end handoff to /to-spec.
- **wizard** — "when to reach for a wizard", authoring rules, re-run/idempotency; template.sh extended to a two-stage example with a confirm-gated pure-action stage (bash -n clean).

## In-progress

- **chief-of-staff** — goal decomposition with the goal doc as single source of truth, spawn-vs-keep decision rules, environment-debt scan, subagent failure verification/retry, closing rhythm.
- **claude-handoff** — structured handoff summary shape (Task/state/next/constraints/suggested skills/open questions), verify-before-you-hand-off step.
- **loop-me** — concrete grilling moves, suggested spec skeleton with failure-mode/output fields, definition-of-done litmus test, unspecified fields stay open.
- **setup-ts-deep-modules** — negative test as non-negotiable proof, troubleshooting section (fail-to-fail, over-matching regex, path-alias monorepo gotchas); config comments clarified.
- **writing-beats / writing-fragments / writing-shape** — "choosing the beats to offer", running-the-grilling structure, heading-vs-no-heading format argument, spine-keeper angle-earning, anti-batching rationale.
- **README.md** — descriptions updated to match.

## Productivity

- **grilling** — round-based grill deepened: worked example round, question-crafting rules (one decision per question, always a recommendation, prefill defaults), answer-shape rules, scope control (3–7 questions per frontier), done-with-tree-confirmation ending.
- **grill-me** — from a one-line alias to real guidance: what to expect (3–6 rounds, batch answering), four practical rules.
- **handoff** — full handoff document template (Goal/Current state/Decisions/Open questions/In-flight/How to resume/Suggested skills), "handoff is a diff, not a copy", redaction guidance.
- **teach** — five-step session loop (orient→set target→ground→teach→close), seven pre-write gates, ZPD adjustment signals; all four format files gained worked examples (filled sample mission, learning record, resource-grading gate, glossary creation timing).
- **to-questionnaire** — "asking for the gap" sub-step, question-crafting rules, don't-lead.
- **wait-what** — from a one-liner to a real procedure: what fires it, gap diagnosis, three-move re-pitch with template and rules.
- **writing-for-agents** — three on-theme worked examples (context-pointer sharpening, completion-criterion contrast, verify-by-running) and invocation-choice flow in SKILL-MECHANICS.

## Misc

- **git-guardrails-claude-code** — rebuilt with a blocked-command table (incl. force-with-lease), hook JSON payload mechanism, fail-open-on-missing-jq model, project-vs-global settings, blocklist customization, verification commands, troubleshooting.
- **migrate-to-shoehorn** — fromExact pattern with full-object example, decision table, better find-casts regex (as-unknown-as), tsc --noEmit verification workflow, common-pitfalls.
- **scaffold-exercises** — ASCII layout diagram, dash-case naming rules, "common failures and fixes" table, 6-step workflow, git-mv caveat, worked stubbing example.
- **setup-pre-commit** — package-manager detection table, husky-init behavior, core.hooksPath verification, lint-staged scope examples, precommit-wins note, pitfalls.
- **README.md** — descriptions updated to match.

## Deprecated

- Untouched — already a lean, correct stub ("bucket is currently empty; a retired skill is deleted, and the changeset that removes it names whatever replaced it"); nothing to upgrade.
