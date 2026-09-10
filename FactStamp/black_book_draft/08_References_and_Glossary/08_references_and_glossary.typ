#import "../lib/helpers.typ": *

#heading(numbering: none)[References]

+ IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
+ Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
+ Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
+ Garimella, K., & Eckles, D., *"Images and misinformation in political groups: Evidence from WhatsApp in India,"* _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
+ Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
+ OWASP Foundation, *"OWASP Top Ten,"* Open Worldwide Application Security Project, 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
+ Meta Platforms, Inc., *"React: The Library for Web and Native User Interfaces,"* React Documentation, 2025. [Online]. Available: `https://react.dev/`.
+ Evan You & Vite Contributors, *"Vite: Next Generation Frontend Tooling,"* Vite Documentation, 2025. [Online]. Available: `https://vite.dev/`.
+ Microsoft Corporation, *"TypeScript: JavaScript With Syntax for Types,"* TypeScript Documentation, 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
+ Tailwind Labs Inc., *"Tailwind CSS v4 Documentation,"* 2025. [Online]. Available: `https://tailwindcss.com/docs`.
+ World Wide Web Consortium (W3C), *"CSS Color Module Level 4 (OKLCH / OKLAB Color Spaces),"* W3C Candidate Recommendation Draft, 2026. [Online]. Available: `https://www.w3.org/TR/css-color-4/`.
+ Google LLC, *"Cloud Firestore Documentation: Data Model, Security Rules & Realtime Snapshot Listeners,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
+ Google LLC, *"Firebase Authentication Documentation,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
+ Remix Software, Inc., *"React Router Documentation,"* 2025. [Online]. Available: `https://reactrouter.com/`.
+ Recharts Group, *"Recharts: A Composable Charting Library Built on React Components,"* 2025. [Online]. Available: `https://recharts.org/`.
+ Project Naptha and Tesseract.js Contributors, *"Tesseract.js: Pure JavaScript OCR for 100 Languages,"* Open-Source Software Documentation, 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
+ Bubkoo, *"html-to-image: Generates images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

#v(8pt)

// ==========================================
// Glossary (Unnumbered Back-Matter Section)
// ==========================================
#heading(numbering: none)[Glossary]

#styled-table(
  columns: (1.5in, 1fr),
  headers: ("Term", "Definition"),
  [Admin Console (Admin Command Center)], [The moderation interface for staff at the unlisted route `/admin` (`src/pages/Admin.tsx`). It is organized into five tabs: System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit & Tools. Dual-layer authorization protects it, using a client-side `AdminRoute` check and server-side `firestore.rules` `isAdmin()` enforcement.],
  [Agreement Ratio], [The percentage of verifiers on a claim who voted for the final majority verdict. It carries a 40% weight in the Confidence Score.],
  [APCA (Accessible Perceptual Contrast Algorithm)], [A contrast-measurement model used to check readability when tuning FactStamp's design tokens. The palette in `src/index.css` is calibrated so text and background pairs pass an APCA lightness contrast of about 60 on dark backgrounds. This is a higher standard than a standard WCAG 2 contrast ratio.],
  [Audit Log (`AdminAuditLog`)], [A Firestore-backed record of all admin actions. It logs the timestamp, admin identity, action, target type and ID, and details of every administrative change. Accessible through the Audit & Tools tab of the Admin Console.],
  [BaaS (Backend-as-a-Service)], [An architecture pattern where a managed platform provides backend functions directly to the client. For this project, Firebase provides Auth, Firestore, and Storage, so FactStamp does not need a custom application server.],
  [Claim], [A submitted WhatsApp forward, which is the main data entity in FactStamp. Users submit claims as plain text or OCR-extracted screenshot text. The system stores them in the `claims` Firestore collection with their category, verdict, confidence score, and an array of verifications.],
  [Claim Category], [The classification of a claim into Health, Political, Financial, Religious, or Other. The claim document stores this as a `health | political | financial | religious | other` value for analytics and dashboard charts. When users upload screenshots, `detectClaimCategory()` in `src/services/ocrService.ts` pre-selects the category using a keyword classifier built for Indian WhatsApp forwards. For plain-text submissions, it defaults to Health. Submitters can change this selection using the `CategoryBadge` selector on the Submit form.],
  [Confidence Score], [The final percentage from 0 to 100 generated by the Weighted Consensus engine. It combines the Agreement Ratio, average Verifier Reputation, and Source Quality.],
  [CONTESTED], [A Verdict classification that applies automatically if verifiers cannot reach a majority agreement or if the Consensus Deadline passes without a resolution.],
  [Consensus Deadline], [The 7-day window defined by `CONSENSUS_DEADLINE_DAYS`. If a claim is not resolved in this time, it automatically becomes `CONTESTED` instead of staying in the Verification Queue forever.],
  [CSP (Content Security Policy)], [An HTTP response header that limits where scripts, styles, and other resources can load from. FactStamp has three deployment targets, and each uses its own specific security policy. Firebase Hosting (`firebase.json`) adds `Strict-Transport-Security` and `Permissions-Policy` to the shared headers. Vercel (`vercel.json`) uses a similar CSP and adds `Cross-Origin-Resource-Policy`. The Docker and Nginx setup (`nginx.conf`) uses a narrower CSP that allows Google endpoints via a `*.googleapis.com` wildcard instead of listing them one by one.],
  [Duplicate Detection], [The process of comparing a new claim against existing claims using Jaccard Similarity on their normalized tokens. If the system finds a near-duplicate, it redirects the claim to the existing verdict instead of adding it to the queue again.],
  [Fact-Check Card], [A shareable PNG image generated from `src/components/FactCheckCard.tsx`. The `html-to-image` library rasterizes it on the client side at a 2#sym.times pixel ratio. This creates a 1080px-wide image from a 540px-wide layout. The height scales based on the length of the claim text and the number of sources. The card includes the claim excerpt, verdict stamp, confidence percentage, and cited sources so users can forward it on WhatsApp.],
  [FactStamp], [The web application built for this dissertation. It is a fact-checking platform that uses community verification to review WhatsApp misinformation.],
  [Firebase Authentication], [The Firebase service that handles user sign-in with email passwords and Google OAuth. This means the application does not need custom code for password hashing or session tokens.],
  [Firebase Security Rules (Firestore Security Rules)], [Server-side rule files, specifically `firestore.rules` and `storage.rules`, that validate data shapes and control access for all database reads and writes. These operate separately from the client-side code.],
  [Firestore (Cloud Firestore)], [Google's NoSQL document database. It is the only backend data store for FactStamp and holds the `users`, `claims`, `notifications`, `reports`, and `audit_logs` collections.],
  [html-to-image], [A JavaScript library that turns a DOM subtree into a PNG image using the browser's SVG `<foreignObject>` rendering. FactStamp uses this for the Fact-Check Card generator to accurately render OKLCH and OKLAB CSS colors via SVG and Canvas.],
  [Idle-Session Timeout], [A client-side security function in `src/lib/security.ts` that signs users out if they are inactive for 30 minutes.],
  [Incident Queue], [The tab in the Admin Console that lists Moderation Reports waiting for review. Admins can filter these tickets by status, such as pending, investigating, resolved, or dismissed, and by severity levels of low, medium, or high.],
  [Jaccard Similarity], [A similarity coefficient measuring how far two sets overlap, taken as the size of their intersection over the size of their union. The system computes this between the normalized token sets of two claims, and flags a claim as a duplicate when the similarity reaches 0.75 or higher.],
  [Login Rate Limiter], [A client-side control that blocks sign-in for 15 minutes after 5 failed login attempts in a row.],
  [MISLEADING], [A Verdict classification for claims that have some facts but present them in a distorted or exaggerated way.],
  [Moderation Report (`ModerationReport`)], [An incident ticket submitted for a claim, user, or verification. It includes a reason, severity level, and status, and admins review it in the Incident Queue.],
  [OCR (Optical Character Recognition)], [The process of extracting text from an image. FactStamp runs OCR entirely on the client side using Tesseract.js to read text from WhatsApp screenshots.],
  [OKLCH], [A CSS Color Module Level 4 color space with Lightness, Chroma, and Hue components. Used across the project's Tailwind CSS v4 design tokens and rendered via `html-to-image` during Fact-Check Card exports.],
  [Quorum], [The minimum requirement of three independent verifier submissions on a claim. The system needs this before calculating the Weighted Consensus and Confidence Score.],
  [RBAC (Role-Based Access Control)], [The privilege model that separates the `User`, `Verifier`, and `Admin` roles. Application logic and Firestore Security Rules enforce these permissions.],
  [React], [A component-based JavaScript UI library, version 18, used as the frontend framework. It manages application state using React Context for auth, claims, notifications, themes, and users.],
  [React Router (`react-router-dom`)], [The routing library that links URL paths like `/submit` or `/dashboard` to page components on the client side, avoiding full page reloads.],
  [Recharts], [A React-based charting library used for the three charts in the application. These include a pie chart on the Misinformation Analytics Dashboard in `DashboardChart.tsx`, which loads the library dynamically, along with a bar chart and another pie chart in the Admin Console.],
  [Reputation Tier], [A category assigned to a verifier based on their Verifier Reputation score. The levels are Novice, Trusted, Expert, and Elite. The Admin Console displays these in the System Overview.],
  [Source Quality], [A rating from 0 to 100 for the credibility of a cited source URL. The `determineSourceQuality()` function assigns 100 for high-quality government and health domains like `who.int` or `pib.gov.in`. It assigns 70 for medium-quality news sites like `bbc.com` and 30 for all other low-quality domains. The system averages these values to calculate the third term of the Confidence Score, which carries a 30% weight.],
  [SPA (Single-Page Application)], [A web application architecture where the client handles route navigation instead of making full-page server requests.],
  [Tailwind CSS], [A CSS framework used for styling the application, specifically version 4. FactStamp uses it because it supports an OKLCH-based design token system and configures directly in CSS without a separate `tailwind.config.js` file.],
  [Tesseract.js], [A WebAssembly version of the Tesseract OCR engine. It runs in the browser via `src/services/ocrService.ts` so uploaded screenshots stay on the device and never go to an external server.],
  [TRUE / FALSE], [The two basic Verdict classifications. The system assigns `TRUE` to claims supported by primary documents and `FALSE` to claims that are fabricated, doctored, or untrue.],
  [TypeScript], [A strictly typed version of JavaScript, specifically version 5.x, used in the codebase to enforce interface contracts on Firestore documents at compile time.],
  [UNVERIFIABLE], [A Verdict classification for claims that lack enough credible evidence to prove them true or false.],
  [Verdict], [The final classification for a resolved claim. The options are `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, and `CONTESTED`.],
  [Verification], [A single review of a claim submitted by a verifier. It includes a verdict, a cited source URL, a source quality rating, and a written explanation with a minimum of 50 characters or 8 words to prevent spam.],
  [Verification Queue], [The public list of claims waiting for review. Claims require a quorum of three independent reviews before the system computes consensus.],
  [Verifier], [An authenticated user who reviews claims and submits verdicts. Verifiers earn a Verifier Reputation score based on how often they align with the community consensus.],
  [Verifier Reputation], [A numeric score on a 0 to 100 scale, starting at 50, that tracks how often a verifier aligns with the community consensus. It supplies the reputation component of the Confidence Score.],
  [Vite], [A frontend build tool and development server, version 5. It provides fast hot module replacement during development and uses a Rollup-based production build with manual chunk splitting.],
  [Weighted Consensus], [The algorithm that calculates a claim's final verdict and Confidence Score from multiple verifications. It weights verifier agreement, reputation, and source quality instead of relying on a simple vote count.],
  [XSS (Cross-Site Scripting)], [A client-side injection vulnerability. FactStamp mitigates it using input sanitization in `src/lib/security.ts` and Firestore Security Rules.]
)

#v(8pt)
