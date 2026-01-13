# Installing on iOS Device with macOS 12.7.6 & Xcode 14.2

## Your Setup
- **macOS:** 12.7.6 (Monterey)
- **Xcode:** 14.2 (supports iOS 16.2 SDK)
- **Limitation:** Xcode 14.2 only supports iOS devices up to iOS 16.x

## The Problem
- Your iPhone is likely on iOS 18.3.1 (too new for Xcode 14.2)
- Direct USB installation fails with "device support files" error
- Xcode can't install directly to devices with iOS 17+ or 18+

## Solutions

### Option 1: Sideloading with AltStore (Recommended)

**Works with:** Any Xcode version, any iOS version  
**Requires:** Free Apple ID (apps expire after 7 days)  
**Best for:** Testing without Developer account

#### Step 1: Install AltStore on Your Mac

1. **Download AltServer:**
   - Go to: https://altstore.io
   - Download AltServer for macOS
   - Install (drag to Applications)

2. **Install Mail Plugin (if using Mail app):**
   - AltServer → Install Mail Plugin
   - Enable in Mail → Preferences → General → Manage Plug-ins

#### Step 2: Install AltStore on iPhone

1. **Connect iPhone via USB**
2. **Open AltServer:**
   - Click AltServer icon in menu bar
   - Select "Install AltStore" → Your iPhone name
   - Enter your Apple ID and password
   - AltStore will install on your iPhone

3. **Trust Developer on iPhone:**
   - Settings → General → VPN & Device Management
   - Tap your Apple ID
   - Tap "Trust"

#### Step 3: Build IPA File

1. **Build the app locally:**
   ```bash
   cd mobile
   flutter build ios --release
   ```

2. **Create IPA manually:**
   - The build creates `Runner.app` in `build/ios/iphoneos/`
   - We need to create an IPA file

#### Step 4: Install via AltStore

1. **Open AltStore on iPhone**
2. **Tap "+" button (top left)**
3. **Select IPA file** (transferred via AirDrop or Files app)
4. **Enter your Apple ID when prompted**
5. **App installs!**

**Note:** Apps expire after 7 days (free account). Refresh weekly in AltStore.

---

### Option 2: Sideloading with Sideloadly

**Works with:** Any Xcode version, any iOS version  
**Requires:** Free Apple ID  
**Best for:** Direct USB installation

#### Step 1: Download Sideloadly

1. Go to: https://sideloadly.io
2. Download for macOS
3. Install

#### Step 2: Build IPA

```bash
cd mobile
flutter build ios --release
# Then create IPA file (see below)
```

#### Step 3: Install via Sideloadly

1. **Connect iPhone via USB**
2. **Open Sideloadly**
3. **Select IPA file**
4. **Select your device**
5. **Enter Apple ID**
6. **Click "Start"**
7. **App installs!**

**Note:** Apps expire after 7 days. Re-install weekly.

---

### Option 3: Build IPA Manually (For Sideloading)

Since Flutter's `flutter build ios` creates `.app`, not `.ipa`, you need to create IPA manually:

#### Method A: Using Script

Create `build_ipa.sh`:

```bash
#!/bin/bash
cd mobile

# Build iOS
flutter build ios --release

# Create Payload directory
mkdir -p build/ios/Payload
cp -r build/ios/iphoneos/Runner.app build/ios/Payload/

# Create IPA
cd build/ios
zip -r lokumvpn.ipa Payload

echo "IPA created: build/ios/lokumvpn.ipa"
```

Run:
```bash
chmod +x build_ipa.sh
./build_ipa.sh
```

#### Method B: Using Xcode (If compatible)

If your device iOS version is supported by Xcode 14.2:

1. Open: `mobile/ios/Runner.xcworkspace`
2. Select "Any iOS Device"
3. Product → Archive
4. Export → Ad Hoc
5. Save IPA

---

### Option 4: Use Older iOS Device (If Available)

If you have an older iPhone/iPad running iOS 16 or earlier:

1. **Connect device via USB**
2. **Enable Developer Mode:**
   - Settings → Privacy & Security → Developer Mode → ON
3. **Configure code signing in Xcode:**
   - Open `mobile/ios/Runner.xcworkspace`
   - Signing & Capabilities → Add your team
4. **Build and run:**
   ```bash
   flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
   ```

---

### Option 5: Use iOS Simulator (No Device Needed)

**Works with:** Your current setup  
**No device needed**  
**Best for:** Testing app functionality

```bash
cd mobile
flutter emulators --launch apple_ios_simulator
flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
```

---

## Recommended Approach for Your Setup

### For Testing on Physical Device:

**Use AltStore (Option 1):**
1. ✅ Works with your current setup
2. ✅ Works with iOS 18.3.1
3. ✅ No Xcode version requirement
4. ✅ Free (apps expire after 7 days)
5. ⚠️ Need to refresh weekly

### Steps:

1. **Install AltServer on Mac:**
   ```bash
   # Download from https://altstore.io
   # Install AltServer
   ```

2. **Build IPA:**
   ```bash
   cd mobile
   flutter build ios --release
   # Create IPA (use script above)
   ```

3. **Install AltStore on iPhone:**
   - Connect iPhone
   - AltServer → Install AltStore → Your iPhone

4. **Install app via AltStore:**
   - Open AltStore on iPhone
   - Tap "+" → Select IPA
   - Install!

---

## Creating IPA File

Since Flutter doesn't create IPA directly, use this script:

```bash
#!/bin/bash
# build_ipa.sh

cd mobile

echo "Building iOS app..."
flutter build ios --release

echo "Creating IPA..."
mkdir -p build/ios/Payload
cp -r build/ios/iphoneos/Runner.app build/ios/Payload/
cd build/ios
zip -r lokumvpn.ipa Payload
cd ../..

echo "✅ IPA created: mobile/build/ios/lokumvpn.ipa"
echo ""
echo "Next steps:"
echo "1. Transfer IPA to iPhone (AirDrop, Files app, or USB)"
echo "2. Install via AltStore or Sideloadly"
```

Save as `mobile/build_ipa.sh`, then:
```bash
chmod +x mobile/build_ipa.sh
./mobile/build_ipa.sh
```

---

## Comparison

| Method | Xcode Version | iOS Version | Developer Account | App Expiry |
|--------|--------------|-------------|-------------------|------------|
| Direct USB | 14.2 | iOS ≤16.x only | Free/Paid | Permanent |
| AltStore | Any | Any | Free | 7 days |
| Sideloadly | Any | Any | Free | 7 days |
| TestFlight | 16+ required | Any | Paid ($99/yr) | Permanent |
| Simulator | Any | Any | None | N/A |

---

## Quick Start: AltStore Method

1. **Install AltServer:** https://altstore.io → Download for macOS
2. **Install on iPhone:** AltServer → Install AltStore → Your iPhone
3. **Build IPA:** Use script above
4. **Install:** AltStore → "+" → Select IPA → Install
5. **Refresh weekly:** AltStore → Tap app → Refresh

---

## Troubleshooting

### "Device support files" error
- **Solution:** Use sideloading (AltStore/Sideloadly)
- Direct USB won't work with iOS 18 on Xcode 14.2

### "IPA install failed"
- Check Apple ID is correct
- Free account: Apps expire after 7 days
- Re-install if expired

### "Build failed"
- Make sure Flutter dependencies are installed
- Run `flutter clean && flutter pub get`

### AltStore won't install
- Make sure Mail plugin is enabled (if using Mail)
- Or use wireless installation option
- Check iPhone is trusted

---

## Notes

- **Free Apple ID:** Apps expire after 7 days, need weekly refresh
- **Paid Developer Account:** Apps don't expire, but requires Xcode 16+ for TestFlight
- **Your Xcode 14.2:** Can build apps, but can't install to iOS 17+ devices directly
- **Sideloading:** Best option for your current setup

