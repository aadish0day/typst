#import "../lib/helpers.typ": *

= Survey of Technologies

This chapter examines the architecture patterns, frameworks, libraries, and consensus models evaluated for FactStamp. Several core operational constraints govern technical selections across the stack. The system must operate strictly within the Firebase Spark free tier without dedicated server compute, execute Optical Character Recognition locally to eliminate API fees and prevent cloud data egress, and accurately render modern CSS color functions (`oklch()` and `oklab()`) during PNG card export. Every library version, interface contract, threshold, and formula cited in this chapter reflects the concrete FactStamp codebase.

#heading(level: 2, outlined: false)[Web Architectures]

Application delivery architecture governs how the system manages client state and distributes compute workloads across hosting environments. FactStamp operates as a Single Page Application (SPA) built in React and backed by Firebase as a Backend-as-a-Service (BaaS), omitting any intermediate REST or GraphQL application server.

=== Survey of Application Delivery Patterns

Traditional Multi-Page Applications (MPAs) trigger full document round-trips on navigation, relying on server-side HTML generation for each route. While effective for search engine indexing, this model is ill-suited to FactStamp. Interactive verification queues and live notifications require continuous state synchronization without page reloads, particularly when incoming reviews alter a claim's confidence score in real time.

Server-Side Rendering (SSR) and hybrid frameworks such as Next.js or Remix render initial HTML on a server to accelerate first contentful paint, hydrating into a client-side application thereafter. Executing this rendering logic, however, requires a persistent Node.js runtime or serverless invocation budget. FactStamp operates under a zero-cost infrastructure constraint that rules out paid server runtimes.

Single Page Applications (SPAs) deliver static HTML, CSS, and pre-bundled JavaScript to the client browser, delegating view routing and rendering entirely to the client runtime. While SPAs sacrifice out-of-the-box search indexing, static distribution eliminates application server dependencies and simplifies deployment. Client-side execution also fits the system's requirement to run compute tasks, such as in-browser OCR processing and PNG card rasterization, directly on user devices.

Evaluating backend infrastructure involves weighing a custom Express and Node service against a managed Backend-as-a-Service (BaaS) model. A custom backend grants fine-grained control over endpoints, but requires dedicated maintenance of database migrations, authentication middleware, and WebSocket infrastructure for real-time distribution. Conversely, a BaaS platform such as Firebase or Supabase supplies authentication, document storage, and live synchronization as managed cloud primitives. The client communicates directly with these services, enforcing security constraints through declarative database rules rather than procedural server handlers.

=== FactStamp's Architecture: React SPA + Firebase BaaS

The production build deploys without a custom application gateway. Server-side rendering and hybrid frameworks were rejected because dedicated Node runtimes incur recurring hosting fees. Building a custom API server was equally unnecessary: FactStamp requires real-time data delivery across the verification queue and user notifications, which Cloud Firestore provides natively through `onSnapshot` listeners without dedicated WebSocket infrastructure.

Firebase handles core backend responsibilities through three integrated cloud primitives:
- Firebase Authentication manages password credentials and Google OAuth tokens directly, eliminating custom password hashing routines and session token validation.
- Cloud Firestore supplies the managed NoSQL document store hosting the `users`, `claims`, `notifications`, `reports`, and `audit_logs` collections, accessible directly from the browser runtime.
- Firestore Security Rules (`firestore.rules`) enforce authorization at the database layer rather than through Express middleware. The database engine evaluates write requests against authentication tokens and document invariants, preventing unauthorized clients from bypassing the consensus rules defined in `ClaimsContext.tsx`.

Because the system operates without an application server, standard backend tasks execute within the client browser. These include OCR character extraction, client-side image compression, PNG card rasterization, Jaccard duplicate calculation, and weighted quorum consensus scoring.

=== Deployment Targets

Static SPA compilation decouples client bundle distribution from database infrastructure. FactStamp supports multiple hosting configurations, each enforcing strict HTTP security headers including Content-Security-Policy, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, and `Referrer-Policy` (with HSTS and `Permissions-Policy` active on Firebase Hosting):

- Firebase Hosting (`firebase.json`) provides the primary production environment, paired with the project database and authentication setup. It connects with the Firebase Local Emulator Suite (Auth `:9099`, Firestore `:8080`, Storage `:9199`, Emulator UI `:4000`) for reproducible offline development and automated testing.
- Vercel (`vercel.json`) supplies static edge hosting with matching security header policies, used for branch previews.
- Docker and Nginx (`Dockerfile`, `docker-compose.yml`, `nginx.conf`) configure a multi-stage container build compiling static assets with Node 20 and serving them through `nginx:1.27-alpine`. This target provides an on-premises deployment option for restricted or air-gapped campus environments.

Since application state persists within Firestore rather than host filesystems, shifting between these hosting environments requires zero application code modification.

#heading(level: 2, outlined: false)[Frontend Frameworks]

=== UI Framework: React 18.3.1

React 18.3.1 was selected over alternatives like Vue 3 or Svelte due to the maturity of its Firebase bindings and the capabilities of its native Context API. Application state decomposes into five isolated Context providers: `AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, and `UsersContext`. Because state transitions remain encapsulated within these discrete domains, pairing Context with `useReducer` handlers meets all synchronization requirements without introducing external state management libraries such as Redux or Zustand.

=== Type Safety: TypeScript 5.5

TypeScript 5.5 in strict mode enforces schema compliance across client routines, with `tsc -b` validating type integrity prior to Vite bundling. Strict typing is necessary because Firestore enforces no server-side document schemas, meaning malformed or legacy documents can reach the client. Document mapping routines such as `mapFirestoreDocToClaim` in `src/services/firebaseService.ts` validate incoming payloads against strict interface contracts defined in `src/lib/types.ts`, catching schema mismatches at compile time before data reaches consensus components.

=== Build Tooling: Vite 5.4

Vite 5.4 replaced legacy configurations such as Create React App and manual Webpack setups. Vite couples native ES module development serving with a Rollup-based production pipeline. In `vite.config.ts`, manual chunking splits vendor dependencies into discrete bundles: `vendor-react`, `vendor-firebase`, `vendor-ui`, `vendor-charts`, `vendor-html-to-image`, and `vendor-ocr`. Isolating large libraries like Tesseract.js and Firebase allows the browser to cache them independently across deployments, speeding up repeat page loads. In development, the local Vite server mirrors production security headers (`X-Frame-Options`, CSP, `X-Content-Type-Options`) to uncover header conflicts prior to staging.

=== Animation Layer: Framer Motion 12

Framer Motion 12 manages complex JavaScript animations across the interface, including staggered card reveals on the landing page (`src/pages/Home.tsx`, `staggerChildren`), spring-physics panels and progress indicators on the profile view (`src/pages/Profile.tsx`), and interaction states in `LoadingButton` (`src/components/ui/LoadingButton.tsx`). Lightweight transitions remain in pure CSS: the verdict press effect uses `@keyframes stamp-press` in `src/index.css` via `src/components/VerdictStamp.tsx`, while the theme toggle switch (`src/components/ui/ThemeToggle.tsx`) uses standard Tailwind transition utilities. Framer Motion is reserved for physics-based spring easing and sequenced DOM mounts that CSS keyframes cannot coordinate cleanly.

#heading(level: 2, outlined: false)[Styling and Design Tokens]

=== Tailwind CSS v4

Tailwind CSS v4 integrates via `@tailwindcss/vite`, configuring styling rules directly in CSS without `tailwind.config.js` or separate PostCSS tooling. The styling layer defines OKLCH design tokens: a cream background, saffron brand accents, and distinct chromatic assignments across the five verdict outcomes (True, False, Misleading, Unverifiable, and Contested). Each verdict badge pairs color with a dedicated Lucide icon, keeping status indicators legible for users with color vision deficiencies.

=== Perceptual Uniformity with OKLCH

FactStamp adopts the OKLCH color space (Lightness, Chroma, Hue in Oklab space) rather than legacy `rgb()` or `hsl()` formats. OKLCH offers perceptual uniformity: varying the lightness parameter produces a consistent change in perceived brightness across all hues. This characteristic enables consistent, accessible color ramps across interface states. Because `oklch()` and `oklab()` belong to the newer CSS Color Module Level 4 specification, certain canvas rasterization libraries fail to parse them, an issue directly influencing the card export architecture detailed in Section 2.6.

=== Utility Class Composition: `clsx` and `tailwind-merge`

Dynamic Tailwind class concatenation often generates conflicting utility assignments when multiple classes target identical CSS properties. To resolve specificity conflicts, the project combines `clsx` and `tailwind-merge` within a centralized `cn()` helper function in `src/lib/utils.ts`. The merge algorithm resolves class namespaces and retains the latest declared property, enabling clean conditional styling across components.

#heading(level: 2, outlined: false)[Cloud Databases]

=== Firebase v12 as Backend Infrastructure

Selecting Firebase v12 over a self-hosted PostgreSQL and Express deployment eliminates server maintenance overhead while providing native `onSnapshot` listeners for real-time document streaming. Firebase Authentication handles user credentials directly via email and password logins or Google OAuth, removing the need for custom session tokens or password hashing logic.

To respect free-tier bandwidth and storage quotas without provisioning dedicated Firebase Storage buckets, incoming screenshots undergo client-side JPEG compression in `src/lib/imageCompression.ts`. The resulting base64 data URLs are embedded directly into the claim document, keeping asset storage within Spark free-tier allowances.

=== Cloud Firestore: Document Model and Embedded Arrays

Cloud Firestore organizes application state into collections for `users`, `claims`, `notifications`, `reports`, and `audit_logs`. A central schema decision involved whether to persist verifications within an embedded document array or as a separate subcollection.

The system stores verifications directly in an array attribute on the claim document. When `subscribeClaimsRealtime` executes, the client retrieves the full claim record and its complete verification history in a single document read, avoiding N+1 read operations when rendering the verification queue. While subcollections handle high-cardinality nested items effectively, FactStamp caps verification cohorts at a three-verifier quorum target. Querying a separate subcollection for every claim would rapidly deplete free-tier query quotas without providing query advantages.

=== Firestore Security Rules

The `firestore.rules` configuration enforces database constraints directly on the server during write operations. When an authenticated user submits a verification, rule invariants verify that `verificationCount` increments by exactly 1, that the record contains the author's valid `uid`, and that the user's reputation matches the database record. This server-side validation blocks unauthorized writes attempted through direct REST requests, maintaining data integrity without requiring custom API endpoints.

=== Data Visualization: Recharts 2.10

Recharts 2.10 generates visual analytics from Firestore collections. Implementations include the lazy-loaded verdict distribution pie chart on the public dashboard (`src/pages/Dashboard.tsx`, `src/components/DashboardChart.tsx`) and category distribution bar charts in the Admin console (`src/pages/Admin.tsx`). The weekly trend analysis (`src/lib/weeklyReport.ts`) and verifier leaderboard consume the same underlying data formatted into ranked tables. Recharts was selected over D3 because its React component bindings accelerate chart construction while providing sufficient styling flexibility for standard visual metrics.

#heading(level: 2, outlined: false)[OCR Engines]

=== Evaluation of Approaches

Incoming WhatsApp forwards frequently arrive as screenshot images rather than plain text, requiring optical text extraction. Three primary implementation pathways were evaluated:

- Cloud vision services: Google Cloud Vision and AWS Textract recognize text accurately over HTTPS, but they charge per-request fees and require transmitting user images to external cloud infrastructure.
- Multimodal language model endpoints: these extract the text and evaluate the claim in a single call. Against that they carry recurring token fees, they add network latency, and using one means sending a personal messaging screenshot to a third party.
- In-browser Tesseract.js via WebAssembly: runs the complete recognition pipeline locally, avoiding external API calls, bandwidth fees, and cloud data egress.

=== In-Browser OCR: Tesseract.js 7.0

FactStamp implements Tesseract.js 7.0 locally using WebAssembly (`src/services/ocrService.ts`, `createWorker`). Running OCR inside the browser satisfies three primary project constraints:

- Privacy protection: WhatsApp screenshots regularly display phone numbers and contact headers. Processing images on the client ensures that sensitive chat metadata never leaves the submitter's device.
- Zero operating cost: Commercial vision APIs bill on a per-image basis, which conflicts with the project's zero-budget mandate. In-browser processing incurs no incremental cost as submission volume grows.
- Offline resilience: Once the browser caches the Tesseract WebAssembly binary and language training data, character extraction operates reliably regardless of network stability.

=== Trade-offs and Mitigation

Client-side WebAssembly OCR delivers lower raw character accuracy than cloud neural models, particularly on low-resolution or compressed mobile screenshots. Two mechanisms counter this limitation. First, `cleanExtractedOcrText()` applies regular expressions to strip mobile UI artifacts such as battery meters and chat timestamps. Second, the user interface places extracted text into an editable input area, allowing submitters to review and correct misread characters manually before submitting.

#heading(level: 2, outlined: false)[Card Export Engines]

=== Evaluation of Approaches

Exporting styled DOM nodes into downloadable PNG cards can be accomplished through several browser rendering techniques:

- Raw HTML5 Canvas API: redraw every visual element onto a `<canvas>` with imperative drawing calls. This gives low-level graphical control, but line wrapping, padding, and font metrics all have to be calculated by hand.
- `html2canvas`: inspects the DOM and reconstructs the elements onto an HTML5 canvas using a custom JavaScript CSS parser. That parser trails the browser's own and regularly fails on newer CSS specifications.
- `html-to-image`: converts the target DOM element into an SVG `<foreignObject>` and lets the browser's native rendering engine paint the markup before rasterizing it to a PNG. It relies on browser-native CSS support instead of an incomplete JavaScript parser.

=== FactStamp Implementation: `html-to-image`

FactStamp uses `html-to-image` to generate shareable fact-check cards (`src/components/FactCheckCard.tsx`). Intermediate canvas parsers like `html2canvas` fail on CSS Color Level 4 syntax, notably the `oklch()` and `oklab()` color functions used throughout Tailwind CSS v4. When applied to such elements, canvas re-parsers produce blank or corrupted backgrounds.

By wrapping the card markup in an SVG `<foreignObject>`, `html-to-image` delegates rendering directly to the browser's native engine, rendering OKLCH colors with full chromatic fidelity. The export routine outputs a 1080#text[ ]px wide PNG card (a 540 CSS-pixel element captured at a 2#sym.times pixel ratio), with vertical dimensions scaling dynamically based on claim text and citation lengths.

#heading(level: 2, outlined: false)[Consensus Models]

=== Survey of Consensus Paradigms

Beyond frontend and database libraries, the consensus model governs how community evaluations settle into definitive claim verdicts. Four operational paradigms were reviewed:

- Single-moderator editorial decision: Traditional fact-checking agencies such as Snopes or AltNews employ professional journalists to investigate claims and issue verdicts. While thorough, centralized editorial desks cannot keep pace with the velocity of viral forwards circulating in closed messaging groups.
- Simple majority voting: Reviewers cast unweighted votes and the plurality verdict prevails. While intuitive, unweighted voting treats all participants identically regardless of track record, and masks consensus certainty: a 2 to 1 split produces the identical verdict to a 10 to 1 consensus.
- Byzantine fault tolerant (BFT) distributed consensus: Protocols like PBFT and Proof-of-Stake establish consensus among untrusted network nodes. However, BFT consensus validates transaction integrity and ordering rather than epistemic truth; it confirms that an assertion was recorded, but offers no metric for evidence validity or verifier credibility.
- Weighted quorum consensus: A minimum quorum of reviewers must participate before settling a verdict, after which confidence scoring incorporates verifier accuracy and evidence quality. This model preserves transparent participation while weighting outcomes by demonstrated verifier reliability.

=== FactStamp Implementation: Weighted Quorum Consensus

FactStamp implements a weighted quorum model requiring a minimum of three verifications before computing a consensus verdict. The confidence calculation is implemented in `src/lib/confidenceScore.ts`.

Enforcing a minimum of three verifications establishes a baseline participation floor. Once quorum is satisfied, the engine derives confidence across three weighted factors:

- Agreement ratio (40% weight): The percentage of participating verifiers whose individual verdict aligns with the majority decision.
- Average verifier reputation (30% weight): The arithmetic mean of historical reputation scores among participating verifiers, so that assessments from experienced verifiers carry greater weight than votes from newly created accounts.
- Source quality score (30% weight): Evaluated by `determineSourceQuality()` and `sourceQualityToScore()`. The system matches cited domains against verified tiers, granting maximum weight to authoritative domains (`who.int`, `pib.gov.in`, `rbi.org.in`), moderate weight to established press outlets, and baseline scores to unverified links.

Unlike BFT protocols designed for anonymous nodes, FactStamp tracks participant reputations, weighting community evaluations by documented reviewer reliability.

=== Supporting Mechanisms: Duplicate Pre-Filtering and Consensus Expiry

To avoid redundant verification workloads, `findDuplicate()` in `src/lib/duplicateDetection.ts` checks incoming text against the existing claim corpus prior to submission. The routine tokenizes the input text and computes Jaccard similarity across tokens exceeding three characters.

If the computed similarity meets or exceeds 0.75 (the `threshold` setting in `findDuplicate()`), the system redirects the user to the existing claim rather than creating a duplicate entry. This pre-filtering prevents near-identical forwards from fragmenting community review effort.

Claims that fail to reach majority consensus within seven days transition automatically to the `CONTESTED` state. In volunteer-driven verification workflows, some claims fail to attract three evaluations or reach decisive agreement. Enforcing an automatic deadline guarantees that every claim eventually settles into a final state rather than remaining permanently unresolved in the active queue.

#heading(level: 2, outlined: false)[Technology Selection Matrix]

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
  "Duplicate Handling", [Jaccard token-similarity (0.75 threshold)], "No pre-filtering / exact-string matching", "Prevents redundant quorum queues for reworded duplicates.",
  "Hosting", "Firebase Hosting / Vercel / Docker + Nginx", "AWS / bare-metal VPS", "Zero-ops static hosting matching the BaaS backend; Docker kept as an on-prem escape hatch."
)

=== Supporting Libraries

#styled-table(
  columns: (1.3in, 1fr),
  headers: ("Library", "Purpose"),
  "lucide-react", "Icon system, chosen over emoji or icon fonts, per the design system's explicit ban on emoji in UI.",
  "sonner", "Toast notification primitives.",
  "react-router-dom v6", "Client-side routing (/, /submit, /verify, /claim/:id, /dashboard, /profile, /admin, etc.).",
  "clsx + tailwind-merge", "Conditional Tailwind class composition (the cn() helper in src/lib/utils.ts).",
  "firebase-tools (dev)", "Local Emulator Suite CLI, used by npm run emulators.",
  "Recharts 2.10", "Declarative React charting for the analytics dashboard and Admin console (category distribution, verdict distribution)."
)

=== Reading the Matrix

Two guiding principles unite the technology selections in this matrix. First, operational cost minimization governs architecture decisions: pairing Firebase BaaS, embedded document arrays, client-side WebAssembly OCR, and static edge hosting offloads compute requirements to client runtimes and managed free tiers. Second, native browser capabilities take precedence over custom runtime parsers: `html-to-image` delegates rendering directly to browser SVG layout engines rather than fragile canvas-based CSS parsers, while Firestore Security Rules enforce access constraints directly at the database boundary. Within this framework, the weighted quorum consensus model is the central algorithmic mechanism, translating distributed community evaluations into objective, verified verdicts.
