# 🚀 Quick Reference - amproject.my.id

## 📋 Informasi VPS
```
IP: 202.10.40.89
Domain: amproject.my.id (⚠️ DNS belum dikonfigurasi)
User: root
Password: Agis1989
```

## ✅ Status Saat Ini

### Services Running:
- ✅ Caddy v2.10.2 (Port 80, 443)
- ✅ PocketBase (Port 8090)
- ✅ Firewall UFW Active

### Backup:
- 📁 `vps-backup-20260217-172307/`
- 💾 17MB (PocketBase data + binary)

---

## ⚡ Quick Commands

### Cek Status
```bash
./monitor-vps.sh          # Status lengkap VPS
./check-dns-status.sh     # Cek DNS
```

### SSH
```bash
ssh root@202.10.40.89
```

### Service Management (di VPS)
```bash
# Status
sudo systemctl status caddy
sudo systemctl status pocketbase

# Restart
sudo systemctl restart caddy
sudo systemctl restart pocketbase

# Logs
sudo journalctl -u caddy -f
sudo journalctl -u pocketbase -f
```

---

## 🌐 Akses Aplikasi

### Saat Ini (via IP):
```
http://202.10.40.89:8090/           # Homepage
http://202.10.40.89:8090/_/         # Admin Panel
http://202.10.40.89:8090/api/health # API Health
```

### Setelah DNS Setup:
```
https://amproject.my.id             # Homepage (SSL)
https://amproject.my.id/_/          # Admin Panel (SSL)
```

---

## ⚠️ NEXT STEP - SETUP DNS!

Login ke domain registrar Anda dan tambahkan:

**A Record 1:**
```
Type: A
Name: @
Value: 202.10.40.89
TTL: 3600
```

**A Record 2:**
```
Type: A
Name: www
Value: 202.10.40.89
TTL: 3600
```

**Tunggu 5-60 menit, lalu test:**
```bash
./check-dns-status.sh
```

---

## 🔒 Security Checklist

- [ ] Ganti password VPS
- [ ] Setup SSH key authentication
- [ ] Install fail2ban
- [ ] Setup regular backups
- [ ] Update system: `sudo apt update && sudo apt upgrade`

---

## 📞 Troubleshooting

**DNS tidak resolve?**
```bash
./check-dns-status.sh    # Cek status
dig amproject.my.id      # Manual check
```

**Service tidak jalan?**
```bash
ssh root@202.10.40.89
sudo systemctl status caddy
sudo systemctl status pocketbase
sudo journalctl -u caddy -n 50
```

**502 Bad Gateway?**
- PocketBase tidak jalan → `sudo systemctl restart pocketbase`

**SSL error?**
- DNS belum resolve → Setup DNS dulu
- Restart Caddy → `sudo systemctl restart caddy`

---

## 📚 Full Documentation

- [VPS-SETUP-README.md](VPS-SETUP-README.md) - Complete guide
- [DNS-SETUP-GUIDE.md](DNS-SETUP-GUIDE.md) - DNS setup detail

---

**Last Updated:** February 17, 2026
