#!/usr/bin/env bash
set -euo pipefail
echo "==> Q1 setup: weaken kubelet/etcd if we can write their configs"
KUBELET_CFG=$(ls /var/lib/kubelet/config.yaml 2>/dev/null || true)
if [[ -f "$KUBELET_CFG" ]]; then
  cp -n "$KUBELET_CFG" "${KUBELET_CFG}.cks.bak" || true
  echo "Backed up $KUBELET_CFG"
  echo "Student: set authentication.anonymous.enabled=false and authorization.mode=Webhook"
else
  echo "No /var/lib/kubelet/config.yaml — this playground may not expose kubelet. Grade will SKIP host checks."
fi
ETCD=$(ls /etc/kubernetes/manifests/etcd.yaml 2>/dev/null || true)
if [[ -f "$ETCD" ]]; then
  cp -n "$ETCD" "${ETCD}.cks.bak" || true
  echo "etcd static pod at $ETCD — student must set --client-cert-auth=true"
fi
echo "Done."
