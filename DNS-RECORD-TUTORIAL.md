# 🌐 Tutorial Setup DNS Record untuk amproject.my.id

## 📋 Informasi DNS Record yang Dibutuhkan

```
Domain: amproject.my.id
IP VPS: 202.10.40.89
```

**DNS Records yang harus ditambahkan:**

| Type | Name/Host | Value/Points To | TTL  |
|------|-----------|-----------------|------|
| A    | @         | 202.10.40.89    | 3600 |
| A    | www       | 202.10.40.89    | 3600 |

---

## 🎯 Pilih Provider Anda

- [Niagahoster](#niagahoster)
- [Domainesia](#domainesia)
- [Cloudflare](#cloudflare)
- [Rumahweb](#rumahweb)
- [IDCloudhost](#idcloudhost)
- [Namecheap](#namecheap)
- [GoDaddy](#godaddy)
- [Provider Lain](#provider-umum)

---

## Niagahoster

### Langkah-langkah:

1. **Login ke Member Area**
   - Buka: https://www.niagahoster.co.id/login
   - Masukkan email dan password

2. **Masuk ke Domain Management**
   - Klik menu **"Layanan Saya"** atau **"My Services"**
   - Pilih **"Domain"**
   - Klik domain **amproject.my.id**

3. **Buka DNS Zone Management**
   - Klik tab **"DNS Management"** atau **"Kelola DNS"**
   - Atau klik **"Manage DNS Zone"**

4. **Tambahkan Record A untuk Root Domain (@)**
   ```
   Type: A
   Name: @ (atau kosongkan)
   Address/Value: 202.10.40.89
   TTL: 3600 (atau Auto/Default)
   ```
   - Klik **"Add Record"** atau **"Tambah"**

5. **Tambahkan Record A untuk www**
   ```
   Type: A
   Name: www
   Address/Value: 202.10.40.89
   TTL: 3600 (atau Auto/Default)
   ```
   - Klik **"Add Record"** atau **"Tambah"**

6. **Simpan Perubahan**
   - Klik **"Save Changes"** atau **"Simpan"**

7. **Tunggu Propagasi**
   - Biasanya 5-30 menit
   - Maksimal 24 jam

### Visual (Niagahoster):
```
┌─────────────────────────────────────────────────────────┐
│ DNS Management - amproject.my.id                        │
├──────┬──────────┬─────────────────┬──────┬────────────┤
│ Type │   Name   │     Value       │ TTL  │   Action   │
├──────┼──────────┼─────────────────┼──────┼────────────┤
│  A   │    @     │  202.10.40.89   │ 3600 │  [Delete]  │
│  A   │   www    │  202.10.40.89   │ 3600 │  [Delete]  │
└──────┴──────────┴─────────────────┴──────┴────────────┘

[+ Add New Record]  [Save Changes]
```

---

## Domainesia

### Langkah-langkah:

1. **Login ke Client Area**
   - Buka: https://my.domainesia.com/
   - Login dengan email dan password

2. **Pilih Domain**
   - Klik menu **"Domains"**
   - Pilih **amproject.my.id**

3. **Manage DNS**
   - Klik **"Manage DNS"** atau ikon DNS
   - Atau tab **"DNS Records"**

4. **Tambah Record A (@)**
   - Klik **"Add Record"**
   - Pilih **Type: A**
   - **Host:** @ (atau kosongkan)
   - **Points to:** 202.10.40.89
   - **TTL:** 3600 atau Automatic
   - Klik **"Add Record"**

5. **Tambah Record A (www)**
   - Klik **"Add Record"** lagi
   - **Type: A**
   - **Host:** www
   - **Points to:** 202.10.40.89
   - **TTL:** 3600
   - Klik **"Add Record"**

6. **Save**
   - Perubahan otomatis tersimpan
   - Tunggu propagasi 5-60 menit

---

## Cloudflare

### Langkah-langkah:

1. **Login ke Cloudflare**
   - Buka: https://dash.cloudflare.com/
   - Login dengan email/password

2. **Pilih Domain**
   - Klik **amproject.my.id** dari daftar

3. **Buka DNS Settings**
   - Klik tab **"DNS"** di menu samping
   - Atau **"DNS Records"**

4. **Tambah A Record (@)**
   - Klik **"Add record"**
   - **Type:** A
   - **Name:** @ (atau amproject.my.id)
   - **IPv4 address:** 202.10.40.89
   - **Proxy status:** 
     - ☑️ Proxied (orange cloud) - Recommended untuk CDN & DDoS protection
     - ☐ DNS only (gray cloud) - Jika tidak mau proxy Cloudflare
   - **TTL:** Auto
   - Klik **"Save"**

5. **Tambah A Record (www)**
   - Klik **"Add record"** lagi
   - **Type:** A
   - **Name:** www
   - **IPv4 address:** 202.10.40.89
   - **Proxy status:** Sama seperti di atas
   - **TTL:** Auto
   - Klik **"Save"**

6. **SSL/TLS Settings (Important for Cloudflare)**
   - Klik tab **"SSL/TLS"**
   - Pilih mode **"Full"** atau **"Full (strict)"**
   - Ini penting agar HTTPS bekerja dengan Caddy

### Catatan Cloudflare:
- ⚡ Propagasi sangat cepat (1-5 menit)
- 🛡️ Gratis DDoS protection
- 🚀 CDN otomatis
- Jika pakai **Proxied** (orange cloud), pastikan SSL/TLS mode = **Full**

---

## Rumahweb

### Langkah-langkah:

1. **Login ke Client Area**
   - Buka: https://clientzone.rumahweb.com/
   - Login dengan username/password

2. **Domains Menu**
   - Klik **"Domains"** di menu atas
   - Pilih **"My Domains"**
   - Klik domain **amproject.my.id**

3. **DNS Management**
   - Scroll ke bawah
   - Cari bagian **"DNS Management"**
   - Klik **"Manage"**

4. **Add A Record (@)**
   ```
   Record Type: A
   Host: @ (atau blank)
   Points to: 202.10.40.89
   TTL: 3600
   ```
   - Klik **"Add Record"**

5. **Add A Record (www)**
   ```
   Record Type: A
   Host: www
   Points to: 202.10.40.89
   TTL: 3600
   ```
   - Klik **"Add Record"**

6. **Save**
   - Klik **"Save Changes"**
   - Tunggu 10-60 menit

---

## IDCloudhost

### Langkah-langkah:

1. **Login ke Console**
   - Buka: https://console.idcloudhost.com/
   - Login dengan akun Anda

2. **Manage Domain**
   - Menu **"Domain"**
   - Pilih **amproject.my.id**

3. **DNS Management**
   - Klik **"Kelola DNS"** atau **"Manage DNS"**

4. **Tambah Record**
   - Klik **"Tambah Record"**
   
   **Record 1:**
   ```
   Type: A
   Host: @
   Value: 202.10.40.89
   TTL: 3600
   ```
   
   **Record 2:**
   ```
   Type: A
   Host: www
   Value: 202.10.40.89
   TTL: 3600
   ```

5. **Simpan**
   - Klik **"Simpan"** atau **"Save"**

---

## Namecheap

### Langkah-langkah:

1. **Login to Account**
   - Go to: https://www.namecheap.com/myaccount/login/
   - Login with username/password

2. **Domain List**
   - Click **"Domain List"**
   - Find **amproject.my.id**
   - Click **"Manage"**

3. **Advanced DNS**
   - Click **"Advanced DNS"** tab

4. **Add A Record (@)**
   - Under **"Host Records"**
   - Click **"Add New Record"**
   ```
   Type: A Record
   Host: @
   Value: 202.10.40.89
   TTL: Automatic
   ```
   - Click checkmark (✓) to save

5. **Add A Record (www)**
   - Click **"Add New Record"**
   ```
   Type: A Record
   Host: www
   Value: 202.10.40.89
   TTL: Automatic
   ```
   - Click checkmark (✓) to save

6. **Save All Changes**
   - Click **"Save All Changes"**
   - Propagation: 30 minutes to 48 hours

---

## GoDaddy

### Langkah-langkah:

1. **Login**
   - Go to: https://account.godaddy.com/
   - Sign in

2. **My Products**
   - Click **"My Products"**
   - Find **amproject.my.id**
   - Click **"DNS"** button

3. **DNS Management**
   - You'll see DNS Records table

4. **Add A Record (@)**
   - Click **"Add"** button
   ```
   Type: A
   Name: @
   Value: 202.10.40.89
   TTL: 1 Hour (or Default)
   ```
   - Click **"Save"**

5. **Add A Record (www)**
   - Click **"Add"** button
   ```
   Type: A
   Name: www
   Value: 202.10.40.89
   TTL: 1 Hour
   ```
   - Click **"Save"**

6. **Done**
   - Changes take effect in 1 hour
   - Full propagation: up to 48 hours

---

## Provider Umum

Jika provider Anda tidak ada di daftar, ikuti langkah umum ini:

### 1. Login ke Control Panel Domain
- Cari menu yang berisi kata:
  - "DNS"
  - "Domain Management"
  - "DNS Management"
  - "DNS Records"
  - "DNS Zone"
  - "Name Servers"

### 2. Cari DNS Record Editor
- Biasanya ada tombol/link:
  - "Manage DNS"
  - "Edit DNS"
  - "DNS Settings"
  - "Advanced DNS"

### 3. Tambahkan 2 Record Ini

**Record 1 - Root Domain:**
```
┌─────────────────────────────────────┐
│ Type:   A                           │
│ Host:   @ (atau kosongkan)          │
│ Value:  202.10.40.89                │
│ TTL:    3600 (atau Auto/Default)    │
└─────────────────────────────────────┘
```

**Record 2 - WWW Subdomain:**
```
┌─────────────────────────────────────┐
│ Type:   A                           │
│ Host:   www                         │
│ Value:  202.10.40.89                │
│ TTL:    3600 (atau Auto/Default)    │
└─────────────────────────────────────┘
```

### 4. Save/Simpan
- Klik tombol Save/Simpan
- Tunggu propagasi

---

## 🧪 Cara Test DNS

### Test 1: Dari Command Line
```bash
# Di computer/terminal Anda
./check-dns-status.sh

# Atau manual:
dig amproject.my.id
nslookup amproject.my.id
```

**Output yang benar:**
```
amproject.my.id.    3600    IN    A    202.10.40.89
```

### Test 2: Online Tools

Buka salah satu website ini:
- https://dnschecker.org
- https://www.whatsmydns.net
- https://mxtoolbox.com/DNSLookup.aspx

**Input:**
- Domain: `amproject.my.id`
- Type: `A`

**Hasil yang benar:**
- Harus menunjukkan IP: `202.10.40.89`
- Check dari berbagai lokasi harus sama

### Test 3: Ping
```bash
ping amproject.my.id
```

**Output yang benar:**
```
PING amproject.my.id (202.10.40.89): 56 data bytes
```

---

## ⏰ Waktu Propagasi DNS

| Provider      | Waktu Normal    | Maksimum  |
|---------------|-----------------|-----------|
| Cloudflare    | 1-5 menit       | 10 menit  |
| Niagahoster   | 5-30 menit      | 2 jam     |
| Domainesia    | 10-60 menit     | 4 jam     |
| Rumahweb      | 15-60 menit     | 6 jam     |
| IDCloudhost   | 10-30 menit     | 2 jam     |
| Namecheap     | 30 menit-1 jam  | 48 jam    |
| GoDaddy       | 1 jam           | 48 jam    |

**Tips:**
- Propagasi DNS bisa berbeda untuk setiap lokasi
- Clear DNS cache lokal jika sudah lama tapi belum resolve
- Gunakan online tools untuk cek dari berbagai lokasi

---

## 🔧 Troubleshooting

### ❌ DNS Tidak Resolve Setelah 1 Jam

**Checklist:**
1. ✅ Apakah Anda sudah klik **Save/Simpan**?
2. ✅ Apakah Type = **A** (bukan CNAME/TXT/MX)?
3. ✅ Apakah Value = **202.10.40.89** (tanpa http:// atau https://)?
4. ✅ Apakah Host/Name = **@** untuk root domain?
5. ✅ Apakah ada record lama yang konflik? (hapus jika ada)

**Solusi:**
```bash
# Clear DNS cache lokal
# Linux:
sudo systemd-resolve --flush-caches

# macOS:
sudo dscacheutil -flushcache

# Windows:
ipconfig /flushdns

# Test lagi
./check-dns-status.sh
```

### ❌ Propagasi Sangat Lambat

**Kemungkinan:**
1. TTL terlalu tinggi (>3600)
2. Ada cached DNS record lama
3. Provider DNS lambat update

**Solusi:**
- Tunggu lebih lama (up to 24-48 jam)
- Coba test dari HP dengan data celular (DNS berbeda)
- Hubungi support provider domain

### ❌ DNS Resolve tapi Website Error

Jika DNS sudah resolve (ping berhasil) tapi website error:

**Cek ini:**
```bash
# Test apakah VPS respond
curl -I http://202.10.40.89:8090

# Test domain
curl -I https://amproject.my.id

# Cek service di VPS
./monitor-vps.sh
```

**Kemungkinan:**
- Caddy belum restart setelah DNS resolve
- SSL certificate belum didapat

**Solusi:**
```bash
ssh root@202.10.40.89
sudo systemctl restart caddy
sudo journalctl -u caddy -f
```

---

## ✅ Success Indicators

### DNS Setup Berhasil Jika:

1. **nslookup/dig shows correct IP:**
   ```
   ✅ amproject.my.id → 202.10.40.89
   ```

2. **Ping berhasil:**
   ```
   ✅ ping amproject.my.id responds
   ```

3. **Website accessible:**
   ```
   ✅ https://amproject.my.id loads
   ✅ https://amproject.my.id/_/ (admin) works
   ```

4. **SSL Certificate valid:**
   ```
   ✅ Browser shows 🔒 (padlock icon)
   ✅ Certificate issued by Let's Encrypt
   ```

---

## 📞 Need Help?

### Jika Masih Bingung:

1. **Screenshot control panel DNS Anda**
   - Kirim screenshot menu DNS management
   - Tunjukkan dimana bingung

2. **Cek dokumentasi provider**
   - Cari "how to add A record" + nama provider
   - Biasanya ada di knowledge base mereka

3. **Contact support provider**
   - Minta bantuan menambahkan A record
   - Berikan info:
     ```
     Domain: amproject.my.id
     Type: A Record
     Host: @ dan www
     Value: 202.10.40.89
     TTL: 3600
     ```

---

## 📝 Checklist Lengkap

Setelah selesai setup DNS, pastikan:

- [ ] A Record @ sudah ditambahkan (202.10.40.89)
- [ ] A Record www sudah ditambahkan (202.10.40.89)
- [ ] Perubahan sudah di-Save
- [ ] Tunggu 30 menit
- [ ] Test dengan: `./check-dns-status.sh`
- [ ] DNS resolve ke IP yang benar
- [ ] Website https://amproject.my.id bisa diakses
- [ ] Admin panel https://amproject.my.id/_/ bisa diakses
- [ ] SSL certificate (🔒) aktif dan valid

---

**Last Updated:** February 17, 2026  
**Domain:** amproject.my.id  
**Target IP:** 202.10.40.89
