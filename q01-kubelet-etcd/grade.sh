#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q1 grade"
cfg=/var/lib/kubelet/config.yaml
if [[ -f $cfg ]]; then
  if grep -qE 'enabled:\s*false' "$cfg" && grep -A2 'anonymous' "$cfg" | grep -q false; then
    ok "kubelet anonymous-auth disabled (config.yaml)"
  elif grep -q 'anonymous-auth=false' /etc/systemd/system/kubelet.service.d/* 2>/dev/null || grep -q 'anonymous-auth=false' /var/lib/kubelet/kubeadm-flags.env 2>/dev/null; then
    ok "kubelet anonymous-auth=false in flags"
  else
    bad "kubelet anonymous-auth is not clearly false"
  fi
  if grep -qi 'AlwaysAllow' "$cfg" /var/lib/kubelet/kubeadm-flags.env 2>/dev/null; then
    bad "kubelet authorization-mode still AlwaysAllow"
  else
    ok "kubelet authorization-mode is not AlwaysAllow"
  fi
else
  skip "kubelet config not on this node"
fi
if [[ -f /etc/kubernetes/manifests/etcd.yaml ]]; then
  if grep -q 'client-cert-auth=true' /etc/kubernetes/manifests/etcd.yaml; then
    ok "etcd --client-cert-auth=true"
  else
    bad "etcd missing --client-cert-auth=true"
  fi
else
  skip "etcd manifest not on this node"
fi
summary
