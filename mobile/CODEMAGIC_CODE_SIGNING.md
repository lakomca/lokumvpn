# Codemagic Code Signing Setup

## Error You're Seeing

```
No Accounts: Add a new account in Accounts settings.
No profiles for 'com.example.lokumVpn' were found
```

This means Codemagic needs your Apple Developer account credentials to sign the app.

## Solution: Configure Code Signing in Codemagic

### Option 1: Automatic Code Signing (Recommended - Easiest)

#### Step 1: Add Apple Developer Account to Codemagic

1. **Go to Codemagic Dashboard:**
   - https://codemagic.io/apps
   - Select your app (lokumvpn)

2. **Go to Settings:**
   - Click "Settings" tab
   - Click "Code signing" in left sidebar

3. **Add Apple Developer Account:**
   - Click "Add account" or "Connect Apple Developer account"
   - Sign in with your Apple ID (the one with Developer account)
   - Authorize Codemagic to access your account
   - Select your team

4. **Configure Automatic Signing:**
   - Codemagic will automatically:
     - Create/use certificates
     - Create provisioning profiles
     - Sign your app

#### Step 2: Update Bundle Identifier (If Needed)

If you see errors about Bundle ID:

1. **In Codemagic Settings:**
   - Go to "Code signing"
   - Check Bundle Identifier
   - If it's `com.example.lokumVpn`, you may need to change it

2. **Change Bundle ID in Xcode project:**
   - Or update in Codemagic settings
   - Format: `com.yourname.lokumvpn`
   - Must match your App Store Connect app

#### Step 3: Rebuild

1. Go to "Builds" tab
2. Click "Start new build"
3. Build should now succeed with code signing

### Option 2: Manual Certificate Upload

If automatic signing doesn't work:

#### Step 1: Export Certificates from Your Mac

1. **Open Keychain Access** (Applications → Utilities)

2. **Export Distribution Certificate:**
   - Find "Apple Distribution: Your Name" certificate
   - Right-click → Export
   - Save as `.p12` file
   - Set password (remember it!)

3. **Export Development Certificate (if needed):**
   - Find "Apple Development: Your Name" certificate
   - Export as `.p12`

#### Step 2: Export Provisioning Profile

1. **From Xcode:**
   - Xcode → Settings → Accounts
   - Select your team
   - Click "Download Manual Profiles"
   - Profiles saved to: `~/Library/MobileDevice/Provisioning Profiles/`

2. **Or from Apple Developer:**
   - https://developer.apple.com/account
   - Certificates, Identifiers & Profiles
   - Profiles → Download

#### Step 3: Upload to Codemagic

1. **In Codemagic Settings:**
   - Code signing → Certificates
   - Upload `.p12` certificate file
   - Enter certificate password

2. **Upload Provisioning Profile:**
   - Code signing → Provisioning profiles
   - Upload `.mobileprovision` file

3. **Configure:**
   - Select certificate
   - Select provisioning profile
   - Save

#### Step 4: Rebuild

Start new build - should work now.

### Option 3: Build Without Code Signing (For Testing)

If you just want to test the build process:

1. **Modify codemagic.yaml:**
   ```yaml
   - name: Build iOS
     script: |
       cd mobile
       flutter build ios --release --no-codesign
   ```

2. **Note:** This creates `.app`, not `.ipa`
   - You'll need to manually create IPA
   - Or use for local testing only

## Quick Fix Steps

### In Codemagic Dashboard:

1. **Settings → Code signing**
2. **Click "Add account"** or "Connect Apple Developer account"
3. **Sign in with Apple ID** (Developer account)
4. **Select your team**
5. **Save**
6. **Rebuild**

That's it! Codemagic handles the rest automatically.

## Troubleshooting

### "Bundle Identifier not found"

**Solution:**
- Create app in App Store Connect first
- Or change Bundle ID to match existing app
- Format: `com.yourname.lokumvpn`

### "Certificate expired"

**Solution:**
- Codemagic should auto-renew
- Or manually upload new certificate
- Check certificate validity in Apple Developer portal

### "Provisioning profile doesn't match"

**Solution:**
- Make sure Bundle ID matches
- Regenerate provisioning profile
- Upload new profile to Codemagic

### "Team not found"

**Solution:**
- Make sure you have paid Developer account ($99/year)
- Free Apple ID won't work for App Store/TestFlight
- Verify account in Apple Developer portal

## Bundle Identifier

Current: `com.example.lokumVpn`

**Recommendation:** Change to something unique:
- `com.yourname.lokumvpn`
- `com.yourcompany.lokumvpn`

**To change:**
1. In Codemagic: Settings → Code signing → Bundle Identifier
2. Or in Xcode: Project → Target → General → Bundle Identifier

## Verification Checklist

- [ ] Apple Developer account added to Codemagic
- [ ] Team selected in Codemagic
- [ ] Bundle Identifier configured
- [ ] Code signing enabled in workflow
- [ ] Certificates/profiles uploaded (if manual)
- [ ] Build triggered successfully

## Next Steps After Code Signing Works

1. **Build succeeds** → Download IPA
2. **Upload to TestFlight** via Transporter app
3. **Configure in App Store Connect**
4. **Install via TestFlight app**

## Reference

- Codemagic Code Signing Docs: https://docs.codemagic.io/code-signing/ios-code-signing/
- Apple Developer Portal: https://developer.apple.com/account

