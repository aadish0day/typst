#import "../lib/helpers.typ": *

= Implementation and Testing

== Implementation Approaches

=== Project Summary

FactStamp was implemented as a single-page web application (SPA): React 18.3.1 on Vite 5.4, written in strict TypeScript 5.5, styled with Tailwind CSS v4, and backed entirely by Firebase v12 (Authentication, Cloud Firestore, Storage) as a Backend-as-a-Service. There is no custom Node/Express server anywhere in the stack: every module (authentication, claim ingestion, duplicate detection, the verification queue, the consensus engine, the PNG card generator, and the analytics dashboard) is a client-side TypeScript module that reads and writes Firestore directly, gated by declarative `firestore.rules`. This "thin client, thick edge" architecture was chosen deliberately (Chapter 2, Survey of Technologies) to keep the whole system operable within Firebase's free Spark tier with zero dedicated DevOps effort.

Implementation proceeded module-by-module rather than screen-by-screen: each of the 8 core system modules (Auth #sym.amp Reputation, Forward Submission/OCR, Duplicate Detection, Verification Queue, Weighted Consensus, Fact-Check Card Generator, Analytics Dashboard, and Security #sym.amp Notifications) was built, wired into a dedicated React Context or `src/lib/*.ts` utility file, and manually exercised against the Firebase Local Emulator Suite before being connected to the next module downstream. This module-first sequencing meant the Jaccard duplicate-detection engine and the weighted consensus formula, the two pieces of genuine algorithmic complexity in the system, were implemented and hand-verified in isolation (as pure functions with no Firebase dependency) before being wired into the stateful `ClaimsContext` that drives the live UI.

The overall system architecture below shows how those modules compose into the end-to-end claim pipeline, from an incoming WhatsApp forward through duplicate detection, the quorum queue, and the consensus engine, to the exportable fact-check card and the public analytics dashboard, with Cloud Firestore and its declarative security rules as the single shared backend beneath them.

#align(center)[#image("attachments/system_architecture.svg", width: 92%)]

=== Incremental, Agile Delivery

Development followed an *iterative, incremental Agile process* rather than a Waterfall sequence, consistent with the SDLC model comparison in Chapter 2 and the Scrum framework referenced in `template/2020-Scrum-Guide-US.md` and `template/SCRUM_Model.md`. Work was organized into four broad sprint-like phases (as reflected in the Project Synopsis's milestone schedule):

+ *Foundation #sym.amp Ingestion Pipeline:* React/Vite/Firebase scaffolding, Firebase Auth wiring, the claim submission form, client-side image compression, OCR text extraction, and the Jaccard duplicate-detection algorithm.
+ *Quorum #sym.amp Consensus Engine:* the public Verification Queue, the 3-verifier quorum voting workbench, the weighted consensus formula, verifier reputation scoring, and the Firestore security rules that back all of the above server-side.
+ *Card Generator #sym.amp Analytics Subsystem:* the `html-to-image` 1080px-wide card export pipeline, the Recharts-based misinformation-trends dashboard, and real-time in-app notifications.
+ *Security Hardening #sym.amp Documentation:* the OWASP-style client hardening in `src/lib/security.ts` (rate limiting, file-upload validation, anti-spam explanation checks), cross-browser verification, and this dissertation.

Each phase produced a working, demonstrable increment of the product rather than a partial, unusable slice of every screen at once: a claim could already be submitted, deduplicated, and queued for verification before the confidence-score formula or the PNG card generator existed. This incremental delivery model let algorithmic tuning (e.g. adjusting the Jaccard stop-word length filter, or the 40/30/30 confidence weighting) happen against a small but real, exercised codebase rather than against a design document.

=== State Management: React Context, Not Redux

FactStamp's client-side state is managed entirely through React's built-in Context API (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, and `UsersContext`), with no external state library (Redux, Zustand, MobX) in the dependency tree. Three things made that workable:

- The application's state graph is *shallow and loosely coupled*: five independent concerns (identity, claims, notifications, theme, the user directory) that rarely need to read each other's internal state, unlike a large e-commerce or IDE-style application where dozens of features share a single normalized store.
- Each Context already owns exactly the Firestore real-time listener (`onSnapshot`) relevant to its domain, so the "single source of truth" that Redux exists to enforce is already naturally provided by Firestore itself: Redux would mean synchronizing a client-side store with a server-side real-time store, which is duplicated bookkeeping with no benefit.
- Context plus plain `useState`/`useCallback` avoids Redux's action-type/reducer/dispatch boilerplate entirely, which for a solo-developer academic project reduces both the amount of code to maintain and the amount of code a grader has to read to verify correctness.

The trade-off (Context re-renders every consumer on any state change, which does not scale to a large, deeply-nested store) is acceptable here because each Context's consumer tree is small, a handful of pages and components per concern, so re-rendering it costs almost nothing.

=== Firebase as Backend-as-a-Service

Choosing Firebase (Auth + Firestore + Storage) over a custom server was the single implementation decision with the largest downstream effect on the rest of the codebase:

- There is no server to operate: no REST/GraphQL API layer, no server-side session management, and no infrastructure to patch, scale, or monitor. `src/services/firebaseService.ts` talks to Firestore directly from the browser, and `firestore.rules` is the only "backend logic" that exists, expressed declaratively rather than imperatively.
- Real-time listeners come for free: the Verification Queue, the live notification bell, and the admin console's Incident Queue and Audit Log all rely on Firestore's `onSnapshot()` primitive, a feature that would otherwise require hand-rolling a WebSocket server and client reconnection logic.
- *The Firebase Local Emulator Suite* (Auth on port 9099, Firestore on port 8080, Storage on port 9199, with an inspection UI on port 4000, run via `npm run emulators`) reproduces the entire backend locally, which is what makes the module-by-module, hand-verified implementation approach above practical: every module could be built and tested against a real (if local) Firestore instance from day one, without touching production data or requiring network connectivity.

This BaaS-first approach let implementation effort concentrate on the parts of the system that are actually novel to this project (the Jaccard duplicate engine, the weighted consensus formula, the OCR/WhatsApp-chrome cleanup pipeline, and the OKLCH-aware PNG card renderer) rather than on undifferentiated backend plumbing (auth flows, session tokens, database drivers) that Firebase already solves.

== Coding Details and Code Efficiency

=== Coding Approach by Module

Each of FactStamp's 8 core modules is implemented as a small, focused cluster of files rather than a monolithic controller. The coding conventions applied consistently across all of them are:

- Algorithmic logic is written as pure functions. The two mathematically load-bearing pieces of the system, Jaccard duplicate similarity (`src/lib/duplicateDetection.ts`) and weighted consensus scoring (`src/lib/confidenceScore.ts`), are written as pure, side-effect-free functions that take plain data in and return plain data out. Neither file imports React or Firebase. This was a deliberate coding choice: it makes both functions trivially callable from a Node REPL or a throwaway script for manual verification (see 5.3.1), independent of the UI or the database being available.
- Strict TypeScript interfaces guard every boundary. `src/lib/types.ts` defines the canonical `Claim`, `Verification`, `User`, and `Verdict` shapes; every function that touches Firestore data (e.g. `mapFirestoreDocToClaim` in `src/services/firebaseService.ts`) narrows an untyped Firestore document into one of these interfaces immediately on read, so a malformed or legacy-shaped document cannot silently propagate `undefined` fields into the consensus computation.
- Context providers are the only stateful layer. UI components consume state exclusively through `useAuth()`, `useClaims()`, `useNotifications()`, etc.; no component reaches into Firestore directly. This keeps the Firestore read/write surface auditable to a handful of files (`src/services/firebaseService.ts` plus the five Context files) instead of scattered across dozens of page components.

*Duplicate Detection Engine (`src/lib/duplicateDetection.ts`)*

The engine normalizes text (lowercase, strip punctuation, collapse whitespace), tokenizes it into a set of words longer than 3 characters (a lightweight stop-word filter), and computes the Jaccard index between the incoming claim and every existing claim:

// Short excerpt (24 lines) — kept on one page so the function body is never
// torn mid-expression across a page boundary.
#block(breakable: false)[
```typescript
function tokenize(text: string): Set<string> {
  return new Set(
    normalize(text)
      .split(/\s+/)
      .filter((word) => word.length > 3) // ignore short words
  )
}

function jaccardSimilarity(a: string, b: string): number {
  const setA = tokenize(a)
  const setB = tokenize(b)

  if (setA.size === 0 && setB.size === 0) return 1
  if (setA.size === 0 || setB.size === 0) return 0

  let intersection = 0
  for (const word of setA) {
    if (setB.has(word)) intersection++
  }

  const union = setA.size + setB.size - intersection
  return intersection / union
}
```
]

`findDuplicate()` then linearly scans the existing claim corpus, keeping the highest-scoring match above the `0.75` threshold and returning `null` when nothing clears it: a submission is only ever redirected to an existing claim, never silently merged, so the calling code in `ClaimsContext` retains full control over what happens next.

*Weighted Consensus Engine (`src/lib/confidenceScore.ts`)*

Once a claim has accumulated verifications, `calculateConfidenceScore()` combines three independently-computed 0--100 components into the final confidence percentage:

// Short excerpt (24 lines) — kept on one page. Previously this block split
// across a page boundary, tearing the "// 3. Source quality score" section
// away from the weighted calculation it feeds.
#block(breakable: false)[
```typescript
// 1. Agreement ratio: How many verifications agree with the majority verdict
const verdicts = verifications.map((v) => v.verdict);
const majorityCount = Math.max(
  ...Array.from(new Set(verdicts)).map(
    (v) => verdicts.filter((x) => x === v).length,
  ),
);
const agreementRatio = (majorityCount / verifications.length) * 100;

// 2. Average reputation of all verifiers
const avgReputation =
  verifications.reduce((sum, v) => sum + v.verifierReputation, 0) /
  verifications.length;

// 3. Source quality score (average)
const sourceQualityScore =
  verifications.reduce((sum, v) => sum + v.sourceQuality, 0) /
  verifications.length;

// Weighted calculation
const score = Math.round(
  agreementRatio * 0.4 + avgReputation * 0.3 + sourceQualityScore * 0.3,
);
```
]

The function is intentionally shape-agnostic about *where* `verifierReputation` and `sourceQuality` come from: `ClaimsContext.tsx` is responsible for resolving each verifier's live reputation and converting their cited source URL's domain (via `determineSourceQuality()`, exported alongside the scorer from `src/lib/confidenceScore.ts`) into a `high` / `medium` / `low` tier and then a numeric score (`sourceQualityToScore()`) before calling into this function. Keeping the scoring math itself free of that resolution logic is what makes it independently, manually testable (5.3.1).

*Other Modules*

- *Auth #sym.amp Reputation* (`AuthContext.tsx`) wraps Firebase Auth's email/password and Google OAuth flows and mirrors the signed-in user's Firestore `users/{uid}` profile (including `reputation`, base value 50) into React state via a live listener.
- *Ingestion #sym.amp OCR* (`Submit.tsx`, `ocrService.ts`, `imageCompression.ts`) chains client-side image compression, a Tesseract.js WebAssembly OCR pass, and a WhatsApp-chrome regex cleanup (`cleanExtractedOcrText()`) before the extracted text is ever shown to the user for confirmation.
- *Verification Queue* (`VerifyQueue.tsx`, `VerifyDetail.tsx`) renders pending claims and funnels every submitted verdict through `validateVerdictExplanation()` in `src/lib/security.ts` (minimum 50 characters / 8 words) before it reaches `ClaimsContext`.
- *Card Generator* (`FactCheckCard.tsx`) is a plain, deterministic React component laid out at a 540px card width; `html-to-image` rasterizes it client-side at `pixelRatio: 2` on export, yielding a 1080px-wide PNG with no server round-trip.
- *Analytics Dashboard* (`Dashboard.tsx`, `weeklyReport.ts`) derives all charts from data already held in `ClaimsContext` and `UsersContext`; no additional Firestore queries are issued purely for the dashboard.

=== Code Efficiency

*Vite Manual Chunk-Splitting*

`vite.config.ts` explicitly partitions the production bundle into six vendor chunks instead of relying on Vite's default automatic chunking:

// Short excerpt (16 lines) — kept on one page so the nested `manualChunks`
// object is never split mid-literal across a page boundary.
#block(breakable: false)[
```typescript
build: {
  chunkSizeWarningLimit: 1000,
  rollupOptions: {
    output: {
      manualChunks: {
        'vendor-react': ['react', 'react-dom', 'react-router-dom'],
        'vendor-firebase': ['firebase/app', 'firebase/auth', 'firebase/firestore', 'firebase/storage'],
        'vendor-ui': ['lucide-react', 'framer-motion'],
        'vendor-charts': ['recharts'],
        'vendor-html-to-image': ['html-to-image'],
        'vendor-ocr': ['tesseract.js'],
      },
    },
  },
},
```
]

This matters because Tesseract.js and the Firebase SDK are both large and change far less often than the application's own code. Without explicit splitting, a single application code change would invalidate one large bundle containing everything; with `vendor-ocr` and `vendor-firebase` isolated, a returning user's browser cache continues to serve those chunks unchanged across most deployments, and a user who never visits `/submit` (and therefore never needs OCR) can, with route-level lazy loading, avoid downloading the Tesseract WASM chunk at all on first load.

*Firestore Schema: Embedded Verifications, Not a Subcollection*

Verifications are stored as an embedded array field directly on each `Claim` document rather than as a separate `verifications` subcollection keyed by claim ID. This is a deliberate denormalization: it means the real-time claims listener (`subscribeClaimsRealtime` in `firebaseService.ts`) can reconstruct a complete `Claim` (text, status, verdict, and every verification cast against it) from a *single document read*, rather than needing one query for the claim plus a second query per claim for its verifications (an N+1 read pattern that would multiply Firestore read costs linearly with the number of claims rendered in the Verification Queue list view). The trade-off, accepted because a claim requires only a 3-verification quorum rather than an open-ended comment thread, is that each claim document must stay under Firestore's 1 MiB per-document limit, which is also why claim screenshots are compressed before being embedded rather than stored as raw uploads.

*Client-Side Image Compression Before Firestore Writes*

Screenshots submitted with a claim are compressed client-side (`src/lib/imageCompression.ts`, via the HTML5 Canvas API) to a bounded resolution before being base64-encoded and written directly onto the claim document. This keeps the combined size of claim text, verification array, and screenshot data comfortably under Firestore's 1 MiB document ceiling without provisioning a paid Cloud Storage bucket for the primary image path, and it means the OCR pass in `ocrService.ts` also runs against a smaller, already-normalized image, which is faster and more memory-stable inside the Tesseract.js WebAssembly worker than running OCR against an uncompressed multi-megapixel photo.

*Memoization and Real-Time Listener Patterns in Contexts*

Each Context subscribes to exactly one Firestore real-time listener for its domain (`onSnapshot`) and derives all downstream values from that single subscription rather than re-querying per consumer. Expensive derived values, such as the weekly trending-misinformation report in `weeklyReport.ts` and the dashboard's category/verdict aggregations, are computed with `useMemo` keyed on the underlying `claims` array reference, so a re-render triggered by an unrelated state change (e.g. the theme toggling) does not re-run the rolling 7-day aggregation. Listener cleanup is handled uniformly: every `useEffect` that opens an `onSnapshot` subscription returns the corresponding unsubscribe function, preventing the duplicate-listener leaks that would otherwise silently multiply Firestore read billing every time a component using `useClaims()` mounted and unmounted (e.g. navigating away from and back to the Verification Queue).

== Testing Approach

FactStamp's repository contains no automated test runner: `package.json` defines only `dev`, `build`, `preview`, `typecheck`, `emulators` (and its `:persist`/`:export` variants), `seed:db`, `create:admin`, and `create:user`; there is no `test` script, and no `*.test.ts` / `*.spec.ts` file exists anywhere under `src/`. The project's quality assurance is therefore *manual and structured*, not backed by a Jest/Vitest suite running in CI. The single automated safety net that does exist is the `typecheck-and-build` job in `.github/workflows/ci.yml`, which runs `npm ci`, `npm run typecheck` (`tsc --noEmit`), and `npm run build` (`tsc -b && vite build`) on every push; this catches type errors and build breakages, but not logical or behavioral regressions. Given that constraint, testing was organized into three deliberate, manually-executed layers: unit-level verification of the two pure algorithmic modules, integration testing across Firebase service boundaries using the Local Emulator Suite, and full end-to-end system/beta walkthroughs of real user journeys.

=== Unit Testing

Because `duplicateDetection.ts` and `confidenceScore.ts` are pure, dependency-free TypeScript functions, they were manually unit-verified by calling them directly with hand-constructed inputs and checking the returned value against a hand-computed expected result, the same discipline an automated `it(...)` block would apply, executed manually in the absence of a test runner.

*Duplicate Detection: `findDuplicate()` / Jaccard Similarity*

// Cells written as content blocks [...], not strings "...": a string cell does
// not parse markup, so `raw`, *bold*, --- and #sym.* would print literally.
// Column 4 widened to 1.0in so the unbreakable `J = 0.00` raw token fits.
#styled-table(
  columns: (0.5in, 1.2fr, 1.2fr, 1.0in, 1.25in),
  headers: ("Case", "Claim A (incoming)", "Claim B (existing)", [Tokens |A|, |B|, |∩|, |∪|], "Expected Outcome"),
  "1", ["Free COVID vaccine registration open nationwide today"], "(identical string)", [7, 7, 7, 7 #sym.arrow.r `J=1.00`], [Flagged duplicate (`J >= 0.75`); redirected to existing claim.],
  "2", ["Drinking hot lemon water every morning cures dengue fever immediately"], ["...cures dengue fever instantly" (one word changed)], [9, 9, 8, 10 #sym.arrow.r `J=0.80`], [Flagged duplicate (`J >= 0.75`); redirected to existing claim.],
  "3", ["Eating raw garlic cures corona virus infection completely"], ["Eating garlic cures corona virus disease naturally"], [7, 7, 5, 9 #sym.arrow.r `J=0.56`], [*Not* flagged (`J < 0.75`); queued as a new, independent claim.],
)

Case 3 was specifically constructed to manually verify the threshold's precision/recall trade-off: two claims share a real topical core (garlic curing coronavirus) but diverge enough in wording that treating them as the same claim would risk conflating two distinct viral variants into a single verdict. Manually re-running `findDuplicate()` confirmed it correctly separates Cases 1--2 (redirect) from Case 3 (new claim), matching the `J >= 0.75` threshold specified in Chapter 4's algorithm design.

*Weighted Consensus: `calculateConfidenceScore()`*

// The Formula column previously held one 35-character raw token
// (`(66.67×0.4)+(63.33×0.3)+(53.33×0.3)`, ~7.4cm) inside a ~3.4cm column, so it
// overprinted the Expected column. Each term is now its own raw span, letting
// the formula wrap at the "+" signs.
#styled-table(
  columns: (0.5in, 1.35fr, 1fr, 1.15fr, 0.7in),
  headers: ("Case", "Verifications (verdict, reputation, source quality)", "Expected Agreement / Avg Rep / Source Quality", "Formula", [Expected `score`]),
  "1", [3#sym.times FALSE, reps 80/60/70, quality 100/100/70], "100.00 / 70.00 / 90.00", [`(100×0.4)` + `(70×0.3)` + `(90×0.3)`], [*88*],
  "2", [FALSE/FALSE/TRUE, reps 50/50/90, quality 30/30/100], "66.67 / 63.33 / 53.33", [`(66.67×0.4)` + `(63.33×0.3)` + `(53.33×0.3)`], [*62*],
  "3", [`[]` (empty array, edge case)], "0 / 0 / 0", "Early-return guard, no division by zero", [*0*],
)

Manual computation for Case 1: $C = (100 times 0.40) + (70 times 0.30) + (90 times 0.30) = 40 + 21 + 27 = 88$, matching `Math.round()`'s output exactly. Case 3 confirms the function's explicit early-return guard (`if (verifications.length === 0) return { score: 0, ... }`) rather than a divide-by-zero: this guard was added specifically because a claim can theoretically be read mid-write with zero verifications still attached, and the UI must render a sane `0%` rather than `NaN` in that window.

=== Integration Testing

Integration testing exercises the boundary between modules and Firebase itself, which pure unit tests of `duplicateDetection.ts`/`confidenceScore.ts` cannot cover. All integration testing was performed against the *Firebase Local Emulator Suite* (`npm run emulators`, or `npm run emulators:persist` to retain state across runs), Auth on port `9099`, Firestore on port `8080`, Storage on port `9199`, with the inspection UI on port `4000`, so that Auth, Firestore, and Storage rules could be exercised together without touching the production project or incurring quota usage.

Representative integration scenarios manually executed against the emulator:

+ *End-to-end quorum consensus.* Seed the emulator (`npm run seed:db`), sign in as three distinct seeded verifier accounts in sequence, and submit one verdict each (via `VerifyDetail.tsx`) against the same pending claim. Confirmed: (a) each submitted verification is appended to the claim document's embedded `verifications` array and `firestore.rules` rejects a write attempting to increment `verificationCount` by anything other than exactly 1; (b) once the third verification lands, `ClaimsContext` recomputes the verdict and calls `calculateConfidenceScore()`, and the claim's `status` transitions from `pending` to `verified` in the same Firestore write; (c) the computed confidence score displayed in `ClaimDetail.tsx` matches the manually hand-computed value for the same three verdicts (cross-checked against 5.3.1's formula).
+ *Firestore rules rejecting a forged write.* Attempted (via the Firestore emulator's REST endpoint, bypassing the app's own UI) to write a verification with an inflated `verifierReputation` value not matching the authenticated user's live profile. Confirmed `firestore.rules` rejects the write: the client-side consensus math in `ClaimsContext.tsx` cannot be trusted alone; the server-side rule is the actual enforcement point.
+ *Storage + Auth interaction for screenshot claims.* Attempted to submit a claim with an attached screenshot while signed out: confirmed both `firestore.rules` (`match /claims/{claimId}` #sym.arrow.r `allow create: if request.auth != null`) and `storage.rules` (`match /claim_screenshots/{fileName}` #sym.arrow.r `allow write: if request.auth != null`) reject the write, i.e. claim submission is an authenticated-only path, consistent with `/submit` being wrapped in `ProtectedRoute` in `src/App.tsx`. Re-run while signed in, the same submission succeeded, with the file-type/size constraints from `src/lib/security.ts` still enforced client-side.
+ *Self-verification lock.* Attempted to submit a verification, as the same user who submitted the original claim, against that same claim: confirmed the anti-Sybil self-verification check in the verification workbench blocks the submission client-side before it ever reaches Firestore.
+ *Admin dual-layer authorization.* Manually attempted the documented `sessionStorage.setItem('fs_admin_session_unlocked', 'true')` DevTools bypass against a non-admin seeded account signed in through the emulator; confirmed `AdminRoute.tsx` re-derives `hasVerifiedAdminRole` from the live Firestore-backed `user.isAdmin` snapshot on every render and discards the stale session flag, bouncing back to the login gate.

=== System/Beta Testing

System and beta testing consisted of manually walking through complete, realistic user journeys end-to-end against a running instance of the application (locally via `npm run dev` against the emulators, and separately against a deployed build), rather than testing modules in isolation. The walkthroughs are scripted and repeatable, but they are executed by hand: the repository carries no Playwright or Cypress configuration, just as it carries no `test` script in `package.json`.

*Public submitter journey:*

+ Sign up via `SignUp.tsx` (email/password), confirming a new `users/{uid}` Firestore profile is created with a base reputation of 50.
+ Submit a claim via `Submit.tsx` as a screenshot upload, confirming client-side image compression runs, Tesseract.js OCR extracts readable text into the form, and `cleanExtractedOcrText()` strips WhatsApp timestamp/checkmark chrome from the extracted string.
+ Confirm the duplicate-detection check runs against the existing claim corpus before the claim is queued (submitting a claim already known to be a near-duplicate correctly redirects to the existing claim's page instead of creating a new one).
+ Confirm the new claim appears in `VerifyQueue.tsx` for other users, and that the submitter receives a real-time in-app notification once three verifications resolve the claim.
+ Open `ClaimDetail.tsx` once resolved, confirm the verdict badge, confidence percentage, and source list render correctly, and export the fact-check PNG card via `html-to-image` (1080px wide, from a 540px card at `pixelRatio: 2`, with the height growing to fit the claim text and source list), confirming the OKLCH-based theme colors rasterize correctly (the specific failure mode the legacy canvas parser could not handle; see Section 5.4).

*Community verifier journey:*

+ Sign in as a seeded verifier account, open the Verification Queue, and select a pending claim.
+ Attempt to submit a verdict with a short, low-effort explanation ("fake"): confirm `validateVerdictExplanation()` rejects it (below the 50-character / 8-word minimum) with a specific, actionable error message rather than a generic failure.
+ Submit a properly-sourced verdict with a real citation URL; confirm the source-quality tier (`determineSourceQuality()`) is correctly derived from the domain and reflected in the eventual confidence score.
+ Confirm the verifier's own reputation score updates once the claim reaches consensus, consistent with whether their verdict matched the eventual majority.

*Admin console walkthrough:*

+ Navigate directly to the unlisted `/admin` route and authenticate through `AdminRoute.tsx`'s login gate.
+ Walk through all five tabs: System Overview (KPI cards and Recharts visualizations), Verifier Directory (search/filter, edit reputation, toggle `isAdmin`), Claims Moderation (override a verdict, flag a claim for expedited review), Incident Queue (create and resolve a `ModerationReport`), and Audit #sym.amp Tools (confirm every mutating action from the previous steps produced a corresponding `AdminAuditLog` entry, then exercise "force-run consensus expiry" and the JSON database export tool).
+ Confirm the "Lock Console" action clears the session flag and returns to the login gate on the next render.

Every one of these walkthroughs was re-run manually after each of the modifications described in 5.4, to confirm the fix or enhancement did not regress an adjacent user journey, which is the nearest this project gets to the regression safety net a CI-gated test suite would provide.

== Modifications and Improvements

Implementation was not a single linear pass: several capabilities were revised after initial delivery, either to fix a real defect discovered during manual testing (5.3) or to improve on an earlier, weaker implementation. The modifications below are drawn from the project's own `CHANGELOG.md` and the architectural notes in `INDEX.md`.

*1. Verification Queue Auto-Replenishment Fix (Bug Fix)*

Problem discovered: during manual testing, the Verification Queue at `/verify` was found to intermittently display zero pending claims. Root-cause investigation traced this to `applyLocalExpiry()` in `ClaimsContext.tsx`: the automatic 7-day consensus-expiry logic (claims that fail to reach the 3-verifier quorum within their `consensusDeadline` are settled as `CONTESTED`) was correctly resolving overdue claims, but nothing was replenishing the queue with new pending work, so a batch of seeded demo claims could all expire at once and leave the queue empty.

Fix implemented: `scripts/seed-db.mjs` was updated to generate claims with *dynamic future deadlines* (3 to 6 days ahead of the script's execution time). `applyLocalExpiry()` was modified so that whenever expiry processing leaves the database with zero `pending` claims, it automatically replenishes the in-memory claims list with fresh active seed claims (each assigned a new future `consensusDeadline`), guaranteeing the Verification Queue is never left empty. The realtime Firestore subscription cleanup in `subscribeClaimsRealtime()` was also hardened to safely tear down both the primary ordered query listener and its unindexed fallback query, preventing a duplicate-listener leak that could otherwise mask the same symptom. This was manually re-verified by letting seeded claims run past their deadline in the emulator and confirming the queue view always continued to show at least one actionable claim afterward.

*2. Authentication Security Hardening #sym.amp Rate Limiting*

The original sign-in flow had no protection against repeated failed login attempts. `src/lib/security.ts` was extended with a multi-tiered rate limiter: failed attempts are tracked both per-account and globally per browser client, using `localStorage` with a `sessionStorage` fallback so a tab reload or browser close cannot reset the counter. A *5-attempt threshold* triggers a strict *15-minute lockout* (`LOCKOUT_DURATION_MS = 15 * 60 * 1000`), with `formatLockoutRemaining()` driving a live ticking countdown in the sign-in UI, and `resetLoginAttempts()` clearing the counter immediately on a successful login. `SignIn.tsx` was updated to check the rate-limit state before dispatching a network request to Firebase Auth, display an "X/5 attempts left" indicator, and standardize all invalid-credential error copy to a generic "Invalid email or password" message, closing a user-enumeration side-channel. The same rate-limiting primitives were also wired into `AdminRoute.tsx`'s login gate.

*3. Universal Sliding Dual-Icon Theme Toggle Rollout*

Plain, inconsistent icon-only theme buttons scattered across different pages were replaced with a single, reusable `<ThemeToggle />` component: a compact pill container with an animated sliding thumb between `Sun` and `Moon` Lucide icons, fully keyboard-accessible. `ThemeContext.tsx` was expanded to expose an explicit `setTheme` alongside the existing `toggleTheme`. The component was then placed consistently across every surface that previously lacked it or used a bespoke variant: the desktop Navbar and mobile navigation drawer, the Admin Command Center's header and Tools tab, the Admin authentication gate, the Sign In / Sign Up auth panels, and the global footer.

*4. Pan-Indic Typography Migration (Font-Stack Rework)*

The original typography setup loaded three separate Google Font families (`DM Sans`, `JetBrains Mono`, `Lora`) totaling over 120 KB across twelve font files, and had no support for Devanagari script, so Hindi or Marathi text embedded in a WhatsApp forward would render with broken baselines. `DM Sans` was replaced with a single variable Latin font, *Plus Jakarta Sans*, and *Noto Sans Devanagari* was added for native Hindi/Marathi rendering. `JetBrains Mono` was dropped in favor of native CSS `font-variant-numeric: tabular-nums` for reputation ratios, case IDs, and countdown timers, achieving the same fixed-width alignment at *zero additional network payload*. `Lora` styling was removed from quoted forward text in favor of plain message typography.

*5. `html-to-image` Adoption Replacing a Legacy Canvas Parser*

The original fact-check card exporter used a hand-written JavaScript canvas-based CSS parser to rasterize `FactCheckCard.tsx` into a downloadable PNG. Once the design system's colors were expressed in Tailwind v4's native OKLCH/OKLAB color space, this legacy parser (which only understood `rgb()`/hex syntax) could not interpret the card's actual computed styles, and card exports came out visually broken or entirely black. The exporter was rewritten around `html-to-image`, which rasterizes DOM nodes through the browser's own native SVG `<foreignObject>` rendering path rather than a custom CSS interpreter, resolving `oklch()`/`oklab()` exactly as the page itself renders it and eliminating the entire class of color-parsing bugs at the root. Cards now export at a crisp 1080px width, rasterized from the 540px card at a 2#sym.times device pixel ratio, with the height scaling to the card's own content and no layout distortion.

*Summary Comparison*

// Files column widened to 1.8fr (~4.4cm) and the directory prefixes dropped
// (`src/lib/security.ts` -> `security.ts`, `scripts/seed-db.mjs` ->
// `seed-db.mjs`): a raw file path is one unbreakable token, and the full paths
// were wider than any column this table can afford. The paths are given in full
// in the prose of 5.4 immediately above.
#styled-table(
  columns: (1.5fr, 1fr, 1.7fr, 1.8fr),
  headers: ("Modification", "Type", "Root Cause / Motivation", "Files Primarily Touched"),
  "Verification queue auto-replenishment", "Bug fix", "Consensus-expiry logic emptied the queue with nothing to backfill it", [`ClaimsContext.tsx`, `seed-db.mjs`, `firebaseService.ts`],
  [Login rate limiting #sym.amp lockout], "Security hardening", "No brute-force protection on sign-in / admin login", [`security.ts`, `SignIn.tsx`, `AdminRoute.tsx`],
  "Universal theme toggle", "UX consistency improvement", "Inconsistent, bespoke theme controls across pages", [`ThemeContext.tsx`, `ThemeToggle.tsx`, `Navbar.tsx`, `Footer.tsx`, `AuthLayout.tsx`, `Admin.tsx`],
  "Pan-Indic font-stack migration", "Improvement (accessibility + payload)", "No Devanagari support; oversized/misapplied font stack", [`index.html`, `index.css`, `Submit.tsx`],
  [`html-to-image` adoption], "Bug fix / architectural improvement", "Legacy canvas parser could not render OKLCH card colors", [`FactCheckCard.tsx`, `ClaimDetail.tsx`],
)

== Test Cases Execution Matrix

The table below is the *executed* counterpart to Chapter 4.6's test case design: each row was actually run manually (per the approach in 5.3) against a running instance of FactStamp on the Firebase Local Emulator Suite, and the Actual Result / Pass column records the outcome observed on that run. Only one row is marked as a historical failure, corresponding to the verification-queue auto-replenishment defect documented and fixed in 5.4; every other scenario passed on the build current at the time of this dissertation.

// Every cell carrying markup is a content block [...], not a string. Columns
// rebalanced (wider ID/Pass so "TC-01" and "Fail -> Fixed" stop spilling into
// their padding; wider Expected Result for the raw tokens it must hold).
// Identifiers wider than their column were deliberately shortened rather than
// left to overprint: `fs_admin_session_unlocked` (25 chars, ~5.3cm),
// `typecheck-and-build`, `consensusDeadline`, `verifierReputation` and
// `applyLocalExpiry()` are all described in words here; each is named in full
// in the prose of 5.3/5.4 and in Chapter 4's schema tables.
#styled-table(
  columns: (0.55in, 1.12fr, 1.13fr, 1.28fr, 1.12fr, 0.6in),
  headers: ("ID", "Test Condition", "Input", "Expected Result", "Actual Result", "Pass"),
  "TC-01", "New user registration", [Valid email + password via `SignUp.tsx`], "Auth account created; Firestore profile created with base reputation 50", "Account and profile created as expected; auto-signed-in", "Pass",
  "TC-02", "Duplicate email registration", "Email already registered", "Registration rejected with clear error", "Rejected with expected error, no duplicate profile", "Pass",
  "TC-03", "Login lockout after repeated failures", "5 consecutive wrong-password attempts, then a 6th", "Locked 15 min after 5th attempt; 6th blocked before hitting Firebase Auth", "Locked exactly at attempt 5; countdown shown; 6th blocked client-side", "Pass",
  "TC-04", "Text claim submission", [Plain-text WhatsApp forward pasted into `Submit.tsx`], [Claim created (`status` = `pending`), added to Verification Queue], "Claim created and visible in queue within one write", "Pass",
  "TC-05", "Screenshot claim + OCR", "WhatsApp forward screenshot (JPEG) uploaded", "Image compressed; text extracted via Tesseract.js; WhatsApp chrome stripped", "Text extracted and chrome removed; shown for confirmation", "Pass",
  "TC-06", [Duplicate detection: identical claim], "Text identical to existing resolved claim", [`J = 1.00` $>= 0.75$; redirected to existing claim], "Redirected correctly; no new claim created", "Pass",
  "TC-07", [Duplicate detection: near-paraphrase], [Text differing by one word (5.3.1 Case 2, `J = 0.80`)], "Flagged duplicate; redirected", "Redirected correctly", "Pass",
  "TC-08", [Duplicate detection: related but distinct], [Topically similar, below threshold (5.3.1 Case 3, `J = 0.56`)], [*Not* flagged; new claim created independently], "New claim correctly created, not merged", "Pass",
  "TC-09", [Verifier explanation: too short], ["fake", a 4-character explanation], "Rejected client-side before any Firestore write", "Rejected with expected error message", "Pass",
  "TC-10", [Verifier explanation: valid], "50+ char explanation with real citation URL", "Accepted; appended to embedded array; count +1 exactly", "Accepted and appended correctly", "Pass",
  "TC-11", "Self-verification block", "User verifies a claim they submitted themselves", "Blocked client-side with anti-Sybil warning", "Blocked as expected before reaching Firestore", "Pass",
  "TC-12", "3-verifier quorum consensus", "Three distinct verifiers submit a verdict each", [On 3rd verification: `status` #sym.arrow.r `verified`; score matches hand-computed value], "Transition occurred on 3rd verification; score matched exactly", "Pass",
  "TC-13", [Consensus expiry to `CONTESTED`], [Claim's 7-day consensus deadline passes with $< 3$ verifications], [Claim auto-settles with verdict `CONTESTED` via the local expiry sweep], [Claim correctly settled as `CONTESTED` at deadline], "Pass",
  "TC-14", "Verification Queue empties after mass expiry", "All pending seed claims expire simultaneously", "Queue should replenish automatically, never empty", [Pre-fix: queue showed 0 claims (root-caused to 5.4 Mod. 1) #sym.arrow.r Fixed: auto-replenishes with dynamic-deadline seeds], [Fail #sym.arrow.r Fixed],
  "TC-15", "Fact-check PNG card export", [Export a resolved claim's fact-check card], [PNG at 1080px width (540px card @ `pixelRatio: 2`), height scaling to card content; OKLCH theme colors render correctly, no black regions], "Exported at 1080px width with correct colors; height varied with claim/source length as expected", "Pass",
  "TC-16", "Firestore rule rejects forged reputation write", "Direct write with an inflated verifier reputation value (bypassing the UI)", "Write rejected by the Firestore security rules", "Write rejected with permission-denied error", "Pass",
  "TC-17", "Admin session-flag bypass attempt", "Manually set the admin unlock flag in browser session storage on a non-admin account", "Bounced back to admin login gate; role re-derived from live snapshot", "Bounced back correctly; stale flag discarded", "Pass",
  "TC-18", "Admin audit log completeness", "Claim-verdict override in Claims Moderation tab", [Corresponding `AdminAuditLog` entry written], [Audit entry created and visible in Audit #sym.amp Tools tab], "Pass",
  "TC-19", "File-upload validation (disguised file)", [`.exe` renamed to `.jpg`, uploaded as screenshot], "Rejected by extension + MIME + magic-byte signature check", "Rejected at magic-byte check despite renamed extension", "Pass",
  "TC-20", "Idle session timeout", "Authenticated session left inactive 30+ minutes", "Session auto-expires, requires re-authentication", "Session expired at the configured 30-minute threshold", "Pass",
  "TC-21", "Analytics dashboard rendering", [Navigate to `/dashboard` after several claims resolved], "Charts render from existing Context data, no extra Firestore reads", "Rendered correctly; no extra reads observed in emulator log", "Pass",
  "TC-22", "CI typecheck-and-build gate", "Push a commit to the repository", [CI job runs `tsc --noEmit` and `vite build` successfully], "Job completed successfully on the current codebase", "Pass",
)
