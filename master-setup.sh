#!/bin/bash
# ================================================================
# MASTER SETUP SCRIPT
# Complete VPS + Domain + SSL Setup
# ================================================================

VPS_IP="202.10.40.89"
VPS_USER="root"
VPS_PASSWORD="Agis1989"
DOMAIN="amproject.my.id"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         COMPLETE VPS SETUP FOR AMPROJECT.MY.ID          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configuration:"
echo "   VPS IP:    $VPS_IP"
echo "   Domain:    $DOMAIN"
echo "   User:      $VPS_USER"
echo ""
echo "⚠️  IMPORTANT: Before running this script, make sure:"
echo "   1. DNS A record for $DOMAIN points to $VPS_IP"
echo "   2. You have root/sudo access to the VPS"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted"
    exit 1
fi

echo ""

# ================================================================
# STEP 1: Check DNS
# ================================================================
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  STEP 1: Checking DNS Configuration                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

chmod +x check-dns-status.sh
./check-dns-status.sh

echo ""
read -p "DNS looks good? Continue with VPS setup? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please fix DNS first, then run this script again"
    exit 1
fi

echo ""

# ================================================================
# STEP 2: Setup Caddy + SSL
# ================================================================
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  STEP 2: Installing Caddy + SSL Setup                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Install sshpass if needed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt update && sudo apt install -y sshpass
fi

# Upload setup script
echo "📤 Uploading setup-domain-ssl.sh to VPS..."
chmod +x setup-domain-ssl.sh
sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    setup-domain-ssl.sh ${VPS_USER}@${VPS_IP}:/tmp/

# Run setup
echo "🔧 Running Caddy setup on VPS..."
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /tmp
chmod +x setup-domain-ssl.sh
./setup-domain-ssl.sh
ENDSSH

echo ""
echo "✅ Caddy setup complete!"
echo ""

sleep 2

# ================================================================
# STEP 3: Setup PocketBase Service
# ================================================================
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  STEP 3: Setting up PocketBase as systemd service       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Upload PocketBase service setup script
echo "📤 Uploading setup-pocketbase-service.sh to VPS..."
chmod +x setup-pocketbase-service.sh
sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    setup-pocketbase-service.sh ${VPS_USER}@${VPS_IP}:/tmp/

# Run PocketBase service setup
echo "🔧 Setting up PocketBase service..."
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /tmp
chmod +x setup-pocketbase-service.sh
./setup-pocketbase-service.sh
ENDSSH

echo ""
echo "✅ PocketBase service setup complete!"
echo ""

sleep 2

# ================================================================
# STEP 4: Final Verification
# ================================================================
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  STEP 4: Final Verification                             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "⏳ Waiting for services to stabilize (10 seconds)..."
sleep 10

chmod +x monitor-vps.sh
./monitor-vps.sh

echo ""

# ================================================================
# STEP 5: Test URLs
# ================================================================
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  STEP 5: Testing URLs                                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "🧪 Testing https://$DOMAIN ..."
MAIN_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://$DOMAIN 2>/dev/null)

if [ "$MAIN_CODE" = "200" ]; then
    echo "✅ Main site: OK"
else
    echo "⚠️  Main site: HTTP $MAIN_CODE"
fi

echo "🧪 Testing https://$DOMAIN/_/ ..."
ADMIN_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://$DOMAIN/_/ 2>/dev/null)

if [ "$ADMIN_CODE" = "200" ]; then
    echo "✅ Admin panel: OK"
else
    echo "⚠️  Admin panel: HTTP $ADMIN_CODE"
fi

echo ""

# ================================================================
# FINAL SUMMARY
# ================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    🎉 SETUP COMPLETE!                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

if [ "$MAIN_CODE" = "200" ] && [ "$ADMIN_CODE" = "200" ]; then
    echo "✅ All systems operational!"
    echo ""
    echo "🌐 Your sites are live:"
    echo "   📱 Main app:     https://$DOMAIN"
    echo "   ⚙️  Admin panel:  https://$DOMAIN/_/"
    echo ""
    echo "🎯 Next Steps:"
    echo "   1. Open https://$DOMAIN in your browser"
    echo "   2. Login to admin panel at https://$DOMAIN/_/"
    echo "   3. Your app files at: /workspaces/POS-Sales/"
    echo ""
    echo "📊 Monitoring:"
    echo "   Run: ./monitor-vps.sh"
    echo ""
    echo "🔐 Security reminders:"
    echo "   - Change VPS root password regularly"
    echo "   - Enable SSH key authentication"
    echo "   - Setup fail2ban for SSH protection"
    echo "   - Regular backups of PocketBase data"
    echo ""
else
    echo "⚠️  Setup completed but some services may need attention"
    echo ""
    echo "📋 Troubleshooting:"
    echo "   1. Check DNS: ./check-dns-status.sh"
    echo "   2. Check VPS: ./monitor-vps.sh"
    echo "   3. SSH to VPS: ssh root@$VPS_IP"
    echo "   4. View logs: sudo journalctl -u caddy -f"
    echo "   5. View logs: sudo journalctl -u pocketbase -f"
    echo ""
fi

echo "📚 Documentation: ./DNS-SETUP-GUIDE.md"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
