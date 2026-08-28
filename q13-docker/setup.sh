#!/usr/bin/env bash
set -euo pipefail
if ! command -v docker >/dev/null; then
  echo "No docker on this node (likely containerd). Q13 will SKIP on grade."
  exit 0
fi
id developer >/dev/null 2>&1 || sudo useradd -m developer || true
sudo gpasswd -a developer docker || true
echo "developer is in docker group. Student must gpasswd -d developer docker"
echo "Also check /etc/docker/daemon.json: no tcp:// hosts, and socket group root."
