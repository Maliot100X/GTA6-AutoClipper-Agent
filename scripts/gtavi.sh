#!/usr/bin/env bash
# Run any bundled gtavi-claudecode script with the repo venv.
# Usage: scripts/gtavi.sh <script> [args...]   e.g. scripts/gtavi.sh trends --hours 24 --limit 20
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
S="${1:?script name: trends|streams|moments|cut|check|live|twitch|payouts|questions|translate|secrets_map|facecam}"; shift
PY="$ROOT/.venv/bin/python"; [ -x "$PY" ] || PY=python3
cd "$ROOT"   # gtavi scripts write jobs/<id>/ relative to the working dir
exec "$PY" "$ROOT/vendor/gtavi-claudecode/scripts/$S.py" "$@"
