#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q3 grade"
if grep -qE '^USER[[:space:]]+nobody' /cks/docker/Dockerfile; then ok "Dockerfile USER nobody"; else bad "Dockerfile should use USER nobody (not root)"; fi
if grep -q 'privileged: true' /cks/docker/deployment.yaml; then bad "deployment still privileged: true"; else ok "deployment privileged flag fixed"; fi
summary
