# 🚀 VPS Setup Guide - amproject.my.id

## 📋 Informasi VPS
```
IP Address: 202.10.40.89
Domain: amproject.my.id
User: root
Password: Agis1989
```

## ⚡ Quick Start (Cara Tercepat)

Jalankan satu command ini untuk setup semuanya:

```bash
./master-setup.sh
```

Script ini akan **otomatis**:
- ✅ Cek konfigurasi DNS
- ✅ Install Caddy web server
- ✅ Setup SSL/HTTPS otomatis (Let's Encrypt)
- ✅ Setup reverse proxy ke PocketBase
- ✅ Install PocketBase sebagai systemd service
- ✅ Verifikasi semua service berjalan

**Total waktu: ~5-10 menit**

---

## 📚 Script yang Tersedia

### 1. `master-setup.sh` ⭐ (RECOMMENDED)
Setup lengkap dari A sampai Z. Jalankan ini dulu!

```bash
./master-setup.sh
```

### 2. `check-dns-status.sh`
Cek apakah DNS sudah pointing ke VPS dengan benar

```bash
./check-dns-status.sh
```

Output:
```
✅ DNS correctly resolved
   amproject.my.id → 202.10.40.89
✅ HTTPS is working (HTTP 200)
✅ PocketBase admin accessible
```

### 3. `monitor-vps.sh`
Monitor status VPS, Caddy, PocketBase secara realtime

```bash
./monitor-vps.sh
```

Output akan menampilkan:
- Status koneksi VPS
- Status Caddy web server
- Status PocketBase
- Port yang listening
- Resource usage (CPU, RAM, Disk)
- Recent logs

### 4. `setup-domain-ssl.sh`
Setup Caddy + SSL (dijalankan di VPS)

Ini dijalankan otomatis oleh `master-setup.sh`, tapi bisa juga manual:
```bash
scp setup-domain-ssl.sh root@202.10.40.89:/tmp/
ssh root@202.10.40.89
cd /tmp && chmod +x setup-domain-ssl.sh && ./setup-domain-ssl.sh
```

### 5. `setup-pocketbase-service.sh`
Setup PocketBase sebagai systemd service (dijalankan di VPS)

Ini juga dijalankan otomatis oleh `master-setup.sh`, tapi bisa manual:
```bash
scp setup-pocketbase-service.sh root@202.10.40.89:/tmp/
ssh root@202.10.40.89
cd /tmp && chmod +x setup-pocketbase-service.sh && ./setup-pocketbase-service.sh
```

### 6. `run-vps-setup.sh`
Upload dan jalankan setup-domain-ssl.sh ke VPS

```bash
./run-vps-setup.sh
```

---

## 🔧 Setup Manual (Step by Step)

### Step 1: Setup DNS
1. Login ke domain registrar Anda (tempat beli domain)
2. Masuk ke **DNS Management**
3. Tambahkan A Record:
   ```
   Type: A
   Name: @
   Value: 202.10.40.89
   TTL: 3600
   ```
4. Tunggu 5-60 menit untuk DNS propagasi
5. Cek dengan: `./check-dns-status.sh`

### Step 2: Setup Caddy + SSL
```bash
./run-vps-setup.sh
```
Atau jalankan `./master-setup.sh` untuk otomatis semua.

### Step 3: Setup PocketBase Service
SSH ke VPS dan setup PocketBase:
```bash
ssh root@202.10.40.89
cd /root  # atau folder tempat PocketBase Anda

# Download PocketBase jika belum ada
wget https://github.com/pocketbase/pocketbase/releases/download/v0.22.6/pocketbase_0.22.6_linux_amd64.zip
unzip pocketbase_0.22.6_linux_amd64.zip
chmod +x pocketbase

# Test manual
./pocketbase serve --http=0.0.0.0:8090

# Jika OK, setup sebagai service
cd /tmp
./setup-pocketbase-service.sh
```

### Step 4: Verifikasi
```bash
./monitor-vps.sh
```

---

## 🧪 Testing

### Test DNS
```bash
nslookup amproject.my.id
# Should return: 202.10.40.89
```

### Test HTTPS
```bash
curl -I https://amproject.my.id
# Should return: HTTP/2 200
```

### Test PocketBase Admin
Buka di browser:
```
https://amproject.my.id/_/
```

### Test Main App
Buka di browser:
```
https://amproject.my.id
```

---

## 📊 Monitoring & Maintenance

### Cek Status Service
```bash
ssh root@202.10.40.89

# Cek Caddy
sudo systemctl status caddy

# Cek PocketBase
sudo systemctl status pocketbase

# Cek port
sudo netstat -tulpn | grep -E ':(80|443|8090)'
```

### Lihat Logs
```bash
# Caddy logs
sudo journalctl -u caddy -f

# PocketBase logs
sudo journalctl -u pocketbase -f

# Access logs
sudo tail -f /var/log/caddy/amproject-access.log
```

### Restart Service
```bash
ssh root@202.10.40.89

# Restart Caddy
sudo systemctl restart caddy

# Restart PocketBase
sudo systemctl restart pocketbase
```

---

## 🔥 Troubleshooting

### ❌ DNS tidak resolve
**Problem:** `nslookup amproject.my.id` tidak return IP yang benar

**Solution:**
1. Cek DNS setting di registrar
2. Tunggu 5-60 menit untuk propagasi
3. Clear DNS cache lokal:
   ```bash
   sudo systemd-resolve --flush-caches
   ```

### ❌ HTTPS tidak bisa diakses
**Problem:** `curl https://amproject.my.id` timeout

**Solution:**
```bash
ssh root@202.10.40.89

# Cek Caddy status
sudo systemctl status caddy

# Cek logs
sudo journalctl -u caddy -n 50

# Restart Caddy
sudo systemctl restart caddy

# Cek firewall
sudo ufw status
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### ❌ 502 Bad Gateway
**Problem:** Caddy jalan tapi PocketBase tidak

**Solution:**
```bash
ssh root@202.10.40.89

# Cek PocketBase
sudo systemctl status pocketbase

# Cek port 8090
sudo netstat -tulpn | grep 8090

# Restart PocketBase
sudo systemctl restart pocketbase
```

### ❌ SSL Certificate Error
**Problem:** Browser warning SSL certificate

**Solution:**
1. Pastikan DNS sudah benar-benar resolve
2. Restart Caddy:
   ```bash
   ssh root@202.10.40.89
   sudo systemctl restart caddy
   ```
3. Tunggu 1-2 menit untuk Caddy mendapatkan certificate dari Let's Encrypt

---

## 🔐 Security Best Practices

### 1. Ganti Password VPS
```bash
ssh root@202.10.40.89
passwd
```

### 2. Setup SSH Key Authentication
```bash
# Di komputer lokal
ssh-keygen -t rsa -b 4096

# Copy public key ke VPS
ssh-copy-id root@202.10.40.89

# Disable password login
ssh root@202.10.40.89
nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart sshd
```

### 3. Install Fail2Ban
```bash
ssh root@202.10.40.89
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 4. Setup Firewall
```bash
ssh root@202.10.40.89

# Allow only necessary ports
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 5. Regular Backups
```bash
ssh root@202.10.40.89

# Backup PocketBase data
cd /root/pocketbase  # atau folder Anda
tar -czf backup-$(date +%Y%m%d).tar.gz pb_data/

# Download backup ke lokal
scp root@202.10.40.89:/root/pocketbase/backup-*.tar.gz ./backups/
```

---

## 📁 File Structure di VPS

```
/root/pocketbase/
├── pocketbase                 # Binary executable
├── pb_data/                   # Database & storage
│   ├── data.db               # SQLite database
│   ├── storage/              # Uploaded files
│   └── logs.db               # Logs
└── pb_migrations/            # Schema migrations

/etc/caddy/
└── Caddyfile                 # Caddy configuration

/etc/systemd/system/
├── caddy.service             # Caddy service
└── pocketbase.service        # PocketBase service

/var/log/caddy/
└── amproject-access.log      # Access logs
```

---

## 🎯 Quick Commands Reference

```bash
# DNS & Monitoring
./check-dns-status.sh         # Cek DNS
./monitor-vps.sh              # Monitor VPS status

# Setup
./master-setup.sh             # Setup lengkap (ALL IN ONE)
./run-vps-setup.sh            # Setup Caddy saja

# SSH
ssh root@202.10.40.89         # Login ke VPS

# Service Management (di VPS)
sudo systemctl status caddy
sudo systemctl restart caddy
sudo systemctl status pocketbase
sudo systemctl restart pocketbase

# Logs (di VPS)
sudo journalctl -u caddy -f
sudo journalctl -u pocketbase -f
sudo tail -f /var/log/caddy/amproject-access.log

# Testing
curl -I https://amproject.my.id
curl -I https://amproject.my.id/_/
```

---

## 📞 Support

Jika ada masalah:
1. Jalankan `./check-dns-status.sh`
2. Jalankan `./monitor-vps.sh`
3. Cek dokumentasi: `DNS-SETUP-GUIDE.md`
4. Cek logs di VPS

---

## ✅ Success Checklist

- [ ] DNS A record sudah pointing ke 202.10.40.89
- [ ] DNS sudah propagasi (cek dengan `./check-dns-status.sh`)
- [ ] Caddy installed dan running
- [ ] SSL certificate didapat dari Let's Encrypt
- [ ] PocketBase running sebagai systemd service
- [ ] Firewall configured (port 80, 443 open)
- [ ] https://amproject.my.id bisa diakses (🔒 hijau)
- [ ] https://amproject.my.id/_/ (admin panel) bisa diakses
- [ ] Security: password diganti, SSH key setup, fail2ban installed
- [ ] Backup: automatic backup configured

---

**Last Updated:** February 17, 2026  
**VPS:** 202.10.40.89  
**Domain:** amproject.my.id
