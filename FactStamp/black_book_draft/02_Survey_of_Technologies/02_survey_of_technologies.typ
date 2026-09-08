#import "../lib/helpers.typ": *

= Survey of Technologies

This chapter surveys the architecture patterns, frameworks, libraries, and algorithmic consensus models evaluated for FactStamp, and justifies the specific technology chosen at every layer of the system against three central project constraints: (a) the system must run entirely on the Firebase free tier with no paid backend or dedicated DevOps budget, (b) Optical Character Recognition must work at zero external API cost and without sending user screenshots to a third-party cloud service, and (c) the shareable PNG fact-check card export must correctly render modern CSS color functions (`oklch()`/`oklab()`) used throughout the design system. Every library version, function name, threshold, and formula cited in this chapter is verified directly against the FactStamp source tree.

== Web Architectures

Before any individual library or framework can be justified, the project's foundational architectural pattern has to be chosen — that choice constrains almost everything downstream. This section surveys standard web application architecture patterns, then justifies the combination FactStamp adopted: a client-heavy React Single Page Application (SPA) backed entirely by Firebase as a Backend-as-a-Service (BaaS), with no custom REST/GraphQL server anywhere in the stack.

=== Survey of Application Delivery Patterns

*Multi-Page Application (MPA).* The traditional model — every navigation is a full page load, with the server rendering a new HTML document per route. Simple to reason about and SEO-friendly by default, but poorly suited to an app like FactStamp where verifiers, submitters, and the analytics dashboard all need live, real-time-updating views (a claim's confidence score changing as new verifications arrive) without a full page reload.

*Server-Side Rendering (SSR) / Hybrid frameworks* (e.g. Next.js, Remix). Render the initial page on the server for fast first paint and SEO, then hydrate into a client-side app for subsequent interaction. This is the right choice when SEO and time-to-first-byte are dominant concerns, but it requires a Node.js server runtime (or a serverless function per route) to do the rendering — infrastructure FactStamp explicitly wanted to avoid provisioning and operating.

*Single Page Application (SPA).* The entire UI is a client-side JavaScript application; the server (or a static host) serves one HTML shell plus a JS/CSS bundle, and all navigation and rendering happens in the browser via a client-side router. This trades away default SEO and first-paint speed for a much simpler deployment model and the ability to do heavy client-side computation — which matters directly for FactStamp, since OCR extraction and PNG card rasterization both need to run in the browser regardless of the architecture chosen elsewhere.

*Backend-as-a-Service (BaaS) vs. a custom server.* A custom Node/Express backend gives full control over business logic, but that control has to be paid for: writing and maintaining authentication, authorization middleware, a database access layer, and hand-rolled WebSocket or polling infrastructure for real-time updates. A BaaS platform (Firebase, Supabase, AWS Amplify) instead exposes authentication, a database, and file storage as managed services accessed directly from the client, with server-side authorization enforced declaratively (security rules) rather than imperatively (route handler code).

=== FactStamp's Architecture: React SPA + Firebase BaaS

FactStamp is a pure client-heavy Single Page Application backed entirely by Firebase as a Backend-as-a-Service — there is no custom REST/GraphQL server anywhere in the deployed system. This ruled out SSR/hybrid frameworks outright — they need a server runtime FactStamp has no budget to operate — and it made a custom backend unnecessary rather than merely undesirable: FactStamp's real-time requirements (a live-updating verification queue, live notification badges, live leaderboards) map directly onto Firestore's `onSnapshot` real-time listener primitive, which a hand-rolled backend would otherwise have to reimplement with WebSocket infrastructure from scratch.

Firebase supplies the three backend concerns a custom server would normally own:
- *Firebase Authentication* handles email/password and Google OAuth sign-in, removing the need to implement password hashing, session tokens, or OAuth handshake logic.
- *Cloud Firestore* (NoSQL document store) holds the `users`, `claims`, `notifications`, `reports`, and `audit_logs` collections that the application reads and writes directly from the browser.
- *Firestore Security Rules* (`firestore.rules`) take over the authorization role a server's route middleware would normally play — every write path is validated server-side so the client-side consensus logic in `ClaimsContext.tsx` cannot be bypassed by a malicious client writing directly to the Firestore REST API.

Because there is no application server, all client-heavy computation that would otherwise be offloaded to a backend — OCR text extraction, image compression, PNG card rasterization, the Jaccard duplicate check, and the weighted consensus calculation — runs in the browser instead. This is the direct consequence of choosing BaaS over a custom server, and it is why "client-side" is a recurring theme across nearly every technology decision in this chapter.

=== Deployment Targets

A BaaS-backed SPA compiles down to static assets, which means the backend and the hosting are decoupled. FactStamp is deployable to three interchangeable targets, each configured with a strict security-header set (Content-Security-Policy, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`); Firebase Hosting additionally sets HSTS and `Permissions-Policy`, and the Nginx target carries a slightly narrower CSP than the Firebase/Vercel one:

- *Firebase Hosting* (`firebase.json`) — the natural default, since Firestore/Auth/Storage are already Firebase services; supports the Firebase Local Emulator Suite (Auth `:9099`, Firestore `:8080`, Storage `:9199`, Emulator UI `:4000`) for fully offline development and CI.
- *Vercel* (`vercel.json`) — an alternative static-hosting target with equivalent rewrite/header configuration, useful for preview-deployment workflows.
- *Docker + Nginx* (`Dockerfile`, `docker-compose.yml`, `nginx.conf`) — a multi-stage build (Node 20 build stage producing static assets, served by an `nginx:1.27-alpine` stage) for environments where Firebase/Vercel hosting is not an option, such as on-prem or restricted-network deployment for an institutional partner.

Having three interchangeable static-hosting targets rather than one is only possible because the architecture pushed all statefulness into Firebase; a custom server architecture would have coupled the backend logic to wherever that server process runs, closing off this flexibility.

== Frontend Frameworks

=== UI Framework — React 18.3.1

React was selected over alternatives (Vue 3, Svelte, Angular) primarily for its mature ecosystem of Firebase bindings and its Context API, which turned out to be sufficient to manage all application state (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, `UsersContext`) without pulling in an external state-management library like Redux or Zustand — the app's state graph is shallow enough (five independent, loosely-coupled concerns) that Context plus `useReducer`-style callbacks avoid Redux's boilerplate cost entirely.

=== Type Safety — TypeScript 5.5

TypeScript 5.5 in strict mode (`tsc -b` as the build's type-checking gate before Vite bundles anything) was non-negotiable given the amount of Firestore document shape-normalization the application performs (`mapFirestoreDocToClaim` in `src/services/firebaseService.ts`). Firestore is schemaless at the database level, so nothing stops a malformed or legacy-shaped document from reaching the client; strict TypeScript interfaces (`src/lib/types.ts`) turn that class of bug into a compile-time error instead of a runtime data-corruption incident inside the consensus computation.

=== Build Tooling — Vite 5.4

Vite was chosen over Create React App (now deprecated) and a hand-configured Webpack setup for its native ES-module dev server (near-instant Hot Module Replacement) and its first-class Rollup-based production build. `vite.config.ts` configures explicit manual chunk-splitting (`vendor-react`, `vendor-firebase`, `vendor-ui`, `vendor-charts`, `vendor-html-to-image`, `vendor-ocr`) so the large, rarely-changed Tesseract.js and Firebase SDK bundles stay cacheable independently of frequently-changed application code — directly reducing repeat-visit load time. The dev server is also configured with the same strict security headers (`X-Frame-Options`, CSP, `X-Content-Type-Options`) used in production, so security-header regressions are visible in local development rather than only surfacing after deployment.

=== Animation Layer — Framer Motion 12

Framer Motion supplies the JavaScript-driven half of the "tactile stamp" motion language described in the project's design system: staggered section reveals on the landing page (`src/pages/Home.tsx`, `staggerChildren`), spring-physics panel and progress-bar mounts on the verifier profile (`src/pages/Profile.tsx`), and the multi-state `LoadingButton` transition machine (`src/components/ui/LoadingButton.tsx`). The purely declarative half of the same motion language stays in CSS — the verdict stamp's impact animation (scale 1.35× down to 1.0×, slight rotation, fast-in/slow-out easing) is a `@keyframes stamp-press` rule in `src/index.css` applied by `src/components/VerdictStamp.tsx`, and the sliding dual-icon theme toggle reused across the Navbar, Footer, authentication layout, and Admin console (`src/components/ui/ThemeToggle.tsx`) is a plain Tailwind transition. Framer Motion was chosen for the remaining interactions because sequencing, interruption handling, and physics-based easing curves are what plain CSS keyframes cannot express cleanly.

== Styling and Design Tokens

=== Tailwind CSS v4

Tailwind v4's new `@tailwindcss/vite` plugin — CSS-native configuration, no separate `tailwind.config.js` file, no PostCSS pipeline — was adopted for its OKLCH-based design-token system, which underlies the entire "warm editorial" visual language documented in the project's `DESIGN.md`: a warm-cream background palette, saffron brand accents, and five verdict-semantic colors (True / False / Misleading / Unverifiable / Contested), each double-encoded with an icon so verdict meaning never depends on color alone.

=== Why OKLCH Over Traditional Color Spaces

OKLCH (Lightness, Chroma, Hue in the Oklab perceptual color space) was chosen over `rgb()`/`hsl()` because it is perceptually uniform — a given step change in the lightness channel produces a visually consistent brightness change across every hue, which is what makes it possible to generate an entire color ramp programmatically and have every step look evenly spaced to the eye. The trade-off is that `oklch()`/`oklab()` are relatively new CSS Color Level 4 functions, not every rendering pipeline understands them — a fact directly relevant later in this chapter (§2.6), where it is the reason a legacy canvas-based card export parser had to be replaced entirely.

=== Utility Class Composition — `clsx` + `tailwind-merge`

Conditional Tailwind class construction can easily produce class-string conflicts, where two conditionally-applied classes both target the same CSS property. `clsx` composed with `tailwind-merge` (which understands Tailwind's utility namespaces and resolves conflicts by keeping the last conflicting utility) is wrapped in a single `cn()` helper in `src/lib/utils.ts`, used across the entire component library to resolve conditional class conflicts cleanly.

== Cloud Databases

=== Firebase v12 as the Sole Backend

Firebase (Auth, Firestore, Storage) is FactStamp's entire backend — a deliberate choice to avoid building and operating a custom server for a project with no dedicated DevOps budget. It was chosen over a custom Node/Express + PostgreSQL stack for one dominant reason: the project's real-time requirements map directly onto Firestore's `onSnapshot` real-time listener primitive, which a custom stack would otherwise have to reimplement with hand-rolled WebSocket infrastructure.

- *Firebase Authentication* handles email/password and Google OAuth sign-in, removing the need to implement password hashing, session-token issuance, or OAuth handshake logic from scratch.
- *Firebase Storage* is configured (`storage.rules`) as a secondary image-upload path, though the primary image flow instead compresses screenshots to base64 JPEG data URLs stored directly on the claim document (`src/lib/imageCompression.ts`) — keeping the project entirely within the Firestore free tier without provisioning a paid Storage bucket.

=== Cloud Firestore — Document Model and the Embedded-Array Decision

Cloud Firestore, a NoSQL document store, holds the `users`, `claims`, `notifications`, `reports`, and `audit_logs` collections. The most consequential schema decision is how a claim's verifications are stored: *embedded as an array field directly on the claim document*, rather than as a separate `verifications` subcollection keyed by claim ID.

- *Embedded array (chosen):* The real-time claims subscription (`subscribeClaimsRealtime`) reconstructs a complete `Claim` object — including every verification cast on it — from a single document read, avoiding an N+1 subcollection-read pattern in list views.
- *Subcollection (rejected):* Would scale better for an unbounded number of verifications, but FactStamp's verification count per claim is small and bounded by design (a 3-verifier quorum, occasionally more), so the subcollection's main advantage does not apply while its N+1-read cost would.

=== Firestore Security Rules

`firestore.rules` enforces the data model server-side — field-level validation on every write path (e.g. a verification being appended must increment `verificationCount` by exactly 1 and match the writer's own `uid` and their current live reputation value) — so the client-side consensus logic in `ClaimsContext.tsx` cannot be bypassed by a malicious client sending arbitrary writes directly to the Firestore REST API. This is what allows FactStamp to skip writing a server-side API layer at all.

=== Data Visualization — Recharts 2.10

Recharts consumes Firestore-backed claim data to power the Misinformation Analytics Dashboard — the category-distribution pie chart on the public dashboard (`src/pages/Dashboard.tsx`, `src/components/DashboardChart.tsx`, lazy-loaded), and the category-distribution bar chart plus verdict-distribution pie chart in the Admin console (`src/pages/Admin.tsx`). The rolling weekly trend report (`src/lib/weeklyReport.ts`) and the top-verifier leaderboard are computed from the same claim data but rendered as ranked lists rather than Recharts graphs. It was chosen over using D3 directly for its declarative React-component API, dramatically faster to build and maintain for the dashboard's standard chart types, at the cost of lower-level customization the project does not need.

== OCR Engines

This is one of the project's most consequential technology decisions, so it is treated as its own survey rather than a single-line library pick.

=== The Alternatives

A WhatsApp forward frequently arrives as a screenshot rather than plain text, so some form of Optical Character Recognition is required. Three broad approaches exist:

- *Cloud vision/OCR APIs* (Google Cloud Vision, AWS Textract) — mature, high-accuracy managed services that accept an image over HTTPS and return extracted text, but require sending the image to a third-party server and charge per request.
- *LLM vision endpoints* — can extract text and even attempt to interpret the claim in the same call, but remain a paid, cloud-hosted, per-request service with the same data-egress profile.
- *Client-side WebAssembly OCR* (Tesseract.js) — runs the OCR engine entirely inside the browser via WASM, with no network call and no per-request cost.

=== FactStamp's Choice — Tesseract.js 7.0, Client-Side

Rather than sending a user's WhatsApp forward screenshot to a cloud OCR/vision API, FactStamp runs Tesseract.js entirely inside the browser via WebAssembly (`src/services/ocrService.ts`, `createWorker` from `tesseract.js`). This was driven by three factors:

+ *Privacy* — a screenshot of a WhatsApp forward often contains other participants' names and phone numbers in the chat header; never transmitting that image off-device avoids an entire category of data-handling and consent concerns.
+ *Cost* — cloud OCR/vision APIs charge per request; at any meaningful submission volume this becomes a recurring operational cost the project has no revenue model to cover. Client-side WASM OCR is free at unlimited scale.
+ *Offline capability* — once the Tesseract WASM core and English model are cached, OCR extraction continues to work without a network round-trip.

=== The Honest Trade-off

The cost of this choice is lower raw accuracy than a modern cloud vision model, especially on low-resolution or heavily-compressed screenshots. This is mitigated two ways: `cleanExtractedOcrText()` is a WhatsApp-chrome-specific regex cleanup pass that strips timestamps, delivery checkmarks, and carrier/battery status-bar text; and the user can always manually correct the extracted text before submission — OCR output is a starting draft, never the final claim text FactStamp acts on.

== Card Export Engines

=== The Alternatives

Turning a styled DOM element into a downloadable PNG image has three common solution shapes:

- *Raw HTML5 Canvas API* — manually redraw every visual element onto a `#raw("<canvas>")` element using imperative drawing calls; gives complete control but requires reimplementing a layout and CSS-parsing engine by hand.
- *`html2canvas`* — walks the DOM and reads computed styles, then redraws the equivalent visuals onto a canvas using its own internal CSS interpretation logic, which lags behind the browser's own and can fail on newer CSS syntax.
- *`html-to-image`* — serializes the target DOM subtree into an SVG `#raw("<foreignObject>")`, which the browser's own rendering engine then paints, and rasterizes the result. Because the browser itself does the styling work, this inherits whatever CSS support the browser already has, with zero additional parsing logic to maintain.

=== FactStamp's Choice — `html-to-image`, After a Legacy Canvas Parser Failed

The shareable fact-check card (`src/components/FactCheckCard.tsx`) is rasterized client-side via `html-to-image`, but this was not the project's first attempt. FactStamp originally used a hand-written, canvas-based CSS parser, and it failed in production: it could not interpret the `oklch()`/`oklab()` color functions used throughout the Tailwind v4 design tokens, because it implemented its own limited CSS color-value interpreter rather than delegating to the browser. The result was broken, black, or incorrectly-colored card exports for a design system built entirely on OKLCH.

`html-to-image` was adopted specifically to eliminate this class of bug rather than to patch around it. Because it uses the browser's native SVG foreignObject rendering path, it resolves CSS Color Level 4 syntax exactly as the browser itself does, producing crisp 1080 px-wide PNG exports (a 540 CSS px card rasterized at 2× device-pixel-ratio, its height determined by the card's own content rather than fixed to a square) with zero layout distortion. `html2canvas` was considered and rejected for the same underlying reason the legacy parser failed: it ships its own CSS interpretation layer rather than delegating to the browser, carrying the same structural risk of falling behind new CSS syntax.

== Consensus Models

Every technology surveyed so far in this chapter is a library or platform choice. This section is different: it surveys *claim-verification consensus models* — the algorithmic and organizational patterns by which a group decides whether a disputed statement is true — because FactStamp's core value proposition is not any single library, it is the consensus mechanism itself.

=== Survey of Consensus Models

*(a) Single-moderator / editorial decision.* This is how traditional fact-checking organizations such as Snopes, PolitiFact, or India-focused outlets like AltNews operate: a professional editorial team investigates a claim and an editor publishes a final verdict. Its strength is depth; its weakness is throughput — one team cannot scale to the volume of hyper-local, informal claims circulating on WhatsApp, and the decision process is opaque to the public.

*(b) Simple majority vote.* Any group of N reviewers each casts a verdict, and whichever verdict has the most votes wins. Easy to implement and explain, but it treats every voter identically regardless of track record, and says nothing about how certain the group actually is — a 2-1 split and a 10-1 split both just resolve to "the majority verdict."

*(c) Byzantine-fault-tolerant (BFT) / blockchain-style distributed consensus.* Protocols in this family (e.g. PBFT, or blockchain Proof-of-Stake) let a distributed set of nodes agree on a single value even when some participants are malicious or faulty, typically requiring a supermajority of agreement. This is the right tool when participants are mutually distrusting, anonymous nodes agreeing on a ledger state — but it is a poor fit for claim verification: BFT consensus agrees on *which value was submitted*, not on *the quality of evidence behind competing values*, and has no native concept of reviewer track record or source credibility.

*(d) Weighted quorum consensus.* A minimum number of independent reviewers (a quorum) must participate before a verdict is finalized, and the final confidence in that verdict is a weighted function of multiple signals rather than raw vote count. This keeps majority voting's transparency while adding a minimum-participation floor and a mechanism for evidence quality and reviewer track record to influence the final confidence score.

=== FactStamp's Choice — Weighted Quorum Consensus

FactStamp implements model (d): a minimum 3-verifier quorum with a weighted confidence formula, computed by `calculateConfidenceScore()` in `src/lib/confidenceScore.ts`:

$ "Confidence" = (0.40 times "AgreementRatio") + (0.30 times "AvgVerifierReputation") + (0.30 times "SourceQualityScore") $

No verdict is finalized until at least three independent verifications exist — this quorum floor is what a pure majority vote lacks. Once quorum is reached, the three weighted components combine agreement, track record, and evidence quality into a single number:

- *AgreementRatio (40%)* — the proportion of participating verifiers whose verdict matches the eventual majority verdict.
- *AvgVerifierReputation (30%)* — the mean verifier reputation across all participating verifiers, so a claim reviewed by several high-reputation verifiers is weighted more confidently than the same vote split among brand-new accounts.
- *SourceQualityScore (30%)* — computed via `determineSourceQuality()` and `sourceQualityToScore()` in the same file, which classify each cited source URL against curated high-quality domain sets (e.g. `who.int`, `pib.gov.in`, `rbi.org.in`) and mid-quality domain sets (major national news outlets), scoring unlisted domains lowest.

This is deliberately not a BFT-style protocol: FactStamp's participants are named, reputation-tracked community members whose historical accuracy is exactly the signal the confidence formula wants to use, not anonymous, mutually-distrusting nodes agreeing on a single submitted value.

=== Supporting Mechanisms: Duplicate Pre-Filtering and Consensus-Deadline Expiry

*Jaccard-similarity duplicate detection as a pre-filter.* Before a new submission enters the verification queue, `findDuplicate()` in `src/lib/duplicateDetection.ts` compares its normalized, tokenized text against existing claims using Jaccard similarity, computed over word tokens longer than 3 characters:

$ J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|) $

A match with similarity $J(A,B) >= 0.75$ (the `threshold` parameter of `findDuplicate()`) redirects the submitter to the existing claim's verdict instead of opening a new, duplicate verification queue entry — preventing identical viral forwards worded slightly differently from each requiring their own independent 3-verifier quorum.

*Automatic 7-day consensus-deadline expiry.* A claim that fails to reach a clear majority verdict within 7 days automatically transitions to a `CONTESTED` state rather than remaining in limbo indefinitely. A community-quorum model with unpaid, occasional volunteer participation has no guarantee that three verifiers will ever weigh in, or that they will not split evenly forever — an explicit deadline keeps every claim moving toward a terminal, user-visible state instead of quietly stalling in the review queue.

== Technology Selection Matrix

=== Core Technology Comparison Summary

#styled-table(
  columns: (1.1in, 1.2in, 1.2in, 1fr),
  headers: ("Concern", "Chosen Technology", "Rejected Alternative", "Reason"),
  "Application Architecture", "React SPA + Firebase BaaS", "SSR/hybrid framework + custom Node server", "No server-runtime budget; Firestore onSnapshot covers all real-time needs natively.",
  "UI Framework", "React 18.3.1", "Vue 3 / Svelte", "Ecosystem maturity for Firebase bindings; Context API sufficient for a shallow, 5-concern state graph.",
  "Type Safety", "TypeScript 5.5 (strict)", "Plain JavaScript", "Compile-time safety against malformed/legacy Firestore document shapes.",
  "Build Tooling", "Vite 5.4", "Create React App / hand-rolled Webpack", "Native ESM dev server, near-instant HMR, manual vendor chunk-splitting.",
  "Styling", "Tailwind CSS v4 (OKLCH tokens)", "Styled-Components / CSS Modules", "Zero-runtime CSS; OKLCH perceptual-uniformity design-token system.",
  "Animation", "Framer Motion 12", "CSS-only transitions", "JS-driven orchestration needed for staggered reveals and spring-physics panel mounts.",
  "Backend", "Firebase v12 (BaaS)", "Custom Node/Express + PostgreSQL", "No dedicated server/DevOps budget; native real-time listeners; declarative Security Rules.",
  "Database Schema", "Embedded verification array", "Separate verifications subcollection", "Single-read claim reconstruction avoids N+1 reads; verification count is small and bounded.",
  "OCR", "Tesseract.js 7.0 (client WASM)", "Google Cloud Vision / AWS Textract / LLM vision", "Zero cost, zero data egress, offline-capable; trade-off mitigated by manual correction.",
  "Card Rasterization", "html-to-image (SVG foreignObject)", "Hand-written canvas parser / html2canvas", "Native OKLCH/OKLAB CSS Color 4 support via browser-native rendering.",
  "Consensus Model", "Weighted quorum (3-verifier, 40/30/30)", "Single-moderator / majority vote / BFT consensus", "Combines quorum-floor trust with evidence-quality and reputation weighting.",
  "Duplicate Handling", "Jaccard token-similarity (J >= 0.75)", "No pre-filtering / exact-string matching", "Prevents redundant quorum queues for reworded duplicates.",
  "Hosting", "Firebase Hosting / Vercel / Docker + Nginx", "AWS / bare-metal VPS", "Zero-ops static hosting matching the BaaS backend; Docker kept as an on-prem escape hatch."
)

=== Supporting Libraries

#styled-table(
  columns: (1.3in, 1fr),
  headers: ("Library", "Purpose"),
  "lucide-react", "Icon system — chosen over emoji or icon fonts, per the design system's explicit ban on emoji in UI.",
  "sonner", "Toast notification primitives.",
  "react-router-dom v6", "Client-side routing (/, /submit, /verify, /claim/:id, /dashboard, /profile, /admin, etc.).",
  "clsx + tailwind-merge", "Conditional Tailwind class composition (the cn() helper in src/lib/utils.ts).",
  "firebase-tools (dev)", "Local Emulator Suite CLI, used by npm run emulators.",
  "Recharts 2.10", "Declarative React charting for the analytics dashboard and Admin console (category distribution, verdict distribution)."
)

=== Reading the Matrix

Two patterns recur across nearly every row above, and both trace back to the architectural choice in §2.1: *zero-server-cost is the dominant constraint* (Firebase BaaS, the embedded-array schema, client-side OCR, and zero-ops static hosting are all instances of pushing cost and computation to the client and to managed services), and *"native browser behavior over custom reimplementation" is the recurring engineering principle* (`html-to-image`'s foreignObject strategy and Firestore Security Rules both reflect a preference for delegating to a platform's own correct implementation rather than maintaining a parallel one that can drift out of sync — the same lesson the legacy canvas-parser failure taught the hard way). The consensus-model choice stands apart from the rest of the table: it is not a cost-minimization decision like the others, but the one place in this chapter where the technology choice *is* the product's core value proposition, rather than infrastructure supporting it.

