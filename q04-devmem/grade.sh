#!/usr/bin/env bash
# CKS Q4 grader — scale only the /dev/mem Deployment to 0
set -uo pipefail

pass=0
fail=0
ok()  { echo "PASS  $*"; pass=$((pass+1)); }
bad() { echo "FAIL  $*"; fail=$((fail+1)); }

echo "==> CKS Q4 grade: /dev/mem"

need() {
  kubectl get "$1" >/dev/null 2>&1
}

if ! need deploy/ollama || ! need deploy/ollama-proxy || ! need deploy/ollama-web; then
  bad "Expected Deployments ollama, ollama-proxy, ollama-web to still exist (do not delete Deployments)"
  echo "SCORE  $pass / $((pass+fail))"
  exit 1
fi
ok "All three Deployments still exist"

replicas() {
  kubectl get deploy "$1" -o jsonpath='{.spec.replicas}'
}

r_ollama=$(replicas ollama)
r_proxy=$(replicas ollama-proxy)
r_web=$(replicas ollama-web)

if [[ "${r_ollama}" == "0" ]]; then
  ok "ollama replicas == 0"
else
  bad "ollama replicas should be 0 (got ${r_ollama:-unset}) — this is the Pod that mounts /dev/mem"
fi

if [[ "${r_proxy}" == "1" ]]; then
  ok "ollama-proxy replicas unchanged (1)"
else
  bad "ollama-proxy replicas must stay 1 (got ${r_proxy:-unset})"
fi

if [[ "${r_web}" == "1" ]]; then
  ok "ollama-web replicas unchanged (1)"
else
  bad "ollama-web replicas must stay 1 (got ${r_web:-unset})"
fi

# Must not have rewritten the ollama template (privileged should still be true if they only scaled)
priv=$(kubectl get deploy ollama -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}' 2>/dev/null || true)
if [[ "${priv}" == "true" ]]; then
  ok "ollama template not rewritten (privileged still true)"
else
  bad "Do not modify the Deployment except scaling replicas (privileged flag missing/changed)"
fi

hp=$(kubectl get deploy ollama -o jsonpath='{.spec.template.spec.volumes[0].hostPath.path}' 2>/dev/null || true)
if [[ "${hp}" == "/dev/mem" ]]; then
  ok "ollama hostPath /dev/mem still present (spec not gutted)"
else
  bad "Do not modify the Deployment except scaling replicas (hostPath /dev/mem gone)"
fi

echo
echo "SCORE  ${pass} / $((pass+fail))"
if [[ "${fail}" -eq 0 ]]; then
  echo "RESULT PASS"
  exit 0
fi
echo "RESULT FAIL"
exit 1
