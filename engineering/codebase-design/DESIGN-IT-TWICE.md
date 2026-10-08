# Design It Twice

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout): your first idea is unlikely to be the best.

Uses the vocabulary in [SKILL.md](SKILL.md): **module**, **interface**, **seam**, **adapter**, **leverage**.

The premise is cheap and the payoff is large: you already know the constraints and the dependencies, and you can run the sub-agents in parallel while the user thinks. The only real cost is writing the briefs well — so the briefs carry the whole weight here. A weak brief produces three designs of the same thing and proves nothing.

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
- A rough illustrative code sketch to ground the constraints, not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

### 2. Spawn sub-agents

Spawn 3+ sub-agents in parallel. Each must produce a **radically different** interface for the deepened module.

Prompt each sub-agent with a separate technical brief (file paths, coupling details, dependency category from [DEEPENING.md](DEEPENING.md), what sits behind the seam). The brief is independent of the user-facing problem-space explanation in Step 1. Give each agent a different design constraint:

- Agent 1: "Minimize the interface: aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility: support many use cases and extension."
- Agent 3: "Optimise for the most common caller: make the default case trivial."
- Agent 4 (if applicable): "Design around ports & adapters for cross-seam dependencies."

**The brief is a bribe for divergence.** If two agents return morally equivalent designs, the constraint you gave them was too weak — the fault is in the brief, not the agents. When a design comes back that merely re-skinned the existing one, send it back once with a constraint that forces a structurally different answer ("the interface must not expose `X`", "callers should never touch `Y`").

Include both [SKILL.md](SKILL.md) vocabulary and GLOSSARY.md vocabulary in the brief so each sub-agent names things consistently with the architecture language and the project's domain language.

Each sub-agent outputs:

1. Interface (types, methods, params, plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
5. Trade-offs: where leverage is high, where it's thin

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated: the user wants a strong read, not a menu.

Comparison rules:

- **Judge on the interface, not the implementation.** A design that hides more behind a smaller interface is better even if its current implementation is uglier; implementation details are replaceable, the interface is the contract you're naming.
- **Judge on what actually varies** (see SKILL.md: two adapters justify a seam). A design that adds a seam nothing varies across is strictly worse, no matter how elegant.
- **Ruthlessly discard.** Drop a design that fails a hard constraint even if its good bits are attractive — salvage the bits into the hybrid instead of keeping the design alive.
- **Converge to an ownership call.** End with a recommendation, not "all viable". If you genuinely can't pick, say so and name what new information would break the tie.