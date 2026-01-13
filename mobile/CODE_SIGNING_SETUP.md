# Code Signing Setup for TestFlight

## Error
"Signing for 'Runner' requires a development team. Select a development team in the Signing & Capabilities editor."

## Solution

### Step 1: Add Apple Developer Account to Xcode

1. **Open Xcode Settings:**
   - Xcode → Settings (or Xcode → Preferences on older versions)
   - Or press `Cmd + ,` (Command + Comma)

2. **Go to Accounts tab:**
   - Click "Accounts" tab at the top

3. **Add Apple ID:**
   - Click "+" button (bottom left)
   - Select "Apple ID"
   - Enter your Apple ID email (the one with Developer account)
   - Enter password
   - Click "Sign In"

4. **Verify Team:**
   - Your team should appear in the list
   - If you have a paid Developer account ($99/year), it will show your team name
   - If you only have a free Apple ID, you'll see "Personal Team"

### Step 2: Configure Signing in Project

1. **In Xcode project window:**
   - Select **"Runner"** project (blue icon, top of left sidebar)
   - NOT "Runner" folder - the blue project icon

2. **Select Target:**
   - Under "TARGETS", select **"Runner"**
   - (Should be the only target listed)

3. **Open Signing & Capabilities tab:**
   - Click **"Signing & Capabilities"** tab at the top

4. **Configure Signing:**
   - ✅ Check **"Automatically manage signing"**
   - Select **Team** from dropdown
     - Should show your team name (or "Personal Team" for free account)
     - If dropdown is empty: Go back to Step 1 and add Apple ID

5. **Bundle Identifier:**
   - Should be: `com.example.lokumVpn`
   - If you see an error about Bundle ID:
     - Change to: `com.yourname.lokumvpn` (replace yourname with your name/company)
     - Or use: `com.yourname.lokumvpn.app` (add .app at end)

6. **Xcode will automatically:**
   - Create signing certificate
   - Create provisioning profile
   - Configure signing

### Step 3: Verify Signing is Working

After selecting team, you should see:
- ✅ Green checkmark next to "Automatically manage signing"
- ✅ Team name selected
- ✅ Provisioning profile created automatically
- ❌ No red error messages

### Step 4: Try Archive Again

Once signing is configured:

1. **Select Device Target:**
   - Top toolbar: Select **"Any iOS Device (arm64)"**

2. **Create Archive:**
   - Product → Archive
   - Should work now!

## Troubleshooting

### "No accounts with App Store Connect access"

**Solution:**
- Make sure you're signed in to Xcode Settings → Accounts
- You need a **paid Apple Developer account** ($99/year) for TestFlight
- Free Apple ID = "Personal Team" = Can only test on your own devices, NOT TestFlight

### "Bundle Identifier is not available"

**Solution:**
- Change Bundle Identifier to something unique
- Format: `com.yourname.appname`
- Example: `com.johndoe.lokumvpn`
- Cannot use: `com.example.*` (reserved)

### "Failed to register bundle identifier"

**Solution:**
- This is normal - Xcode is trying to register it
- Wait a moment, it should resolve
- Or change Bundle ID to something else

### "Personal Team" selected (Free Apple ID)

**Issue:**
- Free Apple ID = Personal Team
- Personal Team = Can only install on your own device via USB
- Personal Team = **Cannot use TestFlight**

**Solution:**
- You need a **paid Apple Developer account** ($99/year)
- Sign up at: https://developer.apple.com/programs/
- Then add that Apple ID to Xcode

### Team dropdown is empty

**Solution:**
1. Go to Xcode → Settings → Accounts
2. Add your Apple ID
3. Wait for it to load teams
4. Go back to Signing & Capabilities
5. Team should now appear

## Quick Checklist

- [ ] Apple Developer account ($99/year) - Required for TestFlight
- [ ] Signed in to Xcode Settings → Accounts
- [ ] Team selected in Signing & Capabilities
- [ ] "Automatically manage signing" checked
- [ ] Bundle Identifier is unique (not com.example.*)
- [ ] No red error messages
- [ ] Green checkmark visible

## Notes

- **Free Apple ID (Personal Team):** Can only install via USB, NOT TestFlight
- **Paid Developer Account:** Required for TestFlight distribution
- **Bundle ID:** Must be unique, format: `com.yourname.appname`
- **Code Signing:** Xcode handles certificates automatically when "Automatically manage signing" is checked

