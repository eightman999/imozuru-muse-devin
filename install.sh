#!/bin/bash
# Install imozuru for Muse and/or Devin CLI from this repo checkout.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
ENGINE_DIR="${IMOZURU_ENGINE_DIR:-$HOME/workspace/tools/imozuru-engine}"
mkdir -p "$ENGINE_DIR"
cp -r "$SRC/engine/scripts" "$SRC/engine/references" "$SRC/engine/assets" "$SRC/engine/shims" "$ENGINE_DIR/"
cp "$SRC/engine/LICENSE" "$SRC/engine/UPSTREAM.md" "$ENGINE_DIR/"
chmod +x "$ENGINE_DIR/shims/tesseract" "$ENGINE_DIR/shims/yt-dlp"
if [ "${1:-all}" = "all" ] || [ "${1:-}" = "muse" ]; then
  mkdir -p "$HOME/workspace/custom-skills/muse-imozuru/scripts"
  cp "$SRC/muse-imozuru/SKILL.md" "$SRC/muse-imozuru/skill.yaml" "$HOME/workspace/custom-skills/muse-imozuru/"
  cp "$SRC/muse-imozuru/scripts/run-imozuru.sh" "$HOME/workspace/custom-skills/muse-imozuru/scripts/"
  chmod +x "$HOME/workspace/custom-skills/muse-imozuru/scripts/run-imozuru.sh"
  echo "muse-imozuru installed"
fi
if [ "${1:-all}" = "all" ] || [ "${1:-}" = "devin" ]; then
  mkdir -p "$HOME/.config/devin/skills/devin-imozuru/scripts"
  cp "$SRC/devin-imozuru/SKILL.md" "$HOME/.config/devin/skills/devin-imozuru/"
  cp "$SRC/devin-imozuru/scripts/run-imozuru.sh" "$HOME/.config/devin/skills/devin-imozuru/scripts/"
  chmod +x "$HOME/.config/devin/skills/devin-imozuru/scripts/run-imozuru.sh"
  echo "devin-imozuru installed (invoke as /devin-imozuru in Devin CLI)"
fi
echo "engine at $ENGINE_DIR"
