# Mobile App Testing - Quick Start Guide

## Quick Start (3 Steps)

### Step 1: Ensure Backend is Running

```bash
cd /home/admin/lokum-vpn/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

✅ Backend should be accessible at: `http://172.31.2.242:8000`

### Step 2: Update API URL in Mobile Config

The mobile app needs to know where to find your backend.

**Option A: Update config.dart directly** (Quickest)

Edit `mobile/lib/config/config.dart`:

```dart
// For Android Emulator:
static const String apiBaseUrl = 'http://10.0.2.2:8000';

// For iOS Simulator:
static const String apiBaseUrl = 'http://localhost:8000';

// For Physical Device (use your server IP):
static const String apiBaseUrl = 'http://172.31.2.242:8000';
```

**Option B: Use Environment Variable** (Recommended)

Keep the default and run with:
```bash
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

### Step 3: Install Dependencies and Run

```bash
cd /home/admin/lokum-vpn/mobile
flutter pub get
flutter run
```

## Testing on Different Platforms

### 🟢 Android Emulator

1. **Start Android Emulator**
   ```bash
   flutter emulators --launch <emulator_id>
   # Or use Android Studio AVD Manager
   ```

2. **Use API URL:** `http://10.0.2.2:8000` (special Android emulator address)

3. **Run:**
   ```bash
   flutter run
   ```

### 🔵 iOS Simulator (macOS only)

1. **Start Simulator**
   ```bash
   open -a Simulator
   ```

2. **Use API URL:** `http://localhost:8000`

3. **Run:**
   ```bash
   flutter run
   ```

### 📱 Physical Device

1. **Connect device via USB**

2. **Enable Developer Mode**
   - **Android:** Settings → About → Tap Build Number 7 times → Enable USB Debugging
   - **iOS:** Trust computer when prompted

3. **Use API URL:** `http://172.31.2.242:8000` (your server IP)

4. **Ensure firewall allows port 8000:**
   ```bash
   sudo ufw allow 8000/tcp  # Ubuntu/Debian
   ```

5. **Run:**
   ```bash
   flutter devices  # Verify device is connected
   flutter run
   ```

## Quick Testing Script

Run the setup script:

```bash
cd /home/admin/lokum-vpn/mobile
./test_setup.sh
```

## Common Issues

### "Failed to connect to API"

**Solution:**
1. Verify backend is running: `curl http://localhost:8000/health`
2. Check API URL matches your testing method:
   - Android Emulator → `10.0.2.2:8000`
   - iOS Simulator → `localhost:8000`
   - Physical Device → `172.31.2.242:8000`
3. Ensure backend binds to `0.0.0.0` (already configured)

### "No devices found"

**Solution:**
```bash
flutter devices  # List all devices
# Enable USB debugging on Android
# Trust computer on iOS
```

### "Package errors"

**Solution:**
```bash
cd mobile
flutter clean
flutter pub get
```

## Testing Checklist

- [ ] App launches
- [ ] Can register new user
- [ ] Can login
- [ ] Server list loads
- [ ] Can view server details
- [ ] Can create VPN config
- [ ] Can connect/disconnect
- [ ] Statistics display
- [ ] All screens work

## Full Documentation

See `mobile/TESTING.md` for detailed testing guide.


