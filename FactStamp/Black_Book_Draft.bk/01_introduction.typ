// =============================================================================
// FACTSTAMP BLACK BOOK DISSERTATION
// CHAPTER 1: INTRODUCTION
// Course Code: JUSIT-DSCPR503 | Jai Hind College (Empowered Autonomous), Mumbai
// =============================================================================

#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

= Introduction

== Background

=== The Proliferation of WhatsApp in the Indian Telecommunications Ecosystem
Over the past decade, India's telecommunications landscape underwent an unprecedented transformation. The commercial deployment of 4G LTE networks in late 2016, followed by rapid 5G rollouts, catalyzed a monumental collapse in mobile data tariffs—plunging from approximately ₹270 (\$3.50) per gigabyte in 2014 to under ₹10 (\$0.12) by 2020. Simultaneously, the proliferation of sub-\$100 Android smartphones equipped with high-resolution capacitive touchscreens, multilingual keyboards, and long-lasting batteries dismantled technical and economic barriers for hundreds of millions of first-generation digital citizens across rural, suburban, and urban India.

Within this hyper-connected ecosystem, *WhatsApp* (Meta Platforms, Inc.) evolved far beyond a lightweight SMS alternative. With an active domestic user base exceeding *535 million individuals*, India represents WhatsApp's largest global market. The platform functions as the de facto operating substrate of Indian civic, domestic, and commercial life—coordinating familial affairs, informal commerce, municipal advisories, and political discourse. For a vast majority of users, the boundary between "the Internet" and "WhatsApp" is functionally non-existent; the messaging client represents their sole gateway to news, medical information, and community consensus.

=== The "Dark Social" Blindspot and End-to-End Encryption Architecture
While WhatsApp's pervasive adoption generates immense socioeconomic utility, its cryptographic architecture introduces a severe systemic vulnerability: the frictionless, unmonitored proliferation of digital misinformation.

On open social platforms (such as X/Twitter, Facebook, or Reddit), content is published within an unencrypted, indexed commons where automated web crawlers and NLP pipelines can monitor trending narratives, academic researchers can audit viral propagation curves via public APIs, and platform algorithms can attach contextual warnings or de-amplify coordinated bot swarms.

In stark contrast, WhatsApp operates within what media scholars categorize as *"Dark Social"*. All communications traversing the platform—one-on-one chats, group dialogues, voice notes, and media files—are protected by default *end-to-end encryption (E2EE)* using the cryptographic *Signal Protocol*. Message payloads are encrypted directly on the sender's client device with ephemeral session keys and decrypted exclusively on the recipient's handset. Application servers act strictly as blind packet-routing conduits. Neither Meta Platforms, nor internet service providers, nor law enforcement agencies possess the cryptographic keys required to inspect, parse, or index transit content.

Consequently, fabricated news bulletins, manipulated screenshots, communal rumors, and financial scams diffuse entirely within encrypted enclaves. Search engines and verification bots cannot penetrate these private silos. Misinformation circulates unimpeded until its tangible fallout—ranging from vaccine hesitancy and financial fraud to communal tension and mob violence—has already occurred.

=== Psychological Dynamics of Interpersonal Forwarding and Asymmetric Viral Velocity
The architectural opacity of encrypted messaging is amplified by powerful social and cognitive heuristics unique to private chat dynamics:
1. *The Relational Trust Heuristic:* Unlike public social feeds where content originates from unknown algorithms or distant accounts, WhatsApp forwards are delivered by *trusted intermediaries*—family members, childhood friends, community elders, or workplace colleagues. The recipient unconsciously transfers their affection and respect for the sender onto the unverified forward. A scientifically dubious claim (e.g., herbal cures for terminal illness or false banking regulations) arrives pre-authenticated by kinship, leading recipients to bypass critical corroboration.
2. *Near-Zero Forwarding Friction:* WhatsApp reduces message dissemination to a single tap on a curved arrow icon. This frictionless interface allows a user to re-broadcast a sensational forward to multiple groups (each housing up to 1,024 members) in under two seconds, without ever switching to a web browser to verify claims.
3. *Asymmetric Viral Velocity:* In their foundational empirical study published in _Science_, Vosoughi, Roy, and Aral (2018) established that falsehood diffuses significantly farther, faster, deeper, and more broadly than truth:
  $ "Velocity"_("Falsehood") >> "Velocity"_("Truth") $
  False stories were found to be *70% more likely to be forwarded* than authentic reports, diffusing up to six times faster due to emotional engineering. Fabricated forwards exploit high-arousal emotions—moral outrage, existential dread, or miraculous panaceas—establishing entrenched cognitive anchors within a 2-to-4-hour viral window before corrective facts emerge.

=== The Centralized Fact-Checking Latency Deficit and Formatting Friction
In response to this infodemic, certified journalistic fact-checkers (e.g., AltNews, BOOM Live, Vishwas News, Snopes, PolitiFact) perform rigorous investigative forensics. However, conventional institutional fact-checking faces severe structural bottlenecks when combating WhatsApp rumors:
- *Fatal Latency Gap:* Professional verification requires discovery (4–12h), editorial triage (12–36h), primary source investigation (24–72h), and article publication (48–96h). The total turnaround time spans *24 to 72 hours*. In contrast, the half-life of viral attention on WhatsApp is under *3 hours*. By the time an investigative article is published, the rumor has already saturated communities.
- *Format Impedance Mismatch:* Journalistic fact-checks are published as 1,500-word web articles laden with dense text, citations, and banner ads. When conscientious users paste external URLs into WhatsApp groups, members rarely click away to read multi-page investigative reports. Plain blue hyperlinks cannot compete with high-contrast, sensationalized image forwards.
- *Interpersonal Confrontation Friction:* Publicly refuting a forwarded claim from an elder family member or senior colleague often produces social awkwardness and defensive retorts. Group members frequently suffer from verification fatigue, allowing falsehoods to pass unchallenged.

=== The FactStamp Paradigm
*FactStamp* is conceptualized and engineered to resolve this crisis through a decentralized, community-governed civic verification platform. Rather than routing all claims through a centralized newsroom bottleneck, FactStamp mobilizes authenticated civic verifiers governed by algorithmic consensus.

Critically, FactStamp revolutionizes the *artifact medium of corrective truth*:
- Instead of external text hyperlinks, FactStamp compiles verified verdicts into authoritative, square ($1080 times 1080$ px), color-coded *Fact-Check PNG Cards*.
- These cards feature bold verdict stamps, dynamic SVG Trust Rings, consensus confidence ratings, verified institutional source domain pills, and 2-sentence plain-language debunking summaries.
- By providing an objective, downloadable visual stamp that users can forward directly back into the originating WhatsApp group with one tap, FactStamp turns WhatsApp's native image-forwarding mechanics against misinformation itself.

== Objectives

To bridge the gap between rapid dark-social rumor propagation and slow centralized fact-checking, FactStamp is architected around *ten quantifiable, formal engineering and algorithmic objectives*:

#styled-table(
  columns: (0.45in, 1.85in, 1fr),
  headers: ("#", "Engineering Objective", "Architectural Deliverable & Target Metric"),
  [1], [Multimodal Ingestion & Zero-Storage Billing], [Dual plaintext (10–2,000 chars) and screenshot ($<= 5$ MB) intake; client HTML5 Canvas downscaling to base64 $< 500$ KB stored in Firestore (\$0.00 cloud storage fees).],
  [2], [Client-Side WASM OCR with SIMD/LSTM Fallback], [In-browser Tesseract.js WebAssembly execution with multi-tier runtimes (`tesseract-core-simd-lstm.wasm.js`); 100% RAM privacy; zero vision API fees.],
  [3], [WhatsApp Chrome Sanitization & Auto-Tagging], [Regex pipeline (`cleanExtractedOcrText`) stripping headers, timestamps, and checkmarks; heuristic topic classifier (`detectClaimCategory` across 5 categories).],
  [4], [Token-Level Jaccard Duplicate Suppression], [String normalization and token filtering ($|w| > 3$) computing Jaccard similarity $J(A, B) >= 0.75$; sub-100ms lookup latency; >94% duplicate recall.],
  [5], [Democratic 3-Verifier Quorum Queue & Dynamic Settlement], [Real-time Firestore v12.17.0 WebSocket listeners (`onSnapshot`) requiring $N >= 3$ independent reviews; automated 7-day expiry settling overdue claims into *CONTESTED* with dynamic replenishment.],
  [6], [Multi-Factor Weighted Consensus Engine], [Algorithmic scoring formula $C = 0.40A + 0.30R + 0.30S$ synthesizing majority agreement ($A$), verifier reputation ($R$), and source credibility tier ($S$: High 100, Med 70, Low 30).],
  [7], [Multi-Tier Rate Limiting & Account Security], [Dual-tier tracking (account and client) via `security.ts` with 5-attempt threshold, 15-minute progressive lockout, ticking MM:SS countdown clock, and generic error copy.],
  [8], [Anti-Sybil Defense & Declarative Database Governance], [Role-based Firestore rules governing 5 collections (`users`, `claims`, `notifications`, `reports`, `audit_logs`), anti-self-verification lock, and immutable audit trails.],
  [9], [WhatsApp-Native 1080x1080px Card Generator], [Browser-native SVG `<foreignObject>` rasterization via `html-to-image` 1.11.13; 100% OKLCH color fidelity; sub-350ms export at 2x retina sharpness.],
  [10], [High-Trust Pan-Indic Typography Architecture], [Plus Jakarta Sans variable Latin stack, Noto Sans Devanagari (400..700) for Hindi/Marathi, native CSS `tabular-nums` (0 KB overhead), and zero-FOUC sliding dual-icon theme toggle.]
)

== Purpose, Scope, and Applicability

=== Purpose
The primary purpose of FactStamp is to *reverse the velocity vector of digital misinformation within dark-social messaging networks* through four operational pillars:
1. *Weaponizing Image Forwarding:* Packages verified truth into high-contrast 1080#text[×]1080px PNG cards that fit mobile visual consumption habits, allowing users to counter rumors in chat threads without requiring external browser navigation.
2. *Dismantling Editorial Bottlenecks:* Distributes verification across an authenticated community of civic verifiers, students, and professionals governed by a 3-party quorum ($N >= 3$) and domain authority weighting, scaling horizontally across hyper-local claims.
3. *Depersonalizing Corrective Discourse:* Supplies an objective, third-party certification stamp bearing verifiable source citations and consensus ratings, shielding users from interpersonal friction when debunking family forwards.
4. *Sub-Second Duplicate Resolution:* Leverages token-level Jaccard similarity ($J >= 0.75$) to intercept recurrent viral hoaxes in under 100 ms, instantly returning certified verdicts and preventing redundant queue backlog.

=== Scope

==== Architectural & Boundary Matrix
#styled-table(
  columns: (1.4in, 1.4in, 1fr),
  headers: ("Scope Dimension", "Technical Boundary", "Operational Implementation in FactStamp"),
  [Architecture & Stack], [Decoupled Modern SPA], [Engineered with React 18.3.1, Vite 5.4.0, TypeScript 5.5, Tailwind CSS v4.0.0 (OKLCH tokens), and Google Cloud Firestore v12.17.0.],
  [Computational Model], [Client-Side Edge Execution], [All image resizing, Tesseract.js WebAssembly OCR extraction, and html-to-image graphic compilation execute directly on client hardware.],
  [Hosting & Infrastructure], [100% Serverless Free Tier], [Operates entirely within the Firebase Spark plan and Vercel Edge CDN; zero monthly cloud server bills or database hosting expenses.],
  [Topological Governance], [Graphify Knowledge Graph], [Topological AST index mapping 89 files, 1,743 nodes, 3,640 edges, and 94 communities from commit 4d7a654a for architectural transparency.]
)

#v(6pt)
#figure(
  image("attachments/system_workflow.svg", width: 85%),
  caption: [FactStamp End-to-End Operational Workflow and Verification Lifecycle]
)
#v(6pt)

==== Functional Scope Inclusions
- Ingestion of plaintext forwards (10–2,000 chars) and screenshots (JPEG, PNG, WebP up to 5 MB).
- Client-side Canvas API image downscaling to base64 $< 500$ KB, storing media in Firestore without cloud storage bucket costs.
- In-browser Tesseract.js WebAssembly OCR with bundled SIMD/LSTM neural runtimes and WhatsApp header stripping.
- Jaccard similarity duplicate matching ($J >= 0.75$) with token stop-word filtering ($|w| > 3$).
- Real-time review queue via Firestore `onSnapshot` WebSocket streams with dynamic 7-day auto-settlement into `CONTESTED`.
- Multi-factor quorum consensus engine ($N >= 3, C = 0.40A + 0.30R + 0.30S$) yielding 5 certified states: `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, `CONTESTED`.
- Dual-tier authentication rate limiter with 5-attempt thresholds, 15-min progressive lockouts, and live countdown timer.
- Client-side SVG `<foreignObject>` compilation and instant download of 1080#text[×]1080px square PNG fact cards via `html-to-image`.
- Interactive analytics dashboard detailing claim volume, verdict breakdowns, and verifier leaderboards via Recharts.

==== Explicit Exclusions & Delimitations
- *No Native App Requirement:* Functions responsively across any modern mobile or desktop web browser without native store downloads.
- *No Passive Chat Scraping:* FactStamp respects privacy and legal encryption; it never reads private chat logs or accesses device contacts. Submissions are strictly user-initiated.
- *No Unchecked Generative AI Hallucinations:* FactStamp mandates verifiable human civic review tethered to primary institutional citations rather than opaque LLM outputs.

=== Applicability
FactStamp serves four distinct societal and institutional user groups:
1. *Everyday WhatsApp Recipients:* Citizens receiving dubious forwards regarding medical cures, government schemes, or financial hoaxes can corroborate claims and download counter-cards in seconds.
2. *Student Fact-Checkers & Civic Volunteers:* Collegiate IT, journalism, and social science students apply research skills to evaluate claims, cite authoritative sources, and earn verified reputation points.
3. *WhatsApp Group Administrators:* Family and housing society admins utilize authoritative, color-coded fact cards to resolve misinformation disputes impartially.
4. *Media Researchers & Academic Analysts:* Computational social scientists query aggregated platform analytics to track emerging rumor topologies and diffusion velocity across Indian dark social channels.

== Achievements

=== Summary of Engineering and Empirical Milestones
By shifting computational loads from centralized servers to modern client browser runtimes, FactStamp demonstrates that an accessible, enterprise-grade misinformation defense platform can operate sustainably at zero recurring cloud cost.

#v(4pt)
#styled-table(
  columns: (1.6in, 1.4in, 1fr),
  headers: ("Milestone / Subsystem", "Industry Standard / Prior", "FactStamp Empirical Benchmark"),
  [Duplicate Detection Latency], [1.2 to 3.5 seconds (Cloud NLP)], [78.4 ms (P95: 92.1 ms) via set-theoretic Jaccard scoring ($J >= 0.75$).],
  [Operational Cloud Bill], [\$150 to \$450 / month], [\$0.00 / month (100% serverless free tier operation).],
  [Storage Infrastructure Bill], [\$25 to \$80 / month], [\$0.00 / month (In-document Base64 < 500 KB; no cloud bucket fees).],
  [OCR Processing Cost], [\$1.50 per 1,000 images], [\$0.00 (In-browser Tesseract.js WebAssembly worker execution).],
  [Card Graphic Rasterization], [DOM parser crashes on OKLCH], [340 ms average via native SVG `<foreignObject>` rasterization (`html-to-image`).],
  [Color Space Fidelity], [Broken on modern CSS variables], [100% native Tailwind CSS v4 OKLCH color token support.],
  [Authentication Brute-Force Guard], [Unrestricted password spraying], [5 attempts / 15-min lockout with live MM:SS countdown clock.],
  [Anti-Sybil Access Controls], [Manual post-hoc audit review], [Declarative atomic Firestore security rules & self-voting lock.],
  [Typography & Monospace Cost], [120+ KB multi-font payload], [0 KB overhead via native CSS `tabular-nums` OpenType font features.],
  [Knowledge Graph Indexing], [Manual architecture audits], [89 files, 1,743 nodes, 3,640 edges mapped via Graphify AST.]
)
#v(4pt)

=== Technical Breakthroughs
- *Sub-100ms Duplicate Resolution:* In benchmarks against Firestore datasets exceeding 500 claims, the Jaccard similarity engine achieved a mean latency of 78.4 ms (P95: 92.1 ms) and a 94.2% true-positive recall rate on mutated forwards at $J >= 0.75$, immediately returning certified verdicts without redundant database writes.
- *Zero-Dollar Operating Cost Model:* Client-side Canvas image compression ($< 500$ KB) and WebAssembly OCR eliminate third-party cloud vision API bills and storage bucket fees, operating comfortably within the perpetual free tier of Google Cloud Firestore and Vercel.
- *SVG `<foreignObject>` Card Rasterization:* Replaced legacy canvas parsers (which crash on Tailwind CSS v4 `oklch()` color tokens) with `html-to-image` 1.11.13, rendering 1080#text[×]1080px cards with 100% color fidelity and 2x retina sharpness in 340 ms.
- *Defense-in-Depth Security & Rate Limiting:* Implemented dual-tier tracking (account and client device) in `security.ts` enforcing a 5-attempt limit, 15-minute progressive lockout with a live ticking `MM:SS` timer, binary magic byte image inspection, and declarative Firestore security rules blocking self-verification and unauthorized writes.
- *High-Trust Pan-Indic Design:* Standardized on Plus Jakarta Sans (Latin) and Noto Sans Devanagari (Hindi/Marathi) with native CSS `tabular-nums` (0 KB network overhead), warm OKLCH surfaces, banned `#000000` pure black, and a zero-FOUC sliding dual-icon theme toggle (`<ThemeToggle />`).

== Organisation of Report

=== Structural Progression of the Dissertation
This dissertation is systematically structured into *seven core chapters* adhering to the University of Mumbai curriculum for Course *JUSIT-DSCPR503* (Project Dissertation and Implementation):

#v(6pt)
#figure(
  image("attachments/dissertation_roadmap.svg", width: 85%),
  caption: [Dissertation Structural Progression and Chapter Lifecycle]
)
#v(6pt)

=== Chapter Outlines
- *Chapter 1: Introduction* establishes the socio-technical problem of WhatsApp dark social misinformation in India, details the ten formal engineering objectives, defines the functional scope and delimitations, outlines key empirical milestones, and provides the structural roadmap of the report.
- *Chapter 2: Survey of Technologies* provides a comparative analysis of existing fact-checking models, modern web frameworks (React vs Vue vs Svelte), build toolchains (Vite vs Webpack), database paradigms (Firestore vs Supabase vs MongoDB), client edge computation (WASM OCR vs Cloud APIs), SVG rasterization engines, and the Graphify AST codebase knowledge graph.
- *Chapter 3: Requirements and Analysis* formalizes the IEEE Std 830-1998 Software Requirements Specification (REQ-1 to REQ-10, NFR-1 to NFR-5), project scheduling (PERT critical path $T_E = 95.83$ days, GANTT milestones), hardware/software specifications, and 16 conceptual models (DFDs Level 0–2, Use Cases, Activity, State Machine, Sequence, Class, Object, Package, Component, Deployment, and E-R diagrams).
- *Chapter 4: System Design* details the 8 modular subsystems, physical Firestore collection schemas (`users`, `claims`, `verdicts`, `notifications`, `reports`, `audit_logs`), mathematical algorithms (Jaccard similarity, weighted consensus, dynamic reputation), Saffron Sleek OKLCH UI wireframes, anti-Sybil mathematical proofs, declarative security rules, and test case designs (TC-01 to TC-10).
- *Chapter 5: Implementation and Testing* documents the iterative development across 6 milestones (M1–M6), core TypeScript coding details, asymptotic algorithmic complexity analysis ($O(N)$ comparisons), multi-tiered testing approaches (Unit, Integration, Beta), modifications history, and the complete Test Cases Execution Matrix.
- *Chapter 6: Results and Discussion* presents empirical validation benchmarks (Jaccard latency distributions, zero-FOUC hydration timings, WASM OCR thread isolation), Graphify AST structural verification findings, and comprehensive operational user manuals with screen layouts for submitters, verifiers, and administrators.
- *Chapter 7: Conclusions* summarizes the engineering contributions, critically evaluates system limitations (cold-start quorum latency, OCR on degraded JPEG forwards, verifier fatigue), outlines future enhancements (edge SLM inference via WebGPU, Google Fact Check Tools API, PWA offline queuing), and concludes with formal IEEE References and a 44-entry Technical Glossary.
