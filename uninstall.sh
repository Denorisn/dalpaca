#!/bin/bash
# uninstall.sh - Remove dalpaca from /usr/local/bin

DEST="/usr/local/bin/dalpaca"

echo "Removing dalpaca from $DEST..."
sudo rm "$DEST"

if [[ $? -eq 0 ]]; then
    echo "✅ Uninstallation complete. 'dalpaca' has been removed."
else
    echo "❌ Uninstallation failed or file not found."
    exit 1
fi
