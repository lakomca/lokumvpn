#!/bin/bash
# WireGuard VPN Server Setup Script for Lokum VPN
# This script sets up a WireGuard VPN server on Ubuntu/Debian

set -e

echo "=== Lokum VPN - WireGuard Server Setup ==="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update system
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install WireGuard
echo "Installing WireGuard..."
apt-get install -y wireguard wireguard-tools iptables qrencode

# Enable IP forwarding
echo "Enabling IP forwarding..."
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p

# Generate server keys
WG_DIR="/etc/wireguard"
mkdir -p $WG_DIR

if [ ! -f "$WG_DIR/privatekey" ]; then
    echo "Generating server keys..."
    wg genkey | tee $WG_DIR/privatekey | wg pubkey > $WG_DIR/publickey
    chmod 600 $WG_DIR/privatekey
    chmod 644 $WG_DIR/publickey
fi

PRIVATE_KEY=$(cat $WG_DIR/privatekey)
PUBLIC_KEY=$(cat $WG_DIR/publickey)

# Get server IP
SERVER_IP=$(curl -s ifconfig.me || curl -s icanhazip.com || echo "YOUR_SERVER_IP")
SERVER_PORT=${SERVER_PORT:-51820}
WG_INTERFACE=${WG_INTERFACE:-wg0}

# Create WireGuard configuration
CONFIG_FILE="$WG_DIR/$WG_INTERFACE.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating WireGuard configuration..."
    cat > $CONFIG_FILE <<EOF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = $SERVER_PORT
PostUp = iptables -A FORWARD -i $WG_INTERFACE -j ACCEPT; iptables -A FORWARD -o $WG_INTERFACE -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i $WG_INTERFACE -j ACCEPT; iptables -D FORWARD -o $WG_INTERFACE -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Add client configurations here using the Lokum VPN backend API
EOF
    chmod 600 $CONFIG_FILE
fi

# Enable and start WireGuard
echo "Starting WireGuard service..."
systemctl enable wg-quick@$WG_INTERFACE
systemctl start wg-quick@$WG_INTERFACE

# Display server information
echo ""
echo "=== WireGuard Server Setup Complete ==="
echo "Server Public Key: $PUBLIC_KEY"
echo "Server IP: $SERVER_IP"
echo "Server Port: $SERVER_PORT"
echo "Interface: $WG_INTERFACE"
echo ""
echo "Add this server to your Lokum VPN backend with:"
echo "  - Hostname: $(hostname)"
echo "  - IP Address: $SERVER_IP"
echo "  - Public Key: $PUBLIC_KEY"
echo "  - Endpoint: $SERVER_IP:$SERVER_PORT"
echo ""
echo "Configuration file: $CONFIG_FILE"
echo "To check status: wg show"
echo "To add clients, use the Lokum VPN backend API"





