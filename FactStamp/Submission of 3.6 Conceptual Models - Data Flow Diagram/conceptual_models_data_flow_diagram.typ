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
#show table.cell: set text(size: 8.5pt)
#show table.cell.where(y: 0): set text(size: 8.5pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 4.5pt, y: 4pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 8.5pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 8.5pt)[#cell])
)

// Responsive Image Helper
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Conceptual Models: Data Flow Diagrams", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: DATA FLOW DIAGRAMS (LEVEL 0, 1 & 2)]
    #v(2pt)
    #text(size: 10.5pt)[*Structured Process Modeling, Functional Decomposition & Data Dictionaries*]
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
// 3.6 CONCEPTUAL MODELS: DATA FLOW DIAGRAMS
// =============================================================================
= Conceptual Models: Data Flow Diagrams (DFD)

== Foundations of Structured Data Flow Analysis
Data Flow Diagrams (DFDs) constitute a cornerstone of structured systems analysis and software engineering. While object-oriented models focus on modular class structures and message lifelines, DFDs provide a graphical representation of the flow of data through an information system. DFDs model:
1. *Transformational Processes:* Operations that accept input data streams, execute business logic or mathematical algorithms, and emit output data flows.
2. *Data Stores:* Passive repositories holding persisted domain records over time.
3. *External Entities (Terminators):* Autonomous agents outside the boundary of the system acting as data sources or data sinks.
4. *Data Flows:* Directional pipelines conveying structured data payloads between entities, processes, and stores.

Within FactStamp, DFDs model the transformation of raw, unverified WhatsApp rumors into mathematically verified civic fact cards across three levels of hierarchical abstraction:
- *DFD Level 0 (Context Level):* Defines the absolute system boundary and environmental interfaces.
- *DFD Level 1 (System Decomposition):* Decomposes the platform into six major functional subsystems and core Firestore NoSQL data stores.
- *DFD Level 2 (Detailed Functional Decomposition):* Examines low-level algorithmic operations within the Multimodal Ingestion Pipeline (Process 1.0) and Consensus Scoring Engine (Process 4.0).

#pagebreak()

== DFD Level 0: Context Level Diagram

=== System Boundary & External Entities
The Context Level DFD encapsulates FactStamp as a single top-level process (`0.0 FactStamp Misinformation Verification System`) interacting with four primary environmental entities:
1. *Public Submitter (WhatsApp User):* The source of unverified forwards and recipient of certified fact cards.
2. *Community Verifier:* Accredited citizen reviewer who inspects unverified queues and supplies evidentiary citations.
3. *Platform Administrator:* Academic faculty or moderator reviewing contested disputes and auditing telemetry.
4. *WhatsApp Chat Groups (Dark Social):* The social recipient medium where certified Fact Cards are disseminated to neutralize rumors.

=== Visual DFD Level 0 Context Diagram
The formal Context Level DFD is rendered below using top-to-bottom orientation:

#v(8pt)
#responsive-image("attachments/dfd_level_0.svg", width: 90%, max-height: 540pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp Context Level 0 Data Flow Diagram*]

#pagebreak()

=== Context Boundary Inflows and Outflows
#styled-table(
  columns: (1.2in, 1.2in, 1.0in, 1fr),
  headers: ("External Entity", "Flow Label", "Direction", "Data Flow Payload Description"),
  "Public Submitter", "Submit Claim", "Inflow -> System", "Plaintext message string (20-500 chars) or screenshot image file (<= 5 MB).",
  "System", "Instant Verdict", "Outflow -> User", "Immediate certified dossier if submission matches an existing duplicate (J >= 0.75).",
  "System", "Download Fact Card", "Outflow -> User", "Standardized 1080x1080px PNG image displaying certified verdict and source URLs.",
  "System", "Pending Queue", "Outflow -> Verifier", "Stream of unverified claims requiring peer evaluation (quorum count N < 3).",
  "Community Verifier", "Submit Verdict", "Inflow -> System", "Structured vote (TRUE/FALSE/MISLEADING) + primary citation URL + rationale.",
  "System", "Update Reputation", "Outflow -> Verifier", "Adjusted civic reputation score (R in [0, 100]) updated upon consensus.",
  "Platform Admin", "Moderation Directives", "Inflow -> System", "Administrative disposition on contested claims and Sybil account locks.",
  "System", "Telemetry & Audits", "Outflow -> Admin", "7-day category submission radar distributions and anomaly audit logs.",
  "Public Submitter", "Share Fact Card", "Outflow -> WhatsApp", "User forwards downloaded Fact Card back into the origin group chat."
)

#pagebreak()

== DFD Level 1: System Level Diagram

=== Subsystems and Functional Decomposition
The System Level DFD decomposes the monolithic verification process into six distinct operational subsystems:
1. *1.0 Ingestion & OCR Extraction:* Sanitizes plaintext and extracts text from screenshot images via canvas and OCR.
2. *2.0 Jaccard Duplicate Detection Engine:* Computes lexical similarity ($J >= 0.75$) to cluster duplicate chain forwards.
3. *3.0 Quorum Verification Queue Manager:* Coordinates community review, enforcing self-verification locks and collecting $N >= 3$ independent votes.
4. *4.0 Consensus & Confidence Engine:* Executes the multi-factor weighted scoring algorithm: $C = round(0.40A + 0.30R + 0.30S)$.
5. *5.0 Fact-Check Card Generator:* Serializes DOM elements into high-DPI $1080 times 1080$px PNG image cards via `html-to-image`.
6. *6.0 Analytics & Trends Subsystem:* Aggregates weekly category metrics, rolling submission counts, and verifier leaderboards.

=== Visual DFD Level 1 Diagram
The formal System Level DFD illustrating processes, data stores, and data flows is presented below:

#v(8pt)
#responsive-image("attachments/dfd_level_1.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.2: FactStamp System Level 1 Data Flow Diagram*]

#pagebreak()

=== Data Stores Inventory
#styled-table(
  columns: (0.8in, 1.4in, 1.1in, 1fr),
  headers: ("Store ID", "Store Name", "Storage Technology", "Schema & Operational Contents"),
  "D1", "Claims Collection", "Cloud Firestore", "Document records of all submitted claims: normalized text, mediaUrl, status, verdict, confidence, and quorumCount.",
  "D2", "Verifications Collection", "Cloud Firestore", "Subcollections holding peer review votes: verifierId, verdict, sourceUrl, rationale, and timestamp.",
  "D3", "Users & Reputation", "Cloud Firestore", "User profiles, authentication identifiers (uid), display names, civic reputation scores (R), and admin flags.",
  "D4", "Analytics & Metrics", "Cloud Firestore", "Aggregated rolling metric documents storing 7-day category counts, total verifications, and leaderboard ranks."
)

#pagebreak()

== DFD Level 2: Detailed Functional Decomposition

=== Decomposition of Process 1.0 & Process 4.0
To provide granular architectural visibility, DFD Level 2 decomposes:
- *Process 1.0 (Multimodal Ingestion Pipeline):* Decomposed into Sub-processes 1.1 (Binary Magic Byte Inspection), 1.2 (HTML5 Canvas Downscaling), 1.3 (OCR Character Extraction), and 1.4 (Text Normalization & Tokenization).
- *Process 4.0 (Consensus & Confidence Engine):* Decomposed into Sub-processes 4.1 (Quorum Threshold Validator $N >= 3$), 4.2 (Multi-Factor Confidence Calculator), and 4.3 (Reputation & Verdict Finalizer).

=== Visual DFD Level 2 Diagram
The detailed functional decomposition is illustrated below:

#v(8pt)
#responsive-image("attachments/dfd_level_2.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.3: FactStamp Detailed Level 2 Functional Decomposition*]

#pagebreak()

=== Detailed Sub-Process Logic (Level 2)
#styled-table(
  columns: (0.9in, 1.3in, 1.2in, 1fr),
  headers: ("Sub-Process", "Process Name", "Inputs", "Algorithmic Transformation & Logic"),
  "1.1", "Magic Byte Inspection", "Screenshot File", "Slices first 4 bytes via Uint8Array; asserts valid JPEG (FF D8 FF) or PNG (89 50 4E 47).",
  "1.2", "Canvas Downscaling", "Validated Image Binary", "Scales dimensions to <= 1280px; quality steps (0.72 -> 0.40) until payload < 700 KB.",
  "1.3", "OCR Extraction", "Downscaled Bitmap", "Executes OCR character recognition; parses embedded Latin and Devanagari text.",
  "1.4", "Text Normalization", "Raw Strings", "Strips script injection tokens, eliminates stop-words (len <= 3), and creates token set.",
  "4.1", "Quorum Validator", "D2 Verifications", "Reads vote count; asserts N >= 3; verifies at least 2 distinct source domains.",
  "4.2", "Confidence Calculator", "D2, D3 Records", "Calculates A (majority agreement), R (mean reputation), S (source quality); computes C.",
  "4.3", "Verdict Finalizer", "Composite Score C", "If C >= 70%, sets status to 'verified'; awards +2 points to majority verifiers, -1 to dissenters."
)

#pagebreak()

== Comprehensive Data Dictionaries

=== Major Data Flows Dictionary
#styled-table(
  columns: (1.3in, 1.2in, 1.2in, 1fr),
  headers: ("Data Flow Name", "Source", "Destination", "Data Composition & Schema Structure"),
  "Forward Payload", "Public Submitter", "Process 1.0", "string textPayload (20-500 chars) OR binary imageBlob (<= 5 MB).",
  "Normalized Tokens", "Process 1.0", "Process 2.0", "Set<string> tokens; array of unique lowercase alphanumeric words (len > 3).",
  "Duplicate Query", "Process 2.0", "D1 Claims", "query(where('category', '==', cat), where('status', 'in', ['verified', 'unverified'])).",
  "Verification Vote", "Community Verifier", "Process 3.0", "{ claimId: string, verdict: enum, sourceUrl: url, rationale: string (>= 50 chars) }.",
  "Consensus Update", "Process 4.0", "D1 Claims", "{ status: 'verified', verdict: string, confidence: float, lastVerifiedAt: timestamp }.",
  "Fact Card PNG", "Process 5.0", "Public Submitter", "image/png binary stream (1080x1080 pixels, RGB 8-bit per channel)."
)

== Traceability to IEEE Std 830-1998 Requirements
#styled-table(
  columns: (1.1in, 1.2in, 1.1in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "DFD Element", "Functional Realization & Traceability"),
  "REQ-1", "Multimodal Ingestion", "Process 1.0 / 1.1-1.3", "Header inspection, canvas compression, and OCR extraction.",
  "REQ-2", "Text Normalization", "Process 1.4", "XSS filtering and stop-word tokenization.",
  "REQ-3", "Duplicate Detection", "Process 2.0", "Jaccard similarity calculation against D1 Claims.",
  "REQ-4", "Quorum Verification", "Process 3.0 & 4.1", "Queue coordination and quorum threshold (N >= 3) verification.",
  "REQ-5", "Domain Authority", "Process 4.2", "Mapping source URLs to authority tiers (100 / 70 / 30).",
  "REQ-6", "Weighted Consensus", "Process 4.2 & 4.3", "Multi-factor formula: $C = round(0.40A + 0.30R + 0.30S)$.",
  "REQ-7", "Fact Card Export", "Process 5.0", "Rasterization of 1080x1080px visual PNG cards.",
  "REQ-8", "Analytics Radar", "Process 6.0 & D4", "7-day rolling category rollups and verifier leaderboards."
)

== Conclusion & Model Verification
The Data Flow Diagrams (Levels 0, 1, and 2) establish an exhaustive, unambiguous blueprint of information transformations within FactStamp. By formalizing data pipelines, input sanitization, NoSQL storage structures, and mathematical consensus algorithms, the system guarantees high architectural integrity, transparent data provenance, and zero-cost serverless execution.
