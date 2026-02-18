#!/bin/bash
# ================================================================
# Setup Domain amproject.my.id dengan SSL/HTTPS + Reverse Proxy
# ================================================================
# VPS: 202.10.40.89
# Domain: amproject.my.id
# Backend: PocketBase di localhost:8090
# ================================================================

set -e

echo "🚀 Setup Domain amproject.my.id dengan SSL/HTTPS"
echo "================================================"
echo ""

# ================================================================
# 1. Install Caddy Web Server
# ================================================================
echo "📦 Installing Caddy..."
sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy

echo "✅ Caddy installed"
echo ""

# ================================================================
# 2. Create Caddyfile Configuration
# ================================================================
echo "📝 Creating Caddyfile..."

sudo tee /etc/caddy/Caddyfile > /dev/null <<'EOF'
# ================================================================
# Caddy Configuration for amproject.my.id
# Auto HTTPS dengan Let's Encrypt
# ================================================================

amproject.my.id {
    # Reverse proxy ke PocketBase
    reverse_proxy localhost:8090 {
        # Headers untuk WebSocket support (realtime)
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Proto {scheme}
        
        # Timeout untuk long-polling
        transport http {
            read_timeout 300s
            write_timeout 300s
        }
    }
    
    # Security headers
    header {
        # Enable HSTS
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        # Prevent clickjacking
        X-Frame-Options "SAMEORIGIN"
        # XSS protection
        X-Content-Type-Options "nosniff"
        X-XSS-Protection "1; mode=block"
        # Referrer policy
        Referrer-Policy "strict-origin-when-cross-origin"
    }
    
    # Enable compression
    encode gzip zstd
    
    # Log
    log {
        output file /var/log/caddy/amproject-access.log
        format console
    }
}

# Redirect www to non-www
www.amproject.my.id {
    redir https://amproject.my.id{uri} permanent
}
EOF

echo "✅ Caddyfile created"
echo ""

# ================================================================
# 3. Create log directory
# ================================================================
sudo mkdir -p /var/log/caddy
sudo chown caddy:caddy /var/log/caddy

# ================================================================
# 4. Restart Caddy
# ================================================================
echo "🔄 Restarting Caddy..."
sudo systemctl enable caddy
sudo systemctl restart caddy
sudo systemctl status caddy --no-pager

echo ""
echo "✅ Caddy is running"
echo ""

# ================================================================
# 5. Check firewall
# ================================================================
echo "🔥 Configuring firewall..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 8090/tcp  # PocketBase (jika perlu akses langsung)
    echo "✅ Firewall configured (ufw)"
elif command -v firewall-cmd &> /dev/null; then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --permanent --add-port=8090/tcp
    sudo firewall-cmd --reload
    echo "✅ Firewall configured (firewalld)"
else
    echo "⚠️  No firewall detected. Make sure ports 80, 443, and 8090 are open."
fi

echo ""

# ================================================================
# 6. Verify Setup
# ================================================================
echo "🔍 Verification:"
echo "================================================"
echo ""
echo "✅ Caddy Status:"
sudo systemctl status caddy --no-pager | head -n 5
echo ""
echo "✅ Caddy Version:"
caddy version
echo ""
echo "✅ SSL Certificate:"
echo "   Caddy will automatically obtain Let's Encrypt certificate"
echo "   when you access https://amproject.my.id"
echo ""
echo "================================================"
echo "🎉 SETUP COMPLETE!"
echo "================================================"
echo ""
echo "📋 Next Steps:"
echo "1. Make sure DNS A Record points to: 202.10.40.89"
echo "   amproject.my.id → 202.10.40.89"
echo ""
echo "2. Make sure PocketBase is running on port 8090:"
echo "   ./pocketbase serve --http=0.0.0.0:8090"
echo ""
echo "3. Test your domain:"
echo "   https://amproject.my.id"
echo ""
echo "4. Check Caddy logs:"
echo "   sudo journalctl -u caddy -f"
echo "   sudo tail -f /var/log/caddy/amproject-access.log"
echo ""
echo "5. Check SSL certificate:"
echo "   curl -I https://amproject.my.id"
echo ""
echo "================================================"
