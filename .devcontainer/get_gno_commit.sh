#!/bin/bash

# Script to extract GNO_COMMIT value from devcontainer.json
# Usage: ./get_gno_commit.sh

# Current script path
CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Path to devcontainer.json
DEVCONTAINER_JSON_PATH="$CURRENT_SCRIPT_DIR/devcontainer.json"

# Check if file exists
if [[ ! -f "$DEVCONTAINER_JSON_PATH" ]]; then
    echo "Error: File '$DEVCONTAINER_JSON_PATH' not found." >&2
    exit 1
fi

# Extract GNO_COMMIT value using grep and sed
# This approach handles the JSON structure and extracts the value between quotes
GNO_COMMIT=$(grep -o '"GNO_COMMIT"[[:space:]]*:[[:space:]]*"[^"]*"' "$DEVCONTAINER_JSON_PATH" | \
             sed 's/.*"GNO_COMMIT"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Check if we found the GNO_COMMIT value
if [[ -z "$GNO_COMMIT" ]]; then
    echo "Error: GNO_COMMIT not found in '$DEVCONTAINER_JSON_PATH'." >&2
    exit 1
fi

# Output the GNO_COMMIT value
echo "$GNO_COMMIT"