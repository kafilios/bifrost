#!/usr/bin/env bash
# Import the SSH key from 1Password into a local ssh-agent pinned to a fixed
# socket path. VS Code / DevPod may forward a host ssh-agent via
# SSH_AUTH_SOCK; we discard it so the new agent binds where the container
# expects (/tmp/ssh-agent.sock, asserted by Dockerfile ENV + containerEnv).

set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_lib.sh
source "$LIB_DIR/_lib.sh"

OP_SSH_KEY_REF='op://x3mqvkweewpkgfwmsifle4vdtu/wa7jvp5bg5pcaepo2fbfonqovu/private key?ssh-format=openssh'
LOCAL_AUTH_SOCK=/tmp/ssh-agent.sock
AGENT_ENV_FILE=/tmp/ssh-agent.env

command -v ssh-agent >/dev/null 2>&1 || exit 0
command -v op >/dev/null 2>&1 || exit 0

unset SSH_AUTH_SOCK SSH_AGENT_PID
rm -f "$LOCAL_AUTH_SOCK"
mkdir -p "$(dirname "$LOCAL_AUTH_SOCK")"

log INFO "starting local ssh-agent on ${LOCAL_AUTH_SOCK}"
eval "$(ssh-agent -a "$LOCAL_AUTH_SOCK" -s)" >/dev/null

# postAttachCommand.d scripts run in their own subshells, so persist the env
# for any later shell that needs it (SSH_AGENT_PID is required for
# `ssh-agent -k`).
cat > "$AGENT_ENV_FILE" <<EOF
export SSH_AUTH_SOCK=${SSH_AUTH_SOCK}
export SSH_AGENT_PID=${SSH_AGENT_PID}
EOF
chmod 600 "$AGENT_ENV_FILE"

# Stream the key from op straight into ssh-add so it never lands on disk.
log INFO "importing SSH key from 1Password..."
if op read "$OP_SSH_KEY_REF" 2>/dev/null | ssh-add - >/dev/null 2>&1; then
  log INFO "SSH key imported"
else
  log WARN "ssh-add failed"
fi
