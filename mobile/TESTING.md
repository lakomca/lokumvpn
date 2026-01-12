# Mobile App Testing Guide

## Prerequisites

### 1. Install Flutter

```bash
# Check if Flutter is installed
flutter --version

# If not installed, follow: https://docs.flutter.dev/get-started/install
```

### 2. Ensure Backend is Running

The backend API must be running and accessible:

```bash
cd /home/admin/lokum-vpn/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

**Important:** The backend must be accessible from your mobile device/emulator.

## Configuration

### Update API Base URL

The mobile app needs to connect to your backend server. Update the API URL based on your testing method:

#### Option 1: Testing on Android Emulator

Android emulator can access the host machine using `10.0.2.2`:

```dart
// In mobile/lib/config/config.dart
static const String apiBaseUrl = 'http://10.0.2.2:8000';
```

#### Option 2: Testing on iOS Simulator

iOS simulator can access localhost directly:

```dart
// In mobile/lib/config/config.dart
static const String apiBaseUrl = 'http://localhost:8000';
```

#### Option 3: Testing on Physical Device

Use your server's IP address (make sure firewall allows port 8000):

```dart
// In mobile/lib/config/config.dart
static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';
```

For the current server: `http://172.31.2.242:8000`

#### Option 4: Using Environment Variable (Recommended)

Update the config to use environment variable:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
```

Then run with:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Testing Methods

### Method 1: Android Emulator (Recommended for Development)

1. **Install Android Studio** (if not already installed)
   - Download from: https://developer.android.com/studio
   - Install Android SDK and create an emulator

2. **Start Android Emulator**
   ```bash
   # List available emulators
   flutter emulators
   
   # Launch emulator
   flutter emulators --launch <emulator_id>
   # Or use Android Studio's AVD Manager
   ```

3. **Update API URL** to `http://10.0.2.2:8000`

4. **Install Dependencies**
   ```bash
   cd mobile
   flutter pub get
   ```

5. **Run the App**
   ```bash
   flutter run
   # Or specify device
   flutter run -d <device_id>
   ```

### Method 2: iOS Simulator (macOS only)

1. **Install Xcode** (macOS required)
   - Available from Mac App Store

2. **Start iOS Simulator**
   ```bash
   open -a Simulator
   # Or
   flutter emulators --launch apple_ios_simulator
   ```

3. **Update API URL** to `http://localhost:8000`

4. **Run the App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

### Method 3: Physical Device (Best for Real Testing)

#### Android Device

1. **Enable Developer Options**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back → Developer Options → Enable USB Debugging

2. **Connect Device**
   ```bash
   # Connect via USB and verify
   flutter devices
   ```

3. **Update API URL** to your server IP: `http://172.31.2.242:8000`

4. **Ensure Backend is Accessible**
   - Check firewall allows port 8000
   - Verify backend is bound to `0.0.0.0` (not just `127.0.0.1`)

5. **Run the App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

#### iOS Device

1. **Connect iPhone/iPad via USB**

2. **Trust Computer** on device

3. **Update API URL** to your server IP

4. **Run the App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

## Quick Test Setup Script

Create a test configuration file:

```bash
# Create test config
cd mobile/lib/config
cp config.dart config.dart.bak
```

Update `config.dart`:
```dart
static const String apiBaseUrl = 'http://172.31.2.242:8000';  // Your server IP
```

## Testing Checklist

### Basic Functionality

- [ ] App launches successfully
- [ ] Splash screen displays
- [ ] Login/Register screens load
- [ ] Can create new account
- [ ] Can login with credentials
- [ ] Home screen displays
- [ ] Server list loads
- [ ] Can view server details
- [ ] Connection status displays

### VPN Functionality

- [ ] Can select a server
- [ ] Can create VPN configuration
- [ ] Can connect to VPN
- [ ] Connection status updates
- [ ] Can disconnect from VPN
- [ ] Statistics display correctly

### UI/UX Testing

- [ ] All screens navigate correctly
- [ ] Loading indicators show
- [ ] Error messages display properly
- [ ] Widgets render correctly
- [ ] Dark theme applies correctly
- [ ] Responsive design works

## Troubleshooting

### "Failed to connect to API"

1. **Check Backend is Running**
   ```bash
   curl http://localhost:8000/health
   ```

2. **Verify API URL**
   - Android Emulator: Use `10.0.2.2:8000`
   - iOS Simulator: Use `localhost:8000`
   - Physical Device: Use server IP (e.g., `172.31.2.242:8000`)

3. **Check Network/Firewall**
   ```bash
   # On server, ensure port 8000 is accessible
   sudo ufw allow 8000/tcp  # If using ufw
   # Or check iptables
   ```

4. **Verify CORS Settings**
   - Backend should allow your origin
   - Check `backend/app/core/config.py` CORS_ORIGINS

### "Flutter command not found"

Install Flutter:
```bash
# Follow official guide
# https://docs.flutter.dev/get-started/install/linux  # For Linux
# https://docs.flutter.dev/get-started/install/macos  # For macOS
# https://docs.flutter.dev/get-started/install/windows # For Windows
```

### "No devices found"

1. **Check Connected Devices**
   ```bash
   flutter devices
   ```

2. **For Android: Enable USB Debugging**
   - Settings → Developer Options → USB Debugging

3. **For iOS: Trust Computer**
   - Unlock device → Trust computer popup

### "Package not found" or "Dependencies error"

```bash
cd mobile
flutter clean
flutter pub get
```

### Hot Reload Not Working

```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
# Or stop and restart: Ctrl+C, then flutter run
```

## Testing Commands Quick Reference

```bash
# Check Flutter setup
flutter doctor

# Get dependencies
cd mobile && flutter pub get

# List available devices
flutter devices

# Run app
flutter run

# Run with specific device
flutter run -d <device_id>

# Run with API URL override
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Build APK (Android)
flutter build apk

# Build IPA (iOS - macOS only)
flutter build ios

# Run tests
flutter test

# Check for issues
flutter analyze
```

## Network Configuration for Physical Devices

If testing on physical device, ensure:

1. **Backend is accessible from device network**
   - Backend should bind to `0.0.0.0` (already configured)
   - Firewall allows port 8000
   - Device and server are on same network (or use public IP)

2. **Update API URL in config.dart**
   ```dart
   static const String apiBaseUrl = 'http://YOUR_SERVER_IP:8000';
   ```

3. **Test connectivity**
   ```bash
   # From device browser or using curl on device
   # Should return: {"status":"healthy"}
   http://YOUR_SERVER_IP:8000/health
   ```

## Next Steps After Testing

1. **Fix any bugs found**
2. **Improve error handling**
3. **Add more tests**
4. **Optimize performance**
5. **Prepare for production build**


