# Android Testing - Quick Start

## Server Information

- **Server IP:** `172.31.2.242`
- **Backend URL:** `http://172.31.2.242:8000`
- **Status:** Backend must be running before testing

## Quick Setup (3 Steps)

### Step 1: On Your Local Machine

Install Flutter and Android Studio (if not already):
- Flutter: https://docs.flutter.dev/get-started/install
- Android Studio: https://developer.android.com/studio

### Step 2: Copy Mobile App

```bash
# From your local machine
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
```

### Step 3: Run on Android

**For Android Emulator:**
```bash
cd ~/lokum-vpn-mobile
flutter pub get
flutter emulators --launch <emulator_id>  # Or start from Android Studio
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

**For Physical Android Device:**
```bash
cd ~/lokum-vpn-mobile
flutter pub get
# Connect device via USB, enable USB debugging
flutter devices  # Verify device
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## API URL Configuration

- **Android Emulator:** `http://10.0.2.2:8000` (if backend on localhost)
- **Physical Device:** `http://172.31.2.242:8000` (your server IP)

## Important Notes

1. **Flutter runs on your LOCAL machine**, not the server
2. **Server runs the backend API** (make sure it's running)
3. **Android device must be able to reach server** (same WiFi or public IP)

## Troubleshooting

**Device not found:**
- Emulator: Start from Android Studio or `flutter emulators --launch`
- Physical: Enable USB debugging in Developer Options

**Can't connect to API:**
- Test from Android Chrome: `http://172.31.2.242:8000/health`
- Ensure device and server on same network

See `ANDROID_TESTING.md` for detailed guide.

