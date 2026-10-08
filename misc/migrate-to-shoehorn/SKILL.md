---
name: migrate-to-shoehorn
description: Replace `as` type assertions in test files with type-safe partial data from @total-typescript/shoehorn (fromPartial, fromAny, fromExact). Use when the user mentions shoehorn, wants to remove `as`/`as unknown as` casts in tests, or needs to pass partial test data without faking an entire object.
---

# Migrate Tests to Shoehorn

`@total-typescript/shoehorn` lets you pass **partial data** to a function that expects a fuller type, while keeping TypeScript's type checking — replacing `as` assertions in test code.

**Test code only.** Shoehorn exists to smooth over friction that only exists in tests. Never import it in production code.

## Why `as` is a problem in tests

- **It suppresses safety** — `as` tells TypeScript "trust me", so a wrong shape silently passes and the test reflects the lie, not reality.
- **It's a smell** — reviewers and linters treat `as` as something to eliminate (`no-explicit-any`-style rules), so it accumulates warnings.
- **Double-casting for wrong data** — `as unknown as Type` is required to pass intentionally-wrong data, which is ugly and undocumented intent.
- **It forces full fakes** — to call a function you must hand it an *entire* object, so you fabricate scores of unused fields just to reach the one you care about.

Shoehorn keeps the type checking on the data you do provide and doesn't make you provide the rest.

## Install

```bash
npm i -D @total-typescript/shoehorn
```

## The three main tools

| Function | Use case | Guidance |
| --- | --- | --- |
| `fromPartial()` | Pass a **subset** that still type-checks against the target | Your default — replace most `as Type` casts. |
| `fromExact()` | Pass a **full** object; insist it's complete | Use when the function genuinely needs everything; swap to `fromPartial` if the object later grows. |
| `fromAny()` | Pass **intentionally wrong** data (error/edge-case testing) | Keeps autocomplete on the object you pass, unlike a bare `as any`. |

## Migration patterns

### Large object, only a few fields matter

Before — must fake the entire `Request` just to reach `body.id`:

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...20 more properties
};

it("gets user by id", () => {
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fake all 20 properties you don't even use
  });
});
```

After — supply only `body.id`:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(fromPartial({ body: { id: "123" } }));
});
```

### `as Type` → `fromPartial()`

Before:

```ts
getUser({ body: { id: "123" } } as Request);
```

After:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

When passing data with a deliberately wrong type (e.g. a number where a string is expected, to test malformed input):

Before:

```ts
getUser({ body: { id: 123 } } as unknown as Request); // wrong type on purpose
```

After:

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

### `as` on a full object → `fromExact()`

When the function really needs the complete object and you don't want partials silently slipping through:

Before:

```ts
const req: Request = { body: { id: "1" }, headers: {}, cookies: {} } as Request;
```

After:

```ts
import { fromExact } from "@total-typescript/shoehorn";

const req = fromExact({ body: { id: "1" }, headers: {}, cookies: {} });
```

Use `fromExact` to *enforce* completeness now; if the type later grows and you stop wanting to provide every field, swap it for `fromPartial`.

## Choosing the right tool

Ask three questions for every cast:

1. **Is the data mostly right?** → `fromPartial()` (the common case).
2. **Is it a full, deliberately-correct object?** → `fromExact()`.
3. **Is it intentionally malformed for an error test?** → `fromAny()`.

Anything else (truly unrelated type conversions, widening to an interface) may still need `as` — shoehorn is for *shaping data to fit*, not for bridging fundamentally different types. Prefer `satisfies` over `as` when all you want is for TypeScript to *validate* a literal against a type rather than supply it as an argument.

## Workflow

1. **Scope the work** — ask the user:
   - Which test files are the problem?
   - Are they faking big objects to reach a few fields? (→ `fromPartial`)
   - Do they pass deliberately-wrong data for error cases? (→ `fromAny`)
   - What's in the last failing `tsc` output so you can verify against it.

2. **Install** the dependency as a devDependency:
   ```bash
   npm i -D @total-typescript/shoehorn
   ```

3. **Find the casts.** `as unknown as` appears in hundreds of files, so narrow it with a regex that catches both forms:
   ```bash
   # ripgrep
   rg -n "as (unknown as )?[A-Z][A-Za-z]" --glob '*.test.ts' --glob '*.spec.ts' .
   # or grep
   grep -rnE "as (unknown as )?[A-Z][A-Za-z]" --include='*.test.ts' --include='*.spec.ts' .
   ```

4. **Convert each cast:**
   - `as Type` → wrap the object in `fromPartial(...)` (or `fromExact(...)` if it must be complete).
   - `as unknown as Type` → wrap in `fromAny(...)`.
   - Remove the cast; add the import: `import { fromPartial, fromAny, fromExact } from "@total-typescript/shoehorn";`

5. **Run the type check** and confirm the suite:
   ```bash
   npx tsc --noEmit
   npm test
   ```

6. **Check for leftovers** — any remaining `as unknown as` is a candidate for `fromAny`; flag non-trivial `as` casts to the user rather than removing them blindly.

## Common pitfalls

- **Don't reach for `fromAny` first.** It disables checking on the fields you pass, so it's the escape hatch, not the default. Prefer `fromPartial`, which still type-checks the properties you supply.
- **`fromExact` isn't a permanent choice.** Switch to `fromPartial` when an object grows and you don't want to maintain every field in tests.
- **Keep shoehorn out of production.** If an import of `@total-typescript/shoehorn` appears outside test files, that's a bug — move it.
- **Verify the type check actually passes.** A migration that leaves `tsc --noEmit` red hasn't finished even if the casts are gone.