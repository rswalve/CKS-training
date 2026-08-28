#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q8 grade"
if kubectl -n prod02 get ing web >/dev/null 2>&1; then ok "Ingress web exists"; else bad "Ingress web missing"; fi
y=$(kubectl -n prod02 get ing web -o yaml 2>/dev/null || true)
echo "$y" | grep -q 'web.k8sng.local' && ok "host web.k8sng.local" || bad "wrong/missing host"
echo "$y" | grep -q 'secretName: web-cert' && ok "tls secret web-cert" || bad "tls secret not web-cert"
echo "$y" | grep -q 'name: web' && ok "backend service web referenced" || bad "backend service missing"
summary
