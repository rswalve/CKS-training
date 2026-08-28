#!/usr/bin/env bash
# CKS Q5 grader — both containers hardened
set -uo pipefail

pass=0
fail=0
ok()  { echo "PASS  $*"; pass=$((pass+1)); }
bad() { echo "FAIL  $*"; fail=$((fail+1)); }

ns=sec-ns
dep=secdep

echo "==> CKS Q5 grade: securityContext"

if ! kubectl -n "$ns" get deploy "$dep" >/dev/null 2>&1; then
  bad "Deployment $ns/$dep missing"
  echo "SCORE $pass / $((pass+fail))"
  exit 1
fi
ok "Deployment $ns/$dep exists"

count=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath='{.spec.template.spec.containers[*].name}' | wc -w)
if [[ "$count" -ge 2 ]]; then
  ok "Two containers still present"
else
  bad "Expected two containers (got $count)"
fi

check_container() {
  local idx="$1"
  local name
  name=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath="{.spec.template.spec.containers[$idx].name}")
  local uid ro ape
  uid=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath="{.spec.template.spec.containers[$idx].securityContext.runAsUser}")
  ro=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath="{.spec.template.spec.containers[$idx].securityContext.readOnlyRootFilesystem}")
  ape=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath="{.spec.template.spec.containers[$idx].securityContext.allowPrivilegeEscalation}")

  if [[ "$uid" == "30000" ]]; then ok "$name runAsUser=30000"; else bad "$name runAsUser should be 30000 (got '${uid:-empty}')"; fi
  if [[ "$ro" == "true" ]]; then ok "$name readOnlyRootFilesystem=true"; else bad "$name readOnlyRootFilesystem should be true"; fi
  if [[ "$ape" == "false" ]]; then ok "$name allowPrivilegeEscalation=false"; else bad "$name allowPrivilegeEscalation should be false"; fi
}

check_container 0
check_container 1

ready=$(kubectl -n "$ns" get deploy "$dep" -o jsonpath='{.status.readyReplicas}')
if [[ "${ready}" == "1" ]]; then
  ok "Deployment has 1 ready replica"
else
  bad "Deployment should be Running/ready (readyReplicas=${ready:-0}). Check events if a container cannot start."
fi

echo
echo "SCORE  ${pass} / $((pass+fail))"
if [[ "${fail}" -eq 0 ]]; then
  echo "RESULT PASS"
  exit 0
fi
echo "RESULT FAIL"
exit 1
