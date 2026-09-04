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

#set document(title: "FactStamp - Project Synopsis", author: "Aadish")

// ==========================================
// Standalone Title & Proforma Header Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 14pt, weight: "bold")[PROJECT SYNOPSIS]
    #v(6pt)
    #text(size: 10.5pt)[Submitted in Partial Fulfilment of the Requirements for the Degree of]\
    #text(size: 12pt, weight: "bold")[Bachelor of Science in Information Technology]\
    #text(size: 10.5pt)[Course Code: *JUSIT-DSCPR503* (Semester V / VI)]
    #v(10pt)
    #text(size: 10pt)[*Department of Information Technology*]\
    #text(size: 11pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai – 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025–2026]
  ]
  #v(12pt)
]

// ==========================================
// Project Proposal Proforma Metadata Table
// ==========================================
#styled-table(
  columns: (1.5in, 1fr),
  headers: ("Attribute", "Project Specification Details"),
  "Project Title", "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker",
  "Candidate Name", "Aadish",
  "Candidate UID", "2023IT001",
  "Programme / Class", "B.Sc. Information Technology (Third Year — Semester V/VI)",
  "Subject / Course", "Project Dissertation and Implementation (Course Code: JUSIT-DSCPR503)",
  "Project Category", "Web Application / Crowdsourced Quorum Consensus / Distributed Verification",
  "Development Stack", "React 18, Vite 5, TypeScript, Tailwind CSS v4, Cloud Firestore, Firebase Auth",
  "Target Platform", "Responsive Modern Web Browsers (Mobile, Tablet, Desktop) & WhatsApp Share",
  "Project Guide", "Department of Information Technology Faculty Supervisor",
  "Submission Date", "September 2026"
)

#v(14pt)

// ==========================================
// Dedicated Table of Contents Page
// ==========================================
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

// ==========================================
// 1. Executive Summary & Abstract
// ==========================================
= Executive Summary & Abstract

Misinformation propagated across end-to-end encrypted messaging applications represents one of the most severe sociological, public health, and democratic challenges in modern India. With over 500 million active users, WhatsApp functions as India's primary information backbone. However, its peer-to-peer forwarding architecture facilitates the exponential, friction-free transmission of fabricated medical claims, altered political quotes, communal falsehoods, and financial swindles. Because WhatsApp messages circulate in private, closed groups ("dark social"), automated search indexing and centralized journalistic interventions remain structurally blind to hyper-local, viral forwards until widespread damage has materialized.

*FactStamp* is an innovative, decentralized, community-driven web application architected specifically to intercept, verify, and reverse the direction of WhatsApp misinformation. Users paste suspicious text forwards or upload screenshots received on WhatsApp. FactStamp's automated pipeline normalizes incoming text, applies client-side image compression, extracts embedded forward strings via Optical Character Recognition (OCR), and queries an intelligent *Jaccard similarity duplicate detection engine* ($J >= 0.75$). If an identical claim has already been resolved, the user is immediately routed to the existing certified verdict, preventing redundant work.

Unique claims enter a public *Verification Quorum Queue*, where a minimum of three independent, authenticated community verifiers examine primary sources and submit their verdicts (*TRUE*, *FALSE*, *MISLEADING*, or *UNVERIFIABLE*) along with verifiable reference citations. A multi-factor consensus engine synthesizes these inputs into a final weighted confidence score ($C = 0.40 A + 0.30 R + 0.30 S$), combining raw agreement ratio ($A$), verifier reputation history ($R$), and source credibility tier ($S$). 

Rather than confining fact-checks to an isolated web repository, FactStamp compiles verified claims client-side using `html-to-image` utilizing browser-native SVG `<foreignObject>` rasterization into a crisp, standardized, 1080#text[×]1080px square *Fact-Check PNG Card*. This card features color-coded status stamps, confidence percentages, verified source citations, and succinct counter-explanations. Users download this visual card and forward it directly back into the originating WhatsApp chat groups, weaponizing the platform's native forwarding culture to replace viral misinformation with verified truth.

#v(8pt)

// ==========================================
// 2. Problem Statement & Need for System
// ==========================================
= Problem Statement & Need for the System

== The WhatsApp Misinformation Epidemic in India
In India's digital ecosystem, WhatsApp is not merely a private messaging client; it operates as an authoritative information distribution channel for hundreds of millions of first-generation smartphone users. The sociological dynamics of family circles, religious communities, and housing society groups create an environment of implicit trust: recipients assume forwards sent by acquaintances or elders possess inherent validity. 

Consequently, fake medical panaceas (e.g., claiming hot lemon water cures dengue fever), doctored audio-visual clips, manufactured banking advisories, and inflammatory sectarian rumors achieve millions of views within minutes. The end-to-end encryption governing WhatsApp prevents search engines and automated crawlers from monitoring this content, shielding viral misinformation inside closed communication channels.

== Shortcomings of Conventional Fact-Checking Agencies
While professional investigative fact-checking organizations (e.g., AltNews, BOOM Live, Vishwas News) provide rigorous journalistic investigations, their operating model faces critical structural bottlenecks:
- *Latency and Throughput Deficit:* Professional investigative reporting requires hours or days to publish a single debunking article, while a viral forward completes its lifecycle within a few hours.
- *Format Incompatibility:* Traditional agencies publish long-form web articles and PDF press releases. When ordinary WhatsApp users encounter a 1,500-word article, they rarely read or forward it. A dense text link cannot compete visually with an incendiary meme.
- *Centralized Capacity Bottlenecks:* Journalistic editorial desks cannot scale to address thousands of hyper-local, regional-language, and informal community rumors circulating simultaneously.

== System Value Proposition: Reversing Misinformation Velocity
FactStamp solves this structural dilemma through a crowdsourced, quorum-governed verification paradigm coupled with instantaneous visual counter-artifact generation. By distributing verification tasks across authenticated community members and distilling complex findings into an unalterable, high-impact 1080#text[×]1080px PNG stamp, FactStamp transforms passive readers into active counter-misinformation advocates.

#v(8pt)

// ==========================================
// 3. Project Objectives
// ==========================================
= Project Objectives

The primary engineering and research objectives of FactStamp are:

- *Objective 1: Multimodal Claim Submission Pipeline:* Build an intuitive, frictionless web interface enabling users to submit unverified WhatsApp forwards either as raw plaintext or as screenshot images without mandating prior account registration.
- *Objective 2: Intelligent Duplicate Detection Engine:* Implement a high-performance token-level Jaccard similarity algorithm ($J >= 0.75$) to detect duplicate or semantically identical claims, preventing redundant verification queues and conserving community capacity.
- *Objective 3: Automated Client-Side OCR Ingestion:* Integrate a client-side Optical Character Recognition (OCR) pipeline that extracts text from uploaded WhatsApp screenshots, compresses images into compact base64 strings, and normalizes typography before database storage.
- *Objective 4: Community Quorum Verification Queue:* Construct a transparent, real-time verification queue requiring a minimum quorum of three ($N >= 3$) independent community reviews before a verdict can be finalized.
- *Objective 5: Multi-Factor Weighted Consensus Engine:* Formulate an algorithmic scoring model that computes a composite confidence percentage based on verifier agreement ratio (40%), verifier historical reputation (30%), and source domain credibility (30%).
- *Objective 6: Sybil-Resistant Verifier Reputation Subsystem:* Design an automated reputation tracking system ($0$ to $100$ scale) that rewards verifiers whose submissions align with verified consensus and penalizes bad actors, preventing collusion and self-verification tampering.
- *Objective 7: Dynamic WhatsApp-Optimized PNG Card Generator:* Engineer a client-side graphic rendering module using `html-to-image` that exports 1080#text[×]1080px square fact-check cards containing claim snippets, verdict badges, trust rings, and primary source links.
- *Objective 8: Public Misinformation Analytics Dashboard:* Implement an interactive analytical dashboard illustrating weekly misinformation surges, category distributions (Health, Political, Financial, Religious), top debunked claims, and verifier leaderboards.

#v(8pt)

// ==========================================
// 4. Scope and Operational Applicability
// ==========================================
= Scope and Operational Applicability

== Functional Scope
The functional boundaries of FactStamp include:
- Unauthenticated and authenticated user claim submissions (text and screenshot uploads).
- Automated client-side image compression and text extraction pipeline.
- Real-time Firestore document state management and duplicate detection indexing.
- Quorum verification workflow allowing verifiers to input verdicts, source URLs, and plain-language reasoning.
- Mathematical consensus derivation and real-time confidence score computation.
- Client-side DOM-to-canvas image rasterization producing downloadable PNG counter-artifacts.
- Reactive user notifications notifying submitters when their claims achieve consensus.
- Analytical reporting of category trends and platform verification metrics.

== Target Audience & Beneficiaries
- *Everyday WhatsApp Users:* Individuals who receive suspicious forwards and require an instant, accessible tool to check veracity before re-sharing.
- *Community Fact-Checkers & University Students:* Digitally literate individuals seeking an organized, reputation-building framework to debunk falsehoods.
- *Media Literacy Researchers & Academic Investigators:* Analysts evaluating viral propagation patterns, categorical misinformation distributions, and consensus dynamics.
- *Community Group Administrators:* Group managers seeking authoritative visual evidence to shut down dangerous rumors in neighborhood or family forums.

== Operational Constraints & Assumptions
- *Non-Invasive Architecture:* FactStamp does not modify or hook directly into WhatsApp's proprietary encrypted client protocols; it operates via user-directed uploads.
- *Human-in-the-Loop Consensus:* Truth validation relies on multi-party human consensus backed by verified secondary/primary citations rather than unverified black-box LLM hallucinations.
- *Zero-Cost Serverless Infrastructure:* The complete architecture is optimized to operate strictly within standard free cloud tiers (Firebase Spark plan, Vercel edge deployment) without incurring subscription liabilities.

#v(8pt)

// ==========================================
// 5. Literature Survey & Competitive Benchmark
// ==========================================
= Literature Survey & Competitive Analysis

Existing fact-checking services operate under diverse methodologies. A systematic comparative analysis highlights FactStamp's structural advantages:

#styled-table(
  columns: (1.2in, 1fr, 1fr, 1fr),
  headers: ("Capability", "AltNews / BOOM Live", "Snopes / PolitiFact", "FactStamp (Proposed)"),
  "Operational Model", "Centralized full-time journalistic investigative team", "Editorial journalist staff and research fellows", "Decentralized community-driven 3-verifier quorum model",
  "Target Channel Focus", "General web, Twitter/X, mainstream public media", "Western politics, urban legends, general web claims", "WhatsApp peer-to-peer forwarded messages and dark social",
  "Verification Turnaround", "High latency: 6 hours to 3 business days per claim", "High latency: 12 hours to several days", "Rapid turnaround: real-time duplicate check, 1-3 hr quorum",
  "Counter-Spread Artifact", "Text-heavy web hyperlinks; embedded editorial ads", "Long-form editorial articles and web database entries", "Standalone 1080×1080px square PNG card for WhatsApp",
  "Multimodal Screenshot Ingestion", "Manual submission via WhatsApp bot; manual OCR", "Web forms requiring manual transcription", "Automated client-side OCR text-extraction pipeline",
  "Consensus Transparency", "Opaque internal editorial decision-making", "Editorial review board approval process", "Mathematical consensus formula with verifiable audit log",
  "Infrastructure Cost", "Substantial corporate operational and editorial budget", "Large media foundation funding / commercial advertising", "Zero infrastructure cost (serverless Firebase + Vercel)"
)

#v(8pt)

#pagebreak()

// ==========================================
// 6. Proposed System Architecture
// ==========================================
= Proposed System Architecture

FactStamp is architected as a modular, reactive, single-page web application communicating directly with Cloud Firestore NoSQL storage via declarative security rules. The system eliminates heavy backend application servers by distributing image compression, OCR extraction, and canvas card rendering directly to client browser engines.

== Architectural Subsystems (8 Core Modules)
1. *Module 1: Authentication & Role-Based Access Control (RBAC):* Manages user onboarding via Firebase Auth (Email/Password and Google OAuth), maintaining distinct privilege tiers (`User`, `Verifier`, `Admin`).
2. *Module 2: Multimodal Claim Ingestion & Preprocessing Subsystem:* Accepts raw text or uploaded screenshot images, performing client-side JPEG/PNG compression and triggering the automated OCR extraction pipeline.
3. *Module 3: Jaccard Token-Based Duplicate Detection Engine:* Evaluates incoming text against Firestore claim collections using normalized Jaccard word-overlap metrics to eliminate redundant queues.
4. *Module 4: Community Verification Quorum Queue:* Dispatches unverified claims to an open verification registry, managing independent reviews until the three-verifier quorum threshold ($N >= 3$) is reached.
5. *Module 5: Weighted Consensus & Confidence Calculation Engine:* Implements the mathematical formula aggregating verifier decisions, individual historical reputation scores, and source domain validity.
6. *Module 6: Dynamic 1080#text[×]1080px Fact-Check Card Generator:* Renders client-side PNG images styled to WhatsApp graphic dimensions using `html-to-image` with native SVG foreignObject rasterization.
7. *Module 7: Public Verification Registry & Analytics Dashboard:* Computes weekly categorical trend reports, leaderboard matrices, and categorical breakdowns using Recharts.
8. *Module 8: System Security, Anti-Sybil Defense & Real-Time Alerts:* Enforces Firestore database security rules, self-verification locks, input sanitation, and reactive snapshot notification listeners.

#pagebreak()

== Architectural Workflow Diagram
The end-to-end data processing lifecycle—from initial WhatsApp message receipt to viral counter-forward distribution—is illustrated below:

#v(10pt)
#responsive-image("attachments/system_workflow.svg", width: 85%)

#pagebreak()

// ==========================================
// 7. Mathematical Formulation & Algorithmic Design
// ==========================================
= Mathematical Formulation & Algorithmic Design

== Text Normalization & Jaccard Duplicate Similarity
To detect whether an incoming forward has previously undergone verification, FactStamp applies string normalization followed by set-theoretic Jaccard token comparison.

*Step 1: Normalization Function:*
The raw claim string $T$ is lowercased, stripped of non-alphanumeric punctuation, and condensed to remove redundant whitespace:
$ "Norm"(T) = "lowercase"("stripPunctuation"("trimWhitespace"(T))) $

*Step 2: Significant Token Set Extraction:*
Tokens having character length $L <= 3$ (stop words, prepositions) are filtered out, yielding token set $S_T$:
$ S_T = { w in "split"("Norm"(T), " ") | |w| > 3 } $

*Step 3: Jaccard Similarity Index:*
For an incoming submission $A$ and an existing database claim $B$, the similarity coefficient $J(A, B)$ is defined as:
$ J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|) $

*Decision Threshold:*
$ "Action" = cases(
  "Redirect to Existing Claim Page" & "if" max_(B in "Claims") J(A, B) >= 0.75,
  "Initialize New Claim in Verification Queue" & "otherwise"
) $

== Multi-Factor Weighted Quorum Consensus Engine
When a claim accumulates $N >= 3$ independent verifications, the consensus algorithm determines the definitive verdict and computes a confidence index $C in [0, 100]$.

*Mathematical Formulation:*
$ C = (A times 40%) + (R times 30%) + (S times 30%) $

Where the individual normalized parameters represent:
- *Agreement Ratio ($A$):* The proportion of participating verifiers who voted for the majority verdict:
  $ A = frac(N_("majority"), N_("total")) times 100 $
- *Average Normalized Reputation ($R$):* The arithmetic mean of the participating verifiers' reputation scores ($R_i in [0, 100]$):
  $ R = frac(1, N) sum_(i=1)^N R_i $
- *Average Source Credibility Score ($S$):* Evaluates the reliability of external URLs supplied during review:
  $ S = frac(1, N) sum_(i=1)^N Q("URL"_i) times 100 $
  Where $Q("URL") = 1.0$ for primary government, WHO, or peer-reviewed scientific domains; $0.70$ for reputable commercial news agencies; and $0.30$ for unverified web blogs or secondary forums.

== Verdict Classification State Matrix
Claims progress through a deterministic state machine based on verifier voting patterns:

#styled-table(
  columns: (1.2in, 1.2in, 1fr),
  headers: ("Verdict Classification", "UI Color Token", "Semantic Determination & Criteria"),
  "TRUE", "Emerald Green", "Claim is factually verified; supported by authoritative primary institutional documentation.",
  "FALSE", "Crimson Red", "Claim is demonstrably fabricated, doctored, fraudulent, or fundamentally untrue.",
  "MISLEADING", "Amber Orange", "Claim contains partial facts presented in a distorted, exaggerated, or deceptive context.",
  "UNVERIFIABLE", "Slate Gray", "Insufficient empirical evidence or credible citations exist to definitively establish truth.",
  "CONTESTED", "Violet Purple", "Equally divided votes among verifiers unable to achieve majority consensus within 7 days."
)

#v(8pt)

// ==========================================
// 8. Technology Stack & Infrastructure
// ==========================================
= Technology Stack & Infrastructure

FactStamp utilizes a cutting-edge, high-performance web engineering stack:

#styled-table(
  columns: (1.3in, 1.4in, 1fr),
  headers: ("Architectural Layer", "Technology Selection", "Role & Engineering Rationale"),
  "Frontend Framework", "React 18 + Vite 5", "Declarative component hierarchy, sub-millisecond hot reloading, lightweight build bundle.",
  "Type Safety", "TypeScript 5.x", "Strict compile-time interface contracts, eliminating runtime type mutations.",
  "Styling & Tokens", "Tailwind CSS v4", "High-performance CSS engine using native OKLCH color spaces and CSS variables.",
  "Design Aesthetic", "Saffron Sleek Theme", "Warm cream surfaces (#FFFDF8), Deep Saffron primary, Slate ink, zero AI-slop purple.",
  "Authentication", "Firebase Auth", "Secure OAuth 2.0 Google sign-in and email credential sessions.",
  "Database Storage", "Cloud Firestore NoSQL", "Real-time reactive document streams with granular security rules.",
  "Image Compression", "HTML5 Canvas API", "Client-side image scaling to 1200px max dimension, base64 payload under 500 KB.",
  "Text Extraction (OCR)", "Tesseract.js / Web OCR", "Client-side character recognition extracting text from forward screenshots.",
  "Card Rasterization", "html-to-image (SVG foreignObject)", "Rasterizes DOM elements to 1080×1080px PNG with modern color space compatibility.",
  "Analytical Charts", "Recharts", "Interactive SVG/Canvas data visualization for category distributions and trend metrics.",
  "Containerization", "Docker & Compose", "Reproducible production container definitions for multi-platform staging."
)

#v(8pt)

// ==========================================
// 9. Hardware and Software Specifications
// ==========================================
= Hardware and Software Specifications

== Client Runtime Requirements
- *Processor:* Dual-core 1.8 GHz 64-bit CPU or higher (ARM/x86_64).
- *System Memory (RAM):* Minimum 2 GB (4 GB recommended for in-browser OCR image processing).
- *Display Resolution:* Minimum 360#text[×]640 (Mobile) up to 1920#text[×]1080 (Desktop FHD).
- *Web Browser:* Google Chrome 100+, Mozilla Firefox 105+, Apple Safari 15.4+, or Microsoft Edge with WebGL and ES2022 support.

== Server & Cloud Platform Specifications
- *Hosting Platform:* Vercel Global Edge Network / Nginx Container.
- *Backend Database:* Google Cloud Firestore (Managed Multi-Region NoSQL).
- *Identity Provider:* Google Identity Services / Firebase Authentication.
- *Network Bandwidth:* Standard broadband / 4G cellular data connection.

== Development & Compilation Tooling
- *Runtime Environment:* Node.js LTS (v20.x or v22.x) and `npm` package manager.
- *Document Compilation:* Typst v0.15.1 typesetting binary.
- *Diagramming Engines:* Graphviz `dot` v16.0.0 and PlantUML (OpenJDK 21 JVM).
- *Version Control:* Git with GitHub repository management.

#v(8pt)

// ==========================================
// 10. Feasibility Study
// ==========================================
= Feasibility Study

A thorough feasibility evaluation establishes that FactStamp is completely viable across technical, operational, and financial dimensions:

== Technical Feasibility
All planned capabilities leverage stable, production-hardened web standards. Client-side OCR via WebAssembly/Tesseract.js functions reliably across modern mobile browsers. `html-to-image` reliably compiles complex styled DOM nodes into high-resolution PNG images. Firebase Firestore provides 99.95% cloud availability with sub-50ms snapshot sync latencies.

== Operational Feasibility
FactStamp requires zero centralized moderation staff to process daily submissions. The 3-verifier quorum model, coupled with transparent source URL attribution and peer reputation tracking, decentralizes governance. The Jaccard duplicate detection engine automatically shields community reviewers from re-evaluating identical viral rumors.

== Economic Feasibility
The entire platform is architected to operate at *zero infrastructure expense*. Firebase's Spark Free Plan provides 50,000 document reads, 20,000 document writes, and 1 GB of storage per day—more than sufficient for college campus deployment and academic demonstration. Screenshot compression directly into Firestore claim records eliminates the need for paid cloud bucket storage.

#v(8pt)

// ==========================================
// 11. Project Plan, Methodology & Milestones
// ==========================================
= Project Plan, Methodology & Milestones

== Software Development Life Cycle (SDLC) Model Justification
FactStamp adopts an *Agile / Scrum* iterative process model. Because user experience interactions with WhatsApp forwards are inherently fluid, two-week sprint cadences allow rapid prototyping, immediate usability testing with student cohorts, and continuous integration of algorithmic enhancements (e.g., tuning Jaccard similarity thresholds and OKLCH color patches).

== Four-Month Milestone Implementation Schedule

#styled-table(
  columns: (1.1in, 1.2in, 1fr, 1.1in),
  headers: ("Sprint / Period", "Phase Name", "Key Deliverables & Engineering Activities", "Status"),
  "Sprint 1\n(June 2026)", "Foundation &\nIngestion Pipeline", "Initialize React-Vite project; configure Firebase Auth; implement text submission forms and client-side image compression; integrate OCR text extraction; code Jaccard duplicate detection algorithm.", "Completed",
  "Sprint 2\n(July 2026)", "Quorum &\nConsensus Engine", "Construct public Verification Queue; implement 3-verifier quorum voting interface; code weighted consensus formula and verifier reputation scoring model; enforce Firestore security rules.", "Completed",
  "Sprint 3\n(August 2026)", "Card Generator &\nAnalytics Subsystem", "Integrate html-to-image 1080×1080px card generator; develop trending misinformation analytics dashboard with Recharts; build real-time reactive notifications.", "Completed",
  "Sprint 4\n(Sept 2026)", "Security Hardening\n& Final Evaluation", "Conduct anti-Sybil attack stress tests, APCA contrast ratio accessibility audit, cross-browser verification; finalize IEEE 830 Black Book documentation; practical viva examination.", "Underway"
)

#v(8pt)

#pagebreak()

// ==========================================
// 12. Expected Deliverables & Academic Outcomes
// ==========================================
= Expected Deliverables & Academic Outcomes

Upon completion of Course JUSIT-DSCPR503, the following deliverables will be formally submitted:
1. *Production Web Platform:* Fully functional, responsive web application deployed on high-availability cloud infrastructure.
2. *Fact-Check Artifact Generator:* Operational 1080#text[×]1080px graphic compilation engine producing WhatsApp-ready PNG cards.
3. *Complete IEEE Std 830-1998 Black Book Documentation:* Fully typeset academic dissertation including Software Requirements Specifications, UML architectural diagrams, Data Flow Diagrams, test suite logs, and user operating manuals.
4. *Open-Source Code Repository:* Clean, documented source repository with strict TypeScript definitions, unit tests, and Docker containerization scripts.

#v(8pt)

// ==========================================
// 13. Conclusion
// ==========================================
= Conclusion

*FactStamp* addresses an urgent socio-technical crisis in India's digital communications landscape. By merging crowdsourced verification with an automated duplicate detection engine and a shareable PNG card generator, the project bridges the fatal gap between slow journalistic debunking and the blinding speed of encrypted WhatsApp forwards. The serverless, zero-cost architecture ensures high sustainability, while the 3-verifier quorum consensus engine maintains scientific objectivity and transparency. FactStamp demonstrates substantial engineering depth, rigorous algorithmic logic, and immediate real-world utility, making it an exemplary capstone project for the Bachelor of Science in Information Technology degree.

#v(8pt)

// ==========================================
// 14. References & Academic Bibliography
// ==========================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
3. Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
4. Garimella, K., & Eckles, D., *"Images and Misinformation in Political Groups: Evidence from WhatsApp in India,"* in _Proc. ACM Hum.-Comput. Interact._, CSCW, 2020.
5. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
6. Google Firebase Documentation, *"Cloud Firestore Security Rules & Realtime Snapshot Listeners,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
7. Bubkoo, *"html-to-image: Generates images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.
