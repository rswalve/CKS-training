# Q16 Secure API server authz

Disable anonymous auth.
authorization-mode=Node,RBAC
admission: NodeRestriction
Then delete ClusterRoleBinding system:anonymous.
After hardening, use /etc/kubernetes/admin.conf
