#!/bin/bash

# TestFlight Build Script for Lokum VPN
# This script helps you build and prepare the app for TestFlight distribution

set -e

echo "🚀 Lokum VPN - TestFlight Build Setup"
echo "======================================"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ TestFlight builds require macOS and Xcode."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the Mac App Store."
    exit 1
fi

echo "✅ Xcode found: $(xcodebuild -version | head -1)"
echo ""

# Check if iOS directory exists
if [ ! -d "ios" ]; then
    echo "❌ iOS directory not found. Are you in the mobile directory?"
    exit 1
fi

echo "📋 TestFlight Requirements Checklist:"
echo ""
echo "Before proceeding, ensure you have:"
echo "  ☐ Paid Apple Developer Account (\$99/year)"
echo "  ☐ Signed in to Apple Developer account in Xcode"
echo "  ☐ App registered in App Store Connect (or we'll create one)"
echo "  ☐ TestFlight app installed on your iPhone (from App Store)"
echo ""
read -p "Do you have an Apple Developer account? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "❌ You need an Apple Developer account for TestFlight."
    echo "   Sign up at: https://developer.apple.com/programs/"
    echo "   Cost: \$99/year"
    exit 1
fi

echo ""
echo "🔧 Step 1: Installing Flutter dependencies..."
flutter pub get
echo ""

echo "🔧 Step 2: Building iOS release..."
flutter build ios --release --no-codesign
echo ""

echo "✅ Build completed!"
echo ""
echo "📦 Next Steps:"
echo ""
echo "1. Open Xcode:"
echo "   open ios/Runner.xcworkspace"
echo ""
echo "2. In Xcode:"
echo "   - Select 'Any iOS Device (arm64)' or your device from device selector"
echo "   - Product → Archive"
echo "   - Wait for archive to complete"
echo ""
echo "3. In Organizer window:"
echo "   - Click 'Distribute App'"
echo "   - Select 'App Store Connect'"
echo "   - Click 'Next'"
echo "   - Select 'Upload'"
echo "   - Click 'Next'"
echo "   - Select your distribution options"
echo "   - Click 'Upload'"
echo ""
echo "4. Wait for upload to complete (5-15 minutes)"
echo ""
echo "5. Go to App Store Connect:"
echo "   https://appstoreconnect.apple.com"
echo "   - Apps → Your App → TestFlight"
echo "   - Wait for processing (10-60 minutes)"
echo "   - Add testers (Internal or External)"
echo ""
echo "6. On your iPhone:"
echo "   - Install TestFlight app (if not installed)"
echo "   - Open TestFlight"
echo "   - Accept invitation or find your app"
echo "   - Install the app"
echo ""
echo "⚠️  Note: First build may take 30-60 minutes to process in TestFlight"
echo ""

# Ask if user wants to open Xcode now
read -p "Open Xcode now to start the Archive process? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Opening Xcode..."
    open ios/Runner.xcworkspace
    
    echo ""
    echo "✅ Xcode opened!"
    echo ""
    echo "Next:"
    echo "1. Select 'Any iOS Device (arm64)' from device selector (top toolbar)"
    echo "2. Product → Archive"
    echo "3. Follow the steps above"
else
    echo ""
    echo "You can open Xcode later with:"
    echo "  open ios/Runner.xcworkspace"
fi

