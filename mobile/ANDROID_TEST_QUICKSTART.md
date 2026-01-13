# Android Testing - Quick Start Guide

## ✅ Current Status

- ✅ Flutter installed and working
- ✅ Android emulator running (emulator-5554)
- ✅ Dependencies installed
- ✅ Android platform files created

## 🚀 Quick Run Commands

### Option 1: Using the Test Script (Recommended)

```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
./test_android.sh
```

The script will:
- Check for devices/emulators
- Ask you to configure the API URL
- Launch the app automatically

### Option 2: Manual Run

#### For Android Emulator with Backend on Localhost:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

#### For Android Emulator with Backend on Remote Server:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

#### For Physical Android Device:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

## 📱 API URL Configuration

| Scenario | API URL |
|----------|---------|
| Emulator + Backend on localhost | `http://10.0.2.2:8000` |
| Emulator + Backend on server | `http://172.31.2.242:8000` |
| Physical device + Backend on server | `http://172.31.2.242:8000` |
| Physical device + Backend on localhost | `http://<your-local-ip>:8000` |

**Note:** `10.0.2.2` is a special IP that Android emulator uses to access the host machine's localhost.

## 🔍 Verify Setup

### Check if emulator is running:
```bash
flutter devices
```

Should show:
```
sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 13
```

### Check if backend is accessible:
From your Mac terminal:
```bash
curl http://172.31.2.242:8000/health
```

Or if backend is on localhost:
```bash
curl http://localhost:8000/health
```

## 🛠️ Troubleshooting

### Emulator not showing up:
```bash
# List available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch Pixel_2_API_TiramisuPrivacySandbox
```

### App won't connect to backend:
1. **For emulator with localhost backend:**
   - Make sure backend is running on your Mac
   - Use `http://10.0.2.2:8000` as API URL
   - Test: `curl http://localhost:8000/health`

2. **For emulator with remote backend:**
   - Make sure backend is running on server
   - Use `http://172.31.2.242:8000` as API URL
   - Test: `curl http://172.31.2.242:8000/health`

### Build errors:
```bash
cd /Users/aga/Desktop/proj/lokumvpn/mobile
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## 📝 Testing Checklist

Once the app launches:
- [ ] App opens on Android emulator
- [ ] Splash screen displays
- [ ] Can register a new user
- [ ] Can login with credentials
- [ ] Home screen loads
- [ ] Server list displays
- [ ] Can view server details
- [ ] Connection status works
- [ ] All navigation works

## 🎯 Next Steps

1. **Start the backend** (if not already running):
   ```bash
   # On the server or localhost
   cd backend
   source venv/bin/activate  # if using virtualenv
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

2. **Run the app** using one of the commands above

3. **Test the features** using the checklist

## 💡 Tips

- Keep the emulator running between test runs for faster iteration
- Use `r` in the Flutter console to hot reload
- Use `R` to hot restart
- Press `q` to quit the app

