#import "../lib/helpers.typ": *

= Requirements and Analysis

#pagebreak(weak: true)
== Problem Definition

=== Statement of the Problem

WhatsApp is India's dominant private-messaging platform, and forwarded messages --- text, images, and short clips passed peer-to-peer between family, neighbourhood, and community groups --- are its single largest vector for the spread of misinformation. Because WhatsApp is end-to-end encrypted and forwarding happens inside closed group chats rather than on the open web, a false claim (a fabricated health cure, a doctored political quote, a fake government scheme, a communal rumour) can reach millions of readers within hours while remaining completely invisible to search-engine indexing, public fact-checking websites, and platform-level content moderation. By the time a claim is noticed and formally debunked, it has typically already completed several generations of forwarding.

*The problem, stated formally:* there is no fast, low-friction, source-accountable mechanism by which an ordinary WhatsApp user who receives a suspicious forward can (a) check whether it has already been verified, (b) get it verified quickly if it has not, and (c) obtain a verified counter-artifact in the same format and medium (a shareable image, not a web link) that can travel back through the group chats where the original claim spread.

=== Why Existing Fact-Checking Approaches Fail

The two categories of fact-checking effort that currently exist around WhatsApp forwards each fail for structurally different reasons, and neither is adequate on its own.

*A. Institutional Fact-Checkers* (PIB Fact Check, established newsrooms, dedicated misinformation-focused NGOs) are professionally rigorous but operationally centralized:
- *Latency mismatch:* a viral forward can complete its most damaging spread cycle within a few hours; a professional investigative debunk typically takes hours to multiple days.
- *Staffing bottleneck:* a small, fixed editorial team cannot scale with the volume of daily forwards across health, political, financial, and religious categories.
- *Format mismatch:* institutional debunks are published as long-form web articles that rarely travel back through the same channel the misinformation used.
- *Discoverability gap:* because the original claim lived inside a private, encrypted group, the eventual public debunk is never automatically connected to it.

*B. Ad-Hoc Community Debunking* (a group member replying "this is fake") is fast but structurally unaccountable:
- *No persistence:* the correction exists only inside one group's chat history, invisible to every other group the same forward is circulating in.
- *No source discipline:* a reply carries no citation and no way for another reader to independently assess it.
- *No reputation accountability:* anyone can assert anything with equal authority, with no track record distinguishing reliable members from unreliable ones.
- *No duplicate recognition:* the same claim resurfacing under reworded phrasing is treated as brand-new every time.

=== How FactStamp's Approach Differs

FactStamp is defined as the problem-solving system that sits between these two failure modes, retaining the speed and reach of ad-hoc community debunking while imposing the source discipline and auditability of institutional fact-checking:

+ *A single shared record, not per-group replies:* every claim is checked against a persistent corpus using Jaccard token-overlap similarity, redirecting resurfacing claims to their existing verdict instead of treating them as new.
+ *Distributed verification instead of a single editorial gate:* a minimum quorum of three independent, authenticated community verifiers must each cite a real source before consensus is computed.
+ *Evidence-weighted consensus, not a headcount vote:* the final confidence score is a function of verifier agreement, verifier reputation, and cited-source credibility.
+ *A time-bounded resolution guarantee:* claims that fail to reach consensus within 7 days auto-settle as `CONTESTED` rather than sitting unresolved indefinitely.
+ *A counter-artifact in the native medium of the misinformation:* a shareable PNG fact-check card 1080#text[ ]px wide with content-dependent height, not a web article, so a correction can travel back through the exact forward chains the original claim used.
+ *A zero-friction submission path:* a user can submit a screenshot exactly as received; client-side OCR extracts the claim text automatically.

*Scope boundary:* FactStamp solves the *verification and re-sharing* problem, not intervention inside WhatsApp itself. It does not hook into WhatsApp's proprietary protocol, does not perform automated AI/LLM truth judgments in place of human verifiers, and does not claim to prevent a claim from being forwarded in the first place.

#pagebreak(weak: true)
== Requirements Specification

This section specifies the software requirements for FactStamp following the IEEE Std 830-1998 structure recommended by `template/srs_template-ieee.md`: Introduction, Overall Description, External Interface Requirements, System Features (Functional Requirements), and Other Nonfunctional Requirements.

=== Introduction

==== Purpose
This section specifies the software requirements for FactStamp, a community-powered WhatsApp misinformation fact-checking web application, Version 1.0, covering the complete client-facing application and the staff-only `/admin` moderation console.

==== Document Conventions
Functional requirements are tagged `FR-<MODULE>-<n>` (e.g. `FR-AUTH-1`), grouped by the 8 core system modules. Non-functional requirements are tagged `NFR-<DOMAIN>-<n>`. Each requirement is rated High (H), Medium (M), or Low (L) priority, and is written to be concise, unambiguous, and independently verifiable per IEEE Std 830-1998.

==== Product Scope
FactStamp lets any user submit a WhatsApp forward (text or screenshot) for community fact-checking. The system automatically detects duplicate claims, routes unique claims into a 3-verifier quorum queue, computes a weighted-consensus verdict, and lets the result be exported as a shareable PNG card. A staff-only admin console provides moderation and audit tooling.

=== Overall Description

==== Product Perspective
FactStamp is a new, self-contained, client-heavy Single Page Application (React 18 + Vite 5 + TypeScript 5.5 + Tailwind CSS v4) backed entirely by Firebase v12 (Authentication and Cloud Firestore) as a Backend-as-a-Service --- there is no custom application server.

==== Product Functions
At a high level, the product lets a user submit a claim (text or screenshot with client-side OCR), have it automatically checked for duplicates, cast a verdict as a verifier once it enters the queue, view the computed weighted-consensus verdict once quorum is reached, export a shareable card, and view misinformation trend analytics. Admins additionally moderate users, claims, and incident reports.

==== User Classes and Characteristics
#styled-table(
  columns: (1.3fr, 1fr, 2.2fr),
  headers: ("User Class", "Access Level", "Key Characteristics"),
  "Registered Verifier", "Standard authenticated user", "Any signed-in user. Can submit claims and cast verdicts on claims other than their own. No separate verifier-only signup path exists -- privileges are identical, differentiated only by accrued reputation score.",
  "Admin", "Staff / elevated (`isAdmin: true`)", "Gains access to the unlisted `/admin` console (5 tabs) for moderation, override, and audit functions, in addition to all Registered Verifier capabilities.",
)

==== Operating Environment
Client: any modern desktop or mobile browser with WebAssembly and ES2022 support. Backend: Google Cloud Firestore (multi-region NoSQL) and Firebase Authentication; uploaded screenshots are compressed and persisted as base64 data URIs on the claim document, so Cloud Storage is not used at runtime. Hosting: Firebase Hosting, Vercel, or a self-hosted Docker + Nginx container.

==== Design and Implementation Constraints
- Must operate entirely within Firebase Spark (free-tier) usage limits -- no paid backend infrastructure.
- OCR must run 100% client-side (WebAssembly); no user image may be transmitted to a third-party cloud vision API.
- Card rasterization must correctly render Tailwind v4's OKLCH/OKLAB CSS colors.
- All database writes are additionally constrained server-side by `firestore.rules`, so client-side business logic cannot be bypassed by a malicious direct Firestore write.

==== Assumptions and Dependencies
Assumes the end user has an active internet connection at time of submission/verification, and that Firebase's free-tier quota (50,000 reads / 20,000 writes per day) is sufficient for the project's academic-demonstration scale. Depends on the continued availability of Firebase v12, Tesseract.js 7.0, and `html-to-image` as third-party packages.

=== External Interface Requirements

==== User Interfaces
The application is a responsive web UI covering Home, Submit, Verify Queue, Verify Detail, Claim Detail, Dashboard, Profile, Sign In / Sign Up, and the unlisted `/admin` console, with consistent verdict color-coding, category badges, loading skeletons, and toast notifications for async actions.

==== Hardware Interfaces
FactStamp has no direct interface to specialized external hardware beyond standard client input devices (touchscreen, keyboard, camera/file picker for screenshot upload).

==== Software Interfaces
#styled-table(
  columns: (1.4fr, 1.2fr, 2fr),
  headers: ("Interface", "Provider", "Purpose"),
  "Firebase Authentication", "Google Firebase v12", "Email/password and Google OAuth sign-in",
  "Cloud Firestore", "Google Firebase v12", "Real-time document store for users, claims, notifications, reports, audit logs. A claims/{claimId}/verdicts subcollection is declared and governed by firestore.rules but unused at runtime -- verifications live as an embedded array on the claim document",
  "Firebase Storage", "Google Firebase v12", "Rules and emulator port configured (`storage.rules`), but the client never calls the Storage SDK -- screenshots are stored as base64 data URIs on the claim document",
  "Tesseract.js 7.0", "Open-source (WASM)", "Client-side OCR text extraction",
  "html-to-image", "Open-source", "DOM-to-PNG rasterization for the fact-check card",
  "Recharts", "Open-source", "Dashboard chart rendering",
)

==== Communications Interfaces
All client-backend communication uses HTTPS via the Firebase JS SDK (Firestore's `onSnapshot` real-time listener over WebSocket/long-polling, and standard HTTPS REST for Auth).

=== System Features (Functional Requirements)

Requirements are grouped by the 8 core system modules, plus the cross-cutting admin console layer.

==== Module 1 --- Auth \& Verifier Reputation
Firebase Auth session management and a persistent 0--100 verifier reputation score. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-AUTH-1", "The system shall allow a user to register and sign in using email/password credentials via Firebase Authentication.", "H",
  "FR-AUTH-2", "The system shall allow a user to sign in using Google OAuth.", "H",
  "FR-AUTH-3", "The system shall assign every newly registered user a base reputation score of 50.", "H",
  "FR-AUTH-4", "The system shall increase a verifier's reputation by 2 points when their verdict matches the eventual majority (consensus) verdict.", "H",
  "FR-AUTH-5", "The system shall decrease a verifier's reputation by 1 point when their verdict disagrees with the eventual majority verdict.", "H",
  "FR-AUTH-6", "The system shall terminate an authenticated session after 30 minutes of user inactivity.", "M",
  "FR-AUTH-7", "The system shall lock out further login attempts for 15 minutes after 5 consecutive failed login attempts on the same account.", "H",
)

==== Module 2 --- Forward Submission (Ingestion \& OCR)
Accepts a claim as raw text or a WhatsApp screenshot; screenshots are OCR-processed and compressed client-side. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-INGEST-1", "The system shall allow a user to submit a claim as free-form text.", "H",
  "FR-INGEST-2", "The system shall allow a user to submit a claim as an uploaded screenshot image (JPEG, PNG, WebP, or GIF).", "H",
  "FR-INGEST-3", "The system shall extract text from an uploaded screenshot using client-side Tesseract.js OCR, with no image data transmitted to an external OCR service.", "H",
  "FR-INGEST-4", "The system shall strip WhatsApp chat chrome (timestamps, delivery checkmarks, carrier/battery bar text) from OCR-extracted text via `cleanExtractedOcrText()` before storage.", "M",
  "FR-INGEST-5", "The system shall compress an uploaded image client-side before it is persisted, to stay within Firestore's document-size limits.", "M",
  "FR-INGEST-6", "The system shall auto-classify a submitted claim into one of five categories via keyword heuristics, with the user able to override the suggestion.", "M",
)

==== Module 3 --- Duplicate Detection Engine
Jaccard token-overlap similarity check against the existing claim corpus. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-DUP-1", "The system shall compute Jaccard similarity between an incoming claim's token set and each existing claim's token set, using only tokens longer than 3 characters.", "H",
  "FR-DUP-2", "The system shall redirect the submitter to the existing claim's verdict page when the maximum computed similarity against any existing claim is 0.75 or higher, instead of creating a new claim record.", "H",
  "FR-DUP-3", "The system shall create a new claim record and enter it into the verification queue when no existing claim matches at or above the 0.75 similarity threshold.", "H",
)

The duplicate-detection similarity coefficient is formally defined as:
$ J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|) $
where $S_A$ and $S_B$ are the significant (length greater than 3) token sets of the incoming claim $A$ and an existing claim $B$ respectively.

==== Module 4 --- Verification Queue
Lists claims awaiting community verification and provides the verifier workbench. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-QUEUE-1", "The system shall display all pending claims in a public verification queue, visible to any authenticated user.", "H",
  "FR-QUEUE-2", "The system shall prevent a user from submitting more than one verification on the same claim.", "H",
  "FR-QUEUE-3", "The system shall prevent a claim's original submitter from verifying their own claim.", "H",
  "FR-QUEUE-4", "The system shall require a verifier to supply a verdict, a source URL, and a written explanation before a verification is accepted; the source-quality tier is derived automatically from the cited domain via `determineSourceQuality()` and is not entered by the verifier.", "H",
  "FR-QUEUE-5", "The system shall reject a verification explanation shorter than 50 characters or fewer than 8 words, or one that fails the anti-spam / copy-paste-the-claim check.", "M",
  "FR-QUEUE-6", "The system shall surface admin-flagged claims at the top of the verification queue for expedited review.", "L",
)

==== Module 5 --- Weighted Consensus \& Confidence Engine
Computes the final verdict and confidence score once quorum is reached. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-CONSENSUS-1", "The system shall compute a final consensus verdict only once a claim has received at least 3 independent verifications.", "H",
  "FR-CONSENSUS-2", "The system shall compute the claim's confidence score as a weighted combination of agreement ratio, average verifier reputation, and source quality score.", "H",
  "FR-CONSENSUS-3", "The system shall determine the agreement ratio as the percentage of participating verifiers whose verdict matches the majority verdict.", "H",
  "FR-CONSENSUS-4", "The system shall determine source quality from the cited domain against a hardcoded credibility list (High: e.g. who.int, pib.gov.in, rbi.org.in; Medium: e.g. bbc.com, reuters.com, snopes.com; Low: any other domain).", "H",
  "FR-CONSENSUS-5", "The system shall automatically mark a claim `CONTESTED` if it has not reached a settled majority verdict within 7 days of submission.", "H",
)

The consensus confidence score is formally defined as:
$ C = 0.40 A + 0.30 R + 0.30 S $
where $A$ is the agreement ratio, $R$ is the average participating-verifier reputation, and $S$ is the average source-quality score, each normalized to a 0--100 scale.

==== Module 6 --- Fact-Check Card Generator
Renders a shareable PNG verdict card 1080#text[ ]px wide, with content-dependent height. Priority: Medium.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-CARD-1", "The system shall render a fact-check card containing the claim text, the final verdict, the confidence score, and the primary cited source.", "M",
  "FR-CARD-2", "The system shall export the rendered card as a PNG image 1080 px wide -- a 540 CSS-pixel card captured at a pixel ratio of 2, its height determined by the card's content -- via `html-to-image`, correctly rendering the application's OKLCH/OKLAB colors.", "M",
  "FR-CARD-3", "The system shall allow the user to download the generated PNG card directly to their device for re-sharing.", "M",
)

==== Module 7 --- Misinformation Analytics Dashboard
Trend graphs, category distribution, and verifier leaderboards. Priority: Low.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-DASH-1", "The system shall display a rolling weekly trend of claims submitted, broken down by category.", "L",
  "FR-DASH-2", "The system shall display a leaderboard of the top verifiers by reputation score.", "L",
  "FR-DASH-3", "The system shall display the proportion of settled claims debunked as FALSE, together with the average confidence score across all settled claims.", "L",
)

==== Module 8 --- System Security \& Notifications (cross-cutting)
Client-side defense-in-depth hardening plus real-time in-app notifications. Priority: High.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-SEC-1", "The system shall sanitize all free-text user input against XSS injection before rendering or storage.", "H",
  "FR-SEC-2", "The system shall validate every uploaded image against extension, declared MIME type, and magic-byte signature, rejecting files over 5MB.", "H",
  "FR-SEC-3", "The system shall enforce all data-integrity and access-control rules identically server-side via `firestore.rules`.", "H",
  "FR-SEC-4", "The system shall deliver real-time in-app notifications covering the four implemented notification types: `claim_verified` (a claim reached consensus), `reputation_update` (the user's reputation changed), `verdict_submitted` (the user's verdict was recorded), and `weekly_report` (the weekly misinformation digest).", "M",
)

==== Admin Console (cross-cutting moderation layer, `/admin`)
Staff-only unlisted moderation console. Not a numbered core module --- the admin console is a cross-cutting layer over Modules 1, 4, 5 and 8. Priority: Medium.

#styled-table(
  columns: (1.1fr, 3.3fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "FR-ADMIN-1", "The system shall restrict access to `/admin` to users whose Firestore profile has `isAdmin` set true, re-checked from the live Firestore-backed auth snapshot on every render.", "H",
  "FR-ADMIN-2", "The system shall provide 5 console tabs: System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit & Tools.", "M",
  "FR-ADMIN-3", "The system shall allow an admin to override a claim's verdict, confidence score, status, text, and category.", "M",
  "FR-ADMIN-4", "The system shall allow an admin to promote or revoke another user's admin flag, edit reputation, or delete a user account.", "M",
  "FR-ADMIN-5", "The system shall log every mutating admin action to the immutable, append-only `audit_logs` Firestore collection, on which `firestore.rules` denies all update and delete.", "H",
  "FR-ADMIN-6", "The system shall allow an admin to create, investigate, resolve, or dismiss an incident report ticket.", "M",
)

#pagebreak(weak: true)
=== Non-Functional Requirements Specification

==== Performance Requirements
#styled-table(
  columns: (1.2fr, 3.2fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "NFR-PERF-1", "The verification queue view shall reflect a newly submitted claim within 2 seconds of submission, via Firestore's real-time listener.", "M",
  "NFR-PERF-2", "Client-side OCR text extraction on a typical WhatsApp screenshot (2MB or less) shall complete within 8 seconds on a mid-range mobile device.", "M",
  "NFR-PERF-3", "PNG card export shall complete within 3 seconds for a typical 1080 px-wide card.", "L",
  "NFR-PERF-4", "Duplicate-detection comparison against the existing claim corpus shall complete within 500 ms for corpora up to 5,000 claims.", "L",
)

==== Security Requirements
#styled-table(
  columns: (1.2fr, 3.2fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "NFR-SEC-1", "All Firebase communication shall occur over HTTPS/TLS; no plaintext credential or claim data shall be transmitted.", "H",
  "NFR-SEC-2", "Admin-only Firestore write paths shall be rejected server-side for any non-admin user, independent of client-side route guarding.", "H",
  "NFR-SEC-3", "Login attempts shall be rate-limited (5 attempts then 15-minute lockout) to mitigate credential brute-forcing.", "H",
  "NFR-SEC-4", "A verdict explanation shall be rejected outside a 50--1,500 character range or below minimum word-count / anti-spam thresholds.", "M",
)

==== Reliability Requirements
#styled-table(
  columns: (1.2fr, 3.2fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "NFR-REL-1", "A claim that fails to reach settled quorum consensus within 7 days shall automatically transition to `CONTESTED` rather than remaining indefinitely pending.", "H",
  "NFR-REL-2", "The system shall degrade gracefully if client-side OCR fails, allowing manual text entry instead of blocking submission.", "M",
)

==== Usability Requirements
#styled-table(
  columns: (1.2fr, 3.2fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "NFR-USE-1", "The claim-submission form shall not require account registration to browse existing verified claims (submission and verification require sign-in).", "M",
  "NFR-USE-2", "Verdict states shall be distinguishable by both color and icon/label, not color alone, for accessibility.", "M",
  "NFR-USE-3", "The application UI shall be responsive across mobile, tablet, and desktop breakpoints without horizontal scrolling or layout breakage.", "M",
)

==== Scalability Requirements
#styled-table(
  columns: (1.2fr, 3.2fr, 0.5fr),
  headers: ("ID", "Requirement", "Pri"),
  "NFR-SCALE-1", "The system shall operate within Firebase Spark (free-tier) quota limits at expected campus-pilot submission volumes.", "M",
  "NFR-SCALE-2", "The claim data model shall denormalize verifications as an embedded array on the parent claim document to avoid N+1 read patterns as claim volume grows.", "L",
)

=== Other Requirements
No database-specific, internationalization, or legal requirements beyond those already stated apply at this stage. The application currently supports English-language OCR only (Tesseract.js bundled English model); this is an explicit out-of-scope item per Chapter 1 Section 1.3.2.

#pagebreak(weak: true)
== Planning and Scheduling

=== Development Process Model: Agile / Scrum

FactStamp was developed using an *Agile Scrum* process, in preference to a sequential Waterfall or V-Model approach, because the product's core algorithmic parameters --- the Jaccard duplicate-detection threshold, the 40/30/30 consensus weighting, and the OCR text-cleanup heuristics --- could only be meaningfully tuned after building a working prototype and observing real WhatsApp-forward text samples. A Waterfall model's up-front, fully-specified design phase would have locked in these parameters before any empirical evidence existed to justify them.

Scrum's three formal roles were held as follows, given the project's single-developer academic context:
- *Product Owner* --- the student developer, representing the interests of the end-user community and the academic requirements of the guides.
- *Scrum Master* --- the student developer, self-facilitating sprint cadence and backlog refinement.
- *Developers* --- the student developer (solo development), consulting the project guides (Mr. Wilson Rao, Ms. Bertilla Fernandes) at sprint-boundary reviews in place of a formal Sprint Review stakeholder audience.

The project followed Scrum's core artifacts (Product Backlog, Sprint Backlog, Increment) and events (Sprint Planning, Daily Scrum, Sprint Review, Sprint Retrospective) at a scale appropriate to a single-developer capstone project, per `template/2020-Scrum-Guide-US.md`.

=== Sprint Cadence and Incremental Module Delivery

Development proceeded in fixed *2-week sprints*, with each sprint incrementally delivering one or more of the 8 core modules.

#styled-table(
  columns: (0.7fr, 1fr, 2.6fr, 1.6fr, 0.7fr),
  headers: ("Sprint", "Duration", "Modules / Deliverables", "Dependencies", "Status"),
  "Sprint 1", "2 wks (Jun, wk 1-2)", "Project scaffolding (React 18 + Vite 5 + TS + Tailwind v4); Firebase setup; Module 1 -- Auth & Verifier Reputation", "None (foundation)", "Done",
  "Sprint 2", "2 wks (Jun, wk 3-4)", "Module 2 -- Forward Submission (Ingestion & OCR); image compression; Tesseract.js integration & text cleanup", "Sprint 1", "Done",
  "Sprint 3", "2 wks (Jul, wk 1-2)", "Module 3 -- Duplicate Detection Engine (Jaccard similarity); claim corpus data model", "Sprint 2", "Done",
  "Sprint 4", "2 wks (Jul, wk 3-4)", "Module 4 -- Verification Queue; verifier workbench UI; anti-self-verification rules", "Sprint 3", "Done",
  "Sprint 5", "2 wks (Aug, wk 1-2)", "Module 5 -- Weighted Consensus & Confidence Engine; quorum logic; 7-day deadline auto-expiry", "Sprint 4", "Done",
  "Sprint 6", "2 wks (Aug, wk 3-4)", "Module 6 -- Fact-Check Card Generator (1080 px wide at 2x pixel ratio); Module 7 -- Analytics Dashboard", "Sprint 5", "Done",
  "Sprint 7", "2 wks (Sep, wk 1-2)", "Module 8 -- System Security & Notifications; Admin Console (`/admin`, 5 tabs)", "Sprints 1-6", "Done",
  "Sprint 8", "2 wks (Sep, wk 3-4)", "Security hardening, cross-browser verification, deployment config, CI, documentation finalization, viva prep", "Sprints 1-7", "Underway",
)

Total planned schedule: 8 sprints of 2 weeks each, approximately 4 months from initial scaffolding through documentation finalization and viva.

=== PERT / Gantt Chart Content

#align(center)[#image("attachments/gantt_chart.svg", width: 100%)]

The Gantt chart for this section renders the 8-sprint schedule above as a horizontal timeline, each sprint's bar spanning its 2-week duration, with dependency arrows drawn per the Dependencies column above. A complementary PERT network diagram expresses the same sequence as a directed acyclic graph of milestone nodes and precedence edges. Because each module's data depends on the previous module's output, the critical path in this project is the full linear chain Sprint 1 through Sprint 8, with zero slack on any sprint -- the critical path length equals the total project duration of 16 weeks.

#align(center)[#image("attachments/pert_chart.svg", width: 100%, height: 88%, fit: "contain")]

=== Sprint Velocity and Definition of Done

Each sprint's Increment was held to a consistent Definition of Done: the feature must be integrated into the deployed application (not left on a feature branch), must not regress any previously delivered module, must pass a manual smoke test across its primary user flow, and must not introduce a TypeScript compile error (the project's `tsc -b` gate runs before every build, and again in GitHub Actions CI).

=== Risk and Contingency Notes

- *Algorithmic tuning risk* (Sprints 3 and 5): the Jaccard threshold and the 40/30/30 weighting were empirically tuned during development rather than fixed up front, which is precisely why Agile/Scrum was chosen over Waterfall.
- *Third-party dependency risk*: a mid-project migration from a hand-written canvas card-rasterization parser to `html-to-image` was absorbed within Sprint 6 without disrupting the overall schedule.
- *Solo-developer capacity risk*: sprint scope was deliberately kept to one or two modules per sprint rather than parallel workstreams, keeping each increment realistically achievable.

#pagebreak(weak: true)
== Software and Hardware Requirements

=== Software Requirements

==== Development \& Build Environment
#styled-table(
  columns: (1.5fr, 1.7fr, 2fr),
  headers: ("Component", "Requirement / Version", "Purpose"),
  "Operating System (dev)", "Linux, macOS 13+, or Windows 10/11 (WSL2)", "Cross-platform development; CI runs on Linux runners",
  "Node.js", "v20.x LTS or v22.x LTS", "JavaScript runtime for Vite build tooling and npm scripts",
  "Package Manager", "npm (bundled with Node.js)", "Dependency installation and script execution",
  "Git", "2.40+", "Version control",
  "Firebase CLI", "Latest (firebase-tools)", "Local Emulator Suite; deployment to Firebase Hosting",
  "Visual Studio Code", "Latest", "Primary IDE (TypeScript / ESLint / Tailwind extensions)",
  "Docker & Compose", "Latest stable", "Optional containerized production build",
  "Typst", "v0.15.1", "Dissertation / black-book document typesetting",
  "PlantUML", "Latest (requires JVM)", "UML diagram source compilation",
  "Graphviz", "Latest (dot binary)", "DFD diagram compilation",
)

==== Core Application Dependencies
#styled-table(
  columns: (1.6fr, 1fr, 2.6fr),
  headers: ("Package", "Version", "Role"),
  "React", "18.3.1", "UI component framework",
  "Vite", "5.4.0", "Build tool / dev server",
  "TypeScript", "5.5.0", "Static typing (strict mode)",
  "Tailwind CSS", "4.0.0", "Utility-first styling, OKLCH design tokens",
  "Firebase (JS SDK)", "12.17.0", "Auth and Cloud Firestore client bindings (the Storage SDK is not used)",
  "Tesseract.js", "7.0.x", "Client-side WebAssembly OCR",
  "html-to-image", "1.11.13", "DOM-to-PNG card rasterization",
  "Recharts", "2.10.0", "Analytics dashboard charts",
  "Framer Motion", "12.42.2", "UI animation",
)

==== End-User (Client) Software Requirements
#styled-table(
  columns: (1.5fr, 3fr),
  headers: ("Component", "Minimum Requirement"),
  "Web Browser", "Chrome 111+, Firefox 113+, Safari 15.4+, or Edge 111+ -- the first versions supporting the CSS oklch()/oklab() functions the design system requires, alongside WebAssembly and ES2022",
  "Operating System", "Any OS with a supported modern browser (Windows 10+, macOS 12+, Android 10+, iOS 15+, current Linux)",
  "JavaScript", "Must be enabled (the application is a JavaScript SPA)",
)

=== Hardware Requirements

Because FactStamp is a purely client-side web application with a serverless (Firebase-managed) backend, this project specifies no dedicated application-server hardware. The relevant requirements are the client device's minimums and the development machine's minimums.

==== Client (End-User) Device
#styled-table(
  columns: (1.3fr, 1.6fr, 1.6fr),
  headers: ("Resource", "Minimum", "Recommended"),
  "Processor", "Dual-core 1.8 GHz 64-bit CPU", "Quad-core 2.0 GHz+",
  "RAM", "2 GB", "4 GB (in-browser OCR is memory-intensive)",
  "Display Resolution", "360x640 (mobile)", "1920x1080 (desktop FHD) or higher",
  "Storage", "Negligible (no local install)", "--",
  "Network", "3G / stable low-bandwidth", "4G / broadband",
)

==== Development Machine
#styled-table(
  columns: (1.3fr, 1.6fr, 1.6fr),
  headers: ("Resource", "Minimum", "Recommended"),
  "Processor", "Dual-core 2.0 GHz", "Quad-core 2.5 GHz+",
  "RAM", "8 GB", "16 GB",
  "Storage", "10 GB free", "20 GB+ SSD",
  "Network", "Broadband internet", "--",
)

==== Backend / Cloud Infrastructure (Managed)
#styled-table(
  columns: (1.5fr, 1.6fr, 2fr),
  headers: ("Layer", "Provider", "Notes"),
  "Authentication", "Firebase Authentication", "Fully managed; no server hardware provisioned by this project",
  "Database", "Google Cloud Firestore", "Fully managed, Spark (free) tier: 50,000 document reads and 20,000 document writes per day, with 1 GiB of total stored data",
  "Static Hosting", "Firebase Hosting / Vercel / Docker + Nginx", "First two fully managed; Docker is the only self-hosted target",
  "CI", "GitHub Actions (hosted runners)", "Typecheck, build, and docker-compose config validation on every push",
)

#pagebreak(weak: true)
== Preliminary Product Description

FactStamp's functionality is organized into 8 core modules, each responsible for one stage of a claim's lifecycle from initial submission through to a shareable verified verdict, plus a cross-cutting security layer and an admin moderation layer. This section previews each module at a preliminary, product-level description; the detailed data design, procedural logic, and algorithms for each appear in Chapter 4.

*Module 1 --- Auth \& Verifier Reputation.* Handles user identity for the entire platform. A visitor registers or signs in using either email/password or Google OAuth through Firebase Authentication, and every account is issued a persistent reputation score starting at 50 on a 0--100 scale. This reputation feeds directly into the weighted-consensus calculation of Module 5.

*Module 2 --- Forward Submission (Multimodal Ingestion \& OCR).* The entry point for every claim. A user can paste raw forwarded text directly, or upload a screenshot of the WhatsApp message as received. Uploaded screenshots are compressed client-side and passed through a 100%-client-side Tesseract.js OCR pipeline that extracts embedded text and strips WhatsApp-specific chat chrome before the claim is normalized and stored, with automatic category suggestion via keyword heuristics.

*Module 3 --- Duplicate Detection Engine.* Before a submitted claim occupies a new slot in the verification queue, this module checks whether it has effectively already been fact-checked, computing Jaccard word-overlap similarity between the incoming claim's tokens and every existing claim's token set. Matches at or above the tuned 0.75 threshold redirect the submitter to the already-verified claim.

*Module 4 --- Verification Queue.* Claims that pass the duplicate check enter a public verification queue, where any authenticated user other than the original submitter can open a claim's verifier workbench and submit an evaluation: a verdict, a supporting source URL, and a written rationale --- with the source-quality tier derived automatically from the cited domain rather than self-assessed. A given user may verify a given claim only once, and submitters cannot verify their own submissions.

*Module 5 --- Weighted Consensus \& Confidence Engine.* Once a claim has accumulated at least three independent verifications, this module computes the claim's final settled verdict and a numeric confidence score using the 40/30/30 weighted formula. Claims still short of quorum when the 7-day window closes are automatically settled --- their status moves from `pending` to `verified` with the verdict `CONTESTED`.

*Module 6 --- Fact-Check Card Generator.* Once a verdict is settled, this module renders a PNG image 1080#text[ ]px wide (a 540 CSS-pixel card captured at 2#text[×] pixel ratio), its height growing with the length of the claim text and the number of cited sources, styled to WhatsApp's native forwarding format, using `html-to-image` for its native OKLCH/OKLAB color support. The exported card can be downloaded and forwarded back into the originating WhatsApp groups.

*Module 7 --- Misinformation Analytics Dashboard.* Provides a public view into platform-wide trends: category distribution, a rolling weekly report of most-contested claims, verdict-outcome proportions, and a top-verifier leaderboard, rendered using Recharts.

*Module 8 --- System Security \& Notifications.* A cross-cutting module underpinning every other module: client-side XSS sanitization, triple-layer upload validation, a 30-minute idle-session timeout, and a 5-attempt/15-minute login rate limiter, backed by matching server-side `firestore.rules` enforcement. Also drives real-time in-app notifications.

*Admin Console (cross-cutting moderation layer).* Layered over Modules 1, 4, and 5 (and Module 8's security concerns) is the staff-only, unlisted `/admin` console, providing five operational tabs -- System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit \& Tools -- with dual-layer authorization and an immutable audit trail of every administrative action taken.

#pagebreak(weak: true)
== Conceptual Models

Every diagram listed in `Rules/Diagrams-Checklist.md` for this section is introduced below with a description of what it will show for FactStamp specifically. Actual `.puml` / `.dot` diagram sources and their compiled `.svg` assets are a separate production pipeline per `Rules/Diagram-rules.md` and are represented here with text placeholders so this chapter compiles cleanly without external image dependencies.

=== Entity-Relationship (E-R) Diagram
Models FactStamp's Firestore data domain as five conceptual entities: *USER* (uid, displayName, reputation, isAdmin), *CLAIM* (id, text, status, verdict, confidence, category, submittedBy), *VERIFICATION* (id, claimId, verifierId, verdict, sourceUrl, sourceQuality), *DUPLICATE_CLUSTER* (canonical claim grouping for near-duplicate submissions), and *CATEGORY_METRIC* (aggregated per-category rollups for the dashboard). USER submits many CLAIMs and casts many VERIFICATIONs; CLAIM receives many VERIFICATIONs (minimum 3 for quorum) and may group duplicates under a DUPLICATE_CLUSTER; CLAIM aggregates many-to-one into a CATEGORY_METRIC.

#align(center)[#image("attachments/er_diagram.svg", width: 100%, height: 86%, fit: "contain")]

=== Class Diagram
Models core domain classes independent of implementation detail: an abstract `BaseVerifier` class specialized by a concrete `CommunityVerifier` class (FactStamp has no separate verifier role); a `Claim` class composed of many `Verification` objects; and a `ConsensusEngine` class exposing the weighted-scoring method. Composition reflects that verifications cannot exist independent of their parent claim, matching Firestore's embedded-array denormalization decision.

#align(center)[#image("attachments/class_diagram.svg", width: 100%, height: 88%, fit: "contain")]

=== Object Diagram
Provides a concrete instance snapshot at a specific runtime moment -- for example an object `verifier_042 : CommunityVerifier` with reputation 78, linked via a "verified" association to an object `claim_017 : Claim` with status "pending" and `verificationCount = 2` -- illustrating one verifier's vote against one claim instance mid-quorum.

#align(center)[#image("attachments/object_diagram.svg", width: 88%)]

=== Use Case Diagram
Captures three actors -- *Public Submitter*, *Community Verifier* (the same user class in a different capacity), and *System Engine* (automated duplicate-detection and consensus logic) -- against use cases including Submit Claim, Check Duplicate, View Confidence, Export Fact Card, Review Queue, Submit Verdict, and Compute Consensus.

#align(center)[#image("attachments/use_case_diagram.svg", width: 100%, height: 88%, fit: "contain")]

=== Activity Diagram
Traces the full claim lifecycle: a user submits text or a screenshot; if a screenshot, OCR extraction and cleanup runs; the duplicate-detection engine computes similarity against the existing corpus; a decision branch either redirects to an existing verified claim or creates a new pending claim; the new claim accumulates verifications one at a time; a second decision branch checks whether quorum has been reached or the 7-day deadline has expired; the consensus engine then computes the final verdict, after which the claim becomes eligible for card export.

#align(center)[#image("attachments/activity_diagram.svg", width: 100%, height: 90%, fit: "contain")]

=== State Diagram (State Machine)
Models a Claim's lifecycle as a finite state machine over the two status values the implementation actually defines (`ClaimStatus = 'pending' | 'verified'` in `src/lib/types.ts`): initial state to `pending` on creation, then to `verified` carrying the majority verdict once the third verification arrives, or to `verified` carrying the verdict `CONTESTED` if the 7-day consensus deadline passes while fewer than three verifications exist. `verified` is the terminal state; `CONTESTED` is a verdict value, not a separate status. Verifications accumulating below quorum appear as a self-transition on `pending` rather than a distinct "under review" state.

#align(center)[#image("attachments/state_diagram.svg", width: 85%)]

=== Sequence Diagram
Traces the temporal message flow for a single verification-to-consensus event: Verifier to the Verify Detail UI, to the Claims context (submit verdict), to the Firebase service layer (persist verification), to Firestore security rules (server-side validation), back to the Claims context which -- once quorum is reached -- invokes the confidence-score calculator, persists the settled claim, and triggers a notification to the original submitter. Per `Rules/Diagram-rules.md`, this will be hand-drawn in native Typst/Fletcher rather than PlantUML.

#align(center)[#image("attachments/sequence_diagram.svg", width: 100%, height: 88%, fit: "contain")]

=== Package Diagram
Groups the source tree into cohesive packages: `pages` (route-level views), `components` (with a nested `components/ui` primitive package), `contexts` (the five React Context providers), `lib` (pure utility/algorithm modules), and `services` (Firebase and OCR service wrappers) -- with dependency arrows showing `pages` depends on `contexts`, `contexts` depends on `services` and `lib`, and `services` depends on `lib`, never the reverse.

#align(center)[#image("attachments/package_diagram.svg", width: 88%)]

=== Component Diagram
Shows high-level runtime components: a `Frontend` component (the React SPA) communicating with `Firestore` and `FirebaseAuth` over HTTPS, plus a `WasmOCR` component (the in-browser Tesseract.js worker) invoked entirely in-process, reflecting the deliberate architectural decision that OCR runs client-side rather than via any cloud vision API.

#align(center)[#image("attachments/component_diagram.svg", width: 100%, height: 86%, fit: "contain")]

=== Deployment Diagram
Models the physical/logical nodes: a Client Device node hosting the Browser and the in-browser WasmOCR artifact; a hosting node (Firebase Hosting / Vercel Edge / self-hosted Docker + Nginx, shown as alternative deployment targets) serving the static Frontend artifact; and a Google Cloud node hosting the managed Firestore database and Firebase Auth service.

#align(center)[#image("attachments/deployment_diagram.svg", width: 92%)]

=== Data Flow Diagrams (Level 0, Level 1, Level 2)

*Level 0 (Context Diagram):* models FactStamp as a single process bubble with two external entities -- User and Admin -- and Firestore/Firebase Auth shown as an external data store at the boundary.

*Level 1:* decomposes the single Level 0 process into major processing stages: Submit Claim, Detect Duplicate, Manage Verification Queue, Compute Consensus, Generate Fact-Check Card, Serve Analytics Dashboard, and Admin Moderation, each reading from and writing to the shared Firestore data store.

*Level 2 (drill-down of Submit Claim):* further decomposes claim submission into Accept Text/Screenshot Input, Compress Image, Run Client-Side OCR, Clean WhatsApp Chrome Text, Auto-Classify Category, and Persist Claim Record.

All three DFD levels will be produced with Graphviz per `Rules/Diagram-rules.md` (the one diagram type that stays on `dot` rather than PlantUML), rendered top-to-bottom.

#align(center)[#image("attachments/dfd_level_0.svg", width: 85%)]

#align(center)[#image("attachments/dfd_level_1.svg", width: 100%, height: 86%, fit: "contain")]

#align(center)[#image("attachments/dfd_level_2.svg", width: 100%, height: 86%, fit: "contain")]

=== Event Table

Per `Rules/Diagram-rules.md`, the Event Table is tabular data, not a diagram, and is rendered here as a native table.

#styled-table(
  columns: (1.3fr, 1.2fr, 2fr, 1.5fr, 1.3fr),
  headers: ("Trigger", "Source", "Action / Process", "Output", "Destination"),
  "Claim submitted (text or screenshot)", "User (Submit page)", "Module 2 ingests input; if screenshot, runs OCR extraction and chrome cleanup; Module 3 computes Jaccard similarity", "New claim record (if unique) or a redirect reference (if duplicate)", "Firestore claims collection / user's browser",
  "Duplicate match found (similarity 0.75 or higher)", "Duplicate Detection Engine (Module 3)", "Suppress new claim creation; resolve to existing canonical claim", "Redirect payload pointing to existing claim ID", "User's browser (Claim Detail page)",
  "Verification submitted", "Community Verifier (Verify Detail page)", "Module 4 validates one-vote-per-user and anti-self-verification rules; persists verdict, source, rationale", "Updated Verification record appended to claim", "Firestore claims collection (embedded array)",
  "Consensus reached (quorum met, majority settled)", "Weighted Consensus Engine (Module 5)", "Compute confidence score; determine final verdict; update reputations (+2 aligned, -1 dissenting)", "Settled verdict, confidence score, updated reputations", "Firestore claims and users collections; Notifications system",
  "Consensus deadline expired (7 days, fewer than 3 verifications)", "Consensus-Deadline Scheduler (`expireOverdueClaims()`)", "Auto-settle the claim: move status from pending to verified and set the verdict to CONTESTED; skip reputation adjustment", "Claim status set to verified, verdict set to CONTESTED", "Firestore claims collection; Notifications system",
)
