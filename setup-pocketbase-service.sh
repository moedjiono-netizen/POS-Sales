#!/bin/bash
# ================================================================
# Setup PocketBase as Systemd Service
# Run this script ON THE VPS (202.10.40.89)
# ================================================================

set -e

echo "🚀 Setting up PocketBase as systemd service"
echo "================================================"
echo ""

# ================================================================
# 1. Detect PocketBase location
# ================================================================
echo "🔍 Detecting PocketBase installation..."

# Common locations
LOCATIONS=(
    "/root/pocketbase/pocketbase"
    "/opt/pocketbase/pocketbase"
    "/home/*/pocketbase/pocketbase"
    "$HOME/pocketbase/pocketbase"
    "$(which pocketbase 2>/dev/null)"
)

PB_PATH=""
for loc in "${LOCATIONS[@]}"; do
    if [ -f "$loc" ] && [ -x "$loc" ]; then
        PB_PATH="$loc"
        break
    fi
done

# If not found, ask user
if [ -z "$PB_PATH" ]; then
    echo "⚠️  PocketBase not found in common locations"
    echo ""
    read -p "Enter full path to pocketbase binary: " PB_PATH
    
    if [ ! -f "$PB_PATH" ]; then
        echo "❌ File not found: $PB_PATH"
        exit 1
    fi
fi

PB_DIR=$(dirname "$PB_PATH")
echo "✅ Found PocketBase at: $PB_PATH"
echo "   Working directory: $PB_DIR"
echo ""

# ================================================================
# 2. Detect user
# ================================================================
if [ "$EUID" -eq 0 ]; then
    PB_USER="root"
else
    PB_USER="$USER"
fi

echo "📋 Service will run as user: $PB_USER"
echo ""

# ================================================================
# 3. Create systemd service file
# ================================================================
echo "📝 Creating systemd service file..."

sudo tee /etc/systemd/system/pocketbase.service > /dev/null <<EOF
[Unit]
Description=PocketBase Backend Service
Documentation=https://pocketbase.io/docs/
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=$PB_USER
WorkingDirectory=$PB_DIR
ExecStart=$PB_PATH serve --http=0.0.0.0:8090

# Restart on failure
Restart=always
RestartSec=5

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$PB_DIR

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=pocketbase

# Resource limits (opsional, sesuaikan dengan kebutuhan)
# LimitNOFILE=65536
# MemoryMax=2G
# CPUQuota=50%

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Service file created at /etc/systemd/system/pocketbase.service"
echo ""

# ================================================================
# 4. Set permissions
# ================================================================
echo "🔒 Setting permissions..."
sudo chmod 644 /etc/systemd/system/pocketbase.service
sudo chown root:root /etc/systemd/system/pocketbase.service

# Make sure PocketBase is executable
chmod +x "$PB_PATH"

echo "✅ Permissions set"
echo ""

# ================================================================
# 5. Reload systemd
# ================================================================
echo "🔄 Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "✅ Systemd daemon reloaded"
echo ""

# ================================================================
# 6. Enable and start service
# ================================================================
echo "🚀 Enabling PocketBase service..."
sudo systemctl enable pocketbase

echo "▶️  Starting PocketBase service..."
sudo systemctl start pocketbase

echo ""
echo "⏳ Waiting for service to start..."
sleep 3

# ================================================================
# 7. Check status
# ================================================================
echo "📊 Service Status:"
echo "------------------------------------------------"
sudo systemctl status pocketbase --no-pager | head -n 15
echo ""

# ================================================================
# 8. Verify it's running
# ================================================================
echo "🔍 Verification:"
echo "------------------------------------------------"

if sudo systemctl is-active --quiet pocketbase; then
    echo "✅ PocketBase service is running"
    
    # Check port
    if netstat -tuln 2>/dev/null | grep -q ':8090' || ss -tuln 2>/dev/null | grep -q ':8090'; then
        echo "✅ Port 8090 is listening"
    else
        echo "⚠️  Port 8090 not listening yet (wait a moment)"
    fi
    
    # Test HTTP
    sleep 2
    if curl -s --max-time 5 http://localhost:8090/api/health > /dev/null 2>&1; then
        echo "✅ PocketBase API responding"
    else
        echo "⚠️  API not responding yet (check logs)"
    fi
else
    echo "❌ PocketBase service failed to start"
    echo ""
    echo "📄 View logs:"
    echo "   sudo journalctl -u pocketbase -n 50"
fi

echo ""

# ================================================================
# Summary
# ================================================================
echo "================================================"
echo "✅ SETUP COMPLETE!"
echo "================================================"
echo ""
echo "📋 Service Information:"
echo "   Name: pocketbase"
echo "   Path: $PB_PATH"
echo "   User: $PB_USER"
echo "   Port: 8090"
echo ""
echo "🔧 Useful Commands:"
echo "   Status:   sudo systemctl status pocketbase"
echo "   Start:    sudo systemctl start pocketbase"
echo "   Stop:     sudo systemctl stop pocketbase"
echo "   Restart:  sudo systemctl restart pocketbase"
echo "   Logs:     sudo journalctl -u pocketbase -f"
echo "   Enable:   sudo systemctl enable pocketbase"
echo "   Disable:  sudo systemctl disable pocketbase"
echo ""
echo "✅ PocketBase will now:"
echo "   - Start automatically on boot"
echo "   - Restart automatically if it crashes"
echo "   - Run in the background"
echo ""
echo "🌐 Test your setup:"
echo "   http://localhost:8090"
echo "   http://localhost:8090/_/"
echo ""
