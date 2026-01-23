# Raspberry Pi Home Server Features

Practical, reproducible features to run on a Raspberry Pi (or other Linux host). Each feature is documented under `features/` and can be enabled independently using the provided scripts and blocklists.

## Prerequisites

- A Linux host (Raspberry Pi OS recommended) with SSH access.
- Docker and Docker Compose (for Pi-hole container).
- Basic familiarity with running shell scripts.

## Prepare the host (quick)

Run these commands on the machine that will host Pi-hole:

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

This installs Docker/docker-compose (if missing), creates persistent data directories and starts Pi-hole using the repository scripts.

## Import blocklists

After Pi-hole is running, import the included blocklists:

```bash
./scripts/import-blocklists.sh
```

## Network configuration

- Preferred: set your router DHCP to hand out the Pi IP as Primary DNS so all devices use Pi-hole.
- Alternative: configure DNS manually on specific devices.

## Features & Quickstarts

Each feature contains a README with details. Below are concise quickstart commands to get the two main features working.

### Ad-free YouTube on Google TV (Pi-hole + SmartTubeNext)

1) Ensure Pi-hole is running (see Prepare the host above).
2) Optionally import SmartTV/YouTube blocklists:

```bash
./scripts/import-blocklists.sh
```

3) On Google TV install SmartTubeNext via the `Downloader` app and the APK URL:

```text
https://github.com/yuliskov/SmartTubeNext/releases/latest/download/smarttube_next.apk
```

See `features/ad-blocking/google-tv/README.md` for testing and details.

### Ad-free RTP Play (Pi-hole + device-level blocking)

If RTP Play shows ads on your device (mobile / Android TV / browser) you can follow this network-first workflow to identify ad domains and block them safely.

1) Preflight checks on the host:

```bash
chmod +x scripts/preflight.sh
./scripts/preflight.sh
```

2) Capture traffic while playing content that shows ads (example 120s):

```bash
./scripts/capture-traffic.sh <DEVICE_IP> 120
```

3) Extract candidate domains from the generated pcap:

```bash
./scripts/extract-domains.sh captures/rtpplay-<device-ip>-<timestamp>.pcap > /tmp/rtp-domains.txt
```

4) Curate and add ad domains interactively:

```bash
./scripts/review-domains.sh /tmp/rtp-domains.txt
```

5) Import curated blocklist into Pi-hole and update gravity:

```bash
./scripts/import-blocklists.sh
pihole -g
```

Notes: if ads are server-side stitched into the stream (same host as video) DNS blocking will likely break playback; prefer device-level filtering (AdGuard local VPN) or client-side solutions in that case.

## Safety & Maintenance

- Edit `./.env` to set a secure `WEBPASSWORD` before exposing the admin UI.
- Back up Pi-hole settings and DNS data: see `docs/BACKUP.md` and `scripts/backup.sh`.
- If using systemd to auto-start, update the example `scripts/pihole.service` with the correct working directory.

## Files of interest

- `scripts/` — installer and investigation helpers (`setup-pi.sh`, `capture-traffic.sh`, `extract-domains.sh`, `review-domains.sh`, `preflight.sh`, `import-blocklists.sh`, `backup.sh`)
- `configs/blocklists/` — curated lists and per-feature placeholder files (e.g., `rtp-play.txt`)
- `features/` — feature-specific docs and guides

## Contributing blocklists

If you find ad domains for a feature, open a PR that adds them to the appropriate `configs/blocklists/<feature>.txt` and include a short note about how the domains were discovered (pcap/tshark lines or other evidence).

Enjoy your raspberry pi home server!