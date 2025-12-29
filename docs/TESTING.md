# Testing checklist

Follow these steps after installing Pi-hole and SmartTubeNext to verify behavior.

1. Check Pi-hole container is running

```bash
docker ps | grep pihole
```

2. Open Pi-hole admin UI
- Visit: `http://<PI_IP>/admin`
- Log in with the `WEBPASSWORD` value in `.env`.

3. Import blocklists
- Admin → Settings → Blocklists → add URLs from `configs/blocklists/default.txt` → Update Gravity

4. Verify DNS queries
- In Admin → Query Log, watch queries while browsing from laptop/phone.

5. Verify SmartTubeNext on Google TV
- Open SmartTubeNext and play a video — pre-roll/mid-roll ads should be gone.

6. If issues
- Check container logs: `docker logs pihole`.
- Check port conflicts (53/80) on the host: `ss -ltnp | grep -E ":(53|80)"`.