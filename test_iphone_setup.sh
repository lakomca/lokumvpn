#!/bin/bash
# Quick setup guide for iPhone testing

SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="172.31.2.242"
fi

echo "=== iPhone Testing Setup ==="
echo ""
echo "Server IP: $SERVER_IP"
echo "Backend URL: http://$SERVER_IP:8000"
echo ""
echo "Quick Steps:"
echo "1. Ensure iPhone is connected via USB"
echo "2. Trust computer on iPhone (if prompted)"
echo "3. From your LOCAL machine (with Flutter):"
echo ""
echo "   cd mobile"
echo "   flutter pub get"
echo "   flutter devices  # Verify iPhone is listed"
echo "   flutter run --dart-define=API_BASE_URL=http://$SERVER_IP:8000"
echo ""
echo "4. Or update mobile/lib/config/config.dart:"
echo "   static const String apiBaseUrl = 'http://$SERVER_IP:8000';"
echo ""
echo "Network Requirements:"
echo "- iPhone and server must be on same WiFi network"
echo "- OR use server's public IP (if firewall allows)"
echo ""
echo "Test connectivity from iPhone Safari:"
echo "http://$SERVER_IP:8000/health"
echo "Should show: {\"status\":\"healthy\"}"
echo ""
