# Codemagic Quick Start Guide

## Why Codemagic?

- ✅ Builds with **Xcode 16+** in the cloud
- ✅ Works around your Xcode 14.2 limitation
- ✅ No need to update macOS/Xcode locally
- ✅ Free tier: 500 build minutes/month
- ✅ Direct TestFlight upload (optional)

## Prerequisites

- ✅ GitHub account (repository is already on GitHub)
- ✅ Paid Apple Developer account ($99/year) - Required for code signing
- ✅ App in App Store Connect (create if needed)

## Step-by-Step Setup

### Step 1: Sign Up for Codemagic

1. **Go to Codemagic:**
   - https://codemagic.io
   - Click "Sign up" (top right)

2. **Sign up with GitHub (Recommended):**
   - Click "Sign up with GitHub"
   - Authorize Codemagic
   - Grant access to repositories (or select specific repos)
   - Faster setup, automatic repository access

3. **Or sign up with email:**
   - Enter email and password
   - Verify email address
   - Then connect repository manually

### Step 2: Add Your Application

1. **After signup:**
   - Click "Add application" button
   - Or go to: https://codemagic.io/apps

2. **Select Git provider:**
   - Choose "GitHub"
   - Authorize if prompted

3. **Select repository:**
   - Find "lakomca/lokumvpn"
   - Click "Select repository"

4. **Add application:**
   - Codemagic will detect Flutter
   - Click "Add application"
   - App appears in your apps list

### Step 3: Configure Code Signing ⚠️ (CRITICAL!)

**This is the step that was failing before - you MUST do this!**

1. **In Codemagic Dashboard:**
   - Click on your app ("lokumvpn")
   - Click "Settings" tab (top navigation bar)

2. **Go to Code Signing:**
   - Click "Code signing" in left sidebar
   - You'll see "Apple Developer account" section

3. **Add Apple Developer Account:**
   - Click "Add account" or "Connect Apple Developer account"
   - You'll be redirected to Apple sign-in
   - **Sign in with your Apple ID** (the one with Developer account)
   - **Enter password** (complete 2FA if prompted)
   - **Authorize Codemagic** to access your account
   - You'll be redirected back to Codemagic

4. **Select Team:**
   - After connecting, select your team from dropdown
   - Should show your team name or company name

5. **Save:**
   - Click "Save" button
   - You should see: "Apple Developer account: Connected"
   - Team should be selected

**✅ Verification:**
- Apple Developer account: [Your Account Name] ✅
- Team: [Your Team Name] ✅
- Status: Connected ✅

### Step 4: Configure Workflow (Optional)

The `codemagic.yaml` file is already configured in your repository.

**Option A: Use YAML file (Recommended)**
- Codemagic will automatically detect `codemagic.yaml`
- Use it as-is (already configured)
- Or customize if needed

**Option B: Use Workflow Editor**
- Go to "Workflow Editor" tab
- Configure through UI
- Codemagic will create workflow

**Current workflow settings:**
- Xcode: 16.0
- Flutter: stable
- Build: Release IPA
- Code signing: Automatic (via account you added)

### Step 5: Build Your App

1. **Go to Builds tab:**
   - Click "Builds" tab in your app
   - Click "Start new build" button

2. **Configure build:**
   - **Branch:** Select "main" (or your branch)
   - **Workflow:** Should show "ios-workflow"
   - **Build type:** Release (default)
   - Click "Start new build"

3. **Wait for build:**
   - Build takes 10-20 minutes
   - First build may take longer
   - You'll see build progress in real-time

4. **Download IPA:**
   - When build completes, click "Download" button
   - Save IPA file to your Mac

### Step 6: Upload to TestFlight

After downloading IPA:

1. **Download Transporter:**
   - Mac App Store → Search "Transporter"
   - Install (free, official Apple app)

2. **Upload IPA:**
   - Open Transporter
   - Sign in with Apple Developer account
   - Drag IPA file into Transporter window
   - Click "Deliver" button
   - Wait for upload (5-15 minutes)

3. **Verify upload:**
   - Go to: https://appstoreconnect.apple.com
   - Apps → Your App → TestFlight tab
   - You should see your build "Processing"

4. **Wait for processing:**
   - Status: "Processing" → "Ready to Submit"
   - First build: 30-60 minutes
   - Updates: 10-30 minutes

5. **Configure TestFlight:**
   - Add testers (Internal Testing - up to 100)
   - Or External Testing (requires App Review first time)

6. **Install on iPhone:**
   - Install TestFlight app (from App Store)
   - Open TestFlight
   - Your app appears (if you're a tester)
   - Tap "Install"

## Troubleshooting

### "No Accounts" Error

**Problem:** Build fails with "No Accounts: Add a new account"

**Solution:**
- You haven't added Apple Developer account yet
- Go to Settings → Code signing
- Add your Apple Developer account
- Make sure team is selected
- Save and rebuild

### "Bundle ID not found"

**Problem:** Bundle identifier error

**Solution:**
- Create app in App Store Connect first
- Or change Bundle ID in Codemagic settings
- Format: `com.yourname.lokumvpn`
- Must match App Store Connect app

### "No team found"

**Problem:** Team not showing in dropdown

**Solution:**
- Make sure you have paid Developer account ($99/year)
- Free Apple ID = Personal Team = Won't work for TestFlight
- Verify account at: https://developer.apple.com/account
- Try disconnecting and reconnecting account

### Build keeps failing

**Check:**
1. Code signing is configured (Settings → Code signing)
2. Apple Developer account is connected
3. Team is selected
4. Account is active and paid
5. Build logs for specific error

### "SDK version" error

**Good news:** This won't happen with Codemagic!
- Codemagic uses Xcode 16+
- Meets Apple's SDK requirements
- Build should succeed (if code signing is configured)

## Current Configuration

Your `codemagic.yaml` is configured with:
- ✅ Xcode 16.0
- ✅ Flutter stable
- ✅ iOS release build
- ✅ IPA artifact output
- ✅ Code signing setup

## Quick Reference

**Codemagic Dashboard:** https://codemagic.io/apps  
**App Store Connect:** https://appstoreconnect.apple.com  
**Apple Developer:** https://developer.apple.com/account  

**Build command:** (automatic via Codemagic)
```bash
# Codemagic runs this automatically:
flutter build ipa --release
```

**Upload command:** (after downloading IPA)
```bash
# Use Transporter app (GUI) or:
xcrun altool --upload-app --file lokumvpn.ipa \
  --type ios --apiKey YOUR_KEY --apiIssuer YOUR_ISSUER
```

## Next Steps

1. ✅ Sign up for Codemagic
2. ✅ Add your repository
3. ✅ **Configure code signing** (IMPORTANT!)
4. ✅ Build app
5. ✅ Download IPA
6. ✅ Upload to TestFlight
7. ✅ Install on iPhone

## Support

- Codemagic Docs: https://docs.codemagic.io
- Code Signing: https://docs.codemagic.io/code-signing/ios-code-signing/
- Flutter: https://docs.codemagic.io/getting-started/flutter/

