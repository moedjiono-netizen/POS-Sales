#!/bin/bash
# ================================================================
# Backup VPS Data Before Setup
# ================================================================

VPS_IP="202.10.40.89"
VPS_USER="root"
VPS_PASSWORD="Agis1989"
BACKUP_DIR="./vps-backup-$(date +%Y%m%d-%H%M%S)"

echo "🔒 VPS Data Backup"
echo "================================================"
echo "VPS: $VPS_IP"
echo "Backup to: $BACKUP_DIR"
echo "================================================"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Install sshpass if needed
if ! command -v sshpass &> /dev/null; then
    echo "📦 Installing sshpass..."
    sudo apt update && sudo apt install -y sshpass
fi

echo "🔍 Checking VPS connection..."
if ! ping -c 1 -W 2 $VPS_IP &> /dev/null; then
    echo "❌ Cannot reach VPS at $VPS_IP"
    exit 1
fi
echo "✅ VPS is reachable"
echo ""

# ================================================================
# Backup PocketBase data
# ================================================================
echo "📦 Backing up PocketBase data..."

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
echo "🔍 Searching for PocketBase installations..."

# Find PocketBase directories
PB_DIRS=$(find /root /home /opt -type d -name "pb_data" 2>/dev/null | head -5)

if [ -z "$PB_DIRS" ]; then
    echo "⚠️  No PocketBase data found"
    echo "BACKUP_STATUS=NONE" > /tmp/backup_status.txt
else
    echo "✅ Found PocketBase data:"
    echo "$PB_DIRS" | sed 's/^/   /'
    
    # Create backup archive
    BACKUP_FILE="/tmp/pocketbase-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    echo ""
    echo "📦 Creating backup archive..."
    tar -czf "$BACKUP_FILE" $PB_DIRS 2>/dev/null
    
    if [ -f "$BACKUP_FILE" ]; then
        SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        echo "✅ Backup created: $BACKUP_FILE ($SIZE)"
        echo "BACKUP_FILE=$BACKUP_FILE" > /tmp/backup_status.txt
        echo "BACKUP_STATUS=SUCCESS" >> /tmp/backup_status.txt
    else
        echo "❌ Failed to create backup"
        echo "BACKUP_STATUS=FAILED" > /tmp/backup_status.txt
    fi
fi
ENDSSH

# Download backup status
BACKUP_STATUS=$(sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} "cat /tmp/backup_status.txt 2>/dev/null")

echo ""
echo "$BACKUP_STATUS"

# Download backup file if exists
BACKUP_FILE=$(echo "$BACKUP_STATUS" | grep "BACKUP_FILE=" | cut -d'=' -f2)
STATUS=$(echo "$BACKUP_STATUS" | grep "BACKUP_STATUS=" | cut -d'=' -f2)

if [ "$STATUS" = "SUCCESS" ] && [ ! -z "$BACKUP_FILE" ]; then
    echo ""
    echo "📥 Downloading backup from VPS..."
    
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
        ${VPS_USER}@${VPS_IP}:"$BACKUP_FILE" "$BACKUP_DIR/"
    
    if [ $? -eq 0 ]; then
        LOCAL_BACKUP="$BACKUP_DIR/$(basename $BACKUP_FILE)"
        SIZE=$(du -h "$LOCAL_BACKUP" | cut -f1)
        echo "✅ Backup downloaded: $LOCAL_BACKUP ($SIZE)"
    else
        echo "⚠️  Failed to download backup"
    fi
fi

# ================================================================
# Backup Caddy config if exists
# ================================================================
echo ""
echo "📦 Backing up Caddy config..."

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
if [ -f /etc/caddy/Caddyfile ]; then
    echo "✅ Found Caddyfile"
    cp /etc/caddy/Caddyfile /tmp/Caddyfile.backup 2>/dev/null
    echo "CADDY_BACKUP=YES" > /tmp/caddy_status.txt
else
    echo "⚠️  No Caddyfile found (fresh install)"
    echo "CADDY_BACKUP=NO" > /tmp/caddy_status.txt
fi
ENDSSH

CADDY_STATUS=$(sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} "cat /tmp/caddy_status.txt 2>/dev/null | grep CADDY_BACKUP= | cut -d'=' -f2")

if [ "$CADDY_STATUS" = "YES" ]; then
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
        ${VPS_USER}@${VPS_IP}:/tmp/Caddyfile.backup "$BACKUP_DIR/" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Caddyfile backed up to: $BACKUP_DIR/Caddyfile.backup"
    fi
fi

# ================================================================
# Backup systemd services
# ================================================================
echo ""
echo "📦 Backing up systemd services..."

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} << 'ENDSSH'
if [ -f /etc/systemd/system/pocketbase.service ]; then
    echo "✅ Found pocketbase.service"
    cp /etc/systemd/system/pocketbase.service /tmp/pocketbase.service.backup 2>/dev/null
fi
ENDSSH

sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    ${VPS_USER}@${VPS_IP}:/tmp/pocketbase.service.backup "$BACKUP_DIR/" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ pocketbase.service backed up"
fi

# ================================================================
# Summary
# ================================================================
echo ""
echo "================================================"
echo "✅ BACKUP COMPLETE"
echo "================================================"
echo ""
echo "📁 Backup location: $BACKUP_DIR"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo "📋 Backed up files:"
    ls -lh "$BACKUP_DIR" | tail -n +2 | awk '{print "   " $9 " (" $5 ")"}'
    echo ""
    
    TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    echo "💾 Total backup size: $TOTAL_SIZE"
fi

echo ""
echo "✅ Safe to proceed with setup"
echo ""
