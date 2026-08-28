#!/bin/bash

echo "=== Creating broken CKS Question 3 files ==="

mkdir -p /cks/docker

# --- Broken Dockerfile ---
cat > /cks/docker/Dockerfile << 'EOF'
FROM nginx:alpine

ENV PATH $PATH:/usr/local/nginx/sbin
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
WORKDIR /usr/local/nginx
EXPOSE 80
USER root
EOF

# --- Broken Deployment ---
cat > /cks/docker/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-secure
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-secure
  template:
    metadata:
      labels:
        app: nginx-secure
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - name: http
          containerPort: 8080
        securityContext:
          runAsUser: 0                 # WRONG - should be 65535
          readOnlyRootFilesystem: false # WRONG - should be true
          privileged: true              # WRONG - should be false
          capabilities:
            drop: ["all"]
            add: ["NET_BIND_SERVICE"]
        volumeMounts:
        - name: database-storage
          mountPath: /var/lib/database
      volumes:
      - name: database-storage
        emptyDir: {}
EOF

echo "Broken files created:"
echo "  /cks/docker/Dockerfile"
echo "  /cks/docker/deployment.yaml"
echo ""
echo "Now fix them with vim as required by the question."