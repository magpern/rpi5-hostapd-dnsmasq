#!/bin/bash

# Ensure wlan0 is UP before configuring
ip link set wlan0 up

# Check if IP is already assigned before adding
if ! ip addr show wlan0 | grep -q "192.168.4.1"; then
    ip addr add 192.168.4.1/24 dev wlan0
else
    echo "IP address already assigned. Skipping..."
fi

# Start hostapd (WiFi Access Point)
hostapd -B /etc/hostapd/hostapd.conf

# Start dnsmasq (DHCP Server)
dnsmasq -C /etc/dnsmasq.conf -d
