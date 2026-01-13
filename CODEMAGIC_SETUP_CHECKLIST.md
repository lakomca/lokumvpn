# Codemagic Setup Checklist

## ⚠️ Code Signing Error Fix

If you see:
```
No Accounts: Add a new account in Accounts settings.
No profiles for 'com.example.lokumVpn' were found
```

## ✅ Required Steps (MUST DO IN CODEMAGIC DASHBOARD)

### Step 1: Add Apple Developer Account

1. **Open Codemagic:**
   - Go to: https://codemagic.io/apps
   - Sign in to your account

2. **Select Your App:**
   - Click on "lokumvpn" app

3. **Go to Settings:**
   - Click "Settings" tab (top navigation bar)
   - Click "Code signing" in left sidebar

4. **Add Apple Developer Account:**
   - Find "Apple Developer account" section
   - Click "Add account" or "Connect" button
   - You'll be redirected to Apple sign-in
   - Sign in with your Apple ID (the one with Developer account)
   - Authorize Codemagic to access your account
   - You'll be redirected back to Codemagic

5. **Select Team:**
   - After connecting, select your team from dropdown
   - Should show your team name (or company name)

6. **Save:**
   - Click "Save" button
   - Codemagic will now have access to create certificates

### Step 2: Verify Configuration

After adding account, you should see:
- ✅ Apple Developer account: Connected
- ✅ Team: [Your Team Name]
- ✅ Automatic code signing: Enabled

### Step 3: Rebuild

1. Go to "Builds" tab
2. Click "Start new build"
3. Select branch (main)
4. Build should now succeed!

## Requirements

- ✅ **Paid Apple Developer Account** ($99/year)
  - Free Apple ID won't work
  - Sign up: https://developer.apple.com/programs/
  - Takes 24-48 hours to activate

- ✅ **App in App Store Connect** (optional but recommended)
  - Create app first: https://appstoreconnect.apple.com
  - Use Bundle ID: com.example.lokumVpn (or change it)

## Troubleshooting

### "No team found"
- Make sure you have paid Developer account
- Free Apple ID = Personal Team = Won't work for TestFlight
- Verify account at: https://developer.apple.com/account

### "Bundle ID not found"
- Create app in App Store Connect first
- Or change Bundle ID in Codemagic settings
- Format: com.yourname.lokumvpn

### "Certificate error"
- Codemagic should auto-create certificates
- If error persists, check Apple Developer account status
- Verify account is active and paid

### Still getting errors?
1. Check Codemagic logs for specific error
2. Verify Apple Developer account is active
3. Make sure team is selected in Codemagic
4. Try disconnecting and reconnecting account

## Alternative: Manual Certificate Upload

If automatic signing doesn't work:

1. **Export certificates from your Mac:**
   - Keychain Access → Export certificates as .p12
   - Download provisioning profiles from Apple Developer

2. **Upload to Codemagic:**
   - Settings → Code signing → Certificates
   - Upload .p12 file
   - Upload .mobileprovision files

3. **Configure:**
   - Select certificate
   - Select provisioning profile
   - Save

## Next Steps After Build Succeeds

1. **Download IPA:**
   - Build completes → Download IPA file

2. **Upload to TestFlight:**
   - Download Transporter app (Mac App Store)
   - Open Transporter
   - Drag IPA into Transporter
   - Click "Deliver"

3. **Configure TestFlight:**
   - App Store Connect → Your App → TestFlight
   - Wait for processing (10-60 minutes)
   - Add testers
   - Install via TestFlight app

