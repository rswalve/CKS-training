#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")" && pwd)
filter="${1:-}"
for d in "$root"/q[0-9]*; do
  [[ -d $d ]] || continue
  base=$(basename "$d")
  if [[ -n $filter && $base != *$filter* ]]; then continue; fi
  echo "======== SETUP $base ========"
  bash "$d/setup.sh" || echo "setup $base returned $?"
done
