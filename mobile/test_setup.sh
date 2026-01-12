#!/bin/bash
# Quick setup script for testing Lokum VPN mobile app

echo "=== Lokum VPN Mobile App Testing Setup ==="

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="172.31.2.242"
fi

echo ""
echo "Detected server IP: $SERVER_IP"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"

# Check backend
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "✓ Backend is running"
else
    echo "⚠️  Backend not running. Start it with:"
    echo "   cd ../backend && source venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000"
fi

echo ""
echo "Testing Configuration Options:"
echo "1. Android Emulator: Use http://10.0.2.2:8000"
echo "2. iOS Simulator: Use http://localhost:8000"
echo "3. Physical Device: Use http://$SERVER_IP:8000"
echo ""

# Check devices
echo "Available devices:"
flutter devices

echo ""
echo "To run the app:"
echo "  cd mobile"
echo "  flutter pub get"
echo "  flutter run --dart-define=API_BASE_URL=http://$SERVER_IP:8000"
echo ""
