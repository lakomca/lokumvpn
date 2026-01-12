# Local Mac Testing - Mobile App with Remote Backend

## Setup Overview

```
┌─────────────────┐         ┌──────────────────┐
│  Your Mac       │         │  Server          │
│  (Local)        │         │  172.31.2.242     │
│                 │         │                  │
│  ✓ Mobile App   │────────▶│  ✓ Backend API   │
│  ✓ iOS Simulator│  HTTP   │  ✓ Database      │
│  ✓ Flutter      │  (8000) │  ✓ Running       │
└─────────────────┘         └──────────────────┘
```

## Architecture

- **Your Mac:** Runs Flutter, builds mobile app, runs iOS Simulator
- **Server (172.31.2.242):** Runs backend API, database, handles requests

## Step-by-Step Setup

### Step 1: Ensure Backend is Running on Server

**On the server** (already done):
```bash
cd /home/admin/lokum-vpn/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

✅ Backend should be accessible at: `http://172.31.2.242:8000`

### Step 2: Install Prerequisites on Your Mac

**On your Mac terminal:**

```bash
# 1. Install Flutter (if not installed)
brew install --cask flutter

# 2. Install CocoaPods (for iOS dependencies)
sudo gem install cocoapods

# 3. Verify installation
flutter doctor
```

### Step 3: Copy Mobile App to Your Mac

**On your Mac terminal:**

```bash
# Copy mobile app from server to your Mac
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# If prompted for password, enter your server password
```

### Step 4: Configure Mobile App to Use Remote Backend

**On your Mac**, edit the config file:

```bash
cd ~/lokum-vpn-mobile
nano lib/config/config.dart
```

**Update line 6** to use the server IP:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://172.31.2.242:8000',  // Remote server backend
);
```

**OR** use environment variable (no file edit needed):

```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

### Step 5: Install Dependencies

**On your Mac:**

```bash
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..
```

### Step 6: Test Backend Connectivity

**On your Mac**, verify you can reach the backend:

```bash
# Test from Mac terminal
curl http://172.31.2.242:8000/health

# Should return: {"status":"healthy"}
```

**From iOS Simulator Safari:**
1. Open Safari in iOS Simulator
2. Go to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

### Step 7: Start iOS Simulator

**On your Mac:**

```bash
open -a Simulator
# Or: flutter emulators --launch apple_ios_simulator
```

### Step 8: Run Mobile App

**On your Mac:**

```bash
cd ~/lokum-vpn-mobile

# Option 1: Using environment variable (recommended)
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000

# Option 2: If you updated config.dart
flutter run
```

## Complete Command Sequence

**On your Mac terminal:**

```bash
# 1. Install Flutter (if needed)
brew install --cask flutter

# 2. Install CocoaPods
sudo gem install cocoapods

# 3. Copy mobile app
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 4. Install dependencies
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..

# 5. Test backend connectivity
curl http://172.31.2.242:8000/health

# 6. Start iOS Simulator
open -a Simulator

# 7. Run app
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Network Requirements

### Your Mac Must Be Able to Reach Server

**Test connectivity:**

```bash
# From your Mac
ping 172.31.2.242
curl http://172.31.2.242:8000/health
```

**If it doesn't work:**
- Mac and server must be on **same network**, OR
- Server must have **public IP** with firewall allowing port 8000
- Check firewall rules on server

### iOS Simulator Network Access

iOS Simulator can access:
- ✅ Server IP: `http://172.31.2.242:8000` (if Mac can reach it)
- ✅ Localhost: `http://localhost:8000` (if backend on Mac)

## Configuration Summary

| Component | Location | URL |
|-----------|----------|-----|
| Mobile App | Your Mac | Runs locally |
| Backend API | Server (172.31.2.242) | `http://172.31.2.242:8000` |
| iOS Simulator | Your Mac | Connects to server |

## Testing Workflow

1. **Backend runs on server** (already set up)
2. **Mobile app runs on your Mac** (Flutter)
3. **iOS Simulator runs on your Mac**
4. **App connects to server backend** via HTTP

## Troubleshooting

### "Cannot connect to API"

**Check 1: Backend is running**
```bash
# On server
curl http://localhost:8000/health
```

**Check 2: Mac can reach server**
```bash
# On your Mac
curl http://172.31.2.242:8000/health
```

**Check 3: Network connectivity**
```bash
# On your Mac
ping 172.31.2.242
```

**Check 4: Firewall**
```bash
# On server, ensure port 8000 is open
sudo ufw allow 8000/tcp
```

### "Flutter not found"

```bash
# On your Mac
brew install --cask flutter
flutter doctor
```

### "CocoaPods not found"

```bash
# On your Mac
sudo gem install cocoapods
```

### "Build failed"

```bash
cd ~/lokum-vpn-mobile
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Alternative: Run Backend Locally on Mac

If you want to test with backend on your Mac too:

```bash
# On your Mac
# 1. Copy backend
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/backend ~/lokum-vpn-backend

# 2. Set up Python environment
cd ~/lokum-vpn-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Run backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# 4. Update mobile app config to use localhost
# In config.dart: defaultValue: 'http://localhost:8000'
```

## Quick Reference

**Server (172.31.2.242):**
- Backend API: `http://172.31.2.242:8000`
- Status: ✅ Running

**Your Mac:**
- Mobile app: `~/lokum-vpn-mobile`
- Flutter: Installed locally
- iOS Simulator: Runs locally
- Connects to: `http://172.31.2.242:8000`

## Next Steps

1. ✅ Backend is running on server
2. ⏳ Install Flutter on your Mac
3. ⏳ Copy mobile app to your Mac
4. ⏳ Configure API URL to server IP
5. ⏳ Run app on iOS Simulator

Ready to test! 🚀

