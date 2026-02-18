#!/bin/bash
# ================================================================
# Run Setup on VPS 202.10.40.89
# ================================================================

VPS_IP="202.10.40.89"
VPS_USER="root"  # Biasanya root, atau ganti dengan user Anda
VPS_PASSWORD="Agis1989"

echo "🚀 Connecting to VPS $VPS_IP..."
echo ""

# ================================================================
# Install sshpass jika belum ada
# ================================================================
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt update && sudo apt install -y sshpass
fi

# ================================================================
# Upload setup script ke VPS
# ================================================================
echo "📤 Uploading setup script to VPS..."
sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    setup-domain-ssl.sh ${VPS_USER}@${VPS_IP}:/tmp/

# ================================================================
# Make executable and run
# ================================================================
echo "🔧 Running setup on VPS..."
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /tmp
chmod +x setup-domain-ssl.sh
./setup-domain-ssl.sh
ENDSSH

echo ""
echo "================================================"
echo "✅ Setup completed on VPS!"
echo "================================================"
echo ""
echo "📋 IMPORTANT - DNS Configuration:"
echo "   Login to your domain registrar and add:"
echo "   Type: A"
echo "   Name: @"
echo "   Value: 202.10.40.89"
echo "   TTL: 3600"
echo ""
echo "   Type: A"
echo "   Name: www"
echo "   Value: 202.10.40.89"
echo "   TTL: 3600"
echo ""
echo "⏳ DNS propagation may take 5-60 minutes"
echo ""
echo "🧪 Test when ready:"
echo "   https://amproject.my.id"
echo ""
