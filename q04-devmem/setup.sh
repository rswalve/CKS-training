#!/usr/bin/env bash
# CKS Q4 setup — misbehaving ollama Pod reads /dev/mem
set -euo pipefail

echo "==> CKS Q4 setup: /dev/mem accessor"

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama
  labels:
    app: ollama
    lab: cks-q4
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
  template:
    metadata:
      labels:
        app: ollama
        lab: cks-q4
    spec:
      containers:
      - name: ollama
        image: busybox:1.36
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c"]
        args:
        - |
          echo "ollama worker starting"
          while true; do
            # Touch /dev/mem if present (privileged). Harmless 1-byte read.
            dd if=/dev/mem of=/dev/null bs=1 count=1 2>/dev/null || true
            sleep 5
          done
        securityContext:
          privileged: true
        volumeMounts:
        - name: devmem
          mountPath: /dev/mem
      volumes:
      - name: devmem
        hostPath:
          path: /dev/mem
          type: CharDevice
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama-proxy
  labels:
    app: ollama-proxy
    lab: cks-q4
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama-proxy
  template:
    metadata:
      labels:
        app: ollama-proxy
        lab: cks-q4
    spec:
      containers:
      - name: proxy
        image: busybox:1.36
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "sleep 365d"]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama-web
  labels:
    app: ollama-web
    lab: cks-q4
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama-web
  template:
    metadata:
      labels:
        app: ollama-web
        lab: cks-q4
    spec:
      containers:
      - name: web
        image: busybox:1.36
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "sleep 365d"]
EOF

echo "==> Waiting for Pods..."
kubectl rollout status deploy/ollama --timeout=90s || true
kubectl rollout status deploy/ollama-proxy --timeout=90s || true
kubectl rollout status deploy/ollama-web --timeout=90s || true

echo
echo "Deployments:"
kubectl get deploy ollama ollama-proxy ollama-web
echo
echo "Pods:"
kubectl get po -l lab=cks-q4 -o wide
echo
echo "Setup done."
echo "Bad actor: Deployment/ollama  (privileged + hostPath /dev/mem)"
echo "Leave ollama-proxy and ollama-web at 1 replica."
echo
echo "If you use Falco on this node:"
echo "  vim /etc/falco/falco_rules.local.yaml   # rule on /dev/mem"
echo "  falco -M 30 -r /etc/falco/falco_rules.local.yaml >> /tmp/devmem.log"
echo "  kubectl get po -o json | grep -A2 containerID"
