#!/bin/bash
# Backup Pi-hole config directories

set -euo pipefail

mkdir -p backups
tar -czvf backups/pihole-config-$(date +%F).tar.gz pihole-config pihole-dnsmasq
echo "Backup saved to backups/"