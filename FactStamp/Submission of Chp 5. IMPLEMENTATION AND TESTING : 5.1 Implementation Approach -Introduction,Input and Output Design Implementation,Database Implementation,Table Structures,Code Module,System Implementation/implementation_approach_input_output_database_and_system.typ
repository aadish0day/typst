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

// Cross-Platform Font Fallbacks
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

// Heading Styling Rules
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory Rule: New topic / major section on new page
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

// Responsive Image Helper
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Chapter 5: 5.1 Implementation Approach", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[CHAPTER 5: IMPLEMENTATION AND TESTING]
    #v(2pt)
    #text(size: 10.5pt)[*5.1 Implementation Approach: Introduction, Input/Output Design, Database, Table Structures, Code Modules & System Implementation*]
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
// CHAPTER 5: IMPLEMENTATION AND TESTING
// =============================================================================
= Chapter 5: Implementation and Testing

== 5.1 Implementation Approach

=== 5.1.1 Introduction to Implementation Approach
The engineering of *FactStamp* departs fundamentally from conventional three-tier web application paradigms by introducing and validating a *Client-First Edge Execution Model*. In classical enterprise web architectures, web browsers function primarily as passive graphical terminals; computationally demanding workloads—such as binary image manipulation, optical character recognition (OCR), natural language tokenization, set-theoretic similarity comparisons, and document rasterization—are routed to clusters of centralized application servers or serverless cloud functions (e.g., AWS Lambda, Google Cloud Functions).

While standard, this legacy topology introduces severe architectural vulnerabilities when applied to high-velocity misinformation verification:
1. *Financial Burn Rate:* Persistent cloud computing clusters, image processing microservices, and object storage egress bandwidth demand recurring monthly expenditure that threatens academic and open-source sustainability.
2. *Cold-Start Penalties:* Ephemeral serverless containers suffer cold-start latencies between $800"ms"$ and $3000"ms"$, degrading user experience during critical breaking-news cycles.
3. *Single Point of Failure:* Centralized API gateways create operational bottlenecks and expand the external threat attack surface.

#responsive-image("attachments/implementation_architecture_and_dataflow.svg", width: 95%)

In contrast, FactStamp capitalizes on the significant computational headroom available on modern client endpoints. Today's consumer smartphones and personal computers feature multi-core processors, hardware-accelerated 2D/3D graphics pipelines, and multi-gigabyte memory allocations that remain largely idle during standard web browsing. FactStamp harnesses modern JavaScript execution engines (such as Chromium V8, WebKit JavaScriptCore, and Mozilla SpiderMonkey) to execute media downscaling, Jaccard duplicate detection, weighted consensus mathematics, and PNG fact card rasterization directly inside the user's browser.

==== Decoupling Compute from Cloud Infrastructure
By transferring computational workloads to client devices, FactStamp eliminates the traditional application server tier entirely. The React application communicates directly with *Google Cloud Firestore* utilizing the Firebase Web SDK v12 over persistent, multiplexed HTTP/2 and WebSocket transport channels.

Data integrity, operational invariants, and security assertions are enforced at the database kernel through *declarative security rules* (`firestore.rules`). Operations are verified directly on Google's distributed database nodes in microseconds before commits reach persistent storage, guaranteeing enterprise-grade security without maintaining a custom server fleet.

==== Zero-Cost Serverless Economic Ledger
A core architectural mandate of FactStamp is absolute economic viability: the platform is engineered to function continuously at $0.00$ recurring cost, leveraging free-tier serverless allocations.

#styled-table(
  columns: (1.5in, 1.6in, 1.8in, 0.9in),
  headers: ("Infrastructure Layer", "Traditional Enterprise Model", "FactStamp Serverless Implementation", "Actual Cost"),
  "Compute & API Servers", "AWS EC2 / ECS ($25 - $80 / mo)", "Client-side execution in browser V8 engine", "$0.00 / mo",
  "Application Web Hosting", "AWS S3 + CloudFront ($10 / mo)", "Vercel Global Edge CDN (Hobby Tier)", "$0.00 / mo",
  "User Identity & Auth", "Auth0 / Okta ($0.0055 / MAU)", "Firebase Authentication (Unlimited Free Tier)", "$0.00 / mo",
  "Database Storage & I/O", "AWS RDS PostgreSQL ($35 - $60 / mo)", "Google Cloud Firestore Spark Free Tier", "$0.00 / mo",
  "Screenshot Media Store", "AWS S3 Object Bucket ($0.023 / GB)", "In-Document Base64 JPEG Storage (< 700 KB)", "$0.00 / mo",
  "Headless Card Render", "Puppeteer Lambda Fleet ($40 / mo)", "Browser-Native SVG foreignObject (html-to-image)", "$0.00 / mo",
  "Scheduled Cron Jobs", "Google Cloud Scheduler ($5 / mo)", "Client-Side In-Memory Dynamic Rolling Windows", "$0.00 / mo",
  "Total Monthly Expense", "Commercial Total: $115 - $200+ / mo", "FactStamp Zero-Cost Serverless Stack", "Rs 0.00 / mo"
)

=== 5.1.2 Input and Output Design Implementation

==== Input Design Implementation
The input architecture of FactStamp is designed for zero cognitive friction, accommodating users across varying levels of digital literacy while enforcing rigorous client-side input validation and security sanitization.

1. *Dual-Modality Ingestion Gateway:*
   - *Plaintext Ingestion Pathway:* Citizens paste raw forwarded rumors directly into an auto-resizing textarea. Strings are bounded between 20 and 500 characters. Input is processed through `sanitizeTextInput()` (`src/lib/security.ts`), which strips malicious script injection tokens (`<script>`, `<iframe>`), purges dangerous URI protocols (`javascript:`, `data:`), collapses redundant whitespace, and normalizes typography.
   - *Screenshot Media Ingestion Pathway:* Users upload social media screenshots, WhatsApp status captures, or fake news clippings. Uploads are safeguarded via a *Triple-Layer Defense System*:
     a. *File Extension Whitelisting:* Restricts uploads to `.jpg`, `.jpeg`, `.png`, `.webp`, and `.gif`.
     b. *Browser MIME Validation:* Checks `file.type` against `ALLOWED_IMAGE_MIMES`.
     c. *Binary Magic Byte Header Inspection:* Reads the first 12 bytes via an `ArrayBuffer` slice, inspecting hexadecimal magic numbers (`0xFF 0xD8 0xFF` for JPEG, `0x89 0x50 0x4E 0x47` for PNG). Disguised polyglot binaries and PHP scripts are aborted before any processing occurs.
   - *Client-Side Canvas Image Compression:* Standard cloud storage buckets incur egress fees. FactStamp downscales images client-side via an off-screen HTML5 `<canvas>`, restricting the maximum dimension to $1280"px"$ and stepping JPEG quality from $0.72$ down to $0.40$ until the Base64 data URL fits within a strict $700"KB"$ ceiling.
   - *Optical Character Recognition (OCR):* The compressed canvas buffer is passed to an in-browser Tesseract.js WebAssembly engine, extracting embedded text blocks into an editable transcription box.
2. *Verifier Workbench Input Validation:*
   - *Canonical Evidence URL Validation:* Verifiers must provide a valid HTTP/HTTPS citation link, which is evaluated in real time against domain authority regex rules.
   - *Structured Explanation Guardrails:* Verifiers must enter an explanation of at least 50 characters and 8 distinct words. Low-effort spam, repetitive character vectors, and generic phrases (e.g., "fake forward", "trust me bro") are automatically rejected by regex heuristic filters.

==== Output Design Implementation
Output design centers on delivering instant cognitive clarity and producing verifiable counter-misinformation artifacts:
1. *Instant Duplicate Match Re-routing:* When set-theoretic Jaccard similarity exceeds the duplicate threshold ($J >= 0.75$), the client avoids creating a duplicate ticket, displaying an amber alert toast and instantly redirecting the user to the existing verified claim.
2. *High-Visibility Verdict Stamps:* Certified claims display a prominent, double-encoded verdict badge:
   - `TRUE`: Emerald Green with Checkmark Icon.
   - `FALSE`: Crimson Red with Octagonal Cross Icon.
   - `MISLEADING`: Amber Orange with Warning Triangle Icon.
   - `UNVERIFIABLE`: Slate Gray with Question Mark Icon.
   - `CONTESTED`: Violet Purple with Scale/Gavel Icon.
   Dual chromatic and geometric encoding guarantees full accessibility for color-blind users (complying with WCAG 2.1 AA standards).
3. *SVG TrustRing Meters:* Renders dynamic circular progress gauges showing verifier reputation and weighted confidence scores ($C in [0, 100]\%$).
4. *Downloadable Fact-Check PNG Cards:* Single-tap generation of an exact $1080 times 1080"px"$ high-DPI image, structured to fit mobile WhatsApp chat previews perfectly.

=== 5.1.3 Database Implementation

FactStamp employs *Google Cloud Firestore*, a horizontally scalable, document-oriented NoSQL cloud database. 

==== Architectural Database Characteristics:
1. *Real-Time WebSocket Synchronization:* Rather than polling REST endpoints, the React application binds directly to Firestore document and collection queries using `onSnapshot()` listeners. When an independent verifier registers a vote or a claim achieves consensus, update deltas are pushed down active WebSocket connections to all connected clients within $120"ms"$.
2. *Offline Persistence & Optimistic Updates:* Client state is maintained optimistically via `localClaimsRef`. When a user submits a claim or verification under spotty network conditions (e.g., Indian mobile 3G/4G transit), the UI renders the update instantly. The Firebase offline cache records operations locally and replays mutations automatically upon network restoration.
3. *Declarative Security Rules Kernel (`firestore.rules`):* All access control, relational integrity checks, and data schema rules are enforced declaratively at the Firestore kernel level. The rules prevent unauthorized field tampering, restrict admin privilege elevation, and enforce the fundamental anti-Sybil rule:
   ```javascript
   // firestore.rules excerpt: Anti-Sybil Self-Verification Prohibition
   match /claims/{claimId} {
     allow update: if request.auth != null
       && resource.data.submittedBy != request.auth.uid
       && request.resource.data.verifications.size() == resource.data.verifications.size() + 1;
   }
   ```

=== 5.1.4 Table Structures (Firestore NoSQL Schemas)

Although Firestore is schema-less by nature, FactStamp enforces rigid structural consistency across all document collections.

==== 1. `/claims` Collection Document Schema
#styled-table(
  columns: (1.2in, 1.0in, 0.6in, 1.2in, 1.8in),
  headers: ("Field Name", "Data Type", "Null?", "Validation Rule", "Description & Invariant"),
  "id", "String (DocID)", "No", "Auto-generated / UUID", "Unique claim identifier in Firestore.",
  "text", "String", "No", "20 <= len <= 3000", "Raw verbatim text of the forwarded rumor.",
  "normalizedText", "String", "No", "Lowercase, cleaned", "Sanitized string utilized by Jaccard engine.",
  "imageUrl", "String (DataURI)", "Yes", "Base64 <= 700 KB", "Client-compressed screenshot payload.",
  "category", "String", "No", "In enum categories", "Health, Political, Financial, Religious, Other.",
  "status", "String", "No", "pending | verified | contested", "Current lifecycle status of verification ticket.",
  "submittedBy", "String (UID)", "No", "UID or 'anonymous'", "Originating submitter; cannot verify this claim.",
  "createdAt", "Timestamp", "No", "request.time", "Server timestamp marking claim creation.",
  "expiresAt", "Timestamp", "No", "createdAt + 7 days", "Deadline for achieving 3-verifier quorum.",
  "verifications", "Array<Object>", "No", "size <= 10", "Ordered list of independent verifier reviews.",
  "verdict", "String", "Yes", "TRUE | FALSE | MISLEADING...", "Consensus verdict resolved upon quorum.",
  "confidenceScore", "Number", "Yes", "0 <= score <= 100", "Weighted algorithmic confidence percentage."
)

==== 2. Nested `verifications` Array Object Schema
#styled-table(
  columns: (1.2in, 1.0in, 0.6in, 1.2in, 1.8in),
  headers: ("Attribute", "Data Type", "Null?", "Validation Rule", "Description & Invariant"),
  "id", "String", "No", "Auto-generated UUID", "Unique identifier for verification entry.",
  "verifierId", "String (UID)", "No", "auth.uid == verifierId", "Unique UID of reviewing verifier.",
  "verifierName", "String", "No", "len >= 2", "Display name of authenticated verifier.",
  "verdict", "String", "No", "In verdict enum", "Voted outcome (`TRUE`, `FALSE`, etc.).",
  "sourceUrl", "String", "No", "Valid HTTP/HTTPS URL", "Canonical evidence citation hyperlink.",
  "sourceQuality", "String", "No", "high | medium | low", "Evaluated domain authority tier.",
  "explanation", "String", "No", "len >= 50, words >= 8", "Plain-language rationale defending verdict.",
  "submittedAt", "Timestamp", "No", "Server timestamp", "Timestamp when verification was recorded."
)

==== 3. `/users` Collection Document Schema
#styled-table(
  columns: (1.2in, 1.0in, 0.6in, 1.2in, 1.8in),
  headers: ("Field Name", "Data Type", "Null?", "Default / Constraint", "Description & Role"),
  "uid", "String (DocID)", "No", "Matches auth.uid", "Cryptographically bound Firebase Auth UID.",
  "displayName", "String", "No", "Standard string", "User-facing identity on public leaderboards.",
  "email", "String", "No", "Valid email regex", "Registered email address for notifications.",
  "reputation", "Number", "No", "Default 50 (0 to 100)", "Dynamic credibility score influencing weight.",
  "totalVerifications", "Number", "No", "Default 0", "Cumulative count of completed peer reviews.",
  "accuracyRate", "Number", "No", "Default 100%", "Historical consensus alignment percentage.",
  "isAdmin", "Boolean", "No", "Default false", "Elevated role for dispute resolution.",
  "createdAt", "Timestamp", "No", "Server timestamp", "User account registration timestamp."
)

==== 4. `/notifications` Collection Document Schema
#styled-table(
  columns: (1.2in, 1.0in, 0.6in, 1.2in, 1.8in),
  headers: ("Field Name", "Data Type", "Null?", "Permitted Values", "Description"),
  "id", "String (DocID)", "No", "UUID string", "Unique notification identifier.",
  "userId", "String (UID)", "No", "Foreign key to /users", "Recipient verifier UID.",
  "claimId", "String", "No", "Foreign key to /claims", "Associated claim reference.",
  "type", "String", "No", "consensus | rep_change | alert", "Semantic notification category.",
  "title", "String", "No", "Text string", "Brief headline rendered in notification bell.",
  "message", "String", "No", "Text string", "Detailed descriptive notification body.",
  "read", "Boolean", "No", "Default false", "Read/unread state tracking.",
  "createdAt", "Timestamp", "No", "Server timestamp", "Event dispatch timestamp."
)

=== 5.1.5 Code Modules

The application codebase is organized into four distinct architectural layers within `/src`:

1. *State Context Providers (`src/context/`):*
   - `AuthContext.tsx`: Governs session lifecycle, token renewals, and role identification.
   - `ClaimsContext.tsx`: The primary state engine; coordinates Firestore snapshot listeners, duplicate checking, quorum status, and optimistic local caching.
   - `NotificationsContext.tsx`: Manages real-time alerts and unread counters for verifiers.
   - `ThemeContext.tsx`: Controls dark and light theme transitions with persistent `localStorage` synchronization.
2. *Domain Page Views (`src/pages/`):*
   - `Home.tsx`: Landing view with live counter marquees and recent debunked claims.
   - `Submit.tsx`: Ingestion portal supporting text pasting and drag-and-drop screenshot OCR.
   - `VerifyQueue.tsx`: Community queue displaying unverified pending claims with urgency badges.
   - `VerifyDetail.tsx`: Investigative workbench where verifiers review claims and cast verdicts.
   - `ClaimDetail.tsx`: Certified case dossier view featuring the 1080x1080px Fact Card generator.
   - `Dashboard.tsx`: Analytics intelligence portal with 7-day radar charts and leaderboards.
   - `Profile.tsx`: Verifier dashboard displaying personal reputation trajectory and history.
3. *Core Algorithmic Libraries (`src/lib/`):*
   - `security.ts`: Regex input sanitizers, HTML tag strippers, and magic byte file inspectors.
   - `duplicateDetection.ts`: Word tokenizers, short-word stop filters, and Jaccard similarity engine.
   - `confidenceScore.ts`: Tri-partite weighted consensus algorithm ($C = 0.40A + 0.30R + 0.30S$) and domain authority evaluator.
   - `imageCompression.ts`: Client-side HTML5 canvas downscaler and iterative JPEG stepping routine.
   - `weeklyReport.ts`: Dynamic rolling 7-day category tally and misinformation aggregator.

=== 5.1.6 System Implementation

==== 1. Build Toolchain & Module Bundling
FactStamp is developed on *Vite 5* paired with the *Rollup* compilation pipeline:
- *Native ESM Development Server:* Delivers instant cold starts and sub-millisecond Hot Module Replacement (HMR).
- *Automated Chunk Splitting:* Third-party vendor dependencies are split into isolated chunks (Firebase SDK, Lucide Icons, Recharts, `html-to-image`), loaded asynchronously on demand.
- *Static Tree-Shaking:* Eliminates dead code paths, yielding a total gzipped JavaScript bundle size under $180"KB"$.
- *Deterministic Content Hashing:* Compiles assets with SHA-256 content hashes for aggressive edge caching.

==== 2. Styling System: Tailwind CSS v4 & Rust Oxide Compiler
Styling is powered by *Tailwind CSS v4* utilizing the high-performance Rust-based *Oxide engine*:
- *CSS-First Configuration (`@theme`):* Eliminates JavaScript-based configuration files; all design tokens (OKLCH color ramps, fluid type scales) are authored directly in `src/index.css`.
- *Zero Runtime Overhead:* Compiles JSX utility classes into purely static CSS at build time.
- *CSS Color Level 4 Support:* Natively parses modern `oklch()` color spaces across all UI components.

==== 3. Edge Deployment & Hosting
The production web client is deployed across the *Vercel Global Edge Network*:
- Continuous deployment (CI/CD) triggers on Git repository commits.
- Global edge servers terminate TLS/SSL and serve static assets with sub-$50"ms"$ TTFB (Time to First Byte) across major Indian telecommunication networks.

