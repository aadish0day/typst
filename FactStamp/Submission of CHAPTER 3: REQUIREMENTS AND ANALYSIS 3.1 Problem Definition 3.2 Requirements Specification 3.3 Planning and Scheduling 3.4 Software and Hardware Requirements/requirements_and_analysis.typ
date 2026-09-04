// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // 1.5in left margin for single-sided binding
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border for Black Books and Assignments
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

// Cross-Platform Font Fallbacks (Windows/Mac/Linux CI compatibility)
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

// Global Table Cell Styling
#show table.cell: set text(size: 9pt)
#show table.cell.where(y: 0): set text(size: 9pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  text(
    font: ("DejaVu Sans Mono", "Liberation Mono", "Courier New"),
    size: 9pt,
    it
  )
)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 4.5pt, y: 4pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 9pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Chapter 3: Requirements and Analysis", author: "Aadish")

// ==========================================
// Standalone Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[ACADEMIC COURSE SUBMISSION]
    #v(4pt)
    #text(size: 12pt, weight: "bold")[CHAPTER 3: REQUIREMENTS AND ANALYSIS]
    #v(2pt)
    #text(size: 10.5pt)[*3.1 Problem Definition | 3.2 Requirements Specification*]\
    #text(size: 10.5pt)[*3.3 Planning and Scheduling (PERT Chart) | 3.4 Software & Hardware Requirements*]
    #v(6pt)
    #text(size: 10pt)[Submitted in Partial Fulfilment of the Requirements for Course *JUSIT-DSCPR503*]\
    #text(size: 11.5pt, weight: "bold")[Bachelor of Science in Information Technology]\
    #v(10pt)
    #text(size: 10pt)[*Candidate:* Aadish (UID: 2023IT001)]\
    #text(size: 10pt)[*Department of Information Technology*]\
    #text(size: 11pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai – 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025–2026]
  ]
  #v(14pt)
]

// Dedicated Table of Contents Page
#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[TABLE OF CONTENTS]
]
#v(12pt)

#outline(
  title: none,
  indent: 1.5em,
  depth: 2
)

#pagebreak()

// =============================================================================
// CHAPTER 3: REQUIREMENTS AND ANALYSIS
// =============================================================================
= Requirements and Analysis

== Problem Definition
The exponential expansion of digital mobile communication in India has elevated WhatsApp to the undisputed primary medium for interpersonal, community, and civic discourse. However, this ubiquitous adoption is accompanied by a severe, systemic crisis: the rapid, unchecked contagion of digital misinformation across end-to-end encrypted messaging channels.

Current institutional approaches to fact-checking exhibit five fundamental socio-technical failures:

1. *Structural Blindspot of Closed Networks:* Unlike open social media platforms (such as X/Twitter or Facebook) where public search crawlers, computational algorithms, and academic researchers can detect viral hoaxes early, WhatsApp operates behind closed, encrypted peer-to-peer and group protocols. Malicious or inaccurate forwards circulate unseen in "dark social" networks until real-world consequences—such as financial scams, medical self-harm, or communal tensions—have already transpired.

2. *Editorial Latency Deficit:* Conventional journalistic fact-checking organizations (e.g., AltNews, BOOM Live, Vishwas News) rely on centralized investigative newsrooms. From initial manual discovery to primary source interviews, official record verification, and editorial sign-off, the investigative lifecycle typically requires 24 to 72 hours. In stark contrast, empirical diffusion research (Vosoughi et al., _Science_, 2018) demonstrates that emotionally charged falsehoods achieve peak viral penetration within 2 to 4 hours of release.

3. *Cognitive and Social Friction of Rebuttals:* When an informed group member identifies a fraudulent forward, sharing a lengthy, text-heavy journalistic web URL into a family, neighborhood, or alumni group often creates social defensiveness. Senders perceive external web links as personal accusations of gullibility. Furthermore, empirical engagement studies reveal that group members rarely click off-platform links to read multi-page journalistic articles.

4. *Operational Ingestion Friction:* Everyday citizens lack the digital tools to quickly verify forwarded claims. Copying complex multilingual text from forwarded messages or extracting text from deceptive infographic screenshots presents a substantial barrier for non-technical users.

5. *Vulnerability to Sybil Manipulation:* Existing crowdsourced rating experiments frequently collapse under bot manipulation, coordinated partisan brigading, or simple majority tyranny, wherein organized factions easily overwhelm factual truth.

*Formal Problem Statement:* There is an urgent requirement for a decentralized, privacy-preserving, zero-cost misinformation counter-measure that enables instant multimodal claim ingestion, eliminates verification delays via community quorum consensus, and compiles certified verdicts into shareable, high-impact square visual fact cards directly distributable within WhatsApp chats.

#pagebreak()

== Requirements Specification
In accordance with IEEE Std 830-1998 (*Recommended Practice for Software Requirements Specifications*), the system requirements are partitioned into unambiguous Functional Requirements (FR) and Non-Functional Requirements (NFR).

=== Functional Requirements (FR)

#styled-table(
  columns: (0.9in, 1.4in, 1fr),
  headers: ("Req ID", "Requirement Name", "Functional Specification & Acceptance Criteria"),
  "REQ-1", "Multimodal Claim Ingestion", "The system shall permit unauthenticated public users to submit suspicious WhatsApp claims either as raw plaintext (up to 2,000 characters) or as image uploads (JPEG/PNG, up to 5 MB) without requiring account creation.",
  "REQ-2", "Client-Side WASM OCR Extraction", "The system shall execute an in-browser WebAssembly OCR pipeline via Tesseract.js to extract text from submitted screenshots directly within client RAM, eliminating external server API calls and preserving complete user privacy.",
  "REQ-3", "Real-Time Jaccard Duplicate Suppression", "The system shall normalize incoming claim text (lowercasing, punctuation stripping, stop-word elimination) and compute the Jaccard similarity index: $J(A, B) = frac(|S_A inter S_B|, |S_A union S_B|)$. If $J(A, B) >= 0.75$, the user shall be immediately redirected to the existing certified verdict in under 100 ms.",
  "REQ-4", "Quorum Verification Queue", "The system shall enqueue unique claims into a public verification registry. Authenticated verifiers can inspect pending claims, select a verdict candidate (*TRUE*, *FALSE*, *MISLEADING*, *UNVERIFIABLE*), provide an authoritative citation URL, and submit a concise factual rationale.",
  "REQ-5", "Multi-Factor Weighted Consensus Engine", "The system shall mandate a minimum quorum of three ($N >= 3$) independent verifications before computing composite consensus confidence: $C = 0.40 A + 0.30 R + 0.30 S$. Claims with $C >= 70\\%$ shall be marked as *CERTIFIED*; claims below $70\\%$ shall remain open or expire as *CONTESTED* after 7 days.",
  "REQ-6", "Anti-Sybil Reputation Engine", "The system shall initialize verifier reputation at 50 points ($R_0 = 50$, range $[0, 100]$). Verifiers aligning with certified consensus receive $+2$ points; divergent outlier votes receive a $-3$ point penalty. Database rules shall strictly prevent users from verifying their own submitted claims.",
  "REQ-7", "1080×1080px Fact Card Generator", "The system shall render a client-side visual fact card via `html-to-image` featuring a prominent color banner, claim summary, circular SVG Trust Ring, domain citation badge, and verification timestamp with 100% native Tailwind CSS v4 OKLCH color support.",
  "REQ-8", "Misinformation Analytics Dashboard", "The system shall provide an interactive analytics portal visualizing 7-day submission volume trends, category distribution (Health, Politics, Finance, Scams), and verified accuracy leaderboards using Recharts.",
  "REQ-9", "Role-Based Access Control (RBAC)", "The system shall enforce three user roles: *Submitter* (unauthenticated, submit/download only), *Verifier* (authenticated, review/vote/profile), and *Admin* (administrative monitoring and dispute management).",
  "REQ-10", "Security Inactivity Session Lock", "The client auth wrapper shall monitor user activity and invalidate active sessions following 30 minutes of continuous idle time to defend against device borrowing and session hijacking."
)

#pagebreak()

=== Non-Functional Requirements (NFR)

#styled-table(
  columns: (0.9in, 1.4in, 1fr),
  headers: ("Req ID", "Quality Attribute", "Engineering Specification & Evaluation Benchmark"),
  "NFR-1", "Performance & Latency", "Initial Single-Page Application bundle shall compile to under 250 KB gzipped. In-memory Jaccard duplicate searches across cached records shall execute in under 100 ms. In-browser OCR extraction on mobile devices shall complete within 2.5 seconds.",
  "NFR-2", "Privacy & Data Confidentiality", "Claim submissions and screenshot images shall be processed entirely within client browser memory. No private conversational metadata, phone numbers, or IP logs shall be stored in persistent cloud databases.",
  "NFR-3", "Security & Database Integrity", "Declarative Cloud Firestore Security Rules shall reject any unauthenticated modification of reputation scores, verification tallies, or administrative privilege flags at the database boundary.",
  "NFR-4", "Usability & Accessibility (APCA)", "The UI shall adhere to the *Saffron Sleek* design system with accessible contrast compliance under APCA standards. All controls shall support 48×48px mobile touch targets and render responsively from 320px to 4K displays.",
  "NFR-5", "Operational Reliability & Availability", "The platform shall leverage Vercel's Global Edge Network and Google Cloud Firestore multi-region clusters, targeting 99.9% uptime with automatic IndexedDB offline caching.",
  "NFR-6", "Zero-Cost Operational Sustainability", "The system architecture shall operate 100% within the free tiers of Firebase (Spark Tier) and Vercel Edge Hosting, incurring zero recurring infrastructure costs."
)

== Planning and Scheduling
Project planning and scheduling followed the Agile Scrum framework, broken down into sequential work packages and monitored using the Program Evaluation and Review Technique (PERT) and Critical Path Method (CPM).

=== Work Breakdown Structure (WBS)
The engineering lifecycle is decomposed into 14 discrete, measurable work activities ($T_1$ to $T_{14}$):
- *$T_1$: Problem Definition & Stakeholder Requirements Analysis* (Define IEEE 830 SRS, constraints, and scope).
- *$T_2$: Technology Survey & Comparative Architecture Evaluation* (Evaluate React, Vite, Firestore, OCR, and Canvas engines).
- *$T_3$: System Architecture & Security Rules Design* (Design SPA decoupled model, schema, and RBAC rules).
- *$T_4$: Authentication & Verifier Profile Subsystem* (Implement Firebase Auth, session timeouts, and reputation models).
- *$T_5$: Client-Side Canvas Image Compression & WASM OCR Pipeline* (Integrate Tesseract.js and HTML5 Canvas resizer).
- *$T_6$: Tokenization & Jaccard Duplicate Detection Engine* (Build string normalizer and $J >= 0.75$ duplicate index).
- *$T_7$: Quorum Verification Queue & Real-Time Sync Subsystem* (Build verification queue with Firestore `onSnapshot`).
- *$T_8$: Multi-Factor Weighted Quorum Consensus Engine* (Implement consensus scoring $C = 0.40A + 0.30R + 0.30S$).
- *$T_9$: Dynamic 1080×1080px Fact Card Generator* (Build `html-to-image` native SVG `<foreignObject>` exporter).
- *$T_{10}$: Misinformation Analytics Dashboard & Trend Visualizer* (Implement 7-day rolling charts with Recharts).
- *$T_{11}$: Integration & End-to-End System Testing* (Execute automated unit tests, cross-browser validation, and security audits).
- *$T_{12}$: User Acceptance Testing (UAT) & Civic Verifier Trials* (Conduct pilot verification with student peer groups).
- *$T_{13}$: Serverless Cloud Deployment & Performance Optimization* (Deploy on Vercel Edge with production bundling).
- *$T_{14}$: Final Documentation & Dissertation Preparation* (Compile academic dissertation, user manual, and reports).

#pagebreak()

=== Probabilistic 3-Point Duration Estimation (PERT Formulation)
To manage schedule uncertainties inherent in cutting-edge client-side WebAssembly and DOM-to-canvas rendering, activity durations were estimated using PERT three-point estimates:
$ T_E = frac(O + 4M + P, 6) wide quad "and" wide quad sigma^2 = (frac(P - O, 6))^2 $
Where $O$ is the Optimistic duration, $M$ is the Most Likely duration, and $P$ is the Pessimistic duration in work days.

=== PERT Computational Schedule Analysis
The forward pass (Early Start $E S$, Early Finish $E F$) and backward pass (Late Start $L S$, Late Finish $L F$) establish the total float / slack ($S = L S - E S = L F - E F$) for each task:

#styled-table(
  columns: (0.35in, 0.45in, 0.28in, 0.28in, 0.28in, 0.38in, 0.38in, 0.38in, 0.38in, 0.38in, 0.38in, 0.35in, 0.45in),
  headers: ("Task", "Pred.", "O", "M", "P", "T_E", "Var", "ES", "EF", "LS", "LF", "Slack", "Critical"),
  "T1", "None", "5", "7", "15", "8.0", "2.78", "0.0", "8.0", "0.0", "8.0", "0.0", "Yes",
  "T2", "T1", "4", "6", "14", "7.0", "2.78", "8.0", "15.0", "10.0", "17.0", "2.0", "No",
  "T3", "T1", "6", "9", "12", "9.0", "1.00", "8.0", "17.0", "8.0", "17.0", "0.0", "Yes",
  "T4", "T3", "5", "8", "11", "8.0", "1.00", "17.0", "25.0", "21.0", "29.0", "4.0", "No",
  "T5", "T3", "8", "12", "16", "12.0", "1.78", "17.0", "29.0", "17.0", "29.0", "0.0", "Yes",
  "T6", "T5", "6", "8", "16", "9.0", "2.78", "29.0", "38.0", "29.0", "38.0", "0.0", "Yes",
  "T7", "T4, T6", "7", "10", "19", "11.0", "4.00", "38.0", "49.0", "38.0", "49.0", "0.0", "Yes",
  "T8", "T7", "5", "8", "11", "8.0", "1.00", "49.0", "57.0", "49.0", "57.0", "0.0", "Yes",
  "T9", "T8", "6", "10", "14", "10.0", "1.78", "57.0", "67.0", "57.0", "67.0", "0.0", "Yes",
  "T10", "T9", "5", "7", "15", "8.0", "2.78", "67.0", "75.0", "67.0", "75.0", "0.0", "Yes",
  "T11", "T10", "6", "9", "12", "9.0", "1.00", "75.0", "84.0", "75.0", "84.0", "0.0", "Yes",
  "T12", "T11", "4", "6", "14", "7.0", "2.78", "84.0", "91.0", "87.0", "94.0", "3.0", "No",
  "T13", "T11", "6", "10", "14", "10.0", "1.78", "84.0", "94.0", "84.0", "94.0", "0.0", "Yes",
  "T14", "T12, T13", "5", "7", "9", "7.0", "0.44", "94.0", "101.0", "94.0", "101.0", "0.0", "Yes"
)

=== Critical Path Determination
The Critical Path comprises tasks possessing exactly zero total float ($S = 0$):
$ "Critical Path" = T_1 arrow.r T_3 arrow.r T_5 arrow.r T_6 arrow.r T_7 arrow.r T_8 arrow.r T_9 arrow.r T_10 arrow.r T_11 arrow.r T_13 arrow.r T_14 $
- *Total Expected Duration ($T_E$):* $8.0 + 9.0 + 12.0 + 9.0 + 11.0 + 8.0 + 10.0 + 8.0 + 9.0 + 10.0 + 7.0 = bold(101.0 " working days")$ (~14.4 weeks / 3.5 academic months).
- *Project Variance ($sigma^2_P$):* $2.78 + 1.00 + 1.78 + 2.78 + 4.00 + 1.00 + 1.78 + 2.78 + 1.00 + 1.78 + 0.44 = bold(21.12 " days"^2)$.
- *Standard Deviation ($sigma_P$):* $sqrt(21.12) approx bold(4.60 " days")$.

#pagebreak()

=== Activity-on-Node PERT Network Diagram
The task dependency graph below highlights the critical path and parallel engineering streams:

#v(6pt)
#responsive-image("attachments/pert_chart.svg", width: 92%, max-height: 580pt)

#pagebreak()

=== Project Milestones & Agile Release Timeline
The 101-day development roadmap was organized into four sequential 2-week Sprint milestones:

#styled-table(
  columns: (1.1in, 1.2in, 1.4in, 1.7in),
  headers: ("Milestone Phase", "Calendar Window", "Core Focus & Epics", "Key Verifiable Deliverables"),
  "Phase 1: Foundation & Ingestion", "Weeks 1 – 4 (Days 1–29)", "Requirements, Architecture, Canvas Resizing, and Tesseract.js OCR", "IEEE 830 SRS Document; client-side image compression; operational WebAssembly OCR pipeline.",
  "Phase 2: Detection & Quorum", "Weeks 5 – 8 (Days 30–57)", "Jaccard String Engine, Verification Queue, and Consensus Model", "Sub-100ms duplicate lookup engine; real-time Firestore verification queue; consensus algorithm.",
  "Phase 3: Graphics & Analytics", "Weeks 9 – 12 (Days 58–84)", "Fact Card Generator, OKLCH Patch, and Recharts Dashboard", "1080×1080px square PNG export transformer; 7-day rolling category trend visualizer.",
  "Phase 4: Hardening & Release", "Weeks 13 – 15 (Days 85–101)", "Security Rules Audit, UAT Trials, Vercel Edge CDN Deployment", "Final production deployment on Vercel; zero security flaws; verified academic dissertation."
)

#pagebreak()

== Software and Hardware Requirements

=== Hardware Requirements
The system is partitioned into Developer Workstation specifications and Target End-User Device requirements:

#styled-table(
  columns: (1.2in, 1.8in, 1fr),
  headers: ("Hardware Tier", "Minimum Configuration", "Recommended Configuration"),
  "Developer Workstation", "Intel Core i5 / AMD Ryzen 5 (4 Cores), 8 GB DDR4 RAM, 256 GB NVMe SSD, 1080p Display.", "Intel Core i7 / AMD Ryzen 7 (8 Cores), 16 GB+ DDR4/DDR5 RAM, 512 GB NVMe SSD, Dual 1080p Displays.",
  "Target End-User (Mobile)", "Quad-Core ARM CPU (1.4 GHz), 2 GB RAM, 3G/4G Connectivity, 720×1280 Touchscreen Display.", "Octa-Core ARM CPU (2.0 GHz+), 4 GB+ RAM, 4G/5G/Wi-Fi, 1080×2400 AMOLED Display.",
  "Target End-User (Desktop)", "Dual-Core x86_64 CPU, 4 GB RAM, Broadband Internet, 1366×768 Screen.", "Quad-Core x86_64 CPU, 8 GB RAM, High-Speed Broadband, 1920×1080 Screen."
)

=== Software Requirements & Build Toolchain

#styled-table(
  columns: (1.4in, 1.4in, 1fr),
  headers: ("Software Category", "Environment / Package", "Version & Architectural Role in FactStamp"),
  "Operating System", "Linux (Arch / Ubuntu) / Windows / macOS", "Primary development conducted on Arch Linux (Kernel 6.12+); cross-platform web delivery.",
  "Runtime & Package Mgr", "Node.js & npm / pnpm", "Node.js v20+ LTS runtime; pnpm for fast, deterministic dependency resolution.",
  "Frontend Framework", "React 18 & TypeScript 5", "React 18.3 with TypeScript for static type-safety and robust compile-time interfaces.",
  "Build Toolchain", "Vite 5 (esbuild & Rollup)", "Sub-50ms Hot Module Replacement (HMR) and optimized production chunk splitting.",
  "Styling & UI Library", "Tailwind CSS v4 & Lucide Icons", "Rust-based Oxide compiler; custom *Saffron Sleek* color tokens and accessible UI icons.",
  "Computer Vision & Canvas", "Tesseract.js v5 & html-to-image", "WebAssembly client OCR engine and native SVG foreignObject 1080×1080px rasterizer.",
  "Cloud BaaS & SDK", "Firebase JS SDK v10+", "Firebase Authentication and Cloud Firestore client libraries with real-time listeners.",
  "Document Compilation", "Typst v0.15+", "High-performance academic typesetter for official university dissertation deliverables."
)

#pagebreak()

=== Cloud Infrastructure & Free-Tier Quota Architecture
FactStamp is engineered to operate sustainably on 100% serverless free-tier cloud infrastructure, ensuring zero monthly operating expenses:

#styled-table(
  columns: (1.3in, 1.3in, 1.4in, 1.4in),
  headers: ("Cloud Service", "Free-Tier Allocation", "FactStamp Daily Utilization", "Operational Safety Headroom"),
  "Google Cloud Firestore", "50,000 document reads/day;\n20,000 document writes/day;\n1 GB persistent storage.", "Avg. 1,200 reads/day;\nAvg. 180 writes/day;\n~15 MB database size.", "*97.6% unused read headroom*;\n*99.1% unused write headroom*.",
  "Firebase Authentication", "Unlimited email/password users;\n50,000 monthly active users (MAU) for Google OAuth.", "Approx. 150 active verifiers;\n~300 registered accounts.", "*99.4% unused authentication quota*.",
  "Vercel Edge Hosting", "100 GB monthly bandwidth;\nUnlimited serverless deployments;\nAutomatic TLS 1.3 certificates.", "Approx. 4.2 GB monthly bandwidth\n(client bundles cached at edge).", "*95.8% unused bandwidth headroom*."
)

#pagebreak()

// ==========================================
// REFERENCES
// ==========================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
3. Kerzner, H., *"Project Management: A Systems Approach to Planning, Scheduling, and Controlling,"* 13th ed., John Wiley & Sons, 2022.
4. Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
5. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
6. Google Firebase Documentation, *"Cloud Firestore Security Rules & Quotas,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
7. Pressman, R. S., & Maxim, B. R., *"Software Engineering: A Practitioner's Approach,"* 9th ed., McGraw-Hill Education, 2020.
