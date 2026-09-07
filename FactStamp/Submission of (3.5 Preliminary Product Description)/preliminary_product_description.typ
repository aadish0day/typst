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
#show table.cell: set text(size: 9pt)
#show table.cell.where(y: 0): set text(size: 9pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

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

#set document(title: "FactStamp - Preliminary Product Description", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[3.5 PRELIMINARY PRODUCT DESCRIPTION]
    #v(2pt)
    #text(size: 10.5pt)[*System Perspective, User Personas, Operational Environment & Constraints*]
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
// 3.5 PRELIMINARY PRODUCT DESCRIPTION
// =============================================================================
= Preliminary Product Description

== System Product Perspective

=== The WhatsApp Misinformation Crisis in India
Over 535 million active users in India utilize WhatsApp as their primary digital communications medium. WhatsApp's end-to-end encrypted architecture—while vital for civil liberties and personal privacy—creates severe information asymmetry:
1. *Opaque Propagation:* Rumors, unscientific medical panaceas, financial phishing scams, and doctored administrative orders circulate through closed group chats without public visibility.
2. *Asymmetric Viral Velocity:* A sensationalized fake claim can propagate to millions of devices across multiple states within hours, whereas traditional institutional fact-checking articles take days to publish and rarely reach the private chat groups where the rumor was seeded.
3. *Cognitive Friction:* Conventional fact-checking platforms require users to navigate dense, text-heavy editorial websites cluttered with advertisements, creating prohibitive friction for non-technical or elderly citizens.

=== Architectural Stance: External, Non-Invasive Civic Companion
*FactStamp* is conceived as an autonomous, serverless, web-based verification platform that bridges the gap between private encrypted messaging networks and crowdsourced civic accountability.

Importantly, FactStamp does *not* attempt to intercept, inspect, or modify WhatsApp's proprietary encrypted client application or network protocols. Doing so would violate end-to-end cryptographic guarantees, compromise user device security, and breach terms of service. Instead, FactStamp operates strictly via *user-initiated public-interest interactions*:
1. A citizen receives a suspicious forwarded message or screenshot in WhatsApp.
2. The citizen shares the forward with FactStamp via standard mobile web browser ingestion (`/submit`).
3. Community verifiers collaboratively research and certify the claim through a multi-factor quorum consensus engine.
4. The system compiles the certified verdict into a shareable square PNG Fact Card.
5. The citizen downloads the Fact Card and forwards it directly back into the WhatsApp group chat where the rumor originated.

#pagebreak()

=== End-to-End Architectural Workflow
The full operational lifecycle of a claim—from dark-social reception to community verification and viral counter-dissemination—is illustrated below:

#v(8pt)
#responsive-image("attachments/system_workflow.svg", width: 92%, max-height: 560pt)
#v(6pt)
#align(center)[*Figure 3.1: FactStamp End-to-End Architectural Workflow*]

#pagebreak()

== User Classes & Detailed Behavioral Personas
FactStamp is designed around three primary user classes, each characterized by distinct technological proficiencies, behavioral motivations, and functional requirements.

#styled-table(
  columns: (1.3in, 1.3in, 1.4in, 1fr),
  headers: ("Persona Name", "Role & Demographic Profile", "Primary Motivation", "Core Pain Point & Platform Requirement"),
  "Rajesh Sharma (52)", "Public Submitter\nResident Welfare Assoc. Admin\nMumbai, India", "Protect family and residential chat groups from financial and medical scams.", "Finds text-heavy news articles difficult to navigate on mobile; requires frictionless one-tap forward ingestion and visual export.",
  "Priya Patel (21)", "Community Verifier\nB.Sc. IT Student / Volunteer\nChurchgate, Mumbai", "Build verifiable fact-checking civic reputation and contribute to social truth.", "Frustrated by lack of transparent tools for community debunking; requires structured verification queue and evidentiary citation tools.",
  "Prof. Vikram Mehta (38)", "Platform Administrator\nFaculty Advisor / Moderator\nAcademic Institution", "Ensure platform governance, audit contested claims, and monitor telemetry.", "Needs automated audit trails to neutralize coordinated Sybil attacks and partisan brigading; requires macro-level radar analytics."
)

=== Persona 1: Rajesh Sharma (The WhatsApp Group Administrator)
- *Demographic Context:* 52 years old, small business owner, administrator of a 150-member residential neighborhood WhatsApp group in Dadar, Mumbai. Uses a mid-range Android phone (Samsung Galaxy M14).
- *Behavioral Archetype:* Receives dozens of forwards daily claiming miraculous Ayurvedic cures, urgent banking ATM shutdowns, or municipal water supply cuts. He is anxious about spreading falsehoods but lacks the research tools or technical literacy to independently verify complex claims.
- *Platform Needs:*
  - *Zero-Friction Ingestion:* Needs to paste forwarded text or upload a screenshot without creating accounts, remembering passwords, or filling complex forms.
  - *Unambiguous Visual Verdict:* Requires a color-coded answer (e.g., bold red rubber-stamp badge marking *"FALSE"*).
  - *One-Click WhatsApp Export:* Wants to download a clean visual card to post directly into his residential group to immediately halt rumor propagation.

=== Persona 2: Priya Patel (The Student Civic Verifier)
- *Demographic Context:* 21 years old, undergraduate Information Technology student at Jai Hind College. Digitally literate, active across social networks, passionate about digital civic hygiene.
- *Behavioral Archetype:* Regularly identifies obvious hoaxes in family groups. Possesses the research skills to navigate sovereign gazettes (`pib.gov.in`, `rbi.org.in`, `who.int`) and accredited fact-checking repositories.
- *Platform Needs:*
  - *Real-Time Verification Queue:* Needs an efficient dashboard filtering pending claims by category (`Health`, `Finance`, `Politics`).
  - *Evidentiary Submission Tools:* Structured input fields to attach authoritative citation URLs and concise rationale summaries ($>= 50$ characters).
  - *Reputation Gamification:* Transparent reputation tracking ($0-100$) and leaderboard recognition for consensus-aligned verdicts.

=== Persona 3: Prof. Vikram Mehta (The Platform Administrator)
- *Demographic Context:* 38 years old, Assistant Professor in Computer Science and research advisor for the FactStamp project.
- *Behavioral Archetype:* Oversees system integrity, audits voting patterns for signs of coordinated Sybil brigading, and reviews claims that fail to reach quorum consensus within 7 days.
- *Platform Needs:*
  - *Telemetry Dashboard:* Real-time visualization of weekly claim volume surges, category distributions, and consensus conversion rates.
  - *Moderation Interface:* Capability to inspect contested split-decision claims ($C < 70%$) and audit outlier verifiers exhibiting suspicious voting anomalies.

#pagebreak()

== Operational Environment and Technical Constraints

=== Zero-Budget Serverless Infrastructure
FactStamp is developed as an academic and public-good initiative operating without commercial venture capital or departmental cloud server budgets. Architectural choices strictly comply with perpetual free-tier allocations:
1. *Google Cloud Firestore:* Utilizes document-level NoSQL storage within the free allocation (50,000 document reads, 20,000 writes per day).
2. *Vercel Global Edge Network:* Hosts static Next.js assets and serverless API endpoints with zero maintenance overhead.
3. *Client-Side Offloading:* Heavy computational tasks—including image resizing, canvas rasterization, and preliminary text normalization—are offloaded to client browsers to avoid expensive server compute.

=== Browser Sandbox & Mobile Memory Budget
Budget mobile devices commonly encountered across the Indian subcontinent feature limited random-access memory (typically 2 GB to 4 GB RAM). When rendering large uncompressed bitmaps onto HTML5 canvases, browser processes risk abrupt termination by the OS low-memory killer. FactStamp enforces strict client-side controls:
- Canvas dimensions are clamped to a maximum bounding box of $1280 times 1280$ pixels.
- Dynamic JPEG quality stepping (starting at $0.72$, stepping down by $0.08$ to a floor of $0.40$) guarantees base64 payloads under $700$ KB.
- Object URLs are promptly revoked (`URL.revokeObjectURL`) to release browser heap memory immediately after image decoding.

=== WhatsApp Square 1:1 Aspect Ratio Mandate
WhatsApp's chat interface renders media previews using an algorithm that automatically crops non-square images into centered square tiles in chat threads:
- Standard 16:9 or 4:3 rectangular cards suffer from critical information loss: the top header (verdict badge) and bottom footer (authoritative source links) are truncated in the chat feed.
- Consequently, FactStamp mandates a strict *1:1 square aspect ratio* ($1080 times 1080$ pixels). This geometry guarantees that the rubber-stamp verdict, claim summary, confidence meter, and sovereign citation URLs remain 100% visible in the chat feed without requiring the recipient to tap and expand the image.

=== Ergonomic Mobile Touch Targets
Over 85% of submitters access FactStamp via mobile smartphones. To ensure accessibility for elderly users and citizens with motor impairments:
- All interactive elements (submission triggers, file upload dropzones, category selectors, vote buttons) enforce a minimum touch target dimension of *48 x 48 pixels*.
- Complies strictly with Android Material Design Accessibility and Accessible Perceptual Contrast Algorithm (APCA) standards.

#pagebreak()

== Assumptions and Dependencies

=== Network Connectivity & Low-Bandwidth Resilience
- *Network Conditions:* FactStamp assumes users operate on variable mobile networks (2G/3G/4G/5G) across urban and semi-urban Indian environments.
- *Resilience:* Web pages utilize progressive enhancement and optimistic UI updates, functioning smoothly over intermittent connectivity.

=== Modern Web Browser Standards Compliance
FactStamp relies on standard web capabilities natively supported across modern browsers:
- *ECMAScript 2022 Modules & WebAssembly:* For fast cryptographic operations and client-side processing.
- *HTML5 Canvas 2D Context & SVG `<foreignObject>`:* For dynamic Fact Card rendering and image resizing without external server dependencies.
- *CSS Custom Properties & Responsive Flexbox/Grid:* For adaptive layouts across mobile, tablet, and desktop viewports.
- Supported browsers: Chrome 100+, Firefox 105+, Safari 15.4+, and Edge.

=== Third-Party Cloud Services Availability
FactStamp relies on stable API availability from:
1. *Google Firebase Services:* Firebase Authentication (OIDC, Google Identity SSO) and Cloud Firestore NoSQL Database.
2. *Vercel Edge Platform:* Global Anycast CDN, HTTP/2 termination, and serverless routing.

#pagebreak()

== Functional Scope Matrix & Product Boundary

#styled-table(
  columns: (1.3in, 1.4in, 1fr),
  headers: ("Capability Area", "In-Scope Core Features", "Explicit Out-of-Scope Anti-Features"),
  "Claim Ingestion", "Anonymous plaintext forward submission; screenshot upload with client canvas downscale and automated OCR extraction.", "Automated crawling of private WhatsApp chats; interception of WhatsApp network traffic; phone number scraping.",
  "Duplicate Detection", "Lexical set-theoretic Jaccard similarity index ($J >= 0.75$) clustering variants under canonical claims.", "Deep semantic embedding transformers requiring GPU server clusters; arbitrary fuzzy regex matches.",
  "Quorum Verification", "Public queue; minimum quorum threshold $N >= 3$; authoritative citation mandate; verifier reputation scoring ($0-100$).", "Single-moderator unilateral censorship; unweighted democratic popular voting; anonymous verifier voting.",
  "Consensus Algorithm", "Tri-partite weighted scoring: $C = 0.40A + 0.30R + 0.30S$; automated 7-day contested timeout.", "Proprietary black-box AI truth arbiters; manual score tampering; unverified source domain scoring.",
  "Visual Dissemination", "Square 1:1 ($1080 times 1080$px) PNG Fact Card generation with rubber-stamp verdict badge; direct WhatsApp share link.", "Automated WhatsApp spam bot broadcasting; automatic injection into third-party chat groups without user action.",
  "System Governance", "Administrative audit dashboard; contested claim review; Sybil anomaly detection; rolling 7-day category radar.", "Automated state surveillance interfaces; identity de-anonymization of anonymous submitters."
)

== Conclusion & Product Feasibility
The Preliminary Product Description confirms FactStamp as a pragmatically scoped, technically feasible, and socially vital counter-disinformation system. By leveraging crowdsourced civic expertise, transparent mathematical consensus, and frictionless mobile ergonomics, FactStamp empowers citizens to actively neutralize viral falsehoods at their point of origin.
