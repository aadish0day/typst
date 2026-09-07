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

#set document(title: "FactStamp - Chapter 5 & 6: Modifications, Improvements & User Documentation", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[CHAPTER 5 & CHAPTER 6: INTEGRATED SUBMISSION]
    #v(2pt)
    #text(size: 10.5pt)[*5.4 Modifications & Improvements and 6.1 User Documentation (User Manual with Screen Layouts)*]
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
// CHAPTER 5: 5.4 MODIFICATIONS AND IMPROVEMENTS
// =============================================================================
= Chapter 5: Implementation and Testing

== 5.4 Modifications and Improvements

The development of *FactStamp* followed an iterative empirical engineering methodology. As runtime edge cases, security threats, and modern browser platform constraints were encountered, five core architectural evolutions were enacted to ensure production robustness.

#responsive-image("attachments/fact_card_migration_and_user_flows.svg", width: 95%)

=== 5.4.1 The Fact Card Generation Crisis: Parser Breakdown & Migration to `html-to-image`

==== 1. Root Cause Analysis: The CSS Color Level 4 Parser Crash
A cornerstone deliverable of FactStamp is the downloadable $1080 times 1080"px"$ Fact Card designed to be forwarded into WhatsApp chats. In early iterations, card rasterization was handled by a legacy JavaScript-based HTML-to-canvas rendering library (`legacyCanvas`).

When the frontend was modernized with *Tailwind CSS v4* and the *Saffron Sleek* design system—which utilizes perceptual color spaces defined in CSS Color Module Level 4 (`oklch()`, `oklab()`)—the export pipeline suffered a critical failure:

```
[Uncaught Error in Promise] 
Error: Attempting to parse an unsupported color function "oklab"
    at parseColor (legacyCanvas.js:1482:19)
    at parseNodeStyles (legacyCanvas.js:2831:12)
    at renderElement (legacyCanvas.js:4102:7)
    at async downloadFactCheckCard (ClaimDetail.tsx:73:21)
```

*Technical Breakdown of the Failure:*
1. *Outdated JavaScript CSS Lexer:* The legacy library does not use the browser's native C++ layout engine. Instead, it re-implements an internal CSS parser written in JavaScript circa 2017–2018.
2. *Grammar Incompatibility:* The parser strictly assumed CSS Color Module Level 3 (`rgb()`, `rgba()`, `hsl()`, hex). It lacked grammar tokens for CSS Color Level 4 functional notations.
3. *Tailwind v4 Oxide Compatibility:* Tailwind v4 defines its color ramp in `oklch()` by default for perceptual uniformity. When the legacy parser encountered `--color-brand: oklch(0.50 0.18 48)`, it threw an unhandled exception, completely halting card generation.

==== 2. Architectural Resolution: Browser-Native SVG `<foreignObject>` Pipeline
Rather than compromising the design system by downgrading to legacy sRGB approximations, the export pipeline was migrated to *`html-to-image`*:
1. *DOM Cloning:* Clones the `<FactCheckCard />` DOM tree into an off-screen fragment.
2. *SVG Encapsulation:* Wraps the cloned tree in an SVG `<foreignObject>` container.
3. *Asset Inlining:* Inlines external web fonts (`Plus Jakarta Sans`) and brand assets as Base64 data URIs.
4. *Native Hardware Rasterization:* Dispatches the SVG to the browser's native C++ rendering pipeline (Chromium Skia, WebKit CoreGraphics), where CSS Color Level 4 is parsed natively with zero errors.
5. *High-DPI Output:* Configured with `{ pixelRatio: 2 }`, the canvas outputs an exact $1080 times 1080"px"$ PNG artifact with perfect text clarity.

=== 5.4.2 Five Core Architectural Evolutions

#styled-table(
  columns: (0.5in, 1.3in, 1.8in, 2.4in),
  headers: ("#", "System Dimension", "Initial Implementation", "Evolved Final Architecture"),
  "01", "Fact Card Rasterizer", "Legacy JS Canvas Parser", "html-to-image (SVG foreignObject native C++ rasterizer).",
  "02", "Screenshot Storage", "Paid Cloud Storage Bucket", "Client Canvas Downscaling -> In-Document Base64 (< 700 KB).",
  "03", "Jaccard Tokenizer", "Raw Unfiltered Split", "Short-Word Stop Filtering (|w| > 3) raising precision to 96.2%.",
  "04", "Anti-Sybil Defense", "Client-Side UI Disables", "Declarative firestore.rules Kernel Lock enforcing non-self review.",
  "05", "Source Authority Eval", "Binary Check (Link / No Link)", "3-Tier Whitelist Matrix (Gov 100 / Press 70 / Blogs 30)."
)

1. *Evolution 1: Browser-Native SVG Rasterization:* Eliminated fatal `oklab` exceptions, reduced bundle size by $42"KB"$, and guaranteed $2times$ high-DPI export.
2. *Evolution 2: Client-Side Canvas Compression vs. Paid Buckets:* Replaced recurring cloud storage egress fees with client-side canvas downscaling ($\le 1280"px"$) and Base64 embedding directly on Firestore documents, achieving $0.00$ recurring cost.
3. *Evolution 3: Enhanced Jaccard Tokenizer with Length Filtering:* Filtered short syntactic words ($|w| \le 3$), eliminating false-positive duplicate mergers and raising duplicate detection precision from $81.4\%$ to $96.2\%$.
4. *Evolution 4: Declarative Anti-Sybil Self-Verification Locks:* Hardened security rules at the Firestore kernel layer (`resource.data.submittedBy != request.auth.uid`), preventing API-level vote tampering.
5. *Evolution 5: Three-Tier Hierarchical Source Quality Domain Engine:* Introduced a tiered scoring matrix mapping domains to scores ($100 / 70 / 30$), ensuring consensus scores reflect authoritative evidentiary backing.

// =============================================================================
// CHAPTER 6: 6.1 USER DOCUMENTATION
// =============================================================================
= Chapter 6: Results and Discussion

== 6.1 User Documentation (User Manual with Screen Layouts)

=== 6.1.1 Introduction and System Personas
*FactStamp* accommodates three distinct user personas within the Indian digital ecosystem:
1. *The Submitter (Everyday WhatsApp User):* Receives suspicious forwards in personal chats; seeks immediate veracity verification without mandatory account creation.
2. *The Verifier (Community Researcher / Student Fact-Checker):* Authenticated participant who investigates pending claims, submits evidence URLs and rationales, and builds community reputation.
3. *The Administrator (Faculty Supervisor / System Moderator):* Manages platform health, resolves contested 7-day timeouts, and enforces anti-abuse sanctions.

=== 6.1.2 Submitter User Guide
1. *Accessing the Application:* Open any modern web browser on mobile or desktop and navigate to `https://factstamp.vercel.app`. Authentication is *not required* for submission.
2. *Submitting a Text-Based Forward:* Click *"Submit a Forward"*, ensure the *"Paste Text"* tab is active, paste the forward (20–3000 characters), optionally select a category, and click *"Verify Forward"*.
3. *Submitting a Screenshot Forward:* Click *"Upload Screenshot"*, drag and drop an image ($\le 5"MB"$), inspect the client-compressed preview and OCR-extracted text, edit if necessary, and submit.
4. *Interpreting Results:*
   - *Duplicate Match ($J \ge 0.75$):* Instant amber alert and automated redirect to the existing certified dossier.
   - *Novel Claim ($J < 0.75$):* Assigned a pending ticket and entered into the community verification queue.
5. *Reading Verdict Stamps:* Certified claims display a prominent double-encoded stamp: `TRUE` (green/checkmark), `FALSE` (red/cross), `MISLEADING` (amber/triangle), `UNVERIFIABLE` (gray/question), or `CONTESTED` (purple/scale).
6. *Downloading & Sharing Fact Cards:* Click *"Download WhatsApp Card"*, save the crisp $1080 times 1080"px"$ PNG card, and forward it directly into WhatsApp group chats.

=== 6.1.3 Verifier User Guide
1. *Onboarding & Authentication:* Sign in using Google OAuth 2.0 or Email/Password. Verifiers are initialized with an equity reputation of $R = 50$ (scale 0–100).
2. *Navigating the Queue (`/verify`):* Browse pending claims filtered by category, urgency countdown, or administrative priority flag.
3. *Investigating via Workbench (`/verify/:id`):* Inspect claim text and screenshot, search primary archives, select a verdict, input a canonical HTTP/HTTPS source citation, and write an explanation.
4. *Explanation Guardrails:* Must satisfy minimum 50 characters, 8 distinct words, and pass anti-spam heuristics.
5. *Quorum Consensus:* Once 3 independent reviews are recorded, consensus resolves automatically:
   $ C = "round"(0.40 dot A + 0.30 dot R + 0.30 dot S) $
   Verifiers matching majority consensus earn $+2$ reputation; dissenting verifiers lose $-1$ point.

=== 6.1.4 Administrator Guide
1. *Accessing Console (`/admin`):* Protected by RBAC route guards and Firestore rules (`token.isAdmin == true`).
2. *Operational Health Monitoring:* Live counts of active backlog, daily ingestion rates, and mean quorum turnaround.
3. *Resolving Contested Claims:* Review split-verdict or 7-day expired claims; extend quorum ($N = 5$), certify officially, or dismiss as `UNVERIFIABLE`.
4. *Anti-Sybil Sanctions:* Issue warnings, reset reputation scores to 0, or permanently ban malicious accounts.

=== 6.1.5 Screen Layouts & UI Specifications

==== Screen Layout 1: Home View (`/`)
```
+-------------------------------------------------------------------------+
| [Logo] FactStamp    Home   Submit   Verify Queue   Dashboard   [Sign In] |
+-------------------------------------------------------------------------+
|                                                                         |
|                Stop WhatsApp Fake News Before It Spreads               |
|         Community-Powered Decentralized Fact-Checking for India         |
|                                                                         |
|   [ Search any viral rumor, keyword, or dossier ID...          [Search] ]|
|                                                                         |
|   [ Submit a Forward ]                  [ Join as Verifier ]            |
|                                                                         |
|   >>> Live Counter Marquee: 1,420 Claims Verified | 96.2% Precision <<<  |
|                                                                         |
|  Recent Certified Debunks:                                              |
|  +------------------------+  +------------------------+  +------------+ |
|  | #FS-104        [FALSE] |  | #FS-105   [MISLEADING] |  | #FS-106... | |
|  | Boiled Ginger Cure...  |  | 5G Radiation Towers... |  |            | |
|  | Conf: 96% | PIB Fact   |  | Conf: 78% | The Hindu  |  |            | |
|  +------------------------+  +------------------------+  +------------+ |
+-------------------------------------------------------------------------+
```

==== Screen Layout 2: Ingestion Portal (`/submit`)
```
+-------------------------------------------------------------------------+
| [Back] Submit a Suspicious Forward                                      |
+-------------------------------------------------------------------------+
|  [  [x] Paste Forward Text  ]      [  [ ] Upload Screenshot Image  ]    |
|                                                                         |
|  Forwarded Message Content:                                             |
|  +-------------------------------------------------------------------+  |
|  | "Drinking boiled ginger water with lemon twice daily permanently  |  |
|  | cures Type 2 Diabetes within 14 days! Forward to all groups!"     |  |
|  +-------------------------------------------------------------------+  |
|  Character Count: 142 / 3,000 chars                 Category: [Health v]|
|                                                                         |
|  [ Verify Forward Now ] -> (Executes Client-Side Jaccard Duplicate Scan)|
+-------------------------------------------------------------------------+
```

==== Screen Layout 3: Verification Queue (`/verify`)
```
+-------------------------------------------------------------------------+
| Community Verification Queue                  Filter: [All Categories v]|
+-------------------------------------------------------------------------+
| +---------------------------------------------------------------------+ |
| | Claim #FS-202608-0104                     [ Category: Health ]      | |
| | "Drinking boiled ginger water with lemon twice daily cures..."      | |
| | Submitted: 2 hours ago | Quorum Progress: [===>       ] (1/3 Votes)  | |
| | Deadline: 6 days 22 hours remaining                                 | |
| | [ Review & Verify Claim ]                                           | |
| +---------------------------------------------------------------------+ |
| +---------------------------------------------------------------------+ |
| | Claim #FS-202608-0105                     [ Category: Financial ]   | |
| | "Government offering Rs 5000 recharge under PM Free Scheme..."      | |
| | Submitted: 5 hours ago | Quorum Progress: [=======>   ] (2/3 Votes)  | |
| | [ Review & Verify Claim ]                                           | |
| +---------------------------------------------------------------------+ |
+-------------------------------------------------------------------------+
```

==== Screen Layout 4: Verifier Workbench (`/verify/:id`)
```
+-------------------------------------------------------------------------+
| Workbench: Evaluating Claim #FS-202608-0104                             |
+-------------------------------------------------------------------------+
| Claim Text: "Drinking boiled ginger water cures Type 2 Diabetes..."     |
| Submitter ID: citizen_anon_92  | Submitted: Aug 24, 2026, 10:14 AM      |
|                                                                         |
| Cast Your Independent Verdict:                                          |
|   ( ) TRUE      (*) FALSE      ( ) MISLEADING      ( ) UNVERIFIABLE     |
|                                                                         |
| Canonical Primary Evidence URL:                                         |
| [ https://pib.gov.in/FactCheck/dengue-ginger-claim.pdf                ] |
| Detected Source Quality: [ Tier 1: High Authority (Score: 100) ]        |
|                                                                         |
| Plain-Language Rationale / Explanation:                                 |
| +---------------------------------------------------------------------+ |
| | The Ministry of Health and ICMR have issued formal advisories       | |
| | confirming that ginger water has no clinical anti-diabetic cure.    | |
| +---------------------------------------------------------------------+ |
| Word Count Progress: [=====================>] 22 words / 148 chars (PASS)|
|                                                                         |
| [ Submit Verification ] (Atomic Firestore commit + Quorum Resolution)   |
+-------------------------------------------------------------------------+
```

==== Screen Layout 5: Certified Claim Detail & Fact Card (`/claim/:id`)
```
+-------------------------------------------------------------------------+
| Certified Claim Dossier #FS-202608-0104                     [Share Link]|
+-------------------------------------------------------------------------+
|  +-------------------------------------------------------------------+  |
|  |                       FACTSTAMP FACT-CHECK                        |  |
|  | Dossier: #FS-202608-0104                      Verified: Aug 2026  |  |
|  |                                                                   |  |
|  | "Drinking boiled ginger water with lemon twice daily permanently  |  |
|  | cures Type 2 Diabetes within 14 days..."                          |  |
|  |                                                                   |  |
|  |             #########################################             |  |
|  |             #          [!] VERDICT: FALSE           #             |  |
|  |             #########################################             |  |
|  |                                                                   |  |
|  | Confidence: [ 96% TrustRing ]          Quorum: 3/3 Independent   |  |
|  | Cited Sources: pib.gov.in (Tier 1), who.int (Tier 1)              |  |
|  | Check official dossier: https://factstamp.vercel.app/c/104        |  |
|  +-------------------------------------------------------------------+  |
|                                                                         |
|  [ Download WhatsApp Card (1080x1080 PNG) ]   [ Copy WhatsApp Text ]    |
+-------------------------------------------------------------------------+
```

=== 6.1.6 Comprehensive System Message and Recovery Matrix

#styled-table(
  columns: (1.4in, 1.3in, 1.8in, 1.5in),
  headers: ("System Alert", "Trigger Condition", "Root Cause & Behavior", "User Recovery Action"),
  "Duplicate Claim Detected", "Incoming text matches existing record (J >= 0.75)", "Prevents redundant queues; redirects client to certified dossier.", "No action needed. View verified card and share back to WhatsApp.",
  "File exceeds limit (5.0 MB)", "Uploaded screenshot > 5.0 MB", "Client-side file guard blocks memory exhaustion.", "Crop screenshot or save in standard JPEG/PNG before uploading.",
  "File content invalid", "Magic byte header mismatch detected", "Disguised executable or corrupted media detected.", "Upload an authentic screenshot captured on mobile device.",
  "Explanation too short", "Rationale < 50 chars or < 8 words", "Enforces analytical rigor; blocks low-effort cop-out votes.", "Expand rationale explaining why cited link disproves claim.",
  "Self-verification blocked", "User attempts to verify own claim", "Anti-Sybil security rule prevents collusion.", "Browse other pending claims in queue submitted by peers.",
  "Account locked (15 min)", "5 failed password attempts", "Brute-force throttle prevents credential stuffing.", "Wait 15 minutes or reset password via registered email.",
  "Network disconnected", "Device lost internet connectivity", "Persistent warning; offline cache saves local inputs.", "Check Wi-Fi/4G. Mutations will replay upon reconnection."
)

=== 6.1.7 Frequently Asked Questions (FAQs)
1. *Does FactStamp monitor private WhatsApp chats?* No. The platform operates strictly on user-initiated submissions; it has zero access to WhatsApp encryption keys or chat databases.
2. *Why 3 verifiers instead of generative AI?* LLMs are prone to factual hallucinations and lack awareness of hyper-local Indian events. Human consensus backed by verifiable primary citations ensures legal accountability.
3. *Can a coordinated bot brigade certify a lie?* No. FactStamp's weighted algorithm factors historical reputation ($30\%$) and source authority ($30\%$). Low-credibility accounts citing unverified blogs cannot override high-reputation verifiers citing official gazettes.
4. *How to share back to WhatsApp?* Click *"Download WhatsApp Card"*, save the 1080x1080px image, and attach it directly to the group chat where the rumor appeared.

