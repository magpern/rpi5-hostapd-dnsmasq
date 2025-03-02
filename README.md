# Raspberry Pi 5 WiFi AP & DHCP Server (`rpi5-hostapd-dnsmasq`)

🚀 A **Docker-based WiFi Access Point (AP) & DHCP Server** for Raspberry Pi 5 using **hostapd & dnsmasq**.

---

## 🛠 Features

- **WiFi AP (hostapd)** - Creates a WiFi hotspot (`ESP32Network`).
- **DHCP Server (dnsmasq)** - Assigns fixed IPs to ESP32-S3 devices.
- **Dockerized** - Simple setup, no need for manual installation.
- **Auto-build on GitHub Actions** - Every commit builds & pushes the image to **Docker Hub**.

---

## 📦 Installation

### **1️⃣ Install Docker & Docker Compose**

If you haven't installed Docker on your Raspberry Pi:

```bash
sudo apt update && sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
```

### **2️⃣ Pull & Run the Prebuilt Docker Image**

```bash
docker pull magpern/rpi5-hostapd-dnsmasq:latest
docker run -d --name wifi-ap --network host --privileged magpern/rpi5-hostapd-dnsmasq:latest
```

---

## 🏗️ **Build & Run from Source**

If you want to **build the image manually**, clone the repository and run:

```bash
git clone https://github.com/magpern/rpi5-hostapd-dnsmasq.git
cd rpi5-hostapd-dnsmasq
docker-compose up -d --build
```

---

## ⚙️ **Configuration**

You can customize:

- **WiFi Name (SSID)** & **Password** → `hostapd.conf`
- **DHCP Range & Fixed IPs** → `dnsmasq.conf`

To edit:

```bash
nano wifi-ap/hostapd.conf
nano wifi-ap/dnsmasq.conf
```

Then restart the container:

```bash
docker restart wifi-ap
```

---

## 🔄 **GitHub Actions - Auto-Build**

Every commit to `main` triggers a **GitHub Action** that:

1. **Builds the Docker image**
2. **Pushes it to Docker Hub**
3. **Updates the latest version**

---

## 🔍 **Troubleshooting**

### **1️⃣ WiFi Network Not Visible?**

```bash
docker logs wifi-ap | grep hostapd
```

Look for:

```
wlan0: AP-ENABLED
```

If missing, ensure `wlan0` is **not connected to a router**:

```bash
nmcli device disconnect wlan0
sudo systemctl stop wpa_supplicant
```

Then restart:

```bash
docker restart wifi-ap
```

### **2️⃣ ESP32-S3 Not Getting an IP?**

Check DHCP logs:

```bash
docker logs wifi-ap | grep DHCP
```

If missing, restart `dnsmasq`:

```bash
docker restart wifi-ap
```

---

## 📝 License

MIT License - Use, modify, and distribute freely.

---

## ✨ **Contributors**

- **Magpern (@magpern)**
- ChatGPT 🚀

---

## ⭐ **Support & Feedback**

💬 **Have issues?** Open a GitHub Issue!  
👍 **Like this project?** Star this repo! ⭐  

---

### **🚀 Ready to Go? Run this:**

```bash
docker pull magpern/rpi5-hostapd-dnsmasq:latest
docker run -d --name wifi-ap --network host --privileged magpern/rpi5-hostapd-dnsmasq:latest
```

Enjoy your **WiFi AP & DHCP Server on Raspberry Pi 5**! 🎉