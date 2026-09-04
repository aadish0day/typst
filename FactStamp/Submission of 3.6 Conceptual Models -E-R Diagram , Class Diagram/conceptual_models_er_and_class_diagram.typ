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
    size: 9pt,
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

#set document(title: "FactStamp - Conceptual Models (E-R & Class Diagrams)", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: E-R DIAGRAM & CLASS DIAGRAM]
    #v(2pt)
    #text(size: 10.5pt)[*Formal Schema Modeling, Data Dictionaries & Object-Oriented Architecture*]
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
// 3.6 CONCEPTUAL MODELS
// =============================================================================
= Conceptual Models

== Introduction to Conceptual Modeling
Conceptual modeling establishes the bridge between abstract user requirements and concrete software execution. In software engineering, conceptual models serve two essential functions:
1. *Data-Centric Abstraction (Structural Perspective):* Formalizing the information architecture, database entities, integrity constraints, and cardinality rules governing persistent application storage.
2. *Object-Oriented Abstraction (Behavioral & Domain Perspective):* Defining the class hierarchy, state encapsulation, method signatures, and inter-class collaborations necessary to execute core business logic.

Within the *FactStamp* architecture, conceptual models address the unique challenges of a decentralized, real-time crowdsourcing platform: tracking verifier reputation, managing claim verification lifecycles, computing multi-factor quorum consensus, suppressing viral duplicate forwards, and compiling shareable fact cards.

#pagebreak()

== Entity-Relationship (E-R) Model
The Entity-Relationship model captures the logical schema of FactStamp. Although FactStamp utilizes Google Cloud Firestore—a document-oriented NoSQL database—formal relational modeling remains crucial to maintain relational consistency, eliminate redundant storage, and structure declarative security rules.

=== Core Entities & Structural Roles
The platform models five primary business entities:

1. *USER:* Represents authenticated community verifiers and system administrators. Stores authentication identifiers (`uid`), public screen names (`displayName`), email addresses, historical track-record reputation scores (`reputation` $in [0, 100]$), completed verification counters (`totalVerifications`), and administrative access flags (`isAdmin`).

2. *CLAIM:* The central operational entity representing submitted WhatsApp forwards. Encapsulates the normalized text content, optional screenshot storage references (`mediaUrl`), lifecycle processing status (`status` $in {"unverified", "verified", "contested"}$), certified verdict classification (`verdict`), computed consensus confidence percentage (`confidence`), topical category, submitter identification, submission timestamps, and active quorum review counters.

3. *VERIFICATION:* Represents an individual verification vote cast by an authenticated verifier on a specific pending claim. Captures the verifier's chosen verdict candidate, the verifier's historical reputation score at the moment of voting, the authoritative primary citation URL, a factual justification rationale, and the computed source domain credibility rating ($S$).

4. *DUPLICATE_CLUSTER:* Represents duplicate or near-identical forward variants detected via the Jaccard similarity engine ($J >= 0.75$). Maps secondary forward variations back to the authoritative canonical claim, ensuring users receive instantaneous certified verdicts without fragmenting verifier effort.

5. *CATEGORY_METRIC:* Represents real-time aggregated analytical rollups across topical misinformation domains (Health, Politics, Finance, Scams, Religion, Other). Maintained to power the public analytics dashboard without incurring massive read costs on raw claim collections.

#pagebreak()

=== Entity-Relationship Diagram
The formal Entity-Relationship diagram illustrating entities, primary/foreign key linkages, and cardinality constraints is presented below:

#v(8pt)
#responsive-image("attachments/er_diagram.svg", width: 88%, max-height: 580pt)

#pagebreak()

=== Data Dictionaries & Logical Schema Specifications
The physical and logical schema definitions for each persistent entity are specified below:

==== Entity: USER (`/users/{uid}`)
#styled-table(
  columns: (1.1in, 0.9in, 0.6in, 0.7in, 1.3in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "uid", "String", "No", "PK", "None", "Unique Firebase Auth UID (alphanumeric, 28 chars).",
  "displayName", "String", "No", "None", "None", "Public verifier handle (max 100 chars; XSS-sanitized).",
  "email", "String", "No", "None", "None", "Verified email address linked to user identity.",
  "reputation", "Integer", "No", "None", "50", "Trust score bounded strictly in [0, 100]; baseline 50.",
  "totalVerifications", "Integer", "No", "None", "0", "Monotonically increasing tally of valid votes cast.",
  "isAdmin", "Boolean", "No", "None", "false", "Platform administrative privilege flag.",
  "joinedAt", "Timestamp", "No", "None", "serverTimestamp()", "Account creation timestamp in UTC."
)

==== Entity: CLAIM (`/claims/{claimId}`)
#styled-table(
  columns: (1.1in, 0.9in, 0.6in, 0.7in, 1.3in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Firestore document auto-generated 20-char key.",
  "text", "String", "No", "None", "None", "Normalized forward text (10 to 2,000 characters).",
  "mediaUrl", "String", "Yes", "None", "null", "Optional Base64 or Cloud Storage screenshot URL.",
  "status", "String", "No", "None", "\"unverified\"", "Lifecycle enum: 'unverified' | 'verified' | 'contested'.",
  "verdict", "String", "Yes", "None", "null", "Consensus verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE'.",
  "confidence", "Float", "Yes", "None", "null", "Computed confidence percentage [0.00 to 100.00].",
  "category", "String", "No", "None", "\"Other\"", "Topical domain: Health, Politics, Finance, Scams, etc.",
  "submittedBy", "String", "No", "FK", "\"anonymous\"", "User UID of submitter or literal 'anonymous'.",
  "submittedAt", "Timestamp", "No", "None", "serverTimestamp()", "Initial claim ingestion timestamp in UTC.",
  "quorumCount", "Integer", "No", "None", "0", "Number of independent verifications received (N).",
  "lastVerifiedAt", "Timestamp", "Yes", "None", "null", "Timestamp of most recent verifier submission."
)

==== Entity: VERIFICATION (`/claims/{claimId}/verifications/{verificationId}`)
#styled-table(
  columns: (1.1in, 0.9in, 0.6in, 0.7in, 1.3in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Firestore document unique key.",
  "claimId", "String", "No", "FK", "None", "Foreign key referencing parent `/claims/{claimId}`.",
  "verifierId", "String", "No", "FK", "None", "Foreign key referencing `/users/{uid}`.",
  "verifierName", "String", "No", "None", "None", "Snapshot of verifier's display name at vote time.",
  "verifierReputation", "Integer", "No", "None", "50", "Snapshot of verifier's reputation score at vote time.",
  "verdict", "String", "No", "None", "None", "Voted verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE'.",
  "sourceUrl", "String", "No", "None", "None", "Valid HTTP/HTTPS primary source citation URL.",
  "rationale", "String", "No", "None", "None", "Mandatory explanation (min 20, max 1,000 chars).",
  "sourceCredibility", "Integer", "No", "None", "50", "Evaluated domain authority rating [0 to 100].",
  "votedAt", "Timestamp", "No", "None", "serverTimestamp()", "Verification submission timestamp in UTC."
)

#pagebreak()

==== Entity: DUPLICATE_CLUSTER (`/duplicateClusters/{clusterId}`)
#styled-table(
  columns: (1.2in, 0.9in, 0.6in, 0.7in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Cluster document identifier.",
  "canonicalClaimId", "String", "No", "FK", "None", "Reference to the primary canonical claim document.",
  "duplicateText", "String", "No", "None", "None", "Raw variant text of the duplicate forward.",
  "jaccardScore", "Float", "No", "None", "None", "Calculated token overlap similarity [0.75 to 1.00].",
  "detectedAt", "Timestamp", "No", "None", "serverTimestamp()", "Timestamp when duplicate match occurred."
)

==== Entity: CATEGORY_METRIC (`/metrics/{category}`)
#styled-table(
  columns: (1.2in, 0.9in, 0.6in, 0.7in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "category", "String", "No", "PK", "None", "Topical category name (e.g., 'Health', 'Politics').",
  "totalClaims", "Integer", "No", "None", "0", "Cumulative count of claims filed under this category.",
  "verifiedCount", "Integer", "No", "None", "0", "Count of claims achieving certified status ($C >= 70\%$).",
  "contestedCount", "Integer", "No", "None", "0", "Count of claims expiring without consensus.",
  "lastUpdated", "Timestamp", "No", "None", "serverTimestamp()", "Timestamp of most recent aggregation update."
)

#pagebreak()

=== Relationship Constraints & Integrity Rules
1. *One-to-Many Submission (`User` $arrow.r$ `Claim`, 0..N):* An individual user may submit zero or multiple claims. A claim may be submitted by an authenticated user or tagged with `"anonymous"` if submitted unauthenticated.
2. *One-to-Many Verification (`User` $arrow.r$ `Verification`, 0..N):* An authenticated verifier may review multiple claims over time.
3. *One-to-Many Quorum Composition (`Claim` $arrow.r$ `Verification`, 0..N):* A claim receives zero or more verification votes. Once the quorum count reaches three ($N >= 3$), the claim transitions to consensus evaluation.
4. *Anti-Self-Verification Integrity Rule:* A verifier is strictly prohibited from verifying a claim they submitted:
   $ "Verification.verifierId" != "Claim.submittedBy" $
   This constraint is enforced declaratively at the database boundary via Firestore security rules.
5. *One-to-Many Duplicate Grouping (`Claim` $arrow.r$ `DuplicateCluster`, 0..N):* A canonical claim can represent multiple duplicate forwards across chat groups.

#pagebreak()

== Object-Oriented UML Class Model
The Object-Oriented Class Model defines the software architecture, encapsulation boundaries, class contracts, and design patterns governing FactStamp's runtime execution.

=== Domain Classes & Class Specifications
The system architecture decomposes into seven primary object-oriented classes:

1. *`User` (Domain Entity Class):* Private attributes (`uid`, `displayName`, `email`, `reputation`, `totalVerifications`, `isAdmin`, `joinedAt`). Methods: `updateReputation(delta)` mutates reputation ($[0, 100]$); `canVerifyClaim(claim)` validates voter eligibility; `isEligibleAdmin()` verifies elevated permissions.
2. *`Claim` (Aggregate Root Entity Class):* Encapsulates claim text, optional screenshot URL, lifecycle status, certified verdict, confidence rating, category, submitter ID, submission timestamp, and verification array. Methods: `addVerification(vote)`; `hasReachedQuorum()` checks $N >= 3$; `isSubmittedBy(uid)`; `getLeadingVerdict()`.
3. *`Verification` (Value / Child Entity Class):* Encapsulates vote identifier, target claim ID, verifier metadata snapshot, chosen verdict enum, primary source URL, rationale, credibility rating, and vote timestamp. Methods: `validateUrl()` checks URL syntax and HTTPS protocol; `evaluateSourceDomain()` returns domain authority.
4. *`ConsensusResult` (Value Object Class):* Immutable output object encapsulating `verdict`, composite `confidence` percentage, `agreementRatio` ($A$), `verifierReputationAvg` ($R$), `sourceQualityAvg` ($S$), and boolean `isCertified` flag.
5. *`ConsensusCalculator` (Domain Service Class):* Stateless domain engine computing multi-factor confidence: $C = 0.40 A + 0.30 R + 0.30 S$. Evaluates quorum votes, computes sub-metrics, and produces a sealed `ConsensusResult`.
6. *`DuplicateDetector` (Utility Service Class):* Stateless utility performing text normalization, tokenization, stop-word elimination, and pairwise Jaccard similarity index computation ($J >= 0.75$) across cached claims.
7. *`FactCardGenerator` (Presentation Service Class):* Orchestrates client-side DOM-to-canvas rendering via `html-to-image` via browser-native SVG `<foreignObject>` rasterization, executing the OKLCH-to-sRGB transformer and exporting square $1080 times 1080$px PNG image buffers.

#pagebreak()

=== UML Class Diagram
The complete Object-Oriented UML Class Diagram depicting class attributes, method signatures, visibility modifiers, and inter-class relationships is illustrated below:

#v(8pt)
#responsive-image("attachments/class_diagram.svg", width: 90%, max-height: 580pt)

#pagebreak()

=== Architectural Design Patterns Implemented
The object-oriented design leverages three proven enterprise design patterns:

1. *Repository Pattern (Data Access Decoupling):*
   - Database operations (reading claims, querying duplicates, appending votes) are decoupled from UI components into specialized repository services (`claimService.ts`, `authService.ts`). UI components remain completely agnostic of Firestore SDK specifics, facilitating automated unit testing and mock injection.

2. *Strategy Pattern (Algorithmic Flexibility):*
   - The consensus calculation and duplicate detection algorithms are implemented as standalone service strategies. If the similarity metric transitions from Jaccard index to Locality Sensitive Hashing (LSH) or the consensus weights are tuned, only the strategy implementation is modified without impacting dependent UI controllers.

3. *Observer Pattern (Real-Time Reactive Streaming):*
   - Google Cloud Firestore's `onSnapshot` listener implements the Observer pattern at the transport layer. When a verifier submits a vote, Firestore notifies all subscribed client observers over persistent WebSockets, reactively updating quorum progress bars across all active browser sessions without polling.

=== Structural & Behavioral Relationship Analysis
#styled-table(
  columns: (1.3in, 1.2in, 1.4in, 1.6in),
  headers: ("Class Linkage", "UML Relationship", "Multiplicity", "Behavioral Justification"),
  "`User` to `Claim`", "Aggregation", "`1` to `0..*`", "A user creates claims over time; if a user deletes their profile, submitted public claims persist in the fact registry for civic continuity.",
  "`User` to `Verification`", "Aggregation", "`1` to `0..*`", "A user authors multiple verification votes. Historical votes remain linked to the verifier's historical track record.",
  "`Claim` to `Verification`", "Composition", "`1` to `0..*`", "Verifications are lifecycle-bound to their parent claim. A verification cannot exist independently of the claim it evaluates.",
  "`ConsensusCalculator` to `Claim`", "Dependency (`..>`)", "Stateless Usage", "`ConsensusCalculator` receives a `Claim` instance, computes the mathematical confidence score, and returns an immutable `ConsensusResult`.",
  "`DuplicateDetector` to `Claim`", "Dependency (`..>`)", "Stateless Usage", "`DuplicateDetector` tokenizes incoming forward strings and computes pairwise Jaccard similarity against cached claims.",
  "`FactCardGenerator` to `Claim`", "Dependency (`..>`)", "Stateless Usage", "`FactCardGenerator` reads the certified verdict and metadata from a `Claim` to rasterize a shareable 1080×1080px fact card."
)

#pagebreak()

// ==========================================
// REFERENCES
// ==========================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Chen, P. P., *"The Entity-Relationship Model: Toward a Unified View of Data,"* _ACM Transactions on Database Systems (TODS)_, vol. 1, no. 1, pp. 9-36, 1976.
3. Fowler, M., *"UML Distilled: A Brief Guide to the Standard Object Modeling Language,"* 3rd ed., Addison-Wesley Professional, 2003.
4. Gamma, E., Helm, R., Johnson, R., & Vlissides, J., *"Design Patterns: Elements of Reusable Object-Oriented Software,"* Addison-Wesley, 1994.
5. Google Firebase Documentation, *"Cloud Firestore Data Model: Documents and Collections,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore/data-model`.
6. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
7. Pressman, R. S., & Maxim, B. R., *"Software Engineering: A Practitioner's Approach,"* 9th ed., McGraw-Hill Education, 2020.
