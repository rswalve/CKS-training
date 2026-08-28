# Q1 Fix kubelet and etcd CIS findings

Fix kubelet:
- anonymous-auth = false
- authorization-mode is not AlwaysAllow (use Webhook)

Fix etcd:
- client-cert-auth = true

Restart affected components so settings apply.
