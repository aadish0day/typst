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

#set document(title: "FactStamp - Conceptual Models: Activity & State Diagrams", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: ACTIVITY DIAGRAM & STATE DIAGRAM]
    #v(2pt)
    #text(size: 10.5pt)[*Dynamic Behavioral Modeling, Control Flow & Lifecycle State Machines*]
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
// 3.6 CONCEPTUAL MODELS: ACTIVITY & STATE DIAGRAMS
// =============================================================================
= Conceptual Models: Dynamic Behavioral Specifications

== Foundations of Behavioral Modeling in Distributed Civic Systems
While structural conceptual models (such as Entity-Relationship and Class diagrams) formalize static database schemas and class relationships, behavioral models capture the dynamic temporal semantics, operational workflows, and state transitions of an executing software system.

In FactStamp, behavioral modeling is critical due to:
1. *Multi-Actor Concurrency:* Coordinating asynchronous interactions across anonymous WhatsApp forward submitters, authenticated community fact-checkers, automated background OCR workers, and mathematical consensus engines.
2. *Asymmetric Temporal Lifecycles:* A claim progresses through distinct operational states—from raw media ingestion and duplicate thresholding, through peer review queueing, to mathematical consensus certification or 7-day timeout disposition.
3. *Non-Linear Routing:* Submissions branch dynamically based on media format (screenshot image vs plaintext), similarity metrics ($J >= 0.75$ duplicate vs novel claim), and quorum thresholds ($N >= 3$).

To formalize these dynamic processes, this deliverable presents two standard UML behavioral models:
- *UML Activity Diagram:* Visualizes algorithmic control flow, decision branches, concurrent actions, and swimlane role partitions.
- *UML State Machine Diagram:* Models the discrete discrete states, transition triggers, guard conditions, and invariant rules governing claim lifecycles and verifier civic trust scores.

#pagebreak()

== UML Activity Diagram: Fact-Checking Workflow & Control Flow

=== Swimlane Architecture & Role Segregation
The FactStamp activity model partitions activities across five specialized swimlanes:
1. *Public Submitter:* Represents citizen interactions (encountering rumors, submitting text/images, downloading fact cards).
2. *Ingestion & OCR Gateway:* Executes client-side validation, binary magic byte inspection, offscreen canvas downscaling, and OCR transcription.
3. *Duplicate Engine & DB:* Calculates lexical Jaccard similarity ($J$), manages document persistence, and indexes the verification queue.
4. *Community Verifier Network:* Encapsulates authenticated peer review, primary source investigation, and structured vote casting.
5. *Consensus & Export Engine:* Executes the tri-partite weighted confidence scoring algorithm and renders high-DPI Fact Cards.

=== Visual UML Activity Diagram
The complete dynamic control flow of FactStamp is modeled in the vertical activity diagram below:

#v(8pt)
#responsive-image("attachments/activity_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp End-to-End UML Activity Diagram*]

#pagebreak()

=== Step-by-Step Control Flow & Decision Branches
1. *Encounter & Navigation:* A user encounters a viral chain message or screenshot in WhatsApp and navigates to `/submit`.
2. *Media Format Branching:*
   - *Screenshot Pathway:* Upload triggers binary magic byte verification (`0xFFD8FF` for JPEG, `0x89504E47` for PNG). The image is downscaled to $<= 1280$px on an offscreen HTML5 canvas, compressed under 700 KB via dynamic quality stepping, and passed to the OCR pipeline to extract embedded text.
   - *Plaintext Pathway:* Raw text is filtered through regex sanitizers to eliminate script injection and control characters, followed by lowercase whitespace normalization.
3. *Similarity Evaluation Branching:*
   - The tokenized text set $A$ is compared against all existing category claims $B_k$ using the Jaccard similarity metric:
     $J(A, B_k) = (|A inter B_k|) / (|A union B_k|)$
   - *Branch A ($J >= 0.75$):* The forward is identified as a duplicate cluster instance. The user is immediately redirected to the canonical claim dossier and delivered the existing certified Fact Card. Execution terminates.
   - *Branch B ($J < 0.75$):* The submission is classified as a novel claim, persisted to Firestore with status `unverified` and initial quorum count $0$, and enqueued in `/queue`.
4. *Concurrent Peer Review Loop:*
   - Authenticated verifiers inspect the claim dossier and research authoritative sovereign sources (`pib.gov.in`, `rbi.org.in`, `who.int`).
   - Verifiers select a verdict, attach a primary URL, and submit a justification rationale ($>= 50$ characters).
   - System validates security assertions (Anti-Self-Verification rule: `claim.submittedBy != auth.uid`; Single-Vote-Per-Claim rule).
   - The system records the vote document and atomically increments `claim.quorumCount`.
   - The review loop repeats until `quorumCount >= 3`.
5. *Consensus Evaluation & Dissemination:*
   - Once $N >= 3$, the engine triggers the tri-partite weighted consensus algorithm:
     $C = round(0.40 A + 0.30 R + 0.30 S)$
   - *Consensus Confirmed ($C >= 70%$):* Claim transitions to `verified` with certified verdict $V_("maj")$. Participating verifiers receive $+2$ reputation points; dissenters receive $-1$ point. The system rasterizes a $1080 times 1080$px Fact Card PNG. The user downloads and shares it back to WhatsApp.
   - *Low Confidence / Timeout ($C < 70%$ or 7-day expiration):* Claim transitions to `contested` and is routed to the administrative audit queue.

#pagebreak()

== UML State Machine Diagram: Claim Lifecycle & Transitions

=== Visual Claim State Machine Diagram
The formal UML State Machine Diagram below specifies the operational states, hierarchical nested states, and transition guards governing a claim from ingestion to final archival:

#v(8pt)
#responsive-image("attachments/state_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.2: FactStamp Claim Lifecycle UML State Diagram*]

#pagebreak()

=== Exhaustive State Transition Matrix
The table below specifies all state transitions, triggers, guard conditions, and actions within the FactStamp state machine.

#styled-table(
  columns: (1.1in, 1.0in, 1.2in, 1.1in, 1fr),
  headers: ("Source State", "Event / Trigger", "Guard Condition", "Target State", "Action / Execution Routine"),
  "[*]", "Submit Forward", "Input valid", "UNVERIFIED_PENDING", "Initialize claim record; assign unique tracking ID.",
  "UNVERIFIED_PENDING", "Upload Screenshot", "Header is JPEG/PNG", "UNVERIFIED_PENDING (OCR)", "Canvas downscaling; extract OCR text transcription.",
  "UNVERIFIED_PENDING", "Jaccard Check", "J >= 0.75", "DUPLICATE_CLUSTERED", "Append variant to /duplicateClusters; redirect client to canonical claim.",
  "UNVERIFIED_PENDING", "Jaccard Check", "J < 0.75", "IN_REVIEW", "Write claim to Firestore /claims; index in public review queue.",
  "IN_REVIEW", "Submit Vote", "N < 3 and auth.uid != author", "IN_REVIEW", "Append verification document; atomically increment quorumCount.",
  "IN_REVIEW", "Submit Vote", "N == 3 and auth.uid != author", "EVALUATING_QUORUM", "Lock queue entry; trigger weighted consensus engine.",
  "IN_REVIEW", "Timer Expiry", "t >= t_created + 7 days, N < 3", "CONTESTED", "Mark claim as contested; flag for administrative moderation.",
  "EVALUATING_QUORUM", "Consensus Calc", "C >= 70% and Majority TRUE", "VERIFIED_TRUE", "Stamp certified TRUE verdict; award verifier reputation (+2).",
  "EVALUATING_QUORUM", "Consensus Calc", "C >= 70% and Majority FALSE", "VERIFIED_FALSE", "Stamp certified FALSE verdict; award verifier reputation (+2).",
  "EVALUATING_QUORUM", "Consensus Calc", "C >= 70% and Majority MISLEADING", "VERIFIED_MISLEADING", "Stamp certified MISLEADING verdict; award reputation (+2).",
  "EVALUATING_QUORUM", "Consensus Calc", "C < 70% (Split Decision)", "CONTESTED", "Tag claim as contested; route to admin audit queue.",
  "VERIFIED_*", "Generate Card", "Status == verified", "FACT_CARD_READY", "html-to-image canvas serialization (1080x1080px PNG).",
  "FACT_CARD_READY", "Retention Policy", "t >= t_verified + 90 days", "ARCHIVED", "Compress storage footprint; retain telemetry metrics."
)

=== State Invariants & Terminal Conditions
1. *In-Review Invariant:* While in `IN_REVIEW`, no claim may have `quorumCount >= 3` without immediately transitioning to `EVALUATING_QUORUM`.
2. *Anti-Self-Verification Invariant:* The transition `IN_REVIEW -> IN_REVIEW` is guarded by $["auth.uid" != "claim.submittedBy"]$.
3. *Immutability Invariant:* Once a claim enters any of the `VERIFIED_*` terminal states, past verifications and certified verdicts become cryptographically immutable via Firestore security rules.

#pagebreak()

== Verifier Civic Reputation State Machine
In addition to the Claim lifecycle, FactStamp models the operational standing of human verifiers using a secondary state machine driven by historical consensus accuracy:

#styled-table(
  columns: (1.2in, 0.9in, 1.2in, 1fr),
  headers: ("Reputation Tier", "Score Range", "Voting Weight", "Privileges & Operational Capabilities"),
  "Novice Verifier", "R = 50", "1.00x Base", "Initial baseline assigned to new accounts. Can review claims in public queue.",
  "Established Verifier", "51 <= R <= 80", "1.10x - 1.60x", "Earned by consistent consensus alignment. Eligible for priority queue review.",
  "Trusted Senior Verifier", "R > 80", "1.70x - 2.00x", "High-accuracy track record. Highest mathematical consensus influence.",
  "Probationary Review", "30 <= R < 50", "0.60x - 0.90x", "Penalized for frequent dissenting or unsubstantiated votes. Voting influence attenuated.",
  "Flagged / Suspended", "R < 30 / Sybil", "0.00x (Revoked)", "Flagged by anti-Sybil heuristics. Voting privileges blocked; flagged for admin review."
)

=== Mathematical Reputation Dynamics
Reputation scores update reactively upon quorum consensus finalization:
- *Consensus Alignment:* Contributing verifiers who voted with the majority verdict receive $+2$ reputation points ($R_{t+1} = min(100, R_t + 2)$).
- *Consensus Dissent:* Contributing verifiers who voted against the certified majority verdict receive $-1$ reputation point ($R_{t+1} = max(0, R_t - 1)$).
- *Strict Bounding:* The score is mathematically constrained to the interval $[0, 100]$.

#pagebreak()

== Behavioral Traceability to IEEE Std 830-1998 Requirements
The dynamic behaviors formalized across the Activity and State diagrams directly realize the functional requirements established in Chapter 3.2:

#styled-table(
  columns: (1.1in, 1.2in, 1.1in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "Behavioral Construct", "Traceability & Verification Mapping"),
  "REQ-1", "Multimodal Ingestion", "Activity Swimlane 2", "Branching logic for text vs screenshot upload; canvas downscale.",
  "REQ-2", "Text Normalization", "Activity Gateway", "Sanitization steps removing XSS tokens and normalizing whitespace.",
  "REQ-3", "Duplicate Detection", "State: DUPLICATE_CLUSTERED", "Jaccard thresholding $J >= 0.75$ preventing redundant tickets.",
  "REQ-4", "Quorum Verification", "State: IN_REVIEW", "Quorum counter accumulation loop ($N < 3$) and self-vote guard.",
  "REQ-5", "Domain Authority", "Activity Consensus Step", "Tiered domain mapping (100 / 70 / 30) fed into confidence formula.",
  "REQ-6", "Weighted Consensus", "State: EVALUATING_QUORUM", "Tri-partite formula execution; consensus threshold $C >= 70%$.",
  "REQ-7", "Fact Card Export", "State: FACT_CARD_READY", "Rasterization of 1080x1080px PNG Fact Card via html-to-image.",
  "REQ-9", "Anti-Sybil Defense", "Reputation State Machine", "Self-verification lockout; score attenuation; suspended tier.",
  "REQ-10", "Zero-Cost Serverless", "All Activities", "Client-side compute offloading; Firestore read/write optimization."
)

== Conclusion & Dynamic Architectural Soundness
The UML Activity and State Machine models provide rigorous, unambiguous blueprints of FactStamp's runtime dynamics. By eliminating ambiguous control paths, enforcing deterministic state transitions, and guarding against concurrency anomalies and Sybil manipulation, the system achieves enterprise-grade software stability.
