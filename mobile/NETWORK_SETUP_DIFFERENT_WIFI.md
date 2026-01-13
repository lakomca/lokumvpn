# Testing on Different Networks - Setup Guide

## Situation
Your iPhone and backend server are **not on the same WiFi network**.

## Solution Options

### Option 1: Public IP Access (Recommended if server has public IP)

Your server IP `3.29.239.219` appears to be a public IP. To make it accessible:

#### Step 1: Verify Server Firewall

**If using AWS EC2:**
1. Go to EC2 Console → Security Groups
2. Select your instance's security group
3. Add Inbound Rule:
   - Type: Custom TCP
   - Port: 8000
   - Source: 0.0.0.0/0 (or your IP for security)
   - Description: Lokum VPN API

**If using other cloud providers:**
- Configure firewall/security group to allow port 8000
- Allow inbound traffic on port 8000

**If using local server with router:**
- Port forward port 8000 to your server
- Configure router firewall

#### Step 2: Verify Backend is Bound to 0.0.0.0

The backend must listen on all interfaces, not just localhost:

```bash
# On your server, check how backend is running:
ps aux | grep uvicorn

# Should show: --host 0.0.0.0
# If not, restart with:
uvicorn main:app --host 0.0.0.0 --port 8000
```

#### Step 3: Test from iPhone

1. **On your iPhone** (using cellular or different WiFi):
   - Open Safari
   - Go to: `http://3.29.239.219:8000/health`
   - Should see: `{"status":"healthy"}`

2. **If it doesn't work:**
   - Check firewall rules
   - Verify backend is running
   - Check server logs for connection attempts

### Option 2: Use ngrok (Temporary Testing)

If you can't configure firewall, use ngrok for temporary access:

#### On Your Server:
```bash
# Install ngrok
# Download from: https://ngrok.com/download

# Start ngrok tunnel
ngrok http 8000

# You'll get a URL like: https://abc123.ngrok.io
```

#### Update App Config:
```bash
# Use the ngrok URL
flutter run --dart-define=API_BASE_URL=https://abc123.ngrok.io
```

**Note:** ngrok free tier has limitations (URL changes on restart, rate limits)

### Option 3: Use Tailscale/VPN (Secure)

Set up a VPN between your iPhone and server:

1. **Install Tailscale** on both iPhone and server
2. **Connect both to same Tailscale network**
3. **Use Tailscale IP** instead of public IP

### Option 4: Use SSH Tunnel (Advanced)

Create an SSH tunnel from your Mac to the server:

```bash
# On your Mac, create SSH tunnel:
ssh -L 8000:localhost:8000 user@3.29.239.219

# Then use localhost in app (but iPhone still needs to reach your Mac)
```

## Quick Test Commands

### Test Server Accessibility:
```bash
# From your Mac (different network simulation):
curl http://3.29.239.219:8000/health

# From iPhone Safari:
http://3.29.239.219:8000/health
```

### Check Port is Open:
```bash
# Using telnet (if available):
telnet 3.29.239.219 8000

# Using nc (netcat):
nc -zv 3.29.239.219 8000
```

## Recommended Setup for Production

1. **Use HTTPS** (not HTTP) for security
2. **Configure proper firewall rules** (not 0.0.0.0/0)
3. **Use domain name** instead of IP
4. **Set up authentication** and rate limiting
5. **Use reverse proxy** (nginx) for better security

## Current Configuration

Your app is configured to use:
- **Server IP:** `3.29.239.219:8000`
- **Protocol:** HTTP (not secure, but works for testing)

## Testing Steps

1. **Verify server firewall allows port 8000**
2. **Test from iPhone browser:** `http://3.29.239.219:8000/health`
3. **If accessible, run app:**
   ```bash
   cd /Users/aga/Desktop/proj/lokumvpn/mobile
   flutter run --dart-define=API_BASE_URL=http://3.29.239.219:8000
   ```

## Troubleshooting

### "Connection refused" or timeout
- Firewall blocking port 8000
- Backend not bound to 0.0.0.0
- Backend not running

### "Network error" in app
- Server not accessible from iPhone's network
- Firewall/security group not configured
- Backend crashed

### Works on WiFi but not cellular
- Server firewall might be blocking certain IPs
- Check security group rules

## Security Notes

⚠️ **Important:** Exposing your backend to the internet (0.0.0.0/0) is a security risk.

For production:
- Use HTTPS
- Restrict firewall to specific IPs
- Add authentication
- Use rate limiting
- Consider using a VPN solution

