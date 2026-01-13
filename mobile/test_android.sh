#!/bin/bash

# Android Testing Script for Lokum VPN
# This script helps you test the app on Android emulator or physical device

set -e

echo "🚀 Lokum VPN - Android Testing Setup"
echo "====================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Check for available devices/emulators
echo "📱 Checking for Android devices/emulators..."
echo ""

DEVICES=$(flutter devices 2>&1 | grep -i android || echo "")
EMULATORS=$(flutter emulators 2>&1 | grep -i android || echo "")

if [ -z "$DEVICES" ] && [ -z "$EMULATORS" ]; then
    echo "⚠️  No Android devices or emulators found."
    echo ""
    echo "Available emulators:"
    flutter emulators
    echo ""
    echo "To launch an emulator, run:"
    echo "  flutter emulators --launch <emulator_id>"
    echo ""
    read -p "Would you like to launch an emulator now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Available Android emulators:"
        flutter emulators | grep android
        echo ""
        read -p "Enter emulator ID to launch: " EMULATOR_ID
        if [ ! -z "$EMULATOR_ID" ]; then
            echo "Launching $EMULATOR_ID..."
            flutter emulators --launch "$EMULATOR_ID"
            echo "Waiting for emulator to start..."
            sleep 10
        fi
    else
        echo "Please connect a device or launch an emulator, then run this script again."
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
echo "  1) On localhost (same machine) - use 10.0.2.2:8000 for emulator"
echo "  2) On remote server (3.29.239.219:8000)"
echo "  3) Custom URL"
echo ""
read -p "Select option (1/2/3): " API_OPTION

case $API_OPTION in
    1)
        # Check if we're using emulator or physical device
        DEVICE_TYPE=$(flutter devices 2>&1 | grep -i "emulator\|physical" | head -1 || echo "")
        if [[ "$DEVICE_TYPE" == *"emulator"* ]]; then
            API_URL="http://10.0.2.2:8000"
        else
            # For physical device, need to find local machine IP
            if [[ "$OSTYPE" == "darwin"* ]]; then
                LOCAL_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1 || echo "localhost")
            else
                LOCAL_IP=$(hostname -I | awk '{print $1}' || echo "localhost")
            fi
            API_URL="http://$LOCAL_IP:8000"
            echo "⚠️  Using $API_URL for physical device"
            echo "   Make sure your device is on the same WiFi network"
        fi
        ;;
    2)
        API_URL="http://3.29.239.219:8000"
        ;;
    3)
        read -p "Enter API URL (e.g., http://192.168.1.100:8000): " API_URL
        ;;
    *)
        echo "Invalid option. Using default: http://3.29.239.219:8000"
        API_URL="http://3.29.239.219:8000"
        ;;
esac

echo ""
echo "✅ Using API URL: $API_URL"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Run the app
echo "🚀 Launching app on Android..."
echo "   API URL: $API_URL"
echo ""

flutter run --dart-define=API_BASE_URL="$API_URL"

