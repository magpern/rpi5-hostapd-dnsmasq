#!/bin/bash

echo "🚀 Starting WiFi AP inside Docker container using create_ap..."

# ✅ Load Configuration from External File
CONFIG_FILE="/etc/wifi-ap.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "❌ Missing config file: $CONFIG_FILE"
    exit 1
fi

# ✅ Ensure Variables Exist (Fallback Defaults)
WIFI_IFACE="${WIFI_IFACE:-wlan0}"
INTERNET_IFACE="${INTERNET_IFACE:-none}"
SSID="${SSID:-ESP32Network}"
PASSWORD="${PASSWORD:-MySecretPassword}"
GATEWAY_IP="${GATEWAY_IP:-192.168.4.1}"
DHCP_CONFIG="/etc/create_ap.conf"

# ✅ Cleanup function (runs on exit)
cleanup() {
    echo "🛑 Stopping create_ap..."
    pkill -f create_ap
    sleep 2
    ip link set "$WIFI_IFACE" down
    ip addr flush dev "$WIFI_IFACE"
    echo "✅ wlan0 cleaned up. Exiting."
    exit 0
}

# ✅ Trap SIGTERM to run cleanup before stopping
trap cleanup SIGTERM

# ✅ Ensure wlan0 is DOWN first (prevents conflicts)
echo "🔄 Resetting $WIFI_IFACE..."
ip link set "$WIFI_IFACE" down
sleep 2

# ✅ Bring wlan0 UP
echo "✅ Enabling $WIFI_IFACE..."
ip link set "$WIFI_IFACE" up
sleep 2
ip addr flush dev "$WIFI_IFACE"

# ✅ Start `create_ap` with config file
echo "🚀 Starting create_ap..."
create_ap --dhcp-dnsmasq="$DHCP_CONFIG" "$WIFI_IFACE" "$INTERNET_IFACE" "$SSID" "$PASSWORD" --gateway "$GATEWAY_IP" --daemon

# ✅ Check if create_ap is running
if ! pgrep -f create_ap > /dev/null; then
    echo "❌ Failed to start create_ap! Exiting..."
    exit 1
fi

echo "🎉 WiFi AP is UP with SSID: $SSID (Interface: $WIFI_IFACE, Internet: $INTERNET_IFACE)"

# ✅ Keep container running
while true; do sleep 1; done
