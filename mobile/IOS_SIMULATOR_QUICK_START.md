# iOS Simulator - Quick Start

## Prerequisites (macOS only)

- ✅ macOS (required for iOS Simulator)
- ✅ Xcode installed (from Mac App Store)
- ✅ Flutter installed on your Mac

## Quick Setup

### Step 1: Start iOS Simulator

```bash
# Option 1: From Xcode
open -a Simulator

# Option 2: From Flutter
flutter emulators --launch apple_ios_simulator
```

### Step 2: Copy Mobile App

```bash
# From your Mac
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
```

### Step 3: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..  # Install CocoaPods dependencies
```

### Step 4: Run App

```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## API URL Configuration

- **Backend on server:** `http://172.31.2.242:8000`
- **Backend on localhost:** `http://localhost:8000`

## Test Connectivity

From iOS Simulator Safari:
- Go to: `http://172.31.2.242:8000/health`
- Should see: `{"status":"healthy"}`

## Troubleshooting

**Simulator not found:**
- Install Xcode from Mac App Store
- Run: `xcode-select --install`

**Build failed:**
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

See `IOS_SIMULATOR_TESTING.md` for detailed guide.

