# Chapter 2: Survey of Technologies

FactStamp's technology-justification chapter — a systematic survey of the architectural patterns, frameworks, libraries, and algorithmic models evaluated for each layer of the system, followed by a justification of the specific choice made at each layer against the project's three central constraints: zero server-operating cost, zero-cost/zero-data-egress OCR, and correct rendering of the OKLCH-based design system in exported card images. Content is verified against the real FactStamp source tree at `/home/aadish/Documents/Github/FactStamp` (see `Rules/CODE_PATHS_AND_NOTES.md`, `Rules/Module-rules.md`, and `Rules/Admin-rules.md`) — every library version, function name, threshold, and formula cited here is real, not invented.

This reorganizes the chapter's original flat draft (`black_book_draft/02_survey_of_technologies.md`, 12 linear sections) into 8 topic-based sections that group related technologies together and add one entirely new section (see Section 2.7, Consensus Models) that the flat draft did not cover — a genuine survey of claim-verification consensus mechanisms (editorial, majority-vote, Byzantine-fault-tolerant, and weighted quorum) justifying why FactStamp's actual weighted-quorum engine was the right model for a crowdsourced fact-checking platform, not just a technology pick.

## Subsections

| File | Section | Description |
|---|---|---|
| [`2.1_web_architectures.md`](2.1_web_architectures.md) | 2.1 Web Architectures | Survey of MPA / SSR / SPA and BaaS-vs-custom-server patterns; justifies FactStamp's React SPA + Firebase BaaS architecture; covers the three deployment targets (Firebase Hosting, Vercel, Docker + Nginx). |
| [`2.2_frontend_frameworks.md`](2.2_frontend_frameworks.md) | 2.2 Frontend Frameworks | React 18.3.1, TypeScript 5.5 (strict mode), Vite 5.4 build tooling, and Framer Motion 12 as the animation layer. |
| [`2.3_styling_and_design_tokens.md`](2.3_styling_and_design_tokens.md) | 2.3 Styling and Design Tokens | Tailwind CSS v4's CSS-native configuration, the OKLCH perceptual color space, and the `cn()` class-composition helper. |
| [`2.4_cloud_databases.md`](2.4_cloud_databases.md) | 2.4 Cloud Databases | Firebase v12 as BaaS (Auth, Firestore, Storage, Security Rules), the embedded-array-vs-subcollection schema decision, and Recharts as the dashboard's charting layer. |
| [`2.5_ocr_engines.md`](2.5_ocr_engines.md) | 2.5 OCR Engines | Tesseract.js 7.0 client-side WebAssembly OCR, surveyed against cloud OCR/vision API alternatives, with an honest accounting of the accuracy trade-off. |
| [`2.6_card_export_engines.md`](2.6_card_export_engines.md) | 2.6 Card Export Engines | `html-to-image`'s SVG-foreignObject rasterization, surveyed against raw Canvas API and `html2canvas`, and why it replaced a legacy canvas parser that broke on OKLCH colors. |
| [`2.7_consensus_models.md`](2.7_consensus_models.md) | 2.7 Consensus Models | New content: a survey of claim-verification consensus models (editorial/single-moderator, majority vote, BFT/blockchain-style, weighted quorum) justifying FactStamp's 3-verifier weighted-quorum engine, Jaccard duplicate pre-filter, and 7-day consensus-deadline expiry. |
| [`2.8_technology_selection_matrix.md`](2.8_technology_selection_matrix.md) | 2.8 Technology Selection Matrix | Consolidated comparison table across every layer above, plus a supporting-libraries table (`lucide-react`, `sonner`, `react-router-dom`, `clsx`/`tailwind-merge`, Recharts). |

## Compiling `02_survey_of_technologies.typ`

The chapter assembles all eight subsections into a single Typst document under `= Survey of Technologies` (H1) with `== Web Architectures`, `== Frontend Frameworks`, `== Styling and Design Tokens`, `== Cloud Databases`, `== OCR Engines`, `== Card Export Engines`, `== Consensus Models`, and `== Technology Selection Matrix` (all H2), auto-numbered `2`, `2.1`, `2.2`, ... via `#set heading(numbering: "1.1")`, following the Master Setup Block in `Rules/Typst_format.md`.

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/02_Survey_of_Technologies"

# Standalone review copy (own title block, numbering restarts at 1)
typst compile 02_survey_of_technologies.typ 02_survey_of_technologies.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 02_survey_of_technologies.typ 02_survey_of_technologies.pdf
```
