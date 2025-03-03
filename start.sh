#!/bin/bash

echo "🚀 Starting WiFi AP inside Docker container..."

# ✅ Extract the Gateway IP from dnsmasq.conf
GATEWAY_IP=$(grep -oP 'dhcp-option=3,\K[\d.]+' /etc/dnsmasq.conf)

# ✅ If no IP is found, set a default value
if [[ -z "$GATEWAY_IP" ]]; then
    GATEWAY_IP="192.168.4.1"
    echo "⚠️ No gateway IP found in dnsmasq.conf. Using default: $GATEWAY_IP"
else
    echo "✅ Gateway IP detected from dnsmasq.conf: $GATEWAY_IP"
fi

# ✅ Cleanup function (runs on exit)
cleanup() {
    echo "🛑 Cleaning up wlan0 before container stops..."
    killall hostapd dnsmasq 2>/dev/null
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

# ✅ Set up wlan0 with the dynamic IP
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
if ! pgrep -x "hostapd" > /dev/null; then
    echo "❌ Failed to start hostapd! Exiting..."
    exit 1
fi

# ✅ Start dnsmasq (DHCP server)
echo "🚀 Starting dnsmasq..."
dnsmasq -C /etc/dnsmasq.conf -d &
sleep 2

# ✅ Verify dnsmasq is running
if ! pgrep -x "dnsmasq" > /dev/null; then
    echo "❌ Failed to start dnsmasq! Exiting..."
    exit 1
fi

echo "🎉 WiFi AP is UP and running with IP: $GATEWAY_IP"

# ✅ Keep container running & handle signals properly
while true; do
    sleep 1
done
