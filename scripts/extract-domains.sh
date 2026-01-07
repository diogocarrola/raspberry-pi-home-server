#!/bin/bash
# Extract candidate hostnames from a pcap (DNS queries, HTTP Host, TLS SNI).
# Usage: ./scripts/extract-domains.sh <PCAP_FILE> [OUTPUT_FILE]

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <PCAP_FILE> [OUTPUT_FILE]"
  exit 2
fi

PCAP="$1"
OUTFILE="${2-:-}" 

if ! command -v tshark >/dev/null 2>&1; then
  echo "Error: tshark is required. Install with: sudo apt install -y tshark"
  exit 1
fi

echo "Extracting domains from: $PCAP"

# Extract DNS queries
tshark -r "$PCAP" -Y dns.qry.name -T fields -e dns.qry.name 2>/dev/null || true \
  | sed 's/^\.|\.$//g' > /tmp/_domains_raw.txt || true

# Extract TLS SNI (for modern TLS)
tshark -r "$PCAP" -Y "tls.handshake.extensions_server_name" -T fields -e tls.handshake.extensions_server_name 2>/dev/null || true \
  >> /tmp/_domains_raw.txt || true

# Extract HTTP Host headers
tshark -r "$PCAP" -Y http.host -T fields -e http.host 2>/dev/null || true \
  >> /tmp/_domains_raw.txt || true

# Normalize, filter heuristics
cat /tmp/_domains_raw.txt \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/^\s*//;s/\s*$//' \
  | grep -E '\.' \
  | sed 's/:.*$//' \
  | sort -u \
  | awk 'length($0) > 3' > /tmp/_domains_final.txt || true

if [ -n "$OUTFILE" ]; then
  cp /tmp/_domains_final.txt "$OUTFILE"
  echo "Domains written to $OUTFILE"
else
  cat /tmp/_domains_final.txt
fi

echo "Tip: review the list and move high-confidence ad domains into configs/blocklists/rtp-play.txt before importing into Pi-hole."
