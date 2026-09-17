# Chapter 7: Conclusions

FactStamp's closing chapter: a reflection on the system built against the eight objectives set out in Chapter 1, an honest accounting of its real limitations, and a grounded, prioritized future-scope roadmap. Content is verified against the real FactStamp source tree at `/home/aadish/Documents/Github/FactStamp` (see `Rules/CODE_PATHS_AND_NOTES.md` and `Rules/Module-rules.md`) — every function name, file path, and hardcoded value cited here is real, not invented, and the limitations listed are genuine (verified by spot-checking `package.json`, `src/lib/confidenceScore.ts`, `src/contexts/ClaimsContext.tsx`, `src/services/firebaseService.ts`, `firestore.rules`, and `storage.rules`), not softened for effect.

## Subsections

| File | Section | Description |
|---|---|---|
| [`7.1_conclusion.md`](7.1_conclusion.md) | 7.1 Conclusion (with 7.1.1 Significance of the System) | Reflects back on each of the 8 Chapter 1 objectives, stating which were achieved and how (Objective 6 — OCR submission — is flagged as only partially achieved), then argues the system's significance as a decentralized, zero-infrastructure-cost, privacy-preserving, source-transparent middle ground between slow institutional fact-checking and unaccountable ad-hoc group-chat debunking. |
| [`7.2_limitations_of_the_system.md`](7.2_limitations_of_the_system.md) | 7.2 Limitations of the System | Eight real, verified limitations grouped into three categories: Coverage & Accuracy (English-only OCR, OCR accuracy trade-off, no WhatsApp Business API integration), Trust & Governance (quorum good-faith assumption, hardcoded source-quality domain list), and Architectural & Scaling (quorum threshold duplicated across three layers, no automated test suite, Firestore-embedded image storage cap). |
| [`7.3_future_scope_of_the_project.md`](7.3_future_scope_of_the_project.md) | 7.3 Future Scope of the Project | Nine future-scope ideas prioritized into Near-Term (multi-language OCR, community-curatable source-credibility database, single-source-of-truth quorum constant, CONTESTED-claim appeal workflow, basic automated test suite) and Long-Term (WhatsApp Business API integration, Firebase Storage migration for images, mobile app wrapper, browser extension, web push notifications, multi-platform support), each with a one-sentence rationale tied back to a Section 7.2 limitation or a Chapter 1 objective. |

## Compiling `07_conclusions.typ`

The chapter assembles all three subsections into a single Typst document under `= Conclusions` (H1), with `== Conclusion` (containing `=== Significance of the System` as H3), `== Limitations of the System` (containing `=== Coverage & Accuracy Limitations`, `=== Trust & Governance Limitations`, `=== Architectural & Scaling Limitations` as H3), and `== Future Scope of the Project` (containing `=== Near-Term Scope` and `=== Long-Term Scope` as H3) — all H2, auto-numbered `7`, `7.1`, `7.2`, `7.3` via `#set heading(numbering: "1.1")`, following the Master Setup Block in `Rules/Typst_format.md`.

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/07_Conclusions"

# Standalone review copy (own title block, numbering restarts at 1)
typst compile 07_conclusions.typ 07_conclusions.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 07_conclusions.typ 07_conclusions.pdf
```
