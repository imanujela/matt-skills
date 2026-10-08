# Issue tracker: Local Markdown

Issues and specs for this repo live as markdown files in `.scratch/`.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`, never a single combined tickets file
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `.scratch/<effort>/map.md` (the Notes / Decisions-so-far / Fog body).
- **Child ticket**: `.scratch/<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question in the body. A `Type:` line records the ticket type (`research`/`prototype`/`grilling`/`task`); a `Status:` line records `claimed`/`resolved`.
- **Blocking**: a `Blocked by: NN, NN` line near the top. A ticket is unblocked when every file it lists is `resolved`.
- **Frontier**: scan `.scratch/<effort>/issues/` for files that are open, unblocked, and unclaimed; first by number wins.
- **Claim**: set `Status: claimed` and save before any work.
- **Resolve**: append the answer under an `## Answer` heading, set `Status: resolved`, then append a context pointer (gist + link) to the map's Decisions-so-far in `map.md`.

## Discipline for the local tracker

Because there's no server enforcing consistency, the local tracker depends on these being honoured by hand:

- **One state line, one place.** Put `Status:`/`Type:`/`Blocked by:` near the top of the file and never duplicate them elsewhere; a skill reading the file trusts the top block.
- **Append, don't overwrite.** Comments and resolution answers append under their `##` headings. Editing history that already exists deletes evidence later skills (like `/triage` resuming a session) rely on.
- **Numbering is the order.** `01` is the earliest/bottommost blocker-free ticket; keep numbering stable once published — renumbering a published set breaks every `Blocked by` reference.
- **Grep the frontier, don't eyeball it.** Listing `.scratch/<effort>/issues/` and checking each file's `Status:` and `Blocked by` lines programmatically beats trusting memory of what's resolved.