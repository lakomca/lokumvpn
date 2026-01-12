# How to Get the Setup Script

## ⚠️ Important: Run from YOUR MAC, not the server!

The `scp` command must be run from **your Mac terminal**, not from the server.

## Method 1: SCP from Your Mac (Recommended)

**On your Mac terminal** (not server):

```bash
# Copy setup script to your Mac
scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/

# If you get "Permission denied", you need SSH key or password
# Option A: Use password (will prompt)
scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/

# Option B: Use SSH key (if you have one set up)
scp -i ~/.ssh/your_key admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/
```

## Method 2: View and Copy Manually

**On your Mac**, view the script:

```bash
# View the script
ssh admin@172.31.2.242 "cat /home/admin/lokum-vpn/setup_ios_simulator.sh"

# Or copy the content and save to ~/setup_ios_simulator.sh on your Mac
```

## Method 3: Direct Download via HTTP (if server has web server)

If you have a web server, you could serve the file, but the easiest is Method 1 or 2.

## Method 4: Create Script Directly on Mac

**On your Mac**, create the script manually:

```bash
cat > ~/setup_ios_simulator.sh << 'SCRIPT_END'
# [Paste the script content here]
SCRIPT_END

chmod +x ~/setup_ios_simulator.sh
```

## Troubleshooting SSH Connection

### "Permission denied (publickey)"

**Solution 1: Use password authentication**
```bash
# Just run scp, it will prompt for password
scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/
```

**Solution 2: Set up SSH key**
```bash
# On your Mac, generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096

# Copy key to server
ssh-copy-id admin@172.31.2.242

# Then scp will work without password
scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/
```

**Solution 3: Use password in command (less secure)**
```bash
# Not recommended, but works
sshpass -p 'your_password' scp admin@172.31.2.242:/home/admin/lokum-vpn/setup_ios_simulator.sh ~/
```

## Quick Alternative: Manual Setup

If you can't copy the script, you can set up manually:

```bash
# On your Mac
# 1. Install Flutter
brew install --cask flutter

# 2. Install CocoaPods
sudo gem install cocoapods

# 3. Copy mobile app
scp -r admin@172.31.2.242:/home/admin/lokum-vpn/mobile ~/lokum-vpn-mobile

# 4. Install dependencies
cd ~/lokum-vpn-mobile
flutter pub get
cd ios && pod install && cd ..

# 5. Start simulator and run
open -a Simulator
flutter run --dart-define=API_BASE_URL=http://172.31.2.242:8000
```

