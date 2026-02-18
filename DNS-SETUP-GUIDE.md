# 🌐 Panduan Setup DNS untuk amproject.my.id

## ✅ Langkah 1: Login ke Domain Registrar

Dimana Anda membeli domain **amproject.my.id** (contoh: Niagahoster, Domainesia, Cloudflare, Namecheap, dll)

## ✅ Langkah 2: Tambahkan DNS Records

Masuk ke menu **DNS Management** / **DNS Zone** / **DNS Records** dan tambahkan:

### Record A untuk domain utama
```
Type: A
Name: @ (atau kosongkan, atau amproject.my.id)
Value: 202.10.40.89
TTL: 3600 (atau Auto)
```

### Record A untuk www
```
Type: A
Name: www
Value: 202.10.40.89
TTL: 3600 (atau Auto)
```

### Contoh Screenshot Settingan:
```
┌──────┬─────────────────┬────────────────┬──────┐
│ Type │      Name       │     Value      │ TTL  │
├──────┼─────────────────┼────────────────┼──────┤
│  A   │       @         │ 202.10.40.89   │ 3600 │
│  A   │      www        │ 202.10.40.89   │ 3600 │
└──────┴─────────────────┴────────────────┴──────┘
```

## ✅ Langkah 3: Tunggu DNS Propagasi

⏳ **Waktu tunggu:** 5-60 menit (kadang bisa lebih cepat)

Cek propagasi DNS dengan command:
```bash
# Cek DNS dari berbagai server DNS
./check-dns-status.sh
```

Atau manual:
```bash
# Cek apakah sudah pointing ke IP yang benar
nslookup amproject.my.id
dig amproject.my.id

# Atau lewat online tool:
# https://dnschecker.org
# https://www.whatsmydns.net
```

## ✅ Langkah 4: Jalankan Setup di VPS

Setelah DNS sudah propagasi:
```bash
chmod +x run-vps-setup.sh
./run-vps-setup.sh
```

Script akan:
- ✅ Install Caddy web server
- ✅ Setup reverse proxy ke PocketBase
- ✅ Setup automatic HTTPS dengan Let's Encrypt
- ✅ Configure firewall

## ✅ Langkah 5: Pastikan PocketBase Running

SSH ke VPS dan jalankan PocketBase:
```bash
ssh root@202.10.40.89

# Navigate ke folder PocketBase
cd /path/to/pocketbase

# Jalankan PocketBase
./pocketbase serve --http=0.0.0.0:8090
```

**PENTING:** Untuk production, gunakan systemd service agar PocketBase jalan otomatis:
```bash
# Buat service file
sudo tee /etc/systemd/system/pocketbase.service > /dev/null <<EOF
[Unit]
Description=PocketBase Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/pocketbase
ExecStart=/root/pocketbase/pocketbase serve --http=0.0.0.0:8090
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable dan start service
sudo systemctl daemon-reload
sudo systemctl enable pocketbase
sudo systemctl start pocketbase
sudo systemctl status pocketbase
```

## ✅ Langkah 6: Test

Test dari browser:
```
https://amproject.my.id
https://amproject.my.id/_/
```

Test dari command line:
```bash
curl -I https://amproject.my.id
```

Harusnya dapat response:
```
HTTP/2 200
server: Caddy
strict-transport-security: max-age=31536000; includeSubDomains; preload
...
```

## 🔍 Troubleshooting

### ❌ DNS belum resolve
```bash
# Cek DNS
nslookup amproject.my.id

# Tunggu lebih lama, atau clear DNS cache
sudo systemd-resolve --flush-caches
```

### ❌ SSL certificate error
```bash
# Cek Caddy logs
ssh root@202.10.40.89
sudo journalctl -u caddy -n 50

# Restart Caddy
sudo systemctl restart caddy
```

### ❌ 502 Bad Gateway
Artinya Caddy jalan tapi PocketBase tidak jalan:
```bash
# Cek PocketBase
ssh root@202.10.40.89
ps aux | grep pocketbase

# Start PocketBase
./pocketbase serve --http=0.0.0.0:8090
```

### ❌ Port sudah dipakai
```bash
# Cek port 80, 443, 8090
sudo netstat -tulpn | grep -E ':(80|443|8090)'

# Kill process yang pakai port tersebut
sudo kill -9 <PID>
```

## 📊 Monitoring

### Cek status Caddy
```bash
ssh root@202.10.40.89
sudo systemctl status caddy
```

### Cek logs Caddy
```bash
ssh root@202.10.40.89
sudo journalctl -u caddy -f
sudo tail -f /var/log/caddy/amproject-access.log
```

### Cek status PocketBase
```bash
ssh root@202.10.40.89
sudo systemctl status pocketbase
```

### Cek SSL certificate info
```bash
curl -vI https://amproject.my.id 2>&1 | grep -E 'SSL|certificate'
```

## 🎉 Success Checklist

- [ ] DNS A record sudah pointing ke 202.10.40.89
- [ ] DNS sudah propagasi (nslookup berhasil)
- [ ] Caddy sudah installed dan running
- [ ] PocketBase sudah running di port 8090
- [ ] Firewall sudah allow port 80, 443
- [ ] https://amproject.my.id bisa diakses
- [ ] https://amproject.my.id/_/ (admin panel) bisa diakses
- [ ] SSL certificate valid (🔒 hijau di browser)

---

📝 **Updated:** February 17, 2026
