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

#set document(title: "FactStamp - Conceptual Models: Sequence Diagrams", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: SEQUENCE DIAGRAMS]
    #v(2pt)
    #text(size: 10.5pt)[*Chronological Message Traces, Lifeline Interactions & Transactional Concurrency*]
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
// 3.6 CONCEPTUAL MODELS: SEQUENCE DIAGRAMS
// =============================================================================
= Conceptual Models: UML Sequence Diagrams

== Foundations of Interaction & Sequence Modeling in Distributed Systems
While static structural diagrams define the entities of a software architecture and behavioral diagrams illustrate general business processes, UML Sequence Diagrams model the exact chronological exchange of messages between executing system components over time.

In FactStamp, sequence modeling serves three vital engineering objectives:
1. *Chronological Protocol Verification:* Tracing synchronous and asynchronous HTTP/REST invocations, WebSockets event streams, and database transactions across the presentation, serverless compute, and database tiers.
2. *Concurrency & Atomicity Guarantees:* Demonstrating how race conditions are prevented when multiple community verifiers cast votes simultaneously on the same pending claim.
3. *Latency & Resource Optimization:* Illustrating how client-side offloading (such as in-browser canvas downscaling) minimizes backend serverless execution time and guarantees zero-cost operation.

This deliverable specifies two primary interaction sequences:
- *Sequence 1: Claim Ingestion & Duplicate Resolution:* Traces user submission, file validation, OCR extraction, Jaccard similarity evaluation, and duplicate redirection.
- *Sequence 2: Quorum Peer Review & Weighted Consensus Finalization:* Traces verifier authentication, self-verification locks, transactional vote persistence, quorum evaluation, confidence scoring, and fact card generation.

#pagebreak()

== Sequence Diagram 1: Claim Ingestion & Duplicate Resolution

=== Architectural Participants & Lifelines
1. *Public Submitter (Citizen):* Human user providing forwarded rumor text or screenshots.
2. *Browser Client (Next.js UI):* Handles client-side magic byte inspection, offscreen canvas downscaling, and DOM updates.
3. *Ingestion API (Serverless Edge):* Next.js API route executing sanitization, XSS filtering, and orchestration.
4. *OCR Pipeline (Canvas/WASM Tesseract):* In-browser neural LSTM optical character recognition engine running via WebAssembly, extracting embedded text from screenshot bitmaps without external cloud APIs.
5. *Duplicate Engine (Jaccard Detector):* Set-theoretic similarity engine executing stop-word filtering and Jaccard coefficient evaluation.
6. *Cloud Firestore (NoSQL DB):* Document-oriented database maintaining persistent collections (`/claims`, `/duplicateClusters`).

=== Visual Sequence Diagram 1
The chronological message exchange for claim submission and duplicate indexing is presented below:

#v(8pt)
#responsive-image("attachments/sequence_diagram_submission.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp Claim Ingestion & Duplicate Resolution Sequence*]

#pagebreak()

=== Detailed Chronological Message Trace (Ingestion)
#styled-table(
  columns: (0.7in, 1.2in, 1.2in, 1fr),
  headers: ("Step", "Sender Lifeline", "Receiver Lifeline", "Message Signature & Execution Description"),
  "1", "Public Submitter", "Browser Client", "Submit Forward (text string or screenshot File object).",
  "2", "Browser Client", "Browser Client", "Validate Magic Bytes: Slices first 4 bytes to confirm genuine JPEG (FF D8 FF) or PNG (89 50 4E 47).",
  "3", "Browser Client", "Browser Client", "Downscale Canvas: Resizes image to <= 1280px; applies quality stepping until < 700 KB.",
  "4-5", "Browser Client", "OCR Pipeline", "Request OCR extraction; engine returns machine-readable normalized text transcription.",
  "6", "Browser Client", "Ingestion API", "POST /api/claims/submit {text, mediaUrl, category}. Transmitted over TLS 1.3.",
  "7", "Ingestion API", "Ingestion API", "Sanitize & Normalize: Strips HTML tags, script tokens, and collapses whitespace.",
  "8-10", "Ingestion API", "Duplicate Engine", "CheckDuplicate(tokens, category); queries active and resolved claims in Firestore.",
  "11", "Duplicate Engine", "Duplicate Engine", "Computes Jaccard Similarity J = |A ∩ B| / |A ∪ B| against all category candidates.",
  "12a-16a", "Duplicate Engine", "Browser Client", "Duplicate Match (J >= 0.75): Logs variant to /duplicateClusters; redirects client to canonical Fact Card.",
  "12b-16b", "Duplicate Engine", "Browser Client", "Unique Claim (J < 0.75): Writes new claim to /claims; returns HTTP 201 with shareable tracking ID."
)

=== Exception Handling & Edge Conditions
- *Binary File Tampering:* If a malicious executable (`.exe`, `.sh`) disguised with a `.jpg` extension is uploaded, magic byte validation fails at Step 2; upload aborts immediately before invoking network APIs.
- *Unreadable Screenshot:* If OCR extraction at Step 5 yields an empty string, the UI prompts the submitter to manually type the visible claim text before dispatching Step 6.

#pagebreak()

== Sequence Diagram 2: Quorum Peer Review & Weighted Consensus Finalization

=== Architectural Participants & Lifelines
1. *Community Verifier (Reviewer):* Authenticated fact-checker evaluating claims in the public queue.
2. *Web Dashboard (/queue UI):* Responsive interface displaying pending claims, evidence forms, and real-time listeners.
3. *Auth Guard (Firebase Auth):* Issues and validates cryptographically signed RS256 JSON Web Tokens (JWT).
4. *Verification API (Next.js Route):* Endpoint managing verification validation and transaction orchestration.
5. *Consensus Engine (Scoring Worker):* Domain service executing the weighted multi-factor scoring formula.
6. *Cloud Firestore (NoSQL DB):* Persistent database executing atomic updates and storing verifications.
7. *Fact Card Generator (html-to-image):* Client/serverless graphics worker rasterizing 1080x1080px Fact Cards.

=== Visual Sequence Diagram 2
The chronological message exchange for peer review, quorum triggering, and consensus certification is presented below:

#v(8pt)
#responsive-image("attachments/sequence_diagram_consensus.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.2: FactStamp Quorum Verification & Weighted Consensus Sequence*]

#pagebreak()

=== Detailed Chronological Message Trace (Consensus)
#styled-table(
  columns: (0.7in, 1.2in, 1.2in, 1fr),
  headers: ("Step", "Sender Lifeline", "Receiver Lifeline", "Message Signature & Execution Description"),
  "1-3", "Community Verifier", "Cloud Firestore", "Verifier selects unverified claim; UI subscribes to real-time Firestore listener.",
  "4-6", "Community Verifier", "Auth Guard", "Verifier submits verdict, citation URL, and rationale; client acquires validated JWT token.",
  "7-9", "Web Dashboard", "Cloud Firestore", "POST /api/verifications/submit; API verifies claim author and checks existing votes.",
  "10", "Verification API", "Verification API", "Anti-Self-Verification Lock: Asserts verifierId != claim.submittedBy. Rejects with 403 if violated.",
  "11-12", "Verification API", "Cloud Firestore", "Atomic Transaction: Writes /claims/{id}/verifications/{vid} and increments quorumCount by +1.",
  "13-15", "Verification API", "Consensus Engine", "Quorum Check (N >= 3): Triggers consensus worker; fetches all votes and verifier reputation scores.",
  "16-20", "Consensus Engine", "Consensus Engine", "Calculates Agreement Ratio A (40%), Mean Reputation R (30%), and Source Credibility S (30%).",
  "21a-24a", "Consensus Engine", "Fact Card Gen", "Confidence Confirmed (C >= 70%): Updates claim to 'verified', updates reputations, renders Fact Card.",
  "21b", "Consensus Engine", "Cloud Firestore", "Split Decision (C < 70%): Updates claim status to 'contested' and routes to admin moderation queue.",
  "25-26", "Verification API", "Community Verifier", "Returns HTTP 200 OK; UI renders confirmation toast and reactive claim dossier updates."
)

=== Concurrency Control & Race Condition Mitigation
When two verifiers cast votes concurrently:
- Firestore's `runTransaction()` executes with optimistic concurrency control (OCC).
- If `quorumCount` is updated concurrently by another thread, the lagging transaction automatically retries with the fresh snapshot.
- The consensus evaluation routine is guarded by an idempotency lock: once consensus begins, `claim.status` transitions from `unverified` to `evaluating`, preventing duplicate scoring runs.

#pagebreak()

== Sequence Traceability to IEEE Std 830-1998 Requirements
The interactions modeled in the Sequence Diagrams validate the implementation of the core functional requirements:

#styled-table(
  columns: (1.1in, 1.2in, 1.1in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "Sequence Interaction", "Architectural Protocol & Invariant"),
  "REQ-1", "Multimodal Ingestion", "Seq 1: Msg 1-5", "Client-side magic byte inspection and canvas downscaling pipeline.",
  "REQ-2", "Text Normalization", "Seq 1: Msg 7", "Regex sanitization in API gateway eliminating script injections.",
  "REQ-3", "Duplicate Detection", "Seq 1: Msg 8-16", "Jaccard coefficient calculation and canonical redirection ($J >= 0.75$).",
  "REQ-4", "Quorum Peer Review", "Seq 2: Msg 1-12", "Real-time subscription, atomic transaction, and quorum threshold ($N >= 3$).",
  "REQ-5", "Domain Authority", "Seq 2: Msg 19", "Automated mapping of source domain authority to credibility tiers.",
  "REQ-6", "Weighted Consensus", "Seq 2: Msg 16-20", "Mathematical composite scoring: $C = round(0.40A + 0.30R + 0.30S)$.",
  "REQ-7", "Fact Card Export", "Seq 2: Msg 23-24", "Rendering 1080x1080px Fact Card PNG via html-to-image.",
  "REQ-9", "Anti-Sybil Defense", "Seq 2: Msg 10", "Self-verification lockout asserting $auth.uid != claim.submittedBy$."
)

== Conclusion & Interaction Robustness
The UML Sequence Diagrams verify that FactStamp's interaction architecture is temporally coherent, robust against concurrent race conditions, and fully resilient against malicious inputs. The synchronous client-side pre-processing paired with asynchronous transactional cloud persistence ensures superior user responsiveness while strictly honoring zero-cost infrastructure boundaries.
