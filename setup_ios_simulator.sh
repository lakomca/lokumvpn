#!/bin/bash
# iOS Simulator Setup Script for Mac
# Run this script on YOUR MAC (not the server)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     iOS Simulator Setup Script for Lokum VPN               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

SERVER_IP="172.31.2.242"
SERVER_USER="admin"
MOBILE_DIR="$HOME/lokum-vpn-mobile"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script must be run on macOS"
    echo "   iOS Simulator only works on Mac"
    exit 1
fi

echo "✓ Running on macOS"
echo ""

# Check Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "⚠️  Xcode not found"
    echo ""
    echo "Please install Xcode:"
    echo "1. Open Mac App Store"
    echo "2. Search for 'Xcode'"
    echo "3. Click Install"
    echo "4. After installation, open Xcode and accept license"
    echo ""
    read -p "Press Enter after Xcode is installed, or Ctrl+C to exit..."
fi

# Install Xcode Command Line Tools
echo "Checking Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the installation, then run this script again"
    exit 0
fi
echo "✓ Xcode Command Line Tools installed"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter not found"
    echo ""
    echo "Installing Flutter..."
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        echo "Installing Flutter via Homebrew..."
        brew install --cask flutter
    else
        echo "Homebrew not found. Installing Flutter manually..."
        echo ""
        echo "Please install Flutter manually:"
        echo "1. Visit: https://docs.flutter.dev/get-started/install/macos"
        echo "2. Download Flutter SDK"
        echo "3. Extract to ~/flutter"
        echo "4. Add to PATH: export PATH=\"\$PATH:\$HOME/flutter/bin\""
        echo ""
        read -p "Press Enter after Flutter is installed, or Ctrl+C to exit..."
    fi
fi

# Verify Flutter
if command -v flutter &> /dev/null; then
    echo "✓ Flutter installed: $(flutter --version | head -1)"
    flutter doctor
    echo ""
else
    echo "❌ Flutter installation failed"
    exit 1
fi

# Check CocoaPods
if ! command -v pod &> /dev/null; then
    echo "Installing CocoaPods..."
    sudo gem install cocoapods
fi
echo "✓ CocoaPods installed"
echo ""

# Copy mobile app
echo "Copying mobile app from server..."
if [ ! -d "$MOBILE_DIR" ]; then
    echo "Copying from server..."
    scp -r ${SERVER_USER}@${SERVER_IP}:/home/admin/lokum-vpn/mobile "$MOBILE_DIR"
    echo "✓ Mobile app copied to $MOBILE_DIR"
else
    echo "✓ Mobile app already exists at $MOBILE_DIR"
fi
echo ""

# Install Flutter dependencies
echo "Installing Flutter dependencies..."
cd "$MOBILE_DIR"
flutter pub get
echo "✓ Flutter dependencies installed"
echo ""

# Install CocoaPods dependencies
echo "Installing CocoaPods dependencies..."
cd ios
pod install
cd ..
echo "✓ CocoaPods dependencies installed"
echo ""

# Start iOS Simulator
echo "Starting iOS Simulator..."
open -a Simulator
sleep 5
echo "✓ iOS Simulator started"
echo ""

# Verify simulator
echo "Checking available devices..."
flutter devices
echo ""

# Test backend connectivity
echo "Testing backend connectivity..."
if curl -s http://${SERVER_IP}:8000/health > /dev/null; then
    echo "✓ Backend is accessible at http://${SERVER_IP}:8000"
else
    echo "⚠️  Backend not accessible. Make sure it's running on the server"
    echo "   Run on server: cd backend && source venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000"
fi
echo ""

# Ready to run
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    Ready to Test!                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "To run the app on iOS Simulator:"
echo ""
echo "  cd $MOBILE_DIR"
echo "  flutter run --dart-define=API_BASE_URL=http://${SERVER_IP}:8000"
echo ""
echo "Or if you updated config.dart:"
echo ""
echo "  cd $MOBILE_DIR"
echo "  flutter run"
echo ""
echo "Server IP: $SERVER_IP"
echo "Backend URL: http://${SERVER_IP}:8000"
echo ""

