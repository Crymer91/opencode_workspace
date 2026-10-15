---
name: code-review-checklist
description: Use when reviewing a diff, auditing a pull request, checking code quality before merge, or when the user asks for a code review or a pre-merge sanity check.
---

# Code Review Checklist

Walk the diff and check each category. Report findings grouped by severity
(`blocker`, `major`, `minor`, `nit`) with `file:line` references.

## Correctness

- Does the change do what it claims?
- Are edge cases (empty, null, zero, single item, max size) handled?
- Are error paths handled, or are exceptions silently swallowed?
- Any off-by-one errors in loops or slicing?

## Security

- Untrusted input validated before use?
- No secrets, tokens, or credentials in code or logs?
- Parameterized queries / no string-built SQL or shell?
- Authorization checked on every new entry point?

## Tests

- Is new behavior covered by tests?
- Do tests assert behavior, not implementation details?
- Are failure cases tested, not just the happy path?

## Performance

- Any accidental O(n^2), N+1 queries, or repeated work in a loop?
- Large allocations or unbounded growth?

## Readability

- Names describe intent, not type?
- Dead code, commented-out blocks, or debug prints left behind?
- Does it follow the surrounding conventions?

## Output

1. One-line verdict (`approve`, `approve with comments`, `request changes`).
2. Findings list, most severe first.
3. Only nitpick when there is nothing more important to say.
