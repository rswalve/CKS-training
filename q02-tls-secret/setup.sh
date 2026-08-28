#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/ca-cert"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$HOME/ca-cert/web.k8s.local.key" \
  -out "$HOME/ca-cert/web.k8s.local.crt" \
  -subj "/CN=web.k8s.local" >/dev/null 2>&1
kubectl create ns clever-cactus --dry-run=client -o yaml | kubectl apply -f -
kubectl -n clever-cactus apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: clever-cactus
spec:
  replicas: 1
  selector:
    matchLabels: {app: clever-cactus}
  template:
    metadata:
      labels: {app: clever-cactus}
    spec:
      containers:
      - name: web
        image: nginx:1.27-alpine
        volumeMounts:
        - name: tls
          mountPath: /etc/nginx/certs
          readOnly: true
      volumes:
      - name: tls
        secret:
          secretName: clever-cactus
          optional: true
EOF
echo "Certs in $HOME/ca-cert — create the TLS secret, do not edit the Deployment."
