#!/usr/bin/env bash
set -euo pipefail
kubectl create ns prod02 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p "$HOME/ca-cert"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/web.key -out /tmp/web.crt -subj "/CN=web.k8sng.local" >/dev/null 2>&1
kubectl -n prod02 create secret tls web-cert --cert=/tmp/web.crt --key=/tmp/web.key --dry-run=client -o yaml | kubectl apply -f -
kubectl -n prod02 apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata: {name: web}
spec:
  selector: {app: web}
  ports: [{port: 80, targetPort: 80}]
---
apiVersion: apps/v1
kind: Deployment
metadata: {name: web}
spec:
  replicas: 1
  selector: {matchLabels: {app: web}}
  template:
    metadata: {labels: {app: web}}
    spec:
      containers:
      - name: nginx
        image: nginx:1.27-alpine
        ports: [{containerPort: 80}]
EOF
echo "Create Ingress named web. Secret web-cert already exists."
