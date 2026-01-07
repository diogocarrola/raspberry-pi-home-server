# Feature: RTP Play — Ad reduction strategy

Short description

This feature documents a practical, reproducible approach to reduce or block ads shown by the RTP Play app (mobile / Android TV) and when accessing RTP Play from a browser. The goal is to provide a clear, network-first workflow that people can run from a Raspberry Pi (or other Linux host) using the existing project tooling (Pi-hole / AdGuard Home + importable blocklists). It also explains fallback options for app-level or stream-inserted ads.

Why this is different

RTP Play may show ads in different ways: (1) client-side ads loaded from ad servers (blockable by DNS/host blocking), or (2) server-side ads stitched into media streams (not blockable by DNS alone). This document explains how to discover which method RTP Play uses and provides recommended mitigations for each case.

High-level approach

- Investigate network requests made by RTP Play to find ad hosts/endpoints.
- If RTP Play loads ads from separate ad domains, add those domains to a blocklist and import to Pi-hole / AdGuard Home.
- If ads are server-side (stitched into streams), prefer client-side solutions: use an Android ad-blocking app (AdGuard for Android with local VPN), or a patched/alternative RTP client if available. Note: MITM HTTPS interception requires installing a CA on devices and may be blocked by certificate pinning.
- Provide step-by-step capture, blocklist creation, and testing instructions so users can add this feature themselves.

Investigation steps (recommended)

1. Capture traffic while playing content that shows ads:

 - On the LAN: run `tcpdump` on the Pi to capture traffic to/from the TV/device IP (pcap saved). Example:

 ```bash
 sudo tcpdump -i any host <DEVICE_IP> -w rtpplay.pcap
 ```

 Or use the included helper script (creates `captures/`):

 ```bash
 ./scripts/capture-traffic.sh <DEVICE_IP> [DURATION_SECONDS]
 ```

 - Alternatively run `mitmproxy` or `mitmproxy --mode transparent` on a local machine and route the device through it (only for advanced users).

2. Inspect the pcap in Wireshark or use `tshark`/`ngrep` to find domains and URLs requested around ad playback times. Look for calls to `ads`, `banner`, `vast`, `manifest` endpoints or third-party ad domains.

3. Identify candidate domains used exclusively for ads. Add them to `configs/blocklists/rtp-play.txt` and import to Pi-hole using `./scripts/import-blocklists.sh`.

Helper to extract domains from a pcap

After capturing traffic, use the helper to extract candidate domains (DNS queries, TLS SNI, HTTP Host):

```bash
./scripts/extract-domains.sh captures/rtpplay-<device-ip>-<timestamp>.pcap > /tmp/rtp-domains.txt
```

Review `/tmp/rtp-domains.txt`, pick high-confidence ad domains and add them to `configs/blocklists/rtp-play.txt`.

Mitigation options

- Network-level (recommended first): Add discovered ad domains to Pi-hole / AdGuard Home blocklists; set router/DHCP to use Pi as DNS.
- Device-level: Install AdGuard for Android (local VPN) on phones or Android TV (if available) to filter ads in-app without network DNS changes.
- Proxy/inspection: Use an HTTP(S) proxy with content rules (requires device CA install; not reliable if app uses certificate pinning).
- Last resort: find alternative clients or ask RTP for ad-free options (e.g., paywall/subscription) or use official settings if provided.

Limitations & notes

- If RTP Play serves server-side stitched ads from the same domain as the video content (same host), DNS blocking will break playback — do not block those hosts. In that case, prefer device-side ad-blocking or a patched client.
- Some apps may use CDNs or wide-scope hostnames; blocking those can break playback. Always test and whitelist necessary hosts.
- Be mindful of legal/ToS implications when modifying apps or intercepting traffic.

How to add this feature to your Pi (summary)

1. Add domains to `configs/blocklists/rtp-play.txt` (after investigation).
2. Run `./scripts/import-blocklists.sh` to import into Pi-hole and `pihole -g` (gravity update).
3. Test playback on devices and revert any host that breaks video.

Files in this feature

- `configs/blocklists/rtp-play.txt` — placeholder blocklist to populate after investigation.
- This README: investigation guide and recommended steps.

If you want, I can add a minimal `scripts/capture-traffic.sh` helper and a short guide with example `tshark`/`grep` commands to speed up domain extraction.
