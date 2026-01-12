# Installing Flutter for Mobile Testing

## Quick Installation Guide

Since Flutter is not currently installed, here are the installation options:

## Option 1: Install Flutter on Linux (Current Server)

### Prerequisites

```bash
# Update system
sudo apt update

# Install required dependencies
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa
```

### Install Flutter

```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH (for current session)
export PATH="$PATH:$HOME/flutter/bin"

# Add to PATH permanently
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
flutter doctor
```

### Install Android Studio (for Android development)

```bash
# Download Android Studio
# Visit: https://developer.android.com/studio
# Or use snap:
sudo snap install android-studio --classic

# After installation, open Android Studio and:
# 1. Go through setup wizard
# 2. Install Android SDK
# 3. Install Android SDK Platform-Tools
# 4. Create an Android Virtual Device (AVD)
```

## Option 2: Test on a Different Machine (Recommended)

Since you're on a server, **testing on your local development machine** is often easier:

### On Your Local Machine (Windows/macOS/Linux)

1. **Install Flutter** on your local machine:
   - **Windows**: Download from https://docs.flutter.dev/get-started/install/windows
   - **macOS**: Download from https://docs.flutter.dev/get-started/install/macos
   - **Linux**: Follow Option 1 above

2. **Clone/Transfer the mobile app** to your local machine:
   ```bash
   # Option A: Clone from git (if using git)
   git clone <your-repo> lokum-vpn
   
   # Option B: Use SCP to transfer
   scp -r user@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
   ```

3. **Configure API URL** to point to your server:
   ```dart
   // In config.dart
   static const String apiBaseUrl = 'http://172.31.2.242:8000';
   ```

4. **Run on your local machine**:
   ```bash
   cd ~/lokum-vpn-mobile
   flutter pub get
   flutter run
   ```

## Option 3: Use CI/CD or Remote Testing Services

### Option A: GitHub Actions
- Push code to GitHub
- Use GitHub Actions with Flutter
- Test on cloud runners

### Option B: Firebase App Distribution
- Build APK/IPA
- Distribute to testers
- Test on physical devices

### Option C: Appetize.io (iOS/Android in browser)
- Upload APK/IPA
- Test in browser
- No local installation needed

## Option 4: Build APK/IPA on Server (No Flutter IDE needed)

You can build the APK without running the full Flutter development environment:

### For Android APK:

1. **Install Flutter SDK only** (without Android Studio):
   ```bash
   cd ~
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:$HOME/flutter/bin"
   flutter doctor --android-licenses
   ```

2. **Install Android SDK Command Line Tools**:
   ```bash
   # Download from: https://developer.android.com/studio#command-tools
   # Extract and set ANDROID_HOME
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
   ```

3. **Build APK**:
   ```bash
   cd /home/admin/lokum-vpn/mobile
   flutter build apk --release
   ```

4. **Transfer APK to device** and install:
   ```bash
   # Copy APK to device
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

## Quick Installation Script

Create a script to install Flutter:

```bash
#!/bin/bash
# install_flutter.sh

echo "Installing Flutter..."

# Install dependencies
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Download Flutter
cd ~
if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable
fi

# Add to PATH
export PATH="$PATH:$HOME/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc

# Verify
flutter doctor

echo "Flutter installed! Restart your terminal or run: source ~/.bashrc"
```

## Current Server Setup

Since you're on a server (likely headless), here are your best options:

### Recommended Approach:

1. **Build APK on server** (Option 4 above)
2. **Test on physical device** by:
   - Transferring APK to your phone
   - Installing and testing
   - Using the server IP for API connection

3. **Or develop locally** (Option 2):
   - Install Flutter on your local machine
   - Connect to server API at `http://172.31.2.242:8000`
   - Test with emulator/simulator on local machine

## Testing Without Flutter Installation

If you just want to verify the backend works with mobile:

1. **Use Postman/Insomnia** to test API endpoints
2. **Use curl** to test authentication
3. **Build APK once** and test manually
4. **Use web-based testing tools**

## Next Steps

Choose the approach that fits your workflow:

- **Quick testing**: Install Flutter locally, connect to server API
- **Production build**: Install Flutter on server, build APK/IPA
- **Continuous testing**: Set up CI/CD pipeline

Need help with any specific approach? Let me know!


