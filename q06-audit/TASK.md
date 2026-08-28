# Q6 API audit logging

Point kube-apiserver at `/etc/kubernetes/logpolicy/sample-policy.yaml`.
Log path: `/var/log/kubernetes/audit-logs.txt`
Max 2 files, 10 days.

Extend policy to log:
- persistentvolumes at RequestResponse
- configmaps request bodies in namespace front-apps
- ConfigMap and Secret changes in all namespaces at Metadata
- everything else at Metadata
