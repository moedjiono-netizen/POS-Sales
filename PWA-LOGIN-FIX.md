# 🔧 Panduan: Fix Login PWA (Progressive Web App)

## ❓ Masalah
Setelah install aplikasi sebagai PWA di HP, tidak bisa login atau aplikasi stuck di halaman login.

## ✅ Solusi yang Sudah Diterapkan

### 1. **PWA Manifest Configuration Fixed**
- ✅ `start_url` diubah dari `window.location.pathname` ke `/` (fixed URL)
- ✅ Tambah `scope: "/"` untuk memastikan PWA scope benar
- ✅ Tambah `display_override` untuk compatibility
- ✅ Tambah `prefer_related_applications: false`

### 2. **Service Worker Strategy Updated**
- ✅ **NEVER cache HTML** - HTML selalu fetch dari network
- ✅ Cache-first hanya untuk logo/asset statis
- ✅ Network-first untuk Firebase & API calls
- ✅ Auto-update service worker pada page reload
- ✅ Version bump ke `v3` untuk force update cache lama

### 3. **Firebase Auth Handling**
- ✅ Browser persistence sudah dikonfigurasi (localStorage & sessionStorage)
- ✅ Error handling untuk network issues
- ✅ IndexedDB persistence dengan fallback

### 4. **User Guidance**
- ✅ Info banner di login screen untuk PWA mode
- ✅ Instruksi clear cache jika ada masalah

## 📱 Cara Fix untuk User (Jika Masih Bermasalah)

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

### Service Worker Cache Strategy
```javascript
// HTML: Network-first (NEVER cache)
if (request.destination === 'document' || url.pathname.endsWith('.html')) {
    return fetch(request); // Always fresh
}

// Logo/Assets: Cache-first
if (url.pathname.includes('/logo-ifix.png')) {
    return caches.match(request) || fetch(request);
}

// Firebase/API: Network-first with fallback
return fetch(request).catch(() => caches.match(request));
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

## 📝 Notes

1. **Service Worker v3** active - cache lama otomatis dihapus
2. **HTML never cached** - login page selalu fresh dari server
3. **PWA detection** aktif - user dapat info jika bermasalah
4. **Network error handling** - pesan error yang jelas untuk user

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
