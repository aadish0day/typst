#!/usr/bin/env python3
"""Rewrite the paragraphs that ai_score.py flagged, using the QuillBot SDK.

Reads the JSON report from ai_score.py, sends the worst paragraphs through a
QuillBot paraphrase mode, re-scores the output with the same scorer, and writes
a side-by-side review file. It never edits your sources in place — QuillBot
rewrites wording without understanding it, so every filename, number, formula,
and citation in the output needs a human check before it goes back in.

Technical identifiers are auto-frozen so `src/lib/confidenceScore.ts` and
`Confidence = 0.40×Agreement` survive the round trip intact.

Setup:
    uv pip install quillbot
    export QUILLBOT_EMAIL=you@example.com
    export QUILLBOT_PASSWORD=...

Usage:
    python3 tools/ai_score.py --json report.json
    python3 tools/humanize.py report.json                      # HUMANIZER, top 10
    python3 tools/humanize.py report.json --mode ACADEMIC      # a mode that fits a report
    python3 tools/humanize.py report.json --mode FORMAL --synonyms 2
    python3 tools/humanize.py report.json --top 25 --min-score 35
    python3 tools/humanize.py report.json --compare-modes      # same para, every mode
    python3 tools/humanize.py report.json --dry-run            # cost nothing, see the plan

Modes: FLUENCY STANDARD CREATIVE SHORTEN EXPAND FORMAL SIMPLE ACADEMIC HUMANIZER
Note HUMANIZER and NARRATIVE are the same underlying mode id (12); the SDK
flips the request headers to QuillBot's AI-humanizer product for it.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from ai_score import Para, score_para, band  # noqa: E402

MODES = ["FLUENCY", "STANDARD", "CREATIVE", "SHORTEN", "EXPAND",
         "FORMAL", "SIMPLE", "ACADEMIC", "HUMANIZER"]

# Things QuillBot must not touch: paths, camelCase/PascalCase identifiers,
# dotted filenames, ALLCAPS acronyms, and anything that looks like a metric.
FREEZE_RES = [
    r"\b(?:src|lib|app|tests?|docs?)/[\w./-]+",
    r"\b\w+\.(?:ts|tsx|js|jsx|py|json|rules|typ|md|yaml|yml|toml|html|css)\b",
    r"\b[a-z]+(?:[A-Z][a-z0-9]+)+\b",
    r"\b[A-Z][a-z0-9]+(?:[A-Z][a-z0-9]+)+\b",
    r"\b[A-Z]{2,6}\b",
    r"\b\d+(?:\.\d+)?%?\b",
]


def frozen_terms(text: str, limit: int = 60) -> list[str]:
    seen: dict[str, None] = {}
    for rx in FREEZE_RES:
        for m in re.findall(rx, text):
            if len(m) > 1:
                seen.setdefault(m, None)
    return list(seen)[:limit]


def connect():
    try:
        from quillbot import QuillBot
    except ImportError:
        sys.exit("Missing SDK.  Install it with:  uv pip install quillbot")

    email, pw = os.getenv("QUILLBOT_EMAIL"), os.getenv("QUILLBOT_PASSWORD")
    token = os.getenv("QUILLBOT_TOKEN")
    if email and pw:
        bot = QuillBot(email=email, password=pw)
    elif token:
        bot = QuillBot(useridtoken=token)
    else:
        sys.exit("Set QUILLBOT_EMAIL and QUILLBOT_PASSWORD (or QUILLBOT_TOKEN) "
                 "in your environment first.")
    print(f"  connected — premium={bot.is_premium}")
    return bot


def rewrite(bot, mode_name: str, text: str, synonyms: int, freeze: bool) -> str:
    from quillbot.endpoints import ParaphraseMode
    return bot.paraphrase(
        text,
        mode=getattr(ParaphraseMode, mode_name),
        synonyms_level=synonyms,
        frozen_words=frozen_terms(text) if freeze else None,
        fetch_synonyms=False,
    ).text


def main() -> None:
    ap = argparse.ArgumentParser(description="Humanize the paragraphs ai_score.py flagged.")
    ap.add_argument("report", type=Path, help="JSON file from: ai_score.py --json report.json")
    ap.add_argument("--mode", default="HUMANIZER", choices=MODES,
                    help="QuillBot rewrite mode (default HUMANIZER)")
    ap.add_argument("--synonyms", type=int, default=0, choices=[0, 1, 2, 3],
                    help="synonym slider strength (default 0 — safest for a technical report)")
    ap.add_argument("--top", type=int, default=10, help="how many paragraphs to rewrite (default 10)")
    ap.add_argument("--min-score", type=float, default=30.0, help="skip anything below this score")
    ap.add_argument("--file", help="only paragraphs whose path contains this substring")
    ap.add_argument("--out", type=Path, help="output review file (default humanized_<mode>.md)")
    ap.add_argument("--compare-modes", action="store_true",
                    help="run the single worst paragraph through every mode instead")
    ap.add_argument("--no-freeze", action="store_true", help="do not protect code identifiers")
    ap.add_argument("--dry-run", action="store_true", help="show what would be sent, call nothing")
    args = ap.parse_args()

    if not args.report.exists():
        sys.exit(f"{args.report} not found — generate it with:\n"
                 f"  python3 tools/ai_score.py --json {args.report}")

    data = json.loads(args.report.read_text())
    picks = [p for p in data["paragraphs"] if p["score"] >= args.min_score]
    if args.file:
        picks = [p for p in picks if args.file in p["file"]]
    picks = picks[: (1 if args.compare_modes else args.top)]
    if not picks:
        sys.exit(f"Nothing at or above score {args.min_score}"
                 + (f" in files matching '{args.file}'" if args.file else "")
                 + ". Lower --min-score to see more.")

    out = args.out or Path(f"humanized_{args.mode.lower()}.md")

    print(f"\n  {len(picks)} paragraph(s) selected · mode={args.mode} · "
          f"synonyms={args.synonyms} · freeze={not args.no_freeze}")
    for p in picks:
        print(f"    {p['score']:>5.1f}  {p['file']}:{p['line']}  ({p['words']}w, "
              f"{len(frozen_terms(p['text']))} terms frozen)")

    if args.dry_run:
        print("\n  --dry-run: nothing sent. Drop the flag to run it.\n")
        return

    bot = connect()
    modes = MODES if args.compare_modes else [args.mode]
    lines = [f"# Humanizer review — mode: {', '.join(modes)}", "",
             "QuillBot rewrites wording, not meaning. Before pasting anything back,",
             "re-check every filename, number, formula, and citation against the source.", ""]
    deltas: list[tuple[float, float]] = []

    for i, p in enumerate(picks, 1):
        src = Para(path=Path(p["file"]), line=p["line"], text=p["text"])
        lines += [f"## {p['file']}:{p['line']}", "",
                  f"**Original — {p['score']:.1f} ({band(p['score'])[0]})**", "",
                  "> " + p["text"], ""]
        for m in modes:
            print(f"  [{i}/{len(picks)}] {m:<10} {p['file']}:{p['line']}", flush=True)
            try:
                new = rewrite(bot, m, p["text"], args.synonyms, not args.no_freeze)
            except Exception as exc:
                lines += [f"**{m}** — request failed: `{exc}`", ""]
                print(f"      failed: {exc}")
                continue
            after = score_para(Para(path=src.path, line=src.line, text=new))
            deltas.append((p["score"], after.score))
            arrow = "improved" if after.score < p["score"] else "no better"
            lines += [f"**{m} → {after.score:.1f} ({band(after.score)[0]}, {arrow})**", "",
                      "> " + new, ""]
            if after.flags and after.flags != ["too-short-to-score"]:
                lines += ["remaining tells: " + ", ".join(after.flags[:6]), ""]
            print(f"      {p['score']:.1f} -> {after.score:.1f}")
        lines += ["---", ""]

    out.write_text("\n".join(lines), encoding="utf-8")
    bot.close()

    if deltas:
        b = sum(d[0] for d in deltas) / len(deltas)
        a = sum(d[1] for d in deltas) / len(deltas)
        won = sum(1 for x, y in deltas if y < x)
        print(f"\n  mean score {b:.1f} -> {a:.1f} · improved {won}/{len(deltas)}")
    print(f"  review file: {out}\n")


if __name__ == "__main__":
    main()
