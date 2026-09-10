#!/usr/bin/env python3
"""Stylometric AI-writing scorer for the black book draft.

Reads .typ / .md / .txt sources, strips markup, and scores every paragraph on
the patterns that AI detectors and human examiners actually react to: uniform
sentence rhythm, em-dash addiction, antithesis scaffolding ("not X but Y"),
stock LLM vocabulary, and transition padding.

This is a heuristic, not a classifier. It tells you WHICH sentences read as
machine-written and WHY, so you can rewrite them. It does not reproduce the
score of GPTZero or Turnitin.

Usage:
    python3 tools/ai_score.py                     # score whole draft
    python3 tools/ai_score.py master_draft.pdf    # score the compiled PDF
    python3 tools/ai_score.py 07_Conclusions      # score one chapter
    python3 tools/ai_score.py --ext .md           # only markdown sources
    python3 tools/ai_score.py --top 15            # worst 15 paragraphs
    python3 tools/ai_score.py --json report.json  # machine-readable

To rewrite what this flags, pipe the JSON into its sibling:
    python3 tools/ai_score.py --json report.json
    python3 tools/humanize.py report.json --mode HUMANIZER
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import re
import statistics
import sys
from dataclasses import dataclass, field
from pathlib import Path

# --------------------------------------------------------------------------
# Lexicons. Weights are "penalty points per hit", tuned so a clean academic
# paragraph lands near 0 and an unedited LLM paragraph lands near 100.
# --------------------------------------------------------------------------

STOCK_WORDS = {
    # the notorious ones
    "delve": 6, "delves": 6, "delving": 6,
    "tapestry": 6, "landscape of": 5, "realm of": 5,
    "testament to": 6, "underscores": 5, "underscore": 4, "underscoring": 5,
    "showcasing": 4, "showcase": 3, "showcases": 4,
    "pivotal": 4, "crucial role": 4, "vital role": 4,
    "seamless": 4, "seamlessly": 5, "robust": 2, "leverage": 3, "leveraging": 4,
    "harness": 3, "harnessing": 4, "unlock": 3, "unlocking": 4,
    "navigate the": 4, "navigating the": 4,
    "ever-evolving": 6, "rapidly evolving": 4, "fast-paced": 4,
    "cutting-edge": 4, "state-of-the-art": 3, "game-changer": 5,
    "holistic": 4, "paradigm": 3, "synergy": 5, "synergies": 5,
    "myriad": 4, "plethora": 5, "multifaceted": 5,
    "intricate": 3, "nuanced": 3, "profound": 3,
    "meticulous": 4, "meticulously": 5,
    "foster": 3, "fostering": 3, "empower": 3, "empowering": 3,
    "streamline": 3, "streamlining": 3, "facilitate": 2,
    "resonate": 4, "resonates": 4, "align with": 2, "aligns with": 2,
    "at the forefront": 5, "in today's world": 6, "in the digital age": 6,
    "it is worth noting": 5, "it should be noted": 4, "it is important to note": 6,
    "boasts": 4, "elevate": 3, "elevates": 3,
    "transformative": 4, "groundbreaking": 4, "revolutionize": 4,
    "unwavering": 5, "invaluable": 3, "unparalleled": 4,
    "deep dive": 4, "dive into": 3,
    "key takeaway": 4, "takeaways": 3,
    "cornerstone": 3, "backbone of": 3, "bedrock": 3,
}

TRANSITIONS = {
    "moreover": 3, "furthermore": 3, "additionally": 2, "in addition": 2,
    "consequently": 2, "therefore": 1, "thus": 1, "hence": 1,
    "overall": 2, "ultimately": 3, "in essence": 4, "essentially": 2,
    "taken together": 5, "in conclusion": 4, "to summarize": 3,
    "in summary": 3, "notably": 2, "importantly": 2, "significantly": 1,
    "as such": 3, "that said": 2, "on the other hand": 2,
    "first and foremost": 5, "last but not least": 6,
}

# Structural tics: sentence shapes an LLM reaches for by default.
PATTERNS: list[tuple[str, str, int]] = [
    (r"\bnot (?:just|only|merely|simply)\b[^.;]{0,80}?\bbut\b", "antithesis-not-only-but", 7),
    (r"\bis not (?:a|an|the|about)\b[^.;]{0,60}?\b(?:but|it is|it's)\b", "antithesis-is-not-but", 7),
    (r"\bisn't\b[^.;]{0,60}?\bit's\b", "antithesis-isnt-its", 6),
    (r"\brather than\b[^.;]{0,60}?\b(?:but|instead)\b", "antithesis-rather-than", 4),
    (r"\bmore than (?:just|merely)\b", "more-than-just", 5),
    (r"\bwhile\b[^,.;]{5,70},\s", "while-concessive-opener", 2),
    (r"^\s*(?:By|Through|With|Leveraging|Utilizing|Building on|Drawing on)\s+\w+ing\b", "participial-opener", 3),
    (r"\b(?:serves|stands|acts) as (?:a|an|the)\b", "serves-as-a", 4),
    (r"\bplays? an? \w+ role\b", "plays-a-role", 4),
    (r"\bensuring (?:that )?\w+", "ensuring-tail", 2),
    (r"\bpaving the way\b", "paving-the-way", 6),
    (r"\bwhen it comes to\b", "when-it-comes-to", 4),
    (r"\bin the world of\b", "in-the-world-of", 5),
    (r"\bnavigat\w+ the (?:complex|challeng|ever)\w*", "navigating-complexities", 6),
    (r"\ba (?:wide|broad) (?:range|array|variety) of\b", "wide-range-of", 3),
    (r"\bboth\b[^.;]{0,40}?\band\b[^.;]{0,40}?\balike\b", "and-alike", 5),
    (r"—[^—]{1,90}—", "em-dash-parenthetical", 3),
    (r"\bnot only\b(?![^.;]{0,80}\bbut\b)", "dangling-not-only", 3),
]

HEDGES = {
    "may", "might", "could", "potentially", "arguably", "generally",
    "typically", "often", "somewhat", "relatively", "largely", "broadly",
}

SENT_SPLIT = re.compile(r"(?<=[.!?])[\"')\]]*\s+(?=[A-Z(\"'\[])")
WORD_RE = re.compile(r"[A-Za-z][A-Za-z'’-]*")


# --------------------------------------------------------------------------
# Markup stripping
# --------------------------------------------------------------------------

def strip_typst(text: str) -> str:
    text = re.sub(r"^\s*//.*$", "", text, flags=re.M)          # line comments
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)           # block comments
    text = re.sub(r"```.*?```", " ", text, flags=re.S)          # raw blocks
    text = re.sub(r"`[^`\n]*`", " CODE ", text)                 # inline raw
    text = re.sub(r"\$[^$\n]*\$", " MATH ", text)               # inline math
    text = re.sub(r"#(?:figure|image|table|grid|block|include|import|let|show|set)\b[^\n]*", "", text)
    text = re.sub(r"#\w+(?:\.\w+)*\((?:[^()]|\([^()]*\))*\)", " ", text)  # #func(...)
    text = re.sub(r"^\s*=+\s.*$", "", text, flags=re.M)         # headings
    text = re.sub(r"^\s*(?:[+-]|\d+\.)\s+", "", text, flags=re.M)  # list markers
    text = re.sub(r"[*_]", "", text)                            # emphasis
    text = re.sub(r"@\w+", " ", text)                           # refs
    return text


def strip_markdown(text: str) -> str:
    text = re.sub(r"^---\n.*?\n---\n", "", text, flags=re.S)    # frontmatter
    text = re.sub(r"```.*?```", " ", text, flags=re.S)
    text = re.sub(r"`[^`\n]*`", " CODE ", text)
    text = re.sub(r"^\s*\|.*\|\s*$", "", text, flags=re.M)      # tables
    text = re.sub(r"!\[[^\]]*\]\([^)]*\)", " ", text)           # images
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text)        # links -> label
    text = re.sub(r"^\s*#+\s.*$", "", text, flags=re.M)         # headings
    text = re.sub(r"^\s*>\s?", "", text, flags=re.M)            # quotes
    text = re.sub(r"^\s*(?:[*+-]|\d+\.)\s+", "", text, flags=re.M)
    text = re.sub(r"[*_~]", "", text)
    text = re.sub(r"\$[^$\n]*\$", " MATH ", text)
    return text


def pdf_text(path: Path) -> str:
    """Extract prose from a compiled PDF, discarding everything that is not prose.

    `pdftotext -layout` keeps table columns as runs of spaces, which is what lets
    us drop tables, code listings, and the TOC instead of scoring them as if a
    human had written them in sentences. Paragraph boundaries are then recovered
    from line measure: in justified body text every line runs to the right margin
    except the last one, so a short line ends a paragraph.
    """
    if not shutil.which("pdftotext"):
        sys.exit("Reading PDFs needs `pdftotext` (poppler).  sudo pacman -S poppler")
    raw = subprocess.run(["pdftotext", "-layout", "-nopgbrk", str(path), "-"],
                         capture_output=True, text=True, check=True).stdout

    # Rejoin words split across a line break (soft hyphen or hard hyphen).
    raw = re.sub(r"[\u00ad-]\n\s*", "", raw)

    lines = raw.split("\n")
    # Running headers/footers repeat on nearly every page; drop the repeats.
    from collections import Counter
    freq = Counter(l.strip() for l in lines if 3 < len(l.strip()) < 70)
    boilerplate = {t for t, n in freq.items() if n >= 8}

    kept: list[tuple[str, int]] = []   # (text, printed width of the source line)
    for line in lines:
        st = line.strip()
        if not st:
            kept.append(("", 0))
            continue
        if st in boilerplate:
            continue
        if re.fullmatch(r"[\divxlcIVXLC]{1,6}", st):            # bare page number
            continue
        if re.search(r"\.{4,}|(?:\. ){4,}", st):                 # TOC dot leaders
            continue
        if re.match(r"^(?:Figure|Table|Listing|Fig\.|Algorithm)\s+\d", st):
            continue
        if re.match(r"^\d+(?:\.\d+)+\s", st) and len(st) < 90:   # numbered heading
            continue
        if re.search(r"\S {3,}\S", line):                       # table / aligned columns
            continue
        letters = sum(c.isalpha() or c.isspace() for c in st)
        if letters / len(st) < 0.72:                           # code, symbols, data
            continue
        # Headings are short, capitalised, and carry no terminal punctuation.
        # A short line that *does* end a sentence is a paragraph's last line —
        # keep it, or the paragraph after it gets glued on.
        if len(st.split()) < 4 and not re.search(r"[.!?:;][\"'\u201d\u2019)]?$", st):
            continue
        kept.append((st, len(line.rstrip())))

    # Full measure = the right margin of body text. Restrict the sample to
    # plausible body widths first: stray wide lines (leftover aligned content)
    # otherwise drag the estimate up and every real line then looks "short".
    body = sorted(w for _, w in kept if 40 <= w <= 100)
    measure = body[int(len(body) * 0.8)] if body else 0

    out, buf = [], []
    def flush():
        if buf:
            out.append(" ".join(buf))
            buf.clear()

    for st, width in kept:
        if not st:
            flush()
            continue
        if re.match(r"^(?:\d+\.|[-\u2022\u2023*+])\s", st):     # a new list item
            flush()
        buf.append(re.sub(r"^(?:\d+\.|[-\u2022\u2023*+])\s+", "", st))
        if measure and width < measure * 0.88:                 # short line = para end
            flush()
    flush()
    return "\n\n".join(out)


STRIPPERS = {".typ": strip_typst, ".md": strip_markdown, ".txt": lambda t: t}


# --------------------------------------------------------------------------
# Scoring
# --------------------------------------------------------------------------

@dataclass
class Para:
    path: Path
    line: int
    text: str
    score: float = 0.0
    words: int = 0
    burstiness: float = 0.0
    mean_sent: float = 0.0
    flags: list[str] = field(default_factory=list)
    breakdown: dict[str, float] = field(default_factory=dict)


def sentences(text: str) -> list[str]:
    parts = [s.strip() for s in SENT_SPLIT.split(text.strip()) if s.strip()]
    return parts or ([text.strip()] if text.strip() else [])


def score_para(p: Para) -> Para:
    text = p.text
    low = text.lower()
    words = WORD_RE.findall(text)
    p.words = len(words)
    if p.words < 25:
        p.score = 0.0
        p.flags.append("too-short-to-score")
        return p

    per100 = 100.0 / p.words
    sents = sentences(text)
    lens = [len(WORD_RE.findall(s)) for s in sents]
    lens = [n for n in lens if n > 0]
    p.mean_sent = statistics.mean(lens) if lens else 0.0
    # Burstiness: humans vary sentence length, LLMs converge on ~20 words.
    if len(lens) >= 3 and p.mean_sent:
        p.burstiness = statistics.pstdev(lens) / p.mean_sent
    else:
        p.burstiness = 0.5  # not enough sentences to judge; assume neutral

    bd: dict[str, float] = {}

    # 1. Rhythm uniformity (max 22)
    if len(lens) >= 3:
        bd["uniform_rhythm"] = max(0.0, min(22.0, (0.55 - p.burstiness) * 55))
        if p.burstiness < 0.32:
            p.flags.append(f"flat-rhythm(cv={p.burstiness:.2f})")
    else:
        bd["uniform_rhythm"] = 0.0

    # 2. Long-sentence drift (max 10) — LLM prose averages 22-30 words.
    bd["long_sentences"] = max(0.0, min(10.0, (p.mean_sent - 21) * 1.1))
    if p.mean_sent > 28:
        p.flags.append(f"long-sentences(avg={p.mean_sent:.0f}w)")

    # 3. Stock vocabulary (max 26)
    vocab = 0.0
    for phrase, w in STOCK_WORDS.items():
        n = len(re.findall(r"\b" + re.escape(phrase) + r"\b", low))
        if n:
            vocab += w * n
            p.flags.append(f"stock:{phrase}" + (f"×{n}" if n > 1 else ""))
    bd["stock_vocab"] = min(26.0, vocab * per100 * 2.2)

    # 4. Transition padding (max 14)
    trans = 0.0
    for phrase, w in TRANSITIONS.items():
        n = len(re.findall(r"\b" + re.escape(phrase) + r"\b", low))
        if n:
            trans += w * n
            if w >= 3:
                p.flags.append(f"transition:{phrase}" + (f"×{n}" if n > 1 else ""))
    bd["transitions"] = min(14.0, trans * per100 * 2.6)

    # 5. Structural tics (max 30)
    struct = 0.0
    for rx, name, w in PATTERNS:
        n = len(re.findall(rx, text, flags=re.M))
        if n:
            struct += w * n
            p.flags.append(f"{name}" + (f"×{n}" if n > 1 else ""))
    bd["structural_tics"] = min(30.0, struct * 2.4)

    # 6. Em-dash density (max 12) — the single loudest surface tell.
    dashes = text.count("—") + len(re.findall(r"\s-{1,2}\s", text))
    dash_rate = dashes * per100
    bd["em_dashes"] = min(12.0, max(0.0, (dash_rate - 0.4) * 9))
    if dash_rate > 1.2:
        p.flags.append(f"em-dash-heavy({dashes} in {p.words}w)")

    # 7. Triadic lists (max 8) — "fast, cheap, and reliable" three times a page.
    triads = len(re.findall(r"\b\w+(?:ly)?,\s+\w+[^,.;]{0,25},\s+and\s+\w+", text))
    bd["triads"] = min(8.0, triads * 3.5)
    if triads >= 2:
        p.flags.append(f"triadic-lists×{triads}")

    # 8. Hedging density (max 8)
    hedge_n = sum(1 for w in words if w.lower() in HEDGES)
    bd["hedging"] = min(8.0, max(0.0, (hedge_n * per100 - 2.0) * 2.2))

    # 9. Sentence-opener repetition (max 8) — LLMs restart the same way.
    openers = [WORD_RE.findall(s)[:1] for s in sents]
    openers = [o[0].lower() for o in openers if o]
    if len(openers) >= 4:
        dupes = len(openers) - len(set(openers))
        bd["repeated_openers"] = min(8.0, dupes * 3.0)
        if dupes >= 2:
            p.flags.append(f"repeated-openers×{dupes}")
    else:
        bd["repeated_openers"] = 0.0

    # Credit back for concrete grounding: numbers, filenames, identifiers.
    # Specificity is the one thing generic LLM prose reliably lacks.
    concrete = len(re.findall(r"\b\d[\d.,]*\b", text)) + text.count("CODE") \
        + len(re.findall(r"\b[a-z]+[A-Z]\w+\b", text))
    bd["concreteness_credit"] = -min(14.0, concrete * per100 * 3.0)

    p.breakdown = bd
    p.score = max(0.0, min(100.0, sum(bd.values())))
    return p


def band(score: float) -> tuple[str, str]:
    if score >= 65:
        return "HIGH", "\033[91m"
    if score >= 40:
        return "MEDIUM", "\033[93m"
    if score >= 20:
        return "LOW", "\033[96m"
    return "CLEAN", "\033[92m"


# --------------------------------------------------------------------------
# Collection
# --------------------------------------------------------------------------

SKIP_DIRS = {"__pycache__", "node_modules", "site-packages", "split_texts",
             "dist", "build", "target", "vendor"}


def skipped(p: Path) -> bool:
    for part in p.parts[:-1]:
        if part in SKIP_DIRS or part.startswith(".") or part.endswith(".dist-info"):
            return True
    return False


def iter_files(root: Path, exts: set[str]) -> list[Path]:
    if root.is_file():
        return [root]
    return [p for p in sorted(root.rglob("*"))
            if p.is_file() and p.suffix in exts and not skipped(p)]


def paragraphs(path: Path) -> list[Para]:
    if path.suffix.lower() == ".pdf":
        clean = pdf_text(path)
    else:
        raw = path.read_text(encoding="utf-8", errors="replace")
        clean = STRIPPERS.get(path.suffix, lambda t: t)(raw)
    out: list[Para] = []
    line = 1
    for block in re.split(r"\n\s*\n", clean):
        n_lines = block.count("\n") + 2
        body = " ".join(block.split())
        if body:
            out.append(Para(path=path, line=line, text=body))
        line += n_lines
    return out


# --------------------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(description="Score prose for AI-writing tells.")
    ap.add_argument("target", nargs="?", default=".", help="file or directory (default: cwd)")
    ap.add_argument("--ext", action="append", help="extensions to scan (repeatable; default .typ .md; .pdf supported)")
    ap.add_argument("--top", type=int, default=20, help="paragraphs to list (default 20)")
    ap.add_argument("--min-words", type=int, default=25, help="ignore paragraphs shorter than this")
    ap.add_argument("--threshold", type=float, default=20.0, help="only list paragraphs at/above this score")
    ap.add_argument("--json", type=Path, help="also write full results as JSON")
    ap.add_argument("--no-color", action="store_true")
    args = ap.parse_args()

    exts = set(args.ext or [".typ", ".md"])
    exts = {e if e.startswith(".") else "." + e for e in exts}
    files = iter_files(Path(args.target), exts)
    if not files:
        sys.exit(f"No {'/'.join(sorted(exts))} files under {args.target}")

    C = (lambda c: "") if (args.no_color or not sys.stdout.isatty()) else (lambda c: c)
    R = "" if (args.no_color or not sys.stdout.isatty()) else "\033[0m"

    all_paras: list[Para] = []
    per_file: dict[Path, list[Para]] = {}
    for f in files:
        scored = [score_para(p) for p in paragraphs(f) if len(WORD_RE.findall(p.text)) >= args.min_words]
        if scored:
            per_file[f] = scored
            all_paras += scored

    if not all_paras:
        sys.exit("No scorable prose found (everything was markup or too short).")

    def weighted(ps: list[Para]) -> float:
        tw = sum(p.words for p in ps)
        return sum(p.score * p.words for p in ps) / tw if tw else 0.0

    print(f"\n{'='*78}\n  AI-WRITING RISK — {len(all_paras)} paragraphs, "
          f"{sum(p.words for p in all_paras):,} words, {len(per_file)} files\n{'='*78}\n")

    print(f"  {'FILE':<52} {'WORDS':>7} {'SCORE':>6}  BAND")
    print(f"  {'-'*52} {'-'*7} {'-'*6}  {'-'*6}")
    for f, ps in sorted(per_file.items(), key=lambda kv: -weighted(kv[1])):
        s = weighted(ps)
        name, col = band(s)
        rel = str(f)
        if len(rel) > 52:
            rel = "…" + rel[-51:]
        print(f"  {rel:<52} {sum(p.words for p in ps):>7,} {C(col)}{s:>6.1f}  {name}{R}")

    overall = weighted(all_paras)
    oname, ocol = band(overall)
    print(f"\n  {'OVERALL':<52} {sum(p.words for p in all_paras):>7,} "
          f"{C(ocol)}{overall:>6.1f}  {oname}{R}")

    hi = [p for p in all_paras if p.score >= 65]
    md = [p for p in all_paras if 40 <= p.score < 65]
    print(f"\n  Distribution: {len(hi)} high · {len(md)} medium · "
          f"{len(all_paras)-len(hi)-len(md)} low/clean")

    flagged = sorted((p for p in all_paras if p.score >= args.threshold),
                     key=lambda p: -p.score)[:args.top]
    if flagged:
        print(f"\n{'='*78}\n  WORST {len(flagged)} PARAGRAPHS\n{'='*78}")
        for i, p in enumerate(flagged, 1):
            name, col = band(p.score)
            print(f"\n{i:>3}. {C(col)}{p.score:>5.1f} {name:<6}{R} {p.path}:{p.line}  "
                  f"({p.words}w, cv={p.burstiness:.2f}, avg {p.mean_sent:.0f}w/sent)")
            top = sorted((kv for kv in p.breakdown.items() if kv[1] > 0.5),
                         key=lambda kv: -kv[1])[:4]
            if top:
                print("      drivers: " + ", ".join(f"{k} +{v:.0f}" for k, v in top))
            if p.flags:
                print("      tells:   " + ", ".join(p.flags[:8]))
            snippet = p.text if len(p.text) <= 220 else p.text[:217] + "…"
            print(f"      \033[2m{snippet}{R}" if C("x") else f"      {snippet}")

    print(f"\n{'='*78}")
    print("  Heuristic stylometry — it locates machine-sounding sentences.")
    print("  It is not a Turnitin/GPTZero score and cannot predict one.")
    print(f"{'='*78}\n")

    if args.json:
        args.json.write_text(json.dumps({
            "overall": round(overall, 2),
            "files": {str(f): round(weighted(ps), 2) for f, ps in per_file.items()},
            "paragraphs": [{
                "file": str(p.path), "line": p.line, "score": round(p.score, 2),
                "words": p.words, "burstiness": round(p.burstiness, 3),
                "mean_sentence_words": round(p.mean_sent, 1),
                "breakdown": {k: round(v, 2) for k, v in p.breakdown.items()},
                "flags": p.flags, "text": p.text,
            } for p in sorted(all_paras, key=lambda p: -p.score)],
        }, indent=2), encoding="utf-8")
        print(f"  JSON → {args.json}\n")


if __name__ == "__main__":
    main()
