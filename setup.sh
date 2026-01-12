#!/bin/bash
# Lokum VPN - Complete Setup Script
# This script sets up the entire Lokum VPN project

set -e

echo "=== Lokum VPN - Complete Setup ==="

# Check prerequisites first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/check-prerequisites.sh" ]; then
    if ! "$SCRIPT_DIR/check-prerequisites.sh"; then
        echo ""
        echo "Please install missing prerequisites and run setup.sh again."
        exit 1
    fi
else
    # Fallback check if prerequisite script doesn't exist
    if ! command -v python3 &> /dev/null; then
        echo "Error: Python 3 is required but not installed."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo "Python version: $PYTHON_VERSION"
fi

# Setup Backend
echo ""
echo "=== Setting up Backend ==="
cd backend

# Check if python3-venv is available
if ! python3 -m venv --help > /dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo "Error: python3-venv module is not available."
    echo "Please install it with:"
    echo "  sudo apt install python3-venv"
    echo "Or for Python 3.13:"
    echo "  sudo apt install python3.13-venv"
    exit 1
fi

# Remove incomplete venv if it exists
if [ -d "venv" ] && [ ! -f "venv/bin/activate" ]; then
    echo "Removing incomplete virtual environment..."
    rm -rf venv
fi

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    
    # Try creating venv normally first
    VENV_OUTPUT=$(python3 -m venv venv 2>&1)
    VENV_EXIT=$?
    
    if [ $VENV_EXIT -ne 0 ] || echo "$VENV_OUTPUT" | grep -q "ensurepip"; then
        echo "ensurepip is not available. Creating venv without pip and installing pip manually..."
        
        # Create venv without pip
        if python3 -m venv --without-pip venv 2>&1; then
            echo "Virtual environment created. Installing pip manually..."
            
            # Download and install pip using get-pip.py
            if curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py 2>/dev/null; then
                if venv/bin/python3 /tmp/get-pip.py --disable-pip-version-check --quiet 2>&1; then
                    rm -f /tmp/get-pip.py
                    echo "pip installed successfully in virtual environment."
                else
                    echo "Warning: Failed to install pip using get-pip.py. Trying alternative method..."
                    rm -f /tmp/get-pip.py
                    
                    # Alternative: copy pip from system if available
                    if python3 -m pip --version > /dev/null 2>&1; then
                        echo "Using system pip to install pip in venv..."
                        venv/bin/python3 -m pip install --upgrade pip --quiet 2>&1 || {
                            echo "Error: Failed to install pip in virtual environment."
                            echo ""
                            echo "Please install python3.13-full which includes ensurepip:"
                            echo "  sudo apt install python3.13-full"
                            echo ""
                            echo "Or manually install pip in the venv after setup."
                            rm -rf venv
                            exit 1
                        }
                    else
                        echo "Error: Cannot install pip. Please install python3.13-full:"
                        echo "  sudo apt install python3.13-full"
                        rm -rf venv
                        exit 1
                    fi
                fi
            else
                echo "Error: Could not download get-pip.py. Please check your internet connection."
                echo "Or install python3.13-full which includes ensurepip:"
                echo "  sudo apt install python3.13-full"
                rm -rf venv
                exit 1
            fi
        else
            echo "Error: Failed to create virtual environment even without pip."
            echo "$VENV_OUTPUT"
            echo ""
            echo "Please install python3.13-full which includes ensurepip:"
            echo "  sudo apt install python3.13-full"
            rm -rf venv 2>/dev/null
            exit 1
        fi
    fi
fi

# Verify venv was created successfully
if [ ! -f "venv/bin/activate" ]; then
    echo "Error: Virtual environment was not created successfully."
    echo "The venv/bin/activate file is missing."
    rm -rf venv 2>/dev/null
    exit 1
fi

# Verify pip is available in venv
if ! venv/bin/python3 -m pip --version > /dev/null 2>&1; then
    echo "Warning: pip is not available in virtual environment. Attempting to install..."
    
    # Try to install pip manually
    if curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py 2>/dev/null; then
        venv/bin/python3 /tmp/get-pip.py --disable-pip-version-check --quiet
        rm -f /tmp/get-pip.py
    elif python3 -m pip --version > /dev/null 2>&1; then
        venv/bin/python3 -m pip install --upgrade pip --quiet
    fi
    
    # Verify again
    if ! venv/bin/python3 -m pip --version > /dev/null 2>&1; then
        echo "Error: pip is still not available in virtual environment."
        echo "Please install python3.13-full which includes ensurepip:"
        echo "  sudo apt install python3.13-full"
        echo ""
        echo "Then remove the venv directory and run setup.sh again."
        exit 1
    fi
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate || {
    echo "Error: Failed to activate virtual environment."
    echo "Please check that venv/bin/activate exists and is executable."
    exit 1
}

# Install dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env <<EOF
SECRET_KEY=$(openssl rand -hex 32)
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
DATABASE_URL=sqlite:///./lokum_vpn.db
API_HOST=0.0.0.0
API_PORT=8000
VPN_MANAGEMENT_PATH=/var/lib/lokum-vpn
VPN_WG_CONFIG_PATH=/etc/wireguard
ADBLOCK_LIST_URL=https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
MALWARE_LIST_URL=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
EOF
    echo ".env file created with secure SECRET_KEY"
fi

# Create data directory
sudo mkdir -p /var/lib/lokum-vpn
sudo chown $USER:$USER /var/lib/lokum-vpn

# Initialize database
echo "Initializing database..."
python3 -c "from app.database import init_db; import asyncio; asyncio.run(init_db())"

cd ..

# Setup Mobile App
echo ""
echo "=== Setting up Mobile App ==="
cd mobile

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "Warning: Flutter is not installed."
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    echo "After installing Flutter, run: cd mobile && flutter pub get"
else
    echo "Flutter found, installing dependencies..."
    flutter pub get
    echo "Mobile app dependencies installed"
fi

cd ..

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To start the backend:"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  uvicorn main:app --reload --host 0.0.0.0 --port 8000"
echo ""
echo "To run the mobile app:"
echo "  cd mobile"
echo "  flutter run"
echo ""
echo "To setup VPN server:"
echo "  cd vpn-server"
echo "  sudo ./setup-wireguard.sh"
echo ""
echo "Don't forget to:"
echo "  1. Configure your API_BASE_URL in mobile/lib/config/config.dart"
echo "  2. Add VPN servers using the backend API or admin interface"
echo "  3. Update SECRET_KEY in backend/.env for production"
echo ""

