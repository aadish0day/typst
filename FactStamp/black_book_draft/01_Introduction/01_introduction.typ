= Introduction

== Background

With hundreds of millions of daily active users across India, WhatsApp is a primary channel for unverified forwarded messages. Because the platform enforces end-to-end encryption and messages circulate across private group chats, false claims concerning public health, politics, government schemes, or financial fraud spread rapidly beyond the observation of search engines, indexers, and platform moderation. Conventional web-based fact-checking requires readers to actively seek out debunking articles on the open web. By the time an investigative article is researched, published, and indexed on search engines, the misleading claim has already propagated through multiple generations of chat forwards.

Current approaches to addressing WhatsApp misinformation suffer from distinct operational limitations:

1. *Institutional fact-checkers* (such as newsrooms, PIB Fact Check, and independent verification agencies) produce rigorous analyses but operate with small editorial teams. They cannot keep pace with the daily volume of regional forwards, and their long-form web articles rarely circulate back into the private chat channels where the rumor originated.
2. *Ad-hoc peer debunking* in chat threads (such as a group participant replying that a post is false) is immediate but unstructured. It leaves no durable record, provides no verifiable citations, and cannot recognize previously evaluated claims when rephrased.

FactStamp bridges these two models through a community verification workflow. When a user submits a forwarded message as plain text or as a screenshot, the system checks whether the claim matches an existing entry in the verified corpus. New claims enter an open verification queue where authenticated community participants evaluate evidence, cite authoritative sources, and record verdicts. Once a quorum of three independent verifications is reached, the system computes a weighted consensus confidence score and renders an exportable fact-check card formatted as a PNG image. The submitter can then share this card directly back into the originating WhatsApp group.

== Objectives

The project addresses the following engineering and research objectives:

1. Shorten the verification cycle for suspicious WhatsApp forwards by enabling direct community submission rather than relying exclusively on centralized editorial desks.
2. Prevent redundant verification effort by calculating Jaccard token-overlap similarity ($J >= 0.75$) against the existing claim corpus, resolving reworded duplicates to existing verdicts.
3. Enforce a distributed quorum requirement rather than single-moderator authority, mandating at least three independent verifications before a verdict settles.
4. Weight consensus confidence through verifiable evidence metrics, factoring in verifier agreement, verifier historical reputation, and cited source authority (`src/lib/confidenceScore.ts`).
5. Provide a shareable counter-artifact in the visual medium of the forward, generating a 1080 px-wide PNG card (540 CSS px at 2#text[×] pixel ratio via `html-to-image`) with content-adaptive height for direct forwarding in chat threads.
6. Minimize submission friction for non-technical users by extracting claim text from screenshots via client-side WebAssembly OCR (Tesseract.js) and stripping WhatsApp interface artifacts such as timestamps and message status indicators.
7. Maintain verifier accountability through an incentive-aligned reputation mechanism that updates participant scores based on alignment with finalized consensus.
8. Publish platform-wide misinformation trends through a public analytics dashboard displaying category distributions and weekly debunks.

== Purpose, Scope, and Applicability

=== Purpose

FactStamp provides a community-driven verification platform designed specifically for WhatsApp forwards. It reduces the turnaround time between the appearance of an unsubstantiated forward and the availability of a sourced, shareable correction, without requiring dedicated editorial infrastructure.

=== Scope

*In scope:*
- Submitting a claim as text or a WhatsApp screenshot using client-side OCR.
- Detecting duplicates against existing claims.
- A verification queue requiring at least three verifiers.
- A confidence-scoring engine using agreement ratio, verifier reputation, and source quality.
- Automatic consensus expiry, settling unresolved claims as `CONTESTED` after 7 days.
- Generating shareable PNG fact-check cards.
- A public analytics dashboard for misinformation trends.
- Firebase Authentication (email/password and Google OAuth) with verifier profiles.
- A staff `/admin` moderation console for managing users, claims, and incident reports, with an audit log.
- Client-side security including rate-limited login, file-upload validation, anti-spam filtering, and XSS sanitization, backed by Firestore Security Rules.

*Out of scope (current version):*
- WhatsApp Business API integration. Users submit claims through the web app.
- Server-side OCR or automated algorithmic fact-checking. Verification relies on human participants.
- Multi-language OCR beyond the English model. Users can type Devanagari-script forwards manually.
- Native mobile applications. The system is deployed as a responsive web application.

=== Applicability

FactStamp is designed for communities and individuals who rely on WhatsApp as an everyday communications medium. In India, this spans diverse demographics and age groups:
- Family and neighborhood WhatsApp groups where health remedies, communal rumors, and financial schemes circulate.
- Civic and journalism collectives requiring a structured, open-source verification pipeline.
- Educational media-literacy programs demonstrating evidence-based evaluation workflows.

== Achievements

FactStamp is a functional, deployable web application. The codebase (`/home/aadish/Documents/Github/FactStamp`) provides the following implementations:

- A Firebase-backed authentication and verifier-reputation system (`src/contexts/AuthContext.tsx`, `src/services/firebaseService.ts`) with anti-enumeration error messaging and idle-session timeout protection.
- A Jaccard-similarity duplicate-detection engine (`src/lib/duplicateDetection.ts`) operating at a $>= 0.75$ threshold.
- A confidence-scoring engine (`src/lib/confidenceScore.ts`) that computes `Confidence = (AgreementRatio × 0.40) + (AvgVerifierReputation × 0.30) + (SourceQualityScore × 0.30)`. It computes verdicts in real time in `src/contexts/ClaimsContext.tsx` and settles unresolved claims as `CONTESTED` after a 7-day window.
- A client-side WebAssembly OCR pipeline (`src/services/ocrService.ts`, Tesseract.js) that normalizes WhatsApp interface noise and categorizes submissions through keyword heuristics.
- A PNG fact-check card generator (`src/components/FactCheckCard.tsx`) using `html-to-image` with native support for OKLCH and OKLAB CSS color palettes.
- An analytics dashboard (`src/pages/Dashboard.tsx`, `src/lib/weeklyReport.ts`) using Recharts to compute rolling 7-day category distributions and verifier leaderboards.
- An Admin Command Center (`src/pages/Admin.tsx`, `/admin` route) with five operational tabs: System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit #sym.amp Tools, secured by client route guards and server-side `firestore.rules` `isAdmin()` verification.
- A security module (`src/lib/security.ts`) covering XSS sanitization, anti-spam heuristics, magic-byte file validation, a 30-minute idle session timeout, and login rate limiting.
- Production deployment configurations for Firebase Hosting, Vercel, and a self-hosted Docker + Nginx container, each configured with Content-Security-Policy, HSTS, and related HTTP security headers.

== Organisation of Report

This report has seven chapters and follows the `JUSIT-DSCPR503` dissertation structure:

- *Chapter 1: Introduction* _(this chapter)_ explains the background problem, objectives, purpose, scope, applicability, and features.
- *Chapter 2: Survey of Technologies* details the technology stack: React 18, Vite 5, TypeScript 5.5, Tailwind CSS v4, Firebase v12, Framer Motion, Recharts, `html-to-image`, Tesseract.js, and the Docker/Vercel/Firebase Hosting deployment targets.
- *Chapter 3: Requirements and Analysis* contains the problem definition, an IEEE 830-style requirements specification, project scheduling, hardware/software requirements, and conceptual models like DFDs and UML diagrams.
- *Chapter 4: System Design* outlines the 8 core modules, Firestore data schema, procedural design, UI design, security architecture, and test-case design.
- *Chapter 5: Implementation and Testing* explains the code structure, testing strategy, and modifications made during development.
- *Chapter 6: Results and Discussion* contains test reports and user documentation.
- *Chapter 7: Conclusions* discusses system limitations and future work. The References and a glossary appear after Chapter 7.
