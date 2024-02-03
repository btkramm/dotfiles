---
name: commit
description: Create a git commit following the user's commit message style
---

Create a git commit following these style rules.

## Steps

1. Run `git diff --staged` to see what is being committed. If nothing is
   staged, stop and tell the user — do not stage files on their behalf.
2. Run `git log --oneline -5` to see recent commit style for context.
3. Draft a commit message following the rules below.
4. Commit using a HEREDOC for proper formatting.
5. Run `git status` to verify.

## Subject line rules

- Use conventional commits: `type: description`
- Use **precise verbs** — not generic "add":
  - `create` for new files, modules, applications, or features
  - `install` for adding dependencies
  - `rename` for renames
  - `update` for modifications to existing things
  - `remove` / `delete` for deletions
  - `fix` for bug fixes
- Wrap **all code references** in backticks — class names, function names,
  package names, file paths, env var names. This applies in the subject line
  too, e.g.: ``feat: create `treasury` application scaffold``
- **No abbreviations**: use "application" not "app", "documentation" not "docs",
  "dependencies" not "deps", "configuration" not "config"
- Keep under 72 characters

## Body rules

- Include a body only when the "why" is not obvious from the subject alone.
  Simple scaffolds or dependency installs do not need a body.
- Wrap **all code references** in backticks: `` `S3Settings` ``,
  `` `common/s3.py` ``, `` `MINIO_*` ``
- **No abbreviations**: "Environment variables" not "Env vars", "parameters"
  not "params", "application" not "app"
- Wrap at 80 characters
- Separate from subject with a blank line

## Trailer

NEVER end with:

```
Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

## Examples

Simple (no body needed):

```
feat: create `treasury` application scaffold
```

```
feat: install `boto3` and `boto3-stubs[s3]` dependencies
```

With body (why is non-obvious):

```
refactor: rename `MinioSettings` to `S3Settings` with `boto3`-aligned fields

Make the S3 configuration agnostic to the storage backend. Environment
variables change from `MINIO_*` to `S3_*` with field names matching
`boto3` parameters (`aws_access_key_id`, `aws_secret_access_key`,
`endpoint_url`).
```

```
feat: create S3 client factory, integration test, and documentation

Create `create_s3_client()` in `common/s3.py`, a proof-of-concept
integration test in the treasury application, and reference
documentation on S3 integration testing.
```
