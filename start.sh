#!/bin/bash

echo "🚀 Starting WiFi AP inside Docker container (Access Point Only)..."

# ✅ Load settings from settings.conf
SETTINGS_FILE="/etc/settings.conf"

if [[ -f "$SETTINGS_FILE" ]]; then
    source "$SETTINGS_FILE"
    echo "✅ Loaded settings from $SETTINGS_FILE"
else
    echo "⚠️ settings.conf not found! Using default gateway: 192.168.4.1"
    GATEWAY_IP="192.168.4.1"
fi

echo "✅ Using static IP for wlan0: $GATEWAY_IP"

# ✅ Cleanup function (runs on exit)
cleanup() {
    echo "🛑 Cleaning up wlan0 before container stops..."
    killall hostapd 2>/dev/null
    sleep 2
    ip link set wlan0 down
    ip addr flush dev wlan0
    echo "✅ wlan0 cleaned up. Exiting."
    exit 0
}

# ✅ Trap SIGTERM to run cleanup before stopping
trap cleanup SIGTERM

# ✅ Ensure wlan0 is DOWN first (prevents conflicts)
echo "🔄 Resetting wlan0..."
ip link set wlan0 down
sleep 2

# ✅ Set up wlan0 with the static IP from settings.conf
echo "✅ Enabling wlan0..."
ip link set wlan0 up
sleep 2
ip addr flush dev wlan0  # Ensure no stale IPs
ip addr add "$GATEWAY_IP/24" dev wlan0

# ✅ Start hostapd
echo "🚀 Starting hostapd..."
hostapd -B /etc/hostapd/hostapd.conf
sleep 2

# ✅ Verify hostapd is running
if ! pidof hostapd > /dev/null; then
    echo "❌ Failed to start hostapd! Exiting..."
    exit 1
fi

echo "🎉 WiFi AP is UP and running with IP: $GATEWAY_IP (No DHCP)"

# ✅ Keep container running & handle signals properly
while true; do
    sleep 1
done
