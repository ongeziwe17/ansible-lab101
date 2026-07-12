#!/usr/bin/env bash
set -euo pipefail

: "${DEVOPS_USER:=devops}"

mkdir -p "/home/${DEVOPS_USER}/.ssh" /workspace
chown -R "${DEVOPS_USER}:${DEVOPS_USER}" "/home/${DEVOPS_USER}/.ssh"
chmod 700 "/home/${DEVOPS_USER}/.ssh"
chown "${DEVOPS_USER}:${DEVOPS_USER}" /workspace 2>/dev/null || true

exec runuser -u "${DEVOPS_USER}" -- "$@"
