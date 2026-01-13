# User Registration Issue - Debugging Guide

## Issue: Unable to Register Users

## Current Status

- ✅ Backend is accessible (health check works)
- ✅ API endpoint is correct: `http://3.29.239.219:8000/api/v1/auth/register`
- ❌ Registration returns: "Internal Server Error"

## Possible Causes

### 1. Database Not Initialized

The database may not be set up. Check on the server:

```bash
# SSH into your server
ssh user@3.29.239.219

# Check if database exists
cd /path/to/lokumvpn/backend
ls -la *.db  # Should see lokum_vpn.db if using SQLite

# If database doesn't exist, initialize it:
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"
```

### 2. Database Permissions Issue

```bash
# Check database file permissions
ls -la lokum_vpn.db

# Ensure writable
chmod 666 lokum_vpn.db
```

### 3. Backend Not Running Properly

Check backend logs on server:
```bash
# Check if backend is running
ps aux | grep uvicorn

# Check backend logs for errors
# Look for Python traceback errors
```

### 4. Missing Dependencies

On server:
```bash
cd /path/to/lokumvpn/backend
pip install -r requirements.txt
```

### 5. CORS Issues

Check if CORS is properly configured for mobile app.

## Quick Test from Server

SSH into your server and test directly:

```bash
# Test registration endpoint
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"testpass123"}'

# Should return user object or specific error message
```

## Fix Steps

### Step 1: Verify Database is Initialized

On your server:
```bash
cd /path/to/lokumvpn/backend

# Activate virtual environment if using one
source venv/bin/activate  # or your venv path

# Initialize database
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"
```

### Step 2: Check Backend Logs

Look at backend console output when registration is attempted. You should see:
- Python traceback error
- Database error
- Or other error details

### Step 3: Test Backend Directly

```bash
# From your Mac, test registration:
curl -v -X POST http://3.29.239.219:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser2","email":"test2@example.com","password":"testpass123"}'

# The -v flag will show detailed error information
```

### Step 4: Check API Response Format

The backend should return proper error messages. Check if the error handling is working:

```bash
# Test with existing username (should return 400 with message):
curl -X POST http://3.29.239.219:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"testpass123"}'
```

## Common Issues and Solutions

### Issue: Database doesn't exist

**Solution:**
```bash
# On server
cd backend
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"
```

### Issue: Database locked or permission denied

**Solution:**
```bash
# Check database file
ls -la backend/*.db

# Fix permissions
chmod 666 backend/*.db

# Or ensure directory is writable
chmod 755 backend/
```

### Issue: SQLite not available

**Solution:**
```bash
# Install SQLite
# Usually comes with Python, but verify:
python3 -c "import sqlite3; print('SQLite OK')"
```

### Issue: Missing Python dependencies

**Solution:**
```bash
cd backend
pip install -r requirements.txt
```

## Debugging in Mobile App

Add better error logging:

```dart
// In api_service.dart, improve error handling:
Exception _handleError(dynamic error) {
  if (error is DioException) {
    if (error.response != null) {
      // Log full response for debugging
      print('API Error: ${error.response?.statusCode}');
      print('Response: ${error.response?.data}');
      final message = error.response?.data['detail'] ?? 
                     error.response?.data['message'] ?? 
                     error.response?.data.toString() ?? 
                     'An error occurred';
      return Exception(message);
    }
    // ... rest of error handling
  }
  return Exception('Unexpected error: $error');
}
```

## Next Steps

1. **SSH into your server**
2. **Check backend logs** when registration is attempted
3. **Verify database exists and is initialized**
4. **Test registration endpoint directly from server**
5. **Check for Python errors in backend console**

The "Internal Server Error" suggests a backend problem, not a frontend issue. Check server logs for the actual error.

