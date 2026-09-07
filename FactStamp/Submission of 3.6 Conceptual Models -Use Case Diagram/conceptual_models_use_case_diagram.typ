// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // 1.5in binding margin
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

// Typography & Font Configuration
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

#show heading.where(level: 1): set text(size: 15pt, weight: "bold")
#show heading.where(level: 2): set text(size: 13pt, weight: "bold")
#show heading.where(level: 3): set text(size: 11.5pt, weight: "bold")

// Global Table Cell Styling
#show table.cell: set text(size: 9pt)
#show table.cell.where(y: 0): set text(size: 9pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 4.5pt, y: 4pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 9pt)[#cell])
)

// Responsive Image Helper
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Conceptual Models: Use Case Diagram", author: "Aadish")

// ==========================================
// Standalone Academic Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[ACADEMIC COURSE SUBMISSION]
    #v(4pt)
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: USE CASE MODEL & DETAILED SPECIFICATIONS]
    #v(2pt)
    #text(size: 10.5pt)[*Functional Requirement Modeling, Actor Taxonomies & Use Case Realization*]
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
// 3.6 CONCEPTUAL MODELS: USE CASE DIAGRAM
// =============================================================================
= Conceptual Models: UML Use Case Model

== Foundations of Use Case Modeling in Civic Verification Systems
Use case modeling establishes a behavioral and functional baseline for software architecture. In distributed, civic-tech environments such as FactStamp, use cases bridge the divide between unstructured human communication (specifically viral chain messages, hoaxes, and manipulated screenshots in private messaging apps like WhatsApp) and rigorous, decentralized verification workflows.

The Unified Modeling Language (UML) Use Case diagram formalizes:
1. *System Boundary:* The boundary isolating client-side user operations, automated serverless processing agents, and sovereign web endpoints.
2. *Actor Taxonomies:* The functional classifications of human and automated entities that initiate or respond to system actions.
3. *Functional Dependencies:* Stereotyped associations including `<<include>>` for mandatory behavioral decomposition, `<<extend>>` for conditional functional paths, and `<<trigger>>` for reactive asynchronous processing.

== Actor Classifications and System Boundary
FactStamp delineates four distinct actors participating in the verification ecosystem, comprising three human user classes and one automated background system actor.

#styled-table(
  columns: (1.2in, 1.0in, 1.2in, 1fr),
  headers: ("Actor Name", "Actor Type", "Authentication Required", "Operational Scope & Responsibilities"),
  "Public Submitter", "Human (Primary)", "No (Zero-friction anonymous)", "Receives viral WhatsApp forwards; submits text or screenshots for verification; views certified claim dossiers; downloads shareable 1080x1080px Fact Cards.",
  "Community Verifier", "Human (Primary)", "Yes (Firebase Auth JWT)", "Reviews pending verification queue; searches sovereign registries; casts structured verdicts with authoritative URLs and rationales; accumulates civic reputation.",
  "Platform Administrator", "Human (Secondary)", "Yes (RBAC: isAdmin=true)", "Audits contested or split-decision claims; monitors Sybil voting anomalies; reviews weekly misinformation category radar trends; flags malicious actors.",
  "Automated System Engine", "System / Background", "Internal / Cloud Run", "Executes automated OCR text extraction; runs Jaccard token duplicate detection; computes multi-factor weighted consensus; handles 7-day expiration timeouts."
)

#pagebreak()

== UML Use Case Diagram
The formal UML Use Case Diagram illustrates the functional decomposition of FactStamp, depicting actor interactions, included routines, and conditional extension points.

#v(8pt)
#responsive-image("attachments/use_case_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp Comprehensive UML Use Case Diagram*]

#pagebreak()

== Exhaustive Formal Use Case Specifications

=== UC1: Submit WhatsApp Forward for Verification
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC1",
  "Use Case Name", "Submit WhatsApp Forward for Verification",
  "Primary Actor", "Public Submitter (Citizen / WhatsApp Recipient)",
  "Stakeholders", "WhatsApp chat group participants seeking factual validation.",
  "Preconditions", "User has navigated to FactStamp web application (`/submit`). No account creation or authentication is required.",
  "Trigger", "User pastes forwarded message text or uploads a screenshot and clicks 'Verify Claim'.",
  "Main Success Scenario", [
    1. Submitter pastes message text into the input field or uploads an image file.\
    2. Submitter selects topical category (`Health`, `Politics`, `Finance`, `Religion`, `Other`).\
    3. Submitter clicks 'Verify Claim'.\
    4. System sanitizes input string and eliminates script tags.\
    5. System invokes UC3 (Detect Duplicate Claim) via mandatory `<<include>>` dependency.\
    6. If unique ($J < 0.75$), system creates a new document in `/claims` with status `unverified` and initial quorum count $0$.\
    7. System displays submission confirmation screen with unique tracking ID and shareable status URL.
  ],
  "Alternative Flows", [
    *2a. Screenshot Ingestion Pathway (UC2 `<<extend>>`):*\
    User uploads `.jpg`, `.png`, or `.webp` file. System validates magic bytes, resizes image on HTML5 canvas ($<= 1280$px, $< 700$ KB), invokes OCR engine to extract text, and populates editable text box for confirmation before Proceeding to Step 4.\
    *5a. Duplicate Forward Detected:*\
    UC3 calculates $J(A, B) >= 0.75$. System halts novel ticket creation, increments duplicate hit counter, and immediately redirects user to the existing certified Fact Dossier.
  ],
  "Postconditions", "Unique claim is persisted in Firestore, indexed in the verification queue, and real-time listeners are alerted.",
  "Traceability", "IEEE Std 830 REQ-1 (Multimodal Forward Ingestion) & REQ-2 (Sanitization & Normalization)."
)

#v(10pt)

=== UC2: Extract Screenshot Text via OCR
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC2",
  "Use Case Name", "Extract Screenshot Text via OCR Pipeline",
  "Primary Actor", "Automated System Engine (triggered by Public Submitter)",
  "Preconditions", "Image payload satisfies MIME type whitelisting and magic byte header verification.",
  "Main Success Scenario", [
    1. Canvas downscaler converts raw bitmap into WebP/JPEG representation.\
    2. Engine executes OCR optical character recognition pass.\
    3. Extracted text is filtered for unicode control characters and normalized.\
    4. Normalized text payload is returned to the ingestion controller.
  ],
  "Alternative Flows", [
    *1a. Invalid Magic Bytes:* Image header indicates corrupted or executable payload -> System aborts upload with HTTP 422.\
    *2a. Low Contrast / Unreadable Image:* OCR returns empty string -> User is prompted to manually type the visible claim text.
  ],
  "Postconditions", "Machine-readable transcription is generated and forwarded to duplicate detector."
)

#pagebreak()

=== UC3: Detect Duplicate Claim via Jaccard Similarity
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC3",
  "Use Case Name", "Detect Duplicate Claim via Lexical Set Similarity",
  "Primary Actor", "Automated System Engine",
  "Preconditions", "Normalized text string with length $20 <= L <= 500$ characters is provided.",
  "Main Success Scenario", [
    1. System decomposes incoming text string $A$ into a set of normalized lexical tokens.\
    2. System filters stop words and tokens with length $<= 3$ characters.\
    3. System queries Firestore for active and resolved claims in the matching category.\
    4. For each existing claim $B_k$, system computes Jaccard similarity index:\
       $J(A, B_k) = (|A inter B_k|) / (|A union B_k|)$\
    5. If $max_k J(A, B_k) >= 0.75$, claim is classified as a duplicate cluster instance.\
    6. System links incoming forward to canonical claim ID in `/duplicateClusters` and redirects client.
  ],
  "Alternative Flows", [
    *5a. Low Similarity ($J < 0.75$):* Claim is classified as a novel submission and enters public queue.
  ],
  "Postconditions", "Redundant claim tickets are prevented; community review effort is concentrated on unique rumors.",
  "Traceability", "IEEE Std 830 REQ-3 (Duplicate Detection & Deduplication)."
)

#v(10pt)

=== UC4: Browse Pending Quorum Verification Queue
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC4",
  "Use Case Name", "Browse Pending Quorum Verification Queue",
  "Primary Actor", "Community Verifier",
  "Preconditions", "User is logged in via authenticated session.",
  "Main Success Scenario", [
    1. Verifier navigates to `/queue` dashboard.\
    2. System loads claims with status `unverified` ordered by submission timestamp and viral velocity.\
    3. Verifier filters claims by category (`Health`, `Politics`, `Finance`, `Religion`, `Other`) or search term.\
    4. Verifier selects an unverified claim card to open the complete Verification Dossier.
  ],
  "Postconditions", "Detailed claim dossier including media, submitter notes, and existing quorum count is presented."
)

#pagebreak()

=== UC5: Submit Verification Vote with Primary Citation
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC5",
  "Use Case Name", "Submit Verification Vote with Primary Citation and Rationale",
  "Primary Actor", "Community Verifier",
  "Preconditions", "Verifier is authenticated; verifier is not the author of the claim (`submittedBy != auth.uid`).",
  "Trigger", "Verifier clicks 'Submit Assessment'.",
  "Main Success Scenario", [
    1. Verifier selects verdict enum (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`).\
    2. Verifier inputs primary authoritative citation URL (e.g., `pib.gov.in`, `rbi.org.in`, `who.int`).\
    3. Verifier inputs factual rationale explanation ($>= 50$ characters, $>= 8$ words).\
    4. System validates citation URL protocol (`https://`) and checks anti-spam heuristics.\
    5. System writes verification document to `/claims/{id}/verifications/{vid}`.\
    6. System atomically increments `claim.quorumCount` by $+1$.\
    7. If `quorumCount >= 3`, system invokes UC6 (Compute Quorum Consensus) via `<<trigger>>` dependency.
  ],
  "Alternative Flows", [
    *4a. Self-Verification Lock Violation:*\
    System detects `claim.submittedBy == auth.uid` -> Security rule rejects write with code 403 Forbidden.\
    *4b. Duplicate Vote Attempt:*\
    Verifier has already submitted a verdict on this claim -> System prevents overwrite.
  ],
  "Postconditions", "Vote is permanently appended to claim verification subcollection.",
  "Traceability", "IEEE Std 830 REQ-4 (Quorum-Based Peer Review) & REQ-5 (Domain Authority Scoring)."
)

#v(10pt)

=== UC6: Calculate Weighted Quorum Consensus
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC6",
  "Use Case Name", "Calculate Weighted Quorum Consensus",
  "Primary Actor", "Automated System Engine",
  "Preconditions", "Claim has reached quorum threshold ($N >= 3$).",
  "Main Success Scenario", [
    1. Engine retrieves all verification documents for the claim.\
    2. Engine determines plurality verdict candidate $V_("maj")$.\
    3. Engine computes Agreement Ratio: $A = (N_("majority") / N_("total")) times 100$.\
    4. Engine calculates average verifier reputation: $R = (1 / N) sum R_i$.\
    5. Engine maps citation domains to authoritative tiers ($S_i in {100, 70, 30}$) and calculates $S = (1 / N) sum S_i$.\
    6. Engine computes composite confidence: $C = round(0.40 A + 0.30 R + 0.30 S)$.\
    7. If $C >= 70.0%$, claim status is updated to `verified` with certified verdict $V_("maj")$.\
    8. Participating consensus verifiers receive $+2$ reputation points; dissenting verifiers receive $-1$ point.
  ],
  "Alternative Flows", [
    *7a. Low Confidence Consensus ($C < 70.0%$ or 7-day expiration):*\
    Claim is tagged as `CONTESTED` and flagged for administrative inspection.
  ],
  "Postconditions", "Certified verdict and confidence percentage are stamped on claim document.",
  "Traceability", "IEEE Std 830 REQ-6 (Multi-Factor Consensus Engine)."
)

#pagebreak()

=== UC7: Generate & Download 1080x1080 Fact-Check PNG Card
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC7",
  "Use Case Name", "Generate & Download 1080x1080px Fact Card",
  "Primary Actor", "Public Submitter / Community Verifier",
  "Preconditions", "Claim has reached certified `verified` status.",
  "Main Success Scenario", [
    1. User clicks 'Download Fact Card' button on verified claim page.\
    2. Client DOM serializer renders high-contrast $1080 times 1080$px card container.\
    3. Card displays rubber-stamp verdict badge, confidence meter, quorum summary, and source citations.\
    4. Library `html-to-image` rasterizes SVG `<foreignObject>` to HTML5 canvas at `pixelRatio: 2`.\
    5. System initiates automated browser file download: `FactStamp-<ClaimID>.png`.
  ],
  "Postconditions", "High-resolution PNG file is saved on user device for forwarding back into WhatsApp.",
  "Traceability", "IEEE Std 830 REQ-7 (Visual Fact Card Generator)."
)

#v(10pt)

=== UC8: View Misinformation Dashboard & Weekly Radar Trends
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC8",
  "Use Case Name", "View Misinformation Dashboard & Weekly Radar Trends",
  "Primary Actor", "Public Submitter / Community Verifier / Platform Administrator",
  "Preconditions", "None (Publicly accessible route `/dashboard`).",
  "Main Success Scenario", [
    1. User navigates to `/dashboard`.\
    2. System queries `/metrics` rollup document in Firestore.\
    3. Interface renders 7-day rolling submission radar, category distribution, and verifier leaderboard.
  ],
  "Postconditions", "Macro-level misinformation intelligence is displayed without executing expensive raw queries.",
  "Traceability", "IEEE Std 830 REQ-8 (Analytics Dashboard)."
)

#v(10pt)

=== UC9: Audit Contested Decisions & Sybil Anomaly Telemetry
#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC9",
  "Use Case Name", "Audit Contested Decisions & Sybil Anomaly Telemetry",
  "Primary Actor", "Platform Administrator",
  "Preconditions", "Authenticated session possessing `isAdmin: true` custom claim.",
  "Main Success Scenario", [
    1. Administrator navigates to `/admin/audit`.\
    2. System queries claims with status `contested` or confidence $C < 70%$.\
    3. Administrator reviews vote distributions, source URLs, and verifier IP/device fingerprints.\
    4. Administrator issues moderation disposition (confirm contested, re-queue, or suspend malicious accounts).
  ],
  "Postconditions", "Platform integrity audit record is updated in administrative audit log.",
  "Traceability", "IEEE Std 830 REQ-9 (Anti-Sybil Defense & Governance)."
)

#pagebreak()

== Use Case Traceability Matrix
The matrix below cross-references each formal use case against the software requirements specification established under IEEE Std 830-1998, verifying full coverage of functional goals.

#styled-table(
  columns: (1.0in, 1.2in, 1.0in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "Primary Use Case", "Verification Method & Architectural Artifact"),
  "REQ-1", "Multimodal Ingestion", "UC1, UC2", "Input validation; HTML5 canvas downscaler; OCR text extraction.",
  "REQ-2", "Text Normalization", "UC1", "Sanitization regex pipelines (`security.ts`); XSS token removal.",
  "REQ-3", "Duplicate Detection", "UC3", "Jaccard similarity calculation engine ($J >= 0.75$ cluster indexing).",
  "REQ-4", "Quorum Review Queue", "UC4, UC5", "Real-time Firestore listeners; minimum quorum threshold $N >= 3$.",
  "REQ-5", "Evidentiary Citation", "UC5", "Tiered domain authority classification matrix (100 / 70 / 30).",
  "REQ-6", "Weighted Consensus", "UC6", "Composite formula $C = 0.40A + 0.30R + 0.30S$; reputation updates.",
  "REQ-7", "Fact Card Export", "UC7", "Square 1:1 ($1080 times 1080$px) SVG `<foreignObject>` canvas rasterization.",
  "REQ-8", "Analytics Radar", "UC8", "Rolling 7-day category aggregations and verifier leaderboard.",
  "REQ-9", "Anti-Sybil Defense", "UC5, UC9", "Self-verification lock; single-vote constraint; admin audit logging.",
  "REQ-10", "Zero-Cost Serverless", "All UC", "Vercel Edge compute; client-side image downscaling; Firestore limits."
)

== Conclusion & Model Integrity
The UML Use Case model comprehensively captures the socio-technical interactions underpinning FactStamp. By formalizing actor permissions, explicit trigger conditions, exception flows, and traceability to IEEE standards, the system guarantees high architectural robustness, zero-cost operational feasibility, and tamper-resistant crowdsourced civic accountability.
