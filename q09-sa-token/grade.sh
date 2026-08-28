#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q9 grade"
am=$(kubectl -n monitoring get sa stats-monitor-sa -o jsonpath='{.automountServiceAccountToken}')
[[ "$am" == "false" ]] && ok "SA automount false" || bad "SA automount should be false (got $am)"
y=$(kubectl -n monitoring get deploy stats-monitor -o yaml)
echo "$y" | grep -q 'name: token' && ok "projected volume named token" || bad "missing volume name token"
echo "$y" | grep -q 'serviceAccountToken' && ok "serviceAccountToken projection" || bad "missing projected serviceAccountToken"
echo "$y" | grep -q '/var/run/secrets/kubernetes.io/serviceaccount' && ok "mount path correct" || bad "wrong mount path"
summary
