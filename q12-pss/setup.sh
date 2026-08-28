#!/usr/bin/env bash
set -euo pipefail
kubectl create ns confidential --dry-run=client -o yaml | kubectl apply -f -
kubectl label ns confidential \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted --overwrite
cat > "$HOME/nginx-unprivileged.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-unprivileged-deployment
  namespace: confidential
spec:
  replicas: 1
  selector: {matchLabels: {app: nginx}}
  template:
    metadata: {labels: {app: nginx}}
    spec:
      containers:
      - name: nginx
        image: nginxinc/nginx-unprivileged:latest
        ports: [{containerPort: 8080}]
EOF
kubectl apply -f "$HOME/nginx-unprivileged.yaml" || true
echo "Deployment is blocked by PSS restricted. Fix $HOME/nginx-unprivileged.yaml"
