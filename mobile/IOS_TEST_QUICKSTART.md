# iOS Simulator Testing - Quick Start Guide

## ✅ Current Status

- ✅ Flutter installed and working
- ✅ iOS platform files created
- ✅ Xcode available
- ✅ iOS Simulator available

## 🚀 Quick Run Commands

### Option 1: Using the Test Script (Recommended)

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_ios.sh
```

The script will:
- Check for iOS Simulator
- Ask you to configure the API URL
- Install dependencies
- Launch the app automatically

### Option 2: Manual Run

#### For Backend on Localhost:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

#### For Backend on Remote Server:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## 📱 API URL Configuration

| Scenario | API URL |
|----------|---------|
| Backend on localhost | `http://localhost:8000` |
| Backend on remote server | `http://172.31.2.242:8000` |

**Note:** iOS Simulator can access `localhost` directly, unlike Android emulator.

## 🔍 Verify Setup

### Check if simulator is running:
```bash
flutter devices
```

Should show:
```
iPhone XX (mobile) • <device-id> • ios • iOS XX.X
```

### Open Simulator manually:
```bash
# Option 1: Using Flutter
flutter emulators --launch apple_ios_simulator

# Option 2: Using Xcode
open -a Simulator
```

### Check if backend is accessible:
From your Mac terminal:
```bash
curl http://172.31.2.242:8000/health
```

Or if backend is on localhost:
```bash
curl http://localhost:8000/health
```

## 🛠️ Troubleshooting

### Simulator not showing up:
```bash
# List available simulators
flutter emulators

# Launch iOS Simulator
flutter emulators --launch apple_ios_simulator

# Or open directly
open -a Simulator
```

### Developer Mode Error:
If you see "enable Developer Mode in Settings":
1. Open iOS Simulator
2. Go to Settings → Privacy & Security
3. Enable Developer Mode
4. Restart the simulator

### CocoaPods Issues:
If you encounter CocoaPods errors:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile/ios

# Try with explicit encoding
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
pod install

# Or let Flutter handle it automatically
cd ..
flutter run
```

Flutter will automatically run `pod install` when needed.

### Build errors:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

### Xcode Command Line Tools:
If Xcode is not properly configured:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

## 📝 Testing Checklist

Once the app launches:
- [ ] App opens on iOS Simulator
- [ ] Splash screen displays
- [ ] Can register a new user
- [ ] Can login with credentials
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Can view server details
- [ ] Connection status works
- [ ] All navigation works
- [ ] App looks good on iOS

## 🎯 Next Steps

1. **Start the backend** (if not already running):
   ```bash
   # On the server or localhost
   cd backend
   source venv/bin/activate  # if using virtualenv
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

2. **Open iOS Simulator**:
   ```bash
   open -a Simulator
   # Or
   flutter emulators --launch apple_ios_simulator
   ```

3. **Run the app** using one of the commands above

4. **Test the features** using the checklist

## 💡 Tips

- iOS Simulator can access `localhost` directly (unlike Android emulator)
- Keep the simulator running between test runs for faster iteration
- Use `r` in the Flutter console to hot reload
- Use `R` to hot restart
- Press `q` to quit the app
- You can test on different iPhone models by selecting them in Simulator → Device

## 🔐 Permissions

iOS Simulator may require:
- **Developer Mode**: Settings → Privacy & Security → Developer Mode
- **Network permissions**: Usually granted automatically

## 📱 Simulator Features

- **Rotate device**: Device → Rotate Left/Right
- **Shake gesture**: Device → Shake
- **Screenshot**: File → Save Screen
- **Change device**: Device → Manage Devices

