# Installing Prerequisites for Lokum VPN

## Quick Install

### Option 1: Install python3.13-full (Recommended)

For Python 3.13, install the full package which includes ensurepip:

```bash
sudo apt update
sudo apt install python3.13-full
```

This includes ensurepip and everything needed for virtual environments.

### Option 2: Install python3-pip (Setup will work around missing ensurepip)

If python3.13-full is not available, install python3-pip:

```bash
sudo apt update
sudo apt install python3-pip
```

**Note:** On Python 3.13, ensurepip may still not be available even with python3-pip. The setup script will automatically work around this by using `--without-pip` and installing pip manually using `get-pip.py`.

## Troubleshooting

### If python3-pip doesn't solve the issue:

1. **Try installing python3-full** (includes everything):
   ```bash
   sudo apt install python3-full
   ```

2. **Or try installing python3-venv separately** (if available for your Python version):
   ```bash
   sudo apt install python3-venv
   ```

3. **For Python 3.13 specifically**, you might need to:
   ```bash
   sudo apt install python3.13-full
   ```

### Alternative: Use virtualenv instead of venv

If venv doesn't work, you can use virtualenv:

```bash
# Install virtualenv
sudo apt install python3-virtualenv
# OR: python3 -m pip install --user virtualenv

# Then use it instead of venv
virtualenv venv
# OR: python3 -m virtualenv venv
```

### Verify Installation

After installing, verify everything works:

```bash
# Check Python
python3 --version

# Check pip
python3 -m pip --version

# Check venv
python3 -m venv --help

# Test venv creation
python3 -m venv test_venv && rm -rf test_venv && echo "✅ venv works!"
```

## Why This is Needed

The `venv` module (built into Python 3.3+) requires the `ensurepip` module to install pip in virtual environments. On Debian/Ubuntu systems, this is typically provided by the `python3-pip` package.

Without `ensurepip`, you'll see errors like:
- "ensurepip is not available"
- "No module named ensurepip"
- "The virtual environment was not created successfully"

Installing `python3-pip` should resolve these issues.
