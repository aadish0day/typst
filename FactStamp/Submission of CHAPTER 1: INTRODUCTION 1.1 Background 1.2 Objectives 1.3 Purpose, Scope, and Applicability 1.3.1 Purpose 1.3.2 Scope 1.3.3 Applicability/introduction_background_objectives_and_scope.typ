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
#show table.cell: set text(size: 10pt)
#show table.cell.where(y: 0): set text(size: 10pt, weight: "bold")
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
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Chapter 1: Introduction", author: "Aadish")

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
    #text(size: 11pt, weight: "bold")[CHAPTER 1: INTRODUCTION]
    #v(2pt)
    #text(size: 10.5pt)[*1.1 Background | 1.2 Objectives | 1.3 Purpose, Scope, and Applicability*]\
    #text(size: 10pt)[(1.3.1 Purpose | 1.3.2 Scope | 1.3.3 Applicability)]
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
  depth: 3
)

#pagebreak()

// =============================================================================
// CHAPTER 1: INTRODUCTION
// =============================================================================
= Introduction

== Background
Over the past decade, India's telecommunications landscape underwent a historic structural transformation. The widespread rollout of fourth- and fifth-generation (4G/5G) mobile broadband networks, coupled with hyper-competitive cellular data tariffs and the proliferation of affordable smartphones, integrated hundreds of millions of first-time Internet users into the national digital ecosystem. Within this expansive environment, WhatsApp (Meta Platforms, Inc.) evolved far beyond a basic peer-to-peer messaging client. Today, with over 535 million active Indian users, it functions as the primary societal operating infrastructure for daily family interactions, community networking, business transactions, civic mobilization, and news consumption.

However, the specific technical architecture and social psychology underpinning instant messaging platforms have inadvertently created a fertile ground for the rapid, frictionless proliferation of digital misinformation. Instant messaging possesses distinct characteristics that differentiate it fundamentally from open web platforms:

1. *The Dark Social Blindspot:* Unlike public microblogging platforms (such as X/Twitter) or open social media networks (such as Facebook or Reddit), WhatsApp conversations occur within private, closed channels protected by default end-to-end encryption (E2EE) via the Signal protocol. Consequently, public search engine spiders, computational linguistics researchers, governmental regulatory bodies, and automated AI classifiers are structurally incapable of monitoring, indexing, or intercepting malicious forwards. Misinformation circulates in the shadows until real-world harm—such as vaccine hesitancy, communal discord, financial fraud, or mob violence—has already materialized.

2. *High-Trust Interpersonal Forwarding:* Information received on public feeds is routinely met with healthy skepticism. In contrast, WhatsApp forwards are received from trusted intermediaries: close relatives, lifelong neighborhood friends, respected school teachers, or community elders. This implicit interpersonal trust bypasses the recipient's critical cognitive filters. A false medical remedy forwarded by an uncle or a fabricated government pension scheme forwarded by a parent arrives pre-authenticated by emotional affection and respect.

3. *Asymmetric Viral Velocity:* Foundational empirical research into social network diffusion (Vosoughi, Roy, & Aral, _Science_, 2018) demonstrates that false news diffuses significantly farther, faster, deeper, and more broadly than the truth across all categories of information. Misinformation is intentionally engineered to evoke intense, visceral emotions—outrage, dread, religious pride, or miraculous medical hope. In private messaging groups, a sensational forward achieves thousands of impressions within hours, while authoritative rebuttals travel sluggishly.

#pagebreak()

4. *The Centralized Fact-Checking Latency Deficit:* Contemporary investigative fact-checking organizations (such as AltNews, BOOM Live, Vishwas News, and Snopes) perform invaluable forensic investigations. However, their centralized editorial workflow presents a crippling latency deficit:
   - Detecting an emerging rumor requires journalists to manually notice viral public mentions.
   - Performing primary-source verification, contacting institutional officials, and authoring investigative copy requires between 24 and 72 hours.
   - By the time an authoritative article is published, the rumor's viral window has long closed, and the damage has been finalized.

5. *The Social Friction of Counter-Narratives:* When an alert recipient identifies a forwarded message as fraudulent, posting a long, text-heavy fact-checking web link into a family or society chat group often triggers immediate interpersonal defensiveness. Senders feel publicly humiliated or accused of bad faith. Furthermore, empirical data shows that group participants rarely click external hyperlinks to read multi-paragraph journalistic dissections.

=== The FactStamp Solution
*FactStamp* is conceptualized and engineered to address this socio-technical dilemma through a decentralized, community-driven verification ecosystem. Rather than relying on a centralized editorial bottleneck, FactStamp harnesses crowdsourced civic verification guided by rigorous algorithmic consensus. Most critically, FactStamp changes the artifact medium of truth: instead of generating external text hyperlinks, FactStamp compiles verified verdicts into high-impact, square ($1080 times 1080$px), color-coded fact-check PNG cards. By providing an objective, authoritative visual stamp that can be downloaded in one tap and forwarded directly back into the originating WhatsApp group, FactStamp turns the platform's forwarding mechanics against misinformation itself.

== Objectives
The overarching aim of the *FactStamp* research and engineering project is to deliver a robust, zero-cost, privacy-preserving, and community-governed misinformation defense platform. The system is architected around eight measurable, technical objectives:

1. *Frictionless Multimodal Claim Ingestion:*
   - Implement responsive input pipelines allowing users to submit suspicious WhatsApp forwards either as raw plaintext (up to 2,000 characters) or as screenshot image uploads (JPEG/PNG, up to 5 MB).
   - Guarantee zero registration barriers for claim submitters, enabling instantaneous submission without requiring account creation.

2. *Automated In-Browser Optical Character Recognition (OCR):*
   - Integrate an in-browser WebAssembly OCR pipeline using Tesseract.js to extract text directly from forwarded screenshot images within client device memory.
   - Completely eliminate reliance on commercial cloud vision APIs (such as Google Cloud Vision or AWS Textract), ensuring 100% user privacy and preserving a zero-dollar infrastructure operational model.

3. *Real-Time Token-Level Duplicate Suppression (Jaccard Similarity Engine):*
   - Design and execute a high-performance string normalization, punctuation-stripping, and tokenization pipeline.
   - Implement the Jaccard similarity coefficient:
     $ J(A, B) = frac(|S_A inter S_B|, |S_A union S_B|) $
   - Benchmark and enforce an empirical threshold of $J(A, B) >= 0.75$ to detect duplicate forwards across Firestore collections in under $100 "ms"$, instantly routing users to existing certified verdicts and preventing queue bloat.

#pagebreak()

4. *Democratic Community Quorum Verification Queue:*
   - Establish an open, transparent public review registry where authenticated community verifiers can inspect pending, unverified claims.
   - Enforce a strict minimum quorum requirement of three ($N >= 3$) independent verifications before a claim transitions into the consensus calculation state.
   - Mandate that every verification vote include an explicit verdict (*TRUE*, *FALSE*, *MISLEADING*, or *UNVERIFIABLE*), an authoritative primary source URL, and a concise factual justification.

5. *Multi-Factor Weighted Quorum Consensus Engine:*
   - Formulate and deploy an algorithmic scoring engine that replaces primitive, easily manipulated binary voting with a multi-factor confidence equation:
     $ C = 0.40 A + 0.30 R + 0.30 S $
     Where:
     - $A$: Raw agreement ratio among quorum verifiers ($0$ to $100\%$).
     - $R$: Average historical track-record and reputation score of voting verifiers ($0$ to $100$).
     - $S$: Domain credibility score of submitted primary citation URLs ($0$ to $100$).
   - Programmatically assign final claim classifications based on computed consensus margins.

6. *Tamper-Resistant Verifier Reputation & Sybil Defense:*
   - Engineer a dynamic verifier reputation tracking subsystem initialized at a baseline of $50$ points ($R_0 = 50$) and bounded within $[0, 100]$.
   - Reward verifiers whose assessments align with certified consensus ($+2$ points) and penalize bad-faith or negligent outlier votes ($-3$ points).
   - Enforce declarative Firestore security rules that programmatically lock claim submitters from verifying their own claims, neutralizing Sybil voting rings.

7. *WhatsApp-Native Visual Artifact Generation (1080×1080px Fact Card):*
   - Author a client-side graphical compiler utilizing `html-to-image` via browser-native SVG `<foreignObject>` rasterization that transforms rendered React DOM components into pixel-perfect, square 1:1 PNG images.
   - Eliminate legacy JavaScript CSS parsing breakdowns, ensuring 100% native support for Tailwind CSS v4 OKLCH color spaces and dynamic CSS variables without brittle stylesheet patching.
   - Design visual stamps incorporating clear verdict color banners (Green for True, Crimson for False, Amber for Misleading, Slate for Unverifiable), claim summaries, dynamic SVG Trust Rings, source domain pills, and verification timestamps.

8. *Public Analytical Transparency & Misinformation Surveillance:*
   - Construct a real-time analytics dashboard aggregating 7-day rolling windows of claim submissions.
   - Deliver interactive Recharts visualizations illustrating category volume distributions (Health, Political, Financial, Religious), weekly rumor surges, and verifier accuracy leaderboards.

#pagebreak()

== Purpose, Scope, and Applicability

=== Purpose
The fundamental purpose of FactStamp is to *reverse the velocity vector of digital misinformation*. While conventional fact-checking efforts operate as external journalistic archives, FactStamp operates as an active, localized counter-measure embedded directly within the user's communication lifecycle:

- *Weaponizing the Forward Mechanism:* FactStamp leverages the exact behavioral mechanism responsible for spreading falsehoods—the WhatsApp 1-tap forward button. By packaging truth into authoritative, highly aesthetic square graphic stamps, recipients can forward counter-evidence back into private groups with zero social awkwardness.
- *Empowering Civic Verification:* It dismantles the bottleneck of centralized newsrooms by mobilizing university students, teachers, IT professionals, and civic volunteers into an authenticated, accountable verification corps.
- *Eliminating Cognitive Friction:* When an ordinary citizen doubts a forwarded claim, FactStamp provides sub-second duplicate lookups, delivering an instant, certified verdict without requiring the user to sift through search engine results.

#pagebreak()

=== Scope
The functional, technical, and operational boundaries of the FactStamp platform are strictly defined across four primary dimensions:

#styled-table(
  columns: (1.3in, 1.4in, 1fr),
  headers: ("Scope Dimension", "Technical Boundary", "Operational Implementation in FactStamp"),
  "Architecture & Tech Stack", "Modern Decoupled Single-Page Application (SPA)", "Engineered using React 18, Vite 5, TypeScript, Tailwind CSS v4 (Saffron Sleek design system), and Google Cloud Firestore.",
  "Computational Model", "Client-Side Edge Execution", "All image compression, Tesseract.js WebAssembly OCR extraction, and html-to-image graphic compilation run within client browser runtimes.",
  "Infrastructure & Hosting", "100% Serverless Free Tier", "Runs completely on Firebase Spark tier and Vercel Edge Hosting; zero monthly cloud server bills or database maintenance overhead.",
  "Platform Boundaries", "Non-Invasive Protocol Layer", "Strictly avoids reverse-engineering WhatsApp's proprietary encrypted client or incurring WhatsApp Business API costs; operates via standard web interfaces."
)

==== Operational Workflow & Architectural Scope
The end-to-end operational lifecycle and architectural workflow of the FactStamp verification platform is illustrated below:

#v(8pt)
#responsive-image("attachments/system_workflow.svg", width: 85%, max-height: 560pt)

#pagebreak()

==== Functional Scope Inclusions
- Direct submission of plaintext forwards up to 2,000 characters.
- Drag-and-drop or file-picker upload of JPEG/PNG screenshot images up to 5 MB.
- Client-side Canvas API image resizing and compression keeping base64 payloads under 500 KB.
- Tokenization, stop-word filtering, and Jaccard similarity matching ($J >= 0.75$).
- Public verification queue with real-time Firestore WebSocket subscriptions.
- Three-verifier quorum gating ($N >= 3$) and multi-factor consensus confidence calculation ($C = 0.40 A + 0.30 R + 0.30 S$).
- Client-side compilation and one-click download of 1080#text[×]1080px square PNG fact cards.
- Interactive analytics dashboard detailing weekly misinformation categories and top verifier leaderboards.

==== Explicit Exclusions & Delimitations
- *No Native App Dependency:* FactStamp does not require native Android or iOS app installation; it functions universally across any modern mobile or desktop web browser.
- *No Scraping of Private WhatsApp Chats:* FactStamp respects personal privacy and legal encryption standards; it never passively reads chat logs or accesses private contact lists. All verification requests are exclusively user-initiated.
- *No Unchecked Automated AI Hallucinations:* Unlike generative AI chat bots that frequently hallucinate factual evidence, FactStamp mandates verifiable human review coupled with primary institutional citations (e.g., government gazettes, WHO bulletins, judicial orders).

#pagebreak()

=== Applicability
FactStamp is designed for broad real-world applicability across distinct societal and institutional domains:

1. *General WhatsApp Recipients (Everyday Citizens):*
   - Individuals receiving suspicious forwards regarding miracle health cures, government welfare schemes, banking scams, or exam cancellations can verify claims in seconds before circulating them to friends and family.

2. *Student Fact-Checkers & Civic Volunteers:*
   - Undergraduate and postgraduate IT, journalism, and humanities students can apply digital literacy skills to research primary sources, submit certified verifications, and earn verifiable platform reputation scores.

3. *Family & Society WhatsApp Group Administrators:*
   - Group administrators often struggle to maintain harmony when inflammatory or false rumors circulate. FactStamp delivers indisputable, color-coded visual stamps that admins can post to authoritatively settle group disputes without appearing biased.

4. *Academic Researchers & Fact-Checking Organizations:*
   - Social scientists, media researchers, and professional fact-checking organizations can monitor FactStamp's aggregated public analytics to detect emerging rumor patterns, seasonal hoax categories, and misinformation propagation velocity across Indian dark social networks.

#pagebreak()

// =============================================================================
// REFERENCES
// =============================================================================
= References & Academic Bibliography

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
3. Garimella, K., & Eckles, D., *"Images and Misinformation in Political Groups: Evidence from WhatsApp in India,"* in _Proc. ACM Hum.-Comput. Interact._, vol. 4, no. CSCW2, Article 130, pp. 1-25, 2020.
4. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
5. Google Firebase Documentation, *"Cloud Firestore Security Rules & Realtime Snapshot Listeners,"* Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
6. Bubkoo, *"html-to-image: Generates images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.
7. Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
8. Pressman, R. S., & Maxim, B. R., *"Software Engineering: A Practitioner's Approach,"* 9th ed., McGraw-Hill Education, 2020.
