#!/bin/bash
# ================================================================
# VPS Status Monitor - Quick Check
# ================================================================

VPS_IP="202.10.40.89"
VPS_USER="root"
VPS_PASSWORD="Agis1989"
DOMAIN="amproject.my.id"

echo "🖥️  VPS Status Monitor"
echo "================================================"
echo "VPS: $VPS_IP"
echo "Domain: $DOMAIN"
echo "================================================"
echo ""

# ================================================================
# 1. Check VPS Connection
# ================================================================
echo "🔌 Connection Check:"
echo "------------------------------------------------"

if ping -c 1 -W 2 $VPS_IP &> /dev/null; then
    echo "✅ VPS is reachable at $VPS_IP"
else
    echo "❌ Cannot reach VPS at $VPS_IP"
    exit 1
fi

# Install sshpass if needed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt update && sudo apt install -y sshpass 2>&1 | grep -v "Reading\|Building\|Unpacking\|Setting"
fi

echo ""

# ================================================================
# 2. Check Caddy Status
# ================================================================
echo "🌐 Caddy Status:"
echo "------------------------------------------------"

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${VPS_USER}@${VPS_IP} << 'ENDSSH'
if systemctl is-active --quiet caddy; then
    echo "✅ Caddy is running"
    caddy version 2>/dev/null || echo "   Version: installed"
else
    echo "❌ Caddy is not running"
    echo "   Start: sudo systemctl start caddy"
fi
ENDSSH

echo ""

# ================================================================
# 3. Check PocketBase Status
# ================================================================
echo "📦 PocketBase Status:"
echo "------------------------------------------------"

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${VPS_USER}@${VPS_IP} << 'ENDSSH'
if netstat -tuln 2>/dev/null | grep -q ':8090' || ss -tuln 2>/dev/null | grep -q ':8090'; then
    echo "✅ PocketBase is running on port 8090"
    
    # Check process
    PB_PID=$(ps aux | grep '[p]ocketbase' | awk '{print $2}' | head -1)
    if [ ! -z "$PB_PID" ]; then
        echo "   PID: $PB_PID"
        
        # Check uptime
        UPTIME=$(ps -p $PB_PID -o etime= 2>/dev/null | xargs)
        echo "   Uptime: $UPTIME"
    fi
else
    echo "❌ PocketBase is not running on port 8090"
    echo "   Check: ps aux | grep pocketbase"
    echo "   Start: ./pocketbase serve --http=0.0.0.0:8090"
fi
ENDSSH

echo ""

# ================================================================
# 4. Check Ports
# ================================================================
echo "🔓 Port Status:"
echo "------------------------------------------------"

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${VPS_USER}@${VPS_IP} << 'ENDSSH'
echo "   Port 80 (HTTP):"
if netstat -tuln 2>/dev/null | grep -q ':80 ' || ss -tuln 2>/dev/null | grep -q ':80 '; then
    echo "   ✅ Listening"
else
    echo "   ❌ Not listening"
fi

echo "   Port 443 (HTTPS):"
if netstat -tuln 2>/dev/null | grep -q ':443 ' || ss -tuln 2>/dev/null | grep -q ':443 '; then
    echo "   ✅ Listening"
else
    echo "   ❌ Not listening"
fi

echo "   Port 8090 (PocketBase):"
if netstat -tuln 2>/dev/null | grep -q ':8090 ' || ss -tuln 2>/dev/null | grep -q ':8090 '; then
    echo "   ✅ Listening"
else
    echo "   ❌ Not listening"
fi
ENDSSH

echo ""

# ================================================================
# 5. Check System Resources
# ================================================================
echo "💻 System Resources:"
echo "------------------------------------------------"

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${VPS_USER}@${VPS_IP} << 'ENDSSH'
# CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "   CPU Usage: ${CPU_USAGE}%"

# Memory
MEM_INFO=$(free -m | awk 'NR==2{printf "Used: %sMB / Total: %sMB (%.0f%%)", $3, $2, $3*100/$2}')
echo "   Memory: $MEM_INFO"

# Disk
DISK_INFO=$(df -h / | awk 'NR==2{printf "Used: %s / Total: %s (%s)", $3, $2, $5}')
echo "   Disk: $DISK_INFO"

# Uptime
UPTIME=$(uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')
echo "   Uptime: $UPTIME"
ENDSSH

echo ""

# ================================================================
# 6. Check Logs (last 5 lines)
# ================================================================
echo "📄 Recent Logs:"
echo "------------------------------------------------"

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${VPS_USER}@${VPS_IP} << 'ENDSSH'
echo "   Caddy (last 3 lines):"
sudo journalctl -u caddy -n 3 --no-pager 2>/dev/null | sed 's/^/   /'

if [ -f /var/log/caddy/amproject-access.log ]; then
    echo ""
    echo "   Access log (last 3 lines):"
    tail -n 3 /var/log/caddy/amproject-access.log 2>/dev/null | sed 's/^/   /'
fi
ENDSSH

echo ""

# ================================================================
# 7. Quick Web Test
# ================================================================
echo "🌐 Web Access Test:"
echo "------------------------------------------------"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 https://$DOMAIN 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ https://$DOMAIN is accessible (HTTP $HTTP_CODE)"
elif [ "$HTTP_CODE" = "000" ]; then
    echo "❌ Cannot connect to https://$DOMAIN"
else
    echo "⚠️  https://$DOMAIN returned HTTP $HTTP_CODE"
fi

ADMIN_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 https://$DOMAIN/_/ 2>/dev/null)
if [ "$ADMIN_CODE" = "200" ]; then
    echo "✅ Admin panel accessible at https://$DOMAIN/_/"
elif [ "$ADMIN_CODE" = "000" ]; then
    echo "❌ Cannot connect to admin panel"
else
    echo "⚠️  Admin panel returned HTTP $ADMIN_CODE"
fi

echo ""

# ================================================================
# Summary
# ================================================================
echo "================================================"
echo "📊 QUICK ACTIONS"
echo "================================================"
echo ""
echo "🔧 SSH to VPS:"
echo "   ssh root@$VPS_IP"
echo ""
echo "🔄 Restart Services:"
echo "   sudo systemctl restart caddy"
echo "   sudo systemctl restart pocketbase"
echo ""
echo "📊 View Logs:"
echo "   sudo journalctl -u caddy -f"
echo "   sudo journalctl -u pocketbase -f"
echo ""
echo "✅ Test URLs:"
echo "   https://$DOMAIN"
echo "   https://$DOMAIN/_/"
echo ""
