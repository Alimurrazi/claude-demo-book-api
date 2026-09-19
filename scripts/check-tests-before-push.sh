#!/usr/bin/env bash
set -euo pipefail

# Claude Code invokes PreToolUse hooks for every matching tool call and passes
# the tool call as JSON on stdin: {"tool_name":"Bash","tool_input":{"command":"..."}, ...}
# The hook matcher can only match on tool name ("Bash"), not on the command
# text, so this script itself decides whether the triggering command is a
# `git push` and is a no-op for every other bash command.
hook_input="$(cat 2>/dev/null || true)"

extract_command() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$hook_input" | jq -r '.tool_input.command // empty'
  else
    printf '%s' "$hook_input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(\([^"\]\|\.\)*\)".*/\1/p' | head -1
  fi
}

triggering_command="$(extract_command)"

# Not a git push? Let it through untouched.
if [ -n "$hook_input" ] && ! printf '%s' "$triggering_command" | grep -qE '(^|[;&|[:space:]])git push([[:space:]]|$)'; then
  exit 0
fi

BASE_BRANCH="${BASE_BRANCH:-}"
if [ -z "$BASE_BRANCH" ]; then
  if git rev-parse --verify --quiet origin/main >/dev/null; then
    BASE_BRANCH="origin/main"
  elif git rev-parse --verify --quiet origin/master >/dev/null; then
    BASE_BRANCH="origin/master"
  else
    BASE_BRANCH="origin/main"
  fi
fi

changed_files=$(git diff --name-only "$BASE_BRANCH"...HEAD)
missing_tests=()

while IFS= read -r file; do
  [ -z "$file" ] && continue
  case "$file" in
    *.test.ts|*.test.js|*.spec.ts|*.spec.js) continue ;;
    *.ts|*.js) ;;
    *) continue ;;
  esac
  base="${file%.*}"
  expected_test="${base}.test.${file##*.}"
  if ! echo "$changed_files" | grep -qx "$expected_test"; then
    missing_tests+=("$file")
  fi
done <<< "$changed_files"

if [ "${#missing_tests[@]}" -gt 0 ]; then
  # On exit 2, Claude Code only relays stderr back as the block reason, so
  # the message must go there, not stdout, or it arrives blank.
  {
    echo "Blocked: these changed files have no matching test file in this push:"
    printf '  - %s\n' "${missing_tests[@]}"
  } >&2
  # Exit 2 is Claude Code's PreToolUse "blocking" exit code: it stops the
  # tool call and feeds this message back to Claude. Exit 1 would only show
  # a warning and let the push proceed anyway.
  exit 2
fi

echo "All changed source files have a matching test file. OK to push."
exit 0
