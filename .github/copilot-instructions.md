This repository builds a single container that proxies requests to the GitHub
Copilot API. There is no application code other than shell scripts and a
Dockerfile.

When Copilot suggests edits:

- Pay attention to the small number of files: `Dockerfile`, `entrypoint.sh`,
  `docker-compose.yml`, and the helpers under `service/` are the only ones that
  matter.
- Do not introduce language-specific boilerplate; keep changes minimal and
  focused on the new behaviour.
- Avoid suggesting removal of the `service/up` script; the repo relies on it for
  secret injection.
- If suggesting environment variable names or defaults, follow the existing
  convention (`APP_NAME`, etc.  port is now hardcoded to 3000).

General style:

- Keep shell script suggestions POSIX‑compatible and avoid unnecessary external
  dependencies.
- When recommending git operations, stay non-destructive and respect the
  repository’s existing commit conventions.
- There are no tests; don't suggest adding test scaffolding unless the user
  explicitly asks for it.

This file is consulted by Copilot when providing inline completions and
suggestions; it should stay brief and focused on repository-specific guidance.