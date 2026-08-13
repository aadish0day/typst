#!/bin/bash
set -e

CODE_FILE="$1"
OUTPUT_FILE="$2"
TITLE="$3"
HASH=$(echo "$OUTPUT_FILE" | md5sum | cut -c1-8)
HTML_FILE="/tmp/code-page-${HASH}.html"

RAW_CODE=$(cat "$CODE_FILE")

# Build HTML — compact styling to fit PDF page
cat > "$HTML_FILE" << 'HTMLSTART'
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<style>
  html, body { margin: 0; padding: 0; background: #282c34; }
  .code-wrapper {
    background: #1e1e1e; border-radius: 8px; margin: 10px;
    overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.3);
  }
  .code-header {
    background: #2d2d2d; padding: 6px 12px; display: flex; align-items: center;
    gap: 6px; border-bottom: 1px solid #3d3d3d;
  }
  .code-header .dots { display: flex; gap: 5px; }
  .code-header .dot { width: 8px; height: 8px; border-radius: 50%; }
  .code-header .dot:nth-child(1) { background: #ff5f57; }
  .code-header .dot:nth-child(2) { background: #febc2e; }
  .code-header .dot:nth-child(3) { background: #28c840; }
  .code-header .title { color: #999; font-size: 10px; font-family: sans-serif; margin-left: 6px; }
  pre { margin: 0; padding: 8px 12px; overflow: visible; }
  code { font-family: 'JetBrains Mono', 'Fira Code', monospace; font-size: 9px; line-height: 1.4; }
  .hljs { background: #1e1e1e !important; }
</style>
</head>
<body>
<div class="code-wrapper">
  <div class="code-header">
    <div class="dots"><span class="dot"></span><span class="dot"></span><span class="dot"></span></div>
    <span class="title">__TITLE__</span>
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

python3 -c "
with open('$HTML_FILE', 'r') as f:
    content = f.read()
with open('/dev/stdin', 'r') as code_file:
    code = code_file.read()
content = content.replace('__CODE__', code)
with open('$HTML_FILE', 'w') as f:
    f.write(content)
" <<< "$ESCAPED_CODE"

# Use 700px width (fits A4 page margins), tall height for full code
/usr/bin/chromium --headless --disable-gpu --no-sandbox --disable-software-rasterizer \
  --screenshot="$OUTPUT_FILE" --window-size=700,9999 \
  --virtual-time-budget=3000 \
  "file://${HTML_FILE}" 2>/dev/null

echo "Written: $(stat -c%s "$OUTPUT_FILE") bytes to $OUTPUT_FILE"
