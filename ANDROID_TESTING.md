# Testing on Android - Complete Guide

## Overview

You can test the Lokum VPN mobile app on Android in two ways:
1. **Android Emulator** (on your local machine)
2. **Physical Android Device** (connected to your local machine)

## Prerequisites

### For Android Emulator:
- Flutter installed on your **local machine** (Windows/Mac/Linux)
- Android Studio installed
- Android SDK installed
- At least one Android Virtual Device (AVD) created

### For Physical Android Device:
- Flutter installed on your **local machine**
- Android device connected via USB
- USB Debugging enabled on device

## Important: Server Setup

**This server runs the backend API.** The mobile app runs on your local machine.

- **Server IP:** `172.31.2.242`
- **Backend URL:** `http://172.31.2.242:8000`
- **Backend Status:** Make sure it's running before testing

## Method 1: Testing on Android Emulator

### Step 1: Install Flutter on Your Local Machine

If not already installed:

**Windows:**
```bash
# Download from: https://docs.flutter.dev/get-started/install/windows
# Or use Chocolatey:
choco install flutter
```

**macOS:**
```bash
# Using Homebrew:
brew install --cask flutter

# Or download from: https://docs.flutter.dev/get-started/install/macos
```

**Linux:**
```bash
# Follow: https://docs.flutter.dev/get-started/install/linux
sudo snap install flutter --classic
```

### Step 2: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android Studio
3. Open Android Studio → More Actions → SDK Manager
4. Install:
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - At least one Android SDK Platform (e.g., Android 13)

### Step 3: Create Android Virtual Device (AVD)

1. Open Android Studio
2. Tools → Device Manager
3. Create Virtual Device
4. Choose a device (e.g., Pixel 5)
5. Select a system image (e.g., Android 13)
6. Finish and start the emulator

Or via command line:
```bash
flutter emulators --create --name test_android
flutter emulators --launch test_android
```

### Step 4: Copy Mobile App to Local Machine

From your **local machine**:

```bash
# Copy mobile app from server
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# Or if using git:
git clone <your-repo> lokum-vpn-mobile
```

### Step 5: Configure API URL for Android Emulator

**Important:** Android emulator uses special IP `10.0.2.2` to access host machine.

Edit `~/lokum-vpn-mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',  // For Android emulator
);
```

**OR** use environment variable when running:
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

**Note:** If your backend is on a different machine (not localhost), you'll need to:
1. Use your server's IP: `http://172.31.2.242:8000`
2. Ensure emulator can reach the server (same network or public IP)

### Step 6: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
```

### Step 7: Verify Emulator is Running

```bash
flutter devices

# Should show something like:
# • sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13
```

### Step 8: Run on Android Emulator

```bash
# Option 1: Using environment variable
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Option 2: If backend is on server (not localhost)
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Option 3: If you updated config.dart
flutter run
```

## Method 2: Testing on Physical Android Device

### Step 1: Enable Developer Options

On your Android device:

1. Go to **Settings → About Phone**
2. Tap **Build Number** 7 times
3. You'll see "You are now a developer!"

### Step 2: Enable USB Debugging

1. Go to **Settings → Developer Options**
2. Enable **USB Debugging**
3. Enable **Install via USB** (if available)

### Step 3: Connect Device via USB

1. Connect Android device to your computer via USB
2. On device, tap **Allow USB Debugging** when prompted
3. Check "Always allow from this computer" (optional)

### Step 4: Verify Device Connection

From your **local machine**:

```bash
# Check if device is detected
flutter devices

# Should show your device, for example:
# • SM G991B (mobile) • R58M30ABCDE • android-arm64 • Android 13
```

If device not detected:
```bash
# Check ADB connection
adb devices

# If unauthorized, check device and allow USB debugging
```

### Step 5: Configure API URL for Physical Device

For physical device, use your **server's IP address**:

Edit `~/lokum-vpn-mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://172.31.2.242:8000',  // Your server IP
);
```

**OR** use environment variable:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

### Step 6: Ensure Network Connectivity

**Important:** Your Android device must be able to reach the server.

**Test from Android device:**
1. Open Chrome on Android device
2. Go to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

**If it doesn't work:**
- Android device and server must be on **same WiFi network**, OR
- Server must be **publicly accessible** (firewall allows port 8000)

### Step 7: Run on Physical Device

```bash
cd ~/lokum-vpn-mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## API URL Configuration Summary

| Testing Method | API URL |
|---------------|---------|
| Android Emulator (backend on localhost) | `http://10.0.2.2:8000` |
| Android Emulator (backend on server) | `http://172.31.2.242:8000` |
| Physical Device (same network) | `http://172.31.2.242:8000` |
| Physical Device (different network) | `http://<public-ip>:8000` |

## Quick Start Commands

### For Android Emulator:

```bash
# 1. Start emulator
flutter emulators --launch <emulator_id>

# 2. Copy app (if not already)
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 3. Run
cd ~/lokum-vpn-mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### For Physical Device:

```bash
# 1. Connect device via USB
# 2. Enable USB debugging on device

# 3. Copy app (if not already)
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 4. Run
cd ~/lokum-vpn-mobile
flutter pub get
flutter devices  # Verify device
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Troubleshooting

### "No devices found"

**For Emulator:**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Or start from Android Studio
```

**For Physical Device:**
```bash
# Check ADB connection
adb devices

# If device shows "unauthorized":
# 1. Check device screen for "Allow USB debugging" prompt
# 2. Check "Always allow from this computer"
# 3. Revoke USB debugging authorizations and reconnect
```

### "Failed to connect to API"

1. **Test server from Android device:**
   - Open Chrome: `http://172.31.2.242:8000/health`
   - Must see: `{"status":"healthy"}`

2. **Check network:**
   - Android device and server on same WiFi
   - Or server has public IP with firewall open

3. **Verify backend is running:**
   ```bash
   # On server
   curl http://localhost:8000/health
   ```

4. **Check API URL:**
   - Emulator: Use `10.0.2.2:8000` if backend on localhost
   - Physical: Use server IP `172.31.2.242:8000`

### "Gradle build failed"

```bash
cd ~/lokum-vpn-mobile
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

### "Package errors"

```bash
cd ~/lokum-vpn-mobile
flutter clean
flutter pub get
flutter pub upgrade
```

## Testing Checklist

Once app runs on Android:

- [ ] App launches successfully
- [ ] Splash screen displays
- [ ] Can register new user
- [ ] Can login
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Can view server details
- [ ] Can create VPN configuration
- [ ] Connection status works
- [ ] Can connect/disconnect
- [ ] Statistics display correctly
- [ ] All screens navigate properly

## Building APK for Distribution

If you want to build an APK to install on devices:

```bash
cd ~/lokum-vpn-mobile

# Build release APK
flutter build apk --release

# APK will be at:
# build/app/outputs/flutter-apk/app-release.apk

# Install on connected device
flutter install
```

## Network Requirements

### For Android Emulator:
- If backend on **localhost**: Use `10.0.2.2:8000`
- If backend on **server**: Use `172.31.2.242:8000` (must be reachable)

### For Physical Device:
- Device and server on **same WiFi network**, OR
- Server has **public IP** with firewall allowing port 8000

## Next Steps

1. **Set up Flutter on your local machine**
2. **Copy mobile app to local machine**
3. **Start Android emulator OR connect physical device**
4. **Configure API URL** (emulator: `10.0.2.2:8000`, device: `172.31.2.242:8000`)
5. **Run the app**

Need help with any specific step?

