# Testing on iPhone - Quick Guide

## Prerequisites

1. **iPhone connected via USB** ✓
2. **Flutter installed on your local machine**
3. **Xcode installed** (macOS required for iOS development)
4. **Backend running on server** at `http://172.31.2.242:8000`

## Quick Setup Steps

### Step 1: Update API URL

The iPhone needs to connect to your server. Update the API URL:

**Option A: Use environment variable (Recommended)**

Run with:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

**Option B: Update config.dart directly**

Edit `mobile/lib/config/config.dart`:
```dart
static const String apiBaseUrl = 'http://172.31.2.242:8000';
```

**Important:** Replace `172.31.2.242` with your actual server IP if different.

### Step 2: Verify iPhone Connection

From your local machine (with Flutter installed):

```bash
# Check if iPhone is detected
flutter devices

# You should see your iPhone listed
```

### Step 3: Trust Computer (if prompted)

1. Unlock your iPhone
2. If prompted, tap "Trust This Computer"
3. Enter your iPhone passcode if requested

### Step 4: Install Dependencies

```bash
cd /path/to/lokum-vpn/mobile
flutter pub get
```

### Step 5: Run on iPhone

```bash
# Run with server IP
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000 -d <device_id>

# Or just run (Flutter will auto-select iPhone if it's the only device)
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Network Requirements

### For iPhone to Access Server

Your iPhone needs to be on the **same network** as the server, OR:

1. **Same WiFi network** (recommended)
   - iPhone connects to same WiFi as server
   - Use server's local IP: `http://172.31.2.242:8000`

2. **Different network** (requires configuration)
   - Server IP must be publicly accessible
   - Firewall must allow port 8000
   - Use server's public IP

3. **Cellular data** (requires public IP)
   - Server must have public IP
   - Firewall rules configured
   - Use server's public IP

### Verify Connectivity

Test from your iPhone:

1. **Open Safari on iPhone**
2. **Navigate to:** `http://172.31.2.242:8000/health`
3. **Should see:** `{"status":"healthy"}`

If you see an error:
- iPhone and server are not on same network
- Firewall is blocking port 8000
- Server IP is incorrect

## Common Issues

### "iPhone not detected"

**Solution:**
1. Unlock iPhone
2. Trust computer when prompted
3. Enable Developer Mode (iOS 16+):
   - Settings → Privacy & Security → Developer Mode → Enable
4. Restart Xcode/Flutter if needed

### "Failed to connect to API"

**Solution:**
1. Verify server is accessible from iPhone:
   - Open Safari: `http://172.31.2.242:8000/health`
2. Check iPhone and server are on same network
3. Verify backend is running:
   ```bash
   # On server
   curl http://localhost:8000/health
   ```
4. Check firewall allows port 8000

### "No code signing identity found"

**Solution:**
1. Open Xcode
2. Go to Xcode → Settings → Accounts
3. Add your Apple ID
4. Select your team
5. Trust the developer certificate

### "Unable to install app"

**Solution:**
1. On iPhone: Settings → General → VPN & Device Management
2. Trust your developer certificate
3. Try installing again

## Troubleshooting Steps

### 1. Check Device Connection

```bash
flutter devices
# Should list your iPhone
```

### 2. Check Server Accessibility

From iPhone Safari:
- Go to: `http://172.31.2.242:8000/health`
- Should see: `{"status":"healthy"}`

### 3. Check Backend Status

On server:
```bash
cd /home/admin/lokum-vpn/backend
source venv/bin/activate
# Backend should be running
curl http://localhost:8000/health
```

### 4. Verify API URL

Make sure config.dart has correct IP:
```dart
static const String apiBaseUrl = 'http://172.31.2.242:8000';
```

Or use environment variable:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Testing Checklist

Once app runs on iPhone:

- [ ] App launches successfully
- [ ] Splash screen displays
- [ ] Can register new user
- [ ] Can login
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Connection status works
- [ ] All features functional

## Network Configuration Tips

### Same WiFi Network (Easiest)

1. Connect iPhone to same WiFi as server
2. Use server's local IP: `172.31.2.242`
3. Works immediately (if firewall allows)

### Different Networks

1. Use server's public IP address
2. Configure firewall to allow port 8000:
   ```bash
   sudo ufw allow 8000/tcp
   ```
3. Update API URL to public IP

### Using ngrok (For Testing Across Networks)

If server is behind NAT, use ngrok:

```bash
# On server
ngrok http 8000
# Use ngrok URL in config
```

## Quick Command Reference

```bash
# List devices
flutter devices

# Run on iPhone
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Build for iOS
flutter build ios

# Clean build
flutter clean && flutter pub get
```

## Next Steps After App Runs

1. Test all features
2. Check connection status
3. Test VPN functionality
4. Verify statistics
5. Check all screens

Need help with any specific step?


