#!/usr/bin/env bash
set -euo pipefail

# postStartCommand for the devcontainer.
# - optionally bootstrap a dotfiles repo if DOTFILES_GIT_URL is provided
# - optionally bring up Tailscale when an auth key is injected
# - clean up any temporary .env file produced by initializeCommand
#
# Helpers print prefixed messages so the container logs are easier to scan.

log() {
  local level=$1; shift
  echo "postStartCommand: [$level] $*" >&2
}

error() {
  log "ERROR" "$@"
}

import_ssh_key() {
  # attempt to fetch a private SSH key from 1Password and add it to ssh-agent.
  # this mirrors the logic from the backup script, keeping the key in-memory
  # and never writing it to disk. failures are non-fatal.
  if ! command -v op >/dev/null 2>&1; then
    return
  fi

  log "INFO" "attempting to import SSH key from 1Password..."
  # start an agent if we don't already have one
  if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null
  fi

  mapfile -t key_lines < <(op read 'op://x3mqvkweewpkgfwmsifle4vdtu/wa7jvp5bg5pcaepo2fbfonqovu/private key?ssh-format=openssh' 2>/dev/null || true)
  if [ "${#key_lines[@]}" -gt 0 ]; then
    printf '%s\n' "${key_lines[@]}" | ssh-add - >/dev/null 2>&1 || \
      log "WARN" "ssh-add failed"
  else
    log "INFO" "no key content available from 1Password"
  fi
}

ensure_docker_context() {
  # When opening the remote shell in the devcontainer, default the docker
  # CLI to the exit-au-oci context so the user doesn't have to pass
  # "--context=exit-au-oci" on every command.  We still keep explicit
  # context flags in the other helper scripts so they continue to work
  # identically outside the container.
  if command -v docker >/dev/null 2>&1; then
    docker context use exit-au-oci >/dev/null 2>&1 || true
  fi
}

bootstrap_dotfiles() {
  # Run `npx` on the supplied repo URL if the variable is set.
  local url="${DOTFILES_GIT_URL:-}"
  [ -z "$url" ] && return

  # prefix with git+ when necessary; npx understands URLs with that scheme.
  case "$url" in
    https://*|ssh://*) url="git+$url" ;;
  esac

  if ! command -v npx >/dev/null 2>&1; then
    log "WARN" "npx not available, skipping bootstrap"
    return
  fi

  if ! npm_config_allow_git=root npx -y "$url"; then
    log "WARN" "npx bootstrap failed for $url"
  fi
}

setup_tailscale() {
  local key="${TAILSCALE_AUTHKEY:-}"
  [ -z "$key" ] && return

  if ! command -v tailscale >/dev/null 2>&1; then
    log "WARN" "tailscale not in PATH, skipping Tailscale setup"
    return
  fi

  log "INFO" "bringing up Tailscale..."
  if ! sudo tailscale up --accept-routes --authkey "$key" --advertise-tags tag:devcontainer; then
    log "WARN" "tailscale up failed"
  fi
}

main() {
  bootstrap_dotfiles
  setup_tailscale
  ensure_docker_context
  import_ssh_key
}

main
