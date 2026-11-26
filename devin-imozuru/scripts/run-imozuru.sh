#!/bin/bash
# imozuru engine wrapper for this VM.
# Why IMOZURU_ALLOW_FAKE_IP=1 lives only here: this VM resolves every
# hostname into 198.18.0.0/15 (a non-global benchmark range used by the
# egress proxy), so fetch.py's SSRF guard rejects every URL by default.
# The user approved lifting the guard inside this wrapper only
# (2026-11-26). The guard stays on everywhere else, and agents must
# still never fetch local/LAN addresses on purpose.
# Usage: run-imozuru.sh <fetch|ingest|chain|report|digest|watch> [args...]
set -euo pipefail
ENGINE="${IMOZURU_ENGINE_DIR:-$HOME/workspace/tools/imozuru-engine}/scripts"
tool="${1:-}"; shift || true
case "$tool" in
  fetch|ingest|chain|report|digest|watch) ;;
  *) echo "usage: run-imozuru.sh <fetch|ingest|chain|report|digest|watch> [args...]" >&2; exit 2 ;;
esac
exec env IMOZURU_ALLOW_FAKE_IP=1 PATH="${IMOZURU_ENGINE_DIR:-$HOME/workspace/tools/imozuru-engine}/shims:$PATH" python3 "$ENGINE/$tool.py" "$@"
