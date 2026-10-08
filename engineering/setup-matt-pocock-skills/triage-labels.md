# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the "Label in our tracker" column to match whatever vocabulary you actually use.

## Reading this file

This is the *single source of truth* for the mapping. A skill that reads it should:

- Treat "Label in our tracker" as authoritative for this repo; never assume the canonical name equals the string.
- Apply the *role*, not the string. The row says what the role means; map that meaning onto the string.
- If a role has no tracker label (a row left blank), flag it rather than creating a near-duplicate label — the intent was to reuse an existing tracker label, and a blank means that's unresolved.

## When the vocabulary drifts

The five roles are fixed; the strings are not. If the tracker later renames a label, edit only this file's right-hand column — no skill reads hardcoded strings. If two roles collapse onto one tracker label, the mapping row should say so explicitly (e.g. "both `needs-info` and `needs-triage` map to `triage`"), because a collapse changes how the state machine behaves.