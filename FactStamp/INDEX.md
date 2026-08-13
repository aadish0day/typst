# FactStamp — Universal Master Project Index & Single Source of Truth

> **Stop WhatsApp Fake News Before It Spreads.**  
> FactStamp is a decentralized, community-driven fact-checking web platform built to verify viral WhatsApp forwards using a weighted 3-verifier quorum consensus engine and downloadable fact-check PNG cards.

This document is the **authoritative master reference** for both human developers and AI agents. It maps every file, component, rule, template, algorithm, and workflow command across all project directories.

---

## System Root Directory Locations

| System Domain | Absolute Path | Primary Purpose |
| :--- | :--- | :--- |
| **Typst Workspace** *(Current)* | [`/home/aadish/Documents/typst/FactStamp`](file:///home/aadish/Documents/typst/FactStamp) | Academic dissertation, report chapters, SRS, and Typst compilation assets. |
| **Obsidian Vault** | [`/home/aadish/Documents/Obsidian/Project/persnoal/FactStamp`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp) | Personal project notes, daily logs, UI specs, and detailed module docs. |
| **Github Repository** | [`/home/aadish/Documents/Github/FactStamp`](file:///home/aadish/Documents/Github/FactStamp) | Full application source code (React 18, Vite 5, Tailwind CSS v4, Firebase, Docker). |

---

## "Where to Look for What" — Quick Decision Matrix

| Task / Topic | Target File Link | Key Guidelines & Rules |
| :--- | :--- | :--- |
| **Typst Page Format & Margins** | [`Rules/Typst_format.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md) | A4, 1.5in left margin, font fallbacks (*Times New Roman*), dual-mode `standalone` vs `blackbook`, `styled-table`, `landscape-page`. |
| **Diagram Tooling & Standards** | [`Rules/Diagram-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Diagram-rules.md) | PlantUML (`.puml` → SVG) for UML (Class, ER, Object, State, Use Case, Package, Deployment), Graphviz (`.dot` → SVG) for DFDs (Level 0/1/2), top-to-bottom vertical layout. |
| **Code Screenshot Automation** | [`Only_module/how_to.md`](file:///home/aadish/Documents/typst/FactStamp/Only_module/how_to.md) | `code-screenshot-v4.sh` (<150 lines, dynamic height), `code-split.sh` (>150 lines, ~70-line A4 chunks). Sequential run only. |
| **AI Template Selection Matrix** | [`Rules/Template-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Template-rules.md) | Decision matrix for selecting reference templates when writing dissertation chapters. |
| **Codebase & File Inventory Map** | [`Rules/CODE_PATHS_AND_NOTES.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/CODE_PATHS_AND_NOTES.md) | Complete directory map of React components, page views, utilities, contexts, and Firestore rules. |
| **Dissertation Syllabus & Outline** | [`Project_syllabus.md`](file:///home/aadish/Documents/typst/FactStamp/Project_syllabus.md) | Official 7-chapter outline (Course `JUSIT-DSCPR503`) & mandatory front-matter requirements. |
| **IEEE 830 SRS Specification** | [`srs_template-ieee.md`](file:///home/aadish/Documents/typst/FactStamp/srs_template-ieee.md) | IEEE 830 standard template for functional/non-functional requirements, external interfaces, and system features. |
| **Scrum Framework & Roles** | [`template/2020-Scrum-Guide-US.md`](file:///home/aadish/Documents/typst/FactStamp/template/2020-Scrum-Guide-US.md) | Official 2020 Scrum Guide rules (Product Owner, Scrum Master, Developers, 5 Events, 3 Artifacts). |
| **Scrum Agile Lifecycle** | [`template/SCRUM_Model.md`](file:///home/aadish/Documents/typst/FactStamp/template/SCRUM_Model.md) | Sprint planning, daily standups, backlog refinement, velocity metrics, and burndown charts. |
| **SDLC Process Models** | [`template/SDLC_Software_Process_Models.md`](file:///home/aadish/Documents/typst/FactStamp/template/SDLC_Software_Process_Models.md) | Comparative evaluation of Waterfall, Spiral, V-Model, Iterative, and Agile SDLC methodologies. |
| **Extreme Programming (XP)** | [`template/Extreme_Programming.md`](file:///home/aadish/Documents/typst/FactStamp/template/Extreme_Programming.md) | Engineering practices: Pair Programming, Test-Driven Development (TDD), Refactoring, Continuous Integration. |
| **Kanban Flow & WIP Limits** | [`template/Kanban.md`](file:///home/aadish/Documents/typst/FactStamp/template/Kanban.md) | Work-In-Progress limits, visual workflow queues, cycle time optimization, and bottleneck management. |
| **Feature-Driven Development** | [`template/FDD.md`](file:///home/aadish/Documents/typst/FactStamp/template/FDD.md) | Feature list decomposition, domain object modeling, milestone tracking, and chief programmer strategy. |
| **Template Folder Index** | [`template/README.md`](file:///home/aadish/Documents/typst/FactStamp/template/README.md) | Index of all reference markdown templates in the `template/` directory. |
| **Academic Synopsis & 7 Modules** | [`Obsidian: documentation/full.md`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp/documentation/full.md) | Project abstract, problem statement, 8 objectives, and detailed specs for all 7 system modules. |
| **UI Design System & Tokens** | [`Obsidian: documentation/ui.md`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp/documentation/ui.md) | `Saffron Sleek` design system, OKLCH warm-tinted color ramps, fluid tokens, DM Sans typography, zero-purple mandate. |
| **Dev Logs & Bug Tracebacks** | [`Obsidian: daily-doc/31-7-26.md`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp/daily-doc/31-7-26.md) | Developer interaction log, bug tracebacks, `html2canvas` `oklab` color parsing patch details. |
| **Obsidian Vault Master Hub** | [`Obsidian: INDEX.md`](file:///home/aadish/Documents/Obsidian/Project/persnoal/FactStamp/INDEX.md) | Master hub note in Obsidian connecting notes, daily docs, and problem logs (`[[INDEX]]`). |
| **Github Application Summary** | [`Github: README.md`](file:///home/aadish/Documents/Github/FactStamp/README.md) | Codebase setup, dependencies, Docker Compose runtimes, and Firebase Local Emulator suite. |

---

## GitHub Source Code Repository Inventory (`/home/aadish/Documents/Github/FactStamp`)

### 1. Application Entrypoints & Global Setup
* [`src/main.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/main.tsx) — React DOM root rendering script.
* [`src/App.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/App.tsx) — Main React Router navigation shell & provider wrapping.
* [`src/index.css`](file:///home/aadish/Documents/Github/FactStamp/src/index.css) — Tailwind CSS v4 design tokens (`saffron-sleek` OKLCH color ramps, fluid typography, concentric radii).
* [`src/vite-env.d.ts`](file:///home/aadish/Documents/Github/FactStamp/src/vite-env.d.ts) — Vite TypeScript environment declarations.

### 2. Main Page Views (`src/pages/`)
* [`src/pages/Home.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Home.tsx) — Hero section, rapid claim lookup, live stats marquee, recent debunked claims grid.
* [`src/pages/Submit.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Submit.tsx) — Forward submission form (text input + screenshot base64 image compression/OCR text extraction).
* [`src/pages/VerifyQueue.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/VerifyQueue.tsx) — Community verification queue listing claims awaiting 3-verifier quorum consensus.
* [`src/pages/VerifyDetail.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/VerifyDetail.tsx) — Verifier workbench view for evaluating claims, adding source links, and submitting verdicts.
* [`src/pages/ClaimDetail.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/ClaimDetail.tsx) — Single claim view with verdict badge, confidence breakdown, source list, and `html2canvas` PNG card export.
* [`src/pages/Dashboard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Dashboard.tsx) — Misinformation analytics dashboard with Recharts trend graphs, category distribution, and top verifiers.
* [`src/pages/Profile.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/Profile.tsx) — User profile page displaying verifier reputation score, submitted claims, and accuracy stats.
* [`src/pages/SignIn.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/SignIn.tsx) — Authentication sign-in view (Email/Password & Google OAuth).
* [`src/pages/SignUp.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/SignUp.tsx) — Authentication sign-up view with initial reputation setup.
* [`src/pages/NotFound.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/pages/NotFound.tsx) — Custom 404 error page.

### 3. Core Domain Components (`src/components/`)
* [`src/components/Navbar.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/Navbar.tsx) — Main application navigation header with active tab indicator, search bar, and user avatar menu.
* [`src/components/Footer.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/Footer.tsx) — Application footer with quick links, tech stack badges, and copyright info.
* [`src/components/ClaimCard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ClaimCard.tsx) — Compact card preview for claims in grids or search results.
* [`src/components/FactCheckCard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/FactCheckCard.tsx) — 1080×1080px WhatsApp-optimised verdict card template targeted by `html2canvas`.
* [`src/components/VerdictStamp.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/VerdictStamp.tsx) — Visual verdict stamp badge (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIED`).
* [`src/components/DashboardChart.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/DashboardChart.tsx) — Recharts wrapper for trend graphs and category pie/bar charts.
* [`src/components/NotificationBell.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/NotificationBell.tsx) — Real-time notification menu for verifier updates and consensus alerts.
* [`src/components/AuthLayout.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/AuthLayout.tsx) — Split-screen authentication layout wrapper.
* [`src/components/Breadcrumbs.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/Breadcrumbs.tsx) — Accessible path breadcrumbs.
* [`src/components/ContrastChecker.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ContrastChecker.tsx) — APCA contrast checking utility component.
* [`src/components/ErrorBoundary.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ErrorBoundary.tsx) — React error boundary for runtime exception catching.
* [`src/components/OnlineStatusBar.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/OnlineStatusBar.tsx) — Network status indicator.
* [`src/components/ProtectedRoute.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ProtectedRoute.tsx) — Route guard requiring authenticated user session.
* [`src/components/AnimatedCounter.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/AnimatedCounter.tsx) — Framer Motion number tick counter.
* [`src/components/Seo.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/Seo.tsx) — Dynamic document title & meta tags manager.

### 4. Primitive UI Components (`src/components/ui/`)
* [`src/components/ui/Button.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Button.tsx) — Standard button with variant states (primary, secondary, outline, ghost, danger).
* [`src/components/ui/Input.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Input.tsx) — Accessible text input, textarea, and select wrappers with error states.
* [`src/components/ui/Modal.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Modal.tsx) — Framer Motion dialog overlay component.
* [`src/components/ui/Badge.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Badge.tsx) — Generic pill badge component.
* [`src/components/ui/CategoryBadge.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/CategoryBadge.tsx) — Color-coded claim category badge (Health, Political, Religious, Financial).
* [`src/components/ui/VerdictPill.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/VerdictPill.tsx) — Compact verdict pill with confidence score.
* [`src/components/ui/TrustRing.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/TrustRing.tsx) — Circular SVG progress ring for verifier reputation and confidence percentages.
* [`src/components/ui/SourceQualityDot.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/SourceQualityDot.tsx) — Source credibility rating indicator (high/medium/low).
* [`src/components/ui/EmptyState.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/EmptyState.tsx) — Reusable empty state view with illustration and CTA.
* [`src/components/ui/ErrorState.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/ErrorState.tsx) — Reusable inline error fallback component.
* [`src/components/ui/Skeletons.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Skeletons.tsx) — Shimmer loading skeletons for cards, tables, and detail views.
* [`src/components/ui/Avatar.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Avatar.tsx) — User profile image / initials fallback avatar.
* [`src/components/ui/BorderBeam.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/BorderBeam.tsx) — Subtle animated border light beam effect.
* [`src/components/ui/FlowButton.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/FlowButton.tsx) — Smooth flowing CTA button.
* [`src/components/ui/InteractiveHoverButton.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/InteractiveHoverButton.tsx) — Micro-interactive hover state button.
* [`src/components/ui/InteractiveShieldButton.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/InteractiveShieldButton.tsx) — Verifier action button with shield animation.
* [`src/components/ui/Marquee.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/Marquee.tsx) — Continuous scrolling statistics banner.
* [`src/components/ui/PasswordStrength.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/PasswordStrength.tsx) — Real-time password strength meter.
* [`src/components/ui/ShimmerButton.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/ShimmerButton.tsx) — Premium shimmer highlight button.
* [`src/components/ui/ShimmerText.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/ShimmerText.tsx) — Text shimmer sweep effect.
* [`src/components/ui/SpotlightCard.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/components/ui/SpotlightCard.tsx) — Mouse-following spotlight card container.

### 5. Application Contexts (`src/contexts/`)
* [`src/contexts/AuthContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/AuthContext.tsx) — Firebase Auth session provider (login, logout, sign-up, Google OAuth, user profile state).
* [`src/contexts/ClaimsContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/ClaimsContext.tsx) — Claims state provider (claim creation, duplicate check trigger, verification submission, consensus computation).
* [`src/contexts/NotificationsContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/NotificationsContext.tsx) — Real-time notifications state provider.
* [`src/contexts/ThemeContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/ThemeContext.tsx) — Light/Dark theme provider (`dark` class toggle on root `<html>`).
* [`src/contexts/UsersContext.tsx`](file:///home/aadish/Documents/Github/FactStamp/src/contexts/UsersContext.tsx) — Users directory and reputation leaderboard provider.

### 6. Logic Core & Utility Libraries (`src/lib/`)
* [`src/lib/firebase.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/firebase.ts) — Firebase SDK initialization (Auth, Firestore, Storage) with emulator connection fallbacks.
* [`src/lib/types.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/types.ts) — Core TypeScript data interfaces (`Claim`, `Verification`, `User`, `VerdictType`, `CategoryType`).
* [`src/lib/duplicateDetection.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/duplicateDetection.ts) — Jaccard word-overlap similarity scoring algorithm ($J \ge 0.75$ threshold).
* [`src/lib/confidenceScore.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/confidenceScore.ts) — Weighted consensus algorithm (40% agreement, 30% verifier reputation, 30% source quality).
* [`src/lib/imageCompression.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/imageCompression.ts) — Client-side screenshot image compression pipeline producing compact base64 strings.
* [`src/lib/apca.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/apca.ts) — APCA contrast math library ensuring accessibility compliance.
* [`src/lib/weeklyReport.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/weeklyReport.ts) — Client-side analytics & weekly trending report computation engine.
* [`src/lib/utils.ts`](file:///home/aadish/Documents/Github/FactStamp/src/lib/utils.ts) — General helper functions including `html2canvas` computed style patcher (converts `oklch`/`oklab` to `rgb`/`rgba`).

### 7. Data Services (`src/services/`)
* [`src/services/firebaseService.ts`](file:///home/aadish/Documents/Github/FactStamp/src/services/firebaseService.ts) — Firestore CRUD service operations for `claims`, `verifications`, and `users` collections.

### 8. Repository Configuration Files
* [`firestore.rules`](file:///home/aadish/Documents/Github/FactStamp/firestore.rules) — Firestore Security Rules enforcing data structure validation, user authentication, and verifier permissions.
* [`storage.rules`](file:///home/aadish/Documents/Github/FactStamp/storage.rules) — Firebase Storage Security Rules.
* [`package.json`](file:///home/aadish/Documents/Github/FactStamp/package.json) — NPM dependencies, scripts (`dev`, `build`, `emulators`, `seed:db`).
* [`vite.config.ts`](file:///home/aadish/Documents/Github/FactStamp/vite.config.ts) — Vite bundler configuration.
* [`tsconfig.json`](file:///home/aadish/Documents/Github/FactStamp/tsconfig.json) — TypeScript compiler configuration.
* [`docker-compose.yml`](file:///home/aadish/Documents/Github/FactStamp/docker-compose.yml) — Docker Compose service definitions (`dev` container with hot-reload, `prod` Nginx container).
* [`Dockerfile`](file:///home/aadish/Documents/Github/FactStamp/Dockerfile) — Multi-stage Docker build file.
### 9. Module Submissions & Compiled Deliverables
* [`Submission of Module 6`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20Module%206) — Module 6: Fact-Check Card Generator deliverable ([`fact_check_card_generator.typ`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20Module%206/fact_check_card_generator.typ) & [`fact_check_card_generator.pdf`](file:///home/aadish/Documents/typst/FactStamp/Submission%20of%20Module%206/fact_check_card_generator.pdf)).

---

## Academic Dissertation Syllabus Structure (`Project_syllabus.md`)

Dissertation chapter structure for Course **`JUSIT-DSCPR503` (Project Dissertation and Implementation)**:

* **Front Matter**: Title Page, Approved Proforma, Authenticated Work Certificate, Role & Responsibility Form, Abstract, Acknowledgement, Table of Contents, Table of Figures.
* **Chapter 1: Introduction**: Background, Objectives (1–8), Purpose, Scope, Applicability, Achievements, Report Organization.
* **Chapter 2: Survey of Technologies**: Evaluation of React 18, Vite 5, Tailwind CSS v4, Firebase v12, Framer Motion, Recharts, html2canvas, Docker.
* **Chapter 3: Requirements and Analysis**: Problem Definition, Requirements Spec, Planning/Scheduling, SW/HW Requirements, Conceptual Models (DFDs Level 0/1/2, Use Cases).
* **Chapter 4: System Design**: Basic Modules (7 Modules), Data Design & Firestore Schemas, Procedural Design/Algorithms (Jaccard, Consensus), UI Design (`Saffron Sleek`), Security Issues, Test Case Design.
* **Chapter 5: Implementation and Testing**: Implementation Approaches, Code Efficiency, Unit/Integrated/Beta Testing, Modifications, Test Cases.
* **Chapter 6: Results and Discussion**: Test Reports, User Documentation.
* **Chapter 7: Conclusions**: System Significance, Limitations, Future Scope, References, Glossary.

---

## Core System Algorithms & Mathematical Formulas

### 1. Jaccard Duplicate Detection Engine
To prevent redundant verification queues, incoming claim text $A$ is normalized (lowercased, stripped of punctuation) and tokenized into word set $A$. It is compared against existing claim word set $B$:

$$J(A, B) = \frac{|A \cap B|}{|A \cup B|}$$

- **Threshold**: If $J(A, B) \ge 0.75$, the submission is flagged as a duplicate and the user is redirected to the existing verified claim.

### 2. Weighted Consensus & Confidence Engine
When 3 or more verifications are submitted, the final verdict is determined by majority agreement. The confidence percentage $C$ is computed from three weighted components:

$$\text{Confidence } C = (A \times 40\%) + (R \times 30\%) + (S \times 30\%)$$

Where:
- $A$ = Verifier Agreement Ratio ($\frac{\text{Matching Verdicts}}{\text{Total Verdicts}}$).
- $R$ = Normalized Average Reputation Score of participating verifiers ($\frac{\bar{R}_{\text{verifiers}}}{100}$).
- $S$ = Source Quality Score (1.0 for WHO/Ministry of Health/Official news, 0.5 for secondary sources, 0.2 for unlinked sources).

### 3. HTML2Canvas OKLCH/OKLAB Color Function Patch
`html2canvas` fails to parse modern CSS `oklch()` and `oklab()` color functions used in Tailwind CSS v4. `src/lib/utils.ts` implements a computed style converter:
- Clones target DOM elements before rendering.
- Reads resolved `getComputedStyle(element)` values (which browsers evaluate to standard `rgb()` or `rgba()`).
- Replaces raw stylesheet CSS custom properties on cloned elements before passing to `html2canvas`.

---

## Core System Architecture (7 System Modules)

```mermaid
flowchart TD
    A["WhatsApp Forward Received (Text / Screenshot)"] --> B["Submission Engine (Module 2)"]
    B --> C{"Jaccard Duplicate Engine (Module 3)"}
    C -- "Match (>0.75)" --> D["Instant Existing Verdict & Card"]
    C -- "Unique Claim" --> E["Verification Queue (Module 4)"]
    E --> F["3 Independent Community Verifiers"]
    F --> G["Weighted Consensus Engine (Module 5)"]
    G --> H["Final Verdict & Confidence %"]
    H --> I["html2canvas Card Generator (Module 6)"]
    I --> J["WhatsApp Shareable PNG Export"]
    H --> K["Analytics Dashboard (Module 7)"]
```

1. **Module 1: Auth & Verifier Reputation**: Firebase Auth, reputation score weighting (base 50).
2. **Module 2: Forward Submission**: Text input & screenshot client compression / OCR text extraction.
3. **Module 3: Duplicate Engine**: Jaccard word-overlap similarity threshold `0.75`.
4. **Module 4: Verification Queue**: Minimum 3 verifications with source URL and plain-language explanation.
5. **Module 5: Consensus & Confidence Engine**: 40% verifier agreement, 30% verifier reputation, 30% source quality.
6. **Module 6: Fact-Check Card Generator**: 1080×1080px client-side PNG export via `html2canvas`.
7. **Module 7: Misinformation Dashboard**: Recharts analytics, weekly reports, category distribution.

---

## Universal CLI Commands Cheat Sheet

```bash
# 1. Run React App Dev Server (Github dir)
cd /home/aadish/Documents/Github/FactStamp
npm run dev

# 2. Run Firebase Emulators & Seed DB
npm run emulators
npm run seed:db

# 3. Docker Runtimes
docker compose up dev   # Local Dev with Hot Reload
docker compose up prod  # Nginx Production Build

# 4. Compile Typst Document (Typst dir)
cd /home/aadish/Documents/typst/FactStamp
typst compile 3.6_dfd.typ 3.6_dfd.pdf                                          # Standalone mode
typst compile --input mode=blackbook master_blackbook.typ master_blackbook.pdf # Blackbook mode

# 5. Generate Diagram Assets
plantuml -tsvg attachments/class_diagram.puml
dot -Tsvg attachments/dfd_level_0.dot -o attachments/dfd_level_0.svg

# 6. Generate Code Screenshots (Only_module dir)
bash Only_module/scripts/code-screenshot-v4.sh src/lib/types.ts attachments/types.png 'types.ts'
bash Only_module/scripts/code-split.sh src/pages/ClaimDetail.tsx 1 70 attachments/claim_1_70.png 'ClaimDetail.tsx'
```
