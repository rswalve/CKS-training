# Q5 Container securityContext

Modify Deployment `secdep` in `sec-ns` so **every** container:
- runAsUser: 30000
- readOnlyRootFilesystem: true
- allowPrivilegeEscalation: false

Manifest: ~/sec-ns_deployment.yaml
