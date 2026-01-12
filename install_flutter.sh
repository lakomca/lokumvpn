#!/bin/bash
# Flutter Installation Script for Lokum VPN

echo "=== Flutter Installation Script ==="
echo ""

# Check if Flutter is already installed
if command -v flutter &> /dev/null; then
    echo "✓ Flutter is already installed"
    flutter --version
    exit 0
fi

echo "Flutter is not installed. Choose an option:"
echo ""
echo "1. Install Flutter on this server (requires ~2GB space)"
echo "2. Show instructions for local machine installation"
echo "3. Exit"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "Installing Flutter..."
        
        # Install dependencies
        echo "Installing system dependencies..."
        sudo apt update
        sudo apt install -y curl git unzip xz-utils zip libglu1-mesa 2>&1 | tail -5
        
        # Download Flutter
        cd ~
        if [ ! -d "flutter" ]; then
            echo "Downloading Flutter SDK (this may take a few minutes)..."
            git clone https://github.com/flutter/flutter.git -b stable
        else
            echo "Flutter directory already exists"
        fi
        
        # Add to PATH
        export PATH="$PATH:$HOME/flutter/bin"
        if ! grep -q "flutter/bin" ~/.bashrc; then
            echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
            echo "Added Flutter to PATH in ~/.bashrc"
        fi
        
        # Verify
        echo ""
        echo "Verifying installation..."
        $HOME/flutter/bin/flutter doctor
        
        echo ""
        echo "✓ Flutter installed!"
        echo "Note: Restart your terminal or run: source ~/.bashrc"
        ;;
    2)
        echo ""
        echo "For local machine installation:"
        echo "1. Visit: https://docs.flutter.dev/get-started/install"
        echo "2. Follow instructions for your OS"
        echo "3. Configure mobile app to use: http://172.31.2.242:8000"
        echo ""
        echo "Or use the provided INSTALL_FLUTTER.md guide"
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
