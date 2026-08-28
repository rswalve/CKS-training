#!/usr/bin/env bash
root=$(cd "$(dirname "$0")" && pwd)
filter="${1:-}"
rc=0
for d in "$root"/q[0-9]*; do
  [[ -d $d ]] || continue
  base=$(basename "$d")
  if [[ -n $filter && $base != *$filter* ]]; then continue; fi
  echo "======== GRADE $base ========"
  bash "$d/grade.sh" || rc=1
done
exit $rc
