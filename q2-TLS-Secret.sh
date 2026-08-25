#!/bin/bash
# break-q2.sh - Sets up the clever-cactus scenario for CKS practice

echo "=== Setting up Question 2: clever-cactus ==="

# Create certificate directory
mkdir -p /home/candidate/ca-cert

# Generate self-signed certificate and key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /home/candidate/ca-cert/web.k8s.local.key \
  -out /home/candidate/ca-cert/web.k8s.local.crt \
  -subj "/CN=web.k8s.local/O=cks-practice" 2>/dev/null

# Fix ownership so candidate user can read them
chown -R candidate:candidate /home/candidate/ca-cert
chmod 644 /home/candidate/ca-cert/web.k8s.local.crt
chmod 600 /home/candidate/ca-cert/web.k8s.local.key

echo "Certificate files created:"
ls -l /home/candidate/ca-cert/

# Create namespace
kubectl create namespace clever-cactus --dry-run=client -o yaml | kubectl apply -f -

# Create a deployment that requires the TLS secret
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: clever-cactus
  namespace: clever-cactus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: clever-cactus
  template:
    metadata:
      labels:
        app: clever-cactus
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        volumeMounts:
        - name: tls
          mountPath: /etc/nginx/ssl
          readOnly: true
      volumes:
      - name: tls
        secret:
          secretName: clever-cactus   # This secret does not exist yet → Pod stays Pending
EOF

echo
echo "=== Setup complete ==="
echo "Deployment status (should be 0/1):"
kubectl -n clever-cactus get deploy clever-cactus

echo
echo "You can now practice the fix:"
echo "kubectl -n clever-cactus create secret tls clever-cactus \\"
echo "  --cert=/home/candidate/ca-cert/web.k8s.local.crt \\"
echo "  --key=/home/candidate/ca-cert/web.k8s.local.key"