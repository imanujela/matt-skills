---
name: git-guardrails-claude-code
description: Install a Claude Code PreToolUse hook that blocks destructive git commands (push, reset --hard, clean -f/-fd, branch -D, checkout/restore .) before they run, per project or globally. Use when the user wants to add git safety hooks, prevent accidental git push/reset/clean in Claude Code, or harden a repo against destructive Bash commands.
---

# Set Up Git Guardrails for Claude Code

Installs a **PreToolUse** hook that intercepts Claude's Bash tool calls and refuses to let destructive `git` commands execute. When a command matches the blocklist, the hook denies the call with exit code 2 and explains why, so Claude must find a safe alternative or ask you first.

This is a guardrail against **accidental destructive operations**, not a full policy system: it matches a blocklist of common dangerous invocations. Because it stops commands before they run, nothing is lost — the only cost of a false positive is Claude asking you for permission.

## What Gets Blocked

| Command | Why it's dangerous |
| --- | --- |
| `git push` (incl. `--force`, `--force-with-lease`) | Publishes commits (and, forced, rewrites remote history). |
| `git reset --hard` | Destroys uncommitted changes and moves HEAD. |
| `git clean -f` / `-fd` / `-fdx` | Permanently deletes untracked files/directories. |
| `git branch -D` | Deletes a branch without checking whether it's merged. |
| `git checkout .` / `git restore .` | Discards every working-tree change at once. |
| `git checkout -- <path>` / `git restore <path>` | Discards a specific path's uncommitted changes. |

The blocklist also catches these when they are **chained** (`cd x && git push`, `a || b`, subshells) and when the command is **multiline**, because the hook normalizes the command onto one line before matching.

## How the Hook Works

Claude Code sends each Bash call to configured hooks as a JSON payload on stdin:

```json
{ "tool_name": "Bash", "tool_input": { "command": "git push origin main" } }
```

The hook script:

1. Reads the payload and extracts `.tool_input.command` with `jq`.
2. Flattens newlines and matches it against the blocklist (`grep -E`).
3. Exits `0` to *allow* the command, or `2` to *deny* it (Claude Code treats non-zero as denied and shows the hook's stderr message to Claude).

If `jq` is missing or the payload is unparseable, the hook **fails open** (exit 0) rather than blocking every Bash call — losing a guardrail is safer than bricking all shell access.

## Steps

### 1. Ask the install scope

Ask the user: install for **this project only** or **all projects**?

- **Project** → `.claude/settings.json` and `.claude/hooks/` (committed to the repo)
- **Global** → `~/.claude/settings.json` and `~/.claude/hooks/` (applies to every project)

Check whether the repo already has a `.claude/` directory before deciding.

### 2. Copy the hook script

The bundled script is at [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh). Copy it into the target hook directory and make it executable:

```bash
# Project
mkdir -p .claude/hooks
cp <repo>/skills/misc/git-guardrails-claude-code/scripts/block-dangerous-git.sh .claude/hooks/
chmod +x .claude/hooks/block-dangerous-git.sh

# Global
mkdir -p ~/.claude/hooks
cp <repo>/skills/misc/git-guardrails-claude-code/scripts/block-dangerous-git.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/block-dangerous-git.sh
```

### 3. Register the hook in settings

Add a `PreToolUse` hook for the `Bash` tool. **Project** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Match rule:** use `"matcher": "Bash"` so the hook runs for *every* Bash call. If the repo runs commands through a different tool, register a hook for that tool too — otherwise commands slip past the guardrail.

**Handle an existing settings file:** if `.claude/settings.json` or `~/.claude/settings.json` already exists, merge the hook into its existing `hooks.PreToolUse` array. Never overwrite other settings (permissions, other hooks, MCP config). If hooks already exist, append to the array rather than replacing it.

### 4. Customize the blocklist (ask first)

Ask whether the user wants to add or remove patterns. Common additions:

- `git push -f` / `--force-with-lease` (already covered by `git push`, but keep for clarity)
- `git rebase` (if you want to forbid rewrites)
- `git stash drop`

Edit the `DANGEROUS_PATTERNS` array in the copied script. Note the patterns are extended regexes — `\.` matches a literal dot, `\s+` matches whitespace.

### 5. Verify

Test that the hook blocks and allows as expected:

```bash
SCRIPT=~/.claude/hooks/block-dangerous-git.sh   # or the project path

# Should be denied (exit 2):
echo '{"tool_input":{"command":"git push origin main"}}' | "$SCRIPT"; echo "exit=$?"

# Should be allowed (exit 0):
echo '{"tool_input":{"command":"git status"}}' | "$SCRIPT"; echo "exit=$?"
```

A denied call prints a `BLOCKED:` line to stderr and exits `2`; a safe call exits `0` (you should see only `exit=0`, no output).

Then confirm Claude Code actually enforces it by asking Claude (in a sandbox repo) to run `git push` and confirming it gets refused with the guardrail message.

## Troubleshooting

- **Hooks never fire** → make sure the settings file is at the exact path Claude Code reads (`~/.claude/settings.json` for global), the JSON is valid, and `matcher` is `"Bash"`. Restart Claude Code after editing settings files.
- **Permission denied executing the script** → run `chmod +x <script-path>`.
- **Hook blocks everything** → check `jq` is installed (`command -v jq`); if the script can't parse the payload it fails open, so this usually means a pattern matches too broadly (e.g. a comment or error string containing `git push`). Tighten the pattern.
- **`$CLAUDE_PROJECT_DIR` empty (project scope)** → your `settings.json` may not be in `.claude/`; use an absolute path to the hook instead.