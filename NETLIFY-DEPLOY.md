# Netlify Deployment Guide - iFix Pro Enterprise

## 📦 File yang Harus Di-Upload

✅ **Wajib:**
- `index.html` (1.3 MB) - Main application
- `logo-ifix.png` (1.5 MB) - App logo
- `netlify.toml` - Konfigurasi Netlify
- `_redirects` - SPA routing (backup jika netlify.toml tidak dibaca)
- `404.html` - Custom 404 page
- `test.html` - Test file untuk debugging

---

## 🚀 Cara Deploy ke Netlify

### Metode 1: Drag & Drop (Manual)
1. Buka: https://app.netlify.com/drop
2. **DRAG 6 FILE DI ATAS** (jangan drag folder!)
3. Tunggu upload 100%
4. Klik URL yang diberikan

### Metode 2: Netlify CLI
```bash
# Install CLI
npm install -g netlify-cli

# Login
netlify login

# Deploy
cd /workspaces/POS-Sales
netlify deploy --prod
```

### Metode 3: GitHub Integration (Otomatis)
1. Push ke GitHub (sudah dilakukan)
2. Netlify Dashboard > New site > Import from Git
3. Pilih repo: `moedjiono-netizen/POS-Sales`
4. **Build Settings:**
   - Build command: (kosongkan)
   - Publish directory: `.` (titik = root)
5. Deploy!

---

## 🔍 Troubleshooting "Page Not Found"

### Test 1: Cek File Test
Setelah deploy, buka: `https://your-site.netlify.app/test.html`

**Hasil:**
- ✅ **Muncul "Netlify Deployment WORKING"** → File ter-upload dengan benar, lanjut Test 2
- ❌ **404 Not Found** → File tidak ter-upload, cek di bawah

### Test 2: Cek Homepage
Buka: `https://your-site.netlify.app/`

**Hasil:**
- ✅ **Muncul aplikasi iFix Pro** → Deploy berhasil!
- ❌ **Blank/White page** → Ada error JavaScript, cek console (F12)
- ❌ **404 Not Found** → Redirect tidak bekerja, cek di bawah

---

## ❌ Solusi Error "Page Not Found"

### 1. File Tidak Ter-Upload
**Penyebab:** Upload folder, bukan file
**Solusi:**
- ✅ Upload **6 FILE** langsung (index.html, logo-ifix.png, netlify.toml, dll)
- ❌ Jangan upload FOLDER yang berisi file-file tersebut

### 2. Publish Directory Salah
**Penyebab:** Netlify mencari file di subfolder
**Solusi:**
1. Netlify Dashboard > Site configuration > Build & deploy
2. **Publish directory:** Ubah ke `.` (titik) atau `/` (root)
3. Save > Redeploy

### 3. _redirects Tidak Terbaca
**Penyebab:** Format salah atau encoding error
**Solusi:** Hapus `_redirects`, gunakan `netlify.toml` saja
```bash
rm _redirects
git add -A
git commit -m "Remove _redirects, use netlify.toml only"
git push
```

### 4. Cache Issue
**Penyebab:** Browser atau Netlify cache
**Solusi:**
- Browser: Hard refresh (Ctrl+Shift+R) atau buka Incognito
- Netlify: Dashboard > Deploys > Trigger deploy > "Clear cache and deploy"

### 5. Custom Domain Belum Propagasi
**Penyebab:** DNS belum update
**Solusi:**
- Gunakan URL default Netlify dulu: `*.netlify.app`
- Tunggu 24-48 jam untuk custom domain

### 6. JavaScript Error (Blank Page)
**Penyebab:** Firebase config error atau library issue
**Solusi:**
1. Buka Console (F12)
2. Lihat error message
3. Biasanya: Firebase API key atau React error

---

## 📊 Checklist Deploy

Sebelum upload ke Netlify:

- [ ] File `index.html` ada dan valid (buka di browser lokal)
- [ ] File `netlify.toml` ada dan format benar
- [ ] File `logo-ifix.png` ada
- [ ] Total ada 6 file yang akan di-upload
- [ ] Test lokal dulu: `python3 -m http.server 8000`
- [ ] Tidak ada folder, hanya file

Setelah deploy:

- [ ] Test: `https://[site].netlify.app/test.html`
- [ ] Homepage: `https://[site].netlify.app/`
- [ ] Cek Console (F12) tidak ada error
- [ ] Test PWA installation
- [ ] Test offline mode

---

## 📞 Masih Error?

1. **Screenshot:**
   - Netlify Deploy Log (Dashboard > Deploys > View log)
   - Browser Console (F12 > Console tab)
   - Network tab (F12 > Network)

2. **Share info:**
   - URL Netlify: `https://[site].netlify.app`
   - Error message lengkap
   - Hasil Test 1 & 2 di atas

---

## 🎯 Expected Results

Jika berhasil:
- ✅ Homepage muncul dengan login form
- ✅ Logo iFix terlihat
- ✅ Console tidak ada error
- ✅ Bisa install as PWA
- ✅ Firebase connected

---

**Last Updated:** February 14, 2026  
**Status:** Production Ready  
**File Size:** ~3 MB total
