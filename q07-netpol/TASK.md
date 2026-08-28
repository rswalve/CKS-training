# Q7 NetworkPolicy deny + allow

1. NetworkPolicy `deny-policy` in `prod` — deny all ingress.
   Namespace label: env=prod
2. NetworkPolicy `allow-from-prod` in `data` — allow ingress only from namespace env=prod.
   Namespace label: env=data
Do not modify namespaces or Pods.
