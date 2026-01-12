# Lokum VPN

A full-featured VPN service with mobile apps and backend infrastructure, emphasizing privacy, security, and bypassing restrictions.

## Features

- **Encrypted Connections**: WireGuard-based VPN with IP hiding and data protection
- **Multi-Country Servers**: Support for servers in 40+ countries for accessing geo-blocked content
- **Ad & Malware Blocking**: Built-in protection against ads, malware, and phishing
- **Unlimited Bandwidth**: No speed limits or data caps
- **High Anonymity**: No-logs policy with IPv4/IPv6 support
- **Easy Connection Management**: User-friendly Flutter mobile apps for iOS and Android
- **Server Selection**: Choose from multiple servers across different countries
- **Connection Statistics**: Track your data usage and connection history
- **Protection Status**: Monitor ad blocking and malware protection in real-time

## Project Structure

```
lokum-vpn/
├── backend/              # Python FastAPI backend
│   ├── app/             # Application code
│   │   ├── routers/     # API route handlers
│   │   ├── models/      # Database models
│   │   ├── schemas/     # Pydantic schemas
│   │   ├── services/    # Business logic services
│   │   ├── utils/       # Utility functions
│   │   └── core/        # Core configuration
│   ├── main.py          # FastAPI application entry point
│   └── requirements.txt # Python dependencies
├── mobile/              # Flutter mobile apps (iOS & Android)
│   ├── lib/            # Dart source code
│   │   ├── models/     # Data models
│   │   ├── services/   # API service
│   │   ├── providers/  # State management
│   │   ├── screens/    # UI screens
│   │   └── config/     # App configuration
│   └── pubspec.yaml    # Flutter dependencies
├── vpn-server/          # VPN server configuration & scripts
│   ├── setup-wireguard.sh    # WireGuard server setup
│   ├── add-client.sh         # Add client script
│   └── remove-client.sh      # Remove client script
├── docs/                # Documentation
│   ├── SETUP.md        # Setup guide
│   └── API.md          # API documentation
├── docker-compose.yml   # Docker orchestration
└── setup.sh            # Automated setup script
```

## Quick Start

### Prerequisites

- Python 3.11+ (for backend)
- Flutter 3.0+ (for mobile apps)
- WireGuard (for VPN server - Ubuntu/Debian)
- Docker & Docker Compose (optional)

### Automated Setup

**Important:** Before running setup, ensure prerequisites are installed:

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

**Note:** On Python 3.13, `ensurepip` may not be available even with `python3-pip`. The setup script will automatically handle this by creating venv with `--without-pip` and installing pip manually.

Then run the automated setup script:

```bash
cd lokum-vpn
chmod +x setup.sh check-prerequisites.sh

# Optional: Check prerequisites first
./check-prerequisites.sh

# Run setup
./setup.sh
```

The setup script will:
- Check prerequisites
- Create Python virtual environment
- Install backend dependencies
- Generate secure `.env` configuration
- Initialize database
- Install Flutter dependencies (if Flutter is installed)

### Manual Setup

#### Backend Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Create .env file (copy from .env.example and configure)
cp .env.example .env
# Edit .env with your settings

# Initialize database
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"

# Run the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- API: `http://localhost:8000`
- Interactive Docs (Swagger): `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

#### Mobile App Setup

```bash
cd mobile
flutter pub get

# Update API base URL in lib/config/config.dart
# Change: static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';

# Run on device/emulator
flutter run
```

#### VPN Server Setup

On your VPN server (Ubuntu/Debian):

```bash
cd vpn-server
sudo chmod +x setup-wireguard.sh
sudo ./setup-wireguard.sh
```

After setup, note:
- Server Public Key
- Server IP Address
- Server Port (default: 51820)

Then add the server to your backend using the API (see API documentation).

## Docker Deployment

Using Docker Compose:

```bash
docker-compose up -d
```

This starts:
- Backend API (port 8000)
- PostgreSQL (optional, port 5432)
- Redis (optional, port 6379)

## Configuration

### Backend Configuration

Edit `backend/.env`:

```env
SECRET_KEY=your-secret-key-here  # IMPORTANT: Change in production!
DATABASE_URL=sqlite:///./lokum_vpn.db
API_HOST=0.0.0.0
API_PORT=8000
VPN_MANAGEMENT_PATH=/var/lib/lokum-vpn
VPN_WG_CONFIG_PATH=/etc/wireguard
```

### Mobile App Configuration

Update `mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';
```

For production, use environment variables during build.

## Features Overview

### VPN Connection Management

- Create configurations for multiple servers
- Connect/disconnect with one tap
- Real-time connection status
- Session statistics (data usage, duration)

### Server Selection

- Browse servers by country
- Filter by region
- View server status (load, latency, users)
- Automatic configuration generation

### Ad Blocking

- Blocks ads and trackers automatically
- Uses StevenBlack hosts file
- Updates daily
- Over 50,000 blocked domains

### Malware Protection

- Blocks malware and phishing sites
- Extended protection list
- Real-time domain checking
- Automatic updates

### Statistics & Analytics

- Total connections count
- Data usage (MB/GB)
- Connection time
- Daily statistics
- Protection stats

## API Documentation

Full API documentation is available at:
- Interactive docs: `http://localhost:8000/docs` (when backend is running)
- See `docs/API.md` for detailed endpoint documentation

## Security Features

- **No-Logs Policy**: No user activity logging
- **Encrypted Connections**: WireGuard encryption (state-of-the-art)
- **Secure Authentication**: JWT tokens with secure password hashing
- **IP Hiding**: Hide your real IP address
- **DNS Leak Protection**: Secure DNS servers
- **Kill Switch**: Automatic disconnect on connection failure (implement in mobile app)

## Development

### Backend Development

```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload
```

### Mobile App Development

```bash
cd mobile
flutter run
```

### Running Tests

```bash
# Backend tests (if available)
cd backend
pytest

# Mobile app tests
cd mobile
flutter test
```

## Production Deployment

1. **Change SECRET_KEY** in production environment
2. **Use PostgreSQL** instead of SQLite
3. **Set up HTTPS** with reverse proxy (Nginx/Apache)
4. **Configure firewall** rules
5. **Enable rate limiting** for API endpoints
6. **Set up monitoring** and logging
7. **Implement backup** system for database
8. **Use process manager** (systemd/supervisor) for backend

## Troubleshooting

### Backend Issues

- **Database errors**: Ensure database file is writable
- **Port already in use**: Change `API_PORT` in `.env`
- **Import errors**: Activate virtual environment

### Mobile App Issues

- **Cannot connect to API**: Check `apiBaseUrl` in config
- **CORS errors**: Ensure backend CORS settings allow mobile app
- **Build errors**: Run `flutter clean && flutter pub get`

### VPN Server Issues

- **WireGuard not starting**: Check configuration syntax
- **No internet after connection**: Check IP forwarding (`sysctl net.ipv4.ip_forward`)
- **Client can't connect**: Verify server public key matches backend

See `docs/SETUP.md` for detailed troubleshooting guide.

## Documentation

- [Setup Guide](docs/SETUP.md) - Detailed setup instructions
- [API Documentation](docs/API.md) - Complete API reference
- [WireGuard Documentation](https://www.wireguard.com/) - WireGuard protocol docs

## License

Private use - Personal/small group scope

## Contributing

This is a personal/small group project. For contributions, please coordinate with the project maintainer.

## Support

For issues and questions:
1. Check the documentation in `docs/` directory
2. Review troubleshooting section
3. Check API documentation at `/docs` endpoint when backend is running

## Acknowledgments

- WireGuard for the excellent VPN protocol
- StevenBlack for the hosts file blocklists
- FastAPI for the excellent Python web framework
- Flutter for cross-platform mobile development

---

**Lokum VPN** - Privacy, Security, Freedom

