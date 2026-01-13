# Physical iOS Device Testing - Quick Start Guide

## ✅ Current Status

- ✅ Flutter installed and working
- ✅ iOS platform files created
- ✅ Xcode available
- ✅ Physical iOS device detected (needs Developer Mode)

## ⚠️ IMPORTANT: Enable Developer Mode

Your iPhone needs Developer Mode enabled:

1. **On your iPhone:**
   - Go to **Settings → Privacy & Security**
   - Scroll down to **Developer Mode**
   - Toggle **Developer Mode** ON
   - Restart your iPhone when prompted

2. **After restart:**
   - You may see a prompt to enable Developer Mode - tap **Turn On**
   - Enter your passcode if requested

3. **Verify device is detected:**
   ```bash
   flutter devices
   ```
   Should show your iPhone (not just an error)

## 🚀 Quick Run Commands

### Option 1: Using the Test Script (Recommended)

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_ios_device.sh
```

The script will:
- Check for connected device
- Guide you through API URL configuration
- Check code signing setup
- Launch the app automatically

### Option 2: Manual Run

#### For Backend on Remote Server:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

#### For Backend on Localhost (same Mac):
```bash
# First, find your Mac's IP address
ipconfig getifaddr en0  # or en1

# Then use that IP (e.g., 192.168.1.100)
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000
```

## 📱 API URL Configuration

| Scenario | API URL |
|----------|---------|
| Backend on remote server | `http://172.31.2.242:8000` |
| Backend on localhost (same Mac) | `http://<your-mac-ip>:8000` |
| Backend on different network | `http://<public-ip>:8000` |

**Important:** Physical devices cannot use `localhost` - they need the actual IP address.

## 🔐 Code Signing Setup

Before running, you may need to configure code signing:

1. **Open Xcode project:**
   ```bash
   cd /Users/aga/Desktop/proj/lokumvpn/mobile
   open ios/Runner.xcworkspace
   ```

2. **In Xcode:**
   - Select **Runner** in the project navigator (left sidebar)
   - Select **Runner** target (under TARGETS)
   - Go to **Signing & Capabilities** tab
   - Check **Automatically manage signing**
   - Select your **Team** (add Apple ID if needed)
   - Xcode will automatically create a development certificate

3. **Trust Developer Certificate on iPhone:**
   - After first install, go to **Settings → General → VPN & Device Management**
   - Tap on your developer certificate
   - Tap **Trust**

## 🔍 Verify Setup

### Check if device is connected:
```bash
flutter devices
```

Should show:
```
iPhone XX (mobile) • <device-id> • ios • iOS XX.X
```

### Check if backend is accessible from iPhone:
1. **On your iPhone**, open **Safari**
2. Navigate to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

**If it doesn't work:**
- iPhone and server must be on **same WiFi network**, OR
- Server must be **publicly accessible** (firewall allows port 8000)

## 🛠️ Troubleshooting

### "Device not detected"

1. **Check USB connection:**
   - Use a data cable (not just charging cable)
   - Try a different USB port
   - Try a different cable

2. **Trust computer:**
   - Unlock iPhone
   - When prompted, tap **Trust This Computer**
   - Enter passcode

3. **Enable Developer Mode:**
   - Settings → Privacy & Security → Developer Mode → ON
   - Restart iPhone

4. **Check in Xcode:**
   ```bash
   open -a Xcode
   # Window → Devices and Simulators
   # Should see your iPhone listed
   ```

### "No code signing identity found"

1. **Open Xcode:**
   ```bash
   cd /Users/aga/Desktop/proj/lokumvpn/mobile
   open ios/Runner.xcworkspace
   ```

2. **Configure signing:**
   - Select Runner → Signing & Capabilities
   - Add your Apple ID (Xcode → Settings → Accounts)
   - Select your Team
   - Check "Automatically manage signing"

### "Failed to connect to API"

1. **Test from iPhone Safari:**
   - Go to: `http://172.31.2.242:8000/health`
   - Must see: `{"status":"healthy"}`

2. **Check network:**
   - iPhone and server on same WiFi
   - Or server has public IP with firewall open

3. **Verify backend is running:**
   ```bash
   # On server
   curl http://localhost:8000/health
   ```

4. **Use correct IP:**
   - Physical devices cannot use `localhost`
   - Use actual IP address (e.g., `192.168.1.100` or `172.31.2.242`)

### "Unable to install app"

1. **Trust developer certificate:**
   - Settings → General → VPN & Device Management
   - Tap your developer certificate
   - Tap **Trust**

2. **Check device restrictions:**
   - Settings → Screen Time → Content & Privacy Restrictions
   - Ensure app installation is allowed

### "Developer Mode error"

If you see: `To use iPhone for development, enable Developer Mode`

1. **On iPhone:**
   - Settings → Privacy & Security → Developer Mode → ON
   - Restart iPhone
   - When prompted after restart, tap **Turn On**

## 📝 Testing Checklist

Once the app launches:
- [ ] App opens on iPhone
- [ ] Splash screen displays
- [ ] Can register a new user
- [ ] Can login with credentials
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Can view server details
- [ ] Connection status works
- [ ] All navigation works
- [ ] App looks good on iPhone

## 🎯 Step-by-Step First Time Setup

### 1. Connect iPhone
- Connect via USB cable
- Unlock iPhone
- Tap **Trust This Computer**

### 2. Enable Developer Mode
- Settings → Privacy & Security → Developer Mode → ON
- Restart iPhone
- Tap **Turn On** when prompted

### 3. Verify Connection
```bash
flutter devices
# Should show your iPhone
```

### 4. Configure Code Signing
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
open ios/Runner.xcworkspace
```
- In Xcode: Select Runner → Signing & Capabilities
- Add Apple ID if needed
- Select Team
- Check "Automatically manage signing"

### 5. Test Server Connectivity
- On iPhone Safari: `http://172.31.2.242:8000/health`
- Should see: `{"status":"healthy"}`

### 6. Run the App
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_ios_device.sh
# OR
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

### 7. Trust Developer Certificate (First Time)
- After first install
- Settings → General → VPN & Device Management
- Tap certificate → Trust

## 💡 Tips

- **Keep iPhone unlocked** during development
- **Use WiFi** for better network connectivity
- **Keep USB connected** for faster builds
- Use `r` in Flutter console for hot reload
- Use `R` for hot restart
- Press `q` to quit the app

## 🌐 Network Requirements

### Same WiFi Network (Recommended)
- iPhone and server on same WiFi
- Use server's local IP: `172.31.2.242:8000`
- Works immediately (if firewall allows)

### Different Networks
- Server must have public IP
- Firewall must allow port 8000
- Use server's public IP address

### Cellular Data
- Server must have public IP
- Firewall configured
- May have higher latency

## 📱 Device Requirements

- **iOS 13.0 or later** (for Flutter support)
- **USB connection** for initial setup
- **Developer Mode enabled** (iOS 16+)
- **Trusted computer** on device

## 🔄 After First Success

Once the app runs successfully:
- You can disconnect USB (app stays installed)
- Use WiFi for network connectivity
- Reconnect USB when you need to update the app

## 🚨 Common First-Time Issues

1. **Developer Mode not enabled** → Enable in Settings
2. **Code signing not configured** → Set up in Xcode
3. **Certificate not trusted** → Trust in Settings
4. **Server not accessible** → Check network/firewall
5. **Wrong IP address** → Use actual IP, not localhost

Need help? Check the troubleshooting section above!

