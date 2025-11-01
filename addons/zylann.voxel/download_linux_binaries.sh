#!/bin/bash
# Script to download Zylann.Voxel GDExtension binaries for Linux
# Run this script to add Linux support to the addon

set -e

ADDON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$ADDON_DIR/bin"
TEMP_DIR="/tmp/godot_voxel_download"

echo "=== Zylann.Voxel Linux Binaries Downloader ==="
echo ""
echo "This script downloads the Linux x86_64 binaries for the Zylann.Voxel GDExtension."
echo "These binaries are required to use the addon on Linux systems."
echo ""

# Check if binaries already exist
if [ -f "$BIN_DIR/libvoxel.linux.editor.x86_64.so" ]; then
    echo "✓ Linux binaries already present!"
    echo "  - libvoxel.linux.editor.x86_64.so"
    [ -f "$BIN_DIR/libvoxel.linux.template_release.x86_64.so" ] && echo "  - libvoxel.linux.template_release.x86_64.so"
    echo ""
    read -p "Do you want to re-download and overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing binaries."
        exit 0
    fi
fi

# Create temp directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Fetching latest release information..."
RELEASE_URL=$(curl -s https://api.github.com/repos/Zylann/godot_voxel/releases | \
    grep "browser_download_url.*godot.*linux.*x86_64.*zip" | \
    head -n 1 | \
    cut -d '"' -f 4)

if [ -z "$RELEASE_URL" ]; then
    echo "ERROR: Could not find Linux binaries in releases."
    echo "Please download manually from: https://github.com/Zylann/godot_voxel/releases"
    exit 1
fi

echo "Found release: $RELEASE_URL"
echo "Downloading..."

curl -L -o godot_voxel_linux.zip "$RELEASE_URL"

echo "Extracting..."
unzip -q godot_voxel_linux.zip

# Find and copy the .so files
echo "Installing binaries..."
find . -name "libvoxel.linux.*.so" -exec cp {} "$BIN_DIR/" \;

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Linux binaries installed to: $BIN_DIR"
ls -lh "$BIN_DIR"/libvoxel.linux.*.so 2>/dev/null || echo "Warning: Files not found after installation"
echo ""
echo "The addon should now work on Linux systems with Godot 4.4.1+"
echo "Restart Godot to activate the changes."
