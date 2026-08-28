#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q12 grade"
ready=$(kubectl -n confidential get deploy nginx-unprivileged-deployment -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo 0)
[[ "$ready" == "1" ]] && ok "pod is running under restricted PSS" || bad "deployment not ready (PSS still blocking?)"
y=$(kubectl -n confidential get deploy nginx-unprivileged-deployment -o yaml)
echo "$y" | grep -q 'runAsNonRoot: true' && ok "runAsNonRoot" || bad "need runAsNonRoot"
echo "$y" | grep -q 'allowPrivilegeEscalation: false' && ok "no priv-esc" || bad "need allowPrivilegeEscalation: false"
echo "$y" | grep -q 'RuntimeDefault' && ok "seccomp RuntimeDefault" || bad "need seccompProfile RuntimeDefault"
summary
