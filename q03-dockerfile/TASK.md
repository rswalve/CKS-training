# Q3 Dockerfile + Deployment hardening

Edit `/cks/docker/Dockerfile` — fix the insecure USER instruction.
Edit `/cks/docker/deployment.yaml` — fix the insecure field.
Do **not** build the image.
If you need a non-root user, use `nobody` (uid 65535).
Only change existing fields; do not add extra settings.
