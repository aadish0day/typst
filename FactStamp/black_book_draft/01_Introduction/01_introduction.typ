= Introduction

== Background

India is the world's largest market for WhatsApp, with hundreds of millions of daily active users, and forwarded messages are the platform's dominant vector for misinformation. A single viral forward --- a fabricated health cure, a fake government scheme, a doctored political claim --- can reach millions of closed group chats within hours, entirely outside the reach of public fact-checking websites, search-engine indexing, or platform-level content moderation. Because WhatsApp is end-to-end encrypted and message forwarding happens peer-to-peer inside private and family groups, conventional web-based fact-checking (a journalist publishing an article that must be _found_ by the reader) arrives too late, if at all --- by the time a debunking article ranks on Google, the false claim has already been forwarded dozens of times further.

Existing fact-checking efforts in this space fall into two categories, both with structural weaknesses:

+ *Institutional fact-checkers* (news organizations, PIB Fact Check, dedicated NGOs) --- authoritative but slow, centralized, and bottlenecked on a small number of professional staff. A single team cannot keep pace with the sheer volume of daily forwards across health, political, financial, and religious categories.
+ *Ad-hoc community debunking* --- individuals replying "this is fake" in a group chat, with no persistent record, no source citation discipline, no reputation accountability, and no way for the same claim to be recognized the next time it resurfaces under slightly different wording.

FactStamp was conceived to sit between these two failure modes: a lightweight, decentralized, *community-powered* verification platform where any user can submit a forwarded claim (as text or a screenshot), the system automatically checks whether it has already been debunked, and --- if not --- routes it into a transparent verification queue where independent community verifiers each cite a real source and cast a verdict. Once three independent verifications agree above a computed confidence threshold, FactStamp issues a final verdict and a shareable, WhatsApp-optimized PNG fact-check card that the original submitter (or anyone else) can forward straight back into the group chat where the claim originated --- closing the loop in the same medium the misinformation used to spread.

== Objectives

The project is built around the following core objectives:

+ *Reduce the time-to-debunk* for a WhatsApp forward by giving any user a way to submit a claim directly, rather than waiting for an institutional fact-checker to notice and publish.
+ *Eliminate redundant verification effort* by automatically detecting near-duplicate claims (Jaccard token-overlap similarity, threshold $>= 0.75$) and instantly returning the existing verdict instead of re-queuing the same claim under different wording.
+ *Replace single-source trust with a distributed quorum* --- no single verifier or moderator can unilaterally decide a claim's verdict; a minimum of three independent verifications is required before consensus settles.
+ *Weight consensus by evidence quality, not just headcount* --- a verdict's confidence score is a function of verifier agreement, verifier reputation, and the credibility of the cited source domain (`src/lib/confidenceScore.ts`), not a simple majority vote.
+ *Make verified facts shareable in the native medium of the misinformation* --- export a 1080 px-wide WhatsApp-ready PNG card, a 540 CSS px card rasterized at 2#text[×] pixel ratio with content-dependent height (`html-to-image`), so a debunk can travel back through the same forward chains, group chats, and status updates that spread the original claim.
+ *Lower the barrier to submission for non-technical users* --- accept a screenshot of a WhatsApp forward directly, and extract the claim text automatically via 100%-client-side OCR (Tesseract.js WebAssembly), with WhatsApp chat chrome (timestamps, checkmarks, carrier bars) stripped automatically.
+ *Build verifier accountability over time* through a reputation system: verifiers who consistently align with eventual community consensus gain reputation; verifiers who consistently disagree lose it, and that reputation feeds back into the confidence-score weighting of every verdict they participate in.
+ *Give the public visibility into misinformation trends* --- a dashboard surfacing which categories (Health, Political, Financial, Religious) are currently generating the most volume, and a rolling weekly "most-debunked" report.

== Purpose, Scope, and Applicability

=== Purpose

The purpose of FactStamp is to provide a free, open, community-operated fact-checking layer purpose-built for the WhatsApp-forward format of misinformation, rather than repurposing tools designed for open web content. It exists to shorten the gap between "a false claim starts spreading" and "a citable, shareable, source-backed correction exists," and to do so without depending on a centralized editorial team that cannot scale with forward volume.

=== Scope

*In scope:*
- Submission of a claim as free text or a WhatsApp forward screenshot (client-side OCR extraction).
- Automatic duplicate detection against the existing claim corpus.
- A community verification queue with a minimum 3-verifier quorum requirement.
- A weighted confidence-scoring engine (agreement ratio, verifier reputation, source quality).
- Automatic consensus expiry (claims unresolved after 7 days settle as `CONTESTED`, never leaving the queue stuck indefinitely).
- Shareable PNG fact-check card generation.
- A public misinformation-trends analytics dashboard.
- Firebase Authentication (email/password and Google OAuth) with a persistent verifier reputation profile.
- A staff-only `/admin` moderation console covering user, claim, and incident-report management, plus an immutable audit log.
- Defense-in-depth client-side security hardening (rate-limited login, file-upload validation, verdict-explanation anti-spam filtering, XSS input sanitization) layered on top of server-side Firestore Security Rules.

*Out of scope (current version):*
- Direct WhatsApp Business API integration (submission happens via the FactStamp web app, not automatically inside WhatsApp itself).
- Server-side / cloud-hosted OCR or LLM-based automated fact-checking --- verification is deliberately human-driven and source-cited, not AI-generated.
- Multi-language OCR beyond the bundled Tesseract English model (Devanagari-script forwards can still be typed manually as text claims).
- Native mobile applications (the product is a responsive Progressive-style web application).

=== Applicability

FactStamp is directly applicable to any population that relies on WhatsApp as a primary information channel --- which, in the Indian context, spans nearly all demographics and age groups. It is particularly relevant to:
- *Families and community WhatsApp groups*, where health and financial-scheme misinformation disproportionately circulates among older, less digitally-literate members.
- *Civic and journalism organizations* that want a lightweight, embeddable verification workflow without building their own consensus infrastructure from scratch.
- *Educational contexts* (media-literacy programs) as a demonstrable, source-transparent example of how a claim moves from submission to verified consensus.

== Achievements

At the current stage of development, FactStamp has achieved a fully functional, deployable web application (not a paper prototype) with the following delivered capabilities, each traceable to real source files in the codebase (`/home/aadish/Documents/Github/FactStamp`):

- A complete Firebase-backed authentication and verifier-reputation system (`src/contexts/AuthContext.tsx`, `src/services/firebaseService.ts`), including standardized anti-enumeration error messaging and idle-session timeout enforcement.
- A working Jaccard-similarity duplicate-detection engine (`src/lib/duplicateDetection.ts`) with a tuned $>= 0.75$ threshold.
- A fully implemented weighted consensus and confidence-scoring engine (`src/lib/confidenceScore.ts`) --- `Confidence = (AgreementRatio × 0.40) + (AvgVerifierReputation × 0.30) + (SourceQualityScore × 0.30)` --- driving real-time verdict computation inside `src/contexts/ClaimsContext.tsx`, including automatic 7-day consensus-deadline expiry to `CONTESTED`.
- A client-side, WebAssembly-based OCR ingestion pipeline (`src/services/ocrService.ts`, Tesseract.js) with WhatsApp-chrome text cleanup and automatic category classification (Health / Political / Financial / Religious / Other) via keyword heuristics tuned for Indian WhatsApp forward phrasing.
- A shareable PNG fact-check card generator (`src/components/FactCheckCard.tsx`) using `html-to-image`, chosen specifically because it natively rasterizes OKLCH/OKLAB CSS colors that a legacy canvas-based parser could not handle.
- A Recharts-powered misinformation analytics dashboard (`src/pages/Dashboard.tsx`, `src/lib/weeklyReport.ts`) computing rolling 7-day category trends and top-verifier leaderboards.
- A staff-only Admin Command Center (`src/pages/Admin.tsx`, unlisted `/admin` route) with five operational tabs (System Overview, Verifier Directory, Claims Moderation, Incident Queue, Audit #sym.amp Tools) and dual-layer authorization (client-side re-check plus server-side `firestore.rules` `isAdmin()` enforcement).
- A defense-in-depth security module (`src/lib/security.ts`) covering OWASP-relevant vectors: XSS sanitization, verdict-explanation anti-spam validation, triple-layer file-upload validation (extension + MIME + magic-byte signature), 30-minute idle-session timeout, and a 5-attempt / 15-minute-lockout login rate limiter --- all backed by matching Firestore and Storage security rules.
- Multi-target deployment configuration: Firebase Hosting, Vercel, and a Docker + Nginx production image, each carrying its own strict Content-Security-Policy and security-header set (Firebase Hosting additionally sets HSTS and `Permissions-Policy`).

== Organisation of Report

This report is organized into seven chapters, following the official `JUSIT-DSCPR503` dissertation structure:

- *Chapter 1 --- Introduction* _(this chapter)_ establishes the background problem, objectives, purpose/scope/applicability, and achievements to date.
- *Chapter 2 --- Survey of Technologies* evaluates and justifies the technology stack: React 18, Vite 5, TypeScript 5.5, Tailwind CSS v4, Firebase v12, Framer Motion, Recharts, `html-to-image`, Tesseract.js, and the Docker/Vercel/Firebase Hosting deployment targets, against realistic alternatives.
- *Chapter 3 --- Requirements and Analysis* covers the problem definition, a formal IEEE 830-style requirements specification, Agile/Scrum planning and scheduling (PERT/Gantt), software and hardware requirements, and the full set of conceptual models (DFDs, ER diagram, Use Case, Class, Sequence, State, and other UML diagrams).
- *Chapter 4 --- System Design* documents the 8 core system modules, the Firestore data design and schema, procedural design (the Jaccard and weighted-consensus algorithms), UI design, security architecture, and test-case design.
- *Chapter 5 --- Implementation and Testing* describes the implementation approach, coding details and code efficiency, the unit/integration/beta testing strategy actually applied, and subsequent modifications and improvements.
- *Chapter 6 --- Results and Discussion* presents test reports and user documentation (role-based walkthroughs of every screen).
- *Chapter 7 --- Conclusions* reflects on the significance of the system, its honest limitations, and future scope. The References and a glossary of domain-specific terms follow as separate back matter after Chapter 7.
