#!/usr/bin/env bash
set -euo pipefail
echo "==> Q16 setup"
if [[ -f /etc/kubernetes/manifests/kube-apiserver.yaml ]]; then
  echo "Edit the static Pod: --anonymous-auth=false --authorization-mode=Node,RBAC --enable-admission-plugins=...,NodeRestriction"
else
  echo "No apiserver manifest on this node — grade will SKIP host flags."
fi
kubectl get clusterrolebinding system:anonymous >/dev/null 2>&1 || \
  kubectl create clusterrolebinding system:anonymous --clusterrole=cluster-admin --user=system:anonymous || true
echo "CRB system:anonymous present for the student to delete."
