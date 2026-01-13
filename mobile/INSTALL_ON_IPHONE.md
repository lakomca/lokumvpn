# Install App on Physical iPhone - Step by Step

## Prerequisites Checklist

- [ ] iPhone connected via USB cable
- [ ] iPhone unlocked
- [ ] iPhone trusted on Mac (tap "Trust This Computer" when prompted)
- [ ] Developer Mode enabled on iPhone (iOS 16+): Settings → Privacy & Security → Developer Mode → ON
- [ ] Xcode installed and updated
- [ ] Server accessible from iPhone (http://3.29.239.219:8000/health works)

## Step 1: Fix Device Detection Issue

You're seeing: "Could not locate device support files"

### Solution A: Check Device in Xcode (Fastest)

1. **Open Xcode:**
   ```bash
   open -a Xcode
   ```

2. **Go to Window → Devices and Simulators**
   - Press `Shift + Cmd + 2`
   - Or: Window menu → Devices and Simulators

3. **Connect your iPhone** via USB if not already connected

4. **Xcode will detect your iPhone** and may prompt:
   - "Device support files missing"
   - Click **"Download"** if prompted
   - Wait for download to complete

5. **Verify iPhone shows up** in the devices list

### Solution B: Update Xcode

If Solution A doesn't work:

1. **Open Mac App Store**
2. **Search for "Xcode"**
3. **Update to latest version** (if available)
4. **After update**, open Xcode and check devices again

### Solution C: Install Command Line Tools

```bash
xcode-select --install
```

## Step 2: Verify Device is Detected

After fixing device support files:

```bash
flutter devices
```

**Expected output:**
```
iPhone XX (mobile) • <device-id> • ios • iOS XX.X
```

If you still see errors, try:
- Disconnect and reconnect iPhone
- Restart Xcode
- Check iPhone is unlocked and trusted

## Step 3: Configure Code Signing (First Time Only)

If this is your first time installing on this iPhone:

### Option A: Using Xcode (Recommended)

1. **Open the iOS project:**
   ```bash
   cd /Users/aga/Desktop/proj/lokumvpn/mobile
   open ios/Runner.xcworkspace
   ```

2. **In Xcode:**
   - Select **Runner** in the left sidebar (project navigator)
   - Select **Runner** target (under TARGETS)
   - Click **Signing & Capabilities** tab
   - Check **"Automatically manage signing"**
   - Select your **Team** from dropdown
     - If no team: Click "+" and add your Apple ID
     - Xcode → Settings → Accounts → Add Apple ID
   - Xcode will automatically create signing certificate

3. **Close Xcode** (or leave it open)

### Option B: Let Flutter Handle It

Flutter can sometimes handle code signing automatically. Try running the app first - if it fails with signing errors, use Option A.

## Step 4: Install and Run the App

### Quick Command:

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
```

### What Happens:

1. Flutter builds the app
2. App installs on your iPhone
3. App launches automatically
4. You may see prompt on iPhone: "Untrusted Developer"
5. Go to Settings → General → VPN & Device Management
6. Tap your developer certificate
7. Tap **"Trust"**

### Alternative: Using Test Script

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_ios_device.sh
```

The script will guide you through the process.

## Step 5: Trust Developer Certificate (First Install)

After first installation, you'll need to trust the certificate:

1. **On your iPhone:**
   - Go to **Settings → General → VPN & Device Management** (or "Device Management" on older iOS)
   - You'll see your developer certificate
   - Tap on it
   - Tap **"Trust [Your Name]"**
   - Confirm by tapping **"Trust"** again

2. **Return to the app** - it should now launch properly

## Troubleshooting

### "Device not detected"

**Solutions:**
1. Check USB cable (try different cable)
2. Try different USB port
3. Unlock iPhone and keep unlocked
4. Trust computer on iPhone when prompted
5. Check in Xcode: Window → Devices and Simulators
6. Restart Xcode
7. Restart iPhone

### "No code signing identity found"

**Solutions:**
1. Open Xcode: `open ios/Runner.xcworkspace`
2. Select Runner → Signing & Capabilities
3. Add Apple ID: Xcode → Settings → Accounts
4. Select Team
5. Enable "Automatically manage signing"

### "Unable to install app"

**Solutions:**
1. Trust certificate: Settings → General → VPN & Device Management
2. Check device restrictions: Settings → Screen Time
3. Ensure iPhone is unlocked during installation
4. Try disconnecting and reconnecting iPhone

### "Could not locate device support files"

**Solutions:**
1. Open Xcode → Window → Devices and Simulators
2. Xcode will prompt to download support files
3. Update Xcode via App Store
4. Install command line tools: `xcode-select --install`

### "Failed to connect to API"

**Verify server is accessible:**
1. On iPhone, open Safari
2. Go to: `http://3.29.239.219:8000/health`
3. Should see: `{"status":"healthy"}`

If not:
- Check iPhone has internet (WiFi or cellular)
- Verify server is running
- Check firewall allows port 8000

## Complete Command Sequence

```bash
# 1. Navigate to mobile app
cd /Users/aga/Desktop/proj/lokumvpn/mobile

# 2. Verify dependencies are installed
flutter pub get

# 3. Check devices
flutter devices

# 4. Run the app
flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
```

## Quick Reference

| Step | Command/Action |
|------|----------------|
| Check devices | `flutter devices` |
| Open Xcode project | `open ios/Runner.xcworkspace` |
| Open Xcode | `open -a Xcode` |
| Run app | `flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000` |
| Test script | `./test_ios_device.sh` |

## After Successful Installation

✅ App is installed on iPhone
✅ App can connect to server at 3.29.239.219:8000
✅ You can disconnect USB (app stays installed)
✅ App will work over WiFi/cellular

**Note:** For future updates, reconnect iPhone and run `flutter run` again.

