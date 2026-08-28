# Q14 Istio mTLS

1. Inject istio-proxy into all Pods in namespace `mtls` (namespace label istio-injection=enabled, restart workloads).
2. PeerAuthentication in `mtls` with mtls.mode: STRICT for the whole namespace.
