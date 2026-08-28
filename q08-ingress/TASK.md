# Q8 Ingress HTTPS

Create Ingress `web` in `prod02`:
- host web.k8sng.local, all paths -> Service `web`
- TLS secret `web-cert`
- redirect HTTP to HTTPS
Test: curl -Lk https://web.k8sng.local
