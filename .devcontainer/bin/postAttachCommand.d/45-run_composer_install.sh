#!/usr/bin/env bash
# Run composer install if the workspace has a composer.json.

set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_lib.sh
source "$LIB_DIR/_lib.sh"

[ ! -f composer.json ] && exit 0
command -v composer >/dev/null 2>&1 || exit 0

# --no-scripts --no-plugins: don't execute composer install hooks in the devcontainer.
# --no-interaction: never prompt; --no-progress: keep the devcontainer log readable.
log INFO "running composer install"
composer install --no-interaction --no-progress --no-scripts --no-plugins || log WARN "composer install failed"
