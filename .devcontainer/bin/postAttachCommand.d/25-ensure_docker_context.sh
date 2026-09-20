#!/usr/bin/env bash
# Default the docker CLI to the exit-au-oci context for this shell.

set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_lib.sh
source "$LIB_DIR/_lib.sh"

command -v docker >/dev/null 2>&1 || exit 0

docker context use exit-au-oci >/dev/null 2>&1 || \
  log WARN "docker context use failed"
