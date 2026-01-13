# Cloud Build Setup for TestFlight

## Overview

Use a cloud build service with Xcode 16+ to build your iOS app, then upload to TestFlight.

## Option 1: Codemagic (Recommended - Easiest)

### Why Codemagic?
- ✅ Free tier: 500 build minutes/month
- ✅ Built-in Flutter support
- ✅ Xcode 16+ available
- ✅ Easy setup
- ✅ Direct TestFlight upload (optional)

### Setup Steps

#### Step 1: Sign Up

1. Go to: https://codemagic.io
2. Click "Sign up for free"
3. Sign up with GitHub/GitLab/Bitbucket (recommended) or email
4. Confirm email

#### Step 2: Connect Repository

1. After signup, click "Add application"
2. Select your Git provider (GitHub, GitLab, Bitbucket)
3. Authorize Codemagic to access your repositories
4. Select your repository (lokumvpn)
5. Click "Add application"

#### Step 3: Configure Build

Codemagic will auto-detect Flutter and suggest configuration.

1. **Select workflow:**
   - Choose "iOS" workflow
   - Or use "Workflow Editor" to customize

2. **Configure build settings:**
   - Xcode version: 16.0 (or latest)
   - Flutter version: Auto-detected (or specify)
   - Build mode: Release

3. **Code signing:**
   - Upload your certificate and provisioning profile
   - Or use Codemagic's automatic code signing (requires Apple Developer account connection)

4. **Environment variables (optional):**
   - Add API_BASE_URL if needed
   - Or configure in app code

5. **Build triggers:**
   - Manual builds (default)
   - Or set up triggers (push to branch, tags, etc.)

#### Step 4: Build

1. Click "Start new build"
2. Select branch (usually main/master)
3. Wait for build (10-20 minutes)
4. Download IPA file when complete

#### Step 5: Upload to TestFlight

After downloading IPA:

**Option A: Via Xcode (Easier)**
1. Open Xcode
2. Window → Organizer (or Product → Archive)
3. Click "Distribute App" (if you have an archive)
4. Or use Transporter app (download from Mac App Store)
5. Upload IPA via Transporter

**Option B: Via Transporter App (Recommended)**
1. Download "Transporter" from Mac App Store
2. Open Transporter
3. Drag IPA file into Transporter
4. Click "Deliver"
5. Wait for upload

**Option C: Via Codemagic (If configured)**
- Configure TestFlight upload in Codemagic settings
- Automatically uploads after build

### Codemagic Configuration File (Optional)

Create `codemagic.yaml` in your repository root for advanced configuration:

```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      xcode: 16.0
      cocoapods: default
    scripts:
      - name: Get Flutter dependencies
        script: |
          cd mobile
          flutter pub get
      - name: Build iOS
        script: |
          cd mobile
          flutter build ipa --release --no-codesign
    artifacts:
      - build/ios/ipa/*.ipa
```

## Option 2: Bitrise

### Setup Steps

1. **Sign up:** https://bitrise.io
2. **Add app:** Connect repository
3. **Select workflow:** iOS workflow
4. **Configure:**
   - Xcode version: Latest (16+)
   - Code signing: Upload certificates or connect Apple Developer account
5. **Build:** Start build, download IPA
6. **Upload:** Use Transporter app

### Pros/Cons
- ✅ Free tier: 200 builds/month
- ✅ Good documentation
- ⚠️ More complex setup than Codemagic

## Option 3: GitHub Actions (Free for Public Repos)

### Setup Steps

1. **Create workflow file:** `.github/workflows/ios.yml`

```yaml
name: Build iOS

on:
  workflow_dispatch:
  push:
    branches: [ main ]
    paths:
      - 'mobile/**'

jobs:
  build:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.6'
          
      - name: Install dependencies
        run: |
          cd mobile
          flutter pub get
          
      - name: Build iOS (no codesign)
        run: |
          cd mobile
          flutter build ios --release --no-codesign
          
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: mobile/build/ios/iphoneos/Runner.app
```

2. **Build manually:** GitHub → Actions → Run workflow
3. **Download artifact:** Download from Actions page
4. **Note:** This creates .app, not .ipa. You'll need to create IPA manually or use Xcode.

### Pros/Cons
- ✅ Free for public repositories
- ✅ Integrated with GitHub
- ⚠️ More complex setup
- ⚠️ Requires creating IPA manually

## Recommended Approach: Codemagic

**Easiest path:**
1. Sign up at codemagic.io
2. Connect repository
3. Use default iOS workflow
4. Configure code signing
5. Build
6. Download IPA
7. Upload via Transporter app

## Uploading IPA to TestFlight

After downloading IPA from cloud service:

### Using Transporter App (Easiest)

1. **Download Transporter:**
   - Mac App Store → Search "Transporter"
   - Install (free, official Apple app)

2. **Upload:**
   - Open Transporter
   - Sign in with Apple Developer account
   - Drag IPA file into window
   - Click "Deliver"
   - Wait for upload (5-15 minutes)

3. **Verify:**
   - Go to App Store Connect
   - Apps → Your App → TestFlight
   - Wait for processing (10-60 minutes)

### Using Xcode (Alternative)

1. Open Xcode
2. Window → Organizer
3. Click "+" → Add archive
4. Select IPA file
5. Click "Distribute App"
6. Follow prompts

## Code Signing for Cloud Builds

### Option A: Automatic (Easiest - Codemagic/Bitrise)

1. Connect Apple Developer account in service
2. Service handles certificates automatically
3. Uses your Developer account credentials

### Option B: Manual Certificate Upload

1. **Export certificates from Xcode:**
   - Keychain Access → Export certificates
   - Export as .p12 file

2. **Export provisioning profile:**
   - Xcode → Settings → Accounts → Download Manual Profiles
   - Or download from developer.apple.com

3. **Upload to cloud service:**
   - Codemagic: Settings → Code signing
   - Bitrise: Workflows → Code signing

## Troubleshooting

### "Code signing failed"
- Make sure certificates are valid
- Check provisioning profile matches Bundle ID
- Verify Apple Developer account is active

### "IPA upload failed"
- Verify IPA is properly signed
- Check Bundle ID matches App Store Connect
- Ensure version number is incremented

### "Build timeout"
- Increase timeout in service settings
- Optimize build scripts
- Remove unnecessary steps

## Cost Comparison

- **Codemagic:** Free (500 min/month), then $95/month
- **Bitrise:** Free (200 builds/month), then $36/month
- **GitHub Actions:** Free for public repos, 2000 min/month for private

## Next Steps

1. **Choose service** (Codemagic recommended)
2. **Sign up and connect repository**
3. **Configure build**
4. **Build and download IPA**
5. **Upload via Transporter**
6. **Configure TestFlight**

