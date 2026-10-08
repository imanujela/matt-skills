---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it. The plan is not the sequence of questions — it is the *tree of decisions* the questions reveal.

## Structure the work as a tree

The design tree is your working model of the plan. Every **decision** is a node; the decisions that can only be answered once it is settled are its children. Two decisions are independent when neither waits on the other; they sit on the same level. Keep expanding until every remaining decision can be settled *now* — nothing hangs off a question that isn't answered yet.

## Work the frontier in rounds

The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Work it in **rounds** — one round is a batch of questions asked together and answered together, after which you recompute the frontier.

Ask the whole frontier in one round. Number each question and give your recommended answer. Then stop and wait for the user's answers before anything else — never start acting on a half-answered round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

A worked round:

```
❓ **Q1 - Local admission**: 4-year or 2-year? What's the tuition ceiling? Do they want to stay in-state or go anywhere?

➡️ 4-year public in-state, under ~$25k total, and prefer a liberal-arts bent if the price allows.

---

❓ **Q2 - The actual driver**: which dominates — prestige, cost, location, or class size?

➡️ Cost and proximity over prestige.
```

Word each question so "yes" accepts your recommended answer. The recommendation **is** the default; the user overrides it only when it is wrong. That keeps rounds fast and surfaces disagreement instead of inviting silence.

## Crafting a question

- **One decision per question.** A compound ("what language, and what framework?") crams two answers into one node and hides a branch. Split it unless the frontier genuinely collapses both into one settled choice.
- **Give a recommendation every time.** A question with no `➡️` answer shoves the work back onto the user. The point of a default is to be *corrected*, not to be deferred to.
- **Prefill the obvious default.** When the field has an industry-standard answer, state it as the recommendation and let the user push back.
- **Lead with the question, not the essay.** Title first, body second; name the trade-off being decided so the user sees what answering costs them.

## Each answer reshapes the tree

Every answer does two things:

1. **Settles a node** — the decision is made, and the decisions that depended on it unlock and move into the frontier.
2. **Maybe splits it** — an answer that reveals a fork the user hadn't named ("we might also need OAuth") spawns new child decisions.

Recompute the frontier and ask the next round. A question whose answer depends on another question *still open in this round* belongs to a later round, never this one — don't ask a question you can't answer because a sibling is unanswered.

When an answer is vague ("we'll figure that out"), **don't let it settle the node.** A stack of hand-waved nodes is exactly the silent assumption you're here to expose. Surf the assumption by:

- **Restating it back**: "so the working assumption is X — correct?" (This also writes the decision down.)
- **Deferring it explicitly**: if the user truly doesn't know yet, mark it deferred with a fallback default and reopen it once the blocker clears.
- **Escalating the consequence**: name what breaks if the assumption is wrong, so the cost of leaving it unsaid is felt.

## Facts are your job

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, published docs, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

## Scope control

- The frontier usually holds **3–7 questions.** Fewer and you're under-exploring; more and you overload working memory and invite throwaway answers.
- **Order the frontier by foundation**: ask the decisions that unblock the most downstream questions first, so later rounds clear faster.
- If the frontier balloons past a manageable round, that's the signal the plan is too big. Say so and offer to split the effort into phases — or into separate grills.

## Done

The session is done when the frontier is empty: every branch visited, nothing left silently assumed. Announce the end and *show the tree* — the settled decisions and the explicitly deferred ones — so the user can confirm nothing is missing. Do not act on the plan until the user confirms you have reached a shared understanding.