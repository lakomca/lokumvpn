# Running App on Connected Android Device

## Your Android Device is Connected ✓

Now you need to run Flutter commands from **YOUR LOCAL MACHINE** (not this server).

## Quick Steps

### Step 1: On Your Local Machine

Make sure you have:
- ✅ Flutter installed
- ✅ Android device connected via USB
- ✅ USB Debugging enabled on device

### Step 2: Copy Mobile App (if not already)

From your **local machine terminal**:

```bash
# Copy mobile app from server to your local machine
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile
```

### Step 3: Verify Device Connection

From your **local machine**:

```bash
# Check if Android device is detected
flutter devices

# Should show your device, for example:
# • SM G991B (mobile) • R58M30ABCDE • android-arm64 • Android 13
```

If device not shown:
- Check USB connection
- Enable USB Debugging: Settings → Developer Options → USB Debugging
- Allow USB debugging on device when prompted

### Step 4: Install Dependencies

```bash
cd ~/lokum-vpn-mobile
flutter pub get
```

### Step 5: Start Backend Server (if not running)

**On this server**, start the backend:

```bash
cd /home/admin/lokum-vpn/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Step 6: Run App on Android Device

From your **local machine**:

```bash
cd ~/lokum-vpn-mobile

# Run with server IP
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Network Requirements

**Important:** Your Android device must be able to reach the server.

### Test Connectivity from Android Device:

1. Open **Chrome** on your Android device
2. Go to: `http://172.31.2.242:8000/health`
3. Should see: `{"status":"healthy"}`

**If it doesn't work:**
- Android device and server must be on **same WiFi network**, OR
- Server must be **publicly accessible** (firewall allows port 8000)

## Alternative: Update Config File

Instead of using environment variable, you can update the config file:

Edit `~/lokum-vpn-mobile/lib/config/config.dart`:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://172.31.2.242:8000',  // Your server IP
);
```

Then just run:
```bash
flutter run
```

## Troubleshooting

### "No devices found"

```bash
# Check ADB connection
adb devices

# If device shows "unauthorized":
# 1. Check Android device screen for "Allow USB debugging" prompt
# 2. Check "Always allow from this computer"
# 3. On device: Settings → Developer Options → Revoke USB debugging authorizations
# 4. Reconnect device
```

### "Failed to connect to API"

1. **Test server from Android device:**
   - Open Chrome: `http://172.31.2.242:8000/health`
   - Must see: `{"status":"healthy"}`

2. **Check backend is running:**
   ```bash
   # On server
   curl http://localhost:8000/health
   ```

3. **Verify network:**
   - Android device and server on same WiFi
   - Or server has public IP with firewall open

### "Gradle build failed"

```bash
cd ~/lokum-vpn-mobile
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## Complete Command Sequence

From your **local machine**:

```bash
# 1. Copy app (first time only)
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 2. Navigate to app
cd ~/lokum-vpn-mobile

# 3. Install dependencies
flutter pub get

# 4. Verify device
flutter devices

# 5. Run app
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## What Happens Next

1. Flutter will build the app
2. App will install on your Android device
3. App will launch automatically
4. App will connect to server at `http://172.31.2.242:8000`

## Testing Checklist

Once app runs:

- [ ] App launches on Android device
- [ ] Splash screen displays
- [ ] Can register new user
- [ ] Can login
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Connection status works
- [ ] All features functional

Need help with any step?

