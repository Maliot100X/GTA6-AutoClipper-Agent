#!/usr/bin/env bash
# Official YouTube Data API v3 helper (read-only). Key from env YOUTUBE_API_KEY (never print it).
# Usage: yt.sh videos <id,id,...>                 -> snippet, statistics, contentDetails
#        yt.sh search "<query>" [days] [order]   -> top videos (default 7 days, order=viewCount)
#        yt.sh live "<query>"                    -> live streams now
#        yt.sh raw "<endpoint?params>"           -> any v3 endpoint (key appended)
# Quota: 10,000 units/day; search costs 100, videos costs 1. Prefer TubeAlfred for bulk search.
set -euo pipefail
B=https://www.googleapis.com/youtube/v3
enc(){ python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))' "$1"; }
case "${1:-}" in
  videos) curl -sf "$B/videos?part=snippet,statistics,contentDetails&id=$2&key=$YOUTUBE_API_KEY";;
  search) after=$(date -u -d "-${3:-7} days" +%Y-%m-%dT%H:%M:%SZ); curl -sf "$B/search?part=snippet&type=video&maxResults=25&order=${4:-viewCount}&publishedAfter=$after&q=$(enc "$2")&key=$YOUTUBE_API_KEY";;
  live) curl -sf "$B/search?part=snippet&type=video&eventType=live&maxResults=25&order=viewCount&q=$(enc "$2")&key=$YOUTUBE_API_KEY";;
  raw) curl -sf "$B/$2&key=$YOUTUBE_API_KEY";;
  *) echo "usage: $0 videos|search|live|raw"; exit 1;;
esac
