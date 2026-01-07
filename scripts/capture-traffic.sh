#!/bin/bash
# Capture network traffic to/from a device IP into a pcap file.
# Usage: ./scripts/capture-traffic.sh <DEVICE_IP> [DURATION_SECONDS]

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <DEVICE_IP> [DURATION_SECONDS]"
  exit 2
fi

DEVICE_IP="$1"
DURATION="${2-60}"
OUTDIR="captures"
mkdir -p "$OUTDIR"
TS=$(date +%Y%m%d-%H%M%S)
OUTFILE="$OUTDIR/rtpplay-${DEVICE_IP//./-}-$TS.pcap"

echo "Capturing traffic for device $DEVICE_IP for $DURATION seconds -> $OUTFILE"

# If duration is 0, run until interrupted
if [ "$DURATION" -eq 0 ]; then
  sudo tcpdump -i any host "$DEVICE_IP" -w "$OUTFILE"
else
  sudo timeout "$DURATION" tcpdump -i any host "$DEVICE_IP" -w "$OUTFILE"
fi

echo "Capture complete: $OUTFILE"
echo "To extract candidate domains: ./scripts/extract-domains.sh $OUTFILE"
