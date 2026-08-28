#!/usr/bin/env bash
set -euo pipefail
kubectl create ns prod --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns data --dry-run=client -o yaml | kubectl apply -f -
kubectl label ns prod env=prod --overwrite
kubectl label ns data env=data --overwrite
for ns in prod data; do
kubectl -n $ns apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata: {name: app}
spec:
  replicas: 1
  selector: {matchLabels: {app: app}}
  template:
    metadata: {labels: {app: app}}
    spec:
      containers:
      - name: c
        image: busybox:1.36
        command: ["sleep","365d"]
EOF
done
echo "Create the two NetworkPolicies only."
