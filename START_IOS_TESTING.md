# Start iOS Simulator Testing - Quick Guide

## ⚠️ Important: iOS Simulator Requires macOS

**This server is Linux** - iOS Simulator only works on **macOS**.

You need to run the testing from **YOUR MAC**, not this server.

## ✅ What's Done on Server

- ✅ Backend server is running at `http://172.31.2.242:8000`
- ✅ Mobile app code is ready
- ✅ Setup script created for your Mac

## 🚀 Quick Start (On Your Mac)

### Option 1: Use Setup Script (Easiest)

1. **Copy setup script to your Mac:**
   ```bash
   scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/
   ```

2. **Run on your Mac:**
   ```bash
   chmod +x ~/setup_ios_simulator.sh
   ~/setup_ios_simulator.sh
   ```

   The script will:
   - Check/install Xcode Command Line Tools
   - Check/install Flutter
   - Check/install CocoaPods
   - Copy mobile app from server
   - Install dependencies
   - Start iOS Simulator
   - Show you how to run the app

### Option 2: Manual Setup

#### Step 1: Install Prerequisites on Mac

```bash
# Install Xcode (from Mac App Store)
# Then install command line tools:
xcode-select --install

# Install Flutter
brew install --cask flutter
# Or download from: https://docs.flutter.dev/get-started/install/macos

# Install CocoaPods
sudo gem install cocoapods
```

#### Step 2: Copy Mobile App

```bash
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
```

#### Step 3: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..
```

#### Step 4: Start iOS Simulator

```bash
open -a Simulator
# Or: flutter emulators --launch apple_ios_simulator
```

#### Step 5: Run App

```bash
cd ~/lokum-vpn-mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## 📋 Complete Command Sequence (Mac)

```bash
# 1. Copy setup script
scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/

# 2. Run setup (installs everything needed)
chmod +x ~/setup_ios_simulator.sh
~/setup_ios_simulator.sh

# 3. Run app (after setup completes)
cd ~/lokum-vpn-mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## 🌐 Server Information

- **Server IP:** `172.31.2.242`
- **Backend URL:** `http://172.31.2.242:8000`
- **Status:** ✅ Running

## ✅ Test Backend from Mac

Before running the app, test connectivity:

```bash
# From your Mac terminal
curl http://172.31.2.242:8000/health

# Should return: {"status":"healthy"}
```

## 📱 Test from iOS Simulator Safari

1. Open Safari in iOS Simulator
2. Go to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

## 🔧 Troubleshooting

### "Xcode not found"
- Install from Mac App Store
- Open Xcode and accept license
- Run: `xcode-select --install`

### "Flutter not found"
```bash
# Install via Homebrew
brew install --cask flutter

# Or download from: https://docs.flutter.dev/get-started/install/macos
```

### "CocoaPods not found"
```bash
sudo gem install cocoapods
```

### "Backend not accessible"
- Ensure backend is running on server
- Check firewall allows port 8000
- Verify Mac and server on same network

## 📚 Documentation

- Full guide: `IOS_SIMULATOR_TESTING.md`
- Quick start: `mobile/IOS_SIMULATOR_QUICK_START.md`

## Next Steps

1. **On your Mac:** Run the setup script or follow manual steps
2. **Start iOS Simulator**
3. **Run the app**
4. **Test all features**

The backend is ready and waiting! 🚀

