#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q11 grade"
names=$(kubectl -n alpine get deploy alpine -o jsonpath='{.spec.template.spec.containers[*].name}')
echo "$names" | grep -q alpine-a && echo "$names" | grep -q alpine-c && ok "kept alpine-a and alpine-c" || bad "do not remove the other containers"
echo "$names" | grep -q alpine-b && bad "alpine-b should be removed" || ok "alpine-b removed"
if [[ -s "$HOME/alpine.spdx" ]]; then ok "~/alpine.spdx exists"; else bad "~/alpine.spdx missing (create with bom or a placeholder SPDX doc)"; fi
summary
