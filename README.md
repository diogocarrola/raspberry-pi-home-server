# Raspberry Pi Home Server Features

Collection of cool features to run on a Raspberry Pi (or other Linux host) to improve your home network and media experience.

## Quick start (Pi-hole + SmartTubeNext)

1) Prepare the host (Raspberry Pi recommended)

```bash
sudo apt update && sudo apt upgrade -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt install -y docker-compose
git clone https://github.com/YOUR_USERNAME/raspberry-pi-home-server.git
cd raspberry-pi-home-server
cp .env.example .env        # edit .env to set a secure WEBPASSWORD
./scripts/setup-pi.sh
```

2) (Optional) Import recommended blocklists

```bash
./scripts/import-blocklists.sh
```

3) Configure your network

- Set your router's DHCP to hand out the Raspberry Pi IP as primary DNS (recommended), or set the DNS on each device manually.

4) Install SmartTubeNext on Google TV

- Install the `Downloader` app on Google TV and allow installs from it.
- In `Downloader` enter: https://github.com/yuliskov/SmartTubeNext/releases/latest/download/smarttube_next.apk and install.

**Notes & Safety**

- Edit `./.env` to set a secure `WEBPASSWORD` before exposing the Pi-hole admin UI.
- Backups: see `docs/BACKUP.md` and `scripts/backup.sh` for Teleporter and filesystem backups.
- If you want Pi automatic start on boot, use the example systemd unit `scripts/pihole.service` (update the working directory placeholder).

**Features**

All features are in the `features/` folder with documentation.

Examples:
	- RTP Play (Portugal): [features/ad-blocking/rtp-play/README.md](features/ad-blocking/rtp-play/README.md)

Enjoy your Raspberry Pi home server!