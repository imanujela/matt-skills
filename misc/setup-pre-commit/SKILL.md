---
name: setup-pre-commit
description: Add Husky pre-commit hooks with lint-staged, Prettier, type checking, and tests to the current JS/TS repo. Use when the user wants to add pre-commit hooks, set up Husky, configure lint-staged or Prettier, or enforce commit-time formatting/typechecking/testing.
---

# Set Up Pre-Commit Hooks

Adds a Husky pre-commit hook that runs **lint-staged** (Prettier on staged files), then a full **typecheck** and **test** pass, so nothing broken or unformatted gets committed.

## What This Sets Up

- **Husky** — the pre-commit hook runner (v9+).
- **lint-staged** — runs Prettier only on files you've staged (fast).
- **Prettier** config (only if the repo doesn't already have one).
- **typecheck** and **test** scripts gated in the pre-commit hook.

## Steps

### 1. Detect the package manager

Look at your `package.json` and the lockfile that's actually present:

| Manager | Lockfile | Inject with |
| --- | --- | --- |
| npm | `package-lock.json` | `npx` / `npm run` |
| pnpm | `pnpm-lock.yaml` | `pnpm` / `pnpm run` |
| yarn | `yarn.lock` | `yarn` / `yarn run` |
| bun | `bun.lockb` / `bun.lock` | `bun` / `bun run` |

Use whichever lockfile exists. **Default to npm** if none is found or unclear. From here on, substitute your manager's `npx`/`npm run` equivalents.

### 2. Install dependencies (devDependencies)

```bash
npm install -D husky lint-staged prettier
```

If you don't want Prettier opinionated to a new config, install `husky` and `lint-staged` only; the rest still works, but formatting won't be enforced.

### 3. Initialize Husky

```bash
npx husky init
```

This creates the `.husky/` directory with a sample `pre-commit` hook and adds `"prepare": "husky"` to `package.json` (Husky v9+ uses that prepare script to set `core.hooksPath`). It may also run `npm install` to trigger the prepare script — leave that if it does.

### 4. Write `.husky/pre-commit`

`husky init` generates a default hook; **replace its contents** with (npm example):

```
npx lint-staged
npm run typecheck
npm run test
```

**Adapt to the repo:**
- Replace `npm` with the detected package manager (`pnpm lint-staged`, `pnpm run typecheck`, etc.).
- If `package.json` has no `typecheck` or `test` script, **omit those lines and tell the user**. Don't invent scripts; wiring a missing script would make every commit fail.
- The `npx lint-staged` line can be `pnpm lint-staged` when pnpm is used; keep it matched to the manager so there's no surprise resolution.
- **No shebang is needed for Husky v9+** — hook files run fine without `#!/bin/sh`.

### 5. Create `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

`--ignore-unknown` makes Prettier skip files it can't parse (images, lockfiles, binaries) instead of erroring. Optionally scope to code globs if you want Prettier to only touch certain types:

```json
{
  "**/*.{js,ts,tsx,jsx,json,md,css}": "prettier --write"
}
```

### 6. Create `.prettierrc` (only if missing)

Add Prettier config **only when the repo has none** (check for any `.prettierrc*`/`prettier.config.*`; an existing one takes priority and must not be overwritten). Defaults:

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. Verify

- [ ] `.husky/pre-commit` exists
- [ ] `.husky/pre-commit` is executable (`chmod +x .husky/pre-commit`)
- [ ] `.lintstagedrc` exists
- [ ] `prepare` in `package.json` is `"husky"`
- [ ] `git config core.hooksPath` returns `.husky` (Husky sets this via `husky init`; if empty, run `npx husky` once)
- [ ] A Prettier config exists (repo's own or the new `.prettierrc`)
- [ ] `npx lint-staged` runs without error on a staged file

If the hook isn't firing on commit, check `core.hooksPath` first — the most common silent failure is that it points somewhere other than `.husky`.

### 8. Commit

Stage all new/changed files and commit — this exercises the fresh hook as a smoke test:

```bash
git add .
git commit -m "Add pre-commit hooks (husky + lint-staged + prettier)"
```

The commit should pause for lint-staged to format staged files, then typecheck and test. If any of those fail, the commit is blocked — which is the point: fix the failure and re-commit.

## Notes & pitfalls

- **Husky v9+ needs no shebang** in hook files (older tutorials insist on one; it's unnecessary and a common source of confusion).
- **`prettier --ignore-unknown`** prevents commit failures on non-Prettier files.
- **Order matters**: lint-staged runs first because it's cheap and only touches staged files; the full `typecheck`/`test` come after because they're slower. Both are part of the pre-commit gate.
- **Don't over-scope lint-staged globs** at first — the `"*"` catch-all with `--ignore-unknown` is the least surprising config and easiest to extend later.
- **Existing Prettier config wins** — never overwrite a repo's current Prettier setup; respect `package.json#prettier` too.
- If `typecheck` or `test` don't exist yet, tell the user the hook only formats until those scripts are added — don't fabricate commands.
