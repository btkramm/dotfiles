---
name: open-pr
description: >-
  Create a GitHub pull request with structured English-language description
---

Create a GitHub pull request following these conventions.

## Arguments

This skill accepts an optional free-text argument describing the objective or
context of the pull request. When provided, use it to inform the **Context**,
**Objective**, and **Changelog** sections instead of guessing purely from the
diff and commit history.

Examples of invocation:

- `/open-pr` — no argument, infer everything from commits.
- `/open-pr Creamos el cliente S3 y un test de integración para validar la conexión con MinIO` — use this description to guide the PR body.

## Steps

1. Run `git log main..HEAD` and `git diff main...HEAD` to understand all
   commits since the branch diverged from `main`.
2. Analyze **all** commits in the branch, not just the latest one.
3. Draft the PR title and body following the rules below.
4. Push to remote with `-u` if needed.
5. Create the PR using `gh pr create` with a HEREDOC body.
6. Return the PR URL to the user.

## Title rules

- Keep under 80 characters.
- Write in English.
- Use a plain, descriptive summary of the objective. Do NOT use conventional
  commit prefixes (`feat:`, `fix:`, `refactor:`, etc.) — this is a PR title,
  not a commit message.

## Body structure

The body **must** use these four sections, in this order:

```markdown
### Context

<!-- Why does this change exist? Link relevant threads, issues, or
     conversations. Explain the problem or background that motivated
     the work. Include screenshots or videos if they help illustrate
     the issue. -->

### Objective

<!-- What is this PR trying to achieve? A concise statement of the
     goal. -->

### Changelog

<!-- What changed and how? Describe the implementation approach,
     trade-offs, decisions, and anything reviewers should know.
     Reference specific commits when helpful. -->

### QA

<!-- How was this tested? Include screenshots, videos, terminal
     output, or step-by-step instructions to verify the change. -->
```

## Formatting

- **No column wrapping** in the PR body. Write each paragraph or sentence as a
  single long line. Do NOT wrap text at 80 characters or any other column
  width. GitHub renders markdown with its own line wrapping — manual line
  breaks inside paragraphs create ugly diffs and reflow issues.

## Language

- Write the **entire PR** (title, body, section content) in **English**, even
  if the invocation argument or the surrounding conversation is in Spanish.
- Keep Chilean AFP domain abbreviations as-is (OTI, APV, SIS, RUT, CCICO, ...)
  per the project's language conventions.
- Use backticks for all code references (class names, function names, file
  paths, variables, commands).

## Creating the PR

Use a HEREDOC to pass the body:

```bash
gh pr create --title "Title" --body "$(cat <<'EOF'
### Context

(...)

### Objective

(...)

### Changelog

(...)

### QA

(...)
EOF
)"
```

## Example

### Context

We need a standardized way to interact with S3 (MinIO in local/CI) from the backend, and a clear pattern for writing integration tests that use files stored in S3. Until now we had neither an S3 client configured nor documentation on how to test against the storage.

### Objective

Propose a pattern for writing integration tests that operate against S3 (MinIO). Includes a reusable S3 client, an example test in the `treasury` application, and reference documentation.

### Changelog

- `refactor: rename MinioSettings to S3Settings` — Renames the environment variables from `MINIO_*` to `S3_*` with fields aligned to the `boto3` parameters (`aws_access_key_id`, `aws_secret_access_key`, `endpoint_url`). Updates `compose.yml` and `.env` accordingly.
- `feat: install boto3 and boto3-stubs[s3]` — Adds `boto3` as a production dependency and `boto3-stubs[s3]` as a CI dependency for strict typing of the S3 client.
- `feat: create treasury application scaffold` — Creates the `treasury` application and registers it in `INSTALLED_APPS`. For now it only contains an example test, but it will eventually hold its own logic.
- `feat: create S3 client factory, integration test, and documentation` — Creates `common/s3.py` with `create_s3_client()` returning a typed `S3Client`. Adds an integration test in `apps/treasury/s3_integration_test.py` demonstrating the pattern: a fixture that creates a bucket, runs the test, and cleans up. Documents the pattern in `docs/references/back/s3-integration-testing.md`.

### QA

The integration test can be run with MinIO up:

```bash
docker compose up minio -d

mise back:test back/src/apps/treasury/s3_integration_test.py
```
