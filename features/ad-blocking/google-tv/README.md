# Feature: Ad-free YouTube on Google TV

## Short description

Ad-free YouTube experience on Google TV by combining a network DNS filter (Pi-hole) with the client app SmartTubeNext.

## Why it helps

Pi-hole blocks known ad/tracker domains at DNS level across the network. SmartTubeNext removes or avoids in-stream YouTube ads on the device itself. Combining both increases reliability and privacy.

## Install steps

1) (Optional) Run Pi-hole on your network and import recommended blocklists:

```bash
./scripts/setup-pi.sh
./scripts/import-blocklists.sh
```

2) On Google TV:

- Install `Downloader` from the Play Store.
- Allow `Downloader` to install apps (Security settings).
- In `Downloader` enter: https://github.com/yuliskov/SmartTubeNext/releases/latest/download/smarttube_next.apk and install SmartTubeNext.

3) (Optional) Point Google TV DNS to your Pi-hole IP for extra filtering (or set router DHCP DNS to the Pi).

## Files included

- `scripts/install-adblocker.sh` - installer for Pi-hole in Docker.
- `scripts/import-blocklists.sh` - imports `configs/blocklists/default.txt` into Pi-hole.
- `configs/blocklists/default.txt` - curated blocklists for SmartTV/YouTube.