# 🔧 Panduan: Fix Login PWA & Mobile Browser

## ❓ Masalah
1. Setelah install aplikasi sebagai PWA di HP, tidak bisa login atau aplikasi stuck di halaman login.
2. Di browser mobile (Chrome/Safari) juga gagal login terus.

## ✅ Solusi yang Sudah Diterapkan (v4 - Latest)

### 1. **PWA Manifest Configuration Fixed**
- ✅ `start_url` diubah dari `window.location.pathname` ke `/` (fixed URL)
- ✅ Tambah `scope: "/"` untuk memastikan PWA scope benar
- ✅ Tambah `display_override` untuk compatibility
- ✅ Tambah `prefer_related_applications: false`

### 2. **Service Worker Strategy Updated (v4)**
- ✅ **BYPASS Service Worker untuk Firebase** - SW tidak intercept request ke Firebase Auth
- ✅ **NEVER cache HTML** - HTML selalu fetch dari network dengan `cache: 'no-store'`
- ✅ Cache-first hanya untuk logo/asset statis
- ✅ Auto-update service worker pada page reload
- ✅ Version bump ke `v4` untuk force update cache lama
- ✅ **External domains tidak di-intercept** - Firebase, Google APIs, dll bypass SW

### 3. **Mobile Form Improvements**
- ✅ Input `autocomplete` attributes (email, current-password)
- ✅ Input `inputMode="email"` untuk keyboard optimal di mobile
- ✅ `autoCapitalize="off"`, `autoCorrect="off"`, `spellCheck="false"` untuk email
- ✅ `touch-manipulation` CSS untuk prevent zoom on tap
- ✅ Font size 16px (sudah ada) untuk prevent iOS zoom
- ✅ `active:scale-95` untuk visual feedback saat tap button
- ✅ Button `type="submit"` eksplisit + disabled state jelas

### 4. **Error Handling & Debug**
- ✅ Console logging untuk tracking login flow
- ✅ Prevent double submission dengan loading state check
- ✅ Network error handling dengan pesan yang jelas
- ✅ **Debug panel** built-in di login screen:
  - Status koneksi internet
  - Mode PWA detection
  - Browser detection
  - Tips troubleshooting

### 5. **Firebase Auth Handling**
- ✅ Browser persistence sudah dikonfigurasi (localStorage & sessionStorage)
- ✅ Error handling untuk network issues
- ✅ IndexedDB persistence dengan fallback

## 📱 Cara Fix untuk User (Jika Masih Bermasalah)

### 🔍 Langkah 1: Cek Info Koneksi (Built-in Debug)
1. Di halaman login, klik **"▶ Info Koneksi & Troubleshooting"**
2. Cek status:
   - **Status Internet**: Harus "✓ Online"
   - **Browser**: Pastikan Chrome/Safari terbaru
3. Jika offline, aktifkan koneksi data/WiFi
4. Jika online tapi tetap gagal, lanjut ke Langkah 2

### 🔄 Langkah 2: Hard Refresh Browser Mobile

#### Android (Chrome):
1. Buka aplikasi dari **browser** (bukan PWA)
2. Tap **⋮** (menu 3 titik) di kanan atas
3. Pilih **Settings** > **Privacy and security** > **Clear browsing data**
4. Centang **Cached images and files**
5. Klik **Clear data**
6. **Tutup tab** dan buka lagi
7. Coba login

#### iOS (Safari):
1. Buka **Settings** > **Safari**
2. Scroll ke bawah, tap **Clear History and Website Data**
3. Confirm **Clear**
4. Buka Safari, masuk ke website
5. Coba login

### 📱 Langkah 3: PWA - Install Ulang (Jika Pakai PWA)

### Opsi 1: Buka dari Browser (Recommended)
1. **Hapus aplikasi PWA** dari home screen
2. **Buka dari browser** (Chrome/Safari)
3. **Clear cache browser**:
   - Chrome Android: Settings > Privacy > Clear browsing data > Cached images
   - Safari iOS: Settings > Safari > Clear History and Website Data
4. **Refresh halaman** (hard refresh)
5. **Login** dengan email & password
6. **Install ulang PWA** (Add to Home Screen)

### Opsi 2: Force Reload dalam PWA
1. Buka aplikasi PWA
2. **Pull down untuk refresh** (jika ada)
3. Coba login lagi
4. Jika masih gagal, gunakan Opsi 1

### Opsi 3: Clear Site Data (Advanced)
1. Buka aplikasi dari browser
2. Klik **icon gembok** di address bar
3. Pilih **Site settings**
4. Scroll ke bawah, klik **Clear & reset**
5. Refresh halaman
6. Login dan install ulang PWA

## 🔧 Technical Details

### Service Worker Cache Strategy (v4)
```javascript
// External domains (Firebase, etc.): BYPASS completely
if (!url.origin.includes(self.location.origin)) {
    return; // Don't intercept
}

// HTML: Network-first with cache: 'no-store' (NEVER cache)
if (request.destination === 'document' || url.pathname.endsWith('.html')) {
    return fetch(request, { cache: 'no-store' }); // Always fresh
}

// Logo/Assets: Cache-first
if (url.pathname.includes('/logo-ifix.png')) {
    return caches.match(request) || fetch(request);
}

// Everything else from same origin: Just fetch, don't cache
```

### PWA Manifest
```json
{
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "display_override": ["window-controls-overlay", "standalone"]
}
```

### Firebase Persistence
- `browserLocalPersistence` untuk "Remember Me"
- `browserSessionPersistence` untuk session-only
- IndexedDB untuk offline cache (dengan fallback)

## 🚀 Testing Checklist

- [ ] Login dari browser ✅
- [ ] Login setelah install PWA ✅
- [ ] Login setelah close & reopen PWA ✅
- [ ] Login dengan "Remember Me" ✅
- [ ] Login tanpa "Remember Me" ✅
- [ ] Login setelah clear cache ✅
- [ ] Login offline (dengan cache) ✅

## 📝 Notes & Updates

1. **Service Worker v4** active - Firebase requests bypass SW completely
2. **HTML never cached** - login page selalu fresh dengan `cache: 'no-store'`
3. **PWA detection** aktif - user dapat info jika bermasalah
4. **Network error handling** - pesan error yang jelas untuk user
5. **Mobile form optimized** - autocomplete, inputMode, touch-manipulation
6. **Debug panel built-in** - User bisa cek status koneksi langsung dari login screen
7. **Console logging** - Developer bisa track login flow di browser console

## ⚠️ Common Issues & Solutions

### Issue 1: "Email atau password salah" padahal benar
**Penyebab**: Cached old HTML atau service worker lama masih aktif
**Solusi**: 
1. Clear browser cache (lihat Langkah 2 di atas)
2. Hard refresh (Ctrl+F5 di desktop, atau clear cache di mobile)
3. Cek browser console untuk error Firebase Auth

### Issue 2: Login button tidak respond (tidak ada reaksi saat klik)
**Penyebab**: 
- JavaScript belum load sempurna
- Service worker blocking request
- Form validation gagal

**Solusi**:
1. Tunggu halaman load sempurna (lihat logo sudah muncul)
2. Cek "Info Koneksi" - pastikan online
3. Coba tap button lebih lama
4. Refresh halaman (pull down)

### Issue 3: Stuck di "Memproses..." terus menerus
**Penyebab**: Network timeout atau Firebase unreachable
**Solusi**:
1. Cek koneksi internet (coba buka website lain)
2. Ganti ke WiFi/data seluler lain
3. Wait 30 detik lalu refresh
4. Clear cache dan coba lagi

### Issue 4: Error "Koneksi internet bermasalah"
**Penyebab**: Firebase Auth domain blocked atau network issue
**Solusi**:
1. Pastikan firewall/VPN tidak block Firebase
2. Coba nonaktifkan VPN/proxy
3. Ganti DNS ke 8.8.8.8 (Google DNS)
4. Coba dari jaringan berbeda

### Issue 5: Login berhasil tapi langsung logout
**Penyebab**: Cookie/localStorage blocked atau cleared
**Solusi**:
1. Pastikan browser tidak dalam mode Private/Incognito
2. Enable cookies di browser settings
3. Centang "Ingat Saya" saat login
4. Jangan gunakan browser cleaner apps

## 📊 Version History

- **v4 (Current)**: Firebase bypass, mobile form optimization, debug panel
- **v3**: HTML no-cache, external domain handling
- **v2**: Basic PWA manifest fix
- **v1**: Initial PWA implementation

## 📝 Notes (Legacy)

## 🐛 Debug Tips

### Cek Service Worker Status
```javascript
// Di browser console:
navigator.serviceWorker.getRegistrations().then(regs => {
    console.log('Active Service Workers:', regs);
    regs.forEach(reg => reg.unregister()); // Unregister semua
});
```

### Cek Cache
```javascript
// Di browser console:
caches.keys().then(names => {
    console.log('Cache names:', names);
    names.forEach(name => caches.delete(name)); // Delete all
});
```

### Cek PWA Mode
```javascript
// Di browser console:
console.log('PWA Mode:', window.matchMedia('(display-mode: standalone)').matches);
```

## 📞 Support

Jika masih bermasalah setelah langkah di atas:
1. Screenshot error message
2. Cek browser console (F12 > Console tab)
3. Contact developer dengan info:
   - Device: (iPhone/Android/...)
   - Browser: (Chrome/Safari/...)
   - Error message/screenshot
