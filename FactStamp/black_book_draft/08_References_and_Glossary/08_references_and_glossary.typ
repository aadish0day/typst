#import "../lib/helpers.typ": *

#heading(numbering: none)[References]

+ IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
+ Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
+ Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
+ Garimella, K., & Eckles, D., *"Images and misinformation in political groups: Evidence from WhatsApp in India,"* _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
+ Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
+ OWASP Foundation, *"OWASP Top Ten,"* Open Worldwide Application Security Project, 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
+ Meta Platforms, Inc., *"React --- The Library for Web and Native User Interfaces,"* React Documentation, 2025. [Online]. Available: `https://react.dev/`.
+ Evan You & Vite Contributors, *"Vite --- Next Generation Frontend Tooling,"* Vite Documentation, 2025. [Online]. Available: `https://vite.dev/`.
+ Microsoft Corporation, *"TypeScript --- JavaScript With Syntax for Types,"* TypeScript Documentation, 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
+ Tailwind Labs Inc., *"Tailwind CSS v4 Documentation,"* 2025. [Online]. Available: `https://tailwindcss.com/docs`.
+ World Wide Web Consortium (W3C), *"CSS Color Module Level 4 (OKLCH / OKLAB Color Spaces),"* W3C Candidate Recommendation Draft, 2026. [Online]. Available: `https://www.w3.org/TR/css-color-4/`.
+ Google LLC, *"Cloud Firestore Documentation --- Data Model, Security Rules & Realtime Snapshot Listeners,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
+ Google LLC, *"Firebase Authentication Documentation,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
+ Remix Software, Inc., *"React Router Documentation,"* 2025. [Online]. Available: `https://reactrouter.com/`.
+ Recharts Group, *"Recharts --- A Composable Charting Library Built on React Components,"* 2025. [Online]. Available: `https://recharts.org/`.
+ Project Naptha and Tesseract.js Contributors, *"Tesseract.js --- Pure JavaScript OCR for 100 Languages,"* Open-Source Software Documentation, 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
+ Bubkoo, *"html-to-image: Generates images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

#v(8pt)

// ==========================================
// Glossary (Unnumbered Back-Matter Section)
// ==========================================
#heading(numbering: none)[Glossary]

#styled-table(
  columns: (1.5in, 1fr),
  headers: ("Term", "Definition"),
  [Admin Console (Admin Command Center)], [The staff-only moderation interface at the unlisted route `/admin` (`src/pages/Admin.tsx`), organized into five tabs --- System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit & Tools --- guarded by dual-layer authorization (a client-side `AdminRoute` re-check plus server-side `firestore.rules` `isAdmin()` enforcement).],
  [Agreement Ratio ($A$)], [The proportion of participating verifiers on a claim who voted for the eventual majority verdict; the first term (weighted 40%) of the Confidence Score formula.],
  [APCA (Accessible Perceptual Contrast Algorithm)], [A perceptual contrast-measurement model used as the readability target when tuning FactStamp's design tokens: the palette in `src/index.css` is calibrated so text/background pairs clear an APCA lightness contrast of roughly 60 on dark backgrounds, a stricter bar than a simple WCAG 2 contrast ratio.],
  [Audit Log (`AdminAuditLog`)], [An immutable, Firestore-backed trail recording the timestamp, admin identity, action, target type/ID, and detail of every administrative mutation, viewable in the Admin Console's Audit & Tools tab.],
  [BaaS (Backend-as-a-Service)], [An architecture pattern in which a managed platform (Firebase: Auth, Firestore, Storage) supplies backend functionality directly to the client, removing the need for FactStamp to build and operate a custom application server.],
  [Claim], [The core FactStamp data entity: a submitted WhatsApp forward (as plain text or OCR-extracted screenshot text), stored in the `claims` Firestore collection together with its category, verdict, confidence score, and embedded array of verifications.],
  [Claim Category], [The classification of a claim into Health, Political, Financial, Religious, or Other, stored on the claim document as a `health | political | financial | religious | other` value and used for analytics and dashboard breakdowns. On the screenshot/OCR submission path the category is pre-selected automatically by `detectClaimCategory()` (`src/services/ocrService.ts`), a keyword-heuristic classifier tuned for Indian WhatsApp forward phrasing; on the plain-text path it defaults to Health. In both cases the submitter can override the selection via the `CategoryBadge` selector on the Submit form.],
  [Confidence Score ($C$)], [The final composite percentage (0--100) produced by the Weighted Consensus engine: $C = 0.40 A + 0.30 R + 0.30 S$, combining Agreement Ratio, average Verifier Reputation, and Source Quality.],
  [CONTESTED], [A Verdict classification automatically assigned when a claim's verifiers cannot reach majority agreement, or when the Consensus Deadline elapses without resolution.],
  [Consensus Deadline], [The fixed 7-day window (`CONSENSUS_DEADLINE_DAYS`) after which an unresolved claim automatically settles as `CONTESTED` rather than remaining indefinitely in the Verification Queue.],
  [CSP (Content Security Policy)], [An HTTP response header restricting which sources scripts, styles, and other resources may load from. Each of FactStamp's three deployment targets ships its own strict policy and accompanying security-header set rather than one identical configuration: Firebase Hosting (`firebase.json`) is the most complete, adding `Strict-Transport-Security` and `Permissions-Policy` on top of the shared headers; Vercel (`vercel.json`) carries a comparable CSP plus `Cross-Origin-Resource-Policy`; and Docker/Nginx (`nginx.conf`) enforces a narrower CSP that reaches Google endpoints through a `*.googleapis.com` wildcard instead of naming them individually.],
  [Duplicate Detection], [The process of comparing a newly submitted claim's normalized token set against existing claims using Jaccard Similarity, so that a claim recognized as a near-duplicate is redirected to its existing verdict instead of re-queued.],
  [Fact-Check Card], [A shareable PNG image (`src/components/FactCheckCard.tsx`) rasterized client-side via `html-to-image` at a 2#sym.times pixel ratio, producing a 1080px-wide export from a 540px-wide card layout; its height is content-dependent, growing with the length of the claim excerpt and the number of cited sources. It carries the claim excerpt, verdict stamp, confidence percentage, and cited sources, and is designed to be re-forwarded on WhatsApp.],
  [FactStamp], [The community-powered web application that is the subject of this dissertation --- a decentralized, quorum-verified fact-checking platform purpose-built for WhatsApp-forwarded misinformation.],
  [Firebase Authentication], [The Firebase service handling user/verifier sign-in via email/password and Google OAuth, removing the need to implement password hashing or session-token logic from scratch.],
  [Firebase Security Rules (Firestore Security Rules)], [Declarative, server-side rule files (`firestore.rules`, `storage.rules`) that enforce data-shape validation and access control on every Firestore/Storage read and write, independent of client-side logic.],
  [Firestore (Cloud Firestore)], [Google's managed, real-time NoSQL document database that serves as FactStamp's sole backend data store for `users`, `claims`, `notifications`, `reports`, and `audit_logs` collections.],
  [html-to-image], [A JavaScript library that rasterizes a DOM subtree into a PNG image via the browser's native SVG `<foreignObject>` rendering path; adopted for the Fact-Check Card generator because --- unlike the legacy hand-written canvas parser it replaced --- it correctly resolves OKLCH/OKLAB CSS colors.],
  [Idle-Session Timeout], [A client-side security control (`src/lib/security.ts`) that automatically signs a user out after 30 minutes of inactivity.],
  [Incident Queue], [The Admin Console tab listing Moderation Reports awaiting review, filterable by status (`pending` / `investigating` / `resolved` / `dismissed`) and severity (`low` / `medium` / `high`).],
  [Jaccard Similarity], [A set-theoretic similarity coefficient, $J(A,B) = (|S_A inter S_B|) / (|S_A union S_B|)$, computed between the normalized significant-token sets of two claims; FactStamp flags a claim as a duplicate when $J >= 0.75$.],
  [Login Rate Limiter], [A client-side control that locks out further sign-in attempts for 15 minutes after 5 consecutive failed login attempts.],
  [MISLEADING], [A Verdict classification for a claim that contains partial facts presented in a distorted, exaggerated, or deceptive context.],
  [Moderation Report (`ModerationReport`)], [An incident ticket raised against a claim, user, or verification, carrying a reason, severity, and status, reviewed through the Admin Console's Incident Queue.],
  [OCR (Optical Character Recognition)], [The process of extracting machine-readable text from an image; FactStamp performs OCR entirely client-side (via Tesseract.js) to read text out of uploaded WhatsApp forward screenshots.],
  [OKLCH], [A perceptually uniform CSS Color Level 4 color space (Lightness, Chroma, Hue) used throughout FactStamp's Tailwind CSS v4 design tokens; correctly rendering OKLCH colors during Fact-Check Card export was the reason the project moved to `html-to-image`.],
  [Quorum], [The minimum number of independent verifier submissions --- three --- required on a claim before its Weighted Consensus and Confidence Score can be computed.],
  [RBAC (Role-Based Access Control)], [The privilege-tier model distinguishing `User`, `Verifier`, and `Admin` roles, enforced through both application logic and Firestore Security Rules.],
  [React], [A component-based JavaScript UI library (v18) used as FactStamp's frontend framework, managing application state through React Context (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, `UsersContext`).],
  [React Router (`react-router-dom`)], [The client-side routing library that maps FactStamp's URL paths (`/`, `/submit`, `/verify`, `/verify/:claimId`, `/claim/:claimId`, `/dashboard`, `/profile`, `/admin`) to page components without full page reloads.],
  [Recharts], [A declarative, React-native charting library used for the three charts in FactStamp: a category-distribution pie chart on the public Misinformation Analytics Dashboard (`DashboardChart.tsx`, which lazy-loads the library via a dynamic `import('recharts')`), plus a claims-by-category bar chart and a verdict-distribution pie chart in the Admin Console.],
  [Reputation Tier], [A categorical grouping of a verifier's numeric Verifier Reputation score --- Novice, Trusted, Expert, or Elite --- shown in the Admin Console's System Overview breakdown.],
  [Source Quality ($S$)], [A 0--100 rating of a verification's cited source-URL credibility, assigned by domain lookup in `determineSourceQuality()` and scored 100 for _high_ (primary government/health-authority domains such as `who.int` or `pib.gov.in`), 70 for _medium_ (established news and fact-checking outlets such as `bbc.com` or `reuters.com`), and 30 for _low_ (every domain not on either list); the per-verification values are averaged into the third, 30%-weighted term of the Confidence Score.],
  [SPA (Single-Page Application)], [A web application architecture, used by FactStamp, in which route navigation is handled entirely client-side (by React Router) without full-page server round-trips.],
  [Tailwind CSS], [A utility-first CSS framework (v4) used for FactStamp's styling, adopted for its native OKLCH-based design-token system and CSS-native configuration (no separate `tailwind.config.js`).],
  [Tesseract.js], [A WebAssembly port of the Tesseract OCR engine, run entirely inside the browser (`src/services/ocrService.ts`) so that uploaded WhatsApp screenshots are never transmitted to a third-party server.],
  [TRUE / FALSE], [The two baseline Verdict classifications: `TRUE` for a claim supported by authoritative primary documentation, `FALSE` for a claim that is demonstrably fabricated, doctored, or untrue.],
  [TypeScript], [A statically typed superset of JavaScript (v5.x, strict mode) used throughout FactStamp's codebase to enforce compile-time interface contracts on Firestore document shapes.],
  [UNVERIFIABLE], [A Verdict classification applied when insufficient credible evidence or citations exist to definitively establish a claim's truth.],
  [Verdict], [The final classification assigned to a resolved claim --- one of `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, or `CONTESTED`.],
  [Verification], [A single verifier's submitted review of a claim, comprising a verdict, a cited source URL, a source-quality rating, and a written explanation (minimum 50 characters / 8 words, anti-spam validated).],
  [Verification Queue], [The public, real-time list of claims awaiting verifier review, requiring a minimum Quorum of three independent reviews before consensus is computed.],
  [Verifier], [An authenticated community member who reviews submitted claims and casts verdicts, accumulating a Verifier Reputation score based on alignment with eventual community consensus.],
  [Verifier Reputation], [A numeric score (0--100 scale, base 50) tracking a verifier's historical alignment with eventual community consensus; it feeds directly into the reputation term ($R$) of the Confidence Score.],
  [Vite], [A modern frontend build tool and development server (v5) providing near-instant hot-module-replacement in development and a Rollup-based, manually chunk-split production build.],
  [Weighted Consensus], [The algorithmic process by which a claim's final verdict and Confidence Score are derived from multiple verifications, weighting verifier agreement, verifier reputation, and source quality rather than a simple majority headcount vote.],
  [XSS (Cross-Site Scripting)], [A class of client-side injection vulnerability mitigated in FactStamp through input sanitization (`src/lib/security.ts`) layered on top of Firestore Security Rules.],
)

#v(8pt)
