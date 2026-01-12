# Lokum VPN - Setup Guide

## Overview

Lokum VPN is a full-featured VPN service with a Python FastAPI backend and Flutter mobile apps. This guide will help you set up and deploy the entire system.

## Prerequisites

- **Python 3.11+** (for backend)
- **Flutter 3.0+** (for mobile apps)
- **WireGuard** (for VPN server)
- **Docker & Docker Compose** (optional, for containerized deployment)
- **Linux/Unix** system for VPN server setup

## Quick Start

### 1. Automated Setup

Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Create Python virtual environment
- Install backend dependencies
- Generate secure `.env` configuration
- Initialize database
- Install Flutter dependencies (if Flutter is installed)

### 2. Manual Setup

#### Backend Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env  # Edit .env with your settings
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

API Documentation: `http://localhost:8000/docs`

#### Mobile App Setup

```bash
cd mobile
flutter pub get
flutter run
```

**Important:** Update the API base URL in `lib/config/config.dart`:
```dart
static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';
```

#### VPN Server Setup

On your VPN server (Ubuntu/Debian):

```bash
cd vpn-server
sudo chmod +x setup-wireguard.sh
sudo ./setup-wireguard.sh
```

This will:
- Install WireGuard
- Generate server keys
- Configure WireGuard interface
- Enable IP forwarding
- Set up firewall rules

**After setup, note:**
- Server Public Key (for backend configuration)
- Server IP Address
- Server Port (default: 51820)

### 3. Add VPN Server to Backend

Once your VPN server is set up, add it to the backend using the API:

```bash
curl -X POST "http://localhost:8000/api/v1/servers/" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "US East Server",
    "country": "United States",
    "country_code": "US",
    "region": "East",
    "hostname": "us-east.lokumvpn.com",
    "ip_address": "YOUR_SERVER_IP",
    "ipv6_address": null,
    "port": 51820,
    "public_key": "SERVER_PUBLIC_KEY",
    "endpoint": "YOUR_SERVER_IP:51820"
  }'
```

## Configuration

### Backend Configuration

Edit `backend/.env`:

```env
SECRET_KEY=your-secret-key-here  # Change in production!
DATABASE_URL=sqlite:///./lokum_vpn.db
API_HOST=0.0.0.0
API_PORT=8000
VPN_MANAGEMENT_PATH=/var/lib/lokum-vpn
VPN_WG_CONFIG_PATH=/etc/wireguard
```

### Mobile App Configuration

Edit `mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';
```

For production, use environment variables:
```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.lokumvpn.com',
);
```

### VPN Server Configuration

WireGuard configuration is located at `/etc/wireguard/wg0.conf`

To view server status:
```bash
sudo wg show
```

## Docker Deployment

### Using Docker Compose

```bash
docker-compose up -d
```

This will start:
- Backend API (port 8000)
- PostgreSQL (optional, port 5432)
- Redis (optional, port 6379)

### Environment Variables for Docker

Create `.env` file in project root:

```env
SECRET_KEY=your-secret-key
POSTGRES_PASSWORD=your-db-password
DATABASE_URL=postgresql://lokum_vpn:your-db-password@postgres:5432/lokum_vpn
```

## Features Setup

### Ad Blocking

Ad blocking uses the StevenBlack hosts file. The service automatically:
- Downloads the latest blocklist on startup
- Updates every 24 hours (configurable)
- Blocks domains in real-time

To manually update:
```bash
curl -X POST "http://localhost:8000/api/v1/protection/update/adblock" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

### Malware Protection

Malware protection uses an extended hosts file including:
- Malware domains
- Phishing sites
- Fake news sites
- Gambling sites
- Adult content (optional)

To manually update:
```bash
curl -X POST "http://localhost:8000/api/v1/protection/update/malware" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

## API Usage Examples

### Register User

```bash
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "securepassword123"
  }'
```

### Login

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "securepassword123"
  }'
```

### Create VPN Configuration

```bash
curl -X POST "http://localhost:8000/api/v1/config/" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "server_id": 1,
    "dns_servers": "1.1.1.1,1.0.0.1"
  }'
```

### Connect to VPN

```bash
curl -X POST "http://localhost:8000/api/v1/config/connect" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "config_id": 1
  }'
```

## Troubleshooting

### Backend Issues

1. **Database errors**: Ensure database file is writable
   ```bash
   chmod 664 backend/lokum_vpn.db
   ```

2. **Port already in use**: Change `API_PORT` in `.env`

3. **Import errors**: Activate virtual environment
   ```bash
   source backend/venv/bin/activate
   ```

### Mobile App Issues

1. **Cannot connect to API**: Check `apiBaseUrl` in config
2. **CORS errors**: Ensure backend CORS settings allow your mobile app
3. **Build errors**: Run `flutter clean && flutter pub get`

### VPN Server Issues

1. **WireGuard not starting**: Check configuration syntax
   ```bash
   sudo wg-quick strip wg0
   ```

2. **No internet after connection**: Check IP forwarding
   ```bash
   sysctl net.ipv4.ip_forward
   # Should be 1
   ```

3. **Client can't connect**: Verify server public key matches backend configuration

## Security Considerations

1. **Change default SECRET_KEY** in production
2. **Use HTTPS** for API in production
3. **Implement rate limiting** for public endpoints
4. **Use strong passwords** for user accounts
5. **Keep WireGuard updated**: `sudo apt update && sudo apt upgrade wireguard`
6. **Monitor server logs** for suspicious activity
7. **Implement IP whitelisting** for admin endpoints

## Production Deployment

1. **Use PostgreSQL** instead of SQLite
2. **Set up reverse proxy** (Nginx/Apache) with SSL
3. **Enable HTTPS** with Let's Encrypt
4. **Configure firewall** rules
5. **Set up backup** system for database
6. **Monitor server** resources and logs
7. **Use process manager** (systemd, supervisor) for backend
8. **Implement logging** and monitoring

## Support

For issues and questions, refer to the main README.md or create an issue in the repository.





