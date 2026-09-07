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

#set document(title: "FactStamp - Conceptual Models: Component Diagram", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: COMPONENT DIAGRAM & INTERFACES]
    #v(2pt)
    #text(size: 10.5pt)[*Component-Based Architecture, Interface Contracts & Service Boundaries*]
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
// 3.6 CONCEPTUAL MODELS: COMPONENT DIAGRAM
// =============================================================================
= Conceptual Models: Software Component Architecture

== Foundations of Component-Based Software Engineering (CBSE)
Component-Based Software Engineering (CBSE) emphasizes the design of software systems as assemblies of autonomous, loosely coupled, and independently replaceable modules known as components. A software component encapsulates its internal data representations and execution logic, exposing its capabilities exclusively through well-defined *Provided Interfaces* (services offered to other components) and consuming dependencies via *Required Interfaces* (services expected from collaborating components).

In the context of FactStamp, component modeling provides substantial architectural advantages:
1. *Subsystem Decoupling:* Isolating client-side image downscaling from serverless routing and NoSQL database adapters ensures that modifications to storage or external AI engines (such as switching OCR providers) do not cascade into user interface components.
2. *Contract-Driven Development:* Expressing interactions via strict TypeScript interface definitions guarantees type safety and simplifies automated unit testing using mock adapters.
3. *Zero-Cost Optimization:* Delineating component responsibilities enables offloading expensive compute operations (such as bitmap downscaling and canvas rasterization) to the client web browser component, preserving serverless execution limits.

#pagebreak()

== Software Component Architecture Diagram

=== Subsystems and Interface Topology
FactStamp is structured into nine specialized functional components connected through standard ball-and-socket interface conventions:
- *Provided Interfaces (Ball Notation):* Services exposed by a component (`IClaimSubmit`, `IAuthService`, `IOCRService`, `IDedupCheck`, `IVerifyQueue`, `IConsensusEval`, `IFactCardExport`, `IFirestoreStorage`).
- *Required Interfaces (Socket Notation):* Consumer dependencies required by client components to fulfill their functional obligations.

=== Visual UML Component Diagram
The formal UML Component Diagram modeling component boundaries, provided interfaces, and required dependencies is presented below:

#v(8pt)
#responsive-image("attachments/component_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp Software Component & Interface Architecture Diagram*]

#pagebreak()

=== Subsystem Components Catalog
#styled-table(
  columns: (1.3in, 1.2in, 1.2in, 1fr),
  headers: ("Component Name", "Provided Interface", "Required Interface", "Component Role & Functional Scope"),
  "Web Presentation", "None (Top UI)", "ISubmit, IAuth, IQueue, IExport", "Next.js React client rendering submission forms, review queues, and analytical charts.",
  "Ingestion Resizer", "IClaimSubmit", "IOCRService, IDedupCheck", "Executes magic byte inspection, offscreen canvas downscaling, and text sanitization.",
  "OCR Adapter", "IOCRService", "None (Wasm Engine)", "Executes client-side WebAssembly neural LSTM OCR (Tesseract.js) to convert screenshot bitmaps into machine-readable text without external cloud APIs.",
  "Duplicate Engine", "IDedupCheck", "IFirestoreStorage", "Tokenizes text, filters stop words, and evaluates Jaccard set similarity against candidate claims.",
  "Quorum Queue", "IVerifyQueue", "IConsensusEval, IFirestoreStorage", "Manages unverified claims queue; validates self-verification locks and triggers consensus at N >= 3.",
  "Consensus Engine", "IConsensusEval", "IFirestoreStorage, IFactCardExport", "Executes the tri-partite weighted formula C = 0.40A + 0.30R + 0.30S; updates reputation scores.",
  "Fact Card Gen", "IFactCardExport", "None (DOM Engine)", "Serializes DOM nodes into high-DPI 1080x1080px PNG Fact Cards via html-to-image.",
  "Auth Gateway", "IAuthService", "None (OIDC Provider)", "Manages user login, session token validation, and RS256 JWT claims via Firebase Auth.",
  "Firestore DAO", "IFirestoreStorage", "None (GCP Client)", "Executes atomic NoSQL reads, writes, transactions, and real-time document listeners."
)

#pagebreak()

== Formal Interface Definitions & Method Contracts

The operational interfaces governing inter-component communication are formalized using strict TypeScript interface specifications:

```typescript
// 1. Ingestion & Submission Interface
export interface IClaimSubmit {
  submitClaim(payload: {
    text?: string;
    imageFile?: File;
    category: 'Health' | 'Politics' | 'Finance' | 'Religion' | 'Other';
  }): Promise<{ claimId: string; isDuplicate: boolean; canonicalId?: string }>;
}

// 2. Optical Character Recognition (OCR) Interface
export interface IOCRService {
  extractText(imageBlob: Blob): Promise<{ text: string; confidence: number }>;
}

// 3. Duplicate Detection Interface
export interface IDedupCheck {
  findDuplicates(
    tokens: Set<string>,
    category: string
  ): Promise<{ isDuplicate: boolean; canonicalId?: string; similarityScore: number }>;
}

// 4. Verification Queue & Review Interface
export interface IVerifyQueue {
  submitVerification(vote: {
    claimId: string;
    verifierId: string;
    verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE';
    sourceUrl: string;
    rationale: string;
  }): Promise<{ success: boolean; newQuorumCount: number }>;
}

// 5. Consensus Scoring Engine Interface
export interface IConsensusEval {
  evaluateConsensus(claimId: string): Promise<{
    certifiedVerdict: string;
    confidenceScore: number;
    status: 'verified' | 'contested';
  }>;
}

// 6. Fact Card Export Interface
export interface IFactCardExport {
  generateCardPNG(claimData: {
    id: string;
    verdict: string;
    confidence: number;
    text: string;
    sources: string[];
  }): Promise<Blob>;
}
```

#pagebreak()

== Non-Functional Component Characteristics

=== Modularity & Replaceability
- *Pluggable OCR Adapters:* The `OCR Adapter Component` implements `IOCRService` using an offline-first, zero-API client-side WebAssembly neural LSTM OCR engine (Tesseract.js). Operating entirely within the client's browser eliminates recurring third-party API costs, protects user privacy, and guarantees uninterrupted offline functionality. Furthermore, encapsulating text extraction behind the abstract `IOCRService` interface ensures that high-throughput cloud vision engines or alternate models can be substituted without altering the `Ingestion Resizer Component` or UI layer.
- *Database Independence:* The `Firestore DAO Component` isolates document mapping logic. If the persistent store is migrated from Firestore to PostgreSQL or Supabase, only the DAO implementation requires modification.

=== Fault Isolation & Error Boundaries
- *Client Canvas Error Shield:* If client-side canvas memory allocation fails on ultra-low-memory mobile devices, the `Ingestion Component` gracefully falls back to direct serverless compression rather than crashing the UI process.
- *Transactional Rollback:* The `Quorum Queue Component` utilizes Firestore atomic transactions (`runTransaction`), ensuring that simultaneous vote submissions cannot corrupt the `quorumCount` counter or result in orphaned verification documents.

== Structural Traceability to IEEE Std 830-1998 Requirements
#styled-table(
  columns: (1.1in, 1.2in, 1.1in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "Component Construct", "Implementation & Architectural Realization"),
  "REQ-1", "Multimodal Ingestion", "Ingestion & OCR Comp", "Canvas downscaling and WebAssembly Tesseract.js OCR engine.",
  "REQ-2", "Text Normalization", "Ingestion Resizer", "Sanitization regex pipelines and token normalization.",
  "REQ-3", "Duplicate Detection", "Duplicate Engine Comp", "Jaccard similarity calculation engine ($J >= 0.75$).",
  "REQ-4", "Quorum Peer Review", "Quorum Queue Comp", "Real-time queue listener and quorum threshold ($N >= 3$).",
  "REQ-5", "Domain Authority", "Consensus Engine Comp", "Authoritative domain tiers mapping (100 / 70 / 30).",
  "REQ-6", "Weighted Consensus", "Consensus Engine Comp", "Tri-partite multi-factor consensus scoring algorithm.",
  "REQ-7", "Fact Card Export", "Fact Card Generator", "Browser-native SVG foreignObject canvas rasterization.",
  "REQ-9", "Anti-Sybil Defense", "Auth Gateway & Queue", "JWT verification and self-verification lock enforcement.",
  "REQ-10", "Zero-Cost Serverless", "All Components", "Client offloading, serverless execution, and Firestore limits."
)

== Conclusion & Component Soundness
The UML Component Diagram and interface contracts establish a robust, modern software architecture for FactStamp. By encapsulating functionality within decoupled components, enforcing strict interface boundaries, and providing built-in fault isolation, the system achieves exceptional maintainability, high modularity, and long-term sustainability.
