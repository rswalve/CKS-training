#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q15 grade"
if grep -q 'defaultAllow: false' /etc/kubernetes/epconfig; then ok "fail closed (defaultAllow false)"; else bad "defaultAllow should be false"; fi
man=/etc/kubernetes/manifests/kube-apiserver.yaml
if [[ -f $man ]]; then
  grep -q ImagePolicyWebhook "$man" && ok "ImagePolicyWebhook on apiserver" || bad "plugin not enabled"
  grep -q 'admission-control-config-file=/etc/kubernetes/epconfig' "$man" && ok "admission-control-config-file" || bad "missing admission-control-config-file flag"
else
  skip "apiserver manifest not here"
fi
summary
