# Use a lightweight base image that supports Raspberry Pi 5 (ARM64)
FROM arm64v8/debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apt-utils hostapd dnsmasq iproute2 iptables iw \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files (to be created separately)
COPY hostapd.conf /etc/hostapd/hostapd.conf
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the startup script as the container entrypoint
CMD ["/bin/bash", "/start.sh"]

