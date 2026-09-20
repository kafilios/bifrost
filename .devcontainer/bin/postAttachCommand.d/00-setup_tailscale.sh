#!/usr/bin/env bash
# Bring up Tailscale if TAILSCALE_AUTHKEY is provided.

set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_lib.sh
source "$LIB_DIR/_lib.sh"

key="${TAILSCALE_AUTHKEY:-}"
[ -z "$key" ] && exit 0

command -v tailscale >/dev/null || { log WARN "tailscale not in PATH"; exit 0; }

log INFO "bringing up Tailscale"
sudo tailscale up --accept-routes --authkey "$key" --advertise-tags tag:devcontainer \
  || log WARN "tailscale up failed"
