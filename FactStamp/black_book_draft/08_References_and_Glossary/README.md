# References and Glossary (Back Matter)

*(Draft status: content-complete. Covers the syllabus's unnumbered "REFERENCES" and "GLOSSARY" sections that follow Chapter 7 --- Conclusions, per `Rules/Project_syllabus.md`. Content verified against `Project Synopsis/project_synopsis.typ` Section 14 (citation style/format precedent), `Rules/Typst_format.md` (Master Setup Block, `styled-table`, unnumbered-heading pattern), and the black book chapter drafts in `black_book_draft/01_Introduction/` through `03_Requirements_and_Analysis/` for terminology coverage.)*

## Files in This Folder

| File | What It Is |
|---|---|
| [`references.md`](references.md) | Markdown-source numbered academic reference list (17 entries): the IEEE Std 830-1998 SRS standard, the 2020 Scrum Guide, the OWASP Top Ten, three real peer-reviewed/foundational papers (Vosoughi/Roy/Aral *Science* 2018, Garimella/Eckles CSCW 2020, Jaccard 1901), and official vendor documentation for every runtime technology named in Chapter 2 --- Survey of Technologies (React, Vite, TypeScript, Tailwind CSS v4, CSS Color Level 4/OKLCH, Firestore, Firebase Auth, React Router, Recharts, Tesseract.js, `html-to-image`). No fabricated sources — every entry is real and independently verifiable; anything uncertain was left out rather than invented. |
| [`glossary.md`](glossary.md) | Markdown-source, two-column Term/Definition glossary (47 entries, alphabetical) covering every domain-specific and technical term used across the black book — FactStamp's own domain vocabulary (Claim, Verdict states, Verifier, Verifier Reputation, Quorum, Weighted Consensus, Confidence Score, Jaccard Similarity, Consensus Deadline, Source Quality, Admin Console, Audit Log, Moderation Report, etc.) alongside the technology terms from Chapter 2 (SPA, BaaS, React, Vite, TypeScript, Tailwind CSS, OKLCH, Firestore, `html-to-image`, Tesseract.js, etc.). |
| [`references.typ`](references.typ) / [`references.pdf`](references.pdf) | A standalone-compilable Typst document containing **only** the References section, built on the Master Setup Block from `Rules/Typst_format.md` (A4 page, 1.5in binding margin, mandatory black page border, Times New Roman body text, `styled-table` / `responsive-image` helpers) and mirroring `Project Synopsis/project_synopsis.typ`'s numbered-citation format exactly. Document metadata: `#set document(title: "FactStamp - References", author: "Aadish")`. |
| [`08_references_and_glossary.typ`](08_references_and_glossary.typ) / [`08_references_and_glossary.pdf`](08_references_and_glossary.pdf) | The combined, compilable Typst document for this back-matter section: both `References` and `Glossary` under the same Master Setup Block, each as an unnumbered top-level heading (`#heading(numbering: none)[References]` / `#heading(numbering: none)[Glossary]`) so they don't inherit the body's `#set heading(numbering: "1.1")` chapter numbering — matching how the syllabus lists REFERENCES and GLOSSARY as unnumbered sections after the numbered Chapter 7. The Glossary is rendered with the shared `styled-table` helper (`columns: (1.5in, 1fr)`, headers `Term` / `Definition`). Document metadata: `#set document(title: "FactStamp - References and Glossary", author: "Aadish")`. |

## Why Two `.typ` Files

- `references.typ` exists as an independently gradable/submittable deliverable, in case References needs to be submitted or reviewed on its own (consistent with how other chapters in `black_book_draft/` ship a standalone per-section `.typ`, e.g. `01_Introduction/01_introduction.typ`).
- `08_references_and_glossary.typ` is the actual back-matter unit that gets pulled into the assembled blackbook (`--input mode=blackbook`) — it is the file this folder's number (`08_`) refers to, and it supersets `references.typ` by adding the Glossary table.

Both files share the exact same Master Setup Block (page geometry, fonts, `styled-table`, `responsive-image`, dual-mode `is-assembly` title-block logic) so they render identically whether compiled standalone or assembled into the master blackbook.

## Compiling

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/08_References_and_Glossary"

# References only (standalone review copy)
typst compile references.typ references.pdf

# Combined References + Glossary section (standalone review copy)
typst compile 08_references_and_glossary.typ 08_references_and_glossary.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 08_references_and_glossary.typ 08_references_and_glossary.pdf
```

Both `references.typ` and `08_references_and_glossary.typ` have been verified to compile cleanly (exit code 0) with no errors or warnings under the installed `typst` binary.
