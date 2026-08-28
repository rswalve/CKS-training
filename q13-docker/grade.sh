#!/usr/bin/env bash
set -uo pipefail
. "$(dirname "$0")/../lib.sh"
echo "==> Q13 grade"
if ! command -v docker >/dev/null; then skip "docker not installed"; summary; exit 0; fi
if id developer >/dev/null 2>&1; then
  groups=$(id -nG developer)
  echo "$groups" | grep -qw docker && bad "developer still in docker group" || ok "developer not in docker"
else
  skip "user developer does not exist"
fi
if [[ -S /var/run/docker.sock ]]; then
  g=$(stat -c %G /var/run/docker.sock)
  [[ "$g" == "root" ]] && ok "docker.sock group root" || bad "docker.sock group is $g (want root)"
fi
if ss -lnt 2>/dev/null | grep -qE ':2375|:2376'; then bad "docker still listening on TCP 2375/2376"; else ok "no docker TCP port"; fi
summary
