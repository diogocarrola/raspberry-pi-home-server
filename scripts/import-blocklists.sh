#!/bin/bash
# Import blocklists from `configs/blocklists/default.txt` into Pi-hole via docker exec
# Usage: ./scripts/import-blocklists.sh

set -euo pipefail

if [ ! -f configs/blocklists/default.txt ]; then
  echo "configs/blocklists/default.txt not found"
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q '^pihole$'; then
  echo "pihole container not running. Start with: docker-compose up -d"
  exit 1
fi

while read -r url; do
  url=$(echo "$url" | xargs)
  [ -z "$url" ] && continue
  echo "Adding adlist: $url"
  docker exec pihole pihole -a adlist add "$url" || echo "Failed to add via CLI, you can add via Admin UI instead."
done < configs/blocklists/default.txt

echo "Updating gravity..."
docker exec pihole pihole -g
echo "Done."