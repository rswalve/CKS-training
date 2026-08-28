#!/usr/bin/env bash
set -euo pipefail
kubectl create ns monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl -n monitoring apply -f - <<'EOF'
apiVersion: v1
kind: ServiceAccount
metadata: {name: stats-monitor-sa}
automountServiceAccountToken: true
---
apiVersion: apps/v1
kind: Deployment
metadata: {name: stats-monitor}
spec:
  replicas: 1
  selector: {matchLabels: {app: stats-monitor}}
  template:
    metadata: {labels: {app: stats-monitor}}
    spec:
      serviceAccountName: stats-monitor-sa
      containers:
      - name: c
        image: busybox:1.36
        command: ["sleep","365d"]
EOF
mkdir -p "$HOME/stats-monitor"
kubectl -n monitoring get deploy stats-monitor -o yaml > "$HOME/stats-monitor/deployment.yaml"
echo "Edit SA + $HOME/stats-monitor/deployment.yaml then apply."
