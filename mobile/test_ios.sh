#!/bin/bash

# iOS Simulator Testing Script for Lokum VPN
# This script helps you test the app on iOS Simulator

set -e

echo "🍎 Lokum VPN - iOS Simulator Testing Setup"
echo "==========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS Simulator is only available on macOS."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the Mac App Store."
    exit 1
fi

echo "✅ Xcode found"
echo ""

# Check for iOS Simulator
echo "📱 Checking for iOS Simulator..."
echo ""

DEVICES=$(flutter devices 2>&1 | grep -i "iphone\|ios" || echo "")
EMULATORS=$(flutter emulators 2>&1 | grep -i ios || echo "")

if [ -z "$DEVICES" ] && [ ! -z "$EMULATORS" ]; then
    echo "⚠️  iOS Simulator is not running."
    echo ""
    echo "Available iOS simulators:"
    flutter emulators | grep ios
    echo ""
    read -p "Would you like to launch iOS Simulator now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Launching iOS Simulator..."
        flutter emulators --launch apple_ios_simulator
        echo "Waiting for simulator to start..."
        sleep 15
    else
        echo "Please launch iOS Simulator manually, then run this script again."
        exit 1
    fi
fi

# Check for devices again
echo ""
echo "📱 Available devices:"
flutter devices
echo ""

# Determine API URL
echo "🔧 API Configuration"
echo "Where is your backend server running?"
echo "  1) On localhost (same machine) - use localhost:8000"
echo "  2) On remote server (172.31.2.242:8000)"
echo "  3) Custom URL"
echo ""
read -p "Select option (1/2/3): " API_OPTION

case $API_OPTION in
    1)
        API_URL="http://localhost:8000"
        ;;
    2)
        API_URL="http://172.31.2.242:8000"
        ;;
    3)
        read -p "Enter API URL (e.g., http://192.168.1.100:8000): " API_URL
        ;;
    *)
        echo "Invalid option. Using default: http://172.31.2.242:8000"
        API_URL="http://172.31.2.242:8000"
        ;;
esac

echo ""
echo "✅ Using API URL: $API_URL"
echo ""

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Install CocoaPods dependencies
if [ -d "ios" ]; then
    echo "📦 Installing CocoaPods dependencies..."
    cd ios
    if command -v pod &> /dev/null; then
        pod install
        cd ..
    else
        echo "⚠️  CocoaPods not found. Skipping pod install."
        echo "   Install with: sudo gem install cocoapods"
        cd ..
    fi
    echo ""
fi

# Run the app
echo "🚀 Launching app on iOS Simulator..."
echo "   API URL: $API_URL"
echo ""

flutter run --dart-define=API_BASE_URL="$API_URL"

