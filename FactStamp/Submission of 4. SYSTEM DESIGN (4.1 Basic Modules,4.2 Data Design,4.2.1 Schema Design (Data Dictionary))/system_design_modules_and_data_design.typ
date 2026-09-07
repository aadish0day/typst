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

// Mandatory Rule: New topic on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

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
    size: 8.5pt,
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

#set document(title: "FactStamp - Chapter 4: System Design (4.1 Basic Modules, 4.2 Data Design)", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[CHAPTER 4: SYSTEM DESIGN]
    #v(2pt)
    #text(size: 10.5pt)[*4.1 Basic Modules, 4.2 Data Design & 4.2.1 Schema Design (Data Dictionary)*]
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
// CHAPTER 4: SYSTEM DESIGN
// =============================================================================
= Chapter 4: System Design

System design serves as the fundamental bridge transforming the functional requirements and analytical specifications of *FactStamp* into a concrete, resilient, and scalable technical architecture. Addressing the viral proliferation of misinformation across WhatsApp closed chat networks in India requires a system architecture that achieves high throughput, near-instantaneous client-side responsiveness, zero cloud operational overhead, and robust defense against coordinated Sybil manipulation.

This chapter details the modular breakdown of the platform, the underlying data architecture, and the formal schema specifications governing persistent data stores.

== 4.1 Basic Modules

The architecture of FactStamp is organized into eight loosely coupled, functionally cohesive basic modules. These modules cleanly delineate responsibilities across content ingestion, mathematical similarity gating, decentralized community peer review, algorithmic consensus calculation, visual artifact synthesis, macro-level analytical intelligence, and holistic system security.

#styled-table(
  columns: (0.7in, 1.4in, 1.3in, 2.0in),
  headers: ("Module #", "Module Name", "Primary Layer", "Core Functional Responsibility"),
  "Module 1", "Authentication & Reputation Subsystem", "Identity & Access Control", "Firebase Auth (OIDC, RS256 JWT), user profile management, reputation accounting ($0 <= R <= 100$).",
  "Module 2", "Multimodal Forward Ingestion & OCR", "Client Ingestion Gateway", "Plaintext sanitization, screenshot validation, HTML5 canvas downscaling ($< 700$ KB), in-browser WASM OCR.",
  "Module 3", "Jaccard Duplicate Detection Engine", "Deduplication & Rerouting", "Word-level token inversion, stop-word filtering ($|w| > 3$), Jaccard similarity thresholding ($J >= 0.75$).",
  "Module 4", "Decentralized Quorum Verification Queue", "Crowdsourced Peer Review", "Public verification workbench, 3-verifier quorum mandate ($N >= 3$), citation & explanation validation, 7-day expiry.",
  "Module 5", "Weighted Confidence Scoring & Consensus", "Consensus Mathematics", "Tri-partite weighted consensus ($40A + 30R + 30S$), majority verdict election, domain authority scoring, reputation deltas.",
  "Module 6", "High-Fidelity Fact-Check Card Generator", "Dissemination & Graphics", "Browser-native SVG `<foreignObject>` canvas rasterization, 1080x1080 high-DPI shareable PNG card generation.",
  "Module 7", "Trending Misinformation Analytics", "Analytical Intelligence", "7-day rolling window misinformation radar, category frequency distribution, verifier leaderboards.",
  "Module 8", "System Security & Anti-Sybil Subsystem", "Defense-in-Depth", [Self-verification lock ($P_"self"$), single vote constraint, 30-min session timeout, 5-attempt brute-force throttling.]
)

#pagebreak()

=== Architectural Interconnection & Subsystem Workflow

The systemic orchestration and data communication pathways among the eight basic modules are illustrated below:

#v(8pt)
#responsive-image("attachments/system_modules_architecture.svg", width: 95%, max-height: 540pt)

#pagebreak()

=== Comprehensive Subsystem Analysis

==== 1. Module 1: Authentication & Verifier Reputation Subsystem
- *Identity Infrastructure:* Built on Firebase Authentication utilizing OpenID Connect (OIDC) protocols. Verifiers authenticate via email/password credentials or Google OAuth 2.0 Identity Federation, receiving cryptographically signed RS256 JSON Web Tokens (JWT).
- *Zero-Barrier Reading & Ingestion:* Citizens submitting forwards or viewing debunked dossiers require zero authentication. Authentication is strictly demanded only when exercising evidentiary review or casting consensus votes.
- *Reputation Economics:* Each verifier possesses a dynamic trust equity score $R in [0, 100]$ initialized at $R_0 = 50$. When a claim achieves consensus, participating verifiers receive $+2$ reputation points for agreeing with the majority verdict and $-1$ point for dissenting.

==== 2. Module 2: Multimodal Forward Ingestion & Preprocessing Subsystem (with OCR Pipeline)
- *Dual-Channel Ingestion:* Accepts raw forwarded plaintext ($20$ to $500$ characters) and screenshot image uploads (JPEG, PNG, WebP, GIF up to $5$ MB).
- *Client-Side Canvas Downscaling:* Avoids recurring cloud storage bucket egress charges by downscaling screenshots directly in browser memory via an off-screen HTML5 `<canvas>` element bounded to $1280 "px"$ maximum dimension.
- *Base64 Direct Embedding Budget:* Executes iterative quality reduction ($0.72$ down to $0.40$ by $0.08$ steps) to guarantee the encoded base64 payload remains strictly below $700 "KB"$, permitting direct persistence within the Firestore claim document without violating Firestore's $1 "MiB"$ ceiling.
- *In-Browser WASM OCR:* Integrates Tesseract.js running in a WebAssembly background worker to transcribe text from screenshots locally, protecting user privacy and eliminating third-party Vision API fees.

==== 3. Module 3: Jaccard Duplicate Detection Engine
- *Mathematical Foundation:* Computes the word-level Jaccard similarity coefficient between incoming submissions and the existing claim corpus:
  $ J(A, B) = frac(|A inter B|, |A union B|) = frac(|A inter B|, |A| + |B| - |A inter B|) $
- *Lexical Token Inversion:* Normalizes text (lowercase folding, punctuation excision, whitespace collapsing) and discards syntactic particles with $|w| <= 3$.
- *Bifurcated Threshold Routing:* If $max_k J(A, B_k) >= 0.75$, the submission is identified as an existing rumor; the user is immediately halted and redirected to the existing dossier. If $J < 0.75$, the claim is enqueued as a novel entity.

==== 4. Module 4: Decentralized Quorum Verification Queue
- *Quorum Requirement:* Enforces a strict minimum of three ($N >= 3$) independent community evaluations before transitioning a claim from `'pending'` to `'verified'`.
- *Verdict Lexicon:* Verifiers choose from four formal truth categories: `TRUE`, `FALSE`, `MISLEADING`, and `UNVERIFIABLE`.
- *Evidence Standard:* Every vote mandates a verified HTTP/HTTPS citation and an explanatory rationale containing at least $50$ characters and $8$ words.
- *Temporal Expiry:* Claims maintain a 7-day consensus window ($T_"deadline" = T_"created" + 7 "days"$). Claims failing to reach quorum upon expiration are resolved under the status `CONTESTED`.

#pagebreak()

==== 5. Module 5: Weighted Confidence Scoring & Consensus Engine
- *Tri-Partite Formula:* Eliminates naive democratic vulnerability to sockpuppet brigading by computing confidence through three weighted vectors:
  $ C = min(100, max(0, round(0.40 times A + 0.30 times R + 0.30 times S))) $
  Where $A$ is the agreement ratio ($%$) concurring with majority verdict, $R$ is average verifier reputation, and $S$ is average source domain authority.
- *Domain Authority Tiers:* Classifies citations dynamically: Tier 1 High Quality ($S = 100$, e.g., official government portals, WHO, gazettes), Tier 2 Medium Quality ($S = 70$, e.g., recognized mainstream press), and Tier 3 Low Quality ($S = 30$, unverified blogs and social links).

==== 6. Module 6: High-Fidelity Fact-Check Card Generator
- *Browser-Native Rasterization:* Serializes live DOM components into an SVG `<foreignObject>` container via `html-to-image`, drawing directly to canvas at C++ browser execution speed.
- *WhatsApp-Optimized Form Factor:* Outputs a pixel-perfect $1080 times 1080 "px"$ PNG card featuring a Deep Saffron banner, case identifier, truncated claim text, tilted rubber-stamp verdict badge, confidence meter, and authoritative source tags.

==== 7. Module 7: Trending Misinformation Analytics Dashboard
- *Rolling 7-Day Misinformation Radar:* Aggregates weekly submission volumes across five categories: Health, Political, Financial, Religious, and Other.
- *Public Intelligence Ledger:* Surfaces top debunked claims and ranks top verifiers by cumulative accuracy and consensus alignment.

==== 8. Module 8: System Security, Anti-Sybil Defense & Real-Time Alerts
- *Self-Verification Prevention Lock ($P_"self"$):* Users are mathematically prohibited from evaluating claims they submitted ($u."uid" eq.not c."submittedBy"$).
- *Brute-Force & Session Protection:* Implements 5-attempt exponential brute-force throttling ($15$-minute lockout) and automatic 30-minute inactivity session invalidation.

#pagebreak()

== 4.2 Data Design

Data design is a cornerstone of FactStamp's engineering architecture. The platform requires real-time synchronization, atomic quorum updates, high read throughput during viral misinformation spikes, and zero operational infrastructure costs.

=== Database Paradigm Selection: NoSQL Document Store vs. RDBMS
FactStamp deploys *Google Cloud Firestore*, a fully managed, serverless, document-oriented NoSQL database. The architectural trade-offs that dictated this selection over traditional relational databases (such as PostgreSQL or MySQL) are detailed below:

#styled-table(
  columns: (1.2in, 1.3in, 1.4in, 1.5in),
  headers: ("Evaluation Criterion", "Relational Database (RDBMS)", "Cloud Firestore (NoSQL)", "FactStamp Architectural Justification"),
  "Data Model Flexibility", "Rigid tabular schemas; DDL migrations require table locking.", "Flexible BSON/JSON document trees; dynamic schema evolution.", "Claim payloads vary widely from short plain text to rich base64 image data and variable verifier arrays.",
  "Real-Time Reactive Synchronization", "Requires external WebSocket brokers (Socket.io) or polling loops.", "Native WebSocket listeners (`onSnapshot`) built into client SDKs.", "Essential for real-time collaboration: verifiers and citizens see quorum steppers advance live.",
  "Atomic Read Efficiency", "Requires multi-table SQL joins across `claims`, `verifications`, and `users`.", "Embedded denormalized arrays inside root claim documents.", "A single document read retrieves the entire claim dossier, eliminating relational join latency.",
  "Operational Cost & Sustainability", "Continuous compute billing for active instances ($15–$60/mo).", "Serverless consumption model with generous free Spark tier ($0/mo).", "Preserves a 100% free-tier architecture for permanent civic accessibility without server upkeep costs."
)

=== Conceptual Entity-Relationship (E-R) Model
The data model encompasses five primary entities: `USERS`, `CLAIMS`, `VERIFICATIONS`, `NOTIFICATIONS`, and `REPORTS`. Embedded denormalization is leveraged for high-frequency queries while relational consistency is enforced via Firestore security assertions.

#v(8pt)
#responsive-image("attachments/er_schema.svg", width: 95%, max-height: 520pt)

#pagebreak()

== 4.2.1 Schema Design (Data Dictionary)

The physical schema of FactStamp is organized into collections of JSON-like document structures. Each collection schema and embedded entity is formally specified below in compliance with university documentation standards.

=== 1. `users` Collection Schema
Path: `/databases/{database}/documents/users/{uid}` \
The `users` collection maintains authenticated verifier identity profiles, role-based privileges, and historical reputation scores.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Field Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "uid", "string", "No", "N/A", "Firebase Auth unique identifier (RS256 JWT subject). Primary Key.",
  "displayName", "string", "No", "N/A", "Public verifier name or pseudonym ($1 <= len <= 100$ characters).",
  "email", "string", "No", "N/A", "Verified email address; must match `request.auth.token.email`.",
  "avatarUrl", "string", "Yes", "null", "Optional URI pointing to user profile avatar or generated monogram.",
  "reputation", "int", "No", "50", "Trust equity score. Range: $0 <= R <= 100$. Immutable by the user.",
  "totalVerifications", "int", "No", "0", "Cumulative count of registered verifications ($>= 0$). Incremented atomically.",
  "isAdmin", "boolean", "No", "false", "Privilege flag granting administrative override and claim flagging powers.",
  "joinedAt", "timestamp", "No", "req.time", "ISO-8601 server timestamp of account creation. Strictly immutable."
)

=== 2. `claims` Collection Schema
Path: `/databases/{database}/documents/claims/{claimId}` \
The core transactional collection containing citizen forward submissions, image payloads, embedded verification arrays, and consensus outcomes.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Field Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "id", "string", "No", "Auto", "Unique alphanumeric identifier assigned by Firestore SDK. Primary Key.",
  "text", "string", "No", "N/A", "Sanitized text of forward. Length constrained: $10 <= len <= 2000$.",
  "category", "string", "No", "N/A", "Category enum: `['health', 'political', 'financial', 'religious', 'other']`.",
  "status", "string", "No", "'pending'", "Lifecycle state: `'pending'` (awaiting quorum) or `'verified'` (resolved/contested).",
  "createdAt", "timestamp", "No", "req.time", "Server timestamp of claim creation. Strictly immutable.",
  "consensusDeadline", "timestamp", "No", "+ 7 days", "Fixed 7-day window for community verification. Strictly immutable.",
  "verifiedAt", "timestamp", "Yes", "null", "Server timestamp when 3rd vote was recorded or marked CONTESTED.",
  "submittedBy", "string", "No", "N/A", "UID of submitter or `'anonymous_citizen'`. Used for self-verification lock.",
  "submittedByName", "string", "No", "N/A", "Display name of citizen submitter ($1 <= len <= 100$).",
  "imageUrl", "string", "Yes", "null", "Base64 JPEG data URL ($<= 700$ KB, string length $<= 800,000$ characters).",
  "verdict", "string", "Yes", "null", "Consensus verdict: `['TRUE', 'FALSE', 'MISLEADING', 'UNVERIFIABLE', 'CONTESTED']`.",
  "confidenceScore", "int", "Yes", "null", "Computed weighted confidence metric. Closed integer range: $0 <= C <= 100$.",
  "verificationCount", "int", "No", "0", "Integer count of verifications recorded. Equal to `verifications.length` ($0..10$).",
  "verifications", "array<map>", "No", "[]", "Embedded list of up to 10 verification objects (detailed in Table 3).",
  "agreementRatio", "float", "Yes", "null", "Percentage of verifiers concurring with majority outcome ($0.0 <= A <= 100.0$).",
  "avgVerifierReputation", "float", "Yes", "null", "Arithmetic mean reputation of participating verifiers ($0.0 <= R <= 100.0$).",
  "sourceQualityScore", "float", "Yes", "null", "Arithmetic mean source quality score ($30.0 <= S <= 100.0$).",
  "adminFlagged", "boolean", "No", "false", "Expedited review indicator. Only modifiable by admin users.",
  "adminFlaggedAt", "timestamp", "Yes", "null", "Server timestamp when administrative priority flag was applied."
)

#pagebreak()

=== 3. Embedded `verifications` Array Schema
Stored as a typed map array directly within `/claims/{claimId}.verifications`. Embedding verification objects inside the claim document guarantees atomic single-read dossier hydration.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Property Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "id", "string", "No", "Auto", "Unique verification identifier formatted as `v{timestamp}`.",
  "claimId", "string", "No", "N/A", "Foreign key referencing parent claim ID (`claims.id`).",
  "verdict", "string", "No", "N/A", "Individual rating enum: `['TRUE', 'FALSE', 'MISLEADING', 'UNVERIFIABLE']`.",
  "sourceUrl", "string", "No", "N/A", "Evidentiary citation URL. Must start with `http://` or `https://` ($<= 500$ chars).",
  "sourceQuality", "string", "No", "N/A", "Domain authority classification: `'high'` (100), `'medium'` (70), `'low'` (30).",
  "explanation", "string", "No", "N/A", "Research reasoning ($50 <= len <= 3000$ characters, minimum 8 words).",
  "verifierId", "string", "No", "N/A", "Foreign key referencing `users.uid`. Must strictly match `request.auth.uid`.",
  "verifierName", "string", "No", "N/A", "Snapshot of verifier's display name at vote time ($1 <= len <= 100$).",
  "verifierReputation", "int", "No", "N/A", "Snapshot of verifier's reputation score at vote time ($0 <= R <= 100$).",
  "createdAt", "timestamp", "No", "req.time", "Server timestamp when verification record was appended."
)

=== 4. `notifications` Collection Schema
Path: `/databases/{database}/documents/notifications/{id}` \
Stores asynchronous in-app alerts dispatched to verifiers and claim submitters upon consensus resolution or reputation updates.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Field Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "id", "string", "No", "Auto", "Unique notification identifier. Primary Key.",
  "userId", "string", "No", "N/A", "Recipient user foreign key (`users.uid`). Indexed for owner query.",
  "type", "string", "No", "N/A", "Enum: `['claim_verified', 'reputation_update', 'weekly_report', 'verdict_submitted']`.",
  "title", "string", "No", "N/A", "Summary title of notification ($1 <= len <= 200$ characters).",
  "message", "string", "No", "N/A", "Detailed notification text ($1 <= len <= 2000$ characters).",
  "isRead", "boolean", "No", "false", "Read status indicator. Toggled upon user interaction.",
  "claimId", "string", "Yes", "null", "Optional foreign key pointing to the referenced claim document.",
  "createdAt", "timestamp", "No", "req.time", "Server timestamp of notification dispatch."
)

=== 5. `reports` Collection Schema
Path: `/databases/{database}/documents/reports/{id}` \
Facilitates community moderation, allowing users to report abusive claims, toxic explanations, or suspicious sockpuppet activities.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Field Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "id", "string", "No", "Auto", "Unique moderation report identifier. Primary Key.",
  "reportedBy", "string", "No", "N/A", "UID of reporting user (`users.uid`).",
  "targetType", "string", "No", "N/A", "Entity classification enum: `'claim'` or `'user'`.",
  "targetId", "string", "No", "N/A", "Identifier of the reported claim (`claims.id`) or user (`users.uid`).",
  "reason", "string", "No", "N/A", "Reason enum: `['hate_speech', 'harassment', 'spam', 'sybil_manipulation']`.",
  "severity", "string", "No", "'medium'", "Severity tier: `'low'`, `'medium'`, or `'high'`.",
  "details", "string", "Yes", "null", "Optional descriptive context ($<= 1000$ characters).",
  "status", "string", "No", "'open'", "Moderation resolution state: `'open'`, `'investigating'`, `'resolved'`, `'dismissed'`.",
  "createdAt", "timestamp", "No", "req.time", "Server timestamp when report was filed."
)

#pagebreak()

=== 6. `audit_logs` Collection Schema
Path: `/databases/{database}/documents/audit_logs/{id}` \
Immutable security audit ledger recording all privileged administrative interventions, claim flagging actions, and system overrides.

#styled-table(
  columns: (1.1in, 0.7in, 0.5in, 0.6in, 2.5in),
  headers: ("Field Name", "Type", "Null", "Default", "Description & Integrity Constraints"),
  "id", "string", "No", "Auto", "Unique audit event identifier. Primary Key.",
  "adminUid", "string", "No", "N/A", "UID of executing administrator (`users.uid`). Must satisfy `isAdmin == true`.",
  "action", "string", "No", "N/A", "Action enum: `['flag_claim', 'unflag_claim', 'override_verdict', 'ban_user']`.",
  "targetClaimId", "string", "Yes", "null", "Associated claim identifier if applicable.",
  "targetUserId", "string", "Yes", "null", "Associated target user identifier if applicable.",
  "rationale", "string", "No", "N/A", "Mandatory justification for administrative intervention ($10 <= \"len\" <= 1000$).",
  "timestamp", "timestamp", "No", "req.time", "Immutable server timestamp of action execution."
)

=== Storage Footprint & Document Boundary Guarantees
Google Cloud Firestore enforces a strict hard ceiling of $1 "MiB"$ ($1,048,576 "bytes"$) per document. To guarantee absolute compliance without risking transaction aborts:

1. *Claim Text Bound:* Constrained to $2,000$ UTF-8 characters ($<= 8 "KB"$).
2. *Base64 Image Bound:* Constrained to $800,000$ characters ($<= 600 "KB"$).
3. *Verifications Capacity:* Bounded to a maximum of $10$ embedded verification objects ($<= 10 times 4 "KB" = 40 "KB"$).
4. *Total Worst-Case Claim Document Size:*
   $ "Size"_"max" approx 8 "KB" ("text") + 600 "KB" ("image") + 40 "KB" ("verifications") + 2 "KB" ("metadata") = 650 "KB" $
   $ 650 "KB" << 1,048 "KB" (62\% "of maximum ceiling") $

This mathematical boundary design proves that FactStamp documents operate safely within free-tier resource budgets, providing guaranteed stability across production workloads.
