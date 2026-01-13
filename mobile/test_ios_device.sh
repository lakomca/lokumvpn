#!/bin/bash

# Physical iOS Device Testing Script for Lokum VPN
# This script helps you test the app on a physical iPhone/iPad

set -e

echo "📱 Lokum VPN - Physical iOS Device Testing Setup"
echo "=================================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Physical iOS device testing requires macOS."
    echo "   iOS development can only be done on macOS with Xcode."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install/macos"
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

# Check for connected iOS devices
echo "📱 Checking for connected iOS devices..."
echo ""

DEVICES=$(flutter devices 2>&1 | grep -i "iphone\|ipad" | grep -v "Simulator" || echo "")

if [ -z "$DEVICES" ]; then
    echo "⚠️  No physical iOS device detected."
    echo ""
    echo "Please ensure:"
    echo "  1. iPhone/iPad is connected via USB cable"
    echo "  2. Device is unlocked"
    echo "  3. You tapped 'Trust This Computer' when prompted"
    echo "  4. Developer Mode is enabled (iOS 16+):"
    echo "     Settings → Privacy & Security → Developer Mode"
    echo ""
    echo "Current devices:"
    flutter devices
    echo ""
    read -p "Press Enter after connecting your device, or Ctrl+C to cancel..."
    
    # Check again
    DEVICES=$(flutter devices 2>&1 | grep -i "iphone\|ipad" | grep -v "Simulator" || echo "")
    if [ -z "$DEVICES" ]; then
        echo "❌ Still no device detected. Please check the connection and try again."
        exit 1
    fi
fi

echo "✅ Device detected:"
echo "$DEVICES"
echo ""

# Determine API URL
echo "🔧 API Configuration"
echo "Where is your backend server running?"
echo "  1) On remote server (3.29.239.219:8000)"
echo "  2) On localhost (same Mac) - use your Mac's IP address"
echo "  3) Custom URL"
echo ""
read -p "Select option (1/2/3): " API_OPTION

case $API_OPTION in
    1)
        API_URL="http://3.29.239.219:8000"
        ;;
    2)
        # Get Mac's local IP address
        if [[ "$OSTYPE" == "darwin"* ]]; then
            LOCAL_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1 || echo "localhost")
            if [ "$LOCAL_IP" == "localhost" ]; then
                echo "⚠️  Could not determine local IP. Using localhost."
                LOCAL_IP="localhost"
            fi
            API_URL="http://$LOCAL_IP:8000"
            echo "   Using Mac's IP: $LOCAL_IP"
        else
            API_URL="http://localhost:8000"
        fi
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

# Check code signing
echo "🔐 Checking code signing setup..."
echo ""

IOS_DIR="ios"
if [ -d "$IOS_DIR" ]; then
    # Check if there's a team configured
    if grep -q "DEVELOPMENT_TEAM" "$IOS_DIR/Runner.xcodeproj/project.pbxproj" 2>/dev/null; then
        echo "✅ Code signing appears to be configured"
    else
        echo "⚠️  Code signing not configured. You may need to:"
        echo "   1. Open ios/Runner.xcworkspace in Xcode"
        echo "   2. Select Runner in project navigator"
        echo "   3. Go to Signing & Capabilities tab"
        echo "   4. Select your Team (add Apple ID if needed)"
        echo "   5. Xcode will automatically manage signing"
        echo ""
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Opening Xcode for code signing setup..."
            open "$IOS_DIR/Runner.xcworkspace" 2>/dev/null || open "$IOS_DIR/Runner.xcodeproj"
            echo "After configuring signing in Xcode, run this script again."
            exit 0
        fi
    fi
fi

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Install CocoaPods dependencies
if [ -d "ios" ]; then
    echo "📦 Installing CocoaPods dependencies..."
    cd ios
    if command -v pod &> /dev/null; then
        # Try to fix encoding issues
        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8
        pod install || echo "⚠️  Pod install had issues, but continuing..."
        cd ..
    else
        echo "⚠️  CocoaPods not found. Skipping pod install."
        echo "   Install with: sudo gem install cocoapods"
        cd ..
    fi
    echo ""
fi

# Network connectivity check
echo "🌐 Network Connectivity Check"
echo ""
echo "⚠️  IMPORTANT: Your iPhone must be able to reach the server."
echo ""
echo "Test from your iPhone:"
echo "  1. Open Safari on iPhone"
echo "  2. Go to: $API_URL/health"
echo "  3. Should see: {\"status\":\"healthy\"}"
echo ""
read -p "Have you verified the server is accessible from your iPhone? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "⚠️  Please test server connectivity first, then run this script again."
    echo "   Server URL: $API_URL/health"
    exit 1
fi

# Get device ID
DEVICE_ID=$(flutter devices 2>&1 | grep -i "iphone\|ipad" | grep -v "Simulator" | head -1 | awk '{print $5}' || echo "")

# Run the app
echo ""
echo "🚀 Launching app on physical iOS device..."
echo "   Device: $(flutter devices 2>&1 | grep -i "iphone\|ipad" | grep -v "Simulator" | head -1)"
echo "   API URL: $API_URL"
echo ""

if [ ! -z "$DEVICE_ID" ]; then
    flutter run --dart-define=API_BASE_URL="$API_URL" -d "$DEVICE_ID"
else
    flutter run --dart-define=API_BASE_URL="$API_URL"
fi

