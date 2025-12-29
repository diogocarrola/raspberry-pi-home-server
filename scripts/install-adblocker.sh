#!/bin/bash
# Quick Pi-hole installer (Docker) — minimal, non-interactive
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/raspberry-pi-home-server/main/scripts/install-adblocker.sh | bash

set -euo pipefail

echo "📦 Installing Pi-hole (Docker)"

sudo apt update && sudo apt upgrade -y

if ! command -v docker >/dev/null 2>&1; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker "$USER" || true
fi

if ! command -v docker-compose >/dev/null 2>&1; then
  echo "📦 Installing docker-compose..."
  sudo apt install -y docker-compose
fi

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "⚙️  Created .env from .env.example — please edit .env to set a secure WEBPASSWORD if desired."
  else
    cat > .env <<'EOF'
WEBPASSWORD=change_this_password
TZ=Europe/Lisbon
DNS1=1.1.1.1
DNS2=8.8.8.8
EOF
    echo "⚙️  Created default .env — please edit .env to set a secure WEBPASSWORD."
  fi
fi

if [ ! -f docker-compose.yml ]; then
  cat > docker-compose.yml <<'EOF'
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    env_file:
      - .env
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      - TZ=${TZ}
      - WEBPASSWORD=${WEBPASSWORD}
      - DNS1=${DNS1}
      - DNS2=${DNS2}
    volumes:
      - './pihole-config:/etc/pihole'
      - './pihole-dnsmasq:/etc/dnsmasq.d'
    restart: unless-stopped
EOF
  echo "📄 Created docker-compose.yml"
fi

echo "🚀 Starting Pi-hole container..."
docker-compose up -d

PI_IP=$(hostname -I | awk '{print $1}') || PI_IP=""

echo "✅ Pi-hole should be running. Admin UI: http://$PI_IP/admin (password: change_this_password)"
echo "To finish: add blocklists from configs/blocklists/default.txt and point devices to $PI_IP as DNS."