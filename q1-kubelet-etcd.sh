#!/bin/bash
# break-cks.sh - Intentionally breaks kubelet + etcd for CKS practice

echo "=== Breaking configurations for CKS practice ==="

##############################
# 1 & 2. Break kubelet
##############################
KUBELET_CONFIG="/var/lib/kubelet/config.yaml"

if [[ -f "$KUBELET_CONFIG" ]]; then
  # Backup original only once
  if [[ ! -f "${KUBELET_CONFIG}.original" ]]; then
    cp "$KUBELET_CONFIG" "${KUBELET_CONFIG}.original"
  fi

  echo "Breaking kubelet authentication & authorization..."
  sed -i 's/enabled: false/enabled: true/' "$KUBELET_CONFIG"
  sed -i 's/mode: Webhook/mode: AlwaysAllow/' "$KUBELET_CONFIG"
  systemctl restart kubelet
else
  echo "WARNING: $KUBELET_CONFIG not found"
fi

##############################
# 3. Break etcd
##############################
ETCD_MANIFEST="/etc/kubernetes/manifests/etcd.yaml"

if [[ -f "$ETCD_MANIFEST" ]]; then
  # Backup original only once
  if [[ ! -f "${ETCD_MANIFEST}.original" ]]; then
    cp "$ETCD_MANIFEST" "${ETCD_MANIFEST}.original"
  fi

  echo "Breaking etcd client-cert-auth..."
  sed -i 's/--client-cert-auth=true/--client-cert-auth=false/' "$ETCD_MANIFEST"
else
  echo "WARNING: $ETCD_MANIFEST not found"
fi

echo
echo "=== All 3 settings are now in the INSECURE state ==="
echo "You can now practice fixing them."