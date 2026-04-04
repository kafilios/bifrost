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
    apt-get install -y --no-install-recommends curl ca-certificates tzdata; \
    # install Node.js LTS
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    npm cache clean --force || true; \
    # install tailscale using upstream script
    curl -fsSL https://tailscale.com/install.sh | sh; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
