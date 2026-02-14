#!/bin/bash

# Test Auto-Zip System
# Script ini untuk testing apakah auto-zip bekerja dengan benar

echo "🧪 Testing Auto-Zip System"
echo "================================"
echo ""

# Step 1: Cek script permissions
echo "1️⃣  Checking script permissions..."
if [ -x "quick-zip.sh" ] && [ -x "auto-zip.sh" ]; then
    echo "   ✅ Scripts are executable"
else
    echo "   ⚠️  Making scripts executable..."
    chmod +x quick-zip.sh auto-zip.sh
fi

# Step 2: Cek git hook
echo ""
echo "2️⃣  Checking git post-commit hook..."
if grep -q "quick-zip.sh" .git/hooks/post-commit 2>/dev/null; then
    echo "   ✅ Git hook is configured"
else
    echo "   ❌ Git hook not configured"
fi

# Step 3: Test quick-zip
echo ""
echo "3️⃣  Testing quick-zip.sh..."
OLD_SIZE=$(du -b deploy-final.zip 2>/dev/null | cut -f1)
./quick-zip.sh > /dev/null 2>&1
NEW_SIZE=$(du -b deploy-final.zip 2>/dev/null | cut -f1)

if [ -f "deploy-final.zip" ]; then
    echo "   ✅ deploy-final.zip created successfully"
    echo "   📦 Size: $(du -h deploy-final.zip | cut -f1)"
else
    echo "   ❌ Failed to create zip"
    exit 1
fi

# Step 4: List files in zip
echo ""
echo "4️⃣  Checking zip contents..."
FILE_COUNT=$(unzip -l deploy-final.zip 2>/dev/null | tail -1 | awk '{print $2}')
echo "   📄 Files in zip: $FILE_COUNT"

# Step 5: Verify excluded files
echo ""
echo "5️⃣  Verifying exclusions..."
EXCLUDED=0
if ! unzip -l deploy-final.zip 2>/dev/null | grep -q "\.git/"; then
    echo "   ✅ .git/ excluded"
else
    echo "   ❌ .git/ not excluded"
    EXCLUDED=1
fi

if ! unzip -l deploy-final.zip 2>/dev/null | grep -q "Screenshot_"; then
    echo "   ✅ Screenshots excluded"
else
    echo "   ❌ Screenshots not excluded"
    EXCLUDED=1
fi

# Summary
echo ""
echo "================================"
if [ $EXCLUDED -eq 0 ]; then
    echo "✅ All tests passed!"
    echo ""
    echo "📋 Next steps:"
    echo "   • Run: ./quick-zip.sh untuk manual zip"
    echo "   • Run: git commit untuk test auto-zip"
    echo "   • File: deploy-final.zip siap untuk deploy"
else
    echo "⚠️  Some tests failed. Check configuration."
fi
echo "================================"
