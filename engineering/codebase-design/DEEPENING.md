# Deepening

How to deepen a cluster of shallow modules safely, given its dependencies. Assumes the vocabulary in [SKILL.md](SKILL.md): **module**, **interface**, **seam**, **adapter**.

The single question that decides everything in this file is: **what does a test of the deepened module have to stand in for?** Classify the dependencies first; the answer selects the testing strategy, and the testing strategy selects how aggressively you can merge.

## Dependency categories

When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested across its seam — and, just as importantly, what happens when the deepening is impossible or not worth it.

### 1. In-process

Pure computation, in-memory state, no I/O. Always deepenable: merge the modules and test through the new interface directly. No adapter needed.

This is the happy case and the one to look for first, because it costs the least: no port, no adapter, no stand-in, just a merge and a new interface. Deepening an in-process cluster is almost always the right move.

### 2. Local-substitutable

Dependencies that have local test stand-ins (PGLite for Postgres, in-memory filesystem). Deepenable **if the stand-in exists**. The deepened module is tested with the stand-in running in the test suite. The seam is internal; no port at the module's external interface.

Caveats to hold in your head before committing to a stand-in:

- **Fidelity gap.** A stand-in is a *model* of the real thing. It diverges exactly where real bugs live: PGLite won't reproduce a Postgres constraint or index quirk, an in-memory FS won't reproduce a real disk-full or permission failure. A test green against the stand-in is not a green pass against production. Decide explicitly which failures the seam is meant to catch.
- **When the gap bites, the seam is genuinely at the wrong level.** If the divergence keeps biting you, that's the signal the in-process "same boundary" assumption is wrong and the dependency is really category 3 or 4 — reclassify and deepen accordingly.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses an HTTP/gRPC/queue adapter.

Recommendation shape: *"Define a port at the seam, implement an HTTP adapter for production and an in-memory adapter for testing, so the logic sits in one deep module even though it's deployed across a network."*

Test the logic against the in-memory adapter *and* keep (or add) one thin connectivity test that drives the real HTTP adapter end to end, so the port actually matches the wire. A port that only ever has a mock backing it is a hypothesis.

### 4. True external (Mock)

Third-party services (Stripe, Twilio, etc.) you don't control. The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

The distinction from category 3 matters: you can't make the real adapter in category 4, so the mock **is** your only window. When the external API changes, the mock won't tell you. Mitigations:

- Keep an integration test behind an env-var flag (run manually or in CI on a schedule) that hits the real third party.
- Record-and-replay fixtures (VCR-style) so a green run reflects *some* real interaction, not pure invention.

## Seam discipline

- **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection.
- **Internal seams vs external seams.** A deep module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface. Don't expose internal seams through the interface just because tests use them. The interface is for callers; internal seams are for the module's own tests.

## Testing strategy: replace, don't layer

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist; delete them. Keeping them gives you a safety net that now tests the wrong thing — the internals you deleted — and it quietly rots.
- Write new tests at the deepened module's interface. The **interface is the test surface**.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors, since they describe behaviour, not implementation. If a test has to change when the implementation changes, it's testing past the interface.

## When NOT to deepen

Deepening is the default, not a law. Hold the candidate against these before committing:

- **The cluster is genuinely two modules with two audiences.** If the "shallow" seam serves a real second caller with a distinct mental model, collapsing it forces both callers to learn one combined interface — a locality *loss*.
- **The deepening would drag in a hard dependency you can't stand in for** (category 4 with no good mock). Then you've swapped shallow modules for one module that's untestable at its only seam.
- **The change is risk without payback.** If the cluster changes rarely and is understood, deepening buys future leverage you may never spend. Title the candidate correctly before starting: is this *deepening* or *reorganisation*? Only the former is this skill's job.