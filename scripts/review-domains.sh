#!/bin/bash
# Interactive helper to review extracted domains and add selected ones to the rtp-play blocklist
# Usage: ./scripts/review-domains.sh /tmp/rtp-domains.txt

set -euo pipefail

INPUT_FILE="${1-}" 
BLOCKLIST="configs/blocklists/rtp-play.txt"

if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
  echo "Usage: $0 <domains_file>
Example: ./scripts/extract-domains.sh captures/...pcap > /tmp/rtp-domains.txt && $0 /tmp/rtp-domains.txt"
  exit 2
fi

mkdir -p "$(dirname "$BLOCKLIST")"
cp -n "$BLOCKLIST" "$BLOCKLIST.bak" 2>/dev/null || true

echo "Reviewing domains from: $INPUT_FILE"
echo "Existing rtp-play blocklist: $BLOCKLIST (backup at ${BLOCKLIST}.bak)"

ADDED=0
while IFS= read -r domain; do
  # skip comments/empty
  [ -z "$domain" ] && continue
  case "$domain" in
    \#*) continue ;;
  esac

  # skip if already present
  if grep -Fxq "$domain" "$BLOCKLIST" 2>/dev/null; then
    continue
  fi

  while true; do
    read -rp "Add domain '$domain' to $BLOCKLIST? [y/N/a=all/q=quit]: " ans
    ans=${ans:-N}
    case "$ans" in
      y|Y)
        echo "$domain" >> "$BLOCKLIST"
        ADDED=$((ADDED+1))
        break
        ;;
      a|A)
        echo "$domain" >> "$BLOCKLIST"
        ADDED=$((ADDED+1))
        # append remaining without prompting
        awk 'NR>0{print}' "$INPUT_FILE" | while IFS= read -r d; do
          if [ -n "$d" ] && ! grep -Fxq "$d" "$BLOCKLIST" 2>/dev/null; then
            echo "$d" >> "$BLOCKLIST"
            ADDED=$((ADDED+1))
          fi
        done
        echo "Added remaining domains."
        exit 0
        ;;
      q|Q)
        echo "Quitting."
        echo "Domains added: $ADDED"
        exit 0
        ;;
      *) break ;;
    esac
  done
done < "$INPUT_FILE"

echo "Done. Domains added: $ADDED"
echo "Next: run ./scripts/import-blocklists.sh to import into Pi-hole and then pihole -g if needed."
