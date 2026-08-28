# Q9 Disable API credential automount

1. ServiceAccount `stats-monitor-sa` in `monitoring`: automountServiceAccountToken: false
2. Deployment `stats-monitor`: inject token via projected volume named `token`,
   mount read-only at /var/run/secrets/kubernetes.io/serviceaccount
Manifest: ~/stats-monitor/deployment.yaml
