# 📦 Auto-Zip System

Sistem otomatis untuk membuat file zip deployment setiap ada pembaruan.

## ✨ Fitur

- ✅ Auto-zip setiap kali git commit
- ✅ Menghapus zip lama otomatis
- ✅ Exclude file tidak penting (git, screenshots, dll)
- ✅ File deployment: `deploy-final.zip`

## 🚀 Cara Penggunaan

### 1. Manual Zip (Kapan Saja)
```bash
./quick-zip.sh
```

### 2. Otomatis (Setelah Git Commit)
Setiap kali Anda melakukan `git commit`, file `deploy-final.zip` akan otomatis dibuat/diperbarui.

```bash
git add .
git commit -m "Update fitur"
# Auto-zip akan berjalan otomatis! 🎉
```

### 3. Zip dengan Timestamp
Jika ingin menyimpan versi dengan timestamp:
```bash
./auto-zip.sh
```
Ini akan membuat file seperti: `POS-Sales-20260214_203000.zip`

## 📁 File yang Di-exclude

Berikut file/folder yang tidak dimasukkan ke dalam zip:
- `.git/` - Git repository
- `node_modules/` - Dependencies
- `*.zip` - File zip lainnya
- `Screenshot_*.jpg` - Screenshot
- `*.png` - Gambar
- `*.md` - Dokumentasi
- Script tools (`auto-zip.sh`, `quick-zip.sh`)

## 💡 Tips

### Cek ukuran zip:
```bash
ls -lh deploy-final.zip
```

### Extract untuk testing:
```bash
unzip deploy-final.zip -d test-extract/
```

### Disable auto-zip:
Jika tidak ingin auto-zip setelah commit:
```bash
rm .git/hooks/post-commit
```

## 🎯 Quick Commands

```bash
# Zip cepat
./quick-zip.sh

# Zip dengan backup versi
./auto-zip.sh

# Commit + Auto-zip
git add . && git commit -m "updates" && git push
```

---

**Status**: ✅ Auto-zip aktif dan siap digunakan!
