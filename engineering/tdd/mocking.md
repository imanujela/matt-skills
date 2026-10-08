# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

The boundary line is the same one `/codebase-design` draws: a mock is a stand-in for something that *varies across the seam* and that you can't cheaply run in tests. If what you're tempted to mock is your own logic, you're about to test your own code against a copy of itself — which asserts nothing.

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```typescript
// Easy to mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```typescript
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

The SDK approach means:
- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint

## Shaping a mock for the test

A mock is a *servant of one test*. Shape it to what that test asserts:

- **Return a known fixture**, not a method that re-implements the real thing. If the mock recomputes the same logic the code under test does, you've built the tautological anti-pattern into the seam.
- **Limit to the calls the path makes.** A mock that exposes every method the real dependency has invites "while we're here" assertions that couple the test to calls it never makes in the scenario.
- **Prefer behaviour the test can observe** over call-count assertions. Asserting `charge` returned an order id the caller acts on tests the contract; asserting "process was called twice" tests the wiring and breaks on any reordering.

## When a test DB beats a mock

For a database, prefer a real test database (or a local stand-in like PGLite / an in-memory filesystem): it exercises real queries, constraints, and transactions, which is where the actual bugs live. Use a mock only when the real thing (or a faithful stand-in) is genuinely unavailable or too slow. See `codebase-design/DEEPENING.md`'s **local-substitutable** category — and hold onto its caveat: a stand-in that never diverges from production is standing in for nothing.
