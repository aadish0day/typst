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

#set document(title: "FactStamp - Conceptual Models: Package & Deployment Diagrams", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.6 CONCEPTUAL MODELS: PACKAGE DIAGRAM & DEPLOYMENT DIAGRAM]
    #v(2pt)
    #text(size: 10.5pt)[*Modular Subsystem Architecture, Dependency Management & Cloud Physical Topologies*]
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
// 3.6 CONCEPTUAL MODELS: PACKAGE & DEPLOYMENT DIAGRAMS
// =============================================================================
= Conceptual Models: Package & Deployment Models

== Foundations of Structural & Deployment Modeling in Modern Web Systems
Modern software engineering mandates a rigorous distinction between:
1. *Logical Architecture (Package Modeling):* The structural decomposition of source code into coherent, loosely coupled packages, namespaces, and sub-systems enforcing the Acyclic Dependencies Principle (ADP) and separation of concerns.
2. *Physical Architecture (Deployment Modeling):* The concrete deployment topology mapping software artifacts to executing hardware processing nodes, edge computing platforms, database clusters, and external third-party cloud APIs.

Within *FactStamp*, these two models formalize how a zero-budget, serverless application achieves enterprise-grade resilience. By delineating client-side execution from serverless backend functions and managed cloud persistence, FactStamp ensures high horizontal scalability, impenetrable security boundaries, and near-instantaneous page rendering.

#pagebreak()

== Subsystem Package Architecture (UML Package Diagram)

=== Subsystem Layering & Dependency Hierarchy
FactStamp enforces a five-tier unidirectional package hierarchy:
1. *Presentation Layer (`app/`, `components/`):* Houses React view components, client-side route controllers, touch ergonomics, and modal dialogs.
2. *Application Services Layer (`services/`):* Coordinates end-to-end business workflows, orchestrating between domain entities and cloud persistence adapters.
3. *Domain Core & Business Logic (`domain/`):* Encapsulates pure domain models, lexical set algorithms (Jaccard similarity), and mathematical consensus formulas.
4. *Security & Anti-Sybil Defense (`security/`):* Enforces JWT verification, rate limiting, anti-spam heuristics, and self-verification locks.
5. *Infrastructure & Persistence Layer (`infrastructure/`):* Houses concrete adapters for Google Cloud Firestore, Firebase Authentication, and client-side WebAssembly OCR (Tesseract.js).

=== Visual UML Package Diagram
The formal UML Package Diagram illustrating the subsystem decomposition and unidirectional dependencies is presented below:

#v(8pt)
#responsive-image("attachments/package_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp Subsystem Package Architecture Diagram*]

#pagebreak()

=== Package Inventory & Responsibilities
#styled-table(
  columns: (1.3in, 1.4in, 1.3in, 1fr),
  headers: ("Package Name", "Contained Components", "Layer Visibility", "Primary Engineering Responsibility"),
  "Presentation Layer", "SubmissionView, QueueView, FactCardModal, DashView", "Public / Client", "Renders responsive UI; captures user touch inputs; executes in-browser canvas downscaling.",
  "Application Services", "IngestSvc, DedupSvc, QueueSvc, ConsensusSvc, ExportSvc", "Serverless API", "Orchestrates transactional workflows; coordinates multi-step business logic.",
  "Domain Core", "ClaimAggregate, VerifyModel, JaccardEngine, ScoringAlgo", "Domain Internal", "Maintains business state invariants; executes mathematical formulas and set comparisons.",
  "Security Defense", "AuthGuard, SelfLock, SpamValidator, AuditLogger", "Cross-Cutting", "Validates RS256 JWT tokens; prevents self-verification and coordinated Sybil brigading.",
  "Infrastructure Layer", "FirestoreDAO, FirebaseAuthAdapter, OCRAdapter", "External Boundary", "Manages low-level gRPC/REST connections to Google Cloud and WebAssembly OCR execution."
)

=== Architectural Coupling & Modularity Metrics
- *Acyclic Dependencies Principle (ADP):* There are zero cyclic dependencies between packages. Dependencies flow strictly downwards: Presentation -> Application -> Domain / Infrastructure.
- *Stable Abstractions Principle (SAP):* Core domain packages (such as `ScoringAlgorithm` and `JaccardSimilarityEngine`) possess zero external framework dependencies, ensuring high testability with standard unit test runners.

#pagebreak()

== Physical Cloud Deployment Topology (UML Deployment Diagram)

=== Physical Infrastructure Tiers
FactStamp is deployed across five physical hardware and cloud environments:
1. *Client Hardware Tier:* Heterogeneous mobile smartphones (Android/iOS) and desktop workstations running modern web browsers (Chrome 100+, Safari 15.4+). Executes client-side image downscaling and in-browser neural optical character recognition via a WebAssembly worker (Tesseract.js LSTM engine).
2. *Edge CDN Infrastructure Tier:* Vercel's global Anycast Edge Network providing Anycast DNS, TLS 1.3 termination, and distributed static asset caching (SSG/ISR).
3. *Serverless Compute Tier:* Vercel Serverless Edge Functions running Node.js 20 runtimes. Ephemeral, stateless execution handling API routing, text sanitization, and consensus webhooks.
4. *Managed Cloud Database Tier:* Google Cloud Platform (Mumbai Region `asia-south1`) hosting Cloud Firestore NoSQL collections and the Firebase Security Rules engine.
5. *External Sovereign Services Tier:* Authoritative sovereign registries (`pib.gov.in`, `rbi.org.in`, `who.int`) cited as primary fact-checking evidence. Optical character recognition runs client-side in the browser via WebAssembly (Tesseract.js), keeping the external tier strictly reserved for sovereign verification portals.

=== Visual UML Deployment Diagram
The formal UML Deployment Diagram modeling physical nodes, artifacts, communication protocols, and execution boundaries is presented below:

#v(8pt)
#responsive-image("attachments/deployment_diagram.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.2: FactStamp Physical Hardware & Cloud Deployment Topology*]

#pagebreak()

=== Physical Node Specifications & Communication Protocols
#styled-table(
  columns: (1.2in, 1.2in, 1.1in, 1fr),
  headers: ("Deployment Node", "Hardware / Cloud Host", "Protocols Supported", "Deployed Software Artifacts & Boundaries"),
  "Client Device Tier", "Consumer Mobile / Desktop (2GB - 16GB RAM)", "HTTPS, WSS, WebAssembly", "Web Browser DOM, Next.js SPA/PWA Bundle, HTML5 Offscreen Canvas, WebAssembly OCR Worker (Tesseract.js).",
  "Edge CDN Tier", "Vercel Global Anycast Edge Network", "HTTP/2, HTTP/3, TLS 1.3", "Anycast DNS routing, static asset edge caches, DDoS mitigation.",
  "Serverless Compute Tier", "Vercel Serverless (Node.js 20 Runtime)", "HTTPS REST, JSON", "API route handlers (/api/claims, /api/verifications, /api/consensus).",
  "Cloud Database Tier", "Google Cloud Platform (asia-south1 Mumbai)", "gRPC over TLS, WebSocket", "Cloud Firestore NoSQL collections, Firebase Auth engine, firestore.rules.",
  "External Sovereign Tier", "Sovereign Government / Institutional Hosts", "HTTPS REST API", "Sovereign verification portals (pib.gov.in, rbi.org.in, who.int) for external claim verification."
)

=== Zero-Trust Network Boundaries & Transport Security
1. *TLS 1.3 Cryptographic Enforcement:* All transport channels between client devices, edge networks, serverless functions, and Google Cloud services mandate TLS 1.3 encryption.
2. *Stateless Authentication:* Inter-tier communication utilizes cryptographically verified RS256 JWT tokens issued by Firebase Auth, verified at both the serverless API boundary and the Firestore security rules engine.
3. *Regional Proximity:* All database and serverless compute clusters are provisioned within the Mumbai region (`asia-south1`), maintaining round-trip database latencies under $35$ milliseconds for Indian end-users.

#pagebreak()

== Architectural Scalability & Zero-Budget Constraints

=== High Availability & Horizontal Scaling
- *Elastic Serverless Concurrency:* Serverless API routes scale from zero to hundreds of concurrent executions automatically in response to viral misinformation spikes, with zero idle server costs.
- *Edge Asset Delivery:* Over 90% of requests (static HTML shells, icons, compiled JavaScript bundles) are resolved directly at Vercel Anycast edge caches without hitting backend compute or database tiers.

=== Free-Tier Allocation Compliance
FactStamp operates strictly within perpetual free quotas:
- *Cloud Firestore:* Bounded within 50,000 document reads and 20,000 document writes per day via aggregated metric rollups (`/metrics`) and Jaccard duplicate suppression.
- *Compute & Bandwidth:* 100 GB monthly bandwidth on Vercel Edge; client-side image compression guarantees that average image sizes stay below 350 KB, fitting thousands of submissions into the monthly tier.

== Structural Traceability to IEEE Std 830-1998 Requirements
#styled-table(
  columns: (1.1in, 1.2in, 1.1in, 1fr),
  headers: ("Requirement ID", "Requirement Description", "Architectural Construct", "Structural Realization & Mapping"),
  "REQ-1", "Multimodal Ingestion", "Client Tier Canvas", "Offscreen canvas downscaling on budget mobile browser nodes.",
  "REQ-2", "Text Normalization", "Application Services", "IngestionService executing sanitization pipelines.",
  "REQ-3", "Duplicate Detection", "Domain Core Layer", "JaccardSimilarityEngine computing set intersections.",
  "REQ-4", "Quorum Peer Review", "Compute & Database Tiers", "Serverless verification endpoints and atomic Firestore subcollections.",
  "REQ-6", "Weighted Consensus", "Domain Core Layer", "WeightedScoringAlgorithm executing tri-partite formula.",
  "REQ-7", "Fact Card Export", "Presentation & Service", "CardExportService generating 1080x1080px PNG Fact Cards.",
  "REQ-9", "Anti-Sybil Defense", "Security Layer & Rules", "SelfVerificationLock and declarative firestore.rules evaluation.",
  "REQ-10", "Zero-Cost Serverless", "Deployment Topology", "Vercel Edge compute paired with Google Cloud free tiers."
)

== Conclusion & Architectural Soundness
The UML Package and Deployment diagrams demonstrate that FactStamp possesses a clean, modular logical codebase and an exceptionally cost-effective, scalable physical infrastructure. By separating presentation from business logic and deploying stateless serverless functions alongside managed NoSQL storage, the system ensures perpetual availability and high responsiveness.
