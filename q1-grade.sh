#!/bin/bash
# grade-cks.sh - Checks if the 3 security issues were fixed

PASS=0
FAIL=0

echo "=== CKS Practice Grading ==="
echo

##############################
# Check 1: kubelet anonymous auth
##############################
KUBELET_CONFIG="/var/lib/kubelet/config.yaml"

if grep -A5 "anonymous:" "$KUBELET_CONFIG" | grep -q "enabled: false"; then
  echo "[PASS] kubelet anonymous authentication is disabled"
  ((PASS++))
else
  echo "[FAIL] kubelet anonymous authentication is still enabled"
  ((FAIL++))
fi

##############################
# Check 2: kubelet authorization mode
##############################
if grep -A3 "authorization:" "$KUBELET_CONFIG" | grep -q "mode: Webhook"; then
  echo "[PASS] kubelet authorization mode is Webhook"
  ((PASS++))
else
  echo "[FAIL] kubelet authorization mode is not Webhook"
  ((FAIL++))
fi

##############################
# Check 3: etcd client-cert-auth
##############################
ETCD_MANIFEST="/etc/kubernetes/manifests/etcd.yaml"

if grep -q -e "--client-cert-auth=true" "$ETCD_MANIFEST"; then
  echo "[PASS] etcd client-cert-auth is set to true"
  ((PASS++))
else
  echo "[FAIL] etcd client-cert-auth is not set to true"
  ((FAIL++))
fi

echo
echo "--------------------------------"
echo "Results: $PASS passed, $FAIL failed"
echo "--------------------------------"

if [[ $FAIL -eq 0 ]]; then
  echo "Overall: PASSED"
  exit 0
else
  echo "Overall: FAILED"
  exit 1
fi