# Backup & restore Pi-hole data

Backup the Docker volumes (recommended before major changes):

```bash
# stop containers
docker-compose down

# create backup directory
mkdir -p backups

# tar pihole config and dnsmasq directories
tar -czvf backups/pihole-config-$(date +%F).tar.gz pihole-config pihole-dnsmasq
```

To restore:

```bash
tar -xzvf backups/pihole-config-YYYY-MM-DD.tar.gz -C .
docker-compose up -d
```

Also export Pi-hole settings from the web UI (Settings → Teleporter) for a quick restore.