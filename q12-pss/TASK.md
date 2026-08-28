# Q12 Restricted Pod Security Standard

Namespace `confidential` is restricted.
Fix Deployment so the Pod schedules.
Manifest: ~/nginx-unprivileged.yaml
Need restricted-compatible securityContext (non-root, drop ALL, no priv-esc, RuntimeDefault seccomp).
