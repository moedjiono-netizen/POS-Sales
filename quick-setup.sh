#!/bin/bash
# Quick Setup untuk iFix Pro PocketBase Collections

ADMIN_EMAIL="${1:-admin@admin.com}"
ADMIN_PASSWORD="${2}"
POCKETBASE_URL="${3:-https://amproject.my.id}"

if [ -z "$ADMIN_PASSWORD" ]; then
    echo "❌ Usage: ./quick-setup.sh admin@admin.com PASSWORD [https://URL]"
    exit 1
fi

echo "🚀 Starting setup for $POCKETBASE_URL"

# Login admin and get token
echo "🔐 Authenticating admin..."
TOKEN=$(curl -s -X POST "$POCKETBASE_URL/api/admins/auth-with-password" \
  -H "Content-Type: application/json" \
  -d "{\"identity\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Login gagal! Periksa email/password admin."
    exit 1
fi
echo "✅ Admin authenticated"

# Create collections
echo ""
echo "📦 Creating collections..."

# 1. plan_configs
echo "Creating plan_configs..."
curl -s -X POST "$POCKETBASE_URL/api/collections" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "plan_configs",
    "type": "base",
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": "",
    "schema": [
      {"name":"plan","type":"text","required":true},
      {"name":"feature_delete","type":"bool"},
      {"name":"feature_print","type":"bool"},
      {"name":"feature_share","type":"bool"},
      {"name":"feature_stock_add","type":"bool"},
      {"name":"menu_finance","type":"bool"},
      {"name":"feature_backup","type":"bool"},
      {"name":"feature_finance_edit","type":"bool"},
      {"name":"feature_employee_edit","type":"bool"},
      {"name":"featuresList","type":"json"}
    ]
  }' > /dev/null 2>&1
echo "✅ plan_configs created"

# 2. owners
echo "Creating owners..."
curl -s -X POST "$POCKETBASE_URL/api/collections" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "owners",
    "type": "base",
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": "",
    "schema": [
      {"name":"name","type":"text","required":true},
      {"name":"email","type":"email"},
      {"name":"plan","type":"text"},
      {"name":"status","type":"text"},
      {"name":"accessRights","type":"json"},
      {"name":"subscription","type":"json"},
      {"name":"autoSyncPlan","type":"bool"},
      {"name":"adminMessage","type":"text"},
      {"name":"adminMessageAt","type":"json"}
    ]
  }' > /dev/null 2>&1
echo "✅ owners created"

# 3. stores
echo "Creating stores..."
curl -s -X POST "$POCKETBASE_URL/api/collections" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "stores",
    "type": "base",
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": "",
    "schema": [
      {"name":"name","type":"text","required":true},
      {"name":"ownerId","type":"text","required":true},
      {"name":"address","type":"text"},
      {"name":"phone","type":"text"}
    ]
  }' > /dev/null 2>&1
echo "✅ stores created"

# Create plan_configs records
echo ""
echo "📝 Creating plan configs records..."

# Basic plan
curl -s -X POST "$POCKETBASE_URL/api/collections/plan_configs/records" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "basic",
    "plan": "basic",
    "feature_delete": true,
    "feature_print": true,
    "feature_share": true,
    "feature_stock_add": true,
    "menu_finance": false,
    "feature_backup": false,
    "feature_finance_edit": false,
    "feature_employee_edit": false,
    "featuresList": ["POS Kasir","Manajemen Servis","Inventory Basic","1 Cabang"]
  }' > /dev/null 2>&1
echo "✅ Basic plan config created"

# Pro plan
curl -s -X POST "$POCKETBASE_URL/api/collections/plan_configs/records" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "pro",
    "plan": "pro",
    "feature_delete": true,
    "feature_print": true,
    "feature_share": true,
    "feature_stock_add": true,
    "menu_finance": true,
    "feature_backup": true,
    "feature_finance_edit": true,
    "feature_employee_edit": true,
    "featuresList": ["Semua Fitur Basic","Laporan Keuangan","Backup & Restore","Multi Cabang (5)","Edit Keuangan","Manajemen Pegawai"]
  }' > /dev/null 2>&1
echo "✅ Pro plan config created"

echo ""
echo "🎉 SETUP COMPLETE!"
echo ""
echo "Sekarang Anda bisa membuat tenant di:"
echo "https://amproject.my.id/index.html"
