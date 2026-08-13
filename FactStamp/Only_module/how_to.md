# FactStamp Typst Submission Workflow

> Created by Buffy (AI agent) for Aadish — July 2026

## Overview

This document explains how Module 4 Typst submission was created: code screenshots from the FactStamp React project, embedded into a `.typ` document, and compiled to PDF.

## Tools Used

| Tool | Purpose |
|---|---|
| **Typst** (`npx typst compile`) | Document typesetting — compiles `.typ` → PDF |
| **Chromium** (`/usr/bin/chromium --headless`) | Headless browser for taking screenshots |
| **highlight.js** (CDN) | Syntax highlighting inside the HTML page before screenshot |
| **ImageMagick** (`magick`) | Auto-crops the uniform page background after each screenshot, so images are exactly as tall as their code content (0px blank space) |

## Rules: When to Use vs. When NOT to Use

### ✅ WHEN TO USE `Only_module` Scripts (`code-screenshot-v4.sh` & `code-split.sh`)

1. **Full Application Code Submissions (Chapter 4 / Chapter 5 / Module 4 Submissions):**
   - Use when submitting actual production source code files (React components, TypeScript files, Firestore security rules, utility modules) as part of official code implementation deliverables.
2. **Visual IDE-Style Presentation Requirements:**
   - Use when the college blackbook format requires realistic code editor frames (with macOS-style window controls, active tab header, line numbers, and dark-theme syntax highlighting).
3. **Small to Medium Files (<150 Lines) → Use `code-screenshot-v4.sh`:**
   - Captures the complete file in a single screenshot at a 700px-wide viewport with 9px font size (viewport height is computed from the file's line count, so tall files are never clipped).
4. **Large Source Files (>150 Lines) → Use `code-split.sh`:**
   - Use to split tall code files into page-budgeted line range chunks (`start-line` to `end-line`, e.g., 1–70, 71–140) at 700x1100px viewport with 8px font size to fit neatly onto single A4 pages without line overflow or clipping.

---

### ❌ WHEN NOT TO USE `Only_module` Scripts

1. **Short Code Snippets & Config Blocks (1–15 Lines):**
   - **Do NOT** compile PNG screenshots for short code snippets, CLI commands, or inline JSON/YAML configs.
   - **Instead:** Use native Typst raw code blocks (```typescript ... ```) or the raw block styling handler defined in [`Typst_format.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md).
2. **Diagrams & Visual Schemas (UML, DFD, Architecture):**
   - **Do NOT** take code screenshots of `.puml` / `.dot` code or JSON schemas as diagram substitutes.
   - **Instead:** Render vector diagrams via PlantUML (`.puml` → SVG) or Graphviz (`.dot` → SVG) as mandated in [`Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md).
3. **Tabular Data & Event Tables:**
   - **Do NOT** format tables, database field lists, or event logs as code and screenshot them.
   - **Instead:** Use native Typst `#table()` or the `styled-table()` helper.
4. **Report Prose & Explanatory Text:**
   - **Do NOT** screenshot written explanations, markdown documentation, or algorithm pseudocode. Text must remain native, searchable PDF text in Typst.
5. **Parallel / Concurrent Script Execution:**
   - **Do NOT** execute `code-screenshot-v4.sh` or `code-split.sh` in parallel bash loops (`&`).
   - **Reason:** Temporary HTML files could race or clash. Always generate screenshots sequentially.

---

### 📋 Module Submission Decision Checklist (When Handling "Submission of Module X")

When creating a submission directory for a module (e.g. `Submission of Chp 4: ...` or `Submission of Module 4/`), follow this 4-step checklist:

1. **Step 1: Check Content Type**
   * **Full Application Source Code File** (`.tsx`, `.ts`, `.rules`, `.css`): **USE `Only_module` SCRIPTS**.
   * **UML Diagram** (Class, ER, State, Component, Use Case, Package): **Do NOT use `Only_module`** → Use PlantUML (`.puml` → SVG) per [`Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md).
   * **DFD Diagram** (Level 0, Level 1, Level 2): **Do NOT use `Only_module`** → Use Graphviz (`.dot` → SVG) per [`Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md).
   * **Short Snippet / Config / Shell Command (<15 lines)**: **Do NOT use `Only_module`** → Use native Typst raw block (`` ```ts ... ``` ``) per [`Typst_format.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md).
   * **Table / Event Matrix**: **Do NOT use `Only_module`** → Use native Typst `#table()` or `styled-table()`.

2. **Step 2: Check Code Line Count (`wc -l <file>`)**
   * **< 150 Lines**: Use `scripts/code-screenshot-v4.sh` (1 single tall screenshot, viewport `700x9999px`).
   * **≥ 150 Lines**: Use `scripts/code-split.sh` (split into ~70-line A4 chunks: 1–70, 71–140, 141–210, etc., viewport `700x1100px`).

3. **Step 3: Execution Order**
   * Run screenshot commands **sequentially**, never in parallel background processes.

4. **Step 4: Output Folder & File Naming**
   * **Folder Name**: **MUST EXACTLY MATCH** the user prompt string (e.g., `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/`).
   * **Sub-files (`.typ` & `.pdf`)**: Use a lowercase title slug with underscores (e.g., `data_integrity_and_security_issues.typ`).
   * **Attachments**: Save all generated `.png` code screenshots in the `attachments/` subfolder and embed with `#image("attachments/filename.png", width: 100%)`.

## The Screenshot Pipeline

### Step 1: Create an HTML page with syntax-highlighted code

A bash script builds an HTML page containing:
- A dark IDE-style window frame (traffic light dots + filename title bar)
- The source code wrapped in `<pre><code>` tags with `language-typescript` class
- highlight.js CSS + JS from CDN for syntax highlighting

### Step 2: Screenshot with headless Chromium

```
chromium --headless --screenshot=output.png --window-size=W,H file://page.html
```

Two screenshot scripts live in `scripts/` (persist across reboots):

| Script | Purpose |
|---|---|
| `scripts/code-screenshot-v4.sh` | Full-file screenshot (dynamic viewport height from line count) — captures entire file at once |
| `scripts/code-split.sh` | Line-range screenshot (viewport 700x1100) — captures specific lines to fit one A4 page |

### Step 3: Embed in Typst

```typst
#image("attachments/filename.png", width: 100%)
```

The `attachments/` folder keeps the Typst source directory clean.

## Script Reference

### `scripts/code-screenshot-v4.sh` — Full-file screenshot

```
Usage: bash scripts/code-screenshot-v4.sh <source-file> <output.png> <title>
```

Screenshots the entire source file at once. Viewport is 700px wide with a height computed from the file's line count (no 9999px cap, so files longer than ~700 lines are no longer clipped). Font: 9px. Good for smaller files (<150 lines).

### `scripts/code-split.sh` — Split screenshot (fits one page)

```
Usage: bash scripts/code-split.sh <source-file> <start-line> <end-line> <output.png> <title>
```

Screenshots only a specific line range. Viewport is 700x1100px to fit one A4 page. Font: 8px.

**Important:** Each run uses a unique temp file (hashed by output name) to avoid race conditions. Run sequentially, NOT in parallel.

## Line Chunking Logic

At 8px font with 1.35 line height, each screenshot fits ~70-80 lines of code on an A4 page.

To determine chunks for a file:
1. Check total lines: `wc -l src/path/to/file.ts`
2. Split into groups of ~70 lines
3. Generate each chunk sequentially:

```bash
for chunk in "1:70" "71:140" "141:210"; do
  start=${chunk%:*}
  end=${chunk#*:}
  bash scripts/code-split.sh src/file.ts $start $end "attachments/file-$start-$end.png" 'file.ts'
done
```

## Typst Document Structure

Each file section follows this pattern:

```typst
= `filename.ts` — Short Description

One-line explanation.

#image("attachments/filename-1-70.png", width: 100%)
#image("attachments/filename-71-140.png", width: 100%)
...
```

Key settings:
- Page margins: `(x: 2cm, y: 2.5cm)` to maximize code area
- Image width: `100%` to scale 700px screenshots to page width
- `#pagebreak()` between file sections

## Common Issues & Fixes

### Problem: All screenshots are identical
**Cause:** Scripts ran in parallel and overwrote the same `/tmp/code-page.html`
**Fix:** Use unique temp files per run (hashed by output name — already in the script)

### Problem: Screenshots too wide for PDF page
**Cause:** Chromium viewport too wide (900px+)
**Fix:** Use `--window-size=700,1100` — 700px fits A4 page margins when scaled with `width: 100%`

### Problem: Code is cut off / only top of file captured
**Cause:** Viewport height too small
**Fix:** `code-screenshot-v4.sh` already sizes its viewport from the file's line count, so it captures whole files of any length. If a specific range is still clipped, split it with `code-split.sh` line ranges instead.

### Problem: Blank/black space at the bottom of screenshots
**Cause:** Old scripts used fixed viewport sizes (700x9999 / 750x1100) that were taller than the code.
**Fix:** Both scripts now compute the viewport height from the line count AND auto-crop the uniform page background with ImageMagick after the screenshot, producing 0px of blank space regardless of line count.

### Problem: highlight.js not loading in headless Chromium
**Cause:** No internet connection for CDN
**Fix:** Download highlight.js locally: `wget https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js` and reference locally

## Quick Command Reference

```bash
# Check line count
wc -l src/lib/types.ts

# Full-file screenshot
bash scripts/code-screenshot-v4.sh src/lib/file.ts ./output.png 'file.ts'

# Split screenshot (lines 1-70)
bash scripts/code-split.sh src/lib/file.ts 1 70 ./output.png 'file.ts'

# Compile Typst to PDF
npx typst compile "Module 4.typ" "Module 4.pdf"

# Create attachments folder and move PNGs
mkdir -p attachments && mv *.png attachments/
# Then update .typ file: #image("attachments/file.png")
```

## Folder Structure Convention

- **Folder Name**: **MUST EXACTLY MATCH** the given submission prompt/title string (including colons, commas, numbers, and spaces).
- **Sub-files**: Use a **descriptive title slug** with lowercase words and underscores for the `.typ` and `.pdf` files.

```
Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/
├── data_integrity_and_security_issues.typ          ← Typst source (references attachments/)
├── data_integrity_and_security_issues.pdf          ← Compiled output
└── attachments/
    ├── file-1-70.png     ← Split screenshots
    └── file-71-140.png
```
