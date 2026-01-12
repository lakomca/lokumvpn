# Testing on iOS Simulator - Complete Guide

## Overview

iOS Simulator allows you to test the Lokum VPN app on a virtual iPhone/iPad without needing a physical device.

## Prerequisites

### Required (macOS only):
- ✅ **macOS** (iOS Simulator only works on Mac)
- ✅ **Xcode** installed (from Mac App Store)
- ✅ **Flutter** installed on your Mac
- ✅ **Xcode Command Line Tools** installed

### Server Setup:
- ✅ Backend API running on server at `http://172.31.2.242:8000`

## Important Notes

- **iOS Simulator requires macOS** - Cannot run on Windows/Linux
- **Flutter runs on your local Mac**, not the server
- **Server runs the backend API** (this machine)
- **iOS Simulator can access localhost** directly (unlike Android emulator)

## Step-by-Step Setup

### Step 1: Install Xcode (if not installed)

1. Open **Mac App Store**
2. Search for "Xcode"
3. Click **Install** (large download, ~15GB)
4. After installation, open Xcode
5. Accept license agreement
6. Install additional components when prompted

### Step 2: Install Xcode Command Line Tools

```bash
# On your Mac terminal
xcode-select --install

# If already installed, verify:
xcode-select -p
```

### Step 3: Install Flutter on Mac

If not already installed:

**Using Homebrew (Recommended):**
```bash
brew install --cask flutter
```

**Or download manually:**
1. Visit: https://docs.flutter.dev/get-started/install/macos
2. Download Flutter SDK
3. Extract to `~/flutter`
4. Add to PATH:
   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

### Step 4: Verify Flutter Setup

```bash
# Check Flutter installation
flutter doctor

# Should show:
# ✓ Flutter
# ✓ Xcode
# ✓ iOS toolchain
```

### Step 5: Copy Mobile App to Your Mac

From your **Mac terminal**:

```bash
# Copy mobile app from server
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# Or if using git:
git clone <your-repo> lokum-vpn-mobile
```

### Step 6: Start iOS Simulator

**Option A: From Xcode**
1. Open Xcode
2. Xcode → Open Developer Tool → Simulator
3. Simulator will launch

**Option B: From Terminal**
```bash
# List available simulators
xcrun simctl list devices available

# Open Simulator app
open -a Simulator

# Or launch specific simulator
flutter emulators --launch apple_ios_simulator
```

**Option C: From Flutter**
```bash
# List available emulators
flutter emulators

# Launch iOS simulator
flutter emulators --launch apple_ios_simulator
```

### Step 7: Configure API URL

**Important:** iOS Simulator can access:
- `localhost` - if backend is on your Mac
- Server IP - if backend is on remote server

**For backend on server** (current setup):

Edit `~/lokum-vpn-mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://172.31.2.242:8000',  // Your server IP
);
```

**OR** use environment variable when running:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

**For backend on localhost** (if you run backend on Mac):
```dart
defaultValue: 'http://localhost:8000',
```

### Step 8: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
```

### Step 9: Verify Simulator is Running

```bash
flutter devices

# Should show something like:
# • iPhone 15 Pro (simulator) • 12345678-1234-1234-1234-123456789ABC • ios • com.apple.CoreSimulator.SimRuntime.iOS-17-0
```

### Step 10: Run App on iOS Simulator

```bash
cd ~/lokum-vpn-mobile

# Option 1: Using environment variable
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Option 2: If you updated config.dart
flutter run

# Option 3: Specify simulator explicitly
flutter run -d <simulator-id> --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Network Configuration

### iOS Simulator Network Access

iOS Simulator can access:
- ✅ `localhost` / `127.0.0.1` - Your Mac's localhost
- ✅ Local network IPs - If on same network
- ✅ Public IPs - If accessible

### Test Connectivity from Simulator

1. **Open Safari in iOS Simulator**
2. **Navigate to:** `http://172.31.2.242:8000/health`
3. **Should see:** `{"status":"healthy"}`

**If it doesn't work:**
- Mac and server must be on **same WiFi network**, OR
- Server must be **publicly accessible** (firewall allows port 8000)

## Quick Start Commands

```bash
# 1. Start iOS Simulator
open -a Simulator
# Or: flutter emulators --launch apple_ios_simulator

# 2. Copy app (if not already)
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 3. Install dependencies
cd ~/lokum-vpn-mobile
flutter pub get

# 4. Verify simulator
flutter devices

# 5. Run app
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## API URL Configuration Summary

| Backend Location | API URL for iOS Simulator |
|-----------------|---------------------------|
| On your Mac (localhost) | `http://localhost:8000` |
| On server (same network) | `http://172.31.2.242:8000` |
| On server (public IP) | `http://<public-ip>:8000` |

## Troubleshooting

### "iOS Simulator not found"

**Solution:**
1. Install Xcode from Mac App Store
2. Open Xcode → Accept license
3. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
4. Open Simulator:
   ```bash
   open -a Simulator
   ```

### "No devices found"

**Solution:**
```bash
# List available simulators
xcrun simctl list devices available

# Launch Simulator app
open -a Simulator

# Or use Flutter
flutter emulators --launch apple_ios_simulator
```

### "Failed to connect to API"

**Solution:**
1. **Test from Simulator Safari:**
   - Open Safari in iOS Simulator
   - Go to: `http://172.31.2.242:8000/health`
   - Must see: `{"status":"healthy"}`

2. **Check backend is running:**
   ```bash
   # On server
   curl http://localhost:8000/health
   ```

3. **Verify network:**
   - Mac and server on same WiFi
   - Or server has public IP with firewall open

### "Code signing error"

**Solution:**
1. Open Xcode
2. Xcode → Settings → Accounts
3. Add your Apple ID
4. Select your team
5. Trust the developer certificate

### "CocoaPods not installed"

**Solution:**
```bash
# Install CocoaPods
sudo gem install cocoapods

# Or using Homebrew
brew install cocoapods

# Navigate to iOS directory and install pods
cd ~/lokum-vpn-mobile/ios
pod install
cd ..
flutter run
```

### "Build failed"

**Solution:**
```bash
cd ~/lokum-vpn-mobile
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Testing Checklist

Once app runs on iOS Simulator:

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
- [ ] Dark theme applies correctly

## Simulator Features

### Useful Simulator Shortcuts:
- **⌘ + Shift + H** - Home button
- **⌘ + K** - Toggle keyboard
- **⌘ + ←/→** - Rotate device
- **⌘ + S** - Screenshot
- **Device → Shake** - Simulate shake gesture

### Change Simulator Device:
1. Simulator → File → Open Simulator
2. Choose different device (iPhone 14, iPhone 15 Pro, iPad, etc.)

## Complete Workflow

```bash
# 1. Start iOS Simulator
open -a Simulator

# 2. Copy app (first time only)
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 3. Navigate to app
cd ~/lokum-vpn-mobile

# 4. Install dependencies
flutter pub get

# 5. Install CocoaPods (if needed)
cd ios && pod install && cd ..

# 6. Verify simulator
flutter devices

# 7. Run app
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Network Requirements

### For iOS Simulator:
- If backend on **localhost**: Use `http://localhost:8000`
- If backend on **server**: Use `http://172.31.2.242:8000` (must be reachable)

### Testing Connectivity:
- Open Safari in iOS Simulator
- Navigate to: `http://172.31.2.242:8000/health`
- Should see: `{"status":"healthy"}`

## Next Steps

1. **Install Xcode** (if not already)
2. **Install Flutter** on your Mac
3. **Start iOS Simulator**
4. **Copy mobile app** to your Mac
5. **Configure API URL** to server IP
6. **Run the app**

Need help with any specific step?

