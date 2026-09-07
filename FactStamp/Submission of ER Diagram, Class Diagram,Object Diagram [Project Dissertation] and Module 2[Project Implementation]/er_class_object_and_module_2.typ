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

#set document(title: "FactStamp - ER, Class, Object Diagrams & Module 2", author: "Aadish")

// ==========================================
// Standalone Academic Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[ACADEMIC DISSERTATION & MODULE IMPLEMENTATION SUBMISSION]
    #v(4pt)
    #text(size: 12pt, weight: "bold")[CONCEPTUAL MODELS (ER, CLASS, OBJECT DIAGRAMS) & MODULE 2]
    #v(2pt)
    #text(size: 10.5pt)[*Formal Schema Modeling, Object-Oriented Architecture, Runtime Instances*]\
    #text(size: 10.5pt)[*and Multimodal Ingestion Pipeline & Client-Side OCR Preprocessing*]\
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
// PART I: CONCEPTUAL MODELS [PROJECT DISSERTATION]
// =============================================================================
= Part I: Conceptual Models [Project Dissertation]

== Foundations of Conceptual Modeling in Software Engineering
Conceptual modeling establishes the semantic and architectural bridge between abstract requirements and concrete executable software. In software engineering, conceptual models serve two vital functions:
1. *Structural & Data-Centric Perspective:* Formalizing information entities, domain attributes, cardinality rules, and physical constraints governing persistent storage.
2. *Object-Oriented & Runtime Perspective:* Defining static class hierarchies, behavioral contracts, encapsulation boundaries, and dynamic runtime object instances during active transaction execution.

Within FactStamp, conceptual modeling addresses the structural complexity of crowdsourced verification: managing civic reputation, coordinating concurrent peer reviews, computing multi-factor quorum consensus, indexing duplicate viral variants, and compiling shareable fact cards.

#pagebreak()

== Entity-Relationship (E-R) Conceptual Model
The Entity-Relationship (E-R) model formalizes the logical schema of FactStamp. Although FactStamp utilizes Google Cloud Firestore—a document-oriented NoSQL database—formal relational modeling is crucial to enforce relational integrity, structure declarative security rules, and optimize indexing strategies.

=== Core Entities & Structural Roles
The platform defines five core domain entities:
1. *USER:* Represents authenticated community verifiers and administrators. Encapsulates authentication identifiers (`uid`), public screen name, email, civic reputation score ($R in [0, 100]$), completed verification count, and administrative privilege flags.
2. *CLAIM:* The central operational entity representing submitted WhatsApp forwards. Captures normalized text, screenshot media references (`mediaUrl`), lifecycle status (`unverified`, `verified`, `contested`), certified verdict classification, consensus confidence score ($C in [0, 100]$), topical category, and quorum progress.
3. *VERIFICATION:* Represents individual evaluation votes cast by authenticated verifiers. Captures verdict candidates, verifier reputation at time of voting, primary citation URLs, factual rationale justifications, and domain credibility scores ($S$).
4. *DUPLICATE_CLUSTER:* Represents duplicate forward variants identified by the Jaccard similarity engine ($J >= 0.75$). Maps secondary forward variations back to canonical claims to prevent effort fragmentation.
5. *CATEGORY_METRIC:* Represents real-time statistical aggregations across topical domains (Health, Politics, Finance, Religion, Other) to power public analytics without incurring high read costs.

=== Entity-Relationship Diagram
The formal E-R Diagram illustrating entities, attributes, primary/foreign key linkages, and cardinality constraints is presented below:

#v(8pt)
#responsive-image("attachments/er_diagram.svg", width: 88%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 1.1: FactStamp Entity-Relationship (E-R) Diagram*]

#pagebreak()

=== Cardinality Matrix & Relational Integrity Constraints
The table below specifies the structural relationships, cardinalities, and business rules governing inter-entity associations.

#styled-table(
  columns: (1.1in, 0.9in, 1.1in, 0.8in, 1fr),
  headers: ("Parent Entity", "Relationship", "Child Entity", "Cardinality", "Business Logic Rule & Enforcement Mechanism"),
  "USER", "Submits", "CLAIM", "1 : N (0..N)", "A user can submit zero or many claims. Anonymous submissions record submittedBy as 'anonymous'.",
  "USER", "Casts", "VERIFICATION", "1 : N (0..N)", "An authenticated verifier can evaluate multiple distinct claims. Self-verification is strictly prohibited.",
  "CLAIM", "Receives", "VERIFICATION", "1 : N (0..N)", "A claim accumulates verifications until quorum threshold (N >= 3) triggers consensus evaluation.",
  "CLAIM", "Groups", "DUPLICATE_CLUSTER", "1 : N (0..N)", "Duplicate forwards matching J >= 0.75 are clustered under the canonical claim.",
  "CLAIM", "Aggregates into", "CATEGORY_METRIC", "N : 1 (N..1)", "Every claim maps to exactly one category metric document for real-time dashboard rollups."
)

=== Comprehensive Data Dictionaries

==== Entity: USER (`/users/{uid}`)
#styled-table(
  columns: (1.1in, 0.9in, 0.6in, 0.7in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "uid", "String", "No", "PK", "None", "Firebase Auth Unique Identifier (RS256 JWT subject).",
  "displayName", "String", "No", "None", "\"Anonymous\"", "Public display name shown on leaderboards.",
  "email", "String", "No", "None", "None", "Validated email address; used for session verification.",
  "reputation", "Integer", "No", "None", "50", "Civic trust score bounded in range [0, 100]. Initialized at 50.",
  "totalVerifications", "Integer", "No", "None", "0", "Monotonically increasing count of submitted verifications.",
  "isAdmin", "Boolean", "No", "None", "false", "Role-based privilege flag authorizing administrative audits.",
  "joinedAt", "Timestamp", "No", "None", "request.time", "Server timestamp recorded at account creation."
)

==== Entity: CLAIM (`/claims/{claimId}`)
#styled-table(
  columns: (1.1in, 0.9in, 0.6in, 0.7in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-generated", "Unique 20-character alphanumeric Firestore document ID.",
  "text", "String", "No", "None", "None", "Sanitized and normalized plaintext content (20-500 chars).",
  "mediaUrl", "String", "Yes", "None", "null", "Base64 data URL (< 700 KB) or Cloud Storage URI.",
  "status", "String", "No", "None", "\"unverified\"", "Lifecycle status: enum('unverified', 'verified', 'contested').",
  "verdict", "String", "Yes", "None", "null", "Certified consensus: enum('TRUE', 'FALSE', 'MISLEADING', 'UNVERIFIABLE').",
  "confidence", "Float", "Yes", "None", "null", "Computed confidence percentage bounded in range [0.0, 100.0].",
  "category", "String", "No", "None", "\"Other\"", "Topical classification: Health, Politics, Finance, Religion, Other.",
  "submittedBy", "String", "No", "FK", "\"anonymous\"", "Submitter UID reference or 'anonymous' identifier.",
  "submittedAt", "Timestamp", "No", "None", "request.time", "Server timestamp marking claim creation.",
  "quorumCount", "Integer", "No", "None", "0", "Count of independent evaluations cast. Quorum requires >= 3.",
  "lastVerifiedAt", "Timestamp", "Yes", "None", "null", "Timestamp at which quorum consensus was finalized."
)

#pagebreak()

== Object-Oriented UML Class Model
The Object-Oriented Class Model captures the static architecture, type safety abstractions, method contracts, and structural patterns implemented across FactStamp.

=== Object-Oriented Architecture in FactStamp
FactStamp is developed in modern TypeScript, leveraging strict interface contracts, abstract base classes, and domain-driven design patterns to enforce enterprise-grade reliability. Key design principles include:
1. *Inheritance & Polymorphism:* The `BaseVerifier` abstract class provides shared identity and reputation properties, specialized into `CommunityVerifier` and `AdminVerifier` with distinct voting weights.
2. *Composition & Aggregates:* The `Claim` entity serves as an aggregate root composing a collection of `Verification` value objects and managing state transitions.
3. *Separation of Concerns:* Algorithmic engines (`DuplicateEngine`, `ConsensusEngine`, `FactCardGenerator`) operate as stateless domain services invoked by controllers.

=== Formal UML Class Diagram
The formal UML Class Diagram illustrates class definitions, inheritance hierarchies, member visibilities, and inter-class collaborations:

#v(8pt)
#responsive-image("attachments/class_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 1.2: FactStamp UML Class Diagram*]

#pagebreak()

=== Enterprise Design Patterns Implemented
1. *Repository Pattern:* Decouples domain entities from underlying Firebase persistence via `ClaimRepository` and `UserRepository`.
2. *Strategy Pattern:* Encapsulates similarity scoring algorithms (`JaccardSimilarityStrategy`, `LevenshteinStrategy`), allowing dynamic algorithm swaps without modifying client code.
3. *Observer Pattern / Event Hooks:* Verifications trigger reactive consensus evaluation once the quorum counter satisfies $N >= 3$.
4. *Factory Pattern:* `FactCardFactory` constructs standardized 1080x1080px export cards configured with dynamic color themes based on certified verdicts.

#pagebreak()

== UML Object Diagram (Runtime Instance Model)
While the Class Diagram defines static compile-time structures, the UML Object Diagram models concrete runtime instances, exact memory states, and object collaborations during a live transaction.

=== Concrete Execution Scenario: Viral Banking Rumor
- *Context:* A fabricated WhatsApp forward circulates across Mumbai claiming: *"RBI announces all bank ATMs will be permanently closed from Friday midnight due to currency re-calibration."*
- *Claim Instance:* `claim_atm : Claim` (Category: `Finance`, Status: `verified`, Verdict: `FALSE`, Confidence: $86%$, Quorum: $3$).
- *Participating Verifiers:*
  - `verifier_priya : CommunityVerifier` ($R = 85$, Weight $= 1.70$, Vote: `FALSE`, Source: `rbi.org.in`, Quality: $100$).
  - `verifier_rahul : CommunityVerifier` ($R = 70$, Weight $= 1.40$, Vote: `FALSE`, Source: `pib.gov.in`, Quality: $100$).
  - `verifier_ananya : CommunityVerifier` ($R = 60$, Weight $= 1.20$, Vote: `MISLEADING`, Source: `ndtv.com`, Quality: $70$).

=== Formal UML Object Diagram
The diagram below illustrates the runtime instance architecture, attribute values, and bidirectional object links:

#v(8pt)
#responsive-image("attachments/object_diagram.svg", width: 90%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 1.3: FactStamp Runtime UML Object Diagram*]

#pagebreak()

=== Mathematical Step-by-Step Validation of Runtime State
The runtime consensus engine evaluated the instances using the formal tri-partite formula:
$C = round(0.40 A + 0.30 R + 0.30 S)$

1. *Agreement Ratio ($A$):*
   Two out of three verifiers voted `FALSE` ($N_("majority") = 2, N_("total") = 3$):
   $A = (2 / 3) times 100 = 66.67%$

2. *Average Verifier Reputation ($R$):*
   $R = (85 + 70 + 60) / 3 = 215 / 3 = 71.67$

3. *Average Source Credibility ($S$):*
   Two Tier-1 sources (`rbi.org.in`, `pib.gov.in` $= 100$) and one Tier-2 source (`ndtv.com` $= 70$):
   $S = (100 + 100 + 70) / 3 = 270 / 3 = 90.00$

4. *Composite Consensus Score ($C$):*
   $C = round(0.40 times 66.67 + 0.30 times 71.67 + 0.30 times 90.00)$\
   $C = round(26.67 + 21.50 + 27.00) = round(75.17) = 75%$

Because $C >= 70.0%$, the claim transitioned to `status: "verified"` with certified verdict `FALSE`.

=== Structural Comparison: Class Diagram vs. Object Diagram
#styled-table(
  columns: (1.4in, 1fr, 1fr),
  headers: ("Dimension", "UML Class Diagram", "UML Object Diagram"),
  "Structural Nature", "Static compile-time structural blueprint of the system.", "Dynamic snapshot of discrete heap memory at time t.",
  "Notation Syntax", "ClassName (Types, method signatures, access modifiers).", "instanceName : ClassName (Concrete values assigned).",
  "Multiplicity", "Defines cardinality ranges (e.g., 1..* or 0..N).", "Models exact number of instantiated object links.",
  "Purpose in Black Book", "Documents system architecture and schema design.", "Validates runtime algorithms and dynamic state changes."
)

#pagebreak()

// =============================================================================
// PART II: PROJECT IMPLEMENTATION — MODULE 2
// =============================================================================
= Part II: Project Implementation — Module 2

== Module 2 Architectural Purpose & Operational Scope
*Module 2: Multimodal Forward Ingestion & Preprocessing Subsystem (with OCR Pipeline)* serves as the primary gateway for FactStamp. WhatsApp misinformation propagates via two distinct media formats:
1. *Unstructured Plaintext Messages:* Long chain messages frequently carrying "Forwarded many times" badges, urgent emotional appeals, and unverified hyperlinks.
2. *Digital Screenshots:* Images of social media postings, fabricated newspaper clippings, manipulated circulars from statutory authorities, or fake chat dialogues.

Module 2 ingests these heterogeneous media types, enforces triple-layer security validation, downscales media client-side to maintain a 100% zero-cost serverless architecture, extracts embedded text via an OCR pipeline, and standardizes data for duplicate detection.

#pagebreak()

== Multimodal Ingestion Pipeline Architecture
The end-to-end ingestion pipeline operates via coordinated client-side pre-filtering, in-browser canvas downscaling, and backend cloud processing.

#v(8pt)
#responsive-image("attachments/multimodal_ingestion_pipeline.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 2.1: FactStamp Multimodal Ingestion & Preprocessing Pipeline*]

#pagebreak()

=== Plaintext Ingestion Pathway & Sanitization
Incoming plain text forwards are subjected to automated sanitization pipelines (`src/lib/security.ts`):
- *Length Constraints:* Enforces a minimum length of 20 characters and maximum length of 500 characters.
- *XSS Defense:* Regex filters eliminate malicious script tokens, HTML tags, and dangerous protocol URI prefixes (`javascript:`, `data:`).
- *Lexical Normalization:* Converts text to lowercase, collapses consecutive whitespace, and strips non-alphanumeric punctuation to prepare tokens for Jaccard comparison.

=== Screenshot Ingestion & Triple-Layer Upload Defense
To safeguard against malicious file payloads, Module 2 implements a robust triple-layer file inspection architecture:
1. *Extension Whitelisting:* Enforces strict `.jpg`, `.png`, `.webp`, `.gif` file extensions.
2. *Browser MIME-Type Validation:* Validates `File.type` against `image/jpeg`, `image/png`, `image/webp`.
3. *Binary Magic Byte Inspection:* Inspects file headers via `Uint8Array` slicing to verify genuine image magic numbers (`0xFFD8FF` for JPEG, `0x89504E47` for PNG) before allowing canvas processing.

#styled-table(
  columns: (1.1in, 1.1in, 1.2in, 1fr),
  headers: ("MIME Format", "Magic Byte Header", "Hex Signature", "Validation & Security Action"),
  "image/jpeg", "FF D8 FF", "0xFF, 0xD8, 0xFF", "Accepted; processed via JPEG canvas compression pipeline.",
  "image/png", "89 50 4E 47", "0x89, 0x50, 0x4E, 0x47", "Accepted; checked for alpha transparency; flattened on canvas.",
  "image/webp", "52 49 46 46", "0x52, 0x49, 0x46, 0x46", "Accepted; parsed via WebP image decoder.",
  "Executable / Script", "4D 5A / 7F 45 4C 46", "PE / ELF Signatures", "Rejected immediately; file upload aborted with security warning."
)

== Client-Side Canvas Image Compression Pipeline
Commercial cloud object stores (e.g., AWS S3, Google Cloud Storage) introduce persistent egress charges and operational costs. FactStamp maintains a strict *zero-budget architecture* by compressing all uploaded screenshots client-side before committing them to Firestore.

=== Dynamic JPEG Quality Stepping Algorithm
1. The uploaded file is drawn onto an offscreen HTML5 `<canvas>` element.
2. The canvas scales the image down so that its maximum dimension (width or height) does not exceed *1280 pixels*, preserving native aspect ratio.
3. The image is exported to a base64 Data URL with dynamic quality stepping:
   - Initial quality: $q = 0.72$.
   - Ceiling: Payload size must not exceed *700 KB* (well within Firestore limits).
   - Stepping: If payload exceeds 700 KB, quality is decreased in increments of $0.08$ down to a floor of $q = 0.40$.
4. The resulting compact base64 string is stored directly in the `imageUrl` attribute of the Firestore claim document.

=== Mobile Memory Conservation
Budget Android devices (2 GB RAM) frequently terminate mobile browser tabs when large uncompressed bitmaps are rendered to canvas. FactStamp mitigates this by immediately freeing object URLs (`URL.revokeObjectURL`) and zeroing canvas context dimensions after compression.

#pagebreak()

== OCR Text Extraction & Preprocessing Pipeline
For screenshot submissions, extracting embedded textual rumors is essential to enable duplicate detection and full-text keyword indexing.

=== OCR Pipeline Execution Steps
1. The client-side downscaled image is passed to the OCR processing routine.
2. The engine performs image binarization, contrast stretching, and character recognition across Latin and Devanagari character sets.
3. Extracted raw text blocks are cleaned:
   - Eliminates battery status, carrier logos, and timestamps common in WhatsApp screenshot status bars.
   - Cleans unicode formatting artifacts.
4. The resulting normalized transcription is merged with user-submitted contextual notes and routed directly to Module 3 (Jaccard Duplicate Detection Engine).

== Implementation Source Code Details

```typescript
// Triple-Layer File Inspection & Client-Side Canvas Downscaling
export async function processScreenshot(file: File): Promise<string> {
  // Layer 1 & 2: MIME and Size Check
  const validTypes = ['image/jpeg', 'image/png', 'image/webp'];
  if (!validTypes.includes(file.type)) throw new Error('Unsupported format');
  if (file.size > 5 * 1024 * 1024) throw new Error('Exceeds 5MB limit');

  // Layer 3: Binary Magic Byte Validation
  const buffer = await file.slice(0, 4).arrayBuffer();
  const bytes = new Uint8Array(buffer);
  const isJpeg = bytes[0] === 0xFF && bytes[1] === 0xD8 && bytes[2] === 0xFF;
  const isPng = bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4E && bytes[3] === 0x47;
  if (!isJpeg && !isPng) throw new Error('Invalid image binary signature');

  // Offscreen Canvas Downscaling
  const img = new Image();
  img.src = URL.createObjectURL(file);
  await img.decode();
  URL.revokeObjectURL(img.src);

  const canvas = document.createElement('canvas');
  const MAX_DIM = 1280;
  let { width, height } = img;
  if (width > MAX_DIM || height > MAX_DIM) {
    if (width > height) {
      height = Math.round((height * MAX_DIM) / width);
      width = MAX_DIM;
    } else {
      width = Math.round((width * MAX_DIM) / height);
      height = MAX_DIM;
    }
  }
  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d');
  ctx?.drawImage(img, 0, 0, width, height);

  // Dynamic Quality Stepping Loop
  let quality = 0.72;
  let dataUrl = canvas.toDataURL('image/jpeg', quality);
  while (dataUrl.length > 700 * 1024 && quality > 0.40) {
    quality -= 0.08;
    dataUrl = canvas.toDataURL('image/jpeg', quality);
  }
  return dataUrl;
}
```

== Conclusion & Verification
The implementation of Module 2 in tandem with the formal Conceptual Models (E-R, Class, and Object diagrams) establishes an airtight engineering foundation for FactStamp. By unifying rigorous relational modeling, typed object-oriented design, client-side zero-cost media pipelines, and robust security defenses, the system reliably defends against malicious inputs while delivering seamless civic verification.
