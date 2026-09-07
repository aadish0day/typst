// =============================================================================
// FACTSTAMP BLACK BOOK DISSERTATION
// CHAPTER 1: INTRODUCTION
// Course Code: JUSIT-DSCPR503 | Jai Hind College (Empowered Autonomous), Mumbai
// =============================================================================

= Introduction

== Background

=== WhatsApp adoption in the Indian telecommunications ecosystem
Following the deployment of 4G networks in late 2016 and subsequent 5G rollouts, mobile data tariffs in India decreased from approximately ₹270 (\$3.50) per gigabyte in 2014 to under ₹10 (\$0.12) by 2020. The concurrent availability of low-cost smartphones lowered access barriers for millions of first-time internet users across the country.

India has become WhatsApp's largest market, with over 535 million active users. The application is used widely for personal messaging, small-business commerce, local administration notices, and community communication. For many users, WhatsApp functions as their primary gateway to digital news and information.

=== Dark social communication and encryption architecture
On open social networks such as X, Facebook, and Reddit, content is publicly accessible. Automated crawlers and natural language processing pipelines can monitor circulating claims, researchers can evaluate propagation trends through public APIs, and platforms can attach contextual labels to disputed content.

WhatsApp, by contrast, operates as private or "dark social" communication. All chats, group discussions, voice notes, and media files are protected by default end-to-end encryption using the Signal Protocol. Message payloads are encrypted on the sender's device and decrypted only on the recipient's handset. Servers route packets without access to the decryption keys, meaning platform operators, network providers, and external monitoring tools cannot inspect message contents.

Because messages circulate within private encrypted groups, unverified claims, altered images, and fraudulent notices spread without indexing or automated public oversight. In many cases, rumors are identified only after real-world harms occur, including financial losses, public health confusion, or local unrest.

=== Social forwarding dynamics and viral velocity
Several behavioral and design factors contribute to the speed of message propagation in private chats:
1. Interpersonal trust: Unlike public feeds where posts come from unfamiliar accounts or recommendation systems, WhatsApp messages are received from known contacts, including family members, friends, and colleagues. Recipients often trust messages forwarded by personal acquaintances without independently checking primary sources.
2. Low forwarding friction: Forwarding a message requires a single tap. A user can broadcast a forward to multiple groups with up to 1,024 members in seconds.
3. Asymmetric propagation speed: In their study on online diffusion, Vosoughi, Roy, and Aral (2018) showed that unverified claims diffuse significantly faster and reach more people than verified corrections. Unverified claims were 70% more likely to be forwarded than factual reports, often because they evoke strong emotional reactions such as alarm or outrage during the first few hours of circulation.

=== Centralized fact-checking latency and format limitations
Professional fact-checking organizations (such as AltNews, BOOM Live, Vishwas News, Snopes, and PolitiFact) conduct detailed investigations. However, centralized fact-checking faces three structural constraints when addressing WhatsApp rumors:
- Verification latency: A formal investigation typically requires claim discovery (4-12 hours), editorial evaluation (12-36 hours), source verification (24-72 hours), and editorial review (48-96 hours). The total turnaround time is often 24 to 72 hours, whereas viral attention on messaging platforms peaks within 2 to 4 hours.
- Format mismatch: Most fact-checking articles are long web pages with detailed text and citations. When users share article URLs in chat groups, few recipients open external links to read complete reports. Plain text links rarely compete with visual image forwards.
- Interpersonal hesitation: Directly correcting family members or senior acquaintances in private groups can cause interpersonal tension, leading many users to leave inaccurate forwards uncorrected.

=== FactStamp approach
FactStamp addresses these challenges by decentralizing claim verification and altering how corrections are formatted and shared:
- Instead of relying on a single editorial desk, FactStamp distributes claim reviews to authenticated community contributors using an algorithmic quorum model requiring at least three independent verifiers.
- Instead of publishing external text articles, FactStamp generates square 1080×1080 px PNG fact-check cards.
- Each card includes a color-coded verdict stamp, a confidence rating, verified source domain indicators, and a concise summary. Users can download the card and forward it directly into the chat where the rumor appeared.

== Objectives

FactStamp is designed around ten core engineering objectives:

1. *Multimodal Ingestion* — Accepts both plaintext claims (10 to 2,000 characters) and screenshot images (up to 5 MB), with client-side Canvas downscaling for efficient Firestore storage.
2. *Client-Side WebAssembly OCR* — Runs Tesseract.js OCR entirely in the browser using WebAssembly, eliminating external API costs.
3. *Text Sanitization and Tagging* — Strips forwarding headers, timestamps, and symbols from extracted text and classifies claims across five topical domains.
4. *Token-Level Jaccard Matching* — Performs string normalization and token-based Jaccard similarity matching, achieving sub-100 ms lookup latency with over 94% recall.
5. *Three-Verifier Quorum Queue* — Requires at least three independent reviews via real-time Firestore listeners, with automated 7-day expiration for uncompleted claims.
6. *Weighted Consensus Calculation* — Computes a composite consensus score combining majority agreement, user reputation, and source credibility.
7. *Rate Limiting and Account Protection* — Implements dual-tier tracking for accounts and devices with 5-attempt limits and 15-minute progressive lockouts.
8. *Access Control and Database Rules* — Enforces role-based Firestore security rules across five collections, preventing self-verification and unauthorized writes.
9. *Square Fact Card Generator* — Renders 1080×1080 px PNG fact-check cards in the browser using SVG rasterization in under 350 ms.
10. *Typography and Theme System* — Uses Plus Jakarta Sans and Noto Sans Devanagari font stacks with a persistent dark/light theme toggle.

== Purpose, scope, and applicability

=== Purpose
The purpose of FactStamp is to reduce the spread of unverified claims in encrypted chat networks through four main mechanisms:
1. Visual counter-cards: Compiles verified results into 1080×1080 px PNG cards that users can share directly in chat threads without opening external web links.
2. Distributed verification: Distributes review tasks across authenticated community members governed by a three-person quorum and weighted scoring.
3. Impartial certification: Provides objective verification cards with primary citations, reducing interpersonal awkwardness when correcting forwarded messages.
4. Rapid duplicate detection: Uses token-based Jaccard similarity to identify previously checked claims in under 100 ms, returning existing verdicts without re-verification.

=== Scope

==== System boundaries
- *Architecture and Stack:* Built as a decoupled web single-page application with React 18, Vite 5, TypeScript 5.5, Tailwind CSS v4, and Google Cloud Firestore.
- *Computational Model:* Image resizing, Tesseract.js WebAssembly OCR, and card graphic compilation all execute on client hardware.
- *Hosting and Infrastructure:* Runs on the Firebase Spark plan and Vercel Edge CDN without dedicated virtual machine hosting costs.
- *Codebase Indexing:* AST-based knowledge graph mapping of 89 source files for structural analysis.

#v(6pt)
#figure(
  image("attachments/system_workflow.svg", width: 85%),
  caption: [FactStamp operational workflow and verification lifecycle]
)
#v(6pt)

==== Functional scope
The functional scope of FactStamp includes:
- Intake of text forwards (10 to 2,000 characters) and screenshot images (JPEG, PNG, WebP up to 5 MB).
- Client-side Canvas API image downscaling for efficient Firestore storage without dedicated storage bucket costs.
- In-browser Tesseract.js WebAssembly OCR with SIMD/LSTM runtimes and WhatsApp header cleaning.
- Jaccard similarity duplicate detection with token-based stop-word filtering.
- Real-time review queue using Firestore snapshot listeners with automated 7-day expiration.
- Multi-factor quorum consensus engine requiring at least three verifiers, supporting five verdict states: TRUE, FALSE, MISLEADING, UNVERIFIABLE, and CONTESTED.
- Two-tier rate limiting with 5-attempt thresholds, 15-minute lockouts, and a countdown timer.
- Client-side SVG rasterization of 1080×1080 px PNG fact cards.
- Interactive analytics dashboard showing claim counts, verdict distributions, and verifier leaderboards.

==== Project delimitations
FactStamp intentionally defines the following boundaries:
- Operates as a responsive web application across mobile and desktop browsers without requiring native app installation.
- Does not inspect private chat messages or device contacts. Submissions are initiated explicitly by users.
- Relies on structured community review and primary citations rather than unverified generative model outputs.

=== Applicability
FactStamp is designed for four primary user groups:
1. Messaging app users: Individuals who receive unverified forwards and wish to check claims or obtain shareable verification cards.
2. Student and community fact-checkers: Contributors who evaluate submitted claims, cite authoritative sources, and earn reputation points.
3. Group administrators: Community and family group moderators who need neutral, visual references to address disputed claims.
4. Academic researchers: Researchers studying rumor propagation patterns and verification metrics through aggregated platform analytics.

== Achievements

=== Summary of engineering milestones
By running image processing and OCR directly in the browser, FactStamp operates on free-tier serverless infrastructure without recurring cloud computing expenses. Key improvements over standard approaches include:

- *Duplicate Detection Latency:* 78.4 ms average (versus 1.2 to 3.5 seconds with cloud NLP services).
- *Operational Cloud Expenses:* \$0.00 per month on serverless free tiers (versus \$150 to \$450 per month).
- *Storage Infrastructure Costs:* \$0.00 per month using in-document media storage (versus \$25 to \$80 per month).
- *OCR Processing Costs:* \$0.00 using in-browser WebAssembly execution (versus \$1.50 per 1,000 images).
- *Card Graphic Rasterization:* 340 ms average using native SVG rasterization (versus DOM parser failures on modern CSS).
- *Color Space Support:* Native Tailwind CSS v4 OKLCH color token integration.
- *Authentication Rate Limiting:* 5 attempts with a 15-minute lockout and live countdown timer.
- *Access Control:* Declarative Firestore security rules and self-verification locks.
- *Typography Overhead:* Zero extra overhead using native OpenType features.
- *Codebase Indexing:* 89 files mapped via AST analysis for structural insight.

=== Technical results
The core technical outcomes include:
- Sub-100 ms duplicate detection: On test datasets exceeding 500 claims, the Jaccard similarity engine achieved a mean latency of 78.4 ms and a 94.2% recall rate on modified forwards.
- Zero-cost architecture: Client-side image compression and WebAssembly OCR eliminate vision API costs and storage bucket fees, running within the standard free tiers of Google Cloud Firestore and Vercel.
- Direct card rendering: Generates 1080×1080 px cards with OKLCH colors and 2x retina clarity in an average of 340 ms using SVG rasterization.
- Security and rate limiting: Combines device and account rate limiting (5 attempts, 15-minute lockout with timer), image validation, and Firestore security rules to prevent self-verification and unauthorized writes.
- Typography and theme support: Integrates Plus Jakarta Sans and Noto Sans Devanagari with OKLCH color palettes and a persistent theme switcher.

== Organisation of report

=== Report structure
This dissertation is divided into seven chapters in accordance with the curriculum for Course JUSIT-DSCPR503 (Project Dissertation and Implementation):

#v(6pt)
#figure(
  image("attachments/dissertation_roadmap.svg", width: 85%),
  caption: [Dissertation structural progression and chapter organization]
)
#v(6pt)

=== Chapter summaries
- *Chapter 1: Introduction* outlines the problem of misinformation in encrypted messaging networks, specifies the ten engineering objectives, defines project scope and limits, presents initial benchmarks, and summarizes the report structure.
- *Chapter 2: Survey of Technologies* provides a comparative analysis of fact-checking approaches, frontend frameworks (React, Vue, Svelte), build tools (Vite, Webpack), databases (Firestore, Supabase, MongoDB), edge execution (WebAssembly OCR versus cloud APIs), and SVG rendering libraries.
- *Chapter 3: Requirements and Analysis* details the IEEE Std 830-1998 Software Requirements Specification, project timeline (PERT critical path and Gantt schedule), hardware and software requirements, and sixteen conceptual system models.
- *Chapter 4: System Design* specifies the eight subsystems, Firestore schemas, mathematical formulations (Jaccard similarity, weighted consensus, reputation updates), UI designs, security rules, and test case specifications.
- *Chapter 5: Implementation and Testing* describes development across six milestones, core TypeScript implementations, algorithmic complexity analyses, unit and integration testing procedures, and the test execution matrix.
- *Chapter 6: Results and Discussion* presents empirical validation benchmarks (Jaccard latency distributions, hydration measurements, WebAssembly worker isolation), structural codebase analysis, and user guides for submitters, verifiers, and administrators.
- *Chapter 7: Conclusions* summarizes engineering outcomes, reviews current system constraints (such as initial quorum latency and degraded image OCR), outlines potential future extensions (including on-device inference via WebGPU and offline queuing), and provides IEEE references and a technical glossary.
