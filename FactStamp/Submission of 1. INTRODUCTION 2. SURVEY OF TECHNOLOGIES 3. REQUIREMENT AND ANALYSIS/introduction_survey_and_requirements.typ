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
#show table.cell: set text(size: 10pt)
#show table.cell.where(y: 0): set text(size: 10pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  text(
    font: ("Fira Code", "DejaVu Sans Mono", "Courier New"),
    size: 9.5pt,
    it
  )
)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Chapters 1, 2, and 3 Submission", author: "Aadish")

// ==========================================
// Standalone Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[SUBMISSION OF CHAPTERS 1, 2, AND 3]
    #v(4pt)
    #text(size: 11pt)[*1. Introduction | 2. Survey of Technologies | 3. Requirements and Analysis*]
    #v(6pt)
    #text(size: 10.5pt)[Submitted in Partial Fulfilment of the Requirements for Course *JUSIT-DSCPR503*]\
    #text(size: 12pt, weight: "bold")[Bachelor of Science in Information Technology]\
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
// CHAPTER 1: INTRODUCTION
// =============================================================================
= Introduction

== Background
Over the past decade, India's telecommunications expansion and hyper-affordable cellular data plans have created one of the largest digitally connected populations in the world. Within this ecosystem, WhatsApp (Meta Platforms, Inc.) has emerged not merely as a conversational messaging tool, but as the de-facto operating infrastructure for primary communication, business networking, news dissemination, and civic coordination across more than 500 million active users.

However, the structural design of instant messaging platforms—specifically end-to-end encryption, automated address-book syncing, and low-friction 1-tap message forwarding—has inadvertently established an ideal medium for the propagation of digital misinformation. Millions of forwarded messages circulate daily through close-knit family chats, community associations, religious brotherhoods, and neighborhood societies. These forwards frequently carry fabricated medical treatments, manipulated political statements, communally inflammatory claims, and sophisticated financial phishing scams.

Because WhatsApp conversations occur within private, encrypted environments ("dark social"), search engine crawlers, regulatory monitors, and conventional public-web fact-checkers are completely blind to viral forwards until severe real-world consequences—such as public panic, vaccine hesitancy, or violent civil unrest—have already transpired. Traditional investigative fact-checking organizations (such as AltNews, BOOM Live, and Vishwas News) employ full-time investigative journalists who publish thorough, evidence-based articles. However, their centralized workflow creates a severe latency deficit: verifying a single claim requires several hours or days, whereas a sensational rumor achieves millions of impressions within a two-hour viral window. Furthermore, when a debunking article is finally published as a dense, text-heavy web link, recipients in private chat groups rarely open or re-forward it. 

*FactStamp* is developed to solve this socio-technical dilemma by providing a decentralized, community-driven fact-checking platform that combines automated client-side ingestion, rapid token-level duplicate detection, a three-verifier quorum consensus engine, and instantaneous client-side compilation of shareable, WhatsApp-optimized 1080#text[×]1080px fact-check PNG cards.

== Objectives
The primary engineering, algorithmic, and operational objectives of FactStamp are:
- *Frictionless Multimodal Ingestion:* Enable any user to submit unverified WhatsApp forwards as raw plaintext or screenshot images directly from mobile and desktop browsers without requiring mandatory initial registration.
- *Intelligent Token-Level Duplicate Suppression:* Implement a high-performance string normalization and Jaccard word-overlap similarity algorithm ($J >= 0.75$) to instantly identify previously verified claims and route users to certified verdicts in sub-second time.
- *Automated Client-Side OCR Pipeline:* Eliminate expensive cloud vision subscription APIs by implementing a client-side Optical Character Recognition (OCR) pipeline that extracts text from forwarded screenshots directly within browser memory.
- *Transparent Community Quorum Verification Queue:* Establish an open, democratic review queue requiring a minimum quorum of three ($N >= 3$) independent, authenticated verifiers before a claim can be formally certified.
- *Multi-Factor Weighted Consensus Engine:* Formulate an algorithmic scoring model that computes a composite confidence percentage ($C = 0.40 A + 0.30 R + 0.30 S$) by weighting raw voter agreement ratio ($A$), verifier historical reputation ($R$), and primary source domain credibility ($S$).
- *Sybil-Resistant Reputation Tracking:* Implement a tamper-resistant reputation tracking subsystem ($0$ to $100$ scale) that rewards verifiers who consistently align with certified consensus and programmatically locks claim submitters from reviewing their own submissions.
- *WhatsApp-Native Visual Artifact Generation:* Engineer a client-side rendering pipeline utilizing `html2canvas` with custom OKLCH color normalization to compile crisp, unalterable 1080#text[×]1080px square PNG fact-check cards designed specifically for WhatsApp image sharing.
- *Public Analytical Transparency:* Deliver an interactive analytics dashboard presenting weekly misinformation volume surges, category distributions (Health, Political, Financial, Religious), and verifier accuracy leaderboards.

== Purpose, Scope, and Applicability

=== Purpose
The fundamental purpose of FactStamp is to *reverse the direction of misinformation velocity*. By packaging certified fact-checks into high-impact, visual square stamps rather than obscure hyperlinks, FactStamp empowers everyday citizens to download the verified PNG stamp and forward it directly back into the specific WhatsApp groups where the falsehood originated.

=== Scope
The functional and technical scope of the system encompasses:
- Single-page responsive web application architecture developed in React 18, Vite 5, and Tailwind CSS v4.
- Direct integration with Google Cloud Firestore NoSQL storage operating under strict security rules.
- Automated client-side image compression (Canvas API) keeping screenshot base64 strings under 500 KB to guarantee a 100% free-tier serverless operating model.
- Client-side token extraction, stop-word elimination, and Jaccard similarity mathematical modeling.
- Real-time reactive notification engine alerting submitters when their claims achieve certified quorum.
- The system explicitly avoids modifying WhatsApp's underlying encrypted client application, ensuring strict legal and security compliance by operating purely through user-initiated uploads and downloads.

=== Applicability
FactStamp is applicable across multiple key stakeholder groups:
- *General WhatsApp Recipients:* Everyday citizens seeking an immediate, reliable verification mechanism before sharing suspicious messages with peers or family.
- *Student Fact-Checkers & Civic Volunteers:* Individuals who can apply digital literacy skills to research primary institutional sources and earn platform reputation.
- *Community Group Administrators:* Group leaders who require indisputable visual counter-evidence to squash inflammatory rumors within neighborhood or institutional forums.
- *Academics & Media Researchers:* Social scientists analyzing misinformation trends and category propagation patterns.

== Achievements
The development and benchmarking of the FactStamp platform achieved several critical milestones:
- *Sub-Second Duplicate Resolution:* Achieving an average execution latency of under $85 "ms"$ for Jaccard token comparisons against Firestore collections, shielding community verifiers from redundant workloads.
- *Zero Infrastructure Operational Expense:* Developing a completely serverless, zero-budget cloud architecture leveraging the Firebase Spark tier and Vercel edge deployment with zero reliance on paid external APIs.
- *Client-Side Canvas OKLCH Compatibility:* Authoring a proprietary pre-render DOM cloning patch resolving `html2canvas` color-parsing failures with modern Tailwind CSS v4 OKLCH color spaces.
- *High-Assurance Quorum Integrity:* Enforcing Firestore security rules that prevent self-verification and validate source citation formatting at the database transaction layer.

== Organisation of Report
This report is organized into seven comprehensive chapters:
- *Chapter 1: Introduction:* Establishes the research problem, project objectives, system scope, and high-level achievements.
- *Chapter 2: Survey of Technologies:* Delivers a comparative evaluation of modern web frameworks, NoSQL databases, OCR engines, styling libraries, and distributed consensus mechanisms.
- *Chapter 3: Requirements and Analysis:* Details the problem definition, formal IEEE Std 830-1998 functional/non-functional specifications, SDLC Scrum methodology, hardware/software constraints, and conceptual models (DFD Levels 0/1 and Use Case diagrams).
- *Chapter 4: System Design:* Outlines architectural modules, Firestore NoSQL schema structures, procedural logic algorithms, and UI wireframes.
- *Chapter 5: Implementation and Testing:* Documents coding details, asymptotic complexity benchmarks, and unit/integration test suites.
- *Chapter 6: Results and Discussion:* Presents test reports, validation benchmarks, and comprehensive user operating manuals.
- *Chapter 7: Conclusions:* Synthesizes key findings, architectural boundaries, future roadmap enhancements, and formal bibliography.

#pagebreak()

// =============================================================================
// CHAPTER 2: SURVEY OF TECHNOLOGIES
// =============================================================================
= Survey of Technologies

Building a high-throughput, community-driven verification platform requires evaluating multiple competing frontend, backend, analytical, and graphic rendering technologies. This chapter provides a rigorous comparative study justifying the final architectural choices for FactStamp.

== Web Architectures for Crowdsourced Fact-Checking
Traditional fact-checking platforms rely on monolithic, server-rendered architectures (e.g., WordPress or Django) hosting relational database instances (PostgreSQL/MySQL). While suitable for publishing static editorial articles, monolithic architectures exhibit severe limitations in crowdsourced, real-time verification environments:
- *High Server Maintenance Overhead:* Dedicated compute instances incur constant monthly hosting costs regardless of traffic.
- *Poor Real-Time Reactive Streaming:* Synchronizing multi-verifier voting states via standard HTTP polling creates heavy server load and high latency.
- *Centralized Ingestion Bottlenecks:* Handling concurrent image uploads and server-side OCR processing requires costly multi-core cloud workers.

FactStamp adopts a *Decoupled Serverless Single-Page Application (SPA)* model. By shifting OCR text extraction, image compression, and canvas graphics rendering directly into client browser runtimes and pairing them with a managed real-time NoSQL backend (Google Cloud Firestore), server compute costs are reduced to zero while client responsiveness is maximized.

== Client-Side Frameworks & Build Toolchains
Selecting the core UI library dictates long-term maintainability, developer ergonomics, and runtime execution speed:

#styled-table(
  columns: (1.1in, 1.2in, 1fr, 1.2in),
  headers: ("Framework", "Rendering Model", "Pros & Architectural Characteristics", "Limitations for FactStamp"),
  "React 18 + Vite 5", "Client-Side SPA (Virtual DOM)", "Sub-millisecond Hot Module Replacement (HMR); rich hooks ecosystem; optimized production bundling with ES modules.", "Requires strict state management for complex reactive stores.",
  "Next.js 14+ (App Router)", "Hybrid SSR / Server Actions", "Excellent initial page load SEO; server-side caching and streaming.", "Demands continuous Node.js runtime or serverless edge budget; unnecessary for private verification dashboard.",
  "Vue.js 3 (Vite)", "Progressive Reactive Framework", "Lightweight runtime; clean single-file component syntax; intuitive reactivity.", "Smaller third-party component ecosystem for specialized canvas graphics tools.",
  "Angular 17+", "Opinionated Full-Stack Enterprise", "Built-in dependency injection; comprehensive TypeScript integration.", "Excessive boilerplate and large bundle footprint, slowing mobile 4G network ingestion."
)

*Selection Justification:* *React 18 paired with Vite 5* was chosen because FactStamp's core value lies in client-side interactive workflows (submitting claims, real-time voting queues, DOM-to-PNG canvas compilation) where SSR delivers minimal advantage and adds server hosting complexity.

== Styling Engines & Design Systems
Modern web applications must balance rapid UI iteration with high-contrast accessibility:
- *Tailwind CSS v4:* A modern utility-first CSS engine built from scratch in Rust, featuring zero-configuration native CSS variables and modern OKLCH color spaces. It allows crafting the *Saffron Sleek* design system (warm cream surfaces `#FFFDF8`, deep saffron `#D97706`, ink-slate typography) with zero runtime styling overhead.
- *Bootstrap 5:* Rigid default styles requiring extensive overrides; lacks native OKLCH gamut support and granular theme token structures.
- *CSS Modules:* Isolates class names cleanly but requires substantial context switching and manual stylesheet maintenance.

== Cloud Databases & Real-Time Sync Engines
The verification queue demands sub-second synchronization across concurrent reviewers:

#styled-table(
  columns: (1.3in, 1fr, 1fr),
  headers: ("Database Engine", "Architectural Paradigm", "Evaluation for FactStamp"),
  "Cloud Firestore (Google Firebase)", "Managed Multi-Region NoSQL Document Store with Snapshot WebSockets", "Optimal choice: declarative security rules enforce client-side DB transactions without a middle-tier server; 50k daily free reads; instant real-time snapshot sync.",
  "Supabase (PostgreSQL)", "Open-source Relational DB with Realtime Extension & Row-Level Security", "Robust relational schema capabilities; however, free compute tier pauses after 7 days of inactivity, introducing cold-start latency.",
  "MongoDB Atlas", "Managed Distributed Document NoSQL Database", "Flexible JSON document storage; but lacks seamless native browser SDK WebSocket streaming with built-in client offline cache.",
  "Firebase Realtime DB", "Legacy Hierarchical JSON Tree Database", "Fast latency for small primitives; but query filtering and indexing across multiple claim categories are structurally primitive."
)

== Optical Character Recognition (OCR) Technologies
Extracting unformatted forward text from user-uploaded screenshots is a foundational capability:
- *Tesseract.js (Client-Side WebAssembly):* Compiles the open-source Tesseract C++ OCR engine into WebAssembly. Runs directly in the browser thread, providing zero API costs, zero data privacy leakage to third parties, and complete offline capability.
- *Google Cloud Vision API:* Exceptional multi-lingual character recognition accuracy; however, requires credit-card billing and charges after 1,000 monthly units, violating the zero-budget academic constraint.
- *AWS Textract:* Highly specialized for structured tables/forms; overkill and cost-prohibitive for conversational WhatsApp screenshot parsing.

== Graphic Compilation & Fact-Check Card Engines
Generating an unalterable, square PNG image directly on the user's mobile device:
- *`html2canvas`:* Renders standard HTML/CSS DOM trees into an HTML5 `<canvas>` element completely client-side. Allows dynamic layout changes, custom typography, and trust ring indicators using standard React JSX. A custom pre-render pass normalizes OKLCH color values to sRGB before rasterization.
- *Server-Side Puppeteer / Playwright:* Launches headless Chromium instances in cloud containers to screenshot HTML pages. While rendering is pixel-perfect, server resource consumption (RAM/CPU) is massive and introduces 2–4 second latency per export.
- *Native HTML5 Canvas Drawing API:* Highly performant; however, hand-coding responsive text wrapping, shadows, badges, and icon SVGs using imperative 2D context commands requires hundreds of fragile lines of code.

== Distributed Consensus & Quorum Models
FactStamp investigated diverse consensus models to balance verifier accountability against latency:
- *Pure Simple Majority:* Votes are counted strictly binary (e.g., 2 FALSE vs 1 TRUE = FALSE). Highly vulnerable to collusion, Sybil accounts, and casual inaccuracies.
- *Multi-Factor Weighted Quorum ($C = 0.40 A + 0.30 R + 0.30 S$):* Adopted by FactStamp. Weights majority vote by verifier historical track record and external source credibility, ensuring a novice cannot override an established, high-accuracy verifier citing official government gazettes.
- *Liquid Democracy / Delegation:* Users delegate voting power to domain experts. While philosophically attractive, it introduces excessive cognitive overhead for rapid, everyday fact-checking.
- *Blockchain Proof-of-Stake (PoS):* Incurs expensive gas fees and high transaction finality latencies (12s to 2min), making it totally unsuitable for rapid social media counter-messaging.

== Technology Stack Selection Summary
The selected technology architecture is synthesized below:

#styled-table(
  columns: (1.4in, 1.4in, 1fr),
  headers: ("Subsystem Layer", "Chosen Technology", "Core Decisive Factor"),
  "Client Frontend", "React 18 + Vite 5", "Sub-second HMR, rich declarative UI ecosystem, optimized production bundle.",
  "Styling & Tokens", "Tailwind CSS v4", "High-performance CSS engine with native OKLCH theme variables.",
  "Database & Rules", "Cloud Firestore", "Managed real-time document listeners, declarative security rules, zero server maintenance.",
  "Identity Management", "Firebase Authentication", "Turnkey Google OAuth and email sessions with zero security vulnerability risks.",
  "OCR Text Extraction", "Tesseract.js / Web OCR", "Client-side WebAssembly execution with zero paid API dependencies.",
  "Fact Card Generator", "html2canvas + OKLCH Patch", "Instantaneous client-side 1080×1080px PNG generation for WhatsApp sharing.",
  "Analytics Engine", "Recharts + Client Aggregates", "Declarative SVG charting for weekly misinformation distributions and trends."
)

#pagebreak()

// =============================================================================
// CHAPTER 3: REQUIREMENTS AND ANALYSIS
// =============================================================================
= Requirements and Analysis

== Problem Definition
The exponential spread of unverified forwarded messages across Indian private messaging networks represents a failure of traditional information verification architecture. The core factors contributing to this crisis include:
1. *The Dark Social Blindspot:* WhatsApp messages circulate within end-to-end encrypted chats. Unlike public posts on Twitter/X or Facebook, search engines cannot index forwards, and algorithmic classifiers cannot automatically flag toxic falsehoods.
2. *Asymmetric Information Propagation:* Misinformation is engineered to trigger immediate emotional arousal (fear, outrage, religious pride, medical hope). Research indicates false claims travel up to six times faster than verified facts.
3. *Cognitive Friction of Counter-Narratives:* When a recipient doubts a forwarded message, finding verified information requires navigating multiple external search engines, reading long investigative articles, and manually summarizing findings. Most users simply abandon the effort.
4. *Absence of a Viral Counter-Artifact:* Even when a user identifies a claim as fraudulent, posting a generic text rebuttal into a family group often triggers defensive hostility. A formal, authoritative, color-coded visual stamp provides objective proof that defuses interpersonal friction.

== Requirements Specification (IEEE Std 830-1998 Aligned)
In compliance with IEEE Std 830-1998 (Recommended Practice for Software Requirements Specifications), the functional, non-functional, and interface requirements are formally specified below.

=== Functional Requirements (System Features)

#styled-table(
  columns: (0.9in, 1.4in, 1fr, 0.7in),
  headers: ("Req ID", "Feature Name", "Detailed Requirement Specification", "Priority"),
  "REQ-1", "Authentication & Role Management", "The system shall authenticate users via Firebase Email/Password and Google OAuth 2.0. The system shall maintain three distinct authorization tiers: Unauthenticated Submitter, Registered Verifier, and Administrator. Users shall view their verification history and reputation score.", "High",
  "REQ-2", "Multimodal Claim Ingestion", "The system shall accept claim submissions as plaintext (up to 2,000 characters) or screenshot image uploads (JPEG/PNG, max 5 MB). Uploaded images shall be compressed client-side to max 1200px and converted to base64 strings under 500 KB.", "High",
  "REQ-3", "Automated Client OCR Extraction", "The system shall automatically extract embedded forward text from uploaded screenshots using Tesseract.js WebAssembly. Extracted text shall be presented to the user for confirmation and editing before duplicate comparison.", "High",
  "REQ-4", "Jaccard Duplicate Detection Engine", "The system shall normalize incoming claim text and compute token-level Jaccard similarity against all existing claims. If similarity $J(A, B) >= 0.75$, the system shall prevent redundant submission and route the user to the existing claim.", "High",
  "REQ-5", "Quorum Verification Queue", "The system shall enqueue unique claims into a public verification registry. The system shall require a minimum of three ($N >= 3$) independent verifications before allowing consensus calculation. Verifiers shall submit a verdict, credible source URL, and explanation.", "High",
  "REQ-6", "Weighted Consensus Calculation", "Upon reaching quorum ($N >= 3$), the system shall execute the multi-factor consensus formula: $C = 0.40 A + 0.30 R + 0.30 S$. The system shall categorize the claim as TRUE, FALSE, MISLEADING, or UNVERIFIABLE.", "High",
  "REQ-7", "Fact-Check Card Generator", "The system shall dynamically generate a 1080×1080px square PNG card displaying claim text, verdict stamp, confidence ring, verifier count, source domains, and verification date using html2canvas with OKLCH-to-sRGB translation.", "High",
  "REQ-8", "Analytics Dashboard & Reports", "The system shall compute weekly misinformation metrics, category volume breakdowns (Health, Political, Financial, Religious), most debunked claims, and top verifier leaderboards.", "Medium",
  "REQ-9", "Anti-Sybil Security Locks", "The system shall enforce security rules prohibiting claim submitters from voting on their own claims. Verifiers shall be restricted to a single immutable vote per claim.", "High",
  "REQ-10", "Reactive Real-Time Notifications", "The system shall maintain Firestore snapshot listeners alerting users in real-time when their submitted claims reach quorum or when their verifier reputation score updates.", "Medium"
)

=== Non-Functional Requirements (Quality Attributes)
- *Performance Requirements (NFR-1):* Duplicate similarity computation across 5,000 indexed claims shall execute in under $150 "ms"$ on standard 4G mobile networks. Client-side fact-check card generation via `html2canvas` shall complete in under $800 "ms"$.
- *Security Requirements (NFR-2):* All database interactions shall be governed by declarative Cloud Firestore security rules enforcing user ownership and data shape validation. Client inputs shall be sanitized against Cross-Site Scripting (XSS).
- *Reliability & Availability (NFR-3):* The serverless database architecture shall guarantee $99.95\%$ platform uptime with multi-region replication. Claims submitted offline shall queue locally via Firestore offline cache.
- *Usability & Accessibility (NFR-4):* The user interface shall adhere to Accessible Perceptual Contrast Algorithm (APCA) contrast standards, achieving high readability on small mobile screens in direct outdoor sunlight.
- *Portability Requirements (NFR-5):* The web application shall render flawlessly across modern desktop, tablet, and mobile browsers (Chrome 100+, Firefox 105+, Safari 15.4+, Edge).

=== External Interface Requirements
- *User Interfaces:* Clean single-page interface using the Saffron Sleek theme; mobile-first bottom navigation bar; one-click "Download Card" button; clear color-coded verdict pills.
- *Software Interfaces:* Firebase Authentication SDK v10.x, Cloud Firestore Web SDK v10.x, Tesseract.js v5.x, html2canvas v1.4.x, Recharts v2.x.
- *Communications Interfaces:* Secure HTTPS/TLS 1.3 encryption for all web transport; WebSocket connections for Firestore reactive real-time snapshot listeners.

== Planning and Scheduling

=== SDLC Process Model Justification
As established in our software engineering methodology analysis, FactStamp selected the *Agile Scrum* process model over traditional predictive lifecycles (Waterfall, V-Model, Spiral):
- *Waterfall Incompatibility:* Waterfall mandates fixed upfront requirements. However, mobile user behaviors when handling forwarded messages and unexpected color rendering issues in modern CSS engines required rapid, iterative prototyping.
- *Scrum Alignment:* Operating in 2-week timeboxed sprints allowed immediate usability testing with student groups, iterative tuning of the Jaccard similarity threshold ($0.75$), and rapid refactoring of the consensus weighting formula.

=== Work Breakdown Structure (WBS)
1. *Phase 1: Project Conception & Requirements (Sprint 1)*
   - 1.1 Feasibility analysis, IEEE 830 SRS drafting, and technology survey.
   - 1.2 Firebase environment initialization and React-Vite project scaffolding.
2. *Phase 2: Ingestion & Duplicate Detection Subsystem (Sprint 2)*
   - 2.1 Multimodal submission forms (plaintext and image drag-and-drop).
   - 2.2 Client-side canvas image compression and Tesseract.js OCR integration.
   - 2.3 Text normalization pipeline and Jaccard similarity algorithm implementation.
3. *Phase 3: Verification Queue & Consensus Engine (Sprint 3)*
   - 3.1 Public quorum verification queue UI and voting forms.
   - 3.2 Multi-factor weighted consensus calculator and reputation scoring algorithm.
   - 3.3 Firestore security rules enforcement and anti-Sybil self-verification locks.
4. *Phase 4: Graphic Export, Analytics & Evaluation (Sprint 4)*
   - 4.1 1080×1080px Fact-check PNG card generator with OKLCH color patch.
   - 4.2 Trending misinformation dashboard, category analytics, and notifications.
   - 4.3 End-to-end integration testing, APCA contrast audits, and Black Book documentation.

=== Four-Month Milestone Implementation Timeline (Gantt Schedule)

#styled-table(
  columns: (1.1in, 1.2in, 1fr, 1.1in),
  headers: ("Sprint / Period", "Development Phase", "Core Engineering Activities & Deliverables", "Target Status"),
  "Sprint 1\n(June 2026)", "Architecture &\nIngestion Layer", "Project scaffolding; Firebase Auth configuration; claim submission forms; canvas image compression; Tesseract.js OCR integration; Jaccard duplicate detection algorithm.", "Completed",
  "Sprint 2\n(July 2026)", "Quorum Queue &\nConsensus Engine", "Verification queue UI; independent verifier review forms; multi-factor consensus formula; verifier reputation model; Firestore security rules and anti-Sybil locks.", "Completed",
  "Sprint 3\n(August 2026)", "Card Generator &\nAnalytics Subsystem", "html2canvas 1080×1080px card generator; OKLCH-to-sRGB pre-render transformer; weekly misinformation analytics dashboard; real-time notification bells.", "Completed",
  "Sprint 4\n(Sept 2026)", "Security Hardening\n& Final Evaluation", "Anti-Sybil attack penetration testing; cross-browser mobile verification; comprehensive IEEE 830 documentation; university viva examination.", "Underway"
)

== Software and Hardware Requirements

=== Client Environment Requirements
- *Hardware Architecture:* Dual-core 64-bit processor (ARM or x86_64), 1.8 GHz or faster.
- *Memory (RAM):* Minimum 2 GB (4 GB recommended for in-browser OCR processing).
- *Storage:* Minimum 200 MB free browser cache space.
- *Display Resolution:* Responsive from 360#text[×]640 (smartphones) up to 1920#text[×]1080 (desktops).
- *Web Browser:* Google Chrome 100+, Mozilla Firefox 105+, Apple Safari 15.4+, or Microsoft Edge with WebGL support.

=== Server & Cloud Infrastructure
- *Cloud Host:* Vercel Global Edge Network / Nginx container.
- *Cloud Database:* Google Cloud Firestore (Managed Multi-Region NoSQL).
- *Identity Services:* Firebase Authentication (OAuth 2.0 Identity Platform).
- *Bandwidth:* Standard broadband or 4G/5G mobile cellular network.

=== Development Environment
- *Runtime & Package Manager:* Node.js LTS v20.x and `npm` v10.x.
- *Typesetting Engine:* Typst v0.15.1 typesetting binary.
- *Diagramming Engines:* Graphviz `dot` v16.0.0 and PlantUML (OpenJDK 21 JVM).
- *Source Control:* Git v2.40+ and GitHub repository hosting.

#pagebreak()

== Preliminary Product Description
FactStamp is a responsive, web-based verification platform that bridges the gap between private encrypted messaging networks and crowdsourced accountability:
- *System Perspective:* Autonomous, serverless cloud platform operating directly between individual WhatsApp users, community verifiers, and private chat groups.
- *User Classes & Personas:*
  1. *Public Submitter:* An unauthenticated or registered user who receives a suspicious forward, pastes the text or uploads a screenshot, and downloads the verified fact card.
  2. *Community Verifier:* An authenticated user who examines unverified claims in the queue, performs web research, and submits structured verdicts with primary source links.
  3. *Administrator:* A privileged user who monitors disputed claims, audits outlier votes, and inspects weekly category analytics.
- *Operating Environment:* 100% cloud-hosted on high-availability edge networks accessible from any device without native app installation.
- *Design Constraints:* Zero-budget infrastructure requirement; compliance with browser memory boundaries during OCR extraction; unalterable square graphic aspect ratio (1:1) for WhatsApp preview tiles.

#pagebreak()

== Conceptual Models

=== Data Flow Diagrams (DFDs)
Data Flow Diagrams model the procedural flow of information across external entities, processes, and persistent data stores.

==== Context Level 0 DFD
The Level 0 Context Diagram establishes the overarching system boundary, identifying how Public Submitters, Community Verifiers, Platform Administrators, and external WhatsApp chat groups interact with the central FactStamp engine:

#v(8pt)
#responsive-image("attachments/dfd_level_0.svg", width: 85%)

#pagebreak()

==== System Level 1 DFD
The Level 1 Data Flow Diagram decomposes the system into six primary operational processes, mapping data flows across Firestore collections (`claims`, `verifications`, `users`):

#v(8pt)
#responsive-image("attachments/dfd_level_1.svg", width: 88%)

#pagebreak()

=== UML Use Case Diagram
The Use Case Diagram formalizes system boundaries, actor roles, and functional interactions across the FactStamp platform:

#v(8pt)
#responsive-image("attachments/use_case_diagram.svg", width: 90%)

#pagebreak()

// ==========================================
// References Section
// ==========================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
3. Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
4. Garimella, K., & Eckles, D., *"Images and Misinformation in Political Groups: Evidence from WhatsApp in India,"* in _Proc. ACM Hum.-Comput. Interact._, CSCW, 2020.
5. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
6. Google Firebase Documentation, *"Cloud Firestore Security Rules & Realtime Snapshot Listeners,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
7. Nikolov, N., *"html2canvas: Screenshots with JavaScript,"* Open-Source Software Specification, 2023. [Online]. Available: `https://html2canvas.hertzen.com`.
8. Pressman, R. S., & Maxim, B. R., *"Software Engineering: A Practitioner's Approach,"* 9th ed., McGraw-Hill Education, 2020.
