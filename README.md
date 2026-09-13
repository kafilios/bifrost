[![Open in DevPod!](https://devpod.sh/assets/open-in-devpod.svg)](https://devpod.sh/open#https://github.com/kafilios/bifrost)

# Bifrost

This repository builds and runs a small container that proxies requests to the
Copilot API and optionally advertises itself over Tailscale.

## Starting the service

You **must** use the provided wrapper script to start the relay; it is
responsible for injecting secrets, building the image, and cleaning up the
temporary environment file.

```sh
./up
```

The script will read `.env.template` (which is ignored by git) and generate a
short-lived `.env` file. When the container comes up the file is removed, so
secrets never persist on disk.

## Stopping the service

To tear everything down and remove any leftover state run:

```sh
./down
```

This is only intended as a convenience; the only requirement is that you never
call `docker compose up` directly—always go through `ops/up` so that the
`.env` file is handled correctly.

## Compose configuration

All of the container configuration lives in `docker-compose.yml`.  The
service does **not** expose any host ports; it relies on the internal port
`3000` and Tailscale for network access.  A small helper proxy now listens on
`3001` inside the container and rewrites websocket debugger urls in JSON
responses; the tail‑scale service endpoint is pointed at 3001 so that external
clients always hit the proxy.  The advertised relay name is fixed to
`bifrost` via `APP_NAME` in that file.
Host‑level overrides (package version, etc.) can be accomplished by editing
the compose file if needed.

Secrets (`GITHUB_TOKEN` and `TAILSCALE_AUTHKEY`) are kept in
`.env.template` and injected by the up script.

For repository‑specific guidance used by Claude Code, see `CLAUDE.md`.
