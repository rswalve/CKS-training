#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q16 grade"
man=/etc/kubernetes/manifests/kube-apiserver.yaml
if [[ -f $man ]]; then
  grep -q 'anonymous-auth=false' "$man" && ok "anonymous-auth=false" || bad "anonymous-auth not false"
  grep -q 'authorization-mode=Node,RBAC' "$man" && ok "authorization-mode Node,RBAC" || bad "authorization-mode not Node,RBAC"
  grep -q NodeRestriction "$man" && ok "NodeRestriction admission" || bad "NodeRestriction missing"
else
  skip "apiserver manifest not on this node"
fi
if kubectl get clusterrolebinding system:anonymous >/dev/null 2>&1; then
  bad "ClusterRoleBinding system:anonymous still exists"
else
  ok "system:anonymous CRB deleted"
fi
summary
