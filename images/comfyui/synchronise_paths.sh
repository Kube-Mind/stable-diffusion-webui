#!/bin/bash
set -Eeuo pipefail

CLONED_PATH=$1

if [ -z "$CLONED_PATH" ]; then
  echo "Usage: $0 <CLONED_PATH>"
  exit 1
fi

# Subpaths that are volume mounted and need to be checked
MOUNTED_SUBDIRS=("models" "output")

for subdir in "${MOUNTED_SUBDIRS[@]}"; do
    # Define path (inside cloned repo) to check for missing folders
    ACTIVE_DIR="$CLONED_PATH/$subdir"

    # Only proceed if the reference directory does not exist
    if [ ! -d "$ACTIVE_DIR" ]; then
        # Iterate through each subfolder in the cloned directory and restore
        cd $CLONED_PATH && git restore $subdir
    fi
done
echo "Path synchronization complete."