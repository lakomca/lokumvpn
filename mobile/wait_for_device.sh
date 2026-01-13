#!/bin/bash

# Wait for Physical Device and Run App
# This script waits for a physical device to connect, then runs the app

set -e

API_URL="${1:-http://3.29.239.219:8000}"

echo "📱 Waiting for Physical Device to Connect..."
echo "=============================================="
echo ""
echo "Please:"
echo "  1. Connect your device (iOS or Android)"
echo "  2. Enable Developer Mode (iOS) or USB Debugging (Android)"
echo "  3. Unlock your device"
echo "  4. Trust this computer"
echo ""
echo "Checking for devices every 3 seconds..."
echo "Press Ctrl+C to cancel"
echo ""

MAX_WAIT=120  # 2 minutes max wait
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
    DEVICES=$(flutter devices 2>&1 | grep -iE "iphone|ipad|android" | grep -v "Simulator" || echo "")
    
    if [ ! -z "$DEVICES" ]; then
        echo ""
        echo "✅ Device detected!"
        echo "$DEVICES"
        echo ""
        echo "🚀 Running app with API URL: $API_URL"
        echo ""
        flutter run --dart-define=API_BASE_URL="$API_URL"
        exit 0
    fi
    
    echo -n "."
    sleep 3
    ELAPSED=$((ELAPSED + 3))
done

echo ""
echo "❌ No device detected after waiting 2 minutes."
echo ""
echo "Please check:"
echo "  • Device is connected via USB"
echo "  • Device is unlocked"
echo "  • Developer Mode enabled (iOS) or USB Debugging (Android)"
echo "  • Device trusts this computer"
echo ""
echo "Run 'flutter devices' to see current status"

