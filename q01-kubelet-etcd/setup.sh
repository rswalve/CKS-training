#!/usr/bin/env bash
set -euo pipefail

cfg=/var/lib/kubelet/config.yaml
if [[ -f "$cfg" ]]; then
  cp -n "$cfg" "${cfg}.cks.bak" || true
  python3 - "$cfg" <<'PY'
import re, sys
from pathlib import Path
p = Path(sys.argv[1])
src = p.read_text()
src = re.sub(
    r"(anonymous:\n(?:[ \t]+.*\n)*?[ \t]+enabled:\s*)(true|false)",
    r"\1true",
    src,
    count=1,
)
src = re.sub(
    r"(authorization:\n(?:[ \t]+.*\n)*?[ \t]+mode:\s*)\S+",
    r"\1AlwaysAllow",
    src,
    count=1,
)
p.write_text(src)
print("broke", p)
PY
  systemctl restart kubelet 2>/dev/null || true
fi

etcd=/etc/kubernetes/manifests/etcd.yaml
if [[ -f "$etcd" ]]; then
  cp -n "$etcd" "${etcd}.cks.bak" || true
  if grep -q -- '--client-cert-auth=' "$etcd"; then
    sed -i 's/--client-cert-auth=true/--client-cert-auth=false/g' "$etcd"
  else
    sed -i '/- --listen-client-urls/i\    - --client-cert-auth=false' "$etcd"
  fi
  echo "broke $etcd"
fi

echo "Fix: anonymous.enabled=false, authorization.mode=Webhook, etcd --client-cert-auth=true"
