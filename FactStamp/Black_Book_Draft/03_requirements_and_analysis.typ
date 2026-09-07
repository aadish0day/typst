// =============================================================================
// FACTSTAMP: CHAPTER 3 - REQUIREMENTS AND ANALYSIS
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Jai Hind College (Empowered Autonomous), University of Mumbai
// Candidate: Aadish Das (UID: 2023IT001 / Roll No.: 10)
// =============================================================================

#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

= Requirements and Analysis

== Problem Definition

=== Socio-Technical Context: The Indian Digital Messaging Ecosystem
Over the past decade, the rapid expansion of 4G and 5G telecommunications infrastructure, alongside low-cost cellular data plans, has established the second-largest digitally connected population in the world, with over 850 million active internet users in India. In this environment, *WhatsApp* (Meta Platforms, Inc.) has expanded beyond personal messaging. With more than 535 million active users in India, the application functions as a primary network for civic notices, small-business transactions, and community coordination.

Civic discourse, local Resident Welfare Association (RWA) announcements, trade groups, and family communications take place primarily within WhatsApp groups. However, the core features that drive adoption, including *end-to-end encryption (E2EE)* via the Signal Protocol, automated contact synchronization, low-friction one-tap forwarding, and mobile accessibility, also make the platform a major conduit for unchecked misinformation.

Millions of forwarded messages circulate through private chat networks each day. These messages often distribute unverified health cures, fraudulent financial schemes, manipulated political speeches, altered news graphics, and inflammatory propaganda. Because forwards arrive from trusted family members, colleagues, or community elders, recipients frequently treat them with implicit trust, accelerating the spread of false claims before independent verification occurs.

=== Systemic Failure Modes of Existing Fact-Checking Infrastructure
Traditional journalistic and institutional approaches to fact-checking struggle when confronting peer-to-peer encrypted messaging networks. This limitation stems from six operational failure modes:

#block(
  fill: rgb("F8F9FA"),
  stroke: 0.5pt + luma(180),
  inset: 9pt,
  radius: 3pt,
  width: 100%,
  [
    *Systemic Misinformation Propagation Failures:* \
    #v(3pt)
    1. *Dark Social Blindspot:* Closed encrypted chats conceal hoaxes until secondary real-world harm occurs. \
    2. *Asymmetric Diffusion Velocity:* Emotional falsehoods spread faster than verified journalistic debunks (2h vs 48h). \
    3. *Cognitive & Social Friction:* Sharing long, text-heavy URLs triggers interpersonal friction in chat groups. \
    4. *Lack of Visual Counter-Artifact:* Plain text refutations fail to compete with image-based forwards. \
    5. *Operational Ingestion Barrier:* Mobile users face high friction extracting text from image screenshots. \
    6. *Sybil Vulnerability in Crowds:* Unweighted voting systems collapse under coordinated brigading.
  ]
)

#v(6pt)

1. *The Dark Social Blindspot:*
   Unlike public social media platforms (such as X, Facebook, or Reddit), where web crawlers, search engines, academic researchers, and automated threat-detection algorithms can monitor content diffusion, WhatsApp operates within closed, private networks. Because message payloads are encrypted end-to-end between client endpoints, platform operators and outside researchers cannot observe viral claims directly. Rumors circulate unseen in private groups until external consequences, such as bank runs, communal violence, vaccine hesitancy, or financial fraud, are reported publicly.

2. *Asymmetric Propagation Velocity:*
   Conventional investigative fact-checking organizations (such as AltNews, BOOM Live, or Vishwas News) rely on centralized investigative newsrooms. The investigative lifecycle (discovery, source cross-referencing, official government record verification, editorial review, and publication) typically requires *24 to 72 hours*. In contrast, empirical research on diffusion dynamics (Vosoughi, Roy, and Aral, _Science_, 2018) shows that emotionally charged rumors spread faster and reach wider audiences than verified facts:
   - Rumors concerning politics and health often reach peak viral penetration within *2 to 4 hours* of release.
   - A falsehood is *70% more likely* to be forwarded than a verified factual statement.
   - By the time an investigative report is published 48 hours later, the initial viral wave has passed, leaving millions of recipients misinformed during the critical window of circulation.

3. *Cognitive and Social Friction of Rebuttals:*
   When an informed group member recognizes that a forwarded message is false, attempting to correct the sender introduces interpersonal friction:
   - *Perceived Hostility:* Sending a text-heavy journalistic URL into a family or neighborhood group is frequently interpreted as a personal challenge or political accusation.
   - *Low Engagement with External Links:* Empirical user studies indicate that fewer than 5% of group members open off-platform hyperlinks to read long journalistic articles. Most users ignore external links, leaving the original false claim uncorrected in the chat log.

4. *Absence of a Viral Counter-Artifact:*
   Countering misinformation requires an artifact that matches the transmission format of the original forward:
   - Misinformation circulates effectively because it is packaged into self-contained graphics, memes, and screenshots.
   - In contrast, conventional debunking initiatives publish 1,500-word text articles with academic citations.
   - Without a compact, color-coded, authoritative visual image (a "Fact Stamp") that users can download and forward back into WhatsApp with a single tap, corrections fail to gain traction in chat feeds.

5. *Operational Ingestion Friction on Mobile Devices:*
   Everyday citizens often lack convenient tools to verify claims. Over 35% of forwarded misinformation in India circulates as image screenshots, such as forged newspaper clippings or manipulated television graphics. Extracting text from these images or copying complex multilingual text on touchscreens creates substantial friction, particularly for elderly and non-technical users.

6. *Vulnerability of Crowdsourcing to Sybil Manipulation:*
   While crowdsourcing offers the scale required to match viral velocity, naive voting mechanisms (such as simple majority upvoting) collapse under bot swarms, coordinated brigading, and partisan collusion. Organized groups can skew outcomes if verification relies solely on raw vote volume rather than citation quality and verifier accountability.

=== Formal Problem Statement
#block(
  fill: rgb("FFFDF8"),
  stroke: 1pt + rgb("BA3E03"),
  inset: 10pt,
  radius: 3pt,
  width: 100%,
  [
    *Formal Problem Statement:* \
    #text(style: "italic")[
      "There is an urgent requirement for an open, decentralized, privacy-preserving, and zero-cost misinformation counter-measure that: (1) eliminates mobile ingestion friction via automated client-side WebAssembly OCR; (2) suppresses redundant workloads via sub-second token-level Jaccard duplicate detection; (3) resolves verification latency through a multi-factor weighted quorum consensus engine resistant to Sybil attacks; and (4) compiles certified verdicts into high-impact, unalterable, square 1080×1080px visual fact cards directly distributable within encrypted WhatsApp chat streams."
    ]
  ]
)

=== Research Questions and Engineering Hypotheses
To guide system design and empirical validation, FactStamp addresses four core research hypotheses:

- *Hypothesis 1 (Client-Side Privacy & Ingestion):* An in-browser WebAssembly OCR pipeline (Tesseract.js) combined with offscreen canvas downscaling ($<= 1280$px, $< 700$ KB payload) and chat chrome pattern cleaning can extract text from mobile screenshots in under 2.5 seconds directly within browser RAM, protecting user data privacy with zero recurring cloud API expense.
- *Hypothesis 2 (Duplicate Suppression):* A word-level tokenized Jaccard similarity index with stop-particle filtering ($|w| > 3$) and a calibrated threshold of $J >= 0.75$ can successfully identify $>= 95\%$ of viral WhatsApp forward variants (accounting for emoji alterations, greeting boilerplate, and minor typos) while maintaining a $0.0\%$ false-positive collision rate, and redirect users directly to canonical dossiers without redundant database writes.
- *Hypothesis 3 (Sybil-Resistant Consensus):* A multi-factor weighted consensus model ($C = round(0.40 dot A + 0.30 dot R + 0.30 dot S)$) requiring a minimum quorum of $N >= 3$ independent verifiers, backed by anti-self-verification constraints ($"submittedBy" != "verifierId"$) and domain authority scoring ($S in {100, 70, 30}$), can prevent coordinated bot swarms ($R = 50, S = 30$, capping confidence at $64\%$) from certifying fraudulent claims while allowing high-credibility verifiers citing sovereign sources to achieve certified status ($C >= 70\%$).
- *Hypothesis 4 (Visual Counter-Artifact Efficacy):* Packaging certified verdicts into standardized square ($1080 times 1080$px, 1:1) PNG cards rendered via browser-native SVG `<foreignObject>` canvas rasterization eliminates cross-platform layout distortion, circumvents CSS color parsing breakdowns, and enables direct forwarding back into WhatsApp chat groups.

#pagebreak()

== Requirements Specification

=== Introduction and Formal Compliance (IEEE Std 830-1998)
In accordance with *IEEE Std 830-1998* (_Recommended Practice for Software Requirements Specifications_), this document establishes the formal software requirements for the FactStamp platform. The specification partitions the system into:
1. *Functional Requirements (FR):* Observable behaviors, input processing, calculations, and state transitions for each subsystem.
2. *Non-Functional Requirements (NFR):* Quantitative quality attributes, performance envelopes, security controls, and operational constraints.
3. *External Interface Requirements:* Specifications for interactions with human actors, hardware peripherals, software libraries, and communications protocols.

=== Functional Requirements (REQ-1 to REQ-10)

#styled-table(
  columns: (0.9in, 1.8in, 0.9in, 1fr),
  headers: ("Req ID", "Feature / Subsystem", "Priority", "Core Acceptance Criteria"),
  "REQ-1", "Multimodal Claim Ingestion", "High", "Plaintext (10 to 2,000 chars) or Image (<=5 MB, JPEG/PNG/WebP/GIF); 5 categories; zero account mandate.",
  "REQ-2", "Client-Side WASM OCR Extraction", "High", "Tesseract.js WASM worker; chat chrome cleaning; keyword category inference; < 2.5s execution; zero server upload.",
  "REQ-3", "Real-Time Jaccard Duplicate Index", "High", "Token set J >= 0.75 threshold (|w| > 3); sub-100ms redirect to canonical claim; zero redundant writes.",
  "REQ-4", "Quorum Verification Queue", "High", "Public queue; status: 'pending'; N >= 3 quorum barrier; self-verification lock; explanation >= 50 chars & >= 8 words.",
  "REQ-5", "Weighted Consensus Engine", "High", "C = round(0.40A + 0.30R + 0.30S); C in [0, 100]; status: 'verified'; overdue auto-settlement to 'CONTESTED'.",
  "REQ-6", "Anti-Sybil Reputation Engine", "High", "Base R0 = 50; +2 consensus agreement reward / -1 dissent penalty; clamped [0, 100]; immutable by self.",
  "REQ-7", "1080x1080 Fact Card Generator", "High", "html-to-image SVG foreignObject; 1:1 WhatsApp form factor; 2x retina PNG export; anti-clipping layout.",
  "REQ-8", "Misinformation Analytics Dash", "Medium", "Dynamic 7-day category breakdown (5 categories) and verifier leaderboards via Recharts.",
  "REQ-9", "Role-Based Access Control (RBAC)", "High", "Submitter (anon), Verifier (auth), Admin (isAdmin=true); priority flagging, overrides, and /audit_logs.",
  "REQ-10", "Authentication & Session Security", "High", "30-min idle timeout; 5-attempt/15m login rate limiting; null-byte & regex XSS input sanitization."
)

#v(8pt)

*Detailed Functional Specifications:*

- *REQ-1: Multimodal Claim Ingestion Subsystem*
  - *Description:* The system shall permit any user (without requiring pre-registration or authentication) to submit suspicious WhatsApp forward content for community verification.
  - *Inputs:* Raw textual forward (UTF-8, minimum 10 characters, maximum 2,000 characters); screenshot image file (JPEG, PNG, WebP, or GIF; maximum file size 5.0 MB); topical category selection (`health`, `political`, `religious`, `financial`, `other`).
  - *Processing & Business Logic:* Client-side sanitization strips dangerous HTML elements, inline event attributes, dangerous protocol schemes, and null bytes (`\0`). For image uploads, the system validates MIME type, file extension, and raw binary magic bytes (`0xFFD8FF` for JPEG, `0x89504E47` for PNG, `0x47494638` for GIF, `0x52494646` for WebP). The image is loaded into an offscreen HTML5 canvas, downscaled to a maximum dimension of $<= 1280$px, and compressed to a normalized base64 JPEG data URL under 700 KB (string length $<= 800,000$ characters) via dynamic quality stepping.
  - *Outputs:* Structured claim object committed to `/claims` with `status: 'pending'` and `verificationCount: 0`, or immediate invocation of the OCR pipeline (REQ-2).
  - *Acceptance Criteria:* Unauthenticated public users can complete claim submission in under three clicks. Corrupt or oversized files (> 5 MB) are rejected with descriptive client-side security alerts.

- *REQ-2: Client-Side WebAssembly OCR Extraction Subsystem*
  - *Description:* The system shall automatically parse and extract embedded text from user-uploaded forward screenshots using an in-browser WebAssembly OCR pipeline.
  - *Inputs:* Client-downscaled screenshot image buffer from REQ-1.
  - *Processing & Business Logic:* A dedicated background Web Worker thread instantiates Tesseract.js with pre-compiled language models. The extracted raw string is filtered through `cleanExtractedOcrText()`, which excises WhatsApp chat chrome patterns (timestamps, delivery checkmarks, "forwarded many times" markers, and battery/network status lines) and normalizes line breaks. The pipeline then applies `detectClaimCategory()` using keyword heuristics (e.g., medical terms mapping to `health`, government/election terms mapping to `political`) to auto-suggest the appropriate category. The cleaned string is populated directly into an editable textarea for user review.
  - *Outputs:* Cleaned plaintext string and detected category presented for user review and manual correction.
  - *Acceptance Criteria:* OCR processing on standard mobile devices shall complete within 2.5 seconds. The image buffer remains strictly within browser RAM, never transmitted to external cloud vision APIs.

- *REQ-3: Real-Time Jaccard Duplicate Suppression Engine*
  - *Description:* Before creating a new claim document, the system shall evaluate the forward string against existing cached claims to detect duplicates and prevent fragmentation of community review effort.
  - *Inputs:* Forward text string and array of existing claims.
  - *Processing & Business Logic:* Normalization converts text to lowercase, removes all punctuation via `/[^\w\s]/g`, collapses whitespace, and trims edges. The `tokenize()` routine filters out short syntactic particles with $|w| <= 3$, constructing a distinct word token set $S$. The engine evaluates pairwise Jaccard similarity against all existing claims:
    $ J(S_A, S_B) = frac(|S_A inter S_B|, |S_A union S_B|) = frac(|S_A inter S_B|, |S_A| + |S_B| - |S_A inter S_B|) $
    If $J(S_A, S_B) >= 0.75$, a duplicate match is confirmed.
  - *Outputs:* If duplicate detected: Abort document creation, render an amber match banner, and immediately redirect the user to `/claim/{id}` of the canonical dossier. If unique ($J < 0.75$): Commit a new document to `/claims` with `status: 'pending'`, `verificationCount: 0`, and `verifications: []`.
  - *Acceptance Criteria:* In-memory duplicate search across up to 5,000 cached records shall execute in under 100 ms on mobile clients with zero redundant database writes.

- *REQ-4: Quorum Verification Queue Subsystem*
  - *Description:* The system shall maintain an open, transparent queue of pending claims accessible to authenticated community verifiers.
  - *Inputs:* Authenticated verifier session; truth rating selection (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`); primary source citation URL; explanation rationale.
  - *Processing & Business Logic:* Enforces the *Anti-Self-Verification Lock:* A user cannot review a claim they submitted (`auth.uid != claim.submittedBy`). Enforces the *Single-Vote-Per-User Invariant:* A verifier cannot cast multiple votes on the same claim dossier. Validates that the citation URL begins with `http://` or `https://` ($<= 500$ chars) and evaluates domain authority: High Quality (100), Medium Quality (70), or Low Quality (30). Validates the explanation rationale via `validateVerdictExplanation()`: must contain between 50 and 1,500 characters, minimum 8 words, reject repetitive character padding (`/(.)\1{5,}/`), reject repetitive words, reject generic cop-out filler phrases, and prohibit verbatim repetition of the claim text.
  - *Outputs:* New verification map appended to `claim.verifications`; atomic increment of `claim.verificationCount` by $+1$.
  - *Acceptance Criteria:* Quorum accumulation triggers consensus calculation immediately upon recording the 3rd verification ($N >= 3$).

- *REQ-5: Multi-Factor Weighted Consensus Engine*
  - *Description:* Upon accumulating a quorum of three ($N >= 3$) independent verifications, the system shall execute an algorithmic consensus model to determine the certified verdict and confidence score.
  - *Inputs:* Array of verification objects containing individual verdict enums, verifier reputation snapshots ($R_i$), and source quality scores ($S_i$).
  - *Processing & Business Logic:* Identify the majority verdict $V_"maj" = arg max_v "count"(v)$. Compute Agreement Ratio $A = (N_"majority" / N_"total") times 100$. Compute Mean Verifier Reputation $R = frac(1, N) sum R_i$. Compute Mean Source Quality $S = frac(1, N) sum S_i$. Compute Composite Confidence Score:
    $ C = min(100, max(0, round(0.40 dot A + 0.30 dot R + 0.30 dot S))) $
    Update claim document: set `status: 'verified'`, `verdict: V_maj`, `confidenceScore: C`, `agreementRatio: A`, `avgVerifierReputation: R`, `sourceQualityScore: S`, and `verifiedAt: timestamp`.
    *Consensus Deadline Handling:* If a pending claim reaches its 7-day deadline ($T > T_"created" + 7 "days"$) without reaching 3 verifications, `expireOverdueClaims()` resolves the claim: sets `status: 'verified'`, `verdict: 'CONTESTED'`, and computes confidence from existing verifications or defaults to 30.
  - *Outputs:* Fully resolved claim document with certified verdict, confidence metric, and unlocked Fact Card generation.
  - *Acceptance Criteria:* Consensus calculation executes in under 20 ms. Overdue claims transition to `CONTESTED` automatically without human intervention.

- *REQ-6: Anti-Sybil Reputation Engine*
  - *Description:* The system shall track and dynamically update verifier reputation scores based on their historical accuracy and consensus alignment.
  - *Inputs:* Majority consensus verdict; participating verifiers' submitted votes.
  - *Processing & Business Logic:* Baseline reputation initializes at $R_0 = 50$ (integer range $0$ to $100$). When consensus is reached on a claim:
    - *Consensus Alignment Reward:* Verifiers whose vote aligned with the majority verdict receive $+2$ points: $R_"new" = min(100, R_"current" + 2)$.
    - *Dissenting / Outlier Penalty:* Verifiers whose vote diverged from the majority verdict receive $-1$ point: $R_"new" = max(0, R_"current" - 1)$.
    Total verifications counter increments atomically: `totalVerifications = totalVerifications + 1`.
  - *Outputs:* Updated `reputation` and `totalVerifications` fields in `/users/{uid}`.
  - *Acceptance Criteria:* Reputation modifications are strictly protected in `firestore.rules`: users cannot manually alter their own reputation or total verification counts.

- *REQ-7: 1080×1080px Fact Card Generator Subsystem*
  - *Description:* The system shall compile certified claims into an unalterable, high-resolution square PNG fact card directly within the client browser.
  - *Inputs:* Certified claim text, category badge, majority verdict enum, confidence percentage, verifier count, primary source citations, and verification date.
  - *Processing & Business Logic:* Renders the card preview component using the *Saffron Sleek* design system. Invokes `html-to-image` to clone the target DOM node, serialize it inside an SVG `<foreignObject>`, and rasterize it onto an HTML5 canvas at `pixelRatio: 2`. Encodes the canvas into a high-DPI $1080 times 1080$px PNG image blob.
  - *Outputs:* Automated browser file download (`factstamp-[claimId].png`).
  - *Acceptance Criteria:* Graphic export shall execute in under 800 ms on mobile devices with exact 1:1 aspect ratio, 100% color fidelity across Tailwind v4 OKLCH tokens, and zero text clipping.

- *REQ-8: Misinformation Analytics Dashboard*
  - *Description:* The system shall aggregate and visualize platform verification telemetry to provide public transparency into misinformation trends.
  - *Inputs:* Real-time collection of claims and verifier profiles.
  - *Processing & Business Logic:* Dynamically computes rolling 7-day submission volumes. Computes topical category distribution percentages across the five canonical domains (`health`, `political`, `religious`, `financial`, `other`). Computes verifier accuracy rankings and top debunked viral claims. Renders responsive declarative SVG charts via Recharts with Framer Motion animated counters.
  - *Outputs:* Interactive trend charts, category distributions, and public verifier reputation leaderboards.
  - *Acceptance Criteria:* Dashboard renders in under 300 ms, updating reactively via Firestore snapshots.

- *REQ-9: Role-Based Access Control (RBAC) Subsystem*
  - *Description:* The system shall enforce a strict three-tier Role-Based Access Control model.
  - *Roles & Permissions:*
    1. *Public Submitter (Unauthenticated / Anonymous):* Can submit forward text and screenshots; can search existing claims; can download certified fact cards. Cannot vote or access the verification queue.
    2. *Community Verifier (Authenticated):* All Submitter privileges; can browse the pending verification queue; can submit verification votes with source citations and rationales; earns and loses reputation points. Strictly blocked from verifying self-submitted claims.
    3. *Platform Administrator (Privileged, `users/{uid}.isAdmin == true`):* All Verifier privileges; can flag claims for expedited review (`adminFlagged: true`); can override erroneous verdicts (`adminOverrideClaim`); can remove illegitimate verifications (`adminDeleteVerification`); can adjust user reputations (`adminUpdateUserDoc`); can manage moderation reports (`/reports`); all actions written to immutable `/audit_logs`.
  - *Acceptance Criteria:* Unauthorized attempts to access administrative endpoints or mutate admin flags are blocked at both the UI router (`AdminRoute`) and Firestore security rule boundary (`isAdmin()` check).

- *REQ-10: Authentication Hardening & Session Security*
  - *Description:* The client authentication layer and security middleware shall enforce defense-in-depth protections against credential stuffing, session hijacking, and injection attacks.
  - *Inputs:* Authentication requests, user interaction events (`keydown`, `mousedown`, `touchstart`), and text inputs.
  - *Processing & Business Logic:*
    - *Login Rate Limiting:* `checkLoginRateLimit()` enforces a maximum of 5 failed login attempts (`MAX_LOGIN_ATTEMPTS = 5`) followed by a 15-minute lockout (`LOCKOUT_DURATION_MS = 15 * 60 * 1000`) with MM:SS countdown display, using dual `localStorage` with `sessionStorage` fallback.
    - *Idle Session Timeout:* User interactions invoke `recordActivity()`, updating `fs_last_activity` in `sessionStorage`. If elapsed inactivity exceeds 30 minutes (`SESSION_TIMEOUT_MS = 30 * 60 * 1000`), `isSessionExpired()` triggers session clearance and forces re-authentication.
    - *Input Sanitization:* `sanitizeTextInput()` eliminates dangerous HTML tags, event handlers, pseudo-protocols, and null bytes (`\0`).
  - *Outputs:* Throttling lockout timers, session termination events, and sanitized string payloads.
  - *Acceptance Criteria:* Defends against automated brute-force attacks and session hijacking on shared mobile workstations.

#pagebreak()

=== Non-Functional Requirements (NFR-1 to NFR-6)

#styled-table(
  columns: (0.8in, 1.6in, 1fr),
  headers: ("Req ID", "Quality Attribute", "Quantitative Specification & Acceptance Benchmark"),
  "NFR-1", "Performance & Latency", [Initial bundle size < 250 KB gzipped; Jaccard duplicate search < 100 ms for 5,000 cached records; in-browser mobile WASM OCR < 2.5 seconds; Fact Card PNG export < 800 ms at $1080 times 1080$px (2x retina); Firestore real-time voting sync latency < 120 ms.],
  "NFR-2", "Privacy & Confidentiality", [Uploaded screenshots and forward texts processed entirely within client browser RAM; zero persistent storage of personal phone numbers, chat contact names, or user IP addresses; zero telemetry transmission to commercial advertising networks.],
  "NFR-3", "Security & Integrity", [100% of database write transactions validated by declarative Cloud Firestore Security Rules; all text inputs sanitized against Cross-Site Scripting (XSS) and injection; session tokens managed exclusively via Google Firebase Authentication (OAuth 2.0 / RS256 JWT).],
  "NFR-4", "Usability & Accessibility", [UI compliant with *Saffron Sleek* design system; contrast complies with Accessible Perceptual Contrast Algorithm (APCA) ($L^c >= 75$ for body text); all interactive mobile touch targets measure >= 48 by 48px; responsive from 320px smartphones to 4K displays.],
  "NFR-5", "Reliability & Availability", [Target 99.9% platform availability backed by Vercel Edge Network and Google Cloud Firestore multi-region clusters; local-first offline caching via IndexedDB maintains UI operational resilience during brief network disconnects.],
  "NFR-6", "Zero-Cost Sustainability", [Entire system architecture must operate 100% within perpetual free-tier cloud quotas (Firebase Spark tier and Vercel Hobby tier), incurring zero monthly operational compute or database expenses.]
)

=== External Interface Requirements
1. *User Interfaces (UI):*
   - *Design Language:* The interface implements the *Saffron Sleek* design system, using warm cream surfaces (`#FFFDF8`), brand saffron accents (`#BA3E03`), and high-contrast stone typography.
   - *Navigation:* Mobile-first sticky bottom navigation bar providing instant access to `/submit`, `/queue`, `/dashboard`, and `/profile`.
   - *Verdict Indicators:* Prominent, color-coded badges with distinct iconography for TRUE (Emerald Green), FALSE (Crimson Red), MISLEADING (Amber Orange), UNVERIFIABLE (Slate Gray), and CONTESTED (Cobalt Blue).
2. *Software Interfaces:*
   - *Google Firebase Authentication SDK (v10.x):* Manages user registration, email verification, Google OAuth 2.0 popups, and secure JWT token renewal.
   - *Google Cloud Firestore SDK (v10.x):* Provides reactive `onSnapshot` listeners, offline persistence via IndexedDB, and document-level transaction management.
   - *Tesseract.js (v5.x):* In-browser WebAssembly OCR worker using pre-compiled language models running in dedicated Web Workers.
   - *html-to-image (v1.11.x):* Native SVG `<foreignObject>` DOM-to-canvas rasterizer.
   - *Recharts (v2.x):* Declarative SVG charting library for rendering 7-day category trends and accuracy leaderboards.
3. *Hardware Interfaces:*
   - Standard mobile capacitive touchscreens supporting tap, long-press, and swipe gestures.
   - Read/write access to device storage for selecting screenshot files and downloading generated PNG fact cards.
4. *Communications Interfaces:*
   - All HTTP communications enforced over *HTTPS / TLS 1.3* with strict HSTS headers.
   - Real-time WebSockets Secure (WSS) connections established directly between the client browser and Firebase edge servers for real-time data streaming.

#pagebreak()

== Planning and Scheduling

=== Software Development Life Cycle (SDLC) Model Justification
Selecting an SDLC process model balances scope, schedule risk, technical uncertainties, and user feedback. Developing FactStamp involved technical uncertainties:
- Integrating cutting-edge WebAssembly OCR (`tesseract.js`) directly into client mobile browsers.
- Managing experimental CSS Color Level 4 (`oklch`) rendering breakdowns within DOM-to-canvas exporters.
- Calibrating mathematical thresholds for duplicate detection ($J >= 0.75$) and consensus confidence ($C >= 70\%$).

Four traditional and modern process models were formally evaluated:

#styled-table(
  columns: (1.2in, 1.8in, 1fr),
  headers: ("Process Model", "Operational Characteristics", "Justification / Deficit for FactStamp"),
  "Waterfall Model", "Linear, sequential phases; rigid upfront requirements freeze.", "Incompatible: Unforeseen canvas bugs and color issues require continuous pivots.",
  "V-Model", "Verification & validation paired at each stage; heavy documentation.", "Inflexible: Test cases cannot easily adapt to emergent client-side WASM APIs.",
  "Spiral Model", "Risk-driven, cyclical prototyping for large aerospace projects.", "Over-engineered: Excessive governance overhead for a lightweight web platform.",
  "Agile Scrum", "Timeboxed 2-week sprints; rapid iterative releases; user demos.", "SELECTED MODEL: Balances empirical parameter tuning, fast iteration, and client feedback."
)

#v(6pt)

*Why Agile Scrum Was Selected:*
1. *Iterative Problem Discovery:* During Sprint 3, when standard canvas parsers failed on Tailwind v4 OKLCH color tokens, the team migrated to `html-to-image` within the active sprint without disrupting the overall delivery schedule.
2. *Empirical Parameter Tuning:* The Jaccard threshold ($0.75$) and consensus weights ($0.40A + 0.30R + 0.30S$) could not be determined purely in theory. Sprint reviews enabled parameter testing against 200 real-world WhatsApp forward samples, tuning weights based on empirical validation.
3. *Continuous Stakeholder Validation:* Bi-weekly sprint demos to academic guides and student peer groups provided early feedback on mobile touch ergonomics and font rendering.

=== Work Breakdown Structure (WBS)
The engineering lifecycle of FactStamp was decomposed into 14 discrete, measurable work activities ($T_1$ to $T_{14}$):
- *$T_1$: Problem Definition & Stakeholder Requirements Analysis:* Formulate problem definition, conduct dark social literature review, and author the IEEE Std 830-1998 SRS.
- *$T_2$: Technology Survey & Comparative Architecture Evaluation:* Conduct comparative benchmarks across web architectures, frontend frameworks, cloud databases, OCR engines, styling systems, and consensus models.
- *$T_3$: System Architecture & Security Rules Design:* Design decoupled serverless SPA model, Firestore collections schema, and declarative security rule boundaries.
- *$T_4$: Authentication & Verifier Profile Subsystem:* Implement Firebase Auth (OAuth 2.0 / Email), session management, inactivity timeouts, rate limiting, and verifier profile tracking.
- *$T_5$: Client-Side Canvas Image Compression & WASM OCR Pipeline:* Build offscreen HTML5 canvas downscaler, integrate Tesseract.js WebAssembly worker, and test mobile memory footprint.
- *$T_6$: Tokenization & Jaccard Duplicate Detection Engine:* Implement string normalizer, stop-particle filter ($|w| > 3$), token set extractor, and pairwise Jaccard similarity index ($J >= 0.75$).
- *$T_7$: Quorum Verification Queue & Real-Time Sync Subsystem:* Develop public verification queue UI, voting forms, and real-time Firestore `onSnapshot` WebSocket listeners.
- *$T_8$: Multi-Factor Weighted Quorum Consensus Engine:* Formulate and code algorithmic consensus engine ($C = round(0.40A + 0.30R + 0.30S)$), source domain credibility lookup, 7-day expiry settlement, and verifier reputation scoring ($+2 / -1$).
- *$T_9$: Dynamic 1080×1080px Fact Card Generator:* Implement `html-to-image` SVG `<foreignObject>` DOM rasterizer, 2x retina export, and automated PNG download pipeline.
- *$T_{10}$: Misinformation Analytics Dashboard & Trend Visualizer:* Build rolling 7-day category trend charts across 5 categories, category distributions, and public verifier accuracy leaderboards using Recharts.
- *$T_{11}$: Integration & End-to-End System Testing:* Execute comprehensive unit testing, security rule penetration testing, and cross-browser mobile validation.
- *$T_{12}$: User Acceptance Testing (UAT) & Civic Verifier Trials:* Conduct pilot verification sessions with student peer groups and evaluate system usability metrics.
- *$T_{13}$: Serverless Cloud Deployment & Performance Optimization:* Configure Vercel Edge CDN, production Rollup chunk splitting, and TLS 1.3 edge caching.
- *$T_{14}$: Final Documentation & Dissertation Preparation:* Compile academic Black Book dissertation, user manual, and technical viva presentations.

=== Probabilistic 3-Point PERT Estimation
Because client-side WebAssembly execution and browser-native SVG rasterization introduced runtime uncertainties, task durations were calculated using the *Program Evaluation and Review Technique (PERT)* probabilistic three-point estimation:
$ T_E = frac(O + 4M + P, 6) wide quad "and" wide quad sigma^2 = (frac(P - O, 6))^2 $
Where $O$ = Optimistic duration, $M$ = Most Likely duration, and $P$ = Pessimistic duration in working days.

=== Computational PERT Schedule Analysis
Using the Forward Pass (Early Start $E S$, Early Finish $E F$) and Backward Pass (Late Start $L S$, Late Finish $L F$), the *Total Float / Slack* ($S = L S - E S = L F - E F$) is calculated for every task:

#styled-table(
  columns: (0.35in, 0.45in, 0.28in, 0.28in, 0.28in, 0.38in, 0.38in, 0.38in, 0.38in, 0.38in, 0.38in, 0.35in, 0.45in),
  headers: ("Task", "Pred.", "O", "M", "P", "T_E", "Var", "ES", "EF", "LS", "LF", "Slack", "Critical"),
  "T1", "None", "5", "7", "15", "8.0", "2.78", "0.0", "8.0", "0.0", "8.0", "0.0", "Yes",
  "T2", "T1", "4", "6", "14", "7.0", "2.78", "8.0", "15.0", "10.0", "17.0", "2.0", "No",
  "T3", "T1", "6", "9", "12", "9.0", "1.00", "8.0", "17.0", "8.0", "17.0", "0.0", "Yes",
  "T4", "T3", "5", "8", "11", "8.0", "1.00", "17.0", "25.0", "21.0", "29.0", "4.0", "No",
  "T5", "T3", "8", "12", "16", "12.0", "1.78", "17.0", "29.0", "17.0", "29.0", "0.0", "Yes",
  "T6", "T5", "6", "8", "16", "9.0", "2.78", "29.0", "38.0", "29.0", "38.0", "0.0", "Yes",
  "T7", "T4, T6", "7", "10", "19", "11.0", "4.00", "38.0", "49.0", "38.0", "49.0", "0.0", "Yes",
  "T8", "T7", "5", "8", "11", "8.0", "1.00", "49.0", "57.0", "49.0", "57.0", "0.0", "Yes",
  "T9", "T8", "6", "10", "14", "10.0", "1.78", "57.0", "67.0", "57.0", "67.0", "0.0", "Yes",
  "T10", "T9", "5", "7", "15", "8.0", "2.78", "67.0", "75.0", "67.0", "75.0", "0.0", "Yes",
  "T11", "T10", "6", "9", "12", "9.0", "1.00", "75.0", "84.0", "75.0", "84.0", "0.0", "Yes",
  "T12", "T11", "4", "6", "14", "7.0", "2.78", "84.0", "91.0", "87.0", "94.0", "3.0", "No",
  "T13", "T11", "6", "10", "14", "10.0", "1.78", "84.0", "94.0", "84.0", "94.0", "0.0", "Yes",
  "T14", "T12, T13", "5", "7", "9", "7.0", "0.44", "94.0", "101.0", "94.0", "101.0", "0.0", "Yes"
)

=== Critical Path Determination and Statistical Confidence
The *Critical Path* comprises the sequence of dependent tasks possessing exactly zero total slack ($S = 0$):
$ "Critical Path" = T_1 arrow.r T_3 arrow.r T_5 arrow.r T_6 arrow.r T_7 arrow.r T_8 arrow.r T_9 arrow.r T_10 arrow.r T_11 arrow.r T_13 arrow.r T_14 $

*Statistical Confidence Parameters:*
1. *Total Expected Project Duration ($T_E$):*
   $ T_E = 8.0 + 9.0 + 12.0 + 9.0 + 11.0 + 8.0 + 10.0 + 8.0 + 9.0 + 10.0 + 7.0 = bold(101.0 " working days") $
   This corresponds to approximately *14.4 calendar weeks* or *3.5 academic months*.
2. *Total Critical Path Variance ($sigma^2_P$):*
   $ sigma^2_P = 2.78 + 1.00 + 1.78 + 2.78 + 4.00 + 1.00 + 1.78 + 2.78 + 1.00 + 1.78 + 0.44 = bold(21.12 " days"^2) $
3. *Project Standard Deviation ($sigma_P$):*
   $ sigma_P = sqrt(21.12) approx bold(4.60 " days") $

*Probability of On-Time Delivery:*
Assuming the project deadline is established at $D = 110$ working days (academic semester deadline):
$ Z = frac(D - T_E, sigma_P) = frac(110.0 - 101.0, 4.60) = frac(9.0, 4.60) approx +1.957 $
Using standard cumulative normal distribution tables:
$ P(T <= 110) = Phi(1.957) approx bold(97.5\%) $
The statistical analysis demonstrates a *97.5% probability* of completing full system implementation, testing, and dissertation documentation prior to the academic deadline.

=== Activity-on-Node PERT Network Diagram
The Activity-on-Node PERT network diagram illustrates the critical path ($S = 0$) and parallel paths below:

#v(8pt)
#figure(
  image("attachments/pert_chart.svg", height: 80%, fit: "contain"),
  caption: [FactStamp Activity-on-Node PERT Network Diagram & Critical Path ($T_E = 101.0$ Days)],
)
#v(6pt)

=== Master Implementation GANTT Chart Breakdown
The 101-day implementation schedule was orchestrated across four 2-week Sprint cycles, as formalized in the Gantt schedule below:

#styled-table(
  columns: (1.1in, 1.2in, 1.4in, 1.7in),
  headers: ("Sprint Milestone", "Calendar Window", "Target Epic & Engineering Activities", "Key Verifiable Deliverables"),
  "Sprint 1 (Weeks 1 to 4)", "Days 1 to 29", "Requirements, Scaffolding, Canvas Compression & Tesseract.js OCR", "IEEE Std 830 SRS; client-side image downscaler; functional WASM OCR pipeline.",
  "Sprint 2 (Weeks 5 to 8)", "Days 30 to 57", "Jaccard Duplicate Engine, Quorum Queue, and Multi-Factor Consensus", "Sub-100ms duplicate lookup; real-time Firestore queue; consensus calculation logic.",
  "Sprint 3 (Weeks 9 to 12)", "Days 58 to 84", "html-to-image SVG Engine, OKLCH Color Tokens & Analytics Dashboard", "1080×1080px Fact Card generator; 7-day rolling category trend charts with Recharts.",
  "Sprint 4 (Weeks 13 to 15)", "Days 85 to 101", "Security Rules Hardening, UAT Trials, Vercel Edge CDN Deployment & Viva", "Production deployment on Vercel; zero security flaws; verified academic dissertation."
)

#v(8pt)
#figure(
  image("attachments/gantt_chart.svg", width: 95%),
  caption: [FactStamp Master Implementation GANTT Schedule (101 Working Days Across 4 Sprints)],
)
#v(6pt)

*Non-Critical Float Buffer Management:*
Three activities have non-zero total float (slack), providing operational buffers against unforeseen bottlenecks:
1. *$T_2$ (Technology Survey, Slack = 2.0 days):* Permits extended evaluation of candidate OCR engines without delaying architecture finalization.
2. *$T_4$ (Authentication Subsystem, Slack = 4.0 days):* Parallelized alongside $T_5$ (WASM OCR); finishes on Day 25 while $T_5$ runs until Day 29, providing a 4-day buffer before Quorum Queue ($T_7$) begins on Day 38.
3. *$T_{12}$ (UAT & Civic Trials, Slack = 3.0 days):* Executes concurrently with Cloud Deployment ($T_{13}$); finishes on Day 91 while $T_{13}$ runs until Day 94, which preserves a 3-day buffer prior to final dissertation compilation ($T_{14}$).

#pagebreak()

== Software and Hardware Requirements

=== Introduction and Infrastructure Philosophy
FactStamp is engineered for zero-budget serverless deployment, ensuring reliable execution on budget smartphones while supporting fast builds on development workstations and 99.9% uptime on serverless hosting.

=== Hardware Specifications
The hardware environment is partitioned into three operational tiers: Developer Workstations, Target End-User Mobile Devices (Smartphones), and Target End-User Desktop/Laptop Workstations:

#styled-table(
  columns: (1.2in, 1.8in, 1fr),
  headers: ("Hardware Tier", "Minimum Operational Specification", "Recommended Production Specification"),
  "Developer Workstation", "Intel Core i5 / AMD Ryzen 5 (4 Cores), 8 GB DDR4 RAM, 256 GB NVMe SSD, 1080p Display.", "Intel Core i7 / AMD Ryzen 7 (8 Cores/16 Threads), 16 to 32 GB RAM, 512 GB to 1 TB NVMe PCIe 4.0 SSD, Dual 1080p Displays.",
  "Target Mobile Device (Smartphone)", "Quad-Core ARM CPU (1.4 GHz), 2 GB LPDDR3 RAM, 3G / 4G LTE Cellular Network, 720×1280 Touchscreen Display.", "Octa-Core ARM CPU (2.0 GHz+), 4 to 8 GB LPDDR4X/LPDDR5 RAM, 4G+ / 5G / High-Speed Wi-Fi, 1080×2400 AMOLED 90/120Hz Display.",
  "Target Desktop Client", "Dual-Core x86_64 CPU (2.0 GHz), 4 GB RAM, Broadband Internet (2 Mbps), 1366×768 Screen Resolution.", "Quad-Core x86_64 CPU (2.8 GHz+), 8 to 16 GB RAM, High-Speed Fiber (25+ Mbps), 1920×1080 Full HD IPS Display."
)

*Mobile Client Hardware Considerations:*
Because Tesseract.js executes character recognition via client-side WebAssembly, device RAM is the primary performance bottleneck:
- On devices with *2 GB RAM*, FactStamp's automatic canvas downscaling reduces the image payload to $<= 1280$px before WASM memory allocation, preventing mobile browser tab crashes (`Out Of Memory` kills).
- Web Worker threads are dynamically capped to a single thread (`workers: 1`) on dual/quad-core mobile CPUs to prevent thermal throttling and UI stutter.
- Object URLs are promptly revoked (`URL.revokeObjectURL`) to release browser heap memory immediately after image decoding.

=== Software Requirements & Build Toolchain

#styled-table(
  columns: (1.3in, 1.4in, 0.8in, 1fr),
  headers: ("Software Component", "Technology / Package", "Version", "Architectural Role & Justification in FactStamp"),
  "Operating System", "Arch Linux / Ubuntu / Windows / macOS", "Kernel 6.x+", "Primary development executed on Arch Linux; cross-platform browser runtime for clients.",
  "JavaScript Runtime", "Node.js (LTS)", "v20.12.0+", "Server-side JavaScript execution environment for build scripts and dependency orchestration.",
  "Package Manager", "pnpm / npm", "v9.x / v10.x", "High-performance, disk-space-efficient deterministic dependency resolution.",
  "Frontend Framework", "React + React DOM", "v18.3.1", "Core UI library providing Concurrent Mode, useTransition, and component lifecycle.",
  "Language", "TypeScript", "v5.4.5", "Static type-checking across data models, Firestore schemas, and consensus math.",
  "Build Toolchain", "Vite", "v5.2.0", "Native ES module development server; Rollup production tree-shaking and chunk splitting.",
  "Styling Engine", "Tailwind CSS (Oxide)", "v4.0.0-beta+", "High-performance utility-first CSS compiler with native OKLCH theme tokens.",
  "Iconography", "Lucide React", "v0.378.0", "Lightweight, tree-shakeable SVG icons for accessible UI controls.",
  "In-Browser OCR", "Tesseract.js", "v5.1.0", "Pure JavaScript/WASM OCR engine executing in background Web Workers.",
  "Fact Card Exporter", "html-to-image", "v1.11.11", "DOM-to-canvas rasterizer using native browser SVG <foreignObject> rendering.",
  "Analytics Charting", "Recharts", "v2.12.7", "Declarative SVG charting library for mobile-responsive trend visualization.",
  "Cloud BaaS SDK", "Firebase JS SDK", "v10.12.0", "Client libraries for Firebase Authentication and Cloud Firestore real-time listeners.",
  "Typesetting Engine", "Typst", "v0.15.1", "Modern academic document compiler for compiling the official university dissertation.",
  "Diagram Tooling", "Graphviz (dot) & PlantUML", "v16.0 / v1.2024", "Automated compilation of DFDs, E-R diagrams, UML Class, and Object diagrams."
)

=== Cloud Infrastructure & Free-Tier Quota Architecture
FactStamp operates as a serverless platform hosted across Google Cloud (Firebase) and Vercel. To guarantee perpetual zero-cost viability, the system's operational load was budgeted against free-tier quotas:

#styled-table(
  columns: (1.3in, 1.4in, 1.2in, 1fr),
  headers: ("Cloud Service", "Perpetual Free-Tier Limit", "FactStamp Daily Usage", "Operational Safety Headroom"),
  "Cloud Firestore (Database)", "50,000 document reads / day;\n20,000 document writes / day;\n1.0 GB persistent storage.", "~1,200 reads / day;\n~180 writes / day;\n~15.5 MB total data.", "*97.6% unused read headroom*;\n*99.1% unused write headroom*;\n*98.4% unused storage headroom*.",
  "Firebase Auth (Identity)", "Unlimited Email/Password;\n50,000 MAU for Google OAuth.", "~150 active verifiers;\n~300 registered users.", "*99.4% unused authentication quota*.",
  "Vercel Global Edge (Hosting)", "100 GB monthly bandwidth;\nUnlimited deployments;\nAutomatic TLS 1.3 edge cert.", "~4.2 GB / month\n(Aggressive browser\ncaching of bundles).", "*95.8% unused bandwidth headroom*."
)

*Headroom Analysis & Sustainability:*
- *Firestore Document Reads:* Because FactStamp uses Firestore's local-first IndexedDB persistence, redundant queries across navigating sessions hit client cache rather than the cloud database. Even during a 10#text[×] traffic spike (12,000 reads/day), the system consumes less than 25% of the free daily allocation.
- *Zero Compute Costs:* Because heavy compute tasks (OCR extraction and PNG card rasterization) execute in client browser threads, cloud compute billing is exactly *\$0.00*.
- *No Inactivity Pausing:* Unlike Supabase or cloud virtual machines that pause after 7 days of inactivity, Google Cloud Firestore remains permanently warm, guaranteeing instant response times for citizens submitting urgent breaking rumors.

#pagebreak()

== Preliminary Product Description

=== System Product Perspective
More than 535 million active users in India rely on WhatsApp for daily communication. While end-to-end encryption protects user privacy, it also creates an information asymmetry for fact verification:
1. *Opaque Propagation:* Rumors, unscientific medical cures, financial phishing schemes, and forged official notices circulate through closed group chats without public visibility.
2. *Asymmetric Viral Velocity:* Sensational forwards can reach millions of users across multiple states within hours, whereas traditional institutional fact checks take days to publish and rarely enter the private groups where the rumor originated.
3. *Cognitive Friction:* Traditional fact-checking portals require users to navigate dense, text-heavy editorial articles, which creates friction for mobile and non-technical citizens.

*Architectural Stance: External Verification Platform* \
FactStamp operates as an independent, serverless web platform that bridges private messaging networks and crowdsourced verification.

FactStamp does not intercept, inspect, or modify WhatsApp client software or network traffic. Attempting to inspect client traffic would violate encryption guarantees, compromise user device security, and breach terms of service. Instead, FactStamp operates strictly through *user-initiated interactions*:
1. A citizen receives a suspicious forwarded message or screenshot in WhatsApp.
2. The citizen shares the forward with FactStamp via standard mobile web browser ingestion (`/submit`).
3. Community verifiers collaboratively research and certify the claim through a multi-factor quorum consensus engine.
4. The system compiles the certified verdict into a shareable square PNG Fact Card.
5. The citizen downloads the Fact Card and forwards it directly back into the WhatsApp group chat where the rumor originated.

#v(8pt)
#figure(
  image("attachments/system_workflow.svg", width: 90%),
  caption: [FactStamp End-to-End Architectural Workflow & Civic Feedback Loop],
)
#v(6pt)

=== User Classes & Detailed Behavioral Personas
FactStamp defines three primary user classes based on their technical background, verification workflow, and authorization level:

#styled-table(
  columns: (1.3in, 1.3in, 1.4in, 1fr),
  headers: ("Persona Name", "Role & Demographic Profile", "Primary Motivation", "Core Pain Point & Platform Requirement"),
  "Rajesh Sharma (52)", "Public Submitter\nResident Welfare Assoc. Admin\nMumbai, India", "Protect family and residential chat groups from financial and medical scams.", "Finds text-heavy news articles difficult to navigate on mobile; requires frictionless one-tap forward ingestion and visual export.",
  "Priya Patel (21)", "Community Verifier\nB.Sc. IT Student / Volunteer\nChurchgate, Mumbai", "Build verifiable fact-checking civic reputation and contribute to social truth.", "Frustrated by lack of transparent tools for community debunking; requires structured verification queue and evidentiary citation tools.",
  "Prof. Vikram Mehta (38)", "Platform Administrator\nFaculty Advisor / Moderator\nAcademic Institution", "Ensure platform governance, audit contested claims, and monitor telemetry.", "Needs automated audit trails to neutralize coordinated Sybil attacks and partisan brigading; requires macro-level radar analytics."
)

#v(6pt)

*1. Persona 1: Rajesh Sharma (The WhatsApp Group Administrator)*
- *Demographic Context:* 52 years old, small business owner, administrator of a 150-member residential neighborhood WhatsApp group in Dadar, Mumbai. Uses a mid-range Android phone (Samsung Galaxy M14).
- *Behavioral Archetype:* Receives dozens of forwards daily claiming miraculous Ayurvedic cures, urgent banking ATM shutdowns, or municipal water supply cuts. He seeks to avoid sharing false claims but lacks specialized tools to verify complex forwards.
- *Platform Needs:*
  - _Zero-Friction Ingestion:_ Needs to paste forwarded text or upload a screenshot without creating accounts, remembering passwords, or filling complex forms.
  - _Unambiguous Visual Verdict:_ Requires a color-coded answer (e.g., bold red rubber-stamp badge marking *"FALSE"*).
  - _One-Click WhatsApp Export:_ Wants to download a visual card to post directly into his residential group to counter rumors.

*2. Persona 2: Priya Patel (The Student Civic Verifier)*
- *Demographic Context:* 21 years old, undergraduate Information Technology student at Jai Hind College. Digitally literate and familiar with online verification workflows.
- *Behavioral Archetype:* Regularly identifies obvious hoaxes in family groups. Regularly checks government portals (`pib.gov.in`, `rbi.org.in`, `who.int`) and public fact-checking repositories.
- *Platform Needs:*
  - _Real-Time Verification Queue:_ Needs an efficient dashboard filtering pending claims by category (`health`, `financial`, `political`, `religious`, `other`).
  - _Evidentiary Submission Tools:_ Structured input fields to attach authoritative citation URLs and concise rationale summaries ($>= 50$ characters, $>= 8$ words).
  - _Reputation Gamification:_ Transparent reputation tracking ($[0, 100]$) and leaderboard visibility for consensus-aligned verdicts (+2 reward).

*3. Persona 3: Prof. Vikram Mehta (The Platform Administrator)*
- *Demographic Context:* 38 years old, Assistant Professor in Computer Science and research advisor for the FactStamp project.
- *Behavioral Archetype:* Oversees system integrity, audits voting patterns for signs of coordinated Sybil brigading, reviews incident reports in `/reports`, and audits claims settling under `CONTESTED`.
- *Platform Needs:*
  - _Telemetry Dashboard:_ Real-time visualization of weekly claim volume surges, category distributions, and consensus conversion rates.
  - _Moderation Interface:_ Capability to inspect contested split-decision claims, flag claims for expedited queue priority (`adminFlagged: true`), and review immutable `/audit_logs`.

=== Operational Environment and Technical Constraints
1. *Zero-Budget Serverless Infrastructure:*
   FactStamp operates without departmental server budgets. Architectural choices comply strictly with perpetual free-tier allocations: Google Cloud Firestore (50k reads/20k writes daily), Vercel Global Edge Network, and client-side computation offloading.
2. *Browser Sandbox & Mobile Memory Budget:*
   Budget mobile devices in the target market typically have 2 GB to 4 GB of RAM. FactStamp applies strict client-side limits: canvas dimensions are constrained to $<= 1280 times 1280$px; dynamic JPEG quality stepping ($0.72$ down to $0.40$) keeps base64 payloads under 700 KB (string length $<= 800,000$ characters); and object URLs are revoked (`URL.revokeObjectURL`) after image decoding to free heap memory.
3. *WhatsApp Square 1:1 Aspect Ratio Mandate:*
   WhatsApp crops non-square images into centered square tiles in chat threads. In 16:9 or 4:3 cards, this crops out header verdict badges and footer source links. FactStamp enforces a 1:1 square aspect ratio ($1080 times 1080$px), ensuring that the verdict badge, summary, confidence score, and citation URLs remain visible in chat previews without requiring users to expand the image.
4. *Ergonomic Mobile Touch Targets:*
   Over 85% of submitters access FactStamp via mobile smartphones. All interactive elements enforce a minimum touch target dimension of *48×48 pixels*, complying strictly with Android Material Design Accessibility and Accessible Perceptual Contrast Algorithm (APCA) standards.

=== Assumptions and Dependencies
- *Network Connectivity:* Assumes users connect over variable mobile networks (2G, 3G, 4G, and 5G). The web interface uses local caching and optimistic UI updates to operate reliably during intermittent connectivity.
- *Modern Web Browser Standards Compliance:* Relies on standard capabilities natively supported across modern browsers (Chrome 100+, Firefox 105+, Safari 15.4+, Edge): ECMAScript 2022 Modules, WebAssembly, HTML5 Canvas 2D, SVG `<foreignObject>`, and CSS Custom Properties.
- *Third-Party Cloud Services Availability:* Relies on stable API availability from Google Firebase Services (Authentication, Firestore) and the Vercel Edge Platform.

=== Functional Scope Matrix & Product Boundary

#styled-table(
  columns: (1.3in, 1.4in, 1fr),
  headers: ("Capability Area", "In-Scope Core Features", "Explicit Out-of-Scope Anti-Features"),
  "Claim Ingestion", "Anonymous plaintext forward submission (10 to 2,000 chars); screenshot upload with client canvas downscale (< 700 KB) and automated Tesseract.js WASM OCR extraction.", "Automated crawling of private WhatsApp chats; interception of WhatsApp network traffic; phone number scraping.",
  "Duplicate Detection", "Lexical set-theoretic Jaccard similarity index ($J >= 0.75$, $|w| > 3$) redirecting client to canonical claim dossier.", "Deep semantic embedding transformers requiring GPU server clusters; arbitrary fuzzy regex matches.",
  "Quorum Verification", "Public queue; minimum quorum threshold $N >= 3$; authoritative citation mandate; explanation validation (50 to 1,500 chars); verifier reputation scoring ($[0, 100]$).", "Single-moderator unilateral censorship; unweighted democratic popular voting; anonymous verifier voting.",
  "Consensus Algorithm", "Tri-partite weighted scoring: $C = round(0.40A + 0.30R + 0.30S)$; automated 7-day contested timeout settling to CONTESTED.", "Proprietary black-box AI truth arbiters; manual score tampering; unverified source domain scoring.",
  "Visual Dissemination", "Square 1:1 ($1080 times 1080$px) PNG Fact Card generation via html-to-image with rubber-stamp verdict badge; direct WhatsApp share link.", "Automated WhatsApp spam bot broadcasting; automatic injection into third-party chat groups without user action.",
  "System Governance", "Administrative audit dashboard; priority claim flagging; Sybil anomaly detection; moderation incident reporting; immutable audit logging.", "Automated state surveillance interfaces; identity de-anonymization of anonymous submitters."
)

=== Summary of Product Feasibility
The product definition bounds FactStamp to a browser-based, serverless architecture that accepts user-forwarded claims, deduplicates inputs via lexical similarity, and resolves verdicts through weighted community consensus. By offloading OCR and fact-card rendering to client hardware, the platform operates within free-tier cloud quotas while producing verifiable artifacts that users can redistribute directly into messaging threads.

#pagebreak()

== Conceptual Models

=== Data Flow Diagrams (DFD)

*Foundations of Structured Data Flow Analysis:* \
Data Flow Diagrams (DFDs) provide a graphical representation of the progressive transformation of data through an information system. DFDs model transformational processes, data stores, external entities (terminators), and directional data flows. Within FactStamp, DFDs formalize how unverified WhatsApp rumors are ingested, sanitized, evaluated, and compiled into certified fact cards across three hierarchical levels of abstraction:
- *DFD Level 0 (Context Level):* Defines the absolute system boundary and environmental interfaces.
- *DFD Level 1 (System Decomposition):* Decomposes the platform into six major functional subsystems and core Firestore NoSQL data stores.
- *DFD Level 2 (Detailed Functional Decomposition):* Details low-level algorithmic operations within the Multimodal Ingestion Pipeline (Process 1.0) and Consensus Scoring Engine (Process 4.0).

#v(8pt)

*1. DFD Level 0: Context Level Diagram* \
The Context Level DFD encapsulates FactStamp as a single central process (`0.0 FactStamp Misinformation Verification System`) interacting with four primary environmental entities: Public Submitter (WhatsApp User), Community Verifier, Platform Administrator, and WhatsApp Chat Groups (Dark Social).

#v(8pt)
#figure(
  image("attachments/dfd_level_0.svg", width: 80%),
  caption: [FactStamp Context Level 0 Data Flow Diagram],
)
#v(6pt)

#styled-table(
  columns: (1.2in, 1.2in, 1.0in, 1fr),
  headers: ("External Entity", "Flow Label", "Direction", "Data Flow Payload Description"),
  "Public Submitter", "Submit Claim", "Inflow -> System", "Plaintext message string (10 to 2,000 chars) or screenshot image file (<= 5 MB).",
  "System", "Instant Verdict", "Outflow -> Submitter", "Immediate redirect to certified dossier if submission matches an existing duplicate (J >= 0.75).",
  "System", "Download Fact Card", "Outflow -> Submitter", "Standardized 1080x1080px PNG image displaying certified verdict, confidence, and source URLs.",
  "System", "Pending Queue Stream", "Outflow -> Verifier", "Stream of unverified claims requiring peer evaluation (verificationCount N < 3).",
  "Community Verifier", "Submit Verdict Vote", "Inflow -> System", "Structured vote (TRUE/FALSE/MISLEADING/UNVERIFIABLE) + HTTPS citation URL + rationale (>= 50 chars).",
  "System", "Update Reputation", "Outflow -> Verifier", "Adjusted civic reputation score (R in [0, 100]) updated upon consensus certification (+2 / -1).",
  "Platform Admin", "Moderation Directives", "Inflow -> System", "Priority flagging (adminFlagged), claim overrides, report resolutions, and audit queries.",
  "System", "Telemetry & Audits", "Outflow -> Admin", "Dynamic 7-day category submission radar, moderation incident reports, and immutable audit logs.",
  "Public Submitter", "Disseminate Fact Card", "Outflow -> WhatsApp", "User forwards downloaded Fact Card back into the origin group chat."
)

#v(10pt)

*2. DFD Level 1: System Level Diagram* \
The System Level DFD decomposes the monolithic verification process into six distinct operational subsystems:
1. *1.0 Ingestion & OCR Extraction:* Sanitizes plaintext and extracts text from screenshot images via canvas and OCR.
2. *2.0 Jaccard Duplicate Detection Engine:* Computes lexical similarity ($J >= 0.75$, $|w| > 3$) to intercept duplicate forward variants.
3. *3.0 Quorum Verification Queue Manager:* Coordinates community review, enforcing self-verification locks and collecting $N >= 3$ independent votes.
4. *4.0 Consensus & Confidence Engine:* Executes the multi-factor weighted scoring algorithm: $C = round(0.40A + 0.30R + 0.30S)$ and handles 7-day CONTESTED expiry.
5. *5.0 Fact-Check Card Generator:* Serializes DOM elements into high-DPI $1080 times 1080$px PNG image cards via `html-to-image`.
6. *6.0 Analytics & Governance Subsystem:* Aggregates 7-day category metrics, verifier leaderboards, moderation reports, and immutable audit logs.

#v(8pt)
#figure(
  image("attachments/dfd_level_1.svg", width: 90%),
  caption: [FactStamp System Level 1 Data Flow Diagram],
)
#v(6pt)

#styled-table(
  columns: (0.8in, 1.4in, 1.1in, 1fr),
  headers: ("Store ID", "Store Name", "Storage Technology", "Schema & Operational Contents"),
  "D1", "claims Collection", "Cloud Firestore", "Document records of all submitted claims: text, category, status, verificationCount, verifications array, verdict, confidenceScore.",
  "D2", "users Collection", "Cloud Firestore", "Verifier profiles: uid, displayName, email, reputation (0-100), totalVerifications, and isAdmin flag.",
  "D3", "notifications Collection", "Cloud Firestore", "Real-time user alerts: userId, type ('claim_verified', 'reputation_update', etc.), title, message, isRead.",
  "D4", "reports Collection", "Cloud Firestore", "Moderation incident reports: targetType ('claim', 'user', 'verification'), reason, severity, status, reportedBy.",
  "D5", "audit_logs Collection", "Cloud Firestore", "Immutable administrative audit ledger: adminId, action, targetType, targetId, details, timestamp."
)

#v(10pt)

*3. DFD Level 2: Detailed Functional Decomposition* \
DFD Level 2 decomposes Process 1.0 (Multimodal Ingestion Pipeline) into sub-processes 1.1 (Magic Byte Inspection), 1.2 (Canvas Downscaling), 1.3 (OCR Extraction), and 1.4 (Text Normalization & Tokenization); and decomposes Process 4.0 (Consensus Engine) into 4.1 (Quorum Validator $N >= 3$), 4.2 (Confidence Calculator), and 4.3 (Reputation & Verdict Finalizer).

#v(8pt)
#figure(
  image("attachments/dfd_level_2.svg", width: 90%),
  caption: [FactStamp Detailed Level 2 Functional Decomposition (Ingestion & Consensus)],
)
#v(6pt)

#styled-table(
  columns: (0.8in, 1.4in, 1.1in, 1fr),
  headers: ("Sub-Process", "Process Name", "Inputs", "Algorithmic Transformation & Logic"),
  "1.1", "Magic Byte Inspection", "Screenshot File", "Slices first 12 bytes; asserts valid JPEG (FF D8 FF), PNG (89 50 4E 47), GIF (47 49 46 38), or WebP (52 49 46 46).",
  "1.2", "Canvas Downscaling", "Validated Image Binary", "Scales dimensions to <= 1280px; quality steps (0.72 -> 0.40) until payload < 700 KB (string <= 800,000 chars).",
  "1.3", "OCR & Chat Cleaning", "Downscaled Bitmap", "Executes Tesseract.js WASM; cleanExtractedOcrText() strips WhatsApp chrome; detectClaimCategory() detects topic.",
  "1.4", "Text Normalization", "Raw Strings", "Strips null bytes and HTML; eliminates particles (|w| <= 3) and creates unique token set.",
  "4.1", "Quorum Validator", "claims.verifications", "Asserts verificationCount N >= 3; verifies verifierId != submittedBy and single vote per user.",
  "4.2", "Confidence Calculator", "claims.verifications", "Calculates A (majority agreement), R (mean reputation), S (source quality 100/70/30); computes C = round(0.40A + 0.30R + 0.30S).",
  "4.3", "Verdict Finalizer", "Composite Score C", "Sets status to 'verified'; stamps majority verdict; awards +2 points to majority verifiers, -1 to dissenters."
)

#v(6pt)

#styled-table(
  columns: (1.3in, 1.2in, 1.2in, 1fr),
  headers: ("Data Flow Name", "Source", "Destination", "Data Composition & Schema Structure"),
  "Forward Payload", "Public Submitter", "Process 1.0", "string text (10-2,000 chars) OR binary image file (<= 5 MB).",
  "Normalized Tokens", "Process 1.0", "Process 2.0", "Set<string> tokens; array of unique lowercase alphanumeric words (len > 3).",
  "Duplicate Check", "Process 2.0", "D1 claims", "findDuplicate(text, existingClaims, 0.75); scans in-memory cached claims.",
  "Verification Vote", "Community Verifier", "Process 3.0", "{ claimId, verdict, sourceUrl, sourceQuality, explanation (50 to 1,500 chars), verifierId, verifierReputation }.",
  "Consensus Update", "Process 4.0", "D1 claims", "{ status: 'verified', verdict: string, confidenceScore: int, verifiedAt: timestamp }.",
  "Fact Card PNG", "Process 5.0", "Public Submitter", "image/png binary stream (1080x1080 pixels, RGB 8-bit per channel)."
)

#pagebreak()

=== Use Case Diagram & Descriptions

*System Boundary and Actor Classifications:* \
FactStamp delineates four distinct actors participating in the verification ecosystem, comprising three human user classes and one automated background system actor:

#styled-table(
  columns: (1.2in, 1.0in, 1.2in, 1fr),
  headers: ("Actor Name", "Actor Type", "Authentication Required", "Operational Scope & Responsibilities"),
  "Public Submitter", "Human (Primary)", "No (Zero-friction anonymous)", "Receives viral WhatsApp forwards; submits text or screenshots for verification; views certified claim dossiers; downloads shareable 1080x1080px Fact Cards.",
  "Community Verifier", "Human (Primary)", "Yes (Firebase Auth JWT)", "Reviews pending verification queue; searches sovereign registries; casts structured verdicts with authoritative URLs and rationales; accumulates civic reputation (+2 / -1).",
  "Platform Administrator", "Human (Secondary)", "Yes (RBAC: isAdmin=true)", "Audits contested claims; flags urgent claims (adminFlagged); manages moderation reports; overrides verdicts; reviews immutable audit logs.",
  "Automated System Engine", "System / Background", "Internal Client / Rules", "Executes in-browser OCR; runs Jaccard duplicate detection; computes weighted consensus; handles 7-day expiration timeouts to CONTESTED."
)

#v(8pt)
#figure(
  image("attachments/use_case_diagram.svg", width: 90%),
  caption: [FactStamp Comprehensive UML Use Case Diagram],
)
#v(6pt)

*Exhaustive Formal Use Case Specifications (UC1 to UC10):*

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC1",
  "Use Case Name", "Submit WhatsApp Forward for Verification",
  "Primary Actor", "Public Submitter (Citizen / WhatsApp Recipient)",
  "Preconditions", "User has navigated to `/submit`. No account creation or authentication is required.",
  "Main Success Flow", [1. Submitter pastes text or uploads screenshot. 2. Selects category (`health`, `political`, `religious`, `financial`, `other`). 3. Clicks 'Verify Claim'. 4. System sanitizes input. 5. System invokes UC3 (Detect Duplicate). 6. If unique ($J < 0.75$), creates `/claims/{id}` with status `'pending'` and `verificationCount = 0`. 7. Displays tracking confirmation and enqueues claim.],
  "Alternative Flows", [2a. Screenshot Ingestion (UC2 `<<extend>>`): Canvas downscaling and OCR extraction populate editable text field. 5a. Duplicate Detected: $J >= 0.75$; system redirects client immediately to canonical certified Fact Dossier (`/claim/{id}`).],
  "Traceability", "IEEE Std 830 REQ-1 (Multimodal Forward Ingestion) & REQ-2 (Sanitization & Normalization)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC2",
  "Use Case Name", "Extract Screenshot Text via OCR Pipeline",
  "Primary Actor", "Automated System Engine (triggered by Public Submitter)",
  "Preconditions", "Image payload satisfies MIME whitelisting and magic byte header verification (JPEG, PNG, WebP, GIF).",
  "Main Success Flow", [1. Canvas downscaler resizes raw bitmap ($<= 1280$px, $< 700$ KB payload). 2. Dedicated Web Worker executes Tesseract.js WASM OCR. 3. `cleanExtractedOcrText()` strips WhatsApp chat chrome (timestamps, checkmarks, status lines). 4. `detectClaimCategory()` infers topic. 5. Returns editable string to submission form.],
  "Alternative Flows", [1a. Corrupt file or magic byte mismatch -> Rejects upload with error toast. 2a. Unreadable image -> Prompts manual entry.],
  "Traceability", "IEEE Std 830 REQ-2 (Client-Side WASM OCR Extraction)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC3",
  "Use Case Name", "Detect Duplicate Claim via Lexical Set Similarity",
  "Primary Actor", "Automated System Engine",
  "Preconditions", "Normalized text string with length $10 <= L <= 2,000$ characters is provided.",
  "Main Success Flow", [1. Decomposes text $A$ into token set, eliminating particles $|w| <= 3$. 2. Compares token set against cached claims via `findDuplicate()`. 3. Computes $J(A, B_k) = (|A inter B_k|) / (|A union B_k|)$. 4. If $max_k J(A, B_k) >= 0.75$, mounts duplicate banner and redirects client directly to canonical `/claim/{id}`.],
  "Alternative Flows", [4a. $J < 0.75$: Enqueues claim as novel submission in `/claims` with `status: 'pending'` and `verificationCount: 0`.],
  "Traceability", "IEEE Std 830 REQ-3 (Duplicate Detection & Suppression)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC4",
  "Use Case Name", "Browse Pending Quorum Verification Queue",
  "Primary Actor", "Community Verifier",
  "Preconditions", "User is logged in via authenticated session (Firebase Auth).",
  "Main Success Flow", [1. Verifier navigates to `/queue`. 2. System loads claims with `status: 'pending'` and `verificationCount < 3`. Admin-flagged claims surface first. 3. Verifier filters by category or search query. 4. Verifier selects claim to open Verification Dossier.],
  "Traceability", "IEEE Std 830 REQ-4 (Quorum Verification Queue)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC5",
  "Use Case Name", "Submit Verification Vote with Primary Citation and Rationale",
  "Primary Actor", "Community Verifier",
  "Preconditions", "Verifier is authenticated; Anti-Self-Verification lock holds (`claim.submittedBy != auth.uid`); verifier has not already voted on this claim.",
  "Main Success Flow", [1. Verifier selects verdict enum (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`). 2. Inputs HTTPS citation URL (auto-evaluated for source quality score: 100/70/30). 3. Inputs explanation rationale (50 to 1,500 chars, $>= 8$ words). 4. System validates explanation heuristics. 5. Appends verification to `claim.verifications` array. 6. Atomically increments `verificationCount`. 7. If `verificationCount >= 3`, triggers UC6.],
  "Alternative Flows", [4a. Self-verification lock violation -> Rejects with 403 Forbidden. 4b. Low-effort/spam explanation -> Rejects with validation prompt.],
  "Traceability", "IEEE Std 830 REQ-4 (Quorum-Based Peer Review) & REQ-5 (Domain Authority Scoring)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC6",
  "Use Case Name", "Calculate Weighted Quorum Consensus",
  "Primary Actor", "Automated System Engine",
  "Preconditions", "Claim has reached quorum threshold ($N >= 3$).",
  "Main Success Flow", [1. Retrieves all verification maps for claim. 2. Elects plurality majority verdict $V_"maj"$. 3. Computes Agreement Ratio: $A = (N_"majority" / N_"total") times 100$. 4. Computes mean verifier reputation $R = frac(1, N) sum R_i$. 5. Computes mean source quality $S = frac(1, N) sum S_i$. 6. Computes composite confidence: $C = round(0.40A + 0.30R + 0.30S)$. 7. Updates claim status to `'verified'` with verdict $V_"maj"$, stamped confidence score, and timestamp. 8. Awards $+2$ reputation points to majority verifiers, $-1$ to dissenters.],
  "Alternative Flows", [7a. 7-day timeout expiry with $N < 3$: `expireOverdueClaims()` marks claim status as `'verified'`, verdict as `'CONTESTED'`, and computes confidence from existing votes or defaults to 30.],
  "Traceability", "IEEE Std 830 REQ-5 (Weighted Consensus) & REQ-6 (Anti-Sybil Reputation)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC7",
  "Use Case Name", "Generate & Download 1080x1080px Fact Card",
  "Primary Actor", "Public Submitter / Community Verifier",
  "Preconditions", "Claim has reached certified `verified` status.",
  "Main Success Flow", [1. User clicks 'Download Fact Card'. 2. Client renders $1080 times 1080$px preview component. 3. Card displays rubber-stamp badge, confidence meter, quorum summary, and authoritative source tags. 4. Library `html-to-image` rasterizes SVG `<foreignObject>` to HTML5 canvas at `pixelRatio: 2`. 5. Initiates automated browser download: `factstamp-[claimId].png`.],
  "Traceability", "IEEE Std 830 REQ-7 (1080x1080px Fact Card Generator)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC8",
  "Use Case Name", "View Misinformation Dashboard & Weekly Radar Trends",
  "Primary Actor", "Public Submitter / Community Verifier / Platform Administrator",
  "Preconditions", "None (Publicly accessible route `/dashboard`).",
  "Main Success Flow", [1. User navigates to `/dashboard`. 2. System queries active claims and verifier profiles. 3. Interface renders 7-day rolling submission radar, category distributions across 5 categories, and verifier leaderboards via Recharts with Framer Motion animated counters.],
  "Traceability", "IEEE Std 830 REQ-8 (Misinformation Analytics Dashboard)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC9",
  "Use Case Name", "Audit Platform Moderation & Administer Overrides",
  "Primary Actor", "Platform Administrator",
  "Preconditions", "Authenticated session possessing `isAdmin == true` clearance in Firestore `/users/{uid}`.",
  "Main Success Flow", [1. Administrator navigates to `/admin`. 2. Inspects priority queue, contested claims, user reputation adjustments, and incident reports (`/reports`). 3. Flags claims for expedited review (`flagClaim`), performs verdict corrections (`adminUpdateClaim`), or deletes bad verifications (`deleteVerification`). 4. System records all actions into `/audit_logs`.],
  "Traceability", "IEEE Std 830 REQ-9 (RBAC) & REQ-6 (Anti-Sybil Defense)."
)

#v(6pt)

#styled-table(
  columns: (1.4in, 1fr),
  headers: ("Attribute", "Specification Details"),
  "Use Case ID", "UC10",
  "Use Case Name", "Manage Verifier Reputation & Sybil Defenses",
  "Primary Actor", "Automated System Engine / Platform Administrator",
  "Preconditions", "Consensus certification event completed or Sybil anomaly detected.",
  "Main Success Flow", [1. Engine updates verifier civic reputation ($R$) bounded in $[0, 100]$. 2. Awards $+2$ for consensus alignment; applies $-1$ penalty for dissent. 3. Bounded reputation ensures Sybil accounts cannot inflate scores without genuine consensus participation.],
  "Traceability", "IEEE Std 830 REQ-6 (Anti-Sybil Reputation Engine)."
)

#pagebreak()

=== Entity-Relationship (E-R) Model

*Core Domain Entities & Structural Roles:* \
The platform models six primary database collections in Cloud Firestore:
1. *USERS (`/users/{uid}`):* Represents authenticated community verifiers and administrators. Stores authentication identifiers (`uid`), display names (`displayName`), verified email, reputation score (`reputation` $in [0, 100]$, baseline 50), completed verifications counter (`totalVerifications`), registration timestamp (`joinedAt`), and administrative clearance flag (`isAdmin`).
2. *CLAIMS (`/claims/{claimId}`):* The central operational entity representing submitted WhatsApp forwards. Stores normalized forward text (`text`), category (`health`, `political`, `religious`, `financial`, `other`), lifecycle status (`status: 'pending' | 'verified'`), optional base64 screenshot (`imageUrl`, $\le 700$ KB), consensus deadline timestamp (`consensusDeadline`, 7 days), submitter information (`submittedBy`, `submittedByName`), certified verdict (`verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE' | 'CONTESTED'`), composite confidence score (`confidenceScore` $in [0, 100]$), agreement ratio (`agreementRatio`), average verifier reputation (`avgVerifierReputation`), source quality score (`sourceQualityScore`), embedded `verifications` array, verification count (`verificationCount`), and admin priority flags (`adminFlagged`, `adminFlaggedAt`).
3. *VERIFICATIONS (`embedded in /claims/{claimId}.verifications`):* Represents individual peer reviews. Stores `id`, `claimId`, `verdict`, `sourceUrl`, `sourceQuality` (`'high' | 'medium' | 'low'`), `explanation` (50 to 3,000 characters), `verifierId`, `verifierName`, `verifierReputation`, and `createdAt`.
4. *NOTIFICATIONS (`/notifications/{notificationId}`):* Represents real-time alerts dispatched to users. Stores `userId`, notification `type` (`'claim_verified' | 'reputation_update' | 'weekly_report' | 'verdict_submitted'`), `title`, `message`, `isRead` boolean, optional `claimId`, and `createdAt`.
5. *REPORTS (`/reports/{reportId}`):* Represents user-submitted moderation reports on abusive claims, users, or verifications. Stores `targetType` (`'claim' | 'user' | 'verification'`), `targetId`, `targetTitle`, `reason`, `details`, `reportedBy`, `reportedByName`, `status` (`'pending' | 'investigating' | 'resolved' | 'dismissed'`), `severity` (`'low' | 'medium' | 'high'`), and resolution metadata.
6. *AUDIT_LOGS (`/audit_logs/{logId}`):* Immutable administrative audit trail recording all privileged interventions. Stores `adminId`, `adminName`, `action`, `targetType` (`'claim' | 'user' | 'report' | 'system'`), `targetId`, `details`, and `timestamp`.

#v(8pt)
#figure(
  image("attachments/er_diagram.svg", width: 90%),
  caption: [FactStamp Logical Entity-Relationship (E-R) Diagram],
)
#v(6pt)

*Data Dictionaries & Logical Schema Specifications:*

#styled-table(
  columns: (1.0in, 0.8in, 0.5in, 0.6in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "uid", "String", "No", "PK", "None", "Firebase Auth UID (alphanumeric, 28 chars). Document Key.",
  "displayName", "String", "No", "None", "None", "Public verifier handle (max 100 chars; XSS-sanitized).",
  "email", "String", "No", "None", "None", "Verified email address matching auth token.",
  "avatarUrl", "String", "Yes", "None", "null", "Optional URL to verifier avatar image.",
  "reputation", "Integer", "No", "None", "50", "Trust score bounded strictly in [0, 100]; baseline 50.",
  "totalVerifications", "Integer", "No", "None", "0", "Monotonically increasing tally of valid reviews cast.",
  "isAdmin", "Boolean", "No", "None", "false", "Platform administrative privilege flag. Immutable by self.",
  "joinedAt", "String", "No", "None", "ISO string", "Account creation timestamp in UTC."
)

#v(6pt)

#styled-table(
  columns: (1.0in, 0.8in, 0.5in, 0.6in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Firestore document unique key. Document Primary Key.",
  "text", "String", "No", "None", "None", "Normalized forward text (10 to 2,000 characters).",
  "category", "String", "No", "None", "\"other\"", "Enum: 'health' | 'political' | 'religious' | 'financial' | 'other'.",
  "status", "String", "No", "None", "\"pending\"", "Lifecycle state: 'pending' | 'verified'.",
  "createdAt", "String", "No", "None", "ISO string", "Initial claim ingestion timestamp in UTC. Immutable.",
  "consensusDeadline", "String", "No", "None", "+7 days", "Consensus timeout timestamp (7 days from creation).",
  "verifiedAt", "String", "Yes", "None", "null", "Timestamp when consensus resolved or marked CONTESTED.",
  "submittedBy", "String", "No", "FK", "None", "UID of submitter. Used for anti-self-verification lock.",
  "submittedByName", "String", "No", "None", "None", "Display name of citizen submitter (max 100 chars).",
  "imageUrl", "String", "Yes", "None", "null", "Base64 JPEG screenshot (< 700 KB, string <= 800,000 chars).",
  "verdict", "String", "Yes", "None", "null", "Enum: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE' | 'CONTESTED'.",
  "confidenceScore", "Integer", "Yes", "None", "null", "Computed confidence score [0 to 100].",
  "verificationCount", "Integer", "No", "None", "0", "Count of registered peer reviews (N). Equal to verifications.length.",
  "verifications", "Array<Map>", "No", "None", "[]", "Embedded list of verification objects.",
  "agreementRatio", "Float", "Yes", "None", "null", "Percentage of verifiers agreeing with majority verdict [0 to 100].",
  "avgVerifierReputation", "Float", "Yes", "None", "null", "Mean reputation of participating verifiers [0 to 100].",
  "sourceQualityScore", "Float", "Yes", "None", "null", "Mean domain credibility rating [30 to 100].",
  "adminFlagged", "Boolean", "Yes", "None", "null", "Expedited review priority flag (admin-only mutable).",
  "adminFlaggedAt", "String", "Yes", "None", "null", "Timestamp when administrative priority flag was set."
)

#v(6pt)

#styled-table(
  columns: (1.0in, 0.8in, 0.5in, 0.6in, 1.2in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Verification unique identifier formatted as `v{timestamp}`.",
  "claimId", "String", "No", "FK", "None", "Foreign key referencing parent claim ID.",
  "verdict", "String", "No", "None", "None", "Voted verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE'.",
  "sourceUrl", "String", "No", "None", "None", "Valid HTTP/HTTPS citation URL (max 500 chars).",
  "sourceQuality", "String", "No", "None", "\"medium\"", "Domain classification: 'high' (100) | 'medium' (70) | 'low' (30).",
  "explanation", "String", "No", "None", "None", "Research rationale (50 to 3,000 characters; min 8 words).",
  "verifierId", "String", "No", "FK", "None", "UID of verifier. Must match request.auth.uid.",
  "verifierName", "String", "No", "None", "None", "Snapshot of verifier's display name at vote time.",
  "verifierReputation", "Integer", "No", "None", "50", "Snapshot of verifier's reputation score at vote time.",
  "createdAt", "String", "No", "None", "ISO string", "Verification submission timestamp in UTC."
)

#v(6pt)

#styled-table(
  columns: (1.1in, 0.8in, 0.5in, 0.6in, 1.1in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Notification unique identifier. Document Primary Key.",
  "userId", "String", "No", "FK", "None", "Recipient user UID (`users.uid`).",
  "type", "String", "No", "None", "None", "Enum: 'claim_verified' | 'reputation_update' | 'weekly_report' | 'verdict_submitted'.",
  "title", "String", "No", "None", "None", "Summary title of notification (max 200 chars).",
  "message", "String", "No", "None", "None", "Detailed notification message text (max 2,000 chars).",
  "isRead", "Boolean", "No", "None", "false", "Read status indicator.",
  "claimId", "String", "Yes", "FK", "null", "Optional foreign key pointing to referenced claim document.",
  "createdAt", "String", "No", "None", "ISO string", "Notification generation timestamp in UTC."
)

#v(6pt)

#styled-table(
  columns: (1.1in, 0.8in, 0.5in, 0.6in, 1.1in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Moderation report identifier. Document Primary Key.",
  "targetType", "String", "No", "None", "None", "Enum: 'claim' | 'user' | 'verification'.",
  "targetId", "String", "No", "None", "None", "Identifier of reported claim, user, or verification.",
  "targetTitle", "String", "No", "None", "None", "Summary title of reported entity (max 300 chars).",
  "reason", "String", "No", "None", "None", "Enum: 'misinformation_spam' | 'harassment' | 'low_quality_source' | 'fake_account' | 'manipulation' | 'hate_speech' | 'other'.",
  "status", "String", "No", "None", "\"pending\"", "Enum: 'pending' | 'investigating' | 'resolved' | 'dismissed'.",
  "severity", "String", "No", "None", "\"medium\"", "Enum: 'low' | 'medium' | 'high'.",
  "reportedBy", "String", "No", "FK", "None", "UID of reporting user. Must match request.auth.uid.",
  "reportedByName", "String", "No", "None", "None", "Display name of reporting user (max 100 chars).",
  "reportedAt", "String", "No", "None", "ISO string", "Timestamp when report was submitted in UTC."
)

#v(6pt)

#styled-table(
  columns: (1.1in, 0.8in, 0.5in, 0.6in, 1.1in, 1fr),
  headers: ("Field Name", "Data Type", "Null", "Key Type", "Default Value", "Business Constraints & Description"),
  "id", "String", "No", "PK", "Auto-ID", "Audit log document identifier. Document Primary Key.",
  "timestamp", "String", "No", "None", "ISO string", "Timestamp of action execution in UTC. Strictly immutable.",
  "adminId", "String", "No", "FK", "None", "UID of administrator who executed the action.",
  "adminName", "String", "No", "None", "None", "Display name of executing administrator (max 100 chars).",
  "action", "String", "No", "None", "None", "Action identifier string (max 200 chars).",
  "targetType", "String", "No", "None", "None", "Enum: 'claim' | 'user' | 'report' | 'system'.",
  "targetId", "String", "No", "None", "None", "Identifier of affected target document.",
  "details", "String", "No", "None", "None", "Mandatory operational explanation for audit review (max 2,000 chars)."
)

*Relationship Constraints & Integrity Rules:*
1. *One-to-Many Submission (`User` $arrow.r$ `Claim`, 0..N):* An individual user may submit zero or multiple claims. Unauthenticated submissions use `'u1'` / anonymous UID.
2. *One-to-Many Verification (`User` $arrow.r$ `Verification`, 0..N):* An authenticated verifier may review multiple claims over time.
3. *One-to-Many Quorum Composition (`Claim` $arrow.r$ `Verification`, 0..10):* A claim receives peer verification votes embedded directly inside its `verifications` array. Quorum threshold triggers at $N >= 3$.
4. *Anti-Self-Verification Integrity Rule:* A verifier is strictly prohibited from verifying a claim they submitted:
   $ "Verification.verifierId" != "Claim.submittedBy" $
   Enforced declaratively at the database boundary via Firestore security rules (`resource.data.submittedBy != request.auth.uid`).
5. *One-to-Many Notifications (`User` $arrow.r$ `AppNotification`, 0..N):* A user receives real-time alert documents scoped to their own UID.

#pagebreak()

=== Class Diagram

*Domain Classes & Class Specifications:* \
The Object-Oriented Class Model defines the software architecture, encapsulation boundaries, class contracts, and design patterns governing FactStamp's runtime execution:
1. *`User` (Domain Entity Interface):* Encapsulates `uid`, `displayName`, `email`, `reputation`, `totalVerifications`, `joinedAt`, `isAdmin`.
2. *`Claim` (Aggregate Root Entity Interface):* Encapsulates claim text, category, lifecycle status (`'pending' | 'verified'`), creation timestamp, consensus deadline, submitter information, optional screenshot URL (`imageUrl`), majority verdict, confidence score, embedded verifications array, verification count, agreement ratio, average verifier reputation, source quality score, and admin priority flags.
3. *`Verification` (Child Entity Interface):* Encapsulates `id`, `claimId`, `verdict`, `sourceUrl`, `sourceQuality` (`'high' | 'medium' | 'low'`), `explanation`, `verifierId`, `verifierName`, `verifierReputation`, and `createdAt`.
4. *`ConfidenceScoreResult` (Value Object Interface):* Encapsulates `score` ($C$), `agreementRatio` ($A$), `avgReputation` ($R$), and `sourceQualityScore` ($S$).
5. *`calculateConfidenceScore` (Domain Algorithm Function):* Pure function computing multi-factor confidence: $C = min(100, max(0, round(0.40 A + 0.30 R + 0.30 S)))$.
6. *`findDuplicate` (Domain Similarity Function):* Pure function performing string normalization, tokenization ($|w| > 3$), and pairwise Jaccard similarity evaluation ($J >= 0.75$).
7. *`FactCardGenerator` (Presentation Service Component):* Orchestrates client-side DOM-to-canvas rendering via `html-to-image` using browser-native SVG `<foreignObject>` rasterization, exporting square $1080 times 1080$px PNG image buffers.

#v(8pt)
#figure(
  image("attachments/class_diagram.svg", width: 90%),
  caption: [FactStamp Object-Oriented UML Class Diagram],
)
#v(6pt)

*Architectural Design Patterns Implemented:*
1. *Service Layer Pattern (Data Access Decoupling):* Database operations are decoupled from UI components into specialized services (`firebaseService.ts`, `ocrService.ts`). React components interact with pure business APIs without hardcoding Firestore internals.
2. *Pure Function Strategy (Algorithmic Determinism):* The consensus calculation (`confidenceScore.ts`) and duplicate detection (`duplicateDetection.ts`) algorithms are implemented as pure, side-effect-free TypeScript functions. This provides deterministic execution and complete unit-testability without mocking external databases.
3. *Observer Pattern (Real-Time Reactive Streaming):* Cloud Firestore's `onSnapshot` listener implements the Observer pattern at the transport layer, notifying subscribed client observers over WebSockets and reactively updating quorum progress bars across all active browser sessions.

#styled-table(
  columns: (1.3in, 1.2in, 1.2in, 1fr),
  headers: ("Class Linkage", "UML Relationship", "Multiplicity", "Behavioral Justification"),
  "`User` to `Claim`", "Association", "`1` to `0..*`", "A user creates claims over time; if a user deletes their profile, submitted public claims persist in the fact registry for civic continuity.",
  "`User` to `Verification`", "Association", "`1` to `0..*`", "A user authors multiple verification votes. Verifier reputation and name are captured snapshot-style.",
  "`Claim` to `Verification`", "Composition", "`1` to `0..10`", "Verifications are embedded directly in the parent claim document, guaranteeing single-read atomic hydration.",
  "`calculateConfidenceScore` to `Claim`", "Dependency (..>)", "Stateless Usage", "Consensus engine receives verification records, computes mathematical confidence score, and returns composite metrics.",
  "`findDuplicate` to `Claim`", "Dependency (..>)", "Stateless Usage", "Duplicate engine tokenizes incoming forward strings and computes pairwise Jaccard similarity against cached claims.",
  "`FactCardGenerator` to `Claim`", "Dependency (..>)", "Stateless Usage", "Fact Card generator reads certified claim attributes to rasterize a shareable 1080×1080px fact card."
)

#pagebreak()

=== Object Diagram

*Runtime Object Snapshot:* \
While the UML Class Diagram models static types and associations, the *UML Object Diagram* captures an instanced snapshot of objects in memory at a specific execution timestamp ($t = t_"snapshot"$). This illustrates concrete object collaborations, runtime attribute assignments, and state transitions during consensus resolution.

*Concrete Execution Scenario: Viral Banking Rumor Consensus:*
- *Submitted Viral Text:* _"Reserve Bank of India is closing all ATMs tonight from 12 AM due to urgent software upgrades. Withdraw cash now!"_
- *Submitter:* Rahul K. (`usr_9901`), an ordinary citizen submitting unverified content.
- *Duplicate Forward:* _"All bank ATMs will stop working from midnight today for system maintenance..."_ detected with Jaccard similarity $J = 0.84$.
- *Quorum Verifiers:* Three independent authenticated community fact-checkers:
  1. Priya Sharma (`usr_4021`, Reputation: 88) citing Press Information Bureau (`pib.gov.in`, High Quality: Score 100).
  2. Dr. Rajesh Iyer (`usr_8819`, Reputation: 94) citing official Reserve Bank of India notification (`rbi.org.in`, High Quality: Score 100).
  3. Ananya Desai (`usr_1204`, Reputation: 76) citing national news report (`thehindu.com`, Medium Quality: Score 70).
- *Consensus Outcome:* Unanimous FALSE verdict ($A = 100.0\%$), Average Reputation $R = 86.0$, Average Source Quality $S = 90.0$, Composite Confidence $C = 93\%$, certified fact card generated.

#v(8pt)
#figure(
  image("attachments/object_diagram.svg", width: 90%),
  caption: [FactStamp Runtime Instance UML Object Diagram (Active Consensus State)],
)
#v(6pt)

#styled-table(
  columns: (1.1in, 1.1in, 1.5in, 1fr),
  headers: ("Object Identifier", "Class Type", "Runtime Attribute Values", "Architectural Role & Function"),
  "submitter", "User", "uid: 'usr_9901'\ndisplayName: 'Rahul K.'\nreputation: 50\nisAdmin: false", "Initial submitter of the viral forward. Prohibited from casting verification votes.",
  "c1", "Claim", "id: 'c_seed_2'\ncategory: 'financial'\nstatus: 'verified'\nverdict: 'FALSE'\nconfidenceScore: 93\nverificationCount: 3", "Aggregate Root entity holding the validated claim state, consensus metrics, and embedded verifications.",
  "v1", "Verification", "id: 'v101'\nverifierId: 'usr_4021'\nverdict: 'FALSE'\nsourceQuality: 'high' (100)\nverifierReputation: 88", "First verification vote citing PIB Fact Check. High credibility government debunk.",
  "v2", "Verification", "id: 'v102'\nverifierId: 'usr_8819'\nverdict: 'FALSE'\nsourceQuality: 'high' (100)\nverifierReputation: 94", "Second verification vote citing official RBI press release. Highest authority institutional source.",
  "v3", "Verification", "id: 'v103'\nverifierId: 'usr_1204'\nverdict: 'FALSE'\nsourceQuality: 'medium' (70)\nverifierReputation: 76", "Third verification vote citing The Hindu. Reaches required quorum threshold (N=3).",
  "u1", "User", "uid: 'usr_4021'\ndisplayName: 'Priya Sharma'\nreputation: 88 -> 90\ntotalVerifications: 42", "Active verifier. Reputation incremented by +2 points following consensus certification.",
  "u2", "User", "uid: 'usr_8819'\ndisplayName: 'Dr. Rajesh Iyer'\nreputation: 94 -> 96\ntotalVerifications: 115", "Senior verifier. High track-record reputation provides heavy weighting in consensus formula.",
  "u3", "User", "uid: 'usr_1204'\ndisplayName: 'Ananya Desai'\nreputation: 76 -> 78\ntotalVerifications: 19", "Junior community verifier. Successful consensus alignment reinforces voter reputation (+2).",
  "res", "ConfidenceResult", "score: 93\nagreementRatio: 100.0\navgReputation: 86.0\nsourceQualityScore: 90.0", "Immutable calculation result returned by calculateConfidenceScore().",
  "card", "FactCardGenerator", "targetElement: '#fact-card'\nresolution: '1080x1080'\nformat: 'PNG'\npixelRatio: 2", "Presentation service converting certified claim DOM state into an exportable square fact card image."
)

#v(8pt)

*Mathematical Validation of Runtime Object State:*
1. *Agreement Ratio ($A$):* All three verifiers unanimously selected `FALSE`:
   $ A = (frac("Votes for Majority Verdict", "Total Quorum Votes")) times 100 = (frac(3, 3)) times 100 = bold(100.0\%) $
2. *Average Verifier Reputation ($R$):* Arithmetic mean of the three verifiers' reputation scores at vote time:
   $ R = frac(88 + 94 + 76, 3) = frac(258, 3) = bold(86.0) $
3. *Average Source Quality ($S$):* Arithmetic mean of numeric source quality scores ($100$ for `who.int`/`rbi.org.in`/`pib.gov.in`, $70$ for `thehindu.com`):
   $ S = frac(100 + 100 + 70, 3) = frac(270, 3) = bold(90.0) $
4. *Composite Confidence Score ($C$):*
   $ C = round(0.40 times A + 0.30 times R + 0.30 times S) = round(0.40(100.0) + 0.30(86.0) + 0.30(90.0)) $
   $ C = round(40.00 + 25.80 + 27.00) = round(92.80) = bold(93\%) $
   Because $C = 93\% >= 70\%$, the threshold is satisfied. The claim status updates to `'verified'`, stamped with a certified `FALSE` verdict and $93\%$ confidence meter.

#pagebreak()

=== System Event Table (EVT-01 to EVT-14)

*Foundations of the System Event Table:* \
The Event Table catalogues all external, temporal, and state triggers across the platform lifecycle, detailing their inputs, processing logic, and generated outputs:

#styled-table(
  columns: (0.95in, 0.90in, 0.85in, 1.30in, 1.10in, 0.80in),
  headers: ("Event Name", "Trigger", "Source", "Activity Performed", "Response Generated", "Destination"),
  // Group A: Ingestion & Submitter Events
  "EVT-01: Submit Plaintext Forward", "User pastes WhatsApp text and clicks 'Verify'", "Public Submitter (Browser)", "Strips null bytes and XSS tags, trims whitespace, validates length (10 to 2,000 chars), tokenizes words (|w| > 3).", "Displays processing indicator; initiates duplicate evaluation.", "Submit Page UI",
  "EVT-02: Upload Forward Screenshot", "User selects screenshot image file", "Public Submitter (Browser)", "Validates MIME/extension/magic bytes (<=5 MB); downscales canvas (<=1280px, <700 KB); triggers Tesseract.js OCR.", "cleanExtractedOcrText() cleans chrome; detectClaimCategory() infers topic.", "Submit Page UI",
  "EVT-03: Duplicate Claim Intercepted", "Pairwise Jaccard similarity index J >= 0.75", "Duplicate Detection Engine", "Halts new document creation; identifies canonical claim ID; increments local cache hit.", "Renders warning banner: 'Duplicate claim detected'; redirects to /claim/{id}.", "Claim Detail View",
  "EVT-04: Unique Claim Enqueued", "Jaccard similarity index J < 0.75 across all claims", "Duplicate Detection Engine", "Creates new Firestore document in /claims with status='pending', verificationCount=0, verifications=[].", "Displays submission confirmation toast; transitions claim to public review queue.", "Verify Queue UI",
  // Group B: Community Verification & Consensus Events
  "EVT-05: Browse Pending Queue", "Verifier navigates to '/queue' route", "Community Verifier", "Queries Firestore for claims where status='pending' and verificationCount < 3, ordered by createdAt desc.", "Renders reactive list of pending forward cards with category badges.", "Verify Queue Page",
  "EVT-06: Submit Claim Verification", "Verifier selects verdict enum, provides URL and explanation", "Community Verifier", "Validates HTTPS URL; evaluates source quality (S: 100/70/30); validates explanation heuristics; writes to verifications array.", "Increments verificationCount by +1; appends vote object to claim.", "Verify Detail View",
  "EVT-07: Quorum Attained (N >= 3)", "Third independent verification recorded", "ClaimsContext / Rules", "Detects updatedVerifications.length >= 3; invokes calculateConfidenceScore().", "Transitions claim status to 'verified'; stamps majority verdict.", "Consensus Engine",
  "EVT-08: Compute Consensus Score", "Quorum threshold achieved (N >= 3)", "Consensus Calculator", "Computes modal verdict, agreement ratio (A), mean reputation (R), mean source quality (S); calculates C.", "Writes verdict, confidence %, and verifiedAt; updates verifier reputations (+2 / -1).", "Firestore claims Store",
  // Group C: Post-Verification, Analytics & Temporal Events
  "EVT-09: Export Fact Card PNG", "User clicks 'Download Fact Card' button", "Public Submitter / Verifier", "Clones DOM preview node, serializes SVG <foreignObject>, renders 1080x1080px canvas at pixelRatio: 2.", "Triggers browser PNG download buffer ('factstamp-[id].png').", "Local Client Device",
  "EVT-10: Refresh Analytics Dashboard", "User accesses '/dashboard' view", "Public Citizen / Verifier", "Queries active claims and user profiles; dynamically computes 7-day category breakdowns and leaderboards.", "Renders category distribution charts and verifier accuracy ranking tables.", "Dashboard View",
  "EVT-11: Consensus Deadline Expiry", "Claim age exceeds 7 days with verificationCount < 3", "expireOverdueClaims() Worker", "Scans overdue pending claims; resolves status to 'verified' with verdict='CONTESTED'.", "Updates claim in Firestore; logs notification to submitter.", "Public Registry",
  // Group D: Security, Governance & Abuse Prevention Events
  "EVT-12: Blocked Self-Verification", "Submitter attempts to verify their own submitted claim", "Client Guard & Firestore Rules", "Compares auth.uid with claim.submittedBy; aborts operation with permission-denied error code.", "Displays security warning toast: 'Self-verification strictly prohibited'.", "Client Toast UI",
  "EVT-13: File Upload Rejection", "Uploaded file fails MIME, extension, or magic byte check", "Security Middleware", "Aborts file processing; refuses canvas allocation; prevents memory buffer overflow.", "Displays error toast: 'Corrupt or disguised file rejected by security gate'.", "Submit Form UI",
  "EVT-14: Authentication Throttling", "User exceeds 5 consecutive failed login attempts", "checkLoginRateLimit()", "Enforces 15-minute lockout timer; renders MM:SS countdown display; disables submit button.", "Blocks authentication API requests until lockout timer elapses.", "SignIn Page UI"
)

#v(8pt)

*Architectural Event Chain Case Studies:*
- *Case Study 1: Claim Ingestion & Duplicate Suppression Event Chain:*
  When a citizen receives a viral WhatsApp rumor and submits it to FactStamp: (1) EVT-01 or EVT-02 Trigger initializes input; (2) EVT-13 Security Gate validates magic bytes and sanitizes payload; (3) Jaccard Engine computes $J(A, B) = (|A inter B|) / (|A union B|)$ on tokens $|w| > 3$; (4) If $J >= 0.75$ (EVT-03), halts document creation, mounts duplicate warning banner, and redirects user to existing dossier (`/claim/{id}`); if $J < 0.75$ (EVT-04), commits new claim to `/claims` with `status: 'pending'` and `verificationCount: 0`.
- *Case Study 2: Quorum Review & Consensus Resolution Event Chain:*
  (1) EVT-05 Trigger allows verifier to inspect queue; (2) EVT-12 validates `verifierId != claim.submittedBy`; (3) EVT-06 validates explanation heuristics (50 to 1,500 chars, min 8 words), appends verification, and increments `verificationCount`; (4) When $N = 3$ (EVT-07), triggers consensus engine; (5) EVT-08 executes $C = round(0.40A + 0.30R + 0.30S)$, sets status to `'verified'`, stamps majority verdict, awards $+2$ reputation points to agreeing verifiers and $-1$ to dissenters.

#pagebreak()

=== Activity Diagram

*Swimlane Architecture & Role Segregation:* \
The FactStamp activity model partitions activities across five specialized swimlanes:
1. *Public Submitter:* Represents citizen interactions (encountering rumors, submitting text/images, downloading fact cards).
2. *Ingestion & OCR Gateway:* Executes client-side validation, binary magic byte inspection, offscreen canvas downscaling, and OCR transcription.
3. *Duplicate Engine & DB:* Calculates lexical Jaccard similarity ($J$, $|w| > 3$), manages document persistence, and indexes the verification queue.
4. *Community Verifier Network:* Encapsulates authenticated peer review, primary source investigation, and structured vote casting.
5. *Consensus & Export Engine:* Executes the tri-partite weighted confidence scoring algorithm and renders high-DPI Fact Cards.

#v(8pt)
#figure(
  image("attachments/activity_diagram.svg", width: 85%),
  caption: [FactStamp End-to-End UML Activity Diagram & Workflow Control Flow],
)
#v(6pt)

*Step-by-Step Control Flow & Decision Branches:*
1. *Encounter & Navigation:* A user encounters a viral chain message or screenshot in WhatsApp and navigates to `/submit`.
2. *Media Format Branching:*
   - *Screenshot Pathway:* Upload triggers binary magic byte verification (`0xFFD8FF` for JPEG, `0x89504E47` for PNG, `0x47494638` for GIF, `0x52494646` for WebP). The image is downscaled to $<= 1280$px on an offscreen HTML5 canvas, compressed under 700 KB via dynamic quality stepping, and passed to the Tesseract.js WASM worker. `cleanExtractedOcrText()` strips WhatsApp chrome, and `detectClaimCategory()` infers the category.
   - *Plaintext Pathway:* Raw text is filtered through regex sanitizers to eliminate script injection, control characters, and null bytes (`\0`), followed by whitespace normalization.
3. *Similarity Evaluation Branching:*
   - The tokenized text set $A$ is compared against all existing cached claims $B_k$ using the Jaccard similarity metric: $J(A, B_k) = (|A inter B_k|) / (|A union B_k|)$.
   - *Branch A ($J >= 0.75$):* The forward is identified as a duplicate variant. The user is immediately redirected to the canonical claim dossier (`/claim/{id}`) to view the existing Fact Card. Execution terminates with zero database writes.
   - *Branch B ($J < 0.75$):* The submission is classified as a novel claim, persisted to Firestore `/claims` with `status: 'pending'` and initial `verificationCount: 0`, and enqueued in `/queue`.
4. *Concurrent Peer Review Loop:*
   - Authenticated verifiers inspect pending claims and research authoritative sovereign sources (`pib.gov.in`, `rbi.org.in`, `who.int`).
   - Verifiers select a verdict (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`), attach a primary HTTPS URL, and submit an explanation rationale (50 to 1,500 characters, $>= 8$ words).
   - System validates security assertions: Anti-Self-Verification lock (`claim.submittedBy != auth.uid`) and Single-Vote-Per-Claim rule.
   - The system appends the verification object to `claim.verifications` and atomically increments `claim.verificationCount`. The review loop repeats until `verificationCount >= 3`.
5. *Consensus Evaluation & Dissemination:*
   - Once $N >= 3$, the engine triggers the tri-partite weighted consensus algorithm: $C = round(0.40 A + 0.30 R + 0.30 S)$.
   - *Consensus Confirmed ($N >= 3$):* Claim status transitions to `'verified'` with majority verdict $V_"maj"$. Participating verifiers receive $+2$ reputation points for agreeing with the majority verdict and $-1$ point for dissenting. The system enables $1080 times 1080$px Fact Card PNG rasterization. The citizen downloads and shares it back to WhatsApp.
   - *Deadline Expiry ($N < 3$ after 7 days):* Overdue claims transition to `status: 'verified'` with `verdict: 'CONTESTED'` via `expireOverdueClaims()`.

#pagebreak()

=== State Machine Diagram

*Claim Lifecycle State Machine:* \
The formal UML State Machine Diagram specifies the operational states, hierarchical nested states, and transition guards governing a claim from ingestion to final resolution:

#v(8pt)
#figure(
  image("attachments/state_diagram.svg", width: 85%),
  caption: [FactStamp Claim Lifecycle UML State Machine Diagram],
)
#v(6pt)

#styled-table(
  columns: (1.1in, 1.0in, 1.2in, 1.1in, 1fr),
  headers: ("Source State", "Event / Trigger", "Guard Condition", "Target State", "Action / Execution Routine"),
  "[*]", "Submit Forward", "Input valid", "PENDING_INTAKE", "Sanitize input; assign unique tracking ID.",
  "PENDING_INTAKE", "Upload Screenshot", "Magic byte verified", "PENDING_INTAKE (OCR)", "Canvas downscaling; extract WASM OCR text.",
  "PENDING_INTAKE", "Jaccard Check", "J >= 0.75", "DUPLICATE_MATCHED", "Halt write; redirect client to canonical claim dossier.",
  "PENDING_INTAKE", "Jaccard Check", "J < 0.75", "PENDING_REVIEW", "Write claim to Firestore /claims (status: 'pending', count: 0).",
  "PENDING_REVIEW", "Submit Vote", "N < 3 and auth.uid != author", "PENDING_REVIEW", "Append verification map; atomically increment verificationCount.",
  "PENDING_REVIEW", "Submit Vote", "N == 3 and auth.uid != author", "EVALUATING_QUORUM", "Trigger multi-factor weighted consensus engine.",
  "PENDING_REVIEW", "Timer Expiry", "t >= t_created + 7 days, N < 3", "VERIFIED_CONTESTED", "Auto-settle status='verified', verdict='CONTESTED'.",
  "EVALUATING_QUORUM", "Consensus Calc", "Majority TRUE", "VERIFIED_TRUE", "Stamp certified TRUE verdict; award reputation (+2 / -1).",
  "EVALUATING_QUORUM", "Consensus Calc", "Majority FALSE", "VERIFIED_FALSE", "Stamp certified FALSE verdict; award reputation (+2 / -1).",
  "EVALUATING_QUORUM", "Consensus Calc", "Majority MISLEADING", "VERIFIED_MISLEADING", "Stamp certified MISLEADING verdict; award reputation (+2 / -1).",
  "EVALUATING_QUORUM", "Consensus Calc", "Majority UNVERIFIABLE", "VERIFIED_UNVERIFIABLE", "Stamp certified UNVERIFIABLE verdict; award reputation (+2 / -1).",
  "VERIFIED_*", "Generate Card", "status == 'verified'", "FACT_CARD_READY", "html-to-image canvas serialization (1080x1080px PNG)."
)

*State Invariants & Terminal Conditions:*
1. *Pending Review Invariant:* While in `PENDING_REVIEW`, no claim may have `verificationCount >= 3` without immediately executing consensus calculation and transitioning to `VERIFIED_*`.
2. *Anti-Self-Verification Invariant:* The transition `PENDING_REVIEW -> PENDING_REVIEW` is guarded by $["auth.uid" != "claim.submittedBy"]$.
3. *Immutability Invariant:* Once a claim enters `VERIFIED_*`, claim identity fields (`text`, `category`, `submittedBy`, `createdAt`, `consensusDeadline`) remain strictly immutable via `firestore.rules`.

*Verifier Civic Reputation State Machine:*
In addition to the Claim lifecycle, FactStamp models the operational standing of human verifiers using a secondary state machine:
- *Novice Verifier ($R = 50$, Baseline):* Initial baseline assigned to new accounts upon registration.
- *Established Verifier ($51 <= R <= 80$):* Earned by consistent consensus alignment.
- *Trusted Senior Verifier ($R > 80$):* High-accuracy track record. Carries maximum weight in consensus calculations.
- *Probationary Review ($30 <= R < 50$):* Resulting from frequent dissenting or unsubstantiated votes.
- *Suspended / Sybil Neutralized ($R < 30$):* Voting influence severely attenuated ($R times 30\%$).
- *Reputation Dynamics:* Majority alignment: $+2$ points ($R_{t+1} = min(100, R_t + 2)$); dissent penalty: $-1$ point ($R_{t+1} = max(0, R_t - 1)$); bounded strictly in $[0, 100]$.

#pagebreak()

=== Sequence Diagrams

*1. Sequence 1: Claim Ingestion & Duplicate Resolution* \
Traces user submission, file validation, OCR extraction, Jaccard similarity evaluation, and duplicate redirection across five architectural lifelines: Public Submitter, Browser Client, OCR Pipeline, Duplicate Engine, and Cloud Firestore.

#v(8pt)
#figure(
  image("attachments/sequence_diagram_submission.svg", width: 90%),
  caption: [FactStamp Claim Ingestion & Duplicate Resolution UML Sequence Diagram],
)
#v(6pt)

#styled-table(
  columns: (0.7in, 1.2in, 1.2in, 1fr),
  headers: ("Step", "Sender Lifeline", "Receiver Lifeline", "Message Signature & Execution Description"),
  "1", "Public Submitter", "Browser Client", "Submit Forward (text string or screenshot File object).",
  "2", "Browser Client", "Browser Client", "Validate Magic Bytes: Slices first 12 bytes to confirm genuine JPEG, PNG, GIF, or WebP header.",
  "3", "Browser Client", "Browser Client", "Downscale Canvas: Resizes image to <= 1280px; applies quality stepping until payload < 700 KB.",
  "4-5", "Browser Client", "OCR Pipeline", "Request OCR extraction; Tesseract.js WASM returns text; cleanExtractedOcrText() strips chat chrome.",
  "6", "Browser Client", "Duplicate Engine", "findDuplicate(text, cachedClaims, 0.75); executes normalization & tokenization (|w| > 3).",
  "7-8", "Duplicate Engine", "Duplicate Engine", "Computes Jaccard Similarity J = |A ∩ B| / |A ∪ B| against all existing candidate claims.",
  "9a-11a", "Duplicate Engine", "Browser Client", "Duplicate Match (J >= 0.75): Mounts duplicate banner; redirects user directly to existing /claim/{id}.",
  "9b-11b", "Duplicate Engine", "Cloud Firestore", "Unique Claim (J < 0.75): Writes new claim to /claims (status: 'pending', count: 0); returns tracking ID."
)

*Exception Handling:* If magic byte validation fails (e.g., disguised executable payload), upload aborts immediately at Step 2. If OCR extraction yields an empty string, the UI prompts manual entry before submission.

#v(10pt)

*2. Sequence 2: Quorum Peer Review & Weighted Consensus Finalization* \
Traces verifier authentication, self-verification locks, transactional vote persistence, quorum evaluation, confidence scoring, and fact card generation across six architectural lifelines: Community Verifier, Web Dashboard, Auth Guard, Claims Service, Cloud Firestore, and Fact Card Generator.

#v(8pt)
#figure(
  image("attachments/sequence_diagram_consensus.svg", width: 90%),
  caption: [FactStamp Quorum Verification & Weighted Consensus UML Sequence Diagram],
)
#v(6pt)

#styled-table(
  columns: (0.7in, 1.2in, 1.2in, 1fr),
  headers: ("Step", "Sender Lifeline", "Receiver Lifeline", "Message Signature & Execution Description"),
  "1-3", "Community Verifier", "Cloud Firestore", "Verifier selects pending claim; UI subscribes to real-time onSnapshot listener.",
  "4-6", "Community Verifier", "Auth Guard", "Verifier selects verdict, inputs HTTPS URL and rationale; client acquires RS256 JWT token.",
  "7-8", "Web Dashboard", "Claims Service", "addVerification(claimId, data); verifies verifierId != claim.submittedBy and single vote check.",
  "9-10", "Claims Service", "Cloud Firestore", "Appends verification object to claims/{claimId}.verifications and increments verificationCount.",
  "11-13", "Claims Service", "Claims Service", "Quorum Check (N >= 3): Triggers calculateConfidenceScore(); computes A (40%), R (30%), S (30%).",
  "14-16", "Claims Service", "Cloud Firestore", "Consensus Confirmed: Updates claim to status: 'verified', stamps verdict & confidence %, updates reputations (+2 / -1).",
  "17-18", "Web Dashboard", "Fact Card Gen", "Generates Fact Card: Serializes DOM via html-to-image; rasterizes 1080x1080px PNG download."
)

#pagebreak()

=== Package Diagram

*Subsystem Layering & Dependency Hierarchy:* \
FactStamp enforces a five-tier unidirectional package hierarchy adhering to the *Acyclic Dependencies Principle (ADP)*:
1. *Presentation Layer (`src/pages/`, `src/components/`):* Houses React view components, client-side route controllers, touch ergonomics, and modal dialogs.
2. *Contexts & State Management (`src/contexts/`):* Coordinates reactive client state (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`).
3. *Application Services Layer (`src/services/`):* Coordinates end-to-end business workflows, orchestrating between domain entities and cloud persistence adapters (`firebaseService.ts`, `ocrService.ts`).
4. *Domain Core & Business Logic (`src/lib/`):* Encapsulates pure domain models (`types.ts`), lexical set algorithms (`duplicateDetection.ts`), mathematical consensus formulas (`confidenceScore.ts`), and security hardening (`security.ts`).
5. *Cloud Infrastructure Layer:* Google Cloud Firestore, Firebase Authentication, and client-side WebAssembly runtime.

#v(8pt)
#figure(
  image("attachments/package_diagram.svg", width: 85%),
  caption: [FactStamp Modular Subsystem Package Architecture Diagram],
)
#v(6pt)

#styled-table(
  columns: (1.3in, 1.4in, 1.3in, 1fr),
  headers: ("Package Name", "Contained Components", "Layer Visibility", "Primary Engineering Responsibility"),
  "Presentation Layer", "Home, Submit, VerifyQueue, VerifyDetail, ClaimDetail, Admin, Dashboard", "Public / Client", "Renders responsive UI; captures user touch inputs; executes in-browser canvas downscaling.",
  "Contexts Layer", "AuthContext, ClaimsContext, NotificationsContext, ThemeContext", "Application State", "Maintains reactive state; manages real-time Firestore listeners; triggers consensus calculations.",
  "Services Layer", "firebaseService.ts, ocrService.ts", "Service API", "Coordinates Firestore queries, authentication workflows, admin operations, and Tesseract.js OCR.",
  "Domain Core", "types.ts, confidenceScore.ts, duplicateDetection.ts, security.ts", "Domain Internal", "Defines TypeScript interfaces; executes mathematical formulas, Jaccard similarity, and security validations.",
  "Infrastructure", "Cloud Firestore, Firebase Auth, WebAssembly", "External Boundary", "Provides multi-region NoSQL persistence, RS256 JWT auth, and client-side WASM execution."
)

*Architectural Coupling & Modularity Metrics:*
- *Acyclic Dependencies Principle (ADP):* There are zero cyclic dependencies between packages. Dependencies flow strictly downwards: Presentation -> Contexts -> Services -> Domain Core -> Infrastructure.
- *Stable Abstractions Principle (SAP):* Core domain modules (`confidenceScore.ts` and `duplicateDetection.ts`) possess zero external framework dependencies, allowing direct unit-testing with standard runners.

#pagebreak()

=== Deployment Diagram

*Physical Infrastructure Tiers:* \
FactStamp is deployed across five physical hardware and cloud environments:
1. *Client Hardware Tier:* Heterogeneous mobile smartphones (Android/iOS) and desktop workstations running modern web browsers (Chrome 100+, Safari 15.4+). Executes client-side image downscaling and in-browser optical character recognition via a WebAssembly worker (Tesseract.js).
2. *Edge CDN Infrastructure Tier:* Vercel's global Anycast Edge Network providing Anycast DNS, TLS 1.3 termination, and distributed static asset caching.
3. *Single-Page Application Runtime:* High-performance Vite bundle delivering optimized ES modules, React Concurrent Mode UI, and IndexedDB client caching.
4. *Managed Cloud Database Tier:* Google Cloud Platform (Mumbai Region `asia-south1`) hosting Cloud Firestore NoSQL collections and the Firebase Security Rules engine.
5. *External Sovereign Services Tier:* Authoritative sovereign registries (`pib.gov.in`, `rbi.org.in`, `who.int`) cited as primary fact-checking evidence.

#v(8pt)
#figure(
  image("attachments/deployment_diagram.svg", width: 85%),
  caption: [FactStamp Physical Cloud Deployment Topology & Infrastructure Diagram],
)
#v(6pt)

#styled-table(
  columns: (1.2in, 1.2in, 1.1in, 1fr),
  headers: ("Deployment Node", "Hardware / Cloud Host", "Protocols Supported", "Deployed Software Artifacts & Boundaries"),
  "Client Device Tier", "Consumer Mobile / Desktop (2GB - 16GB RAM)", "HTTPS, WSS, WebAssembly", "Web Browser DOM, React SPA Bundle, HTML5 Offscreen Canvas, WebAssembly OCR Worker (Tesseract.js).",
  "Edge CDN Tier", "Vercel Global Anycast Edge Network", "HTTP/2, HTTP/3, TLS 1.3", "Anycast DNS routing, static asset edge caches, DDoS mitigation, gzip/brotli compression.",
  "Client Application", "Client Browser Execution Context", "JavaScript, ES Modules", "React 18.3, Tailwind v4 runtime, Lucide React, Recharts, html-to-image DOM exporter.",
  "Cloud Database Tier", "Google Cloud Platform (asia-south1 Mumbai)", "gRPC over TLS, WebSocket", "Cloud Firestore NoSQL collections, Firebase Auth engine, declarative firestore.rules.",
  "External Sovereign Tier", "Sovereign Government / Institutional Hosts", "HTTPS Web Portals", "Authoritative portals (pib.gov.in, rbi.org.in, who.int) evaluated by domain authority lookup."
)

*Zero-Trust Network Boundaries & Transport Security:*
1. *TLS 1.3 Cryptographic Enforcement:* All transport channels mandate TLS 1.3 encryption.
2. *Stateless Authentication:* Inter-tier communication utilizes cryptographically verified RS256 JWT tokens issued by Firebase Auth, verified at the Firestore security rules engine.
3. *Regional Proximity:* Cloud database clusters are provisioned within the Mumbai region (`asia-south1`), keeping round-trip database latencies under 35 milliseconds for domestic users.

#pagebreak()

=== Component Diagram & Interface Contracts

FactStamp is structured into nine functional components connected through standardized interface conventions:

#v(8pt)
#figure(
  image("attachments/component_diagram.svg", width: 85%),
  caption: [FactStamp Software Component Architecture & Interface Topology Diagram],
)
#v(6pt)

#styled-table(
  columns: (1.3in, 1.2in, 1.2in, 1fr),
  headers: ("Component Name", "Provided Interface", "Required Interface", "Component Role & Functional Scope"),
  "Web Presentation", "None (Top UI)", "IClaimSubmit, IAuth, IQueue, IExport", "React client rendering submission forms, review queues, fact cards, and analytical charts.",
  "Ingestion Gateway", "IClaimSubmit", "IOCRService, IDedupCheck", "Executes magic byte inspection, offscreen canvas downscaling (< 700 KB), and text sanitization.",
  "OCR Service", "IOCRService", "None (Wasm Engine)", "Executes client-side WebAssembly OCR (Tesseract.js) to convert screenshot bitmaps into machine-readable text without cloud APIs.",
  "Duplicate Engine", "IDedupCheck", "None (In-Memory)", "Tokenizes text, filters stop particles (|w| > 3), and evaluates Jaccard set similarity (J >= 0.75).",
  "Quorum Queue", "IVerifyQueue", "IConsensusEval, IFirestoreStorage", "Manages pending claims queue; validates self-verification locks and triggers consensus at N >= 3.",
  "Consensus Engine", "IConsensusEval", "IFirestoreStorage", "Executes the tri-partite weighted formula C = round(0.40A + 0.30R + 0.30S); updates reputations (+2 / -1).",
  "Fact Card Gen", "IFactCardExport", "None (DOM Engine)", "Serializes DOM nodes into high-DPI 1080x1080px PNG Fact Cards via html-to-image.",
  "Auth Service", "IAuthService", "None (OIDC Provider)", "Manages user login, session token validation, rate limiting (5 attempts/15m), and RS256 JWT claims.",
  "Firestore Service", "IFirestoreStorage", "None (GCP Client)", "Executes atomic NoSQL reads, writes, transactions, and real-time document snapshot listeners."
)

#v(8pt)

*Formal Interface Definitions & Method Contracts in TypeScript:*

```typescript
// 1. Ingestion & Submission Interface Contract
export interface IClaimSubmit {
  addClaim(data: {
    text: string;
    category: 'health' | 'political' | 'religious' | 'financial' | 'other';
    submittedBy: string;
    submittedByName: string;
    imageUrl?: string;
  }): Promise<Claim>;
}

// 2. Optical Character Recognition (OCR) Interface Contract
export interface IOCRService {
  cleanExtractedOcrText(raw: string): string;
  detectClaimCategory(text: string): ClaimCategory;
}

// 3. Duplicate Detection Interface Contract
export interface IDedupCheck {
  findDuplicate(
    text: string,
    existingClaims: Array<{ id: string; text: string }>,
    threshold?: number
  ): { id: string; text: string; similarity: number } | null;
}

// 4. Verification Queue & Review Interface Contract
export interface IVerifyQueue {
  addVerification(
    claimId: string,
    data: {
      verdict: 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE';
      sourceUrl: string;
      explanation: string;
      verifierId: string;
      verifierName: string;
      verifierReputation: number;
    }
  ): void;
}

// 5. Consensus Scoring Engine Interface Contract
export interface IConsensusEval {
  calculateConfidenceScore(
    verifications: Array<{
      verdict: string;
      verifierReputation: number;
      sourceQuality: number; // scale: 0 to 100 (100, 70, 30)
    }>
  ): {
    score: number;
    agreementRatio: number;
    avgReputation: number;
    sourceQualityScore: number;
  };
}

// 6. Fact Card Export Interface Contract
export interface IFactCardExport {
  generateCardPNG(
    element: HTMLElement,
    options?: { pixelRatio?: number; cacheBust?: boolean }
  ): Promise<string>;
}
```

#v(8pt)

*Non-Functional Component Characteristics:*
- *Modularity & Replaceability:* The `OCR Service Component` implements `IOCRService` using an offline-first, zero-API client-side WebAssembly neural OCR engine (Tesseract.js). Operating entirely within the client browser eliminates recurring third-party API costs, protects user privacy, and guarantees uninterrupted functionality.
- *Database Isolation:* The `firebaseService.ts` module isolates Firestore SDK document mapping logic. If persistent storage is migrated or adapted, only the service layer requires modification.
- *Fault Isolation & Error Boundaries:* If client-side canvas memory allocation fails on memory-constrained mobile devices, React `ErrorBoundary` components isolate failures, providing fallback notices rather than crashing the application.

#v(10pt)

*Master Conceptual Models Traceability Matrix to IEEE Std 830-1998:*

#styled-table(
  columns: (1.0in, 1.4in, 1.2in, 1fr),
  headers: ("Req ID", "Requirement Description", "Realizing Conceptual Model", "Architectural Artifact & Verification Method"),
  "REQ-1", "Multimodal Ingestion", "DFD 1.0, Activity, Comp", "Input validation; HTML5 canvas downscaler (<700 KB); image magic byte verification.",
  "REQ-2", "Client WASM OCR", "Activity, Sequence 1, Comp", "In-browser Tesseract.js WebAssembly worker; chat chrome cleaner; zero cloud upload.",
  "REQ-3", "Duplicate Detection", "DFD 2.0, State, Sequence 1", "Jaccard similarity calculation engine ($J >= 0.75$, $|w| > 3$; redirect to /claim/{id}).",
  "REQ-4", "Quorum Verification", "DFD 3.0, State, Sequence 2", "Real-time Firestore listeners; minimum quorum threshold $N >= 3$; explanation validation.",
  "REQ-5", "Weighted Consensus", "DFD 4.0, Class, Object, Seq 2", "Tri-partite formula $C = round(0.40A + 0.30R + 0.30S)$; 7-day CONTESTED expiry.",
  "REQ-6", "Anti-Sybil Reputation", "State, Object, Class", "Dynamic civic trust scoring ($[0, 100]$, $+2 / -1$); self-verification lockout.",
  "REQ-7", "1080x1080 Fact Card", "DFD 5.0, Activity, Comp", "Square 1:1 ($1080 times 1080$px) SVG <foreignObject> canvas rasterization via html-to-image.",
  "REQ-8", "Analytics Dashboard", "DFD 6.0, Use Case UC8", "Dynamic 7-day category breakdown (5 categories) and verifier leaderboards via Recharts.",
  "REQ-9", "Role-Based Access", "Use Case, Security Package", "Three-tier RBAC (Submitter, Verifier, Admin); Firestore security rules; /audit_logs.",
  "REQ-10", "Authentication & Session", "Security Package, Event Table", "30-minute idle session timeout; 5-attempt/15m rate limiting; null-byte XSS sanitizer."
)

#v(12pt)

*Summary of Conceptual Models:* \
The models in this chapter define the operational boundaries, data flows, and interface contracts of FactStamp. Functional decomposition through DFDs and use cases details how claims move from client-side OCR extraction and duplicate suppression to quorum consensus. The structural schemas and class definitions isolate database access behind service abstractions, while the activity and sequence specifications enforce anti-self-verification constraints and rate limiting at runtime. Together, these specifications establish the technical baseline for the system architecture detailed in Chapter 4.
