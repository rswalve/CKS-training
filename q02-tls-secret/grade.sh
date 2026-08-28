#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q2 grade"
t=$(kubectl -n clever-cactus get secret clever-cactus -o jsonpath='{.type}' 2>/dev/null || true)
if [[ "$t" == "kubernetes.io/tls" ]]; then ok "TLS secret clever-cactus exists"; else bad "missing kubernetes.io/tls secret clever-cactus"; fi
if kubectl -n clever-cactus get secret clever-cactus -o jsonpath='{.data.tls\.crt}' | grep -q .; then ok "tls.crt present"; else bad "tls.crt missing"; fi
if kubectl -n clever-cactus get secret clever-cactus -o jsonpath='{.data.tls\.key}' | grep -q .; then ok "tls.key present"; else bad "tls.key missing"; fi
summary
