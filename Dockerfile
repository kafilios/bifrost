FROM ubuntu:latest

# Install prerequisites for Node.js and tailscale
# set timezone to Melbourne to avoid tzdata interactive prompt
ENV TZ=Australia/Melbourne
ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
    apt-get update; \
    # configure timezone before installing tzdata
    echo "Australia/Melbourne" > /etc/timezone; \
    ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime; \
    apt-get install -y --no-install-recommends curl ca-certificates tzdata python3 python3-yaml; \
    # install Node.js LTS
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    npm cache clean --force || true; \
    # install tailscale using upstream script
    curl -fsSL https://tailscale.com/install.sh | sh; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY config/config.yaml /root/.config/bifrost/config.yaml
RUN set -eux; \
    python3 - <<'PY'; \
import pathlib, yaml, json; \
path = pathlib.Path('/root/.config/bifrost/config.yaml'); \
data = yaml.safe_load(path.read_text()); \
rules = data.get('governance', {}).get('routing_rules'); \
if rules is not None: \
    for idx, rule in enumerate(rules): \
        rule['priority'] = idx; \
path = pathlib.Path('/root/.config/bifrost/config.json'); \
path.write_text(json.dumps(data, indent=2)); \
PY

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
