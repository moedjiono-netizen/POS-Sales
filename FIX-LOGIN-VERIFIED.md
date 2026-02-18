# 🔧 FIX: Masalah Login - User Harus Ganti Password

## 📌 MASALAH
User **SUSAH LOGIN** dan kadang **HARUS GANTI PASSWORD DULU** sebelum bisa masuk.

## 🔍 ROOT CAUSE
**Password TERSIMPAN dengan baik di PocketBase**, tapi:
- User dibuat dengan status `verified=false` (tidak terverifikasi)
- **PocketBase MEMBLOKIR login jika `verified=false`**
- Ketika user reset password via tool, status `verified` juga diubah jadi `true` → makanya bisa login setelah ganti password

## ✅ SOLUSI

### Option 1: Fix Semua User yang Ada (QUICK FIX)
Gunakan tool yang sudah ada:

1. **Buka**: [login-troubleshoot.html](login-troubleshoot.html)
2. **Login sebagai Admin**:
   - Email: `admin@admin.com`
   - Password: password admin Anda
3. **Diagnose User**:
   - Masukkan email user yang bermasalah
   - Klik **"Diagnose Login Problem"**
4. **Fix**:
   - Klik **"FIX ALL"** untuk fix semua masalah sekaligus
   - Atau klik **"Fix 2: Verify User"** untuk hanya verify user

### Option 2: Fix Otomatis Semua User
Gunakan script auto-fix (lihat file `fix-all-unverified-users.html`)

### Option 3: Fix Kode Agar User Baru Otomatis Verified
Update kode di `index.html` agar user baru langsung `verified=true`

---

## 🛠️ DETAIL TEKNIS

### Kenapa User Dibuat dengan verified=false?
Lihat kode di `index.html` line 1294-1302:
```javascript
// Fallback: No admin token available - create via SDK (verified=false)
console.warn('⚠️ No admin token - creating user without verified flag');
const record = await pb.collection('users').create({
    email: email,
    password: password,
    passwordConfirm: password,
    emailVisibility: true,
    // ❌ TIDAK ADA: verified: true
});
```

**Masalahnya**: SDK biasa (non-admin) **TIDAK BISA** set `verified=true` saat create user.

**Solusi**: Harus pakai **Admin API** atau update manual setelah create.

### Kenapa Reset Password Berhasil?
Karena tool troubleshoot update dengan admin token:
```javascript
await pb.collection('users').update(currentUser.id, {
    password: 'password123',
    passwordConfirm: 'password123'
    // Dan biasanya juga set: verified: true
});
```

---

## 📋 CHECKLIST TESTING

Setelah apply fix:
- [ ] User lama bisa login tanpa reset password
- [ ] User baru bisa langsung login setelah dibuat
- [ ] Tidak perlu ganti password lagi
- [ ] Login stabil di browser & PWA

---

## 💡 REKOMENDASI

1. **Segera**: Jalankan script untuk verify semua user yang ada
2. **Permanen**: Update kode pembuatan user agar langsung verified
3. **Monitor**: Cek log PocketBase untuk error `verified=false`

---

## 🔗 FILE TERKAIT
- [login-troubleshoot.html](login-troubleshoot.html) - Tool diagnose & fix manual
- [index.html](index.html#L1240-L1330) - Kode auth & user creation
- [PWA-LOGIN-FIX.md](PWA-LOGIN-FIX.md) - Fix masalah PWA & cache

