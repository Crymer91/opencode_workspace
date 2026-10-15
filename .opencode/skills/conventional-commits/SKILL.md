---
name: conventional-commits
description: Use when writing, reviewing, or fixing a git commit message, or when the user mentions Conventional Commits, commitlint, semantic versioning, or prefixes like feat, fix, chore, docs, refactor.
---

# Conventional Commits

Format every commit message as:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer(s)]
```

## Rules

- Put a blank line between the subject, body, and footers.
- Keep the subject in the imperative mood, lowercase, no trailing period, <= 72 chars.
- Use a scope when it clarifies the area of the change (`auth`, `api`, `deps`).
- Mark a breaking change with `!` after the type/scope AND a `BREAKING CHANGE:`
  footer.

## Types

- `feat`: a new feature (MINOR)
- `fix`: a bug fix (PATCH)
- `docs`: documentation only
- `style`: formatting, no code-behavior change
- `refactor`: code change that neither fixes a bug nor adds a feature
- `perf`: performance improvement
- `test`: adding or fixing tests
- `build`: build system or dependency changes
- `ci`: CI configuration changes
- `chore`: other changes that do not modify src or test
- `revert`: revert a previous commit

## Examples

```
feat(auth): add OAuth2 login flow

fix(api): handle null response from upstream

refactor!: drop Node 16 support

BREAKING CHANGE: minimum supported Node version is now 18.
```

## Emit

Return the commit message in a fenced code block so it can be copied verbatim.
Do not add commentary unless the user asks for it.
