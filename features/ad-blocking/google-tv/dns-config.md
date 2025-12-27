# DNS Config for Google TV (Pi-hole)

1. Find your Raspberry Pi IP (on the Pi):

```bash
hostname -I | awk '{print $1}'
```

2. On Google TV: Settings → Network → [your network] → Advanced → IP settings → DNS → set to the Pi IP.
3. If possible, set router DHCP to hand out Pi IP as DNS (network-wide).
4. Reboot Google TV to clear DNS caches.

Notes: DNS-level blocking is partial for YouTube; use SmartTubeNext for complete ad removal.
