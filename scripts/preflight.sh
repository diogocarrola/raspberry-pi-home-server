#!/bin/bash
# Preflight checks for Raspberry Pi Home Server repository

set -euo pipefail

echo "Running preflight checks..."

check_cmd(){
  if command -v "$1" >/dev/null 2>&1; then
    echo "OK: $1"
  else
    echo "MISSING: $1"
    MISSING=1
  fi
}

MISSING=0
check_cmd docker
check_cmd docker-compose
check_cmd tcpdump
check_cmd tshark

if [ "$MISSING" -ne 0 ]; then
  echo "\nOne or more required commands are missing. Quick install hints:" 
  echo " - Docker: curl -fsSL https://get.docker.com | sh"
  echo " - docker-compose: sudo apt install -y docker-compose"
  echo " - tcpdump: sudo apt install -y tcpdump"
  echo " - tshark: sudo apt install -y tshark" 
  exit 2
fi

echo "\nPreflight OK. You can proceed with setup or capture steps described in GETTING_STARTED.md"
