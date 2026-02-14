#!/bin/bash

# Quick Zip Script - Zip cepat dengan nama deploy-final.zip
# Usage: ./quick-zip.sh

ZIP_NAME="deploy-final.zip"

echo "🗜️  Quick Zip - POS Sales System"
echo "================================"

# Hapus zip lama
if [ -f "$ZIP_NAME" ]; then
    echo "🗑️  Menghapus: $ZIP_NAME"
    rm -f "$ZIP_NAME"
fi

# Buat zip baru
echo "📦 Membuat zip baru..."
zip -r "$ZIP_NAME" . \
    -x "*.git*" \
    -x "*node_modules/*" \
    -x "*.zip" \
    -x "Screenshot_*.jpg" \
    -x "*.png" \
    -x "DEPLOY-FIX.md" \
    -x "NETLIFY-DEPLOY.md" \
    -x "*auto-zip.sh" \
    -x "*quick-zip.sh" \
    -x "*.swp" \
    -x "*~" \
    -q

# Tampilkan info
FILE_SIZE=$(du -h "$ZIP_NAME" | cut -f1)
echo "✅ Zip berhasil dibuat!"
echo "📂 File: $ZIP_NAME"
echo "💾 Size: $FILE_SIZE"
echo ""
echo "================================"
echo "✨ Selesai!"
