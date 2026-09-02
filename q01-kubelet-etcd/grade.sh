#!/usr/bin/env bash
# Q1 grade: kubelet anonymous + authorization.mode, etcd client-cert-auth
set -uo pipefail

PASS=0
FAIL=0
SKIP=0

ok()   { echo "PASS  $*"; PASS=$((PASS+1)); }
bad()  { echo "FAIL  $*"; FAIL=$((FAIL+1)); }
skip() { echo "SKIP  $*"; SKIP=$((SKIP+1)); }
summary() {
  local total=$((PASS+FAIL))
  echo "SCORE  ${PASS} / ${total}"
  if [[ $FAIL -eq 0 && $total -gt 0 ]]; then
    echo "RESULT PASS"
    return 0
  fi
  echo "RESULT FAIL"
  return 1
}

echo "==> Q1 grade"

cfg=/var/lib/kubelet/config.yaml
if [[ -f $cfg ]]; then
  if python3 - "$cfg" <<'PY'
import sys, re
t = open(sys.argv[1]).read()
m = re.search(r"anonymous:\s*\n(?:[ \t]+.*\n)*?[ \t]+enabled:\s*(true|false)", t)
sys.exit(0 if m and m.group(1) == "false" else 1)
PY
  then
    ok "kubelet anonymous.enabled=false"
  elif grep -qE -- 'anonymous-auth=false' /etc/systemd/system/kubelet.service.d/* /var/lib/kubelet/kubeadm-flags.env 2>/dev/null; then
    ok "kubelet anonymous-auth=false in flags"
  else
    bad "kubelet anonymous-auth is not clearly false"
  fi

  if python3 - "$cfg" <<'PY'
import sys, re
t = open(sys.argv[1]).read()
m = re.search(r"authorization:\s*\n(?:[ \t]+.*\n)*?[ \t]+mode:\s*(\S+)", t)
mode = (m.group(1).strip().strip("\"'") if m else "")
sys.exit(0 if mode.lower() == "webhook" else 1)
PY
  then
    ok "kubelet authorization.mode=Webhook"
  elif grep -qE -- 'authorization-mode=Webhook' /etc/systemd/system/kubelet.service.d/* /var/lib/kubelet/kubeadm-flags.env 2>/dev/null; then
    ok "kubelet authorization-mode=Webhook in flags"
  else
    bad "kubelet authorization.mode is not Webhook"
  fi
else
  skip "kubelet config not on this node"
fi

etcd=/etc/kubernetes/manifests/etcd.yaml
if [[ -f $etcd ]]; then
  if grep -qE -- '--client-cert-auth[= ]true' "$etcd"; then
    ok "etcd --client-cert-auth=true"
  else
    bad "etcd missing --client-cert-auth=true"
  fi
else
  skip "etcd manifest not on this node"
fi

summary