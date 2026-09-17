# Chapter 5: Implementation and Testing

FactStamp's fifth chapter, covering how the system was actually built (implementation approach, coding details, and code-efficiency techniques) and how it was actually tested (unit, integration, and system/beta testing), followed by the real modifications made during development and a worked test-case execution matrix. Content is verified against the real FactStamp source tree at `/home/aadish/Documents/Github/FactStamp` (see `Rules/CODE_PATHS_AND_NOTES.md` and `Rules/Module-rules.md`) and the project's own `CHANGELOG.md` — every function name, formula, threshold, and change described here is real, not invented. In particular, `package.json` was checked directly and confirmed to define no `test` script and no `*.test.ts`/`*.spec.ts` files exist anywhere under `src/`, so this chapter describes FactStamp's testing honestly as manual and structured rather than claiming an automated suite that does not exist.

## Subsections

| File | Section | Description |
|---|---|---|
| [`5.1_implementation_approaches.md`](5.1_implementation_approaches.md) | 5.1 Implementation Approaches | Project summary, module-by-module implementation sequencing, incremental Agile delivery, the rationale for React Context over Redux, and Firebase as Backend-as-a-Service. |
| [`5.2_coding_details_and_code_efficiency.md`](5.2_coding_details_and_code_efficiency.md) | 5.2 Coding Details and Code Efficiency (incl. 5.2.1 Code Efficiency) | Coding approach per module with real code excerpts (`duplicateDetection.ts`, `confidenceScore.ts`), plus Vite manual chunk-splitting, the embedded-verifications Firestore schema, client-side image compression, and Context memoization/listener patterns. |
| [`5.3_testing_approach.md`](5.3_testing_approach.md) | 5.3 Testing Approach (5.3.1 Unit, 5.3.2 Integration, 5.3.3 Beta/System) | Manual unit verification of the Jaccard and confidence-score functions with worked example test cases, integration testing via the Firebase Local Emulator Suite, and full user-journey system/beta walkthroughs. |
| [`5.4_modifications_and_improvements.md`](5.4_modifications_and_improvements.md) | 5.4 Modifications and Improvements | Five real, changelog-documented modifications: the verification-queue auto-replenishment bug fix, login rate-limiting hardening, the universal theme-toggle rollout, the pan-Indic font-stack migration, and the `html-to-image` adoption replacing a legacy canvas parser. |
| [`5.5_test_cases_execution_matrix.md`](5.5_test_cases_execution_matrix.md) | 5.5 Test Cases | A filled-in, executed test-case matrix (Test ID / Condition / Input / Expected / Actual / Pass-Fail) covering auth, submission, duplicate detection, consensus, security, and admin scenarios, including one documented "Fail → Fixed" regression. |

## Compiling `05_implementation_and_testing.typ`

The chapter assembles all five subsections into a single Typst document under `= Implementation and Testing` (H1) with `== Implementation Approaches`, `== Coding Details and Code Efficiency` (with `=== Code Efficiency` as H3), `== Testing Approach` (with `=== Unit Testing`, `=== Integration Testing`, `=== System/Beta Testing` as H3), `== Modifications and Improvements`, and `== Test Cases Execution Matrix` (H2), auto-numbered `5`, `5.1`, `5.2`, ... via `#set heading(numbering: "1.1")`, following the Master Setup Block in `Rules/Typst_format.md`.

```bash
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/05_Implementation_and_Testing"

# Standalone review copy (own title block, numbering restarts at 1)
typst compile 05_implementation_and_testing.typ 05_implementation_and_testing.pdf

# As part of the assembled blackbook (title block hidden, continuous pagination)
typst compile --input mode=blackbook 05_implementation_and_testing.typ 05_implementation_and_testing.pdf
```
