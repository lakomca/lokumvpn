# TestFlight Quick Steps

## ✅ Build Complete!

The iOS build was successful. Now follow these steps in Xcode:

## Step 1: Select Device Target

**IMPORTANT:** In Xcode's top toolbar:
- Click the device selector (shows current target)
- Select: **"Any iOS Device (arm64)"**
- ⚠️ DO NOT select your iPhone - select "Any iOS Device"

## Step 2: Create Archive

1. Menu: **Product → Archive**
2. Wait for build to complete (5-10 minutes)
3. Xcode Organizer window opens automatically

## Step 3: Upload to App Store Connect

In the Organizer window:

1. Click **"Distribute App"**
2. Select **"App Store Connect"**
3. Click **"Next"**
4. Select **"Upload"**
5. Click **"Next"**
6. Review options (defaults are usually fine)
7. Review code signing (should auto-select your team)
8. Click **"Upload"**
9. Wait for upload (5-15 minutes)

## Step 4: Configure in App Store Connect

1. Go to: https://appstoreconnect.apple.com
2. Sign in with your Apple Developer account
3. Click **"Apps"**
4. Find your app (or create new if first time):
   - Name: "Lokum VPN"
   - Bundle ID: com.example.lokumVpn
   - SKU: lokum-vpn-001
5. Go to **"TestFlight"** tab
6. Wait for build to process:
   - Status: "Processing" → "Ready to Submit"
   - First build: 30-60 minutes
   - Updates: 10-30 minutes

## Step 5: Add Testers

In TestFlight tab:

1. Click **"Internal Testing"** (if available)
2. Click **"+"** to add testers
3. Add yourself (your Apple ID email)
4. Or use **"External Testing"** for more testers (requires App Review first time)

## Step 6: Install on iPhone

1. Install **TestFlight** app from App Store (if not installed)
2. Open TestFlight app
3. Your app should appear (if you're an internal tester)
4. Tap **"Install"**
5. App installs on your iPhone!

## Troubleshooting

### "No accounts with App Store Connect access"
- Xcode → Settings → Accounts
- Add your Apple ID
- Make sure you have paid Developer account

### "Bundle ID not found"
- Create new app in App Store Connect
- Or change Bundle ID in Xcode to match existing app

### Archive button is grayed out
- Make sure "Any iOS Device (arm64)" is selected
- NOT a simulator
- NOT your iPhone
- Must be "Any iOS Device"

### Code signing errors
- Xcode → Select project → Signing & Capabilities
- Select your Team
- Check "Automatically manage signing"

## Notes

- ❌ **No device connection needed** - that's the beauty of TestFlight!
- ✅ Build for "Any iOS Device (arm64)" - generic build
- ✅ Upload to App Store Connect
- ✅ Install via TestFlight app on iPhone
- ✅ Works around Xcode version issues!

