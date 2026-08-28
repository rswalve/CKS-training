#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /etc/kubernetes
sudo tee /etc/kubernetes/epconfig >/dev/null <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/admission/admission-kubeconfig
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: true
EOF
sudo mkdir -p /etc/kubernetes/admission
cat > "$HOME/web1.yaml" <<'EOF'
apiVersion: v1
kind: Pod
metadata: {name: web1}
spec:
  containers:
  - name: bad
    image: evil.example.com/not-allowed:latest
    command: ["sleep","10"]
EOF
echo "Student: set defaultAllow: false, enable ImagePolicyWebhook on apiserver,"
echo "add --admission-control-config-file=/etc/kubernetes/epconfig"
echo "Enable plugin ImagePolicyWebhook (plus existing plugins)."
