#!/bin/bash
set -Eeuo pipefail

CLONED_PATH=$1
ACTIVE_PATH=$2

if [ -z "$CLONED_PATH" ] || [ -z "$ACTIVE_PATH" ]; then
  echo "Usage: $0 <CLONED_PATH> <ACTIVE_PATH>"
  exit 1
fi

# Subpaths that are volume mounted and need to be checked
MOUNTED_SUBDIRS=("models" "output")

for subdir in "${MOUNTED_SUBDIRS[@]}"; do
    # Define reference path (inside cloned repo) and active path (inside runtime container)
    REF_DIR="$CLONED_PATH/$subdir"
    ACTIVE_DIR="$ACTIVE_PATH/$subdir"

    # Only proceed if the reference directory exists
    if [ -d "$REF_DIR" ]; then
        # Iterate through each subfolder in the reference directory
        for ref_sub in "$REF_DIR"/*/; do
            # Extract subfolder name (e.g., checkpoints, embeddings, etc.)
            ref_name=$(basename "$ref_sub")
            # Define target path where the subfolder should exist in ACTIVE_PATH
            target="$ACTIVE_DIR/$ref_name"

            # If the target folder does not exist in ACTIVE_PATH, recreate it
            if [ ! -d "$target" ]; then
                echo "Restoring missing folder: $target"
                mkdir -p "$target"
            else
                # Otherwise, confirm that it already exists
                echo "Exists: $target"
            fi
        done
    fi
done
echo "Path synchronization complete."