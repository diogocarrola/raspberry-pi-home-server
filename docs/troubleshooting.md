# Troubleshooting

1) Pi-hole admin unreachable
- Check container: `docker ps | grep pihole`
- Check host ports: `ss -ltnp | grep -E ":(53|80)"`

2) DNS not filtering
- Ensure devices use Pi IP as DNS. Use `./scripts/setup-network.sh` to find IP and gateway.

3) Blocked site breaks services
- Remove aggressive blocklists or whitelist required hostnames in Pi-hole Admin.