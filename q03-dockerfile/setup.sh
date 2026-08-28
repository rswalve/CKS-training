#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /cks/docker
sudo tee /cks/docker/Dockerfile >/dev/null <<'EOF'
FROM nginx:1.27
ENV PATH $PATH:/usr/local/nginx/sbin
WORKDIR /usr/local/nginx
EXPOSE 80
USER root
CMD ["nginx", "-g", "daemon off;"]
EOF
sudo tee /cks/docker/deployment.yaml >/dev/null <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: docker-hard
spec:
  replicas: 1
  selector:
    matchLabels: {app: docker-hard}
  template:
    metadata:
      labels: {app: docker-hard}
    spec:
      containers:
      - name: web
        image: nginx:1.27
        securityContext:
          privileged: true
EOF
sudo chmod 666 /cks/docker/Dockerfile /cks/docker/deployment.yaml
echo "Edit /cks/docker/Dockerfile and /cks/docker/deployment.yaml only."
