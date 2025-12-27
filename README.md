# Raspberry Pi Home Server Features

Collection of cool features to run on a Raspberry Pi home server, focused on improving daily digital life.

## Quick start (Pi-hole + SmartTubeNext)

On the Raspberry Pi (install Pi-hole using the included script):

```bash
sudo apt update && sudo apt upgrade -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt install -y docker-compose
git clone https://github.com/YOUR_USERNAME/raspberry-pi-home-server.git
cd raspberry-pi-home-server
./scripts/install-adblocker.sh
```

On Google TV (install SmartTubeNext):

1. Install `Downloader` from Play Store.
2. Settings → Security → Allow `Downloader` to install apps.
3. In `Downloader` enter: `https://github.com/yuliskov/SmartTubeNext/releases/latest/download/smarttube_next.apk` and install.

Features

- Ad blocking
	- Google TV YouTube: `features/ad-blocking/google-tv/README.md`
	- Network-wide Pi-hole: `features/ad-blocking/network-wide/pihole-setup.md`
- (To be continued...)

Enjoy your improved Raspberry Pi home server!