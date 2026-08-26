# BudgetLite Typst Academic Submissions

This workspace maintains the complete academic documentation, reports, and compiled deliverables for **BudgetLite: Offline-First Personal Budgeting App** for the course **ASDT**.

---

## Author & Project Metadata

- **Student Name:** Aadish das
- **UID:** 24BIT010
- **Roll No:** 10
- **Course / Subject:** ASDT (Advanced Software Development Tools)
- **Application Framework:** Flutter 3.x (Dart 3.x)
- **State Management:** Riverpod 2.x (`autoDispose` + `StreamProvider`)
- **Local Persistence:** Drift 2.x (SQLite Schema v5)
- **Target Platform:** Android (SDK 24+, iOS & Web scaffolds included)

---

## Submission Milestones

### 1. [CA1 Mini Project: 25% Submission](./CA1%20Mini%20Project:%2025%20%25%20Submission/)
- **Source Snapshot:** Commit `2d57e78` (*"feat: add recurring transactions, SMS parsing, accounts, and auto-categorization"*, Jul 24, 2026)
- **Core Scope:** Database Schema v2 (7 tables), multi-account ledger, automated recurring transaction engine, on-device regex SMS parsing & review queue, keyword-based auto-categorization, duplicate transaction detector, and Material 3 UI foundations.
- **Deliverables:**
  - [`main.pdf`](./CA1%20Mini%20Project:%2025%20%25%20Submission/main.pdf) (19 Pages, fully compiled with 5 vector PlantUML diagrams)
  - [`main.typ`](./CA1%20Mini%20Project:%2025%20%25%20Submission/main.typ) (Typst master source)
  - [`CA1_Mini_Project_Submission.md`](./CA1%20Mini%20Project:%2025%20%25%20Submission/CA1_Mini_Project_Submission.md) (Markdown reference)

---

### 2. [CA1 Mini Project: 50% Submission](./CA1%20Mini%20Project:%2050%20%25%20Submission/)
- **Source Snapshot:** Commit `b5376d0` (*"feat: add biometric lock, theme system, settings overhaul, and budget notifications"*, Jul 24, 2026)
- **Core Scope:** Full offline financial intelligence suite:
  - **Financial Insights & Analytics Suite:** Quartile activity heatmap (GitHub-style), interactive spend calendar (month/week views), daily burn-rate velocity, and top outflow rankings.
  - **PDF Financial Report Generator:** On-device compiling and rendering of custom date-range statements with native Android share/print integration.
  - **Hardware Biometric Security:** `local_auth` fingerprint/PIN guard with privacy blur overlays and background auto-lock timeout policies.
  - **Proactive Budget Notifications:** Push alerts at 80% & 100% threshold limits with category deep-linking.
  - **Multi-Category Transaction Splitting:** Split modal with atomic sum validation.
  - **'What-If' Savings Goal Simulator:** Scenario reduction sliders calculating accelerated goal completion.
  - **Data Management & Theming:** JSON database export/import, quote-safe CSV ingestion, Light/Dark/System theming.
- **Deliverables:**
  - [`main.pdf`](./CA1%20Mini%20Project:%2050%20%25%20Submission/main.pdf) (21 Pages, fully compiled with 6 vector PlantUML diagrams)
  - [`main.typ`](./CA1%20Mini%20Project:%2050%20%25%20Submission/main.typ) (Typst master source)
  - [`CA1_Mini_Project_50_Submission.md`](./CA1%20Mini%20Project:%2050%20%25%20Submission/CA1_Mini_Project_50_Submission.md) (Markdown reference)

---

### 3. [CA1 Mini Project: 75% Submission](./CA1%20Mini%20Project:%2075%20%25%20Submission/)
- **Source Snapshot:** Commit `2aac960` (*"feat: redesign bottom nav and enhance multiple feature screens"*, Jul 26, 2026)
- **Core Scope:** Full reactive stream architecture and real-world expense management:
  - **Reimbursement & IOUs Tracker:** Specialized bottom sheet (`ReimbursementTrackerSheet`) for managing shared expenses, roommate bills, and employer expense claims with settled/unsettled state transitions.
  - **Schema v5 Database Migration:** Drift database migration adding the `payee` column to `Transactions` with non-editable sender badges.
  - **StreamProvider Reactive Architecture:** Full migration of providers to continuous query streams for instant zero-latency UI re-rendering.
  - **On-Demand Manual SMS Ingestion:** Battery-efficient manual `Scan SMS Inbox` trigger with Android 13+ runtime permission handling and heuristic deduplication.
  - **Comprehensive Test Automation Suite:** Unit and regression tests covering duplicate transaction detection, bank SMS regex parsing, CSV statement import, and formatters.
  - **Material 3 UX Redesign:** Animated bottom navigation bar, high-contrast metric cards, and transaction row subtitle dates.
- **Deliverables:**
  - [`main.pdf`](./CA1%20Mini%20Project:%2075%20%25%20Submission/main.pdf) (17 Pages, fully compiled with 6 vector PlantUML diagrams)
  - [`main.typ`](./CA1%20Mini%20Project:%2075%20%25%20Submission/main.typ) (Typst master source)
  - [`CA1_Mini_Project_75_Submission.md`](./CA1%20Mini%20Project:%2075%20%25%20Submission/CA1_Mini_Project_75_Submission.md) (Markdown reference)

---

### 4. [CA1 Mini Project: 100% Final Submission](./CA1%20Mini%20Project:%20100%20%25%20Submission/)
- **Source Snapshot:** Commit `9eb1a7d` / `bf262ad` (*"perf(core): optimize RAM usage, animation delays, and configure release builds"*, Aug 14, 2026)
- **Core Scope:** Complete production-hardened release lifecycle:
  - **Production Memory & Battery Engineering:** Complete migration to `autoDispose` provider disposal, stream observer cleanup, and native Kotlin worker thread offloading (`SmsService.kt`).
  - **R8 Minification & Release Hardening:** Enabled full R8 bytecode optimization and ProGuard obfuscation rules (`proguard-rules.pro`) for SQLite and JNI bindings.
  - **Complete Offline Feature Matrix:** Multi-account ledger, split transactions, envelope budgeting with 80%/100% push alerts, What-If simulator, quartile heatmaps, on-device PDF generation, reimbursement tracker, and biometric auto-lock.
  - **Quality Assurance & Verification:** Zero static analysis issues (`flutter analyze`), unit and regression test suites passing, locked 60fps scrolling.
- **Deliverables:**
  - [`main.pdf`](./CA1%20Mini%20Project:%20100%20%25%20Submission/main.pdf) (16 Pages, fully compiled with 6 vector PlantUML diagrams)
  - [`main.typ`](./CA1%20Mini%20Project:%20100%20%25%20Submission/main.typ) (Typst master source)
  - [`CA1_Mini_Project_100_Submission.md`](./CA1%20Mini%20Project:%20100%20%25%20Submission/CA1_Mini_Project_100_Submission.md) (Markdown reference)
