#!/bin/bash
# ================================================================
# DNS Monitor - Auto Check sampai DNS resolve
# ================================================================

DOMAIN="amproject.my.id"
TARGET_IP="202.10.40.89"
CHECK_INTERVAL=30  # Check setiap 30 detik
MAX_ATTEMPTS=120   # Max 1 jam (120 x 30 detik)

echo "🔄 DNS Monitor - Automatic Checking"
echo "================================================"
echo "Domain: $DOMAIN"
echo "Target IP: $TARGET_IP"
echo "Check interval: ${CHECK_INTERVAL}s"
echo "Max duration: $((MAX_ATTEMPTS * CHECK_INTERVAL / 60)) minutes"
echo "================================================"
echo ""

attempt=0
while [ $attempt -lt $MAX_ATTEMPTS ]; do
    attempt=$((attempt + 1))
    elapsed=$((attempt * CHECK_INTERVAL))
    elapsed_min=$((elapsed / 60))
    elapsed_sec=$((elapsed % 60))
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⏱️  Check #$attempt (Elapsed: ${elapsed_min}m ${elapsed_sec}s)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Check DNS resolution
    RESOLVED_IP=$(dig +short $DOMAIN | grep -E '^[0-9.]+$' | head -1)
    
    if [ ! -z "$RESOLVED_IP" ]; then
        if [ "$RESOLVED_IP" = "$TARGET_IP" ]; then
            echo ""
            echo "╔══════════════════════════════════════════╗"
            echo "║   ✅ DNS PROPAGATION SUCCESSFUL! ✅      ║"
            echo "╚══════════════════════════════════════════╝"
            echo ""
            echo "🎉 Domain resolved correctly!"
            echo "   $DOMAIN → $RESOLVED_IP"
            echo ""
            echo "⏱️  Time taken: ${elapsed_min}m ${elapsed_sec}s"
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🚀 NEXT STEPS:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "1. Restart Caddy untuk SSL certificate:"
            echo "   ssh root@$TARGET_IP"
            echo "   sudo systemctl restart caddy"
            echo ""
            echo "2. Wait 1-2 minutes for SSL certificate"
            echo ""
            echo "3. Test website:"
            echo "   https://$DOMAIN"
            echo "   https://$DOMAIN/_/"
            echo ""
            echo "4. Monitor VPS:"
            echo "   ./monitor-vps.sh"
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            
            # Auto restart Caddy
            echo ""
            read -p "Auto restart Caddy now? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "🔄 Restarting Caddy..."
                sshpass -p "Agis1989" ssh -o StrictHostKeyChecking=no root@$TARGET_IP "systemctl restart caddy && echo '✅ Caddy restarted' && sleep 3 && systemctl status caddy --no-pager | head -5"
                
                echo ""
                echo "⏳ Waiting for SSL certificate (30 seconds)..."
                sleep 30
                
                echo "🧪 Testing HTTPS..."
                curl -I -s --max-time 10 https://$DOMAIN | head -5
            fi
            
            exit 0
        else
            echo "⚠️  DNS resolved but to wrong IP:"
            echo "   Got: $RESOLVED_IP"
            echo "   Expected: $TARGET_IP"
            echo ""
            echo "   Please check your DNS settings"
            echo "   Then run this script again"
            exit 1
        fi
    else
        echo "❌ DNS not resolved yet"
        echo "   $DOMAIN → (no response)"
        
        # Check from multiple DNS servers
        echo ""
        echo "📡 Checking from multiple DNS servers:"
        
        GOOGLE_DNS=$(dig @8.8.8.8 +short $DOMAIN 2>/dev/null | grep -E '^[0-9.]+$' | head -1)
        if [ ! -z "$GOOGLE_DNS" ]; then
            echo "   Google (8.8.8.8): $GOOGLE_DNS"
        else
            echo "   Google (8.8.8.8): ❌ Not resolved"
        fi
        
        CF_DNS=$(dig @1.1.1.1 +short $DOMAIN 2>/dev/null | grep -E '^[0-9.]+$' | head -1)
        if [ ! -z "$CF_DNS" ]; then
            echo "   Cloudflare (1.1.1.1): $CF_DNS"
        else
            echo "   Cloudflare (1.1.1.1): ❌ Not resolved"
        fi
    fi
    
    # Wait before next check
    if [ $attempt -lt $MAX_ATTEMPTS ]; then
        echo ""
        echo "⏳ Next check in ${CHECK_INTERVAL} seconds..."
        echo "   (Press Ctrl+C to stop monitoring)"
        sleep $CHECK_INTERVAL
        echo ""
    fi
done

echo ""
echo "⏱️  Timeout reached (${MAX_ATTEMPTS} attempts)"
echo ""
echo "DNS still not propagated after $((MAX_ATTEMPTS * CHECK_INTERVAL / 60)) minutes"
echo ""
echo "📋 Possible issues:"
echo "   1. DNS not configured correctly at registrar"
echo "   2. Need more time (up to 24-48 hours for some providers)"
echo "   3. DNS settings not saved"
echo ""
echo "🔍 Verify your DNS settings:"
echo "   - Login to domain registrar"
echo "   - Check A record: @ → $TARGET_IP"
echo "   - Check A record: www → $TARGET_IP"
echo "   - Ensure changes are saved"
echo ""
echo "📖 See: DNS-RECORD-TUTORIAL.md for detailed guide"
echo ""

exit 1
