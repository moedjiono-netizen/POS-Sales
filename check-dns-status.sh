#!/bin/bash
# ================================================================
# Check DNS Status for amproject.my.id
# ================================================================

DOMAIN="amproject.my.id"
TARGET_IP="202.10.40.89"

echo "🔍 Checking DNS Status for $DOMAIN"
echo "================================================"
echo ""

# ================================================================
# 1. Check if dig/nslookup available
# ================================================================
if ! command -v dig &> /dev/null && ! command -v nslookup &> /dev/null; then
    echo "⚠️  Installing dnsutils..."
    sudo apt update && sudo apt install -y dnsutils
fi

# ================================================================
# 2. Check DNS Resolution
# ================================================================
echo "📡 DNS Resolution Check:"
echo "------------------------------------------------"

if command -v dig &> /dev/null; then
    RESOLVED_IP=$(dig +short $DOMAIN | grep -E '^[0-9.]+$' | head -1)
else
    RESOLVED_IP=$(nslookup $DOMAIN | grep -A1 "Name:" | grep "Address:" | awk '{print $2}' | head -1)
fi

if [ -z "$RESOLVED_IP" ]; then
    echo "❌ DNS not resolved yet"
    echo "   $DOMAIN → NO IP"
    echo ""
    echo "📋 Action needed:"
    echo "   1. Check your domain registrar DNS settings"
    echo "   2. Make sure A record points to: $TARGET_IP"
    echo "   3. Wait 5-60 minutes for DNS propagation"
    echo ""
    exit 1
elif [ "$RESOLVED_IP" = "$TARGET_IP" ]; then
    echo "✅ DNS correctly resolved"
    echo "   $DOMAIN → $RESOLVED_IP"
else
    echo "⚠️  DNS resolved but to wrong IP"
    echo "   $DOMAIN → $RESOLVED_IP"
    echo "   Expected: $TARGET_IP"
    echo ""
    echo "📋 Action needed:"
    echo "   Update DNS A record to point to: $TARGET_IP"
    exit 1
fi

echo ""

# ================================================================
# 3. Check DNS from multiple servers
# ================================================================
echo "🌍 DNS Propagation Check (multiple DNS servers):"
echo "------------------------------------------------"

DNS_SERVERS=(
    "8.8.8.8:Google"
    "1.1.1.1:Cloudflare"
    "208.67.222.222:OpenDNS"
)

for server in "${DNS_SERVERS[@]}"; do
    IFS=':' read -r dns_ip dns_name <<< "$server"
    result=$(dig @$dns_ip +short $DOMAIN | grep -E '^[0-9.]+$' | head -1)
    
    if [ -z "$result" ]; then
        echo "   ❌ $dns_name ($dns_ip): Not resolved"
    elif [ "$result" = "$TARGET_IP" ]; then
        echo "   ✅ $dns_name ($dns_ip): $result"
    else
        echo "   ⚠️  $dns_name ($dns_ip): $result (wrong IP)"
    fi
done

echo ""

# ================================================================
# 4. Check HTTPS/SSL
# ================================================================
echo "🔒 HTTPS/SSL Check:"
echo "------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://$DOMAIN 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ HTTPS is working (HTTP $HTTP_CODE)"
    
    # Check SSL certificate
    SSL_INFO=$(curl -vI https://$DOMAIN 2>&1 | grep -E 'SSL|subject|issuer' | head -3)
    echo "   Certificate info:"
    echo "$SSL_INFO" | sed 's/^/   /'
elif [ "$HTTP_CODE" = "000" ]; then
    echo "❌ Cannot connect to HTTPS"
    echo "   Possible reasons:"
    echo "   - Caddy not running"
    echo "   - Firewall blocking port 443"
    echo "   - DNS not propagated yet"
else
    echo "⚠️  HTTPS returned HTTP $HTTP_CODE"
fi

echo ""

# ================================================================
# 5. Check HTTP (should redirect to HTTPS)
# ================================================================
echo "🔄 HTTP Redirect Check:"
echo "------------------------------------------------"

HTTP_REDIRECT=$(curl -s -I --max-time 10 http://$DOMAIN 2>/dev/null | grep -i "location")

if [ ! -z "$HTTP_REDIRECT" ]; then
    echo "✅ HTTP redirects to HTTPS"
    echo "   $HTTP_REDIRECT"
else
    HTTP_CODE_80=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 http://$DOMAIN 2>/dev/null)
    echo "⚠️  No redirect found (HTTP $HTTP_CODE_80)"
fi

echo ""

# ================================================================
# 6. Check PocketBase Admin
# ================================================================
echo "🔧 PocketBase Admin Check:"
echo "------------------------------------------------"

ADMIN_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://$DOMAIN/_/ 2>/dev/null)

if [ "$ADMIN_CODE" = "200" ]; then
    echo "✅ PocketBase admin accessible at https://$DOMAIN/_/"
elif [ "$ADMIN_CODE" = "000" ]; then
    echo "❌ Cannot connect"
else
    echo "⚠️  Admin returned HTTP $ADMIN_CODE"
fi

echo ""

# ================================================================
# Summary
# ================================================================
echo "================================================"
echo "📊 SUMMARY"
echo "================================================"

if [ "$RESOLVED_IP" = "$TARGET_IP" ] && [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Everything looks good!"
    echo ""
    echo "🎉 Your site is live at:"
    echo "   https://amproject.my.id"
    echo "   https://amproject.my.id/_/"
elif [ "$RESOLVED_IP" = "$TARGET_IP" ]; then
    echo "⚠️  DNS is OK, but HTTPS not working yet"
    echo ""
    echo "📋 Next steps:"
    echo "   1. SSH to VPS: ssh root@202.10.40.89"
    echo "   2. Check Caddy: sudo systemctl status caddy"
    echo "   3. Check logs: sudo journalctl -u caddy -n 50"
else
    echo "❌ DNS not configured correctly"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Login to your domain registrar"
    echo "   2. Add A record: amproject.my.id → 202.10.40.89"
    echo "   3. Wait 5-60 minutes"
    echo "   4. Run this script again"
fi

echo ""
