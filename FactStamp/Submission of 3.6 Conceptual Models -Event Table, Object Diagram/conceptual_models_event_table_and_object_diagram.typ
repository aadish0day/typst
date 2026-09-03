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
#show table.cell: set text(size: 8.5pt)
#show table.cell.where(y: 0): set text(size: 8.5pt, weight: "bold")
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
  inset: (x: 4pt, y: 3.8pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 8.5pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 8.5pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Conceptual Models: Event Table & Object Diagram", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS]
    #v(2pt)
    #text(size: 10.5pt)[*System Event Table & Object-Oriented Object Diagram (Runtime Instance Model)*]
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
// 3.6 CONCEPTUAL MODELS: EVENT TABLE & OBJECT DIAGRAM
// =============================================================================
= Conceptual Models: Event Table & Object Diagram

== Introduction to Dynamic Conceptual Modeling
In modern software engineering, comprehensive system specification requires both structural (static) and behavioral (dynamic) conceptual representations:

1. *Structural Modeling:* Formalized through Entity-Relationship (E-R) and UML Class diagrams, defining database schemata, encapsulation boundaries, attribute specifications, and static class hierarchies.
2. *Dynamic & Runtime Modeling:* Formalized through *System Event Tables* and *UML Object Diagrams*, capturing how external, temporal, and internal state stimuli trigger system transformations, and documenting the precise memory state of collaborating object instances during active runtime execution.

Within the *FactStamp* architecture, dynamic modeling is essential. As a real-time, decentralized fact-checking platform countering viral WhatsApp misinformation, the system relies on an *Event-Driven Architecture (EDA)*. Ingestion triggers text sanitization and Jaccard duplicate suppression; independent verifier votes trigger quorum evaluation; third-vote completions trigger weighted consensus calculations; and client actions trigger on-the-fly rasterization of shareable fact cards.

#pagebreak()

== FactStamp System Event Table

=== Foundations of the System Event Table
An *Event Table* is a foundational systems analysis artifact that catalogues all events capable of altering system state. It formalizes inputs, processing activities, generated outputs, and destination targets across the entire platform lifecycle.

In strict compliance with IEEE and academic systems analysis standards, the Event Table employs the standard six-column matrix:
- *Event Name:* Formal identifier describing the operational occurrence.
- *Trigger:* The specific user gesture, temporal schedule, or state mutation initiating the event.
- *Source:* The human actor, hardware client, or internal software subsystem originating the trigger.
- *Activity Performed:* The core computational workflow, algorithmic execution, or database operation performed.
- *Response Generated:* The immediate system response, user feedback, or mutated entity state.
- *Destination:* The UI view, database collection, or client endpoint receiving the resulting response.

=== Formal System Event Table Matrix
The fourteen critical system events governing the FactStamp operational lifecycle are formulated below across four operational groups:

#styled-table(
  columns: (0.95in, 0.90in, 0.85in, 1.30in, 1.10in, 0.80in),
  headers: ("Event Name", "Trigger", "Source", "Activity Performed", "Response Generated", "Destination"),
  // Group A: Ingestion & Submitter Events
  "EVT-01: Submit Plaintext Forward", "User pastes WhatsApp text and clicks 'Verify'", "Public Submitter (Browser)", "Strips XSS tags, trims whitespace, validates length (20–500 chars), executes tokenization.", "Displays processing indicator; enqueues claim for duplicate evaluation.", "Submit Page UI",
  "EVT-02: Upload Forward Screenshot", "User drops or selects screenshot image file", "Public Submitter (Browser)", "Validates MIME/extension/magic bytes (<=5 MB); executes Canvas downscaling (<=1280px); triggers Tesseract.js OCR.", "Generates Base64 data URL; populates extracted text in editor for user review.", "Submit Page UI",
  "EVT-03: Duplicate Claim Detected", "Pairwise Jaccard similarity index J >= 0.75", "Duplicate Detection Engine", "Suppresses duplicate queue entry; records variant text in /duplicateClusters; increments cluster counter.", "Renders warning banner: 'Existing Claim Matched'; routes user to certified verdict.", "Claim Detail View",
  "EVT-04: Unique Claim Enqueued", "Jaccard similarity index J < 0.75 across all claims", "Duplicate Detection Engine", "Creates new Firestore document in /claims with status='unverified', quorumCount=0, confidence=null.", "Displays submission confirmation toast; transitions claim to public review queue.", "Verify Queue UI"
)

#pagebreak()

#styled-table(
  columns: (0.95in, 0.90in, 0.85in, 1.30in, 1.10in, 0.80in),
  headers: ("Event Name", "Trigger", "Source", "Activity Performed", "Response Generated", "Destination"),
  // Group B: Community Verification & Consensus Events
  "EVT-05: Browse Pending Queue", "Verifier navigates to '/queue' route", "Community Verifier", "Queries Firestore for claims where status='unverified' and quorumCount < 3, ordered by submittedAt desc.", "Renders reactive list of unverified forward cards with category badges.", "Verify Queue Page",
  "EVT-06: Submit Claim Verification", "Verifier selects verdict enum, provides URL and rationale", "Community Verifier", "Validates HTTPS URL; evaluates domain credibility (S); verifies verifierId != submittedBy; writes to /verifications.", "Increments claim.quorumCount; appends vote snapshot; updates verifier counters.", "Verify Detail View",
  "EVT-07: Quorum Attained (N >= 3)", "Third independent verification document committed", "Firestore Security & Trigger", "Locks claim from further general review; extracts quorum votes; invokes consensus calculation service.", "Mutates claim lifecycle status from 'unverified' to 'calculating'.", "Consensus Engine",
  "EVT-08: Compute Consensus Score", "Claim status transitions to 'calculating'", "Consensus Calculator", "Computes modal verdict, agreement ratio (A), verifier reputation avg (R), source credibility avg (S); calculates C.", "Writes verdict, confidence %, and certification flag; updates status to 'verified'.", "Firestore claims Store"
)

#pagebreak()

#styled-table(
  columns: (0.95in, 0.90in, 0.85in, 1.30in, 1.10in, 0.80in),
  headers: ("Event Name", "Trigger", "Source", "Activity Performed", "Response Generated", "Destination"),
  // Group C: Post-Verification, Analytics & Temporal Events
  "EVT-09: Export Fact Card PNG", "User clicks 'Download Fact Card' button", "Public Submitter / Verifier", "Clones DOM preview node, executes OKLCH-to-sRGB style transformer, renders 1080x1080px canvas.", "Triggers browser PNG download buffer ('factstamp-[id].png').", "Local Client Device",
  "EVT-10: Refresh Analytics Dashboard", "User accesses '/dashboard' analytics view", "Public Citizen / Verifier", "Queries /metrics collections; aggregates claim volumes, verdict distributions, and verifier leaderboards.", "Renders category donut charts and verifier accuracy ranking tables.", "Dashboard View",
  "EVT-11: Contested Timeout Expiry", "Claim age exceeds 7 days without achieving quorum consensus", "Temporal Cron / Lifecycle Trigger", "Evaluates claims where quorumCount < 3 or consensus confidence C < 70%; classifies as contested.", "Sets status='contested'; logs telemetry incident for administrative review.", "Admin Dashboard",
  // Group D: Security, Governance & Abuse Prevention Events
  "EVT-12: Blocked Self-Verification", "Submitter attempts to verify their own submitted claim", "Client Guard & Firestore Rules", "Compares auth.uid with claim.submittedBy; aborts operation with permission-denied error code.", "Displays security warning toast: 'Self-verification strictly prohibited'.", "Client Toast UI",
  "EVT-13: File Upload Rejection", "Uploaded file fails MIME, extension, or magic byte check", "Security Middleware", "Aborts file processing; refuses canvas allocation; prevents memory buffer overflow.", "Displays error toast: 'Corrupt or disguised file rejected by security gate'.", "Submit Form UI",
  "EVT-14: XSS Payload Neutralization", "User inputs malicious HTML or script tags", "Security Sanitizer", "Executes regex tag stripping, event handler neutralization, and null-byte elimination.", "Stores pure sanitized text string; prevents stored script execution in client DOM.", "Firestore claims Store"
)

#pagebreak()

=== Architectural Event Chain Case Studies

==== Case Study 1: The Claim Ingestion & Duplicate Suppression Event Chain
When a citizen receives a viral WhatsApp rumor and submits it to FactStamp, a sequential event chain executes:
1. *EVT-01 or EVT-02 Trigger:* The user inputs text or drops a screenshot.
2. *EVT-13 or EVT-14 Security Gate:* The input passes through `validateImageUpload()` or `sanitizeTextInput()`. Malicious payloads trigger immediate termination.
3. *Duplicate Detection Evaluation:* The normalized text is tokenized into word sets and compared against all active claims using the Jaccard similarity index:
   $ J(A, B) = frac(|A inter B|, |A union B|) $
4. *Branching Outcome:*
   - *If $J(A, B) >= 0.75$ (EVT-03):* The engine suppresses new document creation. A cluster entry is written to `/duplicateClusters/{id}`, and the user is instantly redirected to the existing certified verdict, saving community verification bandwidth.
   - *If $J(A, B) < 0.75$ (EVT-04):* A fresh document is created in `/claims/{id}` with `status: "unverified"`, making it immediately visible in the public review queue.

==== Case Study 2: The Quorum Review & Consensus Resolution Event Chain
Once a claim is enqueued, the verification lifecycle progresses through community review:
1. *EVT-05 Trigger:* An authenticated verifier browses the pending queue and selects an unverified claim.
2. *EVT-12 Self-Verification Audit:* The system validates that `verifierId != claim.submittedBy`. If identical, write access is blocked.
3. *EVT-06 Vote Commitment:* The verifier submits their evaluated verdict candidate, credible reference URL, and rationale. The vote is committed to `/claims/{id}/verifications/{vId}`.
4. *EVT-07 Quorum Attainment ($N = 3$):* The commit triggers the quorum evaluator. If three independent verifications exist, the claim transitions to `status: "calculating"`.
5. *EVT-08 Mathematical Consensus Execution:* The `ConsensusCalculator` evaluates the votes:
   $ C = 0.40 A + 0.30 R + 0.30 S $
   If $C >= 70.0\%$, the claim is certified as `status: "verified"`, and the verifiers receive reputation score increments ($+2$).

#pagebreak()

== Object-Oriented Object Diagram (Runtime Instance Model)

=== Purpose & Foundations of UML Object Diagrams
While a UML Class Diagram models classes, attributes, operations, and relationships at design-time (the compile-time blueprint), a *UML Object Diagram* (Instance Diagram) captures a concrete snapshot of instanced objects in computer memory at a specific point in time ($t = t_"snapshot"$).

Object diagrams serve three crucial purposes in software engineering:
1. *Validating Class Model Correctness:* Verifying that complex multiplicity constraints, inheritance hierarchies, and compositional lifecycles hold true under real operational conditions.
2. *Illustrating Concrete Collaborations:* Showing how runtime objects instantiate real attribute values, maintain references, and pass data to resolve complex business transactions.
3. *Verifying Algorithmic State Transitions:* Demonstrating how mathematical formulas (such as FactStamp's multi-factor consensus engine) compute final states from concrete instance data.

=== Concrete Execution Scenario: Viral Banking Rumor Consensus
To demonstrate FactStamp's runtime architecture, the Object Diagram models the active consensus resolution of a real-world viral WhatsApp forward:
- *Submitted Viral Text:* _"Reserve Bank of India is closing all ATMs tonight from 12 AM due to urgent software upgrades. Withdraw cash now!"_
- *Submitter:* Rahul K. (`usr_9901`), an ordinary citizen submitting unverified content.
- *Duplicate Forward:* _"All bank ATMs will stop working from midnight today for system maintenance..."_ detected with Jaccard similarity $J = 0.84$.
- *Quorum Verifiers:* Three independent authenticated community fact-checkers:
  1. Priya Sharma (`usr_4021`, Reputation: 88) citing Press Information Bureau (`pib.gov.in`, Credibility: 95).
  2. Dr. Rajesh Iyer (`usr_8819`, Reputation: 94) citing official Reserve Bank of India notification (`rbi.org.in`, Credibility: 98).
  3. Ananya Desai (`usr_1204`, Reputation: 76) citing national news report (`timesofindia.indiatimes.com`, Credibility: 80).
- *Consensus Outcome:* Unanimous FALSE verdict ($A = 1.0$), Average Reputation $R = 86.0$, Average Source Quality $S = 91.0$, Composite Confidence $C = 93.1\%$, certified fact card generated.

#pagebreak()

=== UML Object Diagram
The formal UML Object Diagram illustrating concrete runtime object instances, attribute values, and structural links is presented below:

#v(8pt)
#responsive-image("attachments/object_diagram.svg", width: 90%, max-height: 580pt)

#pagebreak()

=== Comprehensive Object Instance Inventory & State Analysis
The runtime state of all eleven instanced objects captured in the memory snapshot is detailed below:

#styled-table(
  columns: (1.3in, 1.1in, 1.5in, 1.5in),
  headers: ("Object Identifier", "Class Type", "Runtime Attribute Values", "Architectural Role & Function"),
  "submitter", "User", "uid: 'usr_9901'\ndisplayName: 'Rahul K.'\nreputation: 50\nisAdmin: false", "Initial submitter of the viral WhatsApp forward. Prohibited from casting verification votes.",
  "dup", "DuplicateCluster", "id: 'dup_501'\ncanonicalClaimId: 'clm_89234'\njaccardScore: 0.84", "Stores near-identical variant forward; routes secondary submitters directly to canonical claim.",
  "c1", "Claim", "id: 'clm_89234'\ncategory: 'financial'\nstatus: 'verified'\nverdict: 'FALSE'\nconfidence: 93.1%\nquorumCount: 3", "Aggregate Root entity holding the validated claim state, consensus metrics, and quorum collection.",
  "v1", "Verification", "id: 'ver_101'\nverifierId: 'usr_4021'\nverdict: 'FALSE'\nsourceCredibility: 95\nverifierReputation: 88", "First verification vote citing PIB Fact Check. High credibility government debunk.",
  "v2", "Verification", "id: 'ver_102'\nverifierId: 'usr_8819'\nverdict: 'FALSE'\nsourceCredibility: 98\nverifierReputation: 94", "Second verification vote citing official RBI press release. Highest authority institutional source.",
  "v3", "Verification", "id: 'ver_103'\nverifierId: 'usr_1204'\nverdict: 'FALSE'\nsourceCredibility: 80\nverifierReputation: 76", "Third verification vote citing mainstream news outlet. Reaches required quorum threshold (N=3).",
  "u1", "User", "uid: 'usr_4021'\ndisplayName: 'Priya Sharma'\nreputation: 88 -> 90\ntotalVerifications: 42", "Active verifier. Reputation incremented by +2 points following consensus certification.",
  "u2", "User", "uid: 'usr_8819'\ndisplayName: 'Dr. Rajesh Iyer'\nreputation: 94 -> 96\ntotalVerifications: 115", "Senior verifier. High track-record reputation provides heavy weighting in consensus formula.",
  "u3", "User", "uid: 'usr_1204'\ndisplayName: 'Ananya Desai'\nreputation: 76 -> 78\ntotalVerifications: 19", "Junior community verifier. Successful consensus alignment reinforces voter reputation.",
  "cr", "ConsensusResult", "verdict: 'FALSE'\nconfidence: 93.1%\nagreementRatio: 1.0\nreputationAvg: 86.0\nsourceQualityAvg: 91.0\nisCertified: true", "Immutable Value Object encapsulating consensus engine outputs and certification status.",
  "card", "FactCardGenerator", "targetElement: '#preview'\noutputResolution: '1080x1080'\ncolorSpace: 'sRGB'\nexportFormat: 'PNG'", "Presentation service converting certified claim DOM state into an exportable square fact card image."
)

#pagebreak()

=== Mathematical Validation of Runtime Object State
The runtime values recorded in the Object Diagram provide empirical proof of FactStamp's mathematical consensus algorithm:

==== 1. Agreement Ratio ($A$)
All three verifiers unanimously selected the `FALSE` verdict:
$ A = frac("Votes for Leading Verdict", "Total Quorum Votes") = frac(3, 3) = 1.0 wide (100.0\%) $

==== 2. Average Verifier Reputation ($R$)
The arithmetic mean of the three participating verifiers' reputation scores at vote time:
$ R = frac(88 + 94 + 76, 3) = frac(258, 3) = 86.0 $

==== 3. Average Source Credibility ($S$)
The arithmetic mean of the domain credibility ratings for the submitted citation URLs:
$ S = frac(95 + 98 + 80, 3) = frac(273, 3) = 91.0 $

==== 4. Composite Confidence Score ($C$)
Substituting $A$, $R$, and $S$ into the multi-factor weighted consensus formula:
$ C = 0.40 A + 0.30 R + 0.30 S $
$ C = 0.40(100.0) + 0.30(86.0) + 0.30(91.0) $
$ C = 40.00 + 25.80 + 27.30 = 93.10\% $

Because $C = 93.10\% >= 70.0\%$, the threshold is satisfied. The `ConsensusResult.isCertified` boolean is set to `true`, and the claim is stamped with a certified `FALSE` verdict.

=== Structural Comparison: Class Diagram vs. Object Diagram

#styled-table(
  columns: (1.3in, 1.8in, 1.8in),
  headers: ("Dimension", "Design-Time UML Class Diagram", "Runtime UML Object Diagram"),
  "Temporal Perspective", "Static, time-invariant system blueprint.", "Dynamic, time-specific execution snapshot ($t = t_0$).",
  "Elements Represented", "Classes, interfaces, abstract data types.", "Instantiated concrete objects in system memory.",
  "Notation", "`ClassName` (attributes, operations).", "`objectName : ClassName` (concrete attribute values).",
  "Link Representation", "General associations, compositions, aggregations.", "Concrete links binding specific instances together.",
  "Multiplicity Scope", "Permissible cardinality ranges ($0..1$, $1..*$, $0..N$).", "Exact instantiated instance counts (e.g., exactly 3 votes).",
  "Engineering Value", "Defines software architecture and contracts.", "Validates runtime algorithms, memory state, and constraints."
)

#pagebreak()

// ==========================================
// REFERENCES
// ==========================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Fowler, M., *"UML Distilled: A Brief Guide to the Standard Object Modeling Language,"* 3rd ed., Addison-Wesley Professional, 2003.
3. Booch, G., Rumbaugh, J., & Jacobson, I., *"The Unified Modeling Language User Guide,"* 2nd ed., Addison-Wesley, 2005.
4. Pressman, R. S., & Maxim, B. R., *"Software Engineering: A Practitioner's Approach,"* 9th ed., McGraw-Hill Education, 2020.
5. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* Bulletin de la Société Vaudoise des Sciences Naturelles, vol. 37, pp. 547-579, 1901.
6. Google Firebase Documentation, *"Cloud Firestore Data Model: Documents and Collections,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore/data-model`.
7. Sommerville, I., *"Software Engineering,"* 10th ed., Pearson Education, 2016.
