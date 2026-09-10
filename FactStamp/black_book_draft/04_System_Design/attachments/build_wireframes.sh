#!/usr/bin/env bash
# Build every wireframe_*.html in this folder into a print-quality PNG.
#
# Why HTML rather than PlantUML Salt: Rules/Diagrams-Checklist.md item 16 asks
# for "SVG / High-Res Mockups", not a UML diagram. Salt renders hairline boxes
# with no typographic hierarchy; HTML+CSS gives real spacing, weight and state
# (selected / disabled), and still prints correctly in greyscale.
#
# Renders at 2x device scale: 900 CSS px -> 1800 px, embedded at ~14 cm wide
# in the book, which is ~325 dpi — comfortably above print requirement.
#
# Usage:  ./build_wireframes.sh            # build all
#         ./build_wireframes.sh submit     # build only wireframe_submit.html
set -euo pipefail
cd "$(dirname "$0")"

filter="${1:-}"
built=0

for html in wireframe_*.html; do
  [ -e "$html" ] || { echo "no wireframe_*.html found"; exit 1; }
  name="${html%.html}"
  if [ -n "$filter" ] && [[ "$name" != *"$filter"* ]]; then continue; fi

  # Tall window so nothing is cut off; -trim crops back to actual content.
  chromium --headless --disable-gpu --no-sandbox --hide-scrollbars \
           --force-device-scale-factor=2 \
           --window-size=900,2400 \
           --screenshot="$name.png" "$html" 2>/dev/null

  # Trim the empty area below the content, then restore a small white margin.
  magick "$name.png" -trim +repage -bordercolor white -border 16 "$name.png"

  dims=$(magick identify -format "%wx%h" "$name.png")
  echo "  built $name.png  ($dims)"
  built=$((built+1))
done

echo "done: $built wireframe(s)"
