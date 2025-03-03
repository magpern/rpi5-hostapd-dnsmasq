# Use a lightweight Debian-based image
FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    apt-utils create-ap iproute2 iptables iw net-tools \
    tcpdump procps iputils-ping curl wget nano busybox \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files (so they exist inside the image)
COPY wifi-ap.conf /etc/wifi-ap.conf
COPY create_ap.conf /etc/create_ap.conf
COPY start.sh /start.sh

# Ensure scripts and config are executable
RUN chmod +x /start.sh

# Entrypoint script
CMD ["/bin/bash", "/start.sh"]
