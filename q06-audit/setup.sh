#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /etc/kubernetes/logpolicy /var/log/kubernetes
sudo tee /etc/kubernetes/logpolicy/sample-policy.yaml >/dev/null <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages: ["RequestReceived"]
rules:
- level: None
  users: ["system:kube-proxy"]
  verbs: ["watch"]
  resources:
  - group: ""
    resources: ["endpoints", "services", "services/status"]
EOF
echo "Policy stub written. Edit it and add apiserver flags:"
echo "  --audit-policy-file=/etc/kubernetes/logpolicy/sample-policy.yaml"
echo "  --audit-log-path=/var/log/kubernetes/audit-logs.txt"
echo "  --audit-log-maxage=10"
echo "  --audit-log-maxbackup=2"
echo "Then wait for kube-apiserver static Pod to recycle."
