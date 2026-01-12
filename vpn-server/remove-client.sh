#!/bin/bash
# Script to remove a client from WireGuard server

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <client_public_key> [server_interface]"
    echo "Example: $0 <PUBLIC_KEY> wg0"
    exit 1
fi

CLIENT_PUBLIC_KEY=$1
WG_INTERFACE=${2:-wg0}
CONFIG_FILE="/etc/wireguard/$WG_INTERFACE.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: WireGuard config file not found: $CONFIG_FILE"
    exit 1
fi

# Remove client peer configuration
sed -i "/\[Peer\]/,/^$/{
    /PublicKey = $CLIENT_PUBLIC_KEY/,/^$/d
}" "$CONFIG_FILE"

# Reload WireGuard configuration
wg syncconf $WG_INTERFACE <(wg-quick strip $WG_INTERFACE)

echo "Client removed successfully"
echo "Public Key: $CLIENT_PUBLIC_KEY"





