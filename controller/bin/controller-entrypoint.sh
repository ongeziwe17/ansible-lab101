#!/usr/bin/env bash
set -euo pipefail

: "${DEVOPS_USER:=devops}"

mkdir -p "/home/${DEVOPS_USER}/.ssh" /workspace

chmod 700 "/home/${DEVOPS_USER}/.ssh" 2>/dev/null || true
chmod 755 /workspace 2>/dev/null || true

exec "$@"
