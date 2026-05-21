#!/bin/bash
# Asset download script template for Remotion video projects
# Usage: bash scripts/download-assets.sh

set -e

ASSETS_DIR="public/assets"
mkdir -p "$ASSETS_DIR"

echo "=== Downloading assets for Remotion video ==="

# === TTS AUDIO FILES ===
# These should be generated separately using edge-tts or ElevenLabs
# Place them in public/assets/ before running this script

echo "Checking TTS audio files..."
for file in hook.mp3 problem.mp3 observation.mp3 tension.mp3 close.mp3; do
  if [ -f "$ASSETS_DIR/$file" ]; then
    echo "  ✓ $file"
  else
    echo "  ✗ $file MISSING — generate with edge-tts or ElevenLabs"
  fi
done

# === STOCK FOOTAGE ===
# Replace URLs with actual Pexels/Pixabay/Unsplash URLs
# Get video URLs from:
#   Pexels: https://api.pexels.com/videos/search?query=dark+office&per_page=1
#   Pixabay: https://pixabay.com/api/videos/?q=dark+office

echo ""
echo "Downloading stock footage..."

# Example: Dark office footage (replace with real URL)
# curl -L "https://videos.pexels.com/video-files/.../video.mp4" \
#   -o "$ASSETS_DIR/office-dark.mp4" \
#   -H "Authorization: YOUR_PEXELS_API_KEY"

echo "  ⚠ office-dark.mp4 — Add your Pexels/Pixabay URL to this script"

# === MOCKUP IMAGES ===
# These can be generated programmatically or sourced from free image sites

echo ""
echo "Downloading mockup images..."

# Example: Dashboard background
# curl -L "https://images.unsplash.com/photo-..." \
#   -o "$ASSETS_DIR/dashboard-bg.jpg"

echo "  ⚠ call-log.png — Generate programmatically or add URL"

# === VERIFY ===
echo ""
echo "=== Asset verification ==="
ls -la "$ASSETS_DIR/"

echo ""
echo "Done. Run 'npm run dev' to preview or 'npx remotion render' to export."
