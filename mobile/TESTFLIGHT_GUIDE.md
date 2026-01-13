# TestFlight Distribution Guide

## Overview

TestFlight is Apple's official beta testing platform. It allows you to distribute your app to testers without requiring Developer Mode on devices.

## Requirements

- ✅ **Paid Apple Developer Account** ($99/year)
  - Sign up at: https://developer.apple.com/programs/
- ✅ Xcode installed on Mac
- ✅ App Store Connect access
- ✅ TestFlight app installed on iPhone (free from App Store)

## Advantages

- ✅ No Developer Mode needed on device
- ✅ Easy distribution to multiple testers
- ✅ Automatic updates
- ✅ Works on any iPhone/iPad
- ✅ Official Apple solution

## Disadvantages

- ❌ Requires paid Developer account ($99/year)
- ❌ First build takes 30-60 minutes to process
- ❌ Updates take 10-30 minutes to process
- ❌ Must re-upload for each new version

## Step-by-Step Process

### Step 1: Sign In to Apple Developer Account in Xcode

1. Open Xcode
2. Xcode → Settings (or Preferences)
3. Accounts tab
4. Click "+" button
5. Add your Apple ID (the one with Developer account)
6. Select your team

### Step 2: Build and Archive

**Option A: Using the Script**

```bash
cd mobile
./build_testflight.sh
```

**Option B: Manual Steps**

```bash
cd mobile

# Install dependencies
flutter pub get

# Build iOS release (without code signing)
flutter build ios --release --no-codesign

# Open Xcode
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **"Any iOS Device (arm64)"** from device selector (top toolbar)
2. **Product → Archive**
3. Wait for archive to complete (may take 5-10 minutes)

### Step 3: Upload to App Store Connect

After archive completes, Xcode Organizer window opens:

1. Click **"Distribute App"**
2. Select **"App Store Connect"**
3. Click **"Next"**
4. Select **"Upload"**
5. Click **"Next"**
6. Select distribution options (usually defaults are fine)
7. Review signing (should auto-select your team)
8. Click **"Upload"**
9. Wait for upload (5-15 minutes)

### Step 4: Configure in App Store Connect

1. Go to: https://appstoreconnect.apple.com
2. Sign in with your Apple Developer account
3. Click **"Apps"**
4. Find your app (or create new app if first time):
   - Click **"+"** to create new app
   - Fill in app information:
     - Name: "Lokum VPN"
     - Primary Language: English
     - Bundle ID: com.example.lokumVpn (or create new)
     - SKU: lokum-vpn-001
   - Click **"Create"**

5. Go to **"TestFlight"** tab
6. Wait for build to process (10-60 minutes)
   - Status: "Processing" → "Ready to Submit"
7. Once ready, add testers:
   - **Internal Testing**: Up to 100 testers (App Store Connect users)
   - **External Testing**: Up to 10,000 testers (requires App Review first time)

### Step 5: Install on iPhone

1. Install **TestFlight** app from App Store (if not installed)
2. Open TestFlight app
3. If internal tester:
   - App appears automatically
   - Tap **"Install"**
4. If external tester:
   - Accept invitation email
   - Or use public link (if configured)
   - Tap **"Install"**
5. App installs and appears on home screen

### Step 6: Trust the App (First Install)

After first installation:
1. Settings → General → VPN & Device Management
2. Tap your developer certificate
3. Tap **"Trust"**

## Updating the App

To push an update:

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # Format: major.minor.patch+build
   ```

2. Repeat Steps 2-3 (Build, Archive, Upload)

3. New build appears in TestFlight (10-30 minutes processing)

4. Testers get notification in TestFlight app

5. Tap **"Update"** in TestFlight

## Troubleshooting

### "No accounts with App Store Connect access"

- Sign in to Apple Developer account in Xcode
- Xcode → Settings → Accounts → Add Apple ID
- Make sure you have App Store Connect access

### "Bundle ID not found"

- Create new App in App Store Connect
- Use the Bundle ID from Xcode project
- Or change Bundle ID in Xcode to match existing app

### Build fails with code signing errors

- Xcode → Select project → Signing & Capabilities
- Select your Team
- Check "Automatically manage signing"
- Xcode will create/select certificates automatically

### "Processing" takes too long

- First build: 30-60 minutes is normal
- Updates: 10-30 minutes is normal
- Check email for any issues
- Check App Store Connect for error messages

### App doesn't appear in TestFlight

- Make sure build status is "Ready to Submit"
- Check you added yourself as tester (Internal Testing)
- Refresh TestFlight app (pull down to refresh)
- Wait a few more minutes (processing can be slow)

## Quick Reference

```bash
# Build for TestFlight
cd mobile
./build_testflight.sh

# Or manually:
flutter pub get
flutter build ios --release --no-codesign
open ios/Runner.xcworkspace

# In Xcode:
# Product → Archive → Distribute App → App Store Connect → Upload
```

## Useful Links

- App Store Connect: https://appstoreconnect.apple.com
- Apple Developer: https://developer.apple.com
- TestFlight Documentation: https://developer.apple.com/testflight/

