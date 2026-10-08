---
name: scaffold-exercises
description: Create lint-ready exercise directory structures (sections > exercises > problem/solution/explainer variants) in a pnpm course repo, then validate with `pnpm ai-hero-cli internal lint` and commit. Use when the user wants to scaffold exercise stubs, set up a new course section, or restructure/renumber existing exercises.
---

# Scaffold Course Exercises

Create exercise directory structures that pass `pnpm ai-hero-cli internal lint`, then commit them. The linter is strict about naming, required files, and forbidden files — scaffold to its rules the first time so you don't iterate on errors.

## Directory layout

```
exercises/
└── 01-section-name/            # "XX=section number"
    ├── 01.01-exercise-name/    # "XX.YY=exercise number"
    │   ├── problem/            # student workspace with TODOs
    │   │   └── readme.md
    │   ├── solution/           # reference implementation
    │   │   └── readme.md
    │   └── explainer/          # conceptual material, no TODOs
    │       └── readme.md
    └── ...
```

- **Sections** live under `exercises/` as `XX-section-name/` (e.g. `01-retrieval-skill-building`).
- **Exercises** live inside a section as `XX.YY-exercise-name/` (e.g. `01.03-retrieval-with-bm25`).
- `XX` is the section number, `XX.YY` the exercise number. Longer indices (`01.02.03` or a trailing variant like `explainer.1/`) are respected by the linter.
- Names are **dash-case**: lowercase letters and hyphens only — no spaces, no uppercase, no underscores.

## Exercise variants

Each exercise needs **at least one** of these subfolders:

- `problem/` — the student's starting point; contains TODOs to fill in.
- `solution/` — the reference implementation.
- `explainer/` — conceptual walk-through; must NOT contain TODOs.

When stubbing from vague instructions, **default to `explainer/`** unless the plan names specific variants. A readme-only explicaer is almost always enough to satisfy the linter.

## Required files

Every variant subfolder needs a `readme.md` that:

- Is **non-empty** (a single title line is enough to pass).
- Contains **no broken links** — any markdown link must resolve, or lint fails.

**For a stub**, a minimal readme is sufficient:

```md
# Exercise Title

Short description of what this exercise covers.
```

**If the subfolder contains code**, it must also have a `main.ts` longer than one line. Readme-only subfolders (no code) skip that requirement — which is why stubbing readme-only is the fastest path to a green lint.

## What the linter checks

`pnpm ai-hero-cli internal lint` enforces (roughly, in order of how often they bite):

1. Each exercise has proper variant subfolders.
2. At least one of `problem/`, `explainer/`, or an `explainer.1/` variant exists.
3. `readme.md` exists and is non-empty in the variant subfolder.
4. No `.gitkeep` files anywhere in the exercise tree.
5. No `speaker-notes.md` files (they leak into the wrong output).
6. No broken links inside readmes.
7. No `pnpm run exercise` commands inside readmes.
8. `main.ts` is required per subfolder **unless** the subfolder is readme-only.

## Common failures and fixes

| Lint error | Likely cause | Fix |
| --- | --- | --- |
| Readme missing/empty | Folder created with `mkdir` but no readme | Create a `readme.md` with a title line. |
| Broken link | A relative path or URL in a readme that 404s | Remove the link or point it at a real path. |
| `.gitkeep` found | Scaffolder tool created placeholder files | `find exercises -name .gitkeep -delete` |
| `speaker-notes.md` found | Copied from an older template | `find exercises -name speaker-notes.md -delete` |
| `pnpm run exercise` in readme | Copied instructions | Rewrite the readme to describe the exercise, not run it. |
| `main.ts` too short | A one-line stub | Add real code (>1 line) or keep the folder readme-only. |
| Wrong naming | Uppercase, spaces, or underscores in a name | Rename to dash-case and renumber. |

## Workflow

1. **Parse the plan** — extract section names, exercise names (including numeric prefixes), and which variant each exercise needs.
2. **Create directories** — `mkdir -p` each path, one command per exercise:
   ```bash
   mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
   ```
3. **Create stub readmes** — one `readme.md` per variant folder, title matching the exercise name.
4. **Run lint** — `pnpm ai-hero-cli internal lint`. Expect it to surface a few naming/readme issues the first time.
5. **Fix until green** — use the table above, then re-run.
6. **Commit** — stage and commit the new exercise trees.

## Moving & renumbering exercises

1. **Use `git mv`, not `mv`** — preserves history:
   ```bash
   git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
   ```
2. Update the numeric prefix to keep the section ordering sequential.
3. If you renamed a *file* inside the folder (not just the folder), stage the rename with `git add` after the `git mv`; `git mv` alone records the folder rename but a subsequent content change needs staging.
4. Re-run `pnpm ai-hero-cli internal lint` after every move before committing.

## Worked example: stubbing from a plan

Given a plan:

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

Create the trees:

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

Then write readme stubs (each with `# <Title>` plus a one-line description):

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md
```

Result as the linter sees it:

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md      # ok
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md           # ok
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md             # ok
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md            # ok
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md            # ok
```

All five are readme-only, so no `main.ts` is needed and lint should pass. Run `pnpm ai-hero-cli internal lint` to confirm, fix any flags, then commit the section.
