# Chapter 1: Introduction

FactStamp's opening chapter, establishing the WhatsApp misinformation problem, the project's objectives, its purpose/scope/applicability, the achievements delivered so far, and the roadmap for the rest of the dissertation. Content is verified against the real FactStamp source tree at `/home/aadish/Documents/Github/FactStamp` (see `Rules/CODE_PATHS_AND_NOTES.md` and `Rules/Module-rules.md`) — every function name, threshold, and formula cited here is real, not invented.

## Subsections

| File | Section | Description |
|---|---|---|
| [`1.1_background.md`](1.1_background.md) | 1.1 Background | The WhatsApp misinformation problem in India, why institutional and ad-hoc community fact-checking both fall short, and where FactStamp fits between them. |
| [`1.2_objectives.md`](1.2_objectives.md) | 1.2 Objectives | The 8 core objectives: faster debunking, duplicate elimination (Jaccard ≥ 0.75), 3-verifier quorum, weighted confidence scoring, shareable PNG cards, client-side OCR ingestion, verifier reputation, and public trend analytics. |
| [`1.3_purpose_scope_applicability.md`](1.3_purpose_scope_applicability.md) | 1.3 Purpose, Scope, and Applicability | 1.3.1 Purpose, 1.3.2 Scope (in-scope / out-of-scope feature boundaries), and 1.3.3 Applicability (target populations and use contexts). |
| [`1.4_achievements.md`](1.4_achievements.md) | 1.4 Achievements | The fully functional, deployed capabilities delivered to date, each traced to a real source file (auth, duplicate detection, confidence engine, OCR pipeline, PNG card generator, analytics dashboard, admin console, security module, deployment configs). |
| [`1.5_organisation_of_report.md`](1.5_organisation_of_report.md) | 1.5 Organisation of Report | A one-paragraph-per-chapter roadmap of the full seven-chapter `JUSIT-DSCPR503` dissertation structure. |

## Compiling `01_introduction.typ`

The chapter assembles all five subsections into a single Typst document under `= Introduction` (H1) with `== Background`, `== Objectives`, `== Purpose, Scope, and Applicability` (with `=== Purpose`, `=== Scope`, `=== Applicability` as H3), `== Achievements`, and `== Organisation of Report` (H2), auto-numbered `1`, `1.1`, `1.2`, ... via `#set heading(numbering: "1.1")`, following the Master Setup Block in `Rules/Typst_format.md`.

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/01_Introduction"

# Standalone review copy (own title block, numbering restarts at 1)
typst compile 01_introduction.typ 01_introduction.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 01_introduction.typ 01_introduction.pdf
```
