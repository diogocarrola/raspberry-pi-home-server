# How it works

- Pi-hole: DNS sinkhole — blocks hostnames listed in blocklists. When a device asks for an ad host, Pi-hole returns no IP (or 0.0.0.0), preventing the ad from loading.
- YouTube limitation: video and ad streams share CDN hostnames (`*.googlevideo.com`) so blocking by DNS risks breaking video playback; DNS lists are therefore only partially effective for YouTube ads.
- SmartTubeNext: client-side solution for Android TV that detects and skips ads inside the app. Recommended for Google TV.