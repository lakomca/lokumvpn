#!/bin/bash
# Script to add a client to WireGuard server
# This is typically called by the Lokum VPN backend

set -e

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <client_public_key> <client_ip> <server_interface>"
    echo "Example: $0 <PUBLIC_KEY> 10.0.0.2/32 wg0"
    exit 1
fi

CLIENT_PUBLIC_KEY=$1
CLIENT_IP=$2
WG_INTERFACE=${3:-wg0}
CONFIG_FILE="/etc/wireguard/$WG_INTERFACE.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: WireGuard config file not found: $CONFIG_FILE"
    exit 1
fi

# Check if client already exists
if grep -q "$CLIENT_PUBLIC_KEY" "$CONFIG_FILE"; then
    echo "Client with this public key already exists"
    exit 1
fi

# Add client peer configuration
cat >> $CONFIG_FILE <<EOF

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP
EOF

# Reload WireGuard configuration
wg syncconf $WG_INTERFACE <(wg-quick strip $WG_INTERFACE)

echo "Client added successfully: $CLIENT_IP"
echo "Public Key: $CLIENT_PUBLIC_KEY"





