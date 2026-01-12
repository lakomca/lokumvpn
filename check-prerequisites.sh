#!/bin/bash
# Check prerequisites for Lokum VPN setup

echo "=== Checking Prerequisites for Lokum VPN ==="
echo ""

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python found: $PYTHON_VERSION"
    
    # Check if venv module is available
    if python3 -m venv --help > /dev/null 2>&1; then
        echo "✅ venv module is available"
    else
        echo "❌ venv module not found"
        echo "   This is unusual - venv should be built into Python 3.3+"
        exit 1
    fi
    
    # Check if pip is available (required for ensurepip)
    if python3 -m pip --version > /dev/null 2>&1; then
        echo "✅ pip is available"
        
        # Try to actually create a test venv
        TEST_VENV="/tmp/test_venv_$$"
        VENV_OUTPUT=$(python3 -m venv "$TEST_VENV" 2>&1)
        VENV_EXIT=$?
        
        if [ $VENV_EXIT -eq 0 ] && [ -f "$TEST_VENV/bin/activate" ]; then
            # Check if pip is available in venv
            if "$TEST_VENV/bin/python3" -m pip --version > /dev/null 2>&1; then
                echo "✅ Virtual environment creation is working with pip"
                rm -rf "$TEST_VENV"
            else
                echo "⚠️  Virtual environment can be created, but pip is not available"
                echo "   This means ensurepip is not available, but setup will work around this"
                echo "   The setup script will install pip manually using get-pip.py"
                rm -rf "$TEST_VENV"
            fi
        else
            rm -rf "$TEST_VENV" 2>/dev/null
            
            if echo "$VENV_OUTPUT" | grep -q "ensurepip"; then
                echo "⚠️  Virtual environment creation requires ensurepip (not available)"
                echo "   But setup script will work around this by using --without-pip"
                echo ""
                echo "   For best results, install python3.13-full which includes ensurepip:"
                echo "     sudo apt install python3.13-full"
                echo ""
                echo "   However, the setup script will still work by installing pip manually."
            else
                echo "❌ Virtual environment creation failed"
                echo "   Error: $VENV_OUTPUT"
                exit 1
            fi
        fi
    else
        echo "❌ pip is not available"
        echo "   Install it with: sudo apt install python3-pip"
        echo ""
        echo "   Note: pip is required for creating virtual environments"
        echo "   python3-pip also provides ensurepip module needed by venv"
        exit 1
    fi
else
    echo "❌ Python 3 is not installed"
    echo "   Install it with: sudo apt install python3 python3-pip"
    exit 1
fi

# (pip check is already done above as part of venv check)

# Check Flutter (optional)
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -1)
    echo "✅ Flutter found: $FLUTTER_VERSION"
else
    echo "⚠️  Flutter is not installed (optional for mobile app)"
    echo "   Install from: https://flutter.dev/docs/get-started/install"
fi

# Check WireGuard (optional)
if command -v wg &> /dev/null; then
    echo "✅ WireGuard tools found"
else
    echo "⚠️  WireGuard is not installed (optional for VPN server)"
    echo "   Install with: sudo apt install wireguard wireguard-tools"
fi

echo ""
echo "=== Prerequisites Check Complete ==="
echo ""

