#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q6 grade"
p=/etc/kubernetes/logpolicy/sample-policy.yaml
if [[ -f $p ]]; then
  grep -q persistentvolumes "$p" && grep -qi RequestResponse "$p" && ok "PV RequestResponse rule" || bad "missing PV RequestResponse"
  grep -q configmaps "$p" && grep -q front-apps "$p" && ok "front-apps configmaps rule" || bad "missing front-apps configmaps rule"
  grep -q Metadata "$p" && ok "Metadata catch-all present" || bad "missing Metadata rules"
else
  bad "policy file missing"
fi
man=/etc/kubernetes/manifests/kube-apiserver.yaml
if [[ -f $man ]]; then
  grep -q 'audit-policy-file=/etc/kubernetes/logpolicy/sample-policy.yaml' "$man" && ok "apiserver audit-policy-file" || bad "apiserver missing audit-policy-file"
  grep -q 'audit-log-path=/var/log/kubernetes/audit-logs.txt' "$man" && ok "audit-log-path" || bad "missing audit-log-path"
  grep -q 'audit-log-maxage=10' "$man" && ok "maxage=10" || bad "missing maxage=10"
  grep -q 'audit-log-maxbackup=2' "$man" && ok "maxbackup=2" || bad "missing maxbackup=2"
else
  skip "kube-apiserver manifest not on this node"
fi
summary
