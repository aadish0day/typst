#!/bin/bash
set -e

# Crop the uniform page background out of a screenshot so the image is
# exactly as tall/wide as its content. Background is #282c34 (RGB 40,44,52);
# row/column extents are found by averaging each row/column and scanning for
# the first/last value that differs from the background. Requires ImageMagick.
crop_image() {
  local img="$1"
  local w h y0 y1 x0 x1
  w=$(magick "$img" -format %w info:)
  h=$(magick "$img" -format %h info:)
  read y0 y1 < <(magick "$img" -resize 1x${h}! -depth 8 txt:- | awk -F'[(),: ]+' 'NR>1 { y=$2+0; if (!($3==40 && $4==44 && $5==52)) { if (y0=="") y0=y; y1=y } } END { print (y0=="" ? -1 : y0), (y1=="" ? -1 : y1) }')
  read x0 x1 < <(magick "$img" -resize ${w}x1! -depth 8 txt:- | awk -F'[(),: ]+' 'NR>1 { x=$1+0; if (!($3==40 && $4==44 && $5==52)) { if (x0=="") x0=x; x1=x } } END { print (x0=="" ? -1 : x0), (x1=="" ? -1 : x1) }')
  if [ "$y0" -ge 0 ] && [ "$x0" -ge 0 ]; then
    magick "$img" -crop $((x1-x0+1))x$((y1-y0+1))+${x0}+${y0} +repage "$img"
  fi
}

CODE_FILE=$(realpath "$1" 2>/dev/null || echo "$1")
START_LINE="$2"
END_LINE="$3"
OUTPUT_FILE=$(realpath -m "$4")
TITLE="$5"

if [ $# -lt 4 ] || [ -z "$1" ] || [ -z "$START_LINE" ] || [ -z "$END_LINE" ] || [ -z "$4" ]; then
  echo "Usage: bash $0 <source-file> <start-line> <end-line> <output.png> [title]" >&2
  exit 1
fi
if [ ! -f "$CODE_FILE" ]; then
  echo "ERROR: source file not found: $CODE_FILE" >&2
  exit 1
fi

TOTAL_LINES=$(wc -l < "$CODE_FILE")
if [ "$START_LINE" -lt 1 ] || [ "$START_LINE" -gt "$TOTAL_LINES" ]; then
  echo "ERROR: start line $START_LINE outside range 1..$TOTAL_LINES" >&2
  exit 1
fi
if [ "$END_LINE" -gt "$TOTAL_LINES" ]; then
  echo "Note: clamping end line $END_LINE to $TOTAL_LINES (file has fewer lines)" >&2
  END_LINE=$TOTAL_LINES
fi
if [ "$END_LINE" -lt "$START_LINE" ]; then
  echo "ERROR: end line $END_LINE is before start line $START_LINE" >&2
  exit 1
fi

# highlight.js language derived from the source extension. Unknown
# extensions fall back to typescript (previous behaviour); .rules keeps
# typescript so re-runs match already-submitted screenshots.
LANG_NAME="typescript"
case "$CODE_FILE" in
  *.ts|*.tsx|*.rules) LANG_NAME="typescript" ;;
  *.js|*.jsx|*.mjs|*.cjs) LANG_NAME="javascript" ;;
  *.css) LANG_NAME="css" ;;
  *.json) LANG_NAME="json" ;;
  *.html|*.htm|*.xml|*.svg) LANG_NAME="xml" ;;
  *.sh|*.bash) LANG_NAME="bash" ;;
  *.py) LANG_NAME="python" ;;
  *.md) LANG_NAME="markdown" ;;
  *.yml|*.yaml) LANG_NAME="yaml" ;;
esac

HASH=$(printf '%s' "$OUTPUT_FILE" | md5sum | cut -c1-8)
HTML_FILE="/tmp/code-page-${HASH}.html"

# Extract the specific line range
RAW_CODE=$(sed -n "${START_LINE},${END_LINE}p" "$CODE_FILE")
NUM_LINES=$((END_LINE - START_LINE + 1))

# 12.5px font, 1.45 line-height → 18.125px/line; header + pre padding + margins ≈ 56px
HEIGHT=$((NUM_LINES * 19 + 56))
if [ "$HEIGHT" -lt 150 ]; then
  HEIGHT=150
fi

# Build HTML
cat > "$HTML_FILE" << 'HTMLSTART'
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<style>
  html, body { margin: 0; padding: 0; background: #282c34; overflow: hidden; }
  .code-wrapper {
    background: #1e1e1e; border-radius: 6px; margin: 4px;
    overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.3);
  }
  .code-header {
    background: #2d2d2d; padding: 6px 12px; display: flex; align-items: center;
    gap: 6px; border-bottom: 1px solid #3d3d3d;
  }
  .code-header .dots { display: flex; gap: 5px; }
  .code-header .dot { width: 9px; height: 9px; border-radius: 50%; }
  .code-header .dot:nth-child(1) { background: #ff5f57; }
  .code-header .dot:nth-child(2) { background: #febc2e; }
  .code-header .dot:nth-child(3) { background: #28c840; }
  .code-header .title { color: #abb2bf; font-size: 11px; font-weight: bold; font-family: sans-serif; margin-left: 6px; }
  pre { margin: 0; padding: 10px 14px; overflow: hidden; }
  code { font-family: 'Fira Code', 'DejaVu Sans Mono', monospace; font-size: 12.5px; line-height: 1.45; }
  .hljs { background: #1e1e1e !important; }
</style>
</head>
<body>
<div class="code-wrapper">
  <div class="code-header">
    <div class="dots"><span class="dot"></span><span class="dot"></span><span class="dot"></span></div>
    <span class="title">__TITLE__ (lines __START__-__END__)</span>
  </div>
  <pre><code class="language-__LANG__">__CODE__</code></pre>
</div>
<script>hljs.highlightAll();</script>
</body>
</html>
HTMLSTART

# Base64-encode user content, then inject via python — immune to sed
# special characters (& | \), quotes, and HTML entities in title/code.
B64_CODE=$(printf '%s' "$RAW_CODE" | base64 -w0)
B64_TITLE=$(printf '%s' "${TITLE:-$(basename "$CODE_FILE")}" | base64 -w0)

python3 - "$HTML_FILE" "$B64_TITLE" "$B64_CODE" "$LANG_NAME" "$START_LINE" "$END_LINE" <<'PYEOF'
import base64, html, sys
html_file, b64_title, b64_code, lang, start, end = sys.argv[1:7]
with open(html_file, 'r') as f:
    content = f.read()
title = html.escape(base64.b64decode(b64_title).decode('utf-8', 'replace'), quote=True)
content = (content.replace('__TITLE__', title)
                 .replace('__LANG__', lang)
                 .replace('__START__', start)
                 .replace('__END__', end))
code = html.escape(base64.b64decode(b64_code).decode('utf-8', 'replace'), quote=True)
content = content.replace('__CODE__', code)
with open(html_file, 'w') as f:
    f.write(content)
PYEOF

# Screenshot using firefox or fallback browsers
if command -v firefox >/dev/null 2>&1; then
  TMP_FF_PROF=$(mktemp -d /tmp/ff_prof_XXXXXX)
  firefox --headless --no-remote --profile "$TMP_FF_PROF" --screenshot="$OUTPUT_FILE" --window-size=750,${HEIGHT} "file://${HTML_FILE}" 2>/dev/null
  rm -rf "$TMP_FF_PROF"
elif command -v chromium >/dev/null 2>&1; then
  chromium --headless --disable-gpu --no-sandbox --disable-software-rasterizer \
    --screenshot="$OUTPUT_FILE" --window-size=750,${HEIGHT} \
    --hide-scrollbars \
    --virtual-time-budget=2000 \
    "file://${HTML_FILE}" 2>/dev/null
elif command -v google-chrome >/dev/null 2>&1; then
  google-chrome --headless --disable-gpu --no-sandbox \
    --screenshot="$OUTPUT_FILE" --window-size=750,${HEIGHT} \
    --hide-scrollbars \
    "file://${HTML_FILE}" 2>/dev/null
else
  echo "ERROR: No supported headless browser found" >&2
  exit 1
fi

if [ ! -s "$OUTPUT_FILE" ]; then
  echo "ERROR: chromium produced no screenshot at $OUTPUT_FILE" >&2
  exit 1
fi

# Crop the uniform page background around the code box so the image is
# exactly as tall (and wide) as its content — no leftover blank space.
crop_image "$OUTPUT_FILE"

echo "Written: $(stat -c%s "$OUTPUT_FILE") bytes to $OUTPUT_FILE (viewport 750x${HEIGHT})"
