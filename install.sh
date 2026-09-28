#!/bin/bash
# install.sh - Install dalpaca to /usr/local/bin

SOURCE="./dalpaca"
DEST="/usr/local/bin/dalpaca"

if [[ ! -f "$SOURCE" ]]; then
    echo "Error: 'dalpaca' script not found in current directory."
    exit 1
fi

echo "Installing dalpaca to $DEST..."
sudo cp "$SOURCE" "$DEST"
sudo chmod +x "$DEST"

if [[ $? -eq 0 ]]; then
    echo "✅ Installation complete! 'dalpaca' is now available globally."
else
    echo "❌ Installation failed."
    exit 1
fi
