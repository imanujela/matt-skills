---
name: loop-me
description: Grill me about specs for the workflows I want to build, within this workspace.
disable-model-invocation: true
argument-hint: "A workflow to design, or nothing to go find one"
---

Run a stateful `/grilling` session whose only output is **workflow** specs. Use the grilling discipline (relentless, a round of questions at a time, a recommended answer attached to each) aimed at the vocabulary and goal below. Create, edit, and delete specs as the grilling resolves things.

## The loop lens

A **loop** is a recurring pattern in the user's life: their career, their week, their morning, a single repeated activity. Picturing a life as loops within loops reveals how predictable its activities really are, which is what makes them worth **delegating**. Use the lens to find loops worth specifying, and propose ones the user hasn't noticed.

A **workflow** is the spec of one loop, made real. You run a workflow on a loop: the loop is its running instantiation. Workflows live in `workflows/*.md` and are the source of truth.

The move is always: *notice the loop, then make the loop delegable.* When you spot a loop the user repeats, ask whether it's worth capturing as a workflow. When an existing workflow drifts from reality, the loop has changed — update the spec.

## Vocabulary

A shared language, reached for only when a workflow calls for it: never a checklist. **Mandate nothing structural**: a workflow needs no AI, no checkpoint, and no schedule unless the grilling shows it does.

- **Trigger**: what fires each run, an **event** (a new email, a new issue) or a **schedule** (every morning). Event-triggering is usually the more efficient — prefer it over a fixed schedule that can fire when there's nothing to do.
- **Checkpoint**: a human-in-the-loop point where the user is asked to verify or decide. Some workflows have none and run autonomously; some use no AI at all.
- **Push right**: defer the checkpoint as far as it will go. Do maximal work before involving the human, so they are asked once, late, with everything prepared.
- **Brief**: what a checkpoint presents, a tight, decision-ready summary (what was produced, why, and a link down to the asset itself), never the raw output. The user reads a brief, not a draft. Speed of review is imperative.

### Grilling moves that work here

- "What fires this loop?" If the answer is "every Tuesday" rather than an event, ask whether it could be event-triggered instead.
- "At what point does a human *must* look at this?" That's your checkpoint — then push it right: what has to be true before the human is worth interrupting?
- "What does the human need to see to decide in five seconds?" That's the brief. If they'd need to open the whole asset, the brief is wrong.
- "What could go wrong if this ran with no human?" A workflow that runs autonomously needs a defined failure mode and a place to land when it fails.
- "Walk me through the last time this happened." Concrete, specific; anchored loops specify far better than hypothetical ones.

## Definition of done

A workflow spec is done when an implementer agent could build it without asking a single question. Grill until then; nothing is done while a question remains. The litmus test: read the spec in one pass and confirm there is no "how do I figure out X?" an implementer would have to guess at — the trigger, the steps, the checkpoint, the brief, the failure mode, and the output location are all pinned down.

## The workspace

- `workflows/*.md`: one spec per workflow.
- `NOTES.md`: raw notes on the user's world, the tools they use, the channels they process, and their own terminology for both. When it is empty or thin, interview them about their world before specifying anything. Sharpen fuzzy terms into canonical ones as they surface, and record them here.

### Suggested spec skeleton

Not a mandate — a default shape, filled in only as the grilling resolves things:

- **Trigger**: what fires each run (event or schedule), and how the run is started.
- **Inputs**: what the run reads or collects, and where those come from.
- **Steps**: the work, in order, with explicit dependencies.
- **Checkpoint / brief**: whether a human is involved, at what point, and the exact shape of the brief they review.
- **Output**: what the run produces and where it lands.
- **Failure mode**: what happens when a step fails — retry, alert, or human escalation.

When the grilling leaves a field genuinely undetermined, mark it and keep it open rather than inventing an answer; inventing one is how unusable specs get written.