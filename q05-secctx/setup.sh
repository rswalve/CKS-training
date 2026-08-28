#!/usr/bin/env bash
# CKS Q5 setup — Security Context on Deployment secdep
set -euo pipefail

echo "==> CKS Q5 setup: container securityContext"

kubectl create namespace sec-ns --dry-run=client -o yaml | kubectl apply -f -

# Broken baseline: two containers, no hardening
mkdir -p "${HOME}"
cat > "${HOME}/sec-ns_deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secdep
  namespace: sec-ns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secdep
  template:
    metadata:
      labels:
        app: secdep
    spec:
      containers:
      - name: sec-ctx-demo-1
        image: busybox:1.28
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "sleep 12h"]
        volumeMounts:
        - name: sec-ctx-vol-1
          mountPath: /data/demo1
      - name: sec-ctx-demo-2
        image: busybox
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "sleep 12h"]
        volumeMounts:
        - name: sec-ctx-vol-2
          mountPath: /data/demo2
      volumes:
      - name: sec-ctx-vol-1
        emptyDir: {}
      - name: sec-ctx-vol-2
        emptyDir: {}
EOF

kubectl apply -f "${HOME}/sec-ns_deployment.yaml"
kubectl -n sec-ns rollout status deploy/secdep --timeout=90s || true

echo
echo "Wrote ${HOME}/sec-ns_deployment.yaml"
echo "Edit THAT file, then: kubectl apply -f ~/sec-ns_deployment.yaml"
echo
kubectl -n sec-ns get deploy,po
