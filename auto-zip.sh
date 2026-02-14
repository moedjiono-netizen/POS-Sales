#!/bin/bash

# Auto Zip Script - Membuat zip baru dan hapus yang lama
# Usage: ./auto-zip.sh

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PROJECT_NAME="POS-Sales"
ZIP_DIR="."
OLD_ZIP="${ZIP_DIR}/deploy-final.zip"
NEW_ZIP="${ZIP_DIR}/${PROJECT_NAME}-${TIMESTAMP}.zip"

echo "🗜️  Auto Zip - POS Sales System"
echo "================================"

# Hapus zip lama jika ada
if [ -f "$OLD_ZIP" ]; then
    echo "🗑️  Menghapus zip lama: $OLD_ZIP"
    rm -f "$OLD_ZIP"
fi

# Hapus semua zip lama dengan pattern timestamp
echo "🗑️  Membersihkan zip lama..."
rm -f ${ZIP_DIR}/${PROJECT_NAME}-*.zip 2>/dev/null

# Buat zip baru dengan exclude file yang tidak perlu
echo "📦 Membuat zip baru..."
zip -r "$NEW_ZIP" . \
    -x "*.git*" \
    -x "*node_modules/*" \
    -x "*.zip" \
    -x "Screenshot_*.jpg" \
    -x "Screenshot_*.png" \
    -x "*.md" \
    -x "*auto-zip.sh" \
    -x "*quick-zip.sh" \
    -x "*test-auto-zip.sh" \
    -x "*.swp" \
    -x "*~" \
    -q

# Buat symbolic link ke deploy-final.zip
ln -sf "$(basename $NEW_ZIP)" "$OLD_ZIP"

# Tampilkan info
FILE_SIZE=$(du -h "$NEW_ZIP" | cut -f1)
echo "✅ Zip berhasil dibuat!"
echo "📂 File: $(basename $NEW_ZIP)"
echo "💾 Size: $FILE_SIZE"
echo "🔗 Link: deploy-final.zip -> $(basename $NEW_ZIP)"
echo ""
echo "================================"
echo "✨ Selesai!"
