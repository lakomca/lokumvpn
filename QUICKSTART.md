# Lokum VPN - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites

First, install the required system package:

**Option 1 (Recommended):**
```bash
# Install python3.13-full (includes ensurepip)
sudo apt update
sudo apt install python3.13-full
```

**Option 2 (Fallback):**
```bash
# Install python3-pip (setup will work around missing ensurepip)
sudo apt update
sudo apt install python3-pip
```

**Note:** On Python 3.13, `ensurepip` may not be available even with `python3-pip`. The setup script will automatically work around this by installing pip manually using `get-pip.py`. For the best experience, install `python3.13-full`.

### Step 1: Setup Backend (2 minutes)

```bash
cd lokum-vpn/backend
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Create .env file
cat > .env <<EOF
SECRET_KEY=$(openssl rand -hex 32)
DATABASE_URL=sqlite:///./lokum_vpn.db
API_HOST=0.0.0.0
API_PORT=8000
VPN_MANAGEMENT_PATH=/var/lib/lokum-vpn
VPN_WG_CONFIG_PATH=/etc/wireguard
EOF

# Initialize database
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"

# Start server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Backend is now running at `http://localhost:8000`
API Docs: `http://localhost:8000/docs`

### Step 2: Create Admin User

Open `http://localhost:8000/docs` and use the `/auth/register` endpoint:

```json
{
  "username": "admin",
  "email": "admin@lokumvpn.com",
  "password": "securepassword123"
}
```

Then manually set `is_admin: true` in the database (SQLite) or use the API.

### Step 3: Add VPN Server

Use the `/servers/` endpoint to add your first server:

```json
{
  "name": "Test Server",
  "country": "United States",
  "country_code": "US",
  "region": "East",
  "hostname": "test.lokumvpn.com",
  "ip_address": "YOUR_SERVER_IP",
  "port": 51820,
  "public_key": "YOUR_WIREGUARD_PUBLIC_KEY",
  "endpoint": "YOUR_SERVER_IP:51820"
}
```

### Step 4: Setup VPN Server (if needed)

```bash
cd lokum-vpn/vpn-server
sudo chmod +x setup-wireguard.sh
sudo ./setup-wireguard.sh
```

Note the public key from the output and use it in Step 3.

### Step 5: Setup Mobile App

```bash
cd lokum-vpn/mobile

# Install dependencies
flutter pub get

# Update API URL in lib/config/config.dart
# Change: static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';

# Run on device
flutter run
```

### Step 6: Test Connection

1. Register/login in the mobile app
2. Browse servers in the app
3. Select a server and create configuration
4. Connect to VPN
5. Check connection status

## 🎯 Key Features

✅ **User Authentication** - Register, login, JWT tokens  
✅ **Server Management** - Add, list, manage VPN servers  
✅ **Configuration Generation** - Automatic WireGuard configs  
✅ **Connection Management** - Connect/disconnect VPN  
✅ **Ad Blocking** - Automatic ad and tracker blocking  
✅ **Malware Protection** - Blocks malicious domains  
✅ **Statistics** - Track data usage and connection history  
✅ **Mobile Apps** - Flutter apps for iOS and Android  

## 📱 Mobile App Features

- **Splash Screen** - Welcome screen with branding
- **Login/Register** - User authentication
- **Home Screen** - Connection status and quick stats
- **Server List** - Browse and select VPN servers
- **Statistics** - View usage and protection stats
- **Settings** - Account info and preferences

## 🔧 Configuration Files

### Backend
- `backend/.env` - Backend configuration
- `backend/app/core/config.py` - Configuration class

### Mobile
- `mobile/lib/config/config.dart` - App configuration (API URL)

### VPN Server
- `/etc/wireguard/wg0.conf` - WireGuard server config

## 📚 Next Steps

1. Read [SETUP.md](docs/SETUP.md) for detailed setup
2. Read [API.md](docs/API.md) for API documentation
3. Customize the mobile app UI
4. Add more VPN servers
5. Configure production settings

## 🐛 Troubleshooting

**Backend won't start:**
- Check if port 8000 is available: `lsof -i :8000`
- Check Python version: `python3 --version` (needs 3.11+)
- Activate virtual environment: `source venv/bin/activate`

**Mobile app can't connect:**
- Update `apiBaseUrl` in `lib/config/config.dart`
- Check backend is running: `curl http://localhost:8000/health`
- Check CORS settings in backend

**VPN won't connect:**
- Verify server public key matches backend
- Check WireGuard is running: `sudo wg show`
- Check IP forwarding: `sysctl net.ipv4.ip_forward`

## 📞 Need Help?

- Check [SETUP.md](docs/SETUP.md) for detailed instructions
- Review [API.md](docs/API.md) for API details
- Check logs in backend terminal
- Verify all services are running

---

**Lokum VPN** - Ready to use! 🎉

