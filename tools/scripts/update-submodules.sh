#!/bin/bash
set -euo pipefail

# Ensure script is run from repo root
cd "$(dirname "$0")/../.."

echo "Updating submodules according to submodules.json"

# Iterate over submodules using jq
jq -c 'to_entries[]' submodules.json | while read -r sub; do
  name=$(echo "$sub" | jq -r '.key')
  url=$(echo "$sub" | jq -r '.value.url')
  tag=$(echo "$sub" | jq -r '.value.tag')
  path="resources/$name"

  echo "Updating $name ($path) to tag $tag"

  # Initialize submodule if missing
  if [ ! -d "$path" ]; then
    git submodule add "$url" "$path"
  fi

  # Fetch and checkout the tag
  git -C "$path" fetch --tags
  git -C "$path" checkout "$tag"
done
