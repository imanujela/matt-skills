#!/bin/bash
#
# PreToolUse hook for Claude Code that blocks destructive git commands.
#
# Claude Code spawns this hook and pipes a JSON payload to stdin:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }
# A non-zero exit denies the Bash tool call; stderr is surfaced to Claude.
# Exit code 2 is used to signal an explicit block (mirrors Claude Code's
# own hook convention), 0 allows the command to run.
#
# Safety model:
#   - Patterns are conservative: they match common, destructive invocations.
#   - Missing jq or an unparseable payload FAILS OPEN (exit 0) so the
#     guardrail never silently bricks every Bash call in the session.
#
# Install via the git-guardrails-claude-code skill, per project or globally.

set -u

# --- Read the hook payload ---------------------------------------------
INPUT="$(cat)"

# --- Extract the command, failing open if we cannot parse it -----------
if ! command -v jq >/dev/null 2>&1; then
  echo "hook: jq not installed; refusing to block on unparseable input" >&2
  exit 0
fi

COMMAND="$(printf '%s' "$INPUT" | jq -r 'if (.tool_input.command // null) != null then .tool_input.command else empty end' 2>/dev/null)"

# No command to inspect -> nothing to block.
if [ -z "$COMMAND" ]; then
  exit 0
fi

# --- Normalize: one line so multiline / chained commands are matched ----
# Commands commonly arrive as "cd x && git push", "a || b", subshells, or
# true multiline strings. Flatten newlines and match the whole buffer.
COMMAND_ONELINE="$(printf '%s' "$COMMAND" | tr '\n' ' ')"

# --- Blocklist ----------------------------------------------------------
# Each pattern is an extended-regex (grep -E). Prefer the narrowest form
# that still catches the destructive intent. `\.` in a pattern matches a
# literal dot (brace expansion / dotfiles). Order does not matter.
DANGEROUS_PATTERNS=(
  # Any push, including --force / --force-with-lease.
  "git push"
  "push --force"
  # Hard resets discard uncommitted work.
  "git reset --hard"
  "reset --hard"
  # Clean removes untracked files (-f required; -d for directories).
  "git clean\s+-[fd]*"
  # Branch -D deletes a branch without checking merge status.
  "git branch -[dD]"
  # Checkout / restore of "." (or a path) discards working-tree changes.
  "git checkout \."
  "git restore \."
  # Prevent `git checkout -- <path>` from also slipping through.
  "git checkout --"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if printf '%s' "$COMMAND_ONELINE" | grep -qE "$pattern"; then
    echo "BLOCKED: the command '$COMMAND' matches dangerous pattern '$pattern'. You do not have permission to run this. Use a safe alternative (e.g. stash the change, or checkout a specific file from a branch) or ask the user before proceeding." >&2
    exit 2
  fi
done

exit 0