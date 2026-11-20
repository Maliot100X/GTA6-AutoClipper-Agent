#!/usr/bin/env bash
# Supadata REST helper. Key comes from env SUPADATA_API_KEY (never print it).
# Usage: supadata.sh transcript <youtube_url> [lang]   -> plain-text transcript JSON
#        supadata.sh video <youtube_id>               -> video metadata JSON
#        supadata.sh raw <path?query>                 -> any /v1 endpoint
set -euo pipefail
B=https://api.supadata.ai/v1
case "${1:-}" in
  transcript) q="url=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=""))' "$2")&text=true${3:+&lang=$3}"; curl -sf -H "x-api-key: $SUPADATA_API_KEY" "$B/youtube/transcript?$q";;
  video) curl -sf -H "x-api-key: $SUPADATA_API_KEY" "$B/youtube/video?id=$2";;
  raw) curl -sf -H "x-api-key: $SUPADATA_API_KEY" "$B/$2";;
  *) echo "usage: $0 transcript|video|raw ..."; exit 1;;
esac
