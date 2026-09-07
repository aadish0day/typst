# System Modules — Rules & Reference

> **Authoritative Reference for AI Agents**
> Location: [`/home/aadish/Documents/typst/FactStamp/Rules/Module-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Module-rules.md)
> Source of truth: `/home/aadish/Documents/Github/FactStamp` (React 18 + Vite + Firebase codebase)

---

## 1. Purpose

Maps FactStamp's **8 core system modules** (as referenced across `Rules/Project_syllabus.md` Chapter 4 "Basic Modules" and the various `Submission of Module N/` dissertation deliverables) to the actual source files that implement them. Use this file so any Chapter 4 (System Design), Module submission, or SRS section is grounded in real code rather than a generic description.

## 2. Scope

Covers the application-level functional modules only (`src/` in the GitHub repo). Admin/moderation functionality is a cross-cutting layer documented separately in [`Admin-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Admin-rules.md) — Module 8 below is the security/notification subsystem the Admin console also depends on.

## 3. Module Map

| # | Module | Core Files | What It Does |
|---|---|---|---|
| 1 | **Auth & Verifier Reputation** | [`src/contexts/AuthContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/AuthContext.tsx), [`src/pages/SignIn.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/SignIn.tsx), [`src/pages/SignUp.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/SignUp.tsx) | Firebase Auth session provider (email/password + Google OAuth); every verifier has a `reputation` score (base 50) stored on their Firestore `users/{uid}` profile. |
| 2 | **Forward Submission (Multimodal Ingestion & OCR)** | [`src/pages/Submit.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Submit.tsx), [`src/services/ocrService.ts`](file:///home/aadish/Documents/Github/FactStamp/src/services/ocrService.ts), [`src/lib/imageCompression.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/imageCompression.ts) | Accepts raw text or a WhatsApp forward screenshot. Screenshots run through client-side Tesseract.js OCR (`ocrService.ts`, `createWorker` from `tesseract.js`), which strips WhatsApp chat chrome (timestamps, delivery checkmarks, carrier/battery status bar text) via `cleanExtractedOcrText()` before the claim text is stored. Images are compressed client-side before upload. |
| 3 | **Duplicate Detection Engine** | [`src/lib/duplicateDetection.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/duplicateDetection.ts) | Jaccard word-overlap similarity: $J(A,B) = \|A \cap B\| / \|A \cup B\|$ against existing claims. $J \ge 0.75$ redirects the submitter to the existing verified claim instead of creating a duplicate. |
| 4 | **Verification Queue** | [`src/pages/VerifyQueue.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/VerifyQueue.tsx), [`src/pages/VerifyDetail.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/VerifyDetail.tsx), [`src/contexts/ClaimsContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/ClaimsContext.tsx) | Lists claims awaiting community verification; verifier workbench for submitting a verdict, source URL, source-quality rating, and a written explanation. Explanations are validated by `validateVerdictExplanation()` in `src/lib/security.ts` (min 50 chars / 8 words, anti-spam, anti copy-paste-the-claim checks) before acceptance. |
| 5 | **Weighted Consensus & Confidence Engine** | [`src/lib/confidenceScore.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/confidenceScore.ts) | Once ≥3 verifications exist, computes final verdict by majority and a confidence score $C = 0.40A + 0.30R + 0.30S$ (agreement ratio, average verifier reputation, source quality). |
| 6 | **Fact-Check Card Generator** | [`src/components/FactCheckCard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/FactCheckCard.tsx), [`src/pages/ClaimDetail.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/ClaimDetail.tsx) | Renders a 1080×1080px shareable verdict card and rasterizes it client-side via `html-to-image` (chosen over a legacy canvas parser because it natively supports OKLCH/OKLAB CSS colors). |
| 7 | **Misinformation Analytics Dashboard** | [`src/pages/Dashboard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Dashboard.tsx), [`src/components/DashboardChart.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/DashboardChart.tsx), [`src/lib/weeklyReport.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/weeklyReport.ts) | Recharts-based trend graphs, category distribution, top verifiers, and a rolling weekly trending-misinformation report. |
| 8 | **System Security & Notifications** | [`src/lib/security.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/security.ts), [`src/contexts/NotificationsContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/NotificationsContext.tsx), [`src/components/NotificationBell.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/NotificationBell.tsx), [`firestore.rules`](file:///home/aadish/Documents/Github/FactStamp/firestore.rules) | Client-side defense-in-depth covering OWASP-style vectors: XSS sanitization, verdict-explanation anti-spam validation, triple-layer file-upload validation (extension + MIME + magic-byte signature, 5MB cap), idle session timeout (30 min), and login rate-limiting (5 attempts → 15-minute lockout). Backed by real-time in-app notifications. |

## 4. Cross-Module Notes

- **Firestore is the single backend** (`src/lib/firebase.ts`) — there is no separate REST API; all modules read/write Firestore directly through `src/services/firebaseService.ts`, gated by `firestore.rules`.
- **`src/lib/types.ts`** is the canonical data-model file (`Claim`, `Verification`, `User`, `Verdict`, `ModerationReport`, `AdminAuditLog`) — always check it before describing a field in a dissertation chapter.
- Module numbering in this file follows the historical `Submission of Module N/` deliverable convention (Modules 1–7 = core pipeline, Module 8 = security/notifications, added 2026-08-27 per `Rules/CODE_PATHS_AND_NOTES.md`).

## 5. Rules for AI Agents

1. **Always resolve "Module N" against the table in §3**, not the older `Only_module/` screenshot-tooling folder (that folder is about *code-screenshot scripts*, not a system module — see [`Only_module/how_to.md`](file:///home/aadish/Documents/typst/FactStamp/Only_module/how_to.md)).
2. **Ground every module description in the file paths listed above** — do not describe hypothetical functionality not present in the linked files.
3. **When a chapter needs code screenshots for a module**, follow the decision checklist in `Only_module/how_to.md` (full-file vs. split screenshot scripts) using the file paths from §3.
4. **Diagram a module's internals** (state machine, pipeline) per [`Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md) — PlantUML for UML, Graphviz for DFDs.
5. **For admin-facing moderation of a module's data** (e.g. overriding a Module 5 consensus verdict), defer to [`Admin-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Admin-rules.md) rather than duplicating that content here.
