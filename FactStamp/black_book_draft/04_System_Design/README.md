# Chapter 4: System Design — Folder Index

This folder contains the Markdown source drafts and the compilable Typst chapter document for **Chapter 4 (System Design)** of the FactStamp BSc IT black book (`JUSIT-DSCPR503`), following the official structure defined in `Rules/Project_syllabus.md`:

- **4.1 Basic Modules**
- **4.2 Data Design**
  - 4.2.1 Schema Design
  - 4.2.2 Data Integrity and Constraints
- **4.3 Procedural Design**
  - 4.3.1 Logic Diagrams
  - 4.3.2 Data Structures
  - 4.3.3 Algorithms Design
- **4.4 User Interface Design**
- **4.5 Security Issues**
- **4.6 Test Cases Design**

## Subsection Files

| File | Covers |
|---|---|
| `4.1_basic_modules.md` | Detailed per-module description of FactStamp's 8 core system modules, their key source files/functions, and how they call into one another across the claim lifecycle. |
| `4.2_data_design.md` | Full Firestore schema tables for `users`, `claims` (with embedded `verifications[]`), `notifications`, `reports`, `audit_logs` (§4.2.1), plus the `firestore.rules` integrity/immutability enforcement writeup (§4.2.2). |
| `4.3_procedural_design.md` | The claim-lifecycle logic flow (§4.3.1), the core TypeScript interfaces from `src/lib/types.ts` (§4.3.2), and step-by-step / pseudocode descriptions of the Jaccard duplicate-detection and weighted-consensus algorithms with exact formulas (§4.3.3). |
| `4.4_user_interface_design.md` | UI architecture (custom component library, Tailwind v4, Framer Motion, Recharts, React Context), the full routing table with guard status, and wireframe-level descriptions of every major screen including the Admin console's 5 tabs. |
| `4.5_security_issues.md` | Dual-layer admin auth, login rate-limiting, idle session timeout, triple-layer file upload validation, verdict-explanation anti-spam validation, XSS sanitization, and the client-vs-server trust model backed by `firestore.rules`. |
| `4.6_test_cases_design.md` | A 16-row test case design table (Test ID / Module / Test Condition / Input / Expected Result) covering registration, login (valid/invalid/rate-limited), submission (text/OCR), duplicate detection, verification below/at quorum, consensus expiry, admin override, unauthorized admin access, and more. |

## Source-of-Truth References

All facts in this chapter are grounded in the real FactStamp codebase at `/home/aadish/Documents/Github/FactStamp` (not invented) — primarily `src/lib/types.ts`, `firestore.rules`, `src/lib/security.ts`, `src/lib/confidenceScore.ts`, and `src/lib/duplicateDetection.ts` — cross-referenced against `Rules/Module-rules.md`, `Rules/Admin-rules.md`, and `Rules/CODE_PATHS_AND_NOTES.md` in this workspace.

## Compiling the Chapter

The assembled chapter document is `04_system_design.typ`, following the Master Setup Block and helper conventions in `Rules/Typst_format.md` (identical to `Project Synopsis/project_synopsis.typ` and `Submission of Final SRS/final_srs.typ`).

```bash
# Compile standalone (individual chapter submission)
cd "/home/aadish/Documents/typst/FactStamp/black_book_draft/04_System_Design"
typst compile 04_system_design.typ 04_system_design.pdf

# Compile as part of the assembled blackbook (from the master blackbook file, elsewhere)
typst compile --input mode=blackbook master_blackbook.typ master_blackbook.pdf
```

Diagram placeholders (`[DIAGRAM: ... — pending]`) mark every logic diagram and wireframe called for in `Rules/Diagrams-Checklist.md` that has not yet been produced as a PlantUML/Graphviz/SVG asset; the `.typ` file renders these as plain bordered text placeholders rather than calling `#image()` on a non-existent file, so the chapter still compiles cleanly before the diagram assets exist.
