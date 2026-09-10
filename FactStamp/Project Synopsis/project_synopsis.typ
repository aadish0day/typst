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
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai - 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025-2026]
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
  "Programme / Class", "B.Sc. Information Technology (Third Year, Semester V/VI)",
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

Misinformation circulating across encrypted messaging platforms presents substantial risks to public health, civic communication, and personal finance in India. With over 500 million active users in the country, WhatsApp serves as a primary everyday communication channel. However, its direct forwarding model enables unverified claims, fabricated health advice, doctored media, and financial scams to spread rapidly across peer networks. Because messages circulate within private, encrypted chat groups, automated web crawlers and institutional fact-checkers cannot index or evaluate these forwards until users submit them manually or the claims gain broader public exposure.

*FactStamp* is a web application designed to collect, verify, and counter WhatsApp forwards through crowdsourced community consensus. Users submit suspicious text forwards or screenshots directly through the web interface. The intake pipeline normalizes submitted text, applies client-side image compression, extracts text from screenshots using client-side Optical Character Recognition (OCR), and compares the input against existing records using Jaccard token-overlap similarity ($J >= 0.75$). If an identical or near-duplicate claim is already recorded, the application directs the user to the existing verdict, avoiding duplicate review.

New claims enter a public *Verification Queue*, where a minimum of three independent, authenticated verifiers evaluate primary sources and submit verdicts (*TRUE*, *FALSE*, *MISLEADING*, or *UNVERIFIABLE*) with supporting source URLs. A weighted consensus engine calculates a final confidence score ($C = 0.40 A + 0.30 R + 0.30 S$) by combining the verifier agreement ratio ($A$), average verifier reputation ($R$), and source credibility tier ($S$).

To make verified verdicts shareable within messaging threads, FactStamp renders completed claims into an exportable 1080#text[×]1080px square PNG image using client-side SVG `<foreignObject>` rasterization via `html-to-image`. The card displays the claim text, verdict stamp, confidence score, and primary source citations. Users can download this graphic and forward it into chat groups to provide evidence-based counter-information where the original forward circulated.

#v(8pt)

// ==========================================
// 2. Problem Statement & Need for System
// ==========================================
= Problem Statement & Need for the System

== Misinformation Spread on WhatsApp in India
WhatsApp is widely used across India for everyday communication. Messages shared within peer groups, family circles, and community networks often carry interpersonal trust, leading recipients to accept forwarded claims without independent verification.

Unverified messages include false medical remedies (such as claiming hot lemon water cures dengue fever), altered media clips, fake financial advisories, and misleading public notices. Because WhatsApp uses end-to-end encryption, search engines and automated monitoring systems cannot index private chat content, allowing false claims to circulate unnoticed by public debunking initiatives.

== Limitations of Conventional Fact-Checking Approaches
Professional fact-checking organizations (such as AltNews, BOOM Live, and Vishwas News) produce detailed journalistic reviews, but their workflows have operational constraints:
- *Latency and Throughput:* Thorough investigative reporting often requires hours or days to publish an article. By contrast, a viral forward can spread across multiple groups within hours.
- *Format Incompatibility:* Fact-checking agencies typically publish long-form web articles. Users in chat threads rarely read or forward full articles, so text links fail to travel as effectively as image-based forwards.
- *Centralized Editorial Capacity:* Newsroom desks have limited staff and cannot process the high daily volume of local, regional, and informal rumors.

== Proposed Approach: Distributed Verification and Visual Counter-Cards
FactStamp addresses these operational constraints through crowdsourced quorum verification and image-based debunk generation. Distributing verification tasks across authenticated users reduces reliance on a single editorial team. Rendering the final verdict and source citations into a standardized 1080#text[×]1080px PNG card provides an artifact that users can forward directly within chat threads.

#v(8pt)

// ==========================================
// 3. Project Objectives
// ==========================================
= Project Objectives

The engineering objectives of FactStamp are:

+ *Multimodal Claim Submission Pipeline:* Implement a web interface allowing users to submit unverified forwards as plain text or screenshot images without requiring account registration for submission.
+ *Duplicate Detection Engine:* Implement a token-level Jaccard similarity algorithm ($J >= 0.75$) to detect duplicate claims, preventing repeated entries in the verification queue.
+ *Client-Side OCR Ingestion:* Integrate an in-browser Optical Character Recognition pipeline using Tesseract.js to extract text from screenshots, compress images into base64 strings, and clean interface chrome prior to submission.
+ *Community Quorum Verification Queue:* Build a verification queue requiring a minimum quorum of three ($N >= 3$) independent reviews before a verdict settles.
+ *Weighted Consensus Engine:* Formulate a scoring model that calculates a composite confidence percentage from verifier agreement (40%), historical reputation (30%), and cited source quality (30%).
+ *Verifier Reputation Tracking:* Implement a reputation scoring system ($0$ to $100$) that adjusts verifier ratings based on alignment with consensus verdicts and restricts self-verification.
+ *Fact-Check PNG Card Generator:* Develop a client-side rendering module using `html-to-image` to export 1080#text[×]1080px square image cards containing the claim summary, verdict badge, confidence percentage, and cited sources.
+ *Public Analytics Dashboard:* Build an analytics interface showing weekly volume, category distributions (Health, Political, Financial, Religious, Other), frequently debunked claims, and verifier contribution metrics.

#v(8pt)

// ==========================================
// 4. Scope and Operational Applicability
// ==========================================
= Scope and Operational Applicability

== Functional Scope
The functional scope of FactStamp encompasses:
- Unauthenticated and authenticated claim submissions for text and screenshot uploads.
- Client-side image compression and text extraction.
- Firestore document synchronization and duplicate-detection index checks.
- Quorum verification workflow where verifiers enter verdicts, source URLs, and written reasoning.
- Consensus computation and confidence scoring once quorum is reached.
- Client-side DOM rasterization producing downloadable PNG fact-check cards.
- User notifications alerting submitters when their claims reach consensus.
- Analytics reporting on category distributions and verification metrics.

== Target Audience and Beneficiaries
- *Everyday Messaging Users:* Individuals who receive suspicious forwards and seek a tool to verify claims before sharing them further.
- *Community Verifiers and Students:* Individuals seeking an organized framework to evaluate claims with citations and build credibility.
- *Researchers and Analysts:* Investigators examining misinformation categories, forward patterns, and crowdsourced consensus data.
- *Group Administrators:* Community moderators seeking evidence-backed graphic summaries to clarify disputed claims in group chats.

== Operational Constraints and Assumptions
- *Independent Web Workflow:* FactStamp does not interface directly with WhatsApp's proprietary client protocols; it operates through manual user submissions.
- *Human-in-the-Loop Evaluation:* Claims are verified through multi-party human judgment supported by cited references, avoiding automated or AI-generated verdicts.
- *Free-Tier Infrastructure:* The application is designed to operate within standard free cloud tiers (Firebase Spark plan, Vercel deployment) without requiring dedicated server infrastructure.

#v(8pt)

// ==========================================
// 5. Literature Survey & Competitive Benchmark
// ==========================================
= Literature Survey & Comparative Analysis

Existing fact-checking platforms use various organizational models. Table 1 compares FactStamp with representative existing initiatives across operational dimensions:

#styled-table(
  columns: (1.2in, 1fr, 1fr, 1fr),
  headers: ("Capability", "AltNews / BOOM Live", "Snopes / PolitiFact", "FactStamp (Proposed)"),
  "Operational Model", "Full-time professional journalistic investigative team", "Editorial staff and research contributors", "Distributed 3-verifier community quorum model",
  "Target Channel Focus", "Open web, social networks, public news media", "General web claims, political speeches, urban legends", "WhatsApp forwarded messages and private chat threads",
  "Verification Turnaround", "Variable latency: several hours to several business days", "Variable latency: 12 hours to multiple days", "Instant duplicate lookup; quorum dependent on active verifiers",
  "Counter-Misinformation Artifact", "Web hyperlinks to long-form articles", "Web database entries and editorial articles", "Standalone 1080×1080px square PNG card for messaging apps",
  "Screenshot Ingestion", "Manual submission via WhatsApp bot; manual text review", "Web forms requiring manual transcription", "Client-side OCR text extraction via Tesseract.js",
  "Consensus Transparency", "Internal editorial review process", "Editorial review board evaluation", "Deterministic consensus formula with verifiable audit log",
  "Infrastructure Cost", "Dedicated newsroom and operating budget", "Media foundation grants and advertising revenue", "Free-tier serverless resources (Firebase Spark and Vercel)"
)

#v(8pt)

#pagebreak()

// ==========================================
// 6. Proposed System Architecture
// ==========================================
= Proposed System Architecture

FactStamp is organized as a single-page web application communicating directly with Cloud Firestore NoSQL storage through declarative security rules. The architecture avoids dedicated application servers by executing image compression, OCR extraction, and card rendering directly within client browser runtimes.

== Core Functional Modules
1. *Module 1: Authentication & Role-Based Access Control (RBAC):* Manages user accounts via Firebase Auth (Email/Password and Google OAuth) across three roles: User, Verifier, and Admin.
2. *Module 2: Multimodal Claim Ingestion:* Accepts plain text or screenshot uploads, running client-side image compression and client-side OCR text extraction.
3. *Module 3: Jaccard Duplicate Detection:* Compares incoming claim text with existing Firestore records using normalized token-overlap similarity ($J >= 0.75$).
4. *Module 4: Verification Queue:* Maintains unverified claims in a public queue until the three-verifier quorum threshold ($N >= 3$) is reached.
5. *Module 5: Weighted Consensus & Confidence Calculation:* Aggregates verifier decisions, reputation scores, and cited source quality into a composite confidence metric.
6. *Module 6: Fact-Check PNG Card Generator:* Renders exportable 1080#text[×]1080px image cards using `html-to-image` and SVG `<foreignObject>` rasterization.
7. *Module 7: Analytics Dashboard:* Displays weekly trend reports, category distributions, and verifier activity metrics using Recharts.
8. *Module 8: System Security & Alerts:* Enforces Firestore database security rules, self-verification locks, input sanitization, and snapshot notification listeners.

#pagebreak()

== Architectural Workflow Diagram
The end-to-end data processing flow, from WhatsApp message submission to verified card generation, is illustrated below:

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
  "FALSE", "Crimson Red", "Claim is demonstrably fabricated, doctored, or untrue.",
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
