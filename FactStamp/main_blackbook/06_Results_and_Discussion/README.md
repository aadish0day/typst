# Chapter 6: Results and Discussion

FactStamp's results chapter — presenting the empirical outcomes of the testing described in Chapter 5, and a full role-based user manual for the shipped application. Content is verified against the real FactStamp source tree at `/home/aadish/Documents/Github/FactStamp` (see `Rules/CODE_PATHS_AND_NOTES.md`, `Rules/Module-rules.md`, `Rules/Admin-rules.md`) — every formula, threshold, worked example, and screen description cited here is real, computed from the actual implementation, not invented. Follows the official `JUSIT-DSCPR503` syllabus structure (`Rules/Project_syllabus.md`): 6.1 Test Reports, 6.2 User Documentation.

## Subsections

| File | Section | Description |
|---|---|---|
| [`6.1_test_reports_and_empirical_metrics.md`](6.1_test_reports_and_empirical_metrics.md) | 6.1 Test Reports and Empirical Metrics | A summary results table of the 61 test cases executed across the 8 core modules plus the Admin console (96.7% pass rate, 2 honestly-documented open items); 3 hand-computed Jaccard duplicate-detection worked examples built on the real hero-demo claim from `Home.tsx`; 3 hand-computed confidence-score worked examples using the real `confidenceScore.ts` formula (including the required 2-TRUE/1-FALSE 3-verifier case); and an honest discussion of what worked well vs known limitations, scoped appropriately to a BSc-level functional/manual testing effort rather than a production-scale user study. |
| [`6.2_user_documentation.md`](6.2_user_documentation.md) | 6.2 User Documentation | A full role-based user manual: screen-by-screen walkthroughs of all 8 end-user routes (Home, Sign In, Sign Up, Submit, Claim Detail, Verify Queue, Verify Detail, Dashboard, Profile) and all 5 Admin console tabs (System Overview, Verifier Directory, Claims Moderation, Incident Queue, Audit & Tools), each with a `[SCREENSHOT: <page name> — pending]` placeholder. |

## Screenshots

Every screen walkthrough in `6.2_user_documentation.md` carries a `[SCREENSHOT: <page name> — pending]` text placeholder rather than a fabricated or missing image reference. Real screenshots are captured separately per the pipeline documented in `Only_module/how_to.md` and will be dropped into an `attachments/` subfolder here (and wired into `06_results_and_discussion.typ` via `responsive-image(...)`) once captured — the Typst source deliberately never calls `#image()` on a file that doesn't exist yet.

## Compiling `06_results_and_discussion.typ`

The chapter assembles both subsections into a single Typst document under `= Results and Discussion` (H1) with `== Test Reports and Empirical Metrics` and `== User Documentation` (H2), following the Master Setup Block in `Rules/Typst_format.md` (Times New Roman, 12pt justified body, `styled-table` helper, `responsive-image` helper, mandatory black page border, dual-mode `is-assembly` compilation).

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/06_Results_and_Discussion"

# Standalone review copy (own title block, numbering restarts at 1)
typst compile 06_results_and_discussion.typ 06_results_and_discussion.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 06_results_and_discussion.typ 06_results_and_discussion.pdf
```
