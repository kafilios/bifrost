FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# bubblewrap setuid required for namespace sandboxes on restricted hosts.
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl bubblewrap libcap2-bin \
  && bwrap="$(command -v bwrap)" \
  && chown root:root "$bwrap" && chmod 4755 "$bwrap" \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/linuxbrew/.linuxbrew && chown -R vscode:vscode /home/linuxbrew
ENV NONINTERACTIVE=1
USER vscode
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && /home/linuxbrew/.linuxbrew/bin/brew --version \
  && echo >> /home/vscode/.bashrc \
  && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/vscode/.bashrc \
  && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)" \
  && /home/linuxbrew/.linuxbrew/bin/brew install docker docker-compose docker-buildx node wget curl jq gnupg git-secret socat yq gh 1password-cli claude-code php composer pandoc \
  && docker context create exit-au-oci --docker "host=ssh://docker@exit-au-oci" \
  && mkdir -p /home/vscode/.docker/cli-plugins \
  && ln -sf /home/linuxbrew/.linuxbrew/bin/docker-compose /home/vscode/.docker/cli-plugins/docker-compose \
  && ln -sf /home/linuxbrew/.linuxbrew/bin/docker-buildx /home/vscode/.docker/cli-plugins/docker-buildx
USER root

# dbxcli has no Homebrew formula — install the pinned release binary from
# GitHub so bin/deploy works inside the container. Matches the pin used by
# bin/refresh-dbxcli-token (v3.7.3).
#
# Integrity is pinned per-architecture with SHA256 checksums fetched from
# the same Dropbox release. The expected digests are embedded below; the
# `dbxcli version` call is kept only as a sanity check, not the integrity gate.
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "$arch" in \
    amd64) url="https://github.com/dropbox/dbxcli/releases/download/v3.7.3/dbxcli_3.7.3_linux_amd64.tar.gz"; \
           expected="fee977ce4144174356cd7d1bae0b546aecad2570f14666bd44417e96af943484" ;; \
    arm64) url="https://github.com/dropbox/dbxcli/releases/download/v3.7.3/dbxcli_3.7.3_linux_arm64.tar.gz"; \
           expected="9d654da62a1ac10c9e32ee8f66fa6cc8d88ed29bc95555435a5ce4255eb4b96a" ;; \
    *) echo "Unsupported architecture for dbxcli: $arch" >&2; exit 1 ;; \
  esac; \
  curl -fsSL -o /tmp/dbxcli.tar.gz "$url"; \
  actual="$(sha256sum /tmp/dbxcli.tar.gz | awk '{print $1}')"; \
  [ "$actual" = "$expected" ] || { echo "dbxcli checksum mismatch: got $actual, want $expected" >&2; exit 1; }; \
  tar -xz -C /tmp --strip-components=1 \
    -f /tmp/dbxcli.tar.gz "dbxcli_3.7.3_linux_${arch}/dbxcli"; \
  install -m 0755 /tmp/dbxcli /usr/local/bin/dbxcli; \
  rm -f /tmp/dbxcli /tmp/dbxcli.tar.gz; \
  /usr/local/bin/dbxcli version

RUN set -eux; \
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"; \
  npm install -g @anthropic-ai/sandbox-runtime; \
  npm cache clean --force; \
  mkdir -p /usr/local/share/sandbox-runtime/seccomp; \
  src="$(npm root -g)/@anthropic-ai/sandbox-runtime/vendor/seccomp"; \
  test -d "$src"; \
  cp -a "$src/." /usr/local/share/sandbox-runtime/seccomp/; \
  chmod -R a+rX /usr/local/share/sandbox-runtime/seccomp;

ENV EDITOR="code --wait"
ENV BROWSER=code
ENV GNUPGHOME=/home/vscode/.gnupg-container

# Pin a fixed local SSH socket so the container never inherits a host-forwarded
# agent (VS Code / DevPod). Bound by .devcontainer/bin/postAttachCommand.d/20-import_ssh_key.sh.
ENV SSH_AUTH_SOCK=/tmp/ssh-agent.sock

COPY etc/gitconfig /etc/gitconfig
RUN mkdir -p /home/vscode/.ssh && chown vscode:vscode /home/vscode/.ssh && chmod 700 /home/vscode/.ssh
COPY --chmod=644 --chown=vscode:vscode config/.ssh/known_hosts /home/vscode/.ssh/known_hosts
COPY --chmod=755 bin/postAttachCommand.sh /usr/local/bin/postAttachCommand.sh
COPY --chmod=755 bin/postAttachCommand.d/ /usr/local/bin/postAttachCommand.d/
