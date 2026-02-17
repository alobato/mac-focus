#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing mac-focus...${NC}"

# Check if Swift is available
if ! command -v swiftc &> /dev/null; then
    echo -e "${RED}Error: Swift compiler not found.${NC}"
    echo "Please install Xcode Command Line Tools:"
    echo "  xcode-select --install"
    exit 1
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download the source file
echo "Downloading mac-focus source..."
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/mac-focus/main/mac_focus.swift -o mac_focus.swift

# Compile
echo "Compiling mac-focus..."
swiftc -o mac-focus mac_focus.swift -framework ApplicationServices -framework Cocoa

# Determine install location
if [ -w /usr/local/bin ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
else
    mkdir -p "$HOME/.local/bin"
    INSTALL_DIR="$HOME/.local/bin"
fi

# Install
echo "Installing to $INSTALL_DIR..."
cp mac-focus "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/mac-focus"

# Add to PATH if needed
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo -e "${YELLOW}Note: $HOME/.local/bin is not in your PATH.${NC}"
    echo "Add this line to your ~/.zshrc or ~/.bash_profile:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Then run: source ~/.zshrc"
fi

# Cleanup
cd -
rm -rf "$TMP_DIR"

echo -e "${GREEN}mac-focus installed successfully!${NC}"
echo ""
echo "Usage: mac-focus"
echo "Example: sleep 3 && mac-focus"
