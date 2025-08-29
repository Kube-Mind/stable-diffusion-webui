#!/bin/bash

set -Eeuo pipefail

# test for pythorch
python /docker/images/comfyui/torch-test.py

declare -A MOUNTS

MOUNTS["${USER_HOME}/.cache"]="${ROOT}/comfyui/models/.cache"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

# Call synchronise_paths.sh to restore missing mounted subfolders
/docker/images/comfyui/synchronise_paths.sh /docker/resources/comfyui ${ROOT}/comfyui

# Only chown if not running as root (UID != 0)
if [ "$(id -u)" -ne 0 ]; then
  chown -R "$(id -u):$(id -g)" ~ 2>/dev/null || true
fi

chown -R $PUID:$PGID ~/.cache/
chmod 776 ~/.cache/

exec "$@"
