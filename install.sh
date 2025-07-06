#!/bin/bash
# Atlas Project Automation Installer
# Installs the automation scripts to your system

set -e

echo "🚀 Installing Atlas Project Automation..."

# Get current script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPTS="$SCRIPT_DIR/scripts"

# Default installation directory (can be overridden)
INSTALL_DIR="${1:-$HOME/.claude/.scripts}"

# Create installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📁 Creating installation directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Copy scripts
echo "📋 Copying scripts to $INSTALL_DIR..."
cp "$SOURCE_SCRIPTS/new-project.sh" "$INSTALL_DIR/"
cp "$SOURCE_SCRIPTS/new-project.ps1" "$INSTALL_DIR/"

# Make bash script executable
chmod +x "$INSTALL_DIR/new-project.sh"

echo "✅ Installation complete!"
echo ""
echo "📍 Scripts installed to: $INSTALL_DIR"
echo ""
echo "Usage:"
echo "  Bash:       $INSTALL_DIR/new-project.sh project-name"
echo "  PowerShell: $INSTALL_DIR/new-project.ps1 -ProjectName 'project-name'"
echo ""
echo "To add to PATH, add this to your ~/.bashrc or ~/.zshrc:"
echo "  export PATH=\"$INSTALL_DIR:\$PATH\""