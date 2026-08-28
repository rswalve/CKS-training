#!/usr/bin/env bash
set -euo pipefail
kubectl create ns alpine --dry-run=client -o yaml | kubectl apply -f -
cat > "$HOME/alpine-deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: alpine
  namespace: alpine
spec:
  replicas: 1
  selector: {matchLabels: {app: alpine}}
  template:
    metadata: {labels: {app: alpine}}
    spec:
      containers:
      - name: alpine-a
        image: alpine:3.20
        command: ["sleep","365d"]
      - name: alpine-b
        image: alpine:3.18
        command: ["sleep","365d"]
      - name: alpine-c
        image: alpine:3.19
        command: ["sleep","365d"]
EOF
kubectl apply -f "$HOME/alpine-deployment.yaml"
echo "Lab shortcut: treat alpine-b (alpine:3.18) as the flagged image."
echo "If bom exists: bom generate --image alpine:3.18 > ~/alpine.spdx"
