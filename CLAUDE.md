# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## High‑level overview

This repository is not a typical multi‑language application; it exists to build and
run a single container that proxies requests to the GitHub Copilot API.  There is
no application code written in a higher‑level language – the runtime behaviour is
entirely encapsulated in a Dockerfile and a small `entrypoint.sh` shell script.

The container:

* installs Node.js and tailscale in an Ubuntu base image
* includes a small Node-based intercepting proxy listening on 3001 for
  rewriting websocket URLs in JSON responses
* defines an entrypoint that:
  * starts `tailscaled` in userspace mode (if present)
  * optionally brings up a tailscale node using `TAILSCALE_AUTHKEY` and advertises
    the relay name (`APP_NAME`) via `tailscale serve`
  * invokes `npx <COPILOT_API_PACKAGE> start ...` to run the actual relay service

Runtime configuration is driven by environment variables; the compose file
defines and documents the defaults.  Secrets (`GITHUB_TOKEN` and
`TAILSCALE_AUTHKEY`) are kept out of version control in `.env.template` and
injected by the helper script described below.

A `docker-compose.yml` orchestrates the build and run process.  A persistent
volume `tailscale-state` is created for tailscale state.

There is also a `.devcontainer` directory containing a development container
setup used by the original author, but it is not required for the relay itself.

## Common commands

This repository has no tests, linting, or language-specific build steps.  The
primary operations a developer will perform are:

```sh
# generate a temporary env file and bring the service up (builds the image too)
./up

# tear the service down
./down
```

Do **not** run `docker compose up` by hand; the wrapper script handles secret
injection and cleanup.  The wrapper hardcodes the `exit-au-oci` Docker context
used in the original devcontainer, so set `DOCKER_CONTEXT` if you need a
different target.

The only other useful command is building the image explicitly:

```sh
docker --context exit-au-oci compose build
```

or, if you prefer, `docker build` directly from the `Dockerfile`.  The
`Dockerfile` is very simple and can be inspected when diagnosing build issues.

## Sandbox note

`git` (and other bwrap-based tools) fail in this devcontainer with
`bwrap: capset failed: Operation not permitted`. Prefix git commands
with `dangerouslyDisableSandbox: true` on the Bash tool call.

No `make`, `npm`, or test commands exist – just edit the shell scripts or
compose file as needed.

## Code structure

```
/Dockerfile            # image build instructions
/entrypoint.sh         # runtime script run inside the container
/docker-compose.yml    # describes the service used by helpers
/config/config.yaml    # Bifrost governance config: routing rules, providers,
                       # complexity analyzer (semantic + LLM tier classifier)
/.env.template         # secret placeholders injected by ./up
/up            # wrapper that runs op inject + compose up
/down          # wrapper that composes down
/README.md             # user-facing documentation
```

The `.github/copilot-instructions.md` file exists but currently contains no
additional guidance.  `.gitignore` ignores `.env` so secrets never land in
version control.

When editing the entrypoint or compose file, keep in mind that the container
will be rebuilt on each `./up`, so changes need to be committed before
testing.

## Notes for future Claude instances

* Focus on the shell scripts and compose file when you need to change behavior;
  there is no other application logic to review.
* Never commit real credentials – `.env.template` is the canonical way to store
  example values.
* The project is small; most work will involve tweaking environment variables,
  adjusting the `entrypoint.sh` logic, or modifying the Dockerfile/compose
  configuration.  There are no tests to run or frameworks to learn.
* The development container exists but can generally be ignored unless working
  on the devcontainer itself.

This guidance is intended to get you up to speed quickly; you don't need to
re‑read the entire repo to answer simple maintenance or refactoring questions.