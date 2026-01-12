# Quick Mac Setup - No Script Needed

## Run These Commands on YOUR MAC

### Step 1: Install Prerequisites

```bash
# Install Flutter
brew install --cask flutter

# Install CocoaPods
sudo gem install cocoapods

# Verify
flutter doctor
```

### Step 2: Copy Mobile App

```bash
# This will prompt for password
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
```

### Step 3: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..
```

### Step 4: Start iOS Simulator

```bash
open -a Simulator
```

### Step 5: Run App

```bash
cd ~/lokum-vpn-mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## That's It! 🎉

The app should now run on iOS Simulator.

## Server Status

- ✅ Backend running at: http://172.31.2.242:8000
- ✅ Ready to accept connections

## Troubleshooting

**"scp: Permission denied"**
- Enter password when prompted
- Or set up SSH keys: `ssh-copy-id admin@172.31.2.242`

**"Flutter not found"**
- Install: `brew install --cask flutter`
- Or: https://docs.flutter.dev/get-started/install/macos

**"CocoaPods not found"**
- Install: `sudo gem install cocoapods`

