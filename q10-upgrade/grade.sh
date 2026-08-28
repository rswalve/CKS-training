#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q10 grade"
mapfile -t vers < <(kubectl get nodes -o jsonpath='{range .items[*]}{.status.nodeInfo.kubeletVersion}{"\n"}{end}')
uniq=$(printf '%s\n' "${vers[@]}" | sort -u | wc -l)
if [[ "$uniq" -eq 1 ]]; then ok "all nodes same kubelet version (${vers[0]})"; else bad "node versions differ: ${vers[*]}"; fi
summary
