#!/bin/bash
set -euo pipefail

# Load submodule info from JSON
COMFYUI_TAG=$(jq -r '.comfyui.tag' submodules.json)
COMFYUI_MANAGER_TAG=$(jq -r '.comfyui-manager.tag' submodules.json)

# Example: choose one submodule to drive OCI_IMAGE_TAG
export OCI_IMAGE_TAG="$COMFYUI_TAG"

# Trigger build with dynamic JSON
curl 'https://wf.jcan.dev/wf/webhooks/buildkit' \
  -H 'Content-Type: application/json' \
  -H "Authorization: ${{ secrets.ARGOWF_BEARER_TOKEN }}" \
  -d "{
      \"repo\": \"${{ github.server_url }}/${{ github.repository }}.git\",
      \"branch\": \"main\",
      \"dockerfile\": \"images/${{ env.OCI_IMAGE_NAME }}\",
      \"image\": \"ocr.jcan.dev/library/sd-${{ env.OCI_IMAGE_NAME }}:$OCI_IMAGE_TAG\",
      \"context\": \"./\"
    }"
