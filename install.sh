#!/bin/bash
# install.sh - Install dalpaca to /usr/local/bin and require the llama.cpp directory

SOURCE="./dalpaca"
DEST="/usr/local/bin/dalpaca"
DALPACA_HOME="$HOME/.dalpaca"
LLAMA_CONF="$DALPACA_HOME/llama_dir.conf"

if [[ ! -f "$SOURCE" ]]; then
    echo "Error: 'dalpaca' script not found in current directory."
    exit 1
fi

# --- Step 1: require the llama.cpp build directory ---
echo "Enter the path to your llama.cpp build directory (containing llama-cli / llama-server):"
while :; do
    read -r dir
    if [[ -n "$dir" && -d "$dir" && ( -f "$dir/llama-cli" || -f "$dir/llama-server" ) ]]; then
        break
    fi
    echo "⚠️  Directory not found or contains neither 'llama-cli' nor 'llama-server'. Try again."
done

mkdir -p "$DALPACA_HOME"
echo "$dir" > "$LLAMA_CONF"
echo "✅ llama.cpp directory set to: $dir"

# --- Step 2: install the script ---
echo "Installing dalpaca to $DEST..."
sudo cp "$SOURCE" "$DEST"
sudo chmod +x "$DEST"

if [[ $? -eq 0 ]]; then
    echo "✅ Installation complete! 'dalpaca' is now available globally."
else
    echo "❌ Installation failed."
    exit 1
fi
