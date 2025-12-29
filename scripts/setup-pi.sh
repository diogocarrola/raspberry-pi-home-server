#!/bin/bash
# All-in-one Raspberry Pi setup for Pi-hole (uses docker-compose)

set -euo pipefail

echo "🔧 Starting Pi setup..."

# ensure running from repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${SCRIPT_DIR}/.."
cd "$REPO_DIR"

# update system
sudo apt update && sudo apt upgrade -y

# install docker
if ! command -v docker >/dev/null 2>&1; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker "$USER" || true
fi

# install docker-compose
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "📦 Installing docker-compose..."
  sudo apt install -y docker-compose
fi

# ensure data dirs
mkdir -p pihole-config pihole-dnsmasq backups

# create .env from example if missing
if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "⚙️  Created .env from .env.example — edit .env to set a secure WEBPASSWORD"
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

# Run installer (will create docker-compose.yml if missing)
if [ -x ./scripts/install-adblocker.sh ]; then
  ./scripts/install-adblocker.sh
else
  bash ./scripts/install-adblocker.sh
fi

IP_ADDRESS=$(hostname -I | awk '{print $1}') || IP_ADDRESS=""

echo ""
echo "✅ Pi-hole started. Admin UI: http://$IP_ADDRESS/admin"
echo "🔑 Password: see .env (WEBPASSWORD) — change it in the Admin UI or .env"
echo "To import blocklists: ./scripts/import-blocklists.sh"
echo "To backup: ./scripts/backup.sh"