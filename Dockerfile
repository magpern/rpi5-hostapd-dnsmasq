# Use a lightweight base image that supports Raspberry Pi 5 (ARM64)
FROM debian:bullseye

# Install necessary packages (Removed dnsmasq)
RUN apt-get update && apt-get install -y \
    hostapd iproute2 iw \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY hostapd.conf /etc/hostapd/hostapd.conf
COPY settings.conf /etc/settings.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the startup script as the container entrypoint
CMD ["/bin/bash", "/start.sh"]
