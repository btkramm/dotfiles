---
name: open-pr
description: Create a GitHub pull request with structured Spanish-language description
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

1. Run `git log main..HEAD` and `git diff main...HEAD` to understand all commits
   since the branch diverged from `main`.
2. Analyze **all** commits in the branch, not just the latest one.
3. Draft the PR title and body following the rules below.
4. Push to remote with `-u` if needed.
5. Create the PR using `gh pr create` with a HEREDOC body.
6. Return the PR URL to the user.

## Title rules

- Keep under 80 characters.
- Write in Spanish.
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
  single long line. Do NOT wrap text at 80 characters or any other column width.
  GitHub renders markdown with its own line wrapping — manual line breaks inside
  paragraphs create ugly diffs and reflow issues.

## Language

- Write the **entire PR** (title, body, section content) in **Spanish**.
- Use backticks for all code references (class names, function names, file
  paths, variables, commands).

## Creating the PR

Use a HEREDOC to pass the body:

```bash
gh pr create --title "Título" --body "$(cat <<'EOF'
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

Necesitamos una forma estandarizada de interactuar con S3 (MinIO en local/CI) desde el backend, y un patrón claro para escribir tests de integración que usan archivos almacenados en S3. Hasta ahora no teníamos ni un cliente S3 configurado ni documentación sobre cómo testear contra el storage.

### Objective

Proponer un patrón para crear tests de integración que operan contra S3 (MinIO). Se incluye un cliente S3 reutilizable, un test de ejemplo en la app `treasury`, y documentación de referencia.

### Changelog

- `refactor: rename MinioSettings to S3Settings` — Se renombran las variables de entorno de `MINIO_*` a `S3_*` con campos alineados a los parámetros de `boto3` (`aws_access_key_id`, `aws_secret_access_key`, `endpoint_url`). Se actualiza `compose.yml` y `.env` acorde.
- `feat: install boto3 and boto3-stubs[s3]` — Se agrega `boto3` como dependencia de producción y `boto3-stubs[s3]` como dependencia de CI para tener tipos estrictos del cliente S3.
- `feat: create treasury application scaffold` — Se crea la app `treasury` y se registra en `INSTALLED_APPS`. Por ahora solo contiene un test de ejemplo, pero eventualmente albergará lógica propia.
- `feat: create S3 client factory, integration test, and documentation` — Se crea `common/s3.py` con `create_s3_client()` que retorna un `S3Client` tipado. Se agrega un test de integración en `apps/treasury/s3_integration_test.py` que demuestra el patrón: fixture que crea un bucket, ejecuta el test, y limpia. Se documenta el patrón en `docs/references/back/s3-integration-testing.md`.

### QA

El test de integración se puede ejecutar con MinIO corriendo:

```bash
docker compose up minio -d

mise back:test back/src/apps/treasury/s3_integration_test.py
```
