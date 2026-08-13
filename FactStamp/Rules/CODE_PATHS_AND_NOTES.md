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
- [x] Drafted Chapter 4 sections: Data Integrity & Constraints (4.2.2) and User Interface Design & Security (4.4).
- [x] Created fresh `Submission of Module 5/` (Module 5: Confidence Scoring & Consensus Engine) with 3-component weighted scoring math, domain rules matrix, split code modules, and compiled PDF deliverable.
- [x] Created `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/` with PlantUML ER & Security Deployment diagrams, split code modules, and compiled PDF deliverable.
- [ ] Complete remaining chapters according to dissertation syllabus.

### 📌 Log Space for Future Notes
- **2026-08-06 (Chp 5.1 compile fixes):** `implementation_approach.typ` now compiles cleanly on **Typst 0.15.1** → 30-page `implementation_approach.pdf` deliverable. Two errors fixed: (1) `* ` line-start list markers are invalid in Typst (`*` = emphasis only) → converted 15 bullets to `- `; (2) `block(max-height: ...)` is unsupported in 0.15.1 → `responsive-image` helper rewritten to use `image(width, height, fit: "contain")`. `Rules/Typst_format.md` synced to the fixed helper. Only remaining output is the expected font-fallback warning (Times New Roman/Fira Code absent on Linux → Liberation Serif/DejaVu used).

*(Add ongoing code paths, meeting notes, research findings, and task items here.)*
