#!/bin/bash
# Simple tests to check ad blocking

set -euo pipefail

if [ -z "${1-}" ]; then
  PI_IP=$(hostname -I | awk '{print $1}')
else
  PI_IP="$1"
fi

echo "Using Pi IP: $PI_IP"

echo "\n1) Check pihole container"
docker ps | grep pihole || true

echo "\n2) Test DNS resolution for known ad domain (doubleclick.net) via Pi-hole"
dig @${PI_IP} doubleclick.net +short || true

echo "\n3) Test HTTP access for a blocked resource (expected no useful response)"
curl -I http://doubleclick.net || true

echo "\n4) Check Pi-hole admin is reachable: http://$PI_IP/admin"