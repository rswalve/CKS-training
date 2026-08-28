#!/usr/bin/env bash
ok()  { echo "PASS  $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL  $*"; FAIL=$((FAIL+1)); }
skip(){ echo "SKIP  $*"; }
have(){ command -v "$1" >/dev/null 2>&1; }
k(){ kubectl "$@"; }
summary(){
  echo
  echo "SCORE  ${PASS:-0} / $(( ${PASS:-0} + ${FAIL:-0} ))"
  if [[ "${FAIL:-0}" -eq 0 ]]; then echo "RESULT PASS"; return 0; fi
  echo "RESULT FAIL"; return 1
}
PASS=0; FAIL=0
