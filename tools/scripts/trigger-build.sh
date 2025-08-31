#!/bin/bash
GIT_URL=https://github.com/Kube-Mind/stable-diffusion-webui.git
OCI_IMAGE_NAME=comfyui
ARGOWF_BEARER_TOKEN=$1

# Load submodule info from JSON
COMFYUI_TAG=$(jq -r '.comfyui.tag' submodules.json)

# Example: choose one submodule to drive OCI_IMAGE_TAG
export OCI_IMAGE_TAG="$COMFYUI_TAG"

# Trigger build with dynamic JSON
curl 'https://wf.jcan.dev/wf/webhooks/buildkit' \
  -H 'Content-Type: application/json' \
  -H "Authorization: $ARGOWF_BEARER_TOKEN" \
  -d "{
      \"repo\": \"$GIT_URL.git\",
      \"branch\": \"main\",
      \"dockerfile\": \"images/$OCI_IMAGE_NAME\",
      \"image\": \"ocr.jcan.dev/library/sd-$OCI_IMAGE_NAME:$OCI_IMAGE_TAG\",
      \"context\": \"./\"
    }"
