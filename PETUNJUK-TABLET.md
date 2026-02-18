# 📱 RESTORE UNTUK TABLET - PETUNJUK SINGKAT

## Langkah-langkah:

### 1️⃣ Upload File
Upload file `restore-collections-tablet.html` ke server Anda:

**Via FTP/File Manager:**
- Letakkan di: `/workspaces/POS-Sales/restore-collections-tablet.html`
- Atau di root folder yang bisa diakses browser

**Via Terminal (jika ada akses):**
```bash
# File sudah ada di folder ini, tinggal akses via browser
```

### 2️⃣ Akses via Browser Tablet
Buka di browser tablet Anda:
```
https://amproject.my.id/restore-collections-tablet.html
```

> ⚠️ **PENTING:** Pastikan Anda sudah login sebagai admin di PocketBase terlebih dahulu!

### 3️⃣ Klik Tombol Restore
- Tampilan halaman akan muncul dengan judul "🔧 Restore Collections"
- Baca instruksi di halaman
- Klik tombol biru **"Mulai Restore Collections"**
- Tunggu prosesnya (biasanya 10-30 detik)

### 4️⃣ Lihat Hasil
Akan muncul log progress:
- ✅ Hijau = Berhasil
- ⚠️ Kuning = Sudah ada (skip)
- ❌ Merah = Error

### 5️⃣ Selesai!
Jika berhasil, akan muncul kotak hijau dengan checklist:
- ✓ Collection qc_functional_items dibuat
- ✓ Collection master_qc_functional_items dibuat (24 item default)
- ✓ Collection kelengkapan_items dibuat
- ✓ Collection master_kelengkapan_items dibuat (13 item default)
- ✓ store_configs diupdate dengan kategori/subkategori default

### 6️⃣ Refresh Aplikasi POS
- Buka aplikasi POS Anda
- Refresh/reload halaman
- Data kategori, kelengkapan, dan QC sudah tersedia!

---

## Troubleshooting

### ❌ Error "Failed to fetch"
**Penyebab:** Belum login sebagai admin
**Solusi:** 
1. Buka tab baru
2. Login ke `https://amproject.my.id/_/`
3. Kembali ke halaman restore
4. Klik "Coba Lagi"

### ⚠️ Semua "sudah ada"
**Solusi:** Ini normal, berarti collection sudah ada sebelumnya. Skip saja.

### ❌ Error lainnya
**Solusi:**
1. Cek koneksi internet
2. Pastikan PocketBase server running
3. Klik "Coba Lagi"

---

## Screenshot (Tampilan Expected)

### Sebelum Klik:
```
🔧 Restore Collections
POS System - Gallery Ponsel

📱 Petunjuk untuk Tablet:
1. Pastikan Anda sudah login sebagai admin di PocketBase
2. Klik tombol "Mulai Restore" di bawah
3. Tunggu hingga proses selesai
4. Refresh halaman aplikasi POS Anda

[Log Status - kosong]

[Tombol: Mulai Restore Collections]
```

### Sedang Proses:
```
[Log Status:]
📦 Membuat collection qc_functional_items...
✅ Collection "qc_functional_items" berhasil dibuat
📦 Membuat collection master_qc_functional_items...
...

[Tombol: 🔄 Sedang Restore... (disabled)]
```

### Setelah Selesai:
```
[Log Status:]
...
═══════════════════════════════════════
✅ RESTORE SELESAI!
═══════════════════════════════════════

[Kotak Hijau dengan Checklist]
✅ Restore Berhasil!
✓ Collection qc_functional_items dibuat
✓ Collection master_qc_functional_items dibuat (24 item default)
✓ Collection kelengkapan_items dibuat
✓ Collection master_kelengkapan_items dibuat (13 item default)
✓ store_configs diupdate dengan kategori/subkategori default

💡 Silakan refresh halaman aplikasi POS Anda!

[Tombol: ✅ Restore Selesai]
```

---

## Tips Tambahan

### Jika Browser Tablet Freeze
1. Tutup tab
2. Buka tab baru
3. Coba lagi

### Jika Ingin Cek Manual
Buka PocketBase Admin:
```
https://amproject.my.id/_/
```

Cek di sidebar apakah collection sudah ada:
- qc_functional_items
- master_qc_functional_items
- kelengkapan_items
- master_kelengkapan_items

---

## Contact
Jika masih bermasalah, hubungi developer atau buka issue di repository.

Created: 2026-02-17
For: Gallery Ponsel POS System
