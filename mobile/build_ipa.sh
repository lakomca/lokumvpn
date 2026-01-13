#!/bin/bash

# Build IPA file for sideloading
# This creates an IPA file that can be installed via AltStore/Sideloadly

set -e

echo "📱 Building IPA for iOS Device"
echo "================================"
echo ""

# Check if in mobile directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Please run this script from the mobile directory"
    echo "   cd mobile && ./build_ipa.sh"
    exit 1
fi

echo "Step 1: Building iOS app (Release mode)..."
flutter build ios --release

echo ""
echo "Step 2: Creating IPA file..."

# Clean up old Payload if exists
rm -rf build/ios/Payload
rm -f build/ios/lokumvpn.ipa

# Create Payload directory and copy app
mkdir -p build/ios/Payload
cp -r build/ios/iphoneos/Runner.app build/ios/Payload/

# Create IPA
cd build/ios
zip -r lokumvpn.ipa Payload > /dev/null
cd ../..

echo ""
echo "✅ IPA file created successfully!"
echo ""
echo "Location: $(pwd)/build/ios/lokumvpn.ipa"
echo ""
echo "Next steps:"
echo "1. Transfer IPA to iPhone:"
echo "   - AirDrop to iPhone"
echo "   - Or copy to iCloud/Files app"
echo "   - Or use USB with Finder"
echo ""
echo "2. Install via AltStore:"
echo "   - Open AltStore on iPhone"
echo "   - Tap '+' button"
echo "   - Select IPA file"
echo "   - Enter Apple ID"
echo ""
echo "3. Or install via Sideloadly:"
echo "   - Connect iPhone via USB"
echo "   - Open Sideloadly"
echo "   - Select IPA file"
echo "   - Click 'Start'"
echo ""

