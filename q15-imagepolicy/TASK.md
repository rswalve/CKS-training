# Q15 ImagePolicyWebhook

Enable admission plugins from /etc/kubernetes/epconfig (AdmissionConfiguration).
ImagePolicyWebhook must fail closed if backend is down.
Test with ~/web1.yaml (should be rejected).
Webhook: https://image-bouncer-webhook.default.svc:1323/image_policy
