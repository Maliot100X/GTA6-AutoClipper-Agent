#!/usr/bin/env bash
# Postpone MCP helper (https://api.postpone.app/mcp). Key from env POSTPONE_API_KEY (never print it).
# Usage: postpone.sh tools                      -> list tool names
#        postpone.sh call <tool> '<json args>'  -> call a tool
# RULE: postpone_create_social_post / edit / delete / reschedule ONLY after the user's explicit yes.
set -euo pipefail
U=https://api.postpone.app/mcp
req(){ curl -sf -m 60 -X POST "$U" -H "Authorization: Bearer $POSTPONE_API_KEY" -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -d "$1"; }
case "${1:-}" in
  tools) req '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | python3 -c 'import json,sys;[print(t["name"]) for t in json.load(sys.stdin)["result"]["tools"]]';;
  call) body=$(python3 -c 'import json,sys;print(json.dumps({"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":sys.argv[1],"arguments":json.loads(sys.argv[2] if len(sys.argv)>2 else "{}")}}))' "$2" "${3:-{\}}"); req "$body";;
  *) echo "usage: $0 tools | call <tool> '<json>'"; exit 1;;
esac
