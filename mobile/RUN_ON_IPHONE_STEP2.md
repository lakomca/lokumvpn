# Step 2: Run App on iPhone - Detailed Guide

## ✅ Step 1 Complete: Server is Accessible

Your server at `http://3.29.239.219:8000` is now accessible from your iPhone.

## 📱 Step 2: Run App on iPhone

### Current Issue: Device Support Files

You're seeing an error: "Could not locate device support files"

This means Xcode needs device support files for your iPhone's iOS version.

### Fix Device Support Files

#### Option 1: Update Xcode (Recommended)

1. **Open Mac App Store**
2. **Check for Xcode updates**
3. **Update Xcode** (this will download latest device support files)
4. **After update**, restart Xcode

#### Option 2: Check Device in Xcode

1. **Open Xcode**
   ```bash
   open -a Xcode
   ```

2. **Go to Window → Devices and Simulators** (Shift+Cmd+2)

3. **Connect your iPhone** if not already connected

4. **Xcode will prompt** to download device support files if needed
   - Click "Download" when prompted
   - Wait for download to complete

#### Option 3: Install Command Line Tools

```bash
xcode-select --install
```

### Verify iPhone Connection

After fixing device support files:

```bash
flutter devices
```

Should show your iPhone, for example:
```
iPhone 14 Pro (mobile) • <device-id> • ios • iOS 16.0
```

### Ensure iPhone is Ready

1. **iPhone connected via USB**
2. **iPhone unlocked**
3. **Trust Computer**:
   - When prompted on iPhone, tap "Trust This Computer"
   - Enter passcode if requested
4. **Developer Mode** (iOS 16+):
   - Settings → Privacy & Security → Developer Mode
   - Toggle ON
   - Restart iPhone if prompted

### Run the App

Once device is detected:

#### Option 1: Direct Command

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
```

#### Option 2: Using Test Script

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_ios_device.sh
# Select option 1 (remote server)
# Answer 'y' to connectivity check (since server is working)
```

### First Time: Code Signing Setup

If this is your first time running on this iPhone, you may need to configure code signing:

1. **Open Xcode project:**
   ```bash
   cd /Users/aga/Desktop/proj/lokumvpn/mobile
   open ios/Runner.xcworkspace
   ```

2. **In Xcode:**
   - Select **Runner** in project navigator
   - Select **Runner** target
   - Go to **Signing & Capabilities** tab
   - Check **Automatically manage signing**
   - Select your **Team** (add Apple ID if needed)
   - Xcode will create development certificate

3. **Trust Certificate on iPhone** (after first install):
   - Settings → General → VPN & Device Management
   - Tap your developer certificate
   - Tap **Trust**

### Troubleshooting

#### "Device not detected"

1. **Check USB connection** - try different cable/port
2. **Unlock iPhone** and keep it unlocked
3. **Trust computer** when prompted
4. **Check in Xcode**: Window → Devices and Simulators
5. **Restart Xcode** if needed

#### "No code signing identity found"

1. Open Xcode project: `open ios/Runner.xcworkspace`
2. Select Runner → Signing & Capabilities
3. Add Apple ID (Xcode → Settings → Accounts)
4. Select Team
5. Enable "Automatically manage signing"

#### "Unable to install app"

1. **Trust certificate**:
   - Settings → General → VPN & Device Management
   - Tap certificate → Trust

2. **Check device restrictions**:
   - Settings → Screen Time → Content & Privacy Restrictions
   - Ensure app installation allowed

#### "Could not locate device support files"

- Update Xcode
- Check device in Xcode (it will download support files)
- Install command line tools: `xcode-select --install`

### Quick Reference

```bash
# Check devices
flutter devices

# Run app
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000

# Open Xcode (for code signing)
open ios/Runner.xcworkspace
```

### Next Steps After App Runs

1. ✅ App launches on iPhone
2. ✅ Test connectivity to server
3. ✅ Test all features
4. ✅ Check server connectivity works
5. ✅ Verify all screens work properly

## Summary

**Current Status:**
- ✅ Server accessible from iPhone
- ⚠️ Need to fix device support files
- ⏭️ Then run app on iPhone

**Action Items:**
1. Update Xcode or check device in Xcode
2. Verify iPhone is detected: `flutter devices`
3. Run app: `flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000`

