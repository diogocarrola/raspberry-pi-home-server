#!/bin/bash
# Helper to show network values and router instructions

IP=$(hostname -I | awk '{print $1}')
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Raspberry Pi IP: $IP"
echo "Network gateway: $GATEWAY"

echo "\nRouter setup (general):"
echo "1. Open http://$GATEWAY in your browser"
echo "2. Login to your router admin"
echo "3. Look for DHCP/DNS settings and set Primary DNS to: $IP"

echo "\nIf router does not allow changing DNS, set DNS manually on each device to: $IP"