#!/bin/bash

# Set up the network interface
ip link set wlan0 up
ip addr add 192.168.4.1/24 dev wlan0

# Start hostapd (WiFi Access Point)
hostapd -B /etc/hostapd/hostapd.conf

# Start dnsmasq (DHCP Server)
dnsmasq -C /etc/dnsmasq.conf -d
