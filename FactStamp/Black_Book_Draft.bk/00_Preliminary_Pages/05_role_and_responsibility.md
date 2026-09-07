# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 05: Role and Responsibility Form

---

### Administrative Header

```text
====================================================================================================
                              JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)
                               DEPARTMENT OF INFORMATION TECHNOLOGY
                           'A' Road, Churchgate, Mumbai – 400 020
                  Affiliated with the University of Mumbai | Academic Year: 2026–2027
====================================================================================================
                                  ROLE AND RESPONSIBILITY FORM
                  Formal SDLC Work Breakdown & Individual Contribution Matrix
                       Course Code: JUSIT-DSCPR503 (Credits: 01)
               Practical Title: Project Dissertation and Implementation (Sem V / VI)
====================================================================================================
```

*Note: In accordance with University of Mumbai guidelines for undergraduate engineering and IT capstone dissertations, this form formally records the individual software development lifecycle (SDLC) role, subsystem allocations, and verified contribution percentage of the candidate.*

---

### Candidate and Project Profile

| Parameter | Record Details |
| :--- | :--- |
| **Candidate Name** | **Aadish Das** |
| **Unique Identification (UID)** | **2023IT001** |
| **Institutional Roll Number** | **10** |
| **Class / Academic Session** | T.Y. B.Sc. (Information Technology) — Semester V / VI (2026–2027) |
| **Project Full Title** | **FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker** |
| **Project Architecture Type** | Decoupled Single-Page Web Application (SPA) with Cloud Firestore NoSQL |
| **Project Nature** | **Solo Capstone Project (100% Individual Engineering Effort)** |
| **Faculty Supervisors** | **Mr. Wilson Rao** (HOD) & **Ms. Bertilla Fernandes** (Assistant Professor) |

---

### Technical Responsibility Breakdown Across 8 Core Modules

Because FactStamp was conceived, engineered, tested, and documented entirely as an **individual capstone effort**, candidate **Aadish Das** assumed 100% responsibility across all functional modules:

```text
+----------------------------------------------------------------------------------------------------------------+
| MODULE 1: AUTHENTICATION & ROLE-BASED ACCESS CONTROL (RBAC)                           [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Integrated Firebase Authentication v12.17.0 supporting Email/Password and Google OAuth 2.0 sessions.         |
| - Configured React AuthContext provider and protected client route guards (ProtectedRoute.tsx).                |
| - Designed user schema initializing baseline reputation score at R0 = 50 with strict session state isolation.  |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 2: MULTIMODAL CLAIM INGESTION & CLIENT PREPROCESSING                           [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Developed dual-mode claim submission interface (raw text up to 2,000 chars and screenshot drag-and-drop).   |
| - Engineered client-side HTML5 Canvas API image compression pipeline resizing images to max 1200px width/height|
|   and compressing base64 payloads under 500 KB to preserve a strict zero cloud storage billing model.          |
| - Integrated in-browser Tesseract.js WebAssembly OCR extracting textual forwards directly in client memory.   |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 3: JACCARD TOKEN-BASED DUPLICATE DETECTION ENGINE                              [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Implemented string normalization, punctuation-stripping, and word tokenization algorithms.                  |
| - Formulated set-theoretic Jaccard similarity index J(A, B) = |A ∩ B| / |A ∪ B| with empirical threshold >=0.75|
| - Architected sub-100ms Firestore query pipeline instantly routing users to existing certified verdicts.       |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 4: COMMUNITY VERIFICATION QUORUM QUEUE                                        [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Constructed real-time verification queue using Firestore v12.17.0 onSnapshot WebSocket listeners.           |
| - Enforced three-verifier quorum gate (N >= 3) before claim transitions from "in_review" to "verified".        |
| - Developed verifier submission workbench with mandatory verdict selection, citation URL, and rationale.      |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 5: MULTI-FACTOR WEIGHTED QUORUM CONSENSUS ENGINE                               [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Engineered composite confidence formula: C = 0.40A + 0.30R + 0.30S (Agreement, Reputation, Source Quality).  |
| - Built automated reputation adjustment loop (+2 for consensus alignment, -3 for outlier votes).              |
| - Designed deterministic 5-state verdict classifier (TRUE, FALSE, MISLEADING, UNVERIFIABLE, CONTESTED).        |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 6: WHATSAPP-NATIVE VISUAL FACT CARD GENERATOR                                  [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Architected client-side graphical compiler utilizing html-to-image 1.11.13 via browser SVG <foreignObject>. |
| - Resolved OKLCH CSS Color Level 4 syntax incompatibilities, guaranteeing pixel-perfect 1080x1080px cards.    |
| - Styled visual elements: verdict color banners, dynamic SVG Trust Rings, claim snippets, source pills.       |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 7: MISINFORMATION ANALYTICS DASHBOARD & TREND REPORTING                        [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Integrated Recharts 2.10.0 library for interactive visualization of category distributions and surges.       |
| - Implemented 7-day rolling window analytics engine aggregating platform verification velocity and accuracy.  |
| - Built real-time verifier reputation leaderboard recognizing top civic contributors.                         |
+----------------------------------------------------------------------------------------------------------------+
| MODULE 8: SYSTEM SECURITY, ANTI-SYBIL DEFENSE & DEVOPS                                [ CONTRIBUTION: 100% ]  |
+----------------------------------------------------------------------------------------------------------------+
| - Authored declarative Cloud Firestore v12.17.0 security rules blocking unauthorized writes and self-voting.   |
| - Implemented reactive notification engine alerting claim submitters upon quorum consensus finalization.       |
| - Conducted APCA contrast audits for accessibility (Lc > 75) and packaged into multi-stage Docker containers.  |
+----------------------------------------------------------------------------------------------------------------+
```

---

### Formal SDLC Lifecycle Allocation

| SDLC Phase | Core Engineering Activities Performed by Candidate | Verified Effort Allocation |
| :--- | :--- | :---: |
| **Requirements Engineering & SRS** | Formulated IEEE Std 830-1998 specifications (REQ-1 to REQ-10, NFR-1 to NFR-5), PERT critical path analysis, and WBS breakdown. | **100%** |
| **Conceptual Modeling** | Authored all 16 conceptual models: DFD Level 0/1/2, Use Cases, Event Tables, Activity, State Machine, Sequence, Class, Object, Component, Deployment, and E-R diagrams. | **100%** |
| **Architectural & Data Design** | Architected decoupled React 18.3.1 + Vite 5.4.0 SPA, designed Firestore NoSQL schema dictionaries, indexing rules, and Saffron Sleek OKLCH design tokens. | **100%** |
| **Algorithmic Formulation** | Formulated in-browser Canvas downsampling (<500 KB base64 payload), Jaccard duplicate detection ($J \ge 0.75$), and multi-factor weighted quorum consensus ($C = 0.40A + 0.30R + 0.30S$). | **100%** |
| **Frontend & UI Implementation** | Developed complete React 18.3.1 application, Tailwind CSS v4.0.0 styles, Framer Motion transitions, responsive mobile views, and html-to-image 1.11.13 card compiler. | **100%** |
| **Backend & Security Integration** | Configured Firebase Auth v12.17.0, Firestore real-time WebSocket listeners, anti-Sybil database rules, and offline IndexedDB persistence. | **100%** |
| **Verification & Quality Assurance** | Conducted unit testing of algorithms, emulator-based security rule validation (10,000 automated test cases), APCA contrast evaluation, and mobile beta testing. | **100%** |
| **Dissertation & Technical Docs** | Authored complete 7-chapter academic dissertation, user documentation manual with 8 step-by-step screens, and Typst typesetting templates. | **100%** |

---

### Verification and Institutional Signatures

```text
+--------------------------------------------------------------------------------------------------+
|                                    FORMAL SIGNATURE MATRIX                                       |
+------------------------------------+-------------------------------------------------------------+
| __________________________________ | ___________________________________________________________ |
| Candidate Signature:               | Internal Guide 1 Signature:                                 |
| AADISH DAS                         | MR. WILSON RAO                                              |
| UID: 2023IT001 | Roll No.: 10       | Head of Department (IT & Software Development)              |
| Date: 04/09/2026                   | Date: 04/09/2026                                            |
+------------------------------------+-------------------------------------------------------------+
| __________________________________ | ___________________________________________________________ |
| Internal Guide 2 Signature:        | Project Coordinator / HOD Signature:                        |
| MS. BERTILLA FERNANDES             | MR. WILSON RAO                                              |
| Assistant Professor (Dept of IT)   | Head of Department & Convener, Project Review Committee     |
| Date: 04/09/2026                   | Date: 04/09/2026                                            |
+------------------------------------+-------------------------------------------------------------+
```
