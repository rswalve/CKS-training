#!/usr/bin/env bash
set -euo pipefail
kubectl create ns mtls --dry-run=client -o yaml | kubectl apply -f -
kubectl -n mtls apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: {name: shop}
spec:
  replicas: 1
  selector: {matchLabels: {app: shop}}
  template:
    metadata: {labels: {app: shop}}
    spec:
      containers:
      - name: app
        image: busybox:1.36
        command: ["sleep","365d"]
EOF
echo "Label mtls for sidecar injection and create a STRICT PeerAuthentication."
echo "If Istio is not installed, objects can still be created; sidecars will not appear."
