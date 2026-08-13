#!/bin/bash
set -e

CODE_FILE="$1"
START_LINE="$2"
END_LINE="$3"
OUTPUT_FILE="$4"
TITLE="$5"
HASH=$(echo "$OUTPUT_FILE" | md5sum | cut -c1-8)
HTML_FILE="/tmp/code-page-${HASH}.html"

# Extract the specific line range
RAW_CODE=$(sed -n "${START_LINE},${END_LINE}p" "$CODE_FILE")
NUM_LINES=$((END_LINE - START_LINE + 1))

# Dynamic height calculation: 21px per line + 55px header/padding
HEIGHT=$((NUM_LINES * 21 + 55))
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
  html, body { margin: 0; padding: 0; background: #1e1e1e; overflow: hidden; }
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
  <pre><code class="language-typescript">__CODE__</code></pre>
</div>
<script>hljs.highlightAll();</script>
</body>
</html>
HTMLSTART

# Escape the code for HTML
ESCAPED_CODE=$(printf '%s\n' "$RAW_CODE" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')

# Replace placeholders
sed -i "s|__TITLE__|$TITLE|g" "$HTML_FILE"
sed -i "s|__START__|$START_LINE|g" "$HTML_FILE"
sed -i "s|__END__|$END_LINE|g" "$HTML_FILE"

# Base64 encode code snippet for safe python injection
B64_CODE=$(printf '%s\n' "$ESCAPED_CODE" | base64 -w0)

python3 -c "
import base64
with open('$HTML_FILE', 'r') as f:
    content = f.read()
code = base64.b64decode('$B64_CODE').decode('utf-8')
content = content.replace('__CODE__', code)
with open('$HTML_FILE', 'w') as f:
    f.write(content)
"

# Use tight dynamic viewport height based on actual lines of code
/usr/bin/chromium --headless --disable-gpu --no-sandbox --disable-software-rasterizer \
  --screenshot="$OUTPUT_FILE" --window-size=750,${HEIGHT} \
  --hide-scrollbars \
  --virtual-time-budget=2000 \
  "file://${HTML_FILE}" 2>/dev/null

echo "Written: $(stat -c%s "$OUTPUT_FILE") bytes to $OUTPUT_FILE (viewport 750x${HEIGHT})"
