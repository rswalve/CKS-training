#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q7 grade"
if kubectl -n prod get netpol deny-policy >/dev/null 2>&1; then ok "deny-policy exists"; else bad "deny-policy missing"; fi
ing=$(kubectl -n prod get netpol deny-policy -o jsonpath='{.spec.policyTypes}' 2>/dev/null || true)
echo "$ing" | grep -q Ingress && ok "deny-policy is Ingress" || bad "deny-policy should type Ingress"
from=$(kubectl -n prod get netpol deny-policy -o jsonpath='{.spec.ingress}' 2>/dev/null || true)
if [[ -z "$from" ]]; then ok "deny-policy ingress empty (deny-all)"; else bad "deny-policy ingress should be empty/absent"; fi
if kubectl -n data get netpol allow-from-prod >/dev/null 2>&1; then ok "allow-from-prod exists"; else bad "allow-from-prod missing"; fi
sel=$(kubectl -n data get netpol allow-from-prod -o yaml 2>/dev/null || true)
echo "$sel" | grep -q 'env: prod' && ok "allow-from-prod selects ns env=prod" || bad "allow-from-prod must use namespaceSelector env=prod"
summary
