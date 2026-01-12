# Testing on iPhone - Complete Guide

## Important: You Need Flutter on Your LOCAL Machine

**This server is for running the backend API only.**

The mobile app must be built and run from your **local macOS machine** (since iPhone development requires macOS/Xcode).

## Setup Your Local Machine

### Step 1: Install Flutter on Your Mac

If you don't have Flutter installed locally:

```bash
# On your Mac, install Flutter
# Visit: https://docs.flutter.dev/get-started/install/macos

# Quick install (using Homebrew)
brew install --cask flutter

# Or download from:
# https://docs.flutter.dev/get-started/install/macos

# Verify installation
flutter doctor
```

### Step 2: Copy Mobile App to Your Local Machine

From your **local Mac**, copy the mobile app:

```bash
# From your local Mac terminal
cd ~
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# Or if you have git access, clone the repo
```

### Step 3: Update API URL for Server

Edit `~/lokum-vpn-mobile/lib/config/config.dart`:

```dart
// Change line 6 to use your server IP
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://172.31.2.242:8000',  // Your server IP
);
```

### Step 4: Connect iPhone via USB

1. Connect iPhone to your Mac via USB cable
2. Unlock iPhone
3. Tap "Trust This Computer" if prompted
4. Enter iPhone passcode if requested

### Step 5: Verify iPhone Connection

From your **local Mac terminal**:

```bash
cd ~/lokum-vpn-mobile
flutter devices

# You should see your iPhone listed, for example:
# • iPhone 14 Pro (00008030-001...) • ios • com.apple.CoreSimulator...
```

### Step 6: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
```

### Step 7: Run on iPhone

```bash
# Option 1: Using environment variable
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Option 2: If you updated config.dart, just run:
flutter run
```

## Network Setup

### Ensure iPhone Can Access Server

Your iPhone needs to reach the server at `http://172.31.2.242:8000`.

**Test from iPhone Safari:**
1. Open Safari on iPhone
2. Go to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

**If it doesn't work:**
- iPhone and server must be on **same WiFi network**, OR
- Server must be **publicly accessible** (firewall allows port 8000)

## Quick Checklist

- [ ] Flutter installed on your Mac (not server)
- [ ] iPhone connected via USB to Mac
- [ ] iPhone trusted on Mac
- [ ] Mobile app copied to local Mac
- [ ] API URL updated to `http://172.31.2.242:8000`
- [ ] iPhone can access server (test in Safari)
- [ ] Run `flutter devices` - iPhone is listed
- [ ] Run `flutter run` - App installs on iPhone

## Troubleshooting

### "Flutter command not found" on Server

**This is normal!** Flutter should be on your **local Mac**, not the server.

The server only runs:
- Backend API (FastAPI/Python)
- Database
- VPN server services

### "iPhone not detected"

On your **local Mac**:
1. Unlock iPhone
2. Trust computer on iPhone
3. Enable Developer Mode (iOS 16+):
   - Settings → Privacy & Security → Developer Mode
4. Open Xcode → Settings → Accounts → Add Apple ID
5. Try: `flutter devices` again

### "Failed to connect to API"

1. **Test server from iPhone Safari:**
   - Go to: `http://172.31.2.242:8000/health`
   - Must see: `{"status":"healthy"}`

2. **Check network:**
   - iPhone and server on same WiFi
   - Or server has public IP with firewall open

3. **Verify backend is running:**
   - On server: `curl http://localhost:8000/health`

## Development Workflow

### Typical Workflow

1. **Server (this machine):**
   - Runs backend API
   - No Flutter needed here

2. **Your Local Mac:**
   - Has Flutter installed
   - Has Xcode installed
   - Builds and runs mobile app
   - Connects to server API

3. **iPhone:**
   - Connected via USB to Mac
   - Receives app installation
   - Runs app and connects to server API

## Summary

**You need to run Flutter commands from your LOCAL Mac, not this server.**

The server is working correctly - it's running your backend API. Now you need to:

1. Install Flutter on your Mac (if not already)
2. Copy mobile app to your Mac
3. Connect iPhone to Mac
4. Run `flutter run` from your Mac

The server will continue running the backend API that the mobile app connects to.


