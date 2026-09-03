# FactStamp — Code Paths, Documentation & Project Notes

> **Project Title:** FactStamp — A Community-Powered WhatsApp Misinformation Fact-Checker  
> **Course Code / Subject:** Project Dissertation and Implementation (`JUSIT-DSCPR503`)  
> **Institution:** Department of Information Technology, Jai Hind College, Mumbai  

---

## 1. Directory & File Map (Code & Documentation Paths)

### 📌 Root Workspace Files
| File Path | Description |
|---|---|
| [`/home/aadish/Documents/typst/FactStamp/Project_syllabus.md`](file:///home/aadish/Documents/typst/FactStamp/Project_syllabus.md) | Official dissertation chapter syllabus structure & outline. |
| [`/home/aadish/Documents/typst/FactStamp/Project_syllabus.pdf`](file:///home/aadish/Documents/typst/FactStamp/Project_syllabus.pdf) | Compiled PDF version of the Project Syllabus. |
| [`/home/aadish/Documents/typst/FactStamp/CODE_PATHS_AND_NOTES.md`](file:///home/aadish/Documents/typst/FactStamp/CODE_PATHS_AND_NOTES.md) | Central repository file path index and project development notes (this file). |

### 📌 Rules & Standards (`Rules/`)
| File Path | Description |
|---|---|
| [`/home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md) | Diagram tooling standards (PlantUML for UML, Graphviz for DFD, Native Typst for tables). |
| [`/home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md) | Master Typst document formatting, page margins, typography, front-matter templates, and dual-mode build flags. |

### 📌 Screenshot & Module Workflow (`Only_module/`)
| File Path | Description |
|---|---|
| [`/home/aadish/Documents/typst/FactStamp/Only_module/how_to.md`](file:///home/aadish/Documents/typst/FactStamp/Only_module/how_to.md) | Documentation & decision rules for screenshot pipeline (when to use vs. when NOT to use scripts). |
| [`/home/aadish/Documents/typst/FactStamp/Only_module/scripts/code-screenshot-v4.sh`](file:///home/aadish/Documents/typst/FactStamp/Only_module/scripts/code-screenshot-v4.sh) | Bash script for full-file syntax-highlighted code screenshots (viewport 700x9999px). |
| [`/home/aadish/Documents/typst/FactStamp/Only_module/scripts/code-split.sh`](file:///home/aadish/Documents/typst/FactStamp/Only_module/scripts/code-split.sh) | Bash script for split line-range code screenshots fitting single A4 pages. |

### 📌 FactStamp Application Codebase (`/home/aadish/Documents/Github/FactStamp/`)
| File / Directory Path | Description |
|---|---|
| [`/home/aadish/Documents/Github/FactStamp/package.json`](file:///home/aadish/Documents/Github/FactStamp/package.json) | React + Vite + Firebase application package dependencies and build scripts. |
| [`/home/aadish/Documents/Github/FactStamp/vite.config.ts`](file:///home/aadish/Documents/Github/FactStamp/vite.config.ts) | Vite build & bundler configuration. |
| [`/home/aadish/Documents/Github/FactStamp/firestore.rules`](file:///home/aadish/Documents/Github/FactStamp/firestore.rules) | Firestore database security rules & data validation. |
| [`/home/aadish/Documents/Github/FactStamp/src/App.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/App.tsx) | Main React Router application entry point. |
| [`/home/aadish/Documents/Github/FactStamp/src/main.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/main.tsx) | React DOM root rendering script. |
| [`/home/aadish/Documents/Github/FactStamp/src/index.css`](file:///home/aadish/Documents/Github/FactStamp/src/index.css) | Global styling and Tailwind / design tokens. |
| [`/home/aadish/Documents/Github/FactStamp/src/pages/`](file:///home/aadish/Documents/Github/FactStamp/src/pages/) | Main page views: `Home.tsx`, `Dashboard.tsx`, `ClaimDetail.tsx`, `VerifyQueue.tsx`, `Submit.tsx`, `Profile.tsx`, `SignIn.tsx`, `SignUp.tsx`. |
| [`/home/aadish/Documents/Github/FactStamp/src/components/`](file:///home/aadish/Documents/Github/FactStamp/src/components/) | Key components: `ClaimCard.tsx`, `FactCheckCard.tsx`, `VerdictStamp.tsx`, `DashboardChart.tsx`, `Navbar.tsx`, `Footer.tsx`. |
| [`/home/aadish/Documents/Github/FactStamp/src/components/ui/`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/) | UI library: `Button.tsx`, `Input.tsx`, `Modal.tsx`, `Badge.tsx`, `TrustRing.tsx`, `VerdictPill.tsx`, `EmptyState.tsx`, `ErrorState.tsx`. |
| [`/home/aadish/Documents/Github/FactStamp/src/contexts/`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/) | State management: `AuthContext.tsx`, `ClaimsContext.tsx`, `NotificationsContext.tsx`, `ThemeContext.tsx`, `UsersContext.tsx`. |
| [`/home/aadish/Documents/Github/FactStamp/src/lib/`](file:///home/aadish/Documents/Github/FactStamp/src/lib/) | Utility logic: `firebase.ts`, `types.ts`, `confidenceScore.ts`, `duplicateDetection.ts`, `imageCompression.ts`, `apca.ts`, `weeklyReport.ts`. |

### 📌 Obsidian Project Notes (`/home/aadish/Documents/Obsidian/`)
| Directory Path | Description |
|---|---|
| [`/home/aadish/Documents/Obsidian/Project/persnoal/FactStamp`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp) | Personal Obsidian vault project notes & documentation for FactStamp. |

---

## 2. Project Syllabus & Report Architecture

The report is structured into 7 main chapters as specified in [`Project_syllabus.md`](file:///home/aadish/Documents/typst/FactStamp/Project_syllabus.md):

* **Front Matter:** Title Page, Approved Proforma, Authenticated Work Certificate, Role & Responsibility Form, Abstract, Acknowledgement, Table of Contents, Table of Figures.
* **Chapter 1: Introduction** (Background, Objectives, Purpose, Scope, Applicability, Achievements, Organisation of Report)
* **Chapter 2: Survey of Technologies**
* **Chapter 3: Requirements and Analysis** (Problem Definition, Requirements Spec, Planning/Scheduling, SW/HW Requirements, Conceptual Models — DFDs, ER, Use Case)
* **Chapter 4: System Design** (Basic Modules, Data Design/Schema, Procedural Design, UI Design, Security Issues, Test Case Design)
* **Chapter 5: Implementation and Testing** (Implementation Approaches, Code Efficiency, Unit/Integrated/Beta Testing, Modifications & Improvements, Test Cases)
* **Chapter 6: Results and Discussion** (Test Reports, User Documentation)
* **Chapter 7: Conclusions** (Significance, Limitations, Future Scope, References, Glossary)

---

## 3. Formatting & Diagram Quick Reference

### Compilation Commands
```bash
# Compile individual submission (standalone mode)
typst compile section.typ section.pdf

# Compile master blackbook (assembly mode)
typst compile --input mode=blackbook master_blackbook.typ master_blackbook.pdf

# Generate PlantUML SVG diagram
plantuml -tsvg attachments/class_diagram.puml

# Generate Graphviz DFD SVG diagram
dot -Tsvg attachments/dfd_level_0.dot -o attachments/dfd_level_0.svg
```

### Folder & Sub-file Naming Rule
- **Folder Name**: **MUST EXACTLY MATCH** the title/prompt specified by the user (e.g. `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/`).
- **Sub-files (`.typ` & `.pdf`)**: Use a **descriptive title slug** with lowercase words and underscores (e.g. `data_integrity_and_security_issues.typ` & `data_integrity_and_security_issues.pdf`).

### Diagram Rules Checklist
- **PlantUML (`.puml`):** ER, Class, Object, Component, Package, Deployment, Use Case, State diagrams.
- **Graphviz (`.dot`):** Level 0 / 1 / 2 Data Flow Diagrams (DFDs) only.
- **Native Typst (`#table()` / `fletcher`):** Sequence diagrams, Event tables, small callouts.

---

## 4. Project Development Notes & Logs

### 📌 Project Milestones & Progress
- [x] Initialized workspace structure, Typst format rules, and Diagram tooling rules.
- [x] Created screenshot scripts for code submission embedding (`code-screenshot-v4.sh`, `code-split.sh`).
- [x] Documented decision rules for `Only_module` screenshot scripts (when to use vs. when NOT to use).
- [x] Created `Submission of 5.1 Implementation Approach :• Project Summary,5.2 Coding Details and Code Efficiency,5.2.1 Code Efficiency/` covering Chapter 5.1 Project Summary, 6-sprint Agile Scrum execution, tech stack, PlantUML implementation architecture diagram, Chapter 5.2 coding details for all 5 core modules (`types.ts`, `duplicateDetection.ts`, `confidenceScore.ts`, `imageCompression.ts`, `utils.ts` OKLCH color transformer) with IDE screenshots, and 5.2.1 asymptotic complexity analysis and bundle efficiency benchmarks in a 14-page compiled PDF deliverable.
- [x] Created `Submission of 5.4 Modifications and Improvements, 6.1 User Documentation(User manual with screen Layouts)/` covering Chapter 5.4 Modifications & Improvements (5 core architectural evolutions: dynamic canvas screenshot compression, enhanced Jaccard stop-word filter, OKLCH-to-sRGB transformer, anti-sybil self-verification locks, domain credibility whitelist with summary comparison matrix) and Chapter 6.1 User Documentation (role-based operational workflows, UML user flow map SVG, 8 detailed screen walkthroughs with PlantUML workbench and fact-card layout schematics, error handling matrix, and FAQs) in a 10-page compiled PDF deliverable.
- [ ] Complete remaining chapters according to dissertation syllabus.

### 📌 Log Space for Future Notes
- **2026-08-06 (Chp 5.1 compile fixes):** `implementation_approach.typ` now compiles cleanly on **Typst 0.15.1** → 30-page `implementation_approach.pdf` deliverable. Two errors fixed: (1) `* ` line-start list markers are invalid in Typst (`*` = emphasis only) → converted 15 bullets to `- `; (2) `block(max-height: ...)` is unsupported in 0.15.1 → `responsive-image` helper rewritten to use `image(width, height, fit: "contain")`. `Rules/Typst_format.md` synced to the fixed helper. Only remaining output is the expected font-fallback warning (Times New Roman/Fira Code absent on Linux → Liberation Serif/DejaVu used).
- **2026-08-20 (Module 7 deliverable):** `trending_misinformation_dashboard.typ` compiled cleanly on **Typst 0.15.1** → 33-page `trending_misinformation_dashboard.pdf` deliverable in [`Submission of Module 7/`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20Module%207). Features PlantUML component architecture SVG diagram, mathematical formulations for 7-day rolling window analytics and verifier accuracy computation, test case matrix, and code screenshots of `weeklyReport.ts`, `DashboardChart.tsx`, `AnimatedCounter.tsx`, and `Dashboard.tsx` (11 chunks).
- **2026-08-20 (Chapter 7 deliverable):** `conclusion_and_future_scope.typ` compiled cleanly on **Typst 0.15.1** → 7-page `conclusion_and_future_scope.pdf` deliverable in [`Submission of 7. CONCLUSION(7.1 Conclusion, 7.2 Limitations of the System, 7.3 Future Scope of the Project, References/`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%207.%20CONCLUSION%287.1%20Conclusion,%207.2%20Limitations%20of%20the%20System,%207.3%20Future%20Scope%20of%20the%20Project,%20References). Comprehensive retrospective covering all 7 modules, societal significance, architectural boundaries, future roadmap, 16 formal academic references, and domain glossary.
- **2026-08-25 (Final SRS deliverable):** `final_srs.typ` compiled cleanly on **Typst 0.15.1** → 21-page `final_srs.pdf` deliverable in [`Submission of Final SRS/`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20Final%20SRS). Fully compliant with IEEE Std 830-1998 structure (Sections 1–6 + Appendices A–C), featuring Graphviz Context Level 0 DFD, PlantUML Use Case and ER Diagrams, exact mathematical formulations ($J(A, B) \ge 0.75$, 40-30-30 weighted consensus), and numbered requirement specifications across all 7 core modules.
- **2026-08-25 (Gantt & Data Design deliverable):** `gantt_chart_and_data_design.typ` compiled cleanly on **Typst 0.15.1** → 13-page `gantt_chart_and_data_design.pdf` deliverable in [`Submission of GANTT chart,4.2 Data Design: Database and Schema Design/`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20GANTT%20chart,4.2%20Data%20Design:%20Database%20and%20Schema%20Design). Features PlantUML GANTT schedule diagram, 11-phase WBS, 9 milestones, risk matrix, NoSQL Firestore rationale, PlantUML ER Schema diagram, 5 formal JSON schemas, integrity constraints, and security rules.
- **2026-08-25 (Diagram Legibility & Professional Typography Rule 6):** Updated `Rules/Diagram-rules.md` (Rule 6) to establish modern, clean engineering sans-serif typography (`Liberation Sans` / `Helvetica-Bold`) across all PlantUML and Graphviz diagrams. Configured bold entity headers (22pt), bold attributes (18pt), diagram titles (26pt), thick 2.5px solid borders and arrows, and 100% full-width Typst embeds. Upgraded Use Case Diagram to a balanced upright 2-column grid. All 5 vector diagram assets re-rendered and both deliverables (`final_srs.pdf` and `gantt_chart_and_data_design.pdf`) recompiled cleanly.
- **2026-08-26 (Chapter 5.1 & 5.2 Deliverable):** Created `Submission of 5.1 Implementation Approach :• Project Summary,5.2 Coding Details and Code Efficiency,5.2.1 Code Efficiency/` featuring 5.1 Implementation Approach (Project Summary, Agile Scrum 6-sprint velocity table, tech stack, PlantUML vector architecture diagram), 5.2 Coding Details (TypeScript interfaces, Jaccard duplicate detector, 3-verifier weighted consensus engine, canvas screenshot compressor, and OKLCH color transformer with IDE screenshots), and 5.2.1 Code Efficiency (asymptotic complexity bounds, bundle tree-shaking, zero-cloud-storage egress economics, and memoization) in a 14-page compiled PDF deliverable.
- **2026-08-26 (Chapter 5.4 & 6.1 Deliverable):** Created `Submission of 5.4 Modifications and Improvements, 6.1 User Documentation(User manual with screen Layouts)/` featuring 5.4 Modifications & Improvements (5 core architectural evolutions, comparison matrix) and 6.1 User Documentation (role-based workflows, UML operational flow diagram, 8 detailed screen walkthroughs with PlantUML workbench and fact-card layout schematics, error handling matrix, FAQs) in a 10-page compiled PDF deliverable.
- **2026-08-27 (Module 8 deliverable):** Created `Submission of Module 8/` featuring Module 8: System Security, Anti-Sybil Defense & Real-Time Alerts Subsystem (`system_security_and_notifications.typ` & `system_security_and_notifications.pdf`). Includes PlantUML security architecture and anti-sybil state machine SVG diagrams, mathematical proofs for self-verification blocking ($P(u, c)$), binary magic byte array matching ($M$), exponential lockout thresholds ($L(N)$), code screenshots for `security.ts`, `NotificationsContext.tsx`, `NotificationBell.tsx`, and `firestore.rules`, OWASP security audit matrix, and 6 verification test cases in a 22-page compiled PDF deliverable.
