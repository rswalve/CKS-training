#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q14 grade"
lab=$(kubectl get ns mtls -o jsonpath='{.metadata.labels.istio-injection}')
[[ "$lab" == "enabled" ]] && ok "ns mtls istio-injection=enabled" || bad "label istio-injection=enabled missing"
if kubectl -n mtls get peerauthentication >/dev/null 2>&1; then
  y=$(kubectl -n mtls get peerauthentication -o yaml)
  echo "$y" | grep -q STRICT && ok "PeerAuthentication STRICT" || bad "PeerAuthentication not STRICT"
else
  bad "no PeerAuthentication in mtls"
fi
summary
