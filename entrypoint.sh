#!/usr/bin/env bash
set -euo pipefail

# simplified entrypoint for the Copilot relay container.  The env vars below
# are mainly defaults; callers may override them when they start the service.
: "${APP_NPX_PACKAGE:=@maximhq/bifrost}"

# start tailscaled in userspace mode if available.  we ignore its output and
# let the background process live for the duration of the container.
if command -v tailscaled >/dev/null 2>&1; then
    tailscaled --state=/var/lib/tailscale/state.db \
              --tun=tailscale0 ${TAILSCALED_ARGS:-} &
fi

# if an auth key is provided, bring the node up and advertise the relay
# hostname so that `tailscale serve` can expose the local HTTP port.
if [ -n "${TAILSCALE_AUTHKEY:-}" ]; then
    hostname="${APP_NAME:-bifrost}"
    tailscale up --authkey "$TAILSCALE_AUTHKEY" \
                 --advertise-tags "tag:$hostname" && \
        tailscale serve --service "svc:$hostname" --https 443 \
            http://127.0.0.1:8080
fi

# finally, exec the Copilot relay via npx.  include the GitHub token argument
# only if the corresponding variable is nonempty; any additional command-line
# args are passed through unchanged.
exec npx -y "$APP_NPX_PACKAGE" 
