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

#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory: New topic on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

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
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9.5pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 9.5pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - GANTT Chart & 4.2 Data Design", author: "Aadish")

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
    #text(size: 11pt, weight: "bold")[GANTT CHART & 4.2 DATA DESIGN: DATABASE AND SCHEMA DESIGN]
    #v(2pt)
    #text(size: 10.5pt)[*3.3 Planning and Scheduling (GANTT Chart) | 4.2 Data Design (Schema & Database)*]
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
  depth: 3
)

#pagebreak()

// =============================================================================
// SECTION 3.3: PLANNING AND SCHEDULING (GANTT CHART)
// =============================================================================
= 3.3 Planning and Scheduling

== Software Development Life Cycle (SDLC) Model Justification

Selecting an appropriate Software Development Life Cycle (SDLC) process model dictates how an engineering team balances scope, schedule risk, technical uncertainties, and user feedback. Developing *FactStamp* presented significant technological unpredictability:
- Integrating cutting-edge WebAssembly OCR (`tesseract.js`) directly into client mobile browsers.
- Managing experimental CSS Color Level 4 (`oklch`) rendering breakdowns within DOM-to-canvas exporters.
- Calibrating mathematical thresholds for duplicate detection ($J >= 0.75$) and consensus confidence ($C >= 70\%$).

Three traditional process models were evaluated alongside *Agile Scrum*:

#v(6pt)

#styled-table(
  columns: (1.3in, 1.8in, 1fr),
  headers: ("Process Model", "Operational Characteristics", "Justification / Deficit for FactStamp"),
  "Waterfall Model", "Linear sequential phases; rigid upfront requirements freeze.", "Incompatible: Unforeseen canvas bugs and color issues require continuous architectural pivots.",
  "V-Model", "Verification and validation paired at each stage; heavy governance.", "Inflexible: Test cases cannot easily adapt to emergent client-side WebAssembly browser APIs.",
  "Spiral Model", "Risk-driven cyclical prototyping for large aerospace/defense.", "Over-engineered: Excessive governance overhead for a lightweight zero-cost web application.",
  "Agile Scrum", "Timeboxed 2-week sprints; rapid iterative releases; user demos.", "SELECTED MODEL: Perfect balance of empirical feedback, algorithmic tuning, and scheduling agility."
)

#v(8pt)

=== Why Agile Scrum Was Selected:
1. *Iterative Problem Discovery:* In Sprint 3, when `html2canvas` failed on Tailwind v4's OKLCH color tokens, the team quickly pivoted within the active sprint to migrate to `html-to-image` without invalidating the entire project schedule.
2. *Empirical Parameter Tuning:* The Jaccard threshold ($0.75$) and consensus weighting ($0.40A + 0.30R + 0.30S$) could not be established purely theoretically. Scrum's sprint reviews allowed testing iterative releases against 200 real-world forward samples and tuning parameters based on empirical data.
3. *Continuous Stakeholder Validation:* Bi-weekly sprint demos to academic guides and student peer groups provided early feedback on mobile touch ergonomics and Devanagari font rendering.

== Work Breakdown Structure (WBS)

The engineering lifecycle of FactStamp was decomposed into *14 discrete, measurable work activities* ($T_1$ to $T_(14)$):
- *$T_1$: Problem Definition & Stakeholder Requirements Analysis:* Formulate problem definition, conduct dark social literature review, and author the IEEE Std 830-1998 SRS.
- *$T_2$: Technology Survey & Comparative Architecture Evaluation:* Conduct comparative benchmarks across web architectures, frontend frameworks, cloud databases, OCR engines, styling systems, and consensus models.
- *$T_3$: System Architecture & Security Rules Design:* Design decoupled serverless SPA model, Firestore collections schema, and declarative security rule boundaries.
- *$T_4$: Authentication & Verifier Profile Subsystem:* Implement Firebase Auth (OAuth 2.0 / Email), session management, inactivity timeouts, and verifier profile tracking.
- *$T_5$: Client-Side Canvas Image Compression & WASM OCR Pipeline:* Build offscreen HTML5 canvas downscaler, integrate Tesseract.js WebAssembly worker, and test mobile memory footprint.
- *$T_6$: Tokenization & Jaccard Duplicate Detection Engine:* Implement string normalizer, stop-word eliminator, token set extractor, and pairwise Jaccard similarity index ($J >= 0.75$).
- *$T_7$: Quorum Verification Queue & Real-Time Sync Subsystem:* Develop public verification queue UI, voting forms, and real-time Firestore `onSnapshot` WebSocket listeners.
- *$T_8$: Multi-Factor Weighted Quorum Consensus Engine:* Formulate and code algorithmic consensus engine ($C = 0.40A + 0.30R + 0.30S$), source domain credibility lookup, and verifier reputation scoring.
- *$T_9$: Dynamic 1080×1080px Fact Card Generator:* Implement `html-to-image` SVG `<foreignObject>` DOM rasterizer, 2x retina export, and automated PNG download pipeline.
- *$T_(10)$: Misinformation Analytics Dashboard & Trend Visualizer:* Build rolling 7-day category trend charts, category donut graphs, and public verifier accuracy leaderboards using Recharts.
- *$T_(11)$: Integration & End-to-End System Testing:* Execute comprehensive unit testing, security rule penetration testing, and cross-browser mobile validation.
- *$T_(12)$: User Acceptance Testing (UAT) & Civic Verifier Trials:* Conduct pilot verification sessions with student peer groups and evaluate system usability metrics.
- *$T_(13)$: Serverless Cloud Deployment & Performance Optimization:* Configure Vercel Edge CDN, production Rollup chunk splitting, and TLS 1.3 edge caching.
- *$T_(14)$: Final Documentation & Dissertation Preparation:* Compile academic Black Book dissertation, user manual, and technical viva presentations.

== Probabilistic 3-Point PERT Estimation

Due to technical uncertainties in client-side WebAssembly execution and browser-native SVG rasterization, task durations were calculated using the *Program Evaluation and Review Technique (PERT)* probabilistic three-point estimation:

$ T_E = (O + 4M + P) / 6 $
$ sigma^2 = ((P - O) / 6)^2 $

Where $O$ is Optimistic duration, $M$ is Most Likely duration, and $P$ is Pessimistic duration.

== Computational PERT Schedule Analysis

Using the Forward Pass (Early Start $E S$, Early Finish $E F$) and Backward Pass (Late Start $L S$, Late Finish $L F$), the *Total Float / Slack* ($S = L S - E S = L F - E F$) is calculated for every task:

#v(6pt)

#styled-table(
  columns: (0.5in, 1.8in, 0.6in, 0.4in, 0.4in, 0.4in, 0.5in, 0.5in, 0.4in, 0.4in, 0.4in, 0.4in, 0.4in, 0.5in),
  headers: ("ID", "Task Description", "Pred.", "O", "M", "P", "T_E", "σ²", "ES", "EF", "LS", "LF", "Slack", "Crit.?"),
  "T1", "Problem Def. & IEEE SRS", "None", "5", "7", "15", "8.0", "2.78", "0", "8", "0", "8", "0.0", "YES",
  "T2", "Tech Survey & Architecture", "T1", "4", "6", "14", "7.0", "2.78", "8", "15", "10", "17", "2.0", "No",
  "T3", "Architecture & DB Design", "T1", "6", "9", "12", "9.0", "1.00", "8", "17", "8", "17", "0.0", "YES",
  "T4", "Auth & Verifier Profile", "T3", "5", "8", "11", "8.0", "1.00", "17", "25", "21", "29", "4.0", "No",
  "T5", "Canvas Comp. & WASM OCR", "T3", "8", "12", "16", "12.0", "1.78", "17", "29", "17", "29", "0.0", "YES",
  "T6", "Tokenization & Jaccard", "T5", "6", "8", "16", "9.0", "2.78", "29", "38", "29", "38", "0.0", "YES",
  "T7", "Quorum Queue & Realtime", "T4, T6", "7", "10", "19", "11.0", "4.00", "38", "49", "38", "49", "0.0", "YES",
  "T8", "Weighted Consensus Engine", "T7", "5", "8", "11", "8.0", "1.00", "49", "57", "49", "57", "0.0", "YES",
  "T9", "Fact Card Gen (SVG Engine)", "T8", "6", "10", "14", "10.0", "1.78", "57", "67", "57", "67", "0.0", "YES",
  "T10", "Analytics Dash & Visuals", "T9", "5", "7", "15", "8.0", "2.78", "67", "75", "67", "75", "0.0", "YES",
  "T11", "Integration & E2E Testing", "T10", "6", "9", "12", "9.0", "1.00", "75", "84", "75", "84", "0.0", "YES",
  "T12", "UAT & Civic Trials", "T11", "4", "6", "14", "7.0", "2.78", "84", "91", "87", "94", "3.0", "No",
  "T13", "Cloud Deploy & CDN", "T11", "6", "10", "14", "10.0", "1.78", "84", "94", "84", "94", "0.0", "YES",
  "T14", "Final Dissertation & Viva", "T12, T13", "5", "7", "9", "7.0", "0.44", "94", "101", "94", "101", "0.0", "YES"
)

== Critical Path Determination and Statistical Confidence

The *Critical Path* comprises the sequence of dependent tasks possessing exactly zero total slack ($S = 0$):

$ "Critical Path" = T_1 arrow.r T_3 arrow.r T_5 arrow.r T_6 arrow.r T_7 arrow.r T_8 arrow.r T_9 arrow.r T_(10) arrow.r T_(11) arrow.r T_(13) arrow.r T_(14) $

1. *Total Expected Project Duration ($T_E$):*
   $ T_E = 8.0 + 9.0 + 12.0 + 9.0 + 11.0 + 8.0 + 10.0 + 8.0 + 9.0 + 10.0 + 7.0 = 101.0 "working days" $
   This corresponds to approximately *14.4 calendar weeks* or *3.5 academic months*.

2. *Total Critical Path Variance ($sigma_P^2$) and Standard Deviation ($sigma_P$):*
   $ sigma_P^2 = 2.78 + 1.00 + 1.78 + 2.78 + 4.00 + 1.00 + 1.78 + 2.78 + 1.00 + 1.78 + 0.44 = 21.12 "days"^2 $
   $ sigma_P = sqrt(21.12) approx 4.60 "days" $

3. *Probability of On-Time Delivery:*
   With academic semester deadline set at $D = 110$ working days:
   $ Z = (D - T_E) / sigma_P = (110.0 - 101.0) / 4.60 = 9.0 / 4.60 approx +1.957 $
   $ P(T <= 110) = Phi(1.957) approx 97.5% $

== Four-Month Milestone Implementation Timeline (Gantt Schedule)

The 101-day implementation schedule was orchestrated across four 2-week Sprint cycles:

#v(6pt)

#styled-table(
  columns: (1.2in, 1.1in, 1.9in, 1.2in),
  headers: ("Sprint Milestone", "Calendar Days", "Target Epic & Core Engineering Activities", "Key Verifiable Deliverables"),
  "Sprint 1 (Weeks 1–4)", "Days 1 – 29", "Requirements, Scaffolding, Canvas Compression & Tesseract.js OCR", "IEEE Std 830 SRS; client-side image downscaler; functional WASM OCR pipeline.",
  "Sprint 2 (Weeks 5–8)", "Days 30 – 57", "Jaccard Duplicate Engine, Quorum Queue, and Multi-Factor Consensus", "Sub-100ms duplicate lookup; real-time Firestore queue; consensus calculation logic.",
  "Sprint 3 (Weeks 9–12)", "Days 58 – 84", "html-to-image SVG Engine, OKLCH Color Tokens & Analytics Dashboard", "1080×1080px Fact Card generator; 7-day rolling category trend charts with Recharts.",
  "Sprint 4 (Weeks 13–15)", "Days 85 – 101", "Security Rules Hardening, UAT Trials, Vercel Edge CDN Deployment & Viva", "Production deployment on Vercel; zero security flaws; verified academic dissertation."
)

#v(10pt)

== Visual GANTT Chart Diagram

Figure 3.1 illustrates the complete 14-task Gantt schedule, explicitly visualizing task start days, durations, sprint boundaries, critical path sequencing (highlighted in red), and non-critical float / slack allowances (indicated via hatched patterns).

#v(8pt)

#align(center)[
  #image("attachments/gantt_chart.svg", width: 100%)
]
#align(center)[
  #text(size: 9.5pt, style: "italic")[Figure 3.1: FactStamp Master Implementation GANTT Chart with Critical Path and Slack Intervals]
]

// =============================================================================
// CHAPTER 4.2: DATA DESIGN: DATABASE AND SCHEMA DESIGN
// =============================================================================
= 4.2 Data Design: Database and Schema Design

Data design is a foundational pillar of the *FactStamp* architecture. Unlike conventional relational systems built on rigid tabular schemas, FactStamp leverages a real-time, document-oriented NoSQL model provided by *Google Cloud Firestore*. This design satisfies the high-throughput, low-latency requirements of crowdsourced misinformation verification while accommodating semi-structured forward data, dynamic quorum verifications, and real-time client subscriptions.

== Schema Design

=== Database Paradigm Evaluation: NoSQL Document Store vs. Relational Model
The selection of Cloud Firestore over traditional relational databases (e.g., PostgreSQL or MySQL) was dictated by four core architectural drivers:

#v(6pt)

#styled-table(
  columns: (1.3in, 1.4in, 1.4in, 1fr),
  headers: ("Evaluation Dimension", "Relational Model (RDBMS)", "Document Store (Cloud Firestore)", "FactStamp Architectural Rationale"),
  "Data Structure Flexibility", "Strict fixed schema; schema migrations require table locking.", "Dynamic JSON-like document tree; flexible embedded arrays.", "Forward submissions vary from pure text to rich multimodal attachments with variable verifier lists.",
  "Real-Time Client Sync", "Requires external WebSocket bridges or polling layers (Socket.io).", "Native WebSocket listeners (onSnapshot) built into SDK.", "Verifiers and citizens receive instant live updates as quorums assemble and verdicts resolve.",
  "Quorum Atomicity", "Multi-table joins across claims, verifications, and users.", "Denormalized embedded arrays inside the root claim document.", "A single atomic read retrieves the entire claim dossier, including verifications and metrics.",
  "Operational Economics", "Continuous compute billing for idle server instances ($15–$50/mo).", "Serverless consumption model with generous free Spark tier ($0/mo).", "Preserves 100% zero-cost infrastructure for academic and civic sustainability."
)

#v(10pt)

=== Entity-Relationship (E-R) Diagram

The logical relationships and cardinality constraints governing the FactStamp data store are depicted in Figure 4.1.

#v(8pt)

#align(center)[
  #image("attachments/er_diagram.svg", width: 92%)
]
#align(center)[
  #text(size: 9.5pt, style: "italic")[Figure 4.1: FactStamp Entity-Relationship (E-R) Architectural Diagram]
]

#v(8pt)

The structural entities in the data model operate as follows:
- *USERS:* Stores verifier profiles, authentication metadata, and persistent reputation scores. A user submits zero or more claims ($0..N$) and casts zero or more verification votes ($0..N$).
- *CLAIMS:* The central entity containing forward text, extracted OCR data, verdict outcomes, and aggregated consensus metrics. Each claim receives zero or more verifications ($0..N$).
- *VERIFICATIONS:* Embedded audit records representing individual peer reviews with verdict, citation source URL, rationale explanation, and verifier credentials.
- *DUPLICATE_CLUSTER / NOTIFICATIONS:* Auxiliary structures maintaining fast duplicate token mappings and user alert feeds.
- *REPORTS:* Moderation entity tracking reported claims, abusive verifiers, or flagged content for administrative review.

=== Collection Schemas and Data Dictionaries

==== 1. `users` Collection Schema
Path: `/databases/{database}/documents/users/{uid}` \
The `users` collection stores verifier profiles, authentication metadata, and persistent reputation scores.

#v(6pt)

#styled-table(
  columns: (1.2in, 0.8in, 0.7in, 0.9in, 1fr),
  headers: ("Field Name", "Type", "Nullable", "Default", "Description & Validation Rules"),
  "uid", "string", "No", "N/A", "Firebase Auth unique identifier (RS256 JWT subject claim). Primary Key.",
  "displayName", "string", "No", "N/A", "Public verifier pseudonym or real name. Constraints: 1 <= length <= 100.",
  "email", "string", "No", "N/A", "Verified email address. Must match request.auth.token.email.",
  "avatarUrl", "string", "Yes", "null", "Optional URI pointing to user profile avatar or generated initial fallback.",
  "reputation", "int", "No", "50", "Trust score. Range: 0 <= R <= 100. Initialized to 50 upon registration.",
  "totalVerifications", "int", "No", "0", "Cumulative count of submitted peer reviews. Range: >= 0. Incremented on vote.",
  "isAdmin", "boolean", "No", "false", "System moderation flag. Grants access to expedited review flagging tools.",
  "joinedAt", "timestamp", "No", "request.time", "ISO-8601 server timestamp of account creation. Immutable."
)

#v(10pt)

==== 2. `claims` Collection Schema
Path: `/databases/{database}/documents/claims/{claimId}` \
The primary transactional collection containing citizen-submitted forwards, OCR extracted text, verification arrays, and consensus outcomes.

#v(6pt)

#styled-table(
  columns: (1.2in, 0.8in, 0.6in, 0.8in, 1fr),
  headers: ("Field Name", "Type", "Nullable", "Default", "Description & Validation Rules"),
  "id", "string", "No", "Auto", "Unique alphanumeric identifier generated by Firestore or client counter.",
  "text", "string", "No", "N/A", "Normalized body of the forward. Constraints: 10 <= length <= 2000.",
  "category", "string", "No", "N/A", "Enum: ['health', 'political', 'financial', 'religious', 'other'].",
  "status", "string", "No", "'pending'", "Lifecycle state: 'pending' (awaiting quorum) or 'verified' (resolved).",
  "createdAt", "timestamp", "No", "request.time", "Creation timestamp. Immutable after creation.",
  "consensusDeadline", "timestamp", "No", "createdAt + 7d", "Fixed temporal window for community quorum resolution. Immutable.",
  "verifiedAt", "timestamp", "Yes", "null", "Timestamp when 3rd verification was submitted or when marked CONTESTED.",
  "submittedBy", "string", "No", "N/A", "UID of submitting user (or 'anonymous_citizen' for unauthenticated posts).",
  "submittedByName", "string", "No", "N/A", "Display name of submitter (1 <= length <= 100).",
  "imageUrl", "string", "Yes", "null", "Base64 JPEG data URL or external URL. Constraint: length <= 800,000 chars.",
  "verdict", "string", "Yes", "null", "Majority outcome: ['TRUE', 'FALSE', 'MISLEADING', 'UNVERIFIABLE', 'CONTESTED'].",
  "confidenceScore", "int", "Yes", "null", "Computed weighted certainty metric. Closed range: 0 <= C <= 100.",
  "verificationCount", "int", "No", "0", "Count of registered peer verifications. Equal to verifications.length.",
  "verifications", "array<map>", "No", "[]", "Embedded list of verification objects (max capacity: 10).",
  "agreementRatio", "float", "Yes", "null", "Consensus agreement percentage (0.0 <= A <= 100.0).",
  "avgVerifierReputation", "float", "Yes", "null", "Mean reputation of participating verifiers (0.0 <= R <= 100.0).",
  "sourceQualityScore", "float", "Yes", "null", "Mean source authority score (30.0 <= S <= 100.0).",
  "adminFlagged", "boolean", "No", "false", "Expedited review indicator. Only mutable by administrators.",
  "adminFlaggedAt", "timestamp", "Yes", "null", "Timestamp when administrative flag was asserted."
)

#v(10pt)

==== 3. Embedded `verifications` Object Schema
Stored inside the `verifications` array of each document in `/claims/{claimId}`:

#v(6pt)

#styled-table(
  columns: (1.3in, 0.8in, 0.6in, 1fr),
  headers: ("Property Name", "Type", "Nullable", "Description & Integrity Constraints"),
  "id", "string", "No", "Unique verification identifier formatted as v{timestamp}.",
  "claimId", "string", "No", "Foreign Key referencing parent claims.id.",
  "verdict", "string", "No", "Individual rating: ['TRUE', 'FALSE', 'MISLEADING', 'UNVERIFIABLE'].",
  "sourceUrl", "string", "No", "Web citation URL. Must start with http:// or https://. Max 500 chars.",
  "sourceQuality", "string", "No", "Computed tier: 'high' (100), 'medium' (70), or 'low' (30).",
  "explanation", "string", "No", "Fact-checking rationale. Constraint: 50 <= length <= 3000 chars, >= 8 words.",
  "verifierId", "string", "No", "Foreign Key referencing users.uid. Must equal request.auth.uid.",
  "verifierName", "string", "No", "Cached display name of the verifier at verification time. Max 100 chars.",
  "verifierReputation", "int", "No", "Cached reputation score of verifier at time of vote (0 <= R <= 100).",
  "createdAt", "timestamp", "No", "Timestamp when verification was recorded."
)

#v(10pt)

==== 4. `notifications` and `reports` Collection Schemas

#v(6pt)

#styled-table(
  columns: (1.1in, 1.1in, 0.8in, 0.6in, 1fr),
  headers: ("Collection", "Field Name", "Type", "Nullable", "Description & Constraints"),
  "notifications", "id", "string", "No", "Unique notification ID. Primary Key.",
  "notifications", "userId", "string", "No", "Target recipient (users.uid). Indexed for owner query.",
  "notifications", "type", "string", "No", "Enum: ['claim_verified', 'reputation_update', 'weekly_report'].",
  "notifications", "title / msg", "string", "No", "Alert heading (<= 200 chars) and detailed message (<= 2000 chars).",
  "notifications", "isRead", "boolean", "No", "Read status indicator. Default: false.",
  "reports", "id", "string", "No", "Unique report identifier.",
  "reports", "reportedBy", "string", "No", "UID of reporter. Must equal request.auth.uid.",
  "reports", "targetType / id", "string", "No", "Entity type ('claim' or 'user') and target identifier.",
  "reports", "reason / details", "string", "No", "Flagging category ('spam', 'offensive', 'collusion') and detail notes."
)

== Data Integrity and Security Constraints

In a serverless NoSQL architecture lacking traditional SQL foreign key triggers and relational cascades, data integrity must be programmatically enforced at the database boundary. FactStamp accomplishes this via declarative rules defined in `firestore.rules`.

=== Referential Integrity & Anti-Orphan Guarantees
- *Denormalization Trade-off:* Verifier profile attributes (`verifierName`, `verifierReputation`) are denormalized and captured snapshot-style inside the `verifications` array of a claim. This guarantees that subsequent changes to a user's display name or reputation do not retroactively distort historical consensus computations.
- *Cascade Containment:* Deleting a user account does not invalidate past community verifications; the evidentiary contribution remains anchored in the claim's tamper-proof audit trail.
- *Atomicity via Pre-Condition Assertions:* In Firestore, array updates on `/claims/{claimId}` assert that the array length matches current expectations (`request.resource.data.verificationCount == resource.data.verificationCount + 1`), preventing race conditions when two verifiers submit simultaneously.

=== Core Security Invariants in `firestore.rules`

==== Invariant A: Immutability of Core Claim Identity
Once a citizen submits a claim, its substantive facts cannot be altered by subsequent verifiers or malicious actors:

```javascript
// Helper to verify a field's value did not change during update
function isUnchanged(field) {
  return request.resource.data.get(field, null) == resource.data.get(field, null);
}

// Enforces absolute immutability of claim identity properties
function identityUnchanged() {
  return isUnchanged('text')
    && isUnchanged('category')
    && isUnchanged('submittedBy')
    && isUnchanged('submittedByName')
    && isUnchanged('createdAt')
    && isUnchanged('consensusDeadline')
    && isUnchanged('imageUrl');
}
```

==== Invariant B: Verifier Identity & Self-Verification Lock
To eliminate conflicts of interest and Sybil manipulation, a user cannot submit a verification where the `verifierId` does not match their authenticated session, nor can they verify their own submitted claim:

```javascript
// From match /claims/{claimId} update rule (Case C: Adding verification):
allow update: if request.auth != null
  && (
    identityUnchanged()
    // Verification count must strictly increment by 1
    && request.resource.data.verificationCount == resource.data.verificationCount + 1
    // Existing verifications array must be strictly preserved without deletion
    && request.resource.data.verifications.hasAll(resource.data.verifications)
    // The newly appended element must belong to the authenticated caller
    && request.resource.data.verifications[resource.data.verifications.size()].verifierId == request.auth.uid
    // The claimed reputation must match the official server-side user document
    && request.resource.data.verifications[resource.data.verifications.size()].verifierReputation 
       == get(/databases/$(database)/documents/users/$(request.auth.uid)).data.reputation
    // Submitter cannot verify their own claim (Self-Verification Lock)
    && resource.data.submittedBy != request.auth.uid
  );
```

==== Invariant C: Strict Privilege Separation on User Profiles
Users can modify their own display name, but cannot elevate their reputation or grant themselves administrator status:

```javascript
match /users/{uid} {
  allow read: if request.auth != null;
  allow update: if request.auth != null && (
    isAdmin() ||
    (
      request.auth.uid == uid
      && isUnchanged('uid')
      && isUnchanged('email')
      && isUnchanged('joinedAt')
      && isUnchanged('reputation')
      && isUnchanged('totalVerifications')
      && isUnchanged('isAdmin')
      && request.resource.data.displayName is string
      && request.resource.data.displayName.size() <= 100
    )
  );
}
```

=== Structural Boundary & Payload Ceilings

To prevent denial-of-service via resource exhaustion and guarantee adherence to Firestore's $1"MiB"$ document ceiling, the schema enforces hard byte and character boundaries:

#v(6pt)

#styled-table(
  columns: (1.2in, 1.3in, 1.1in, 1.1in, 1fr),
  headers: ("Target Entity", "Target Attribute", "Lower Boundary", "Upper Boundary", "Enforcement Mechanism"),
  "Claim", "text", "10 characters", "2,000 characters", "firestore.rules string size check",
  "Claim", "imageUrl (base64)", "0 characters", "800,000 characters", "firestore.rules size check (~600 KB)",
  "Verification", "explanation", "50 characters", "3,000 characters", "Client heuristic + firestore.rules",
  "Verification", "sourceUrl", "10 characters", "500 characters", "Regex ^https?://.+ protocol check",
  "User", "reputation", "0", "100", "Range assertion in security rules",
  "Notification", "message", "1 character", "2,000 characters", "firestore.rules string size check"
)
