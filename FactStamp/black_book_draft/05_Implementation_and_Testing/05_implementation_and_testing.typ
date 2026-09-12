#import "../lib/helpers.typ": *

= Implementation and testing

== Implementation approach

=== Project summary

FactStamp is a single-page web application (SPA) built with React 18.3.1 on Vite 5.4, written in strict TypeScript 5.5, styled with Tailwind CSS v4, and backed entirely by Firebase v12 (Authentication, Cloud Firestore, Storage) as a Backend-as-a-Service. The stack has no custom Node or Express server. Every module (authentication, claim ingestion, duplicate detection, the verification queue, the consensus engine, the PNG card generator, and the analytics dashboard) is client-side TypeScript that reads and writes Firestore directly, and declarative `firestore.rules` control what each write may do. This design was chosen (Chapter 2, Survey of Technologies) so the whole system could run inside Firebase's free Spark tier without any dedicated DevOps work.

Implementation went module by module. Each of the 8 core modules (Auth #sym.amp Reputation, Forward Submission/OCR, Duplicate Detection, Verification Queue, Weighted Consensus, Fact-Check Card Generator, Analytics Dashboard, and Security #sym.amp Notifications) was built, connected to its own React Context or `src/lib/*.ts` utility file, and exercised by hand against the Firebase Local Emulator Suite before the next module downstream was attached to it. Because of this order, the two algorithmically complex parts of the system, the Jaccard duplicate-detection engine and the weighted consensus formula, were written and checked by hand as pure functions with no Firebase dependency before they were connected to the stateful `ClaimsContext` that drives the live UI.

The architecture diagram below shows how the modules fit together. An incoming WhatsApp forward passes through duplicate detection, the quorum queue, and the consensus engine, and the result feeds the exportable fact-check card and the public analytics dashboard. Cloud Firestore and its security rules sit underneath all of them as the one shared backend.

=== Incremental, agile delivery

Development was iterative and incremental, following Agile rather than Waterfall, in line with the SDLC model comparison in Chapter 2 and the Scrum framework. The work fell into four broad sprint-like phases, matching the milestone schedule in the Project Synopsis:

+ *Foundation #sym.amp ingestion pipeline:* React/Vite/Firebase scaffolding, Firebase Auth, the claim submission form, client-side image compression, OCR text extraction, and the Jaccard duplicate-detection algorithm.
+ *Quorum #sym.amp consensus engine:* the public Verification Queue, the 3-verifier voting workbench, the weighted consensus formula, verifier reputation scoring, and the Firestore security rules that enforce all of it on the server.
+ *Card generator #sym.amp analytics:* the `html-to-image` export pipeline for 1080px-wide cards, the Recharts misinformation-trends dashboard, and real-time in-app notifications.
+ *Security hardening #sym.amp documentation:* the OWASP-style client hardening in `src/lib/security.ts` (rate limiting, file-upload validation, anti-spam explanation checks), cross-browser verification, and this dissertation.

Each phase ended with a working increment that could be demonstrated. A claim could already be submitted, deduplicated, and queued for verification before the confidence-score formula or the PNG card generator existed. Algorithmic tuning, such as adjusting the Jaccard stop-word length filter or the 40/30/30 confidence weighting, could then be done against a small but real, running codebase instead of a design document.

=== State management with React Context

All client-side state lives in React's built-in Context API (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, and `UsersContext`), and no external state library (Redux, Zustand, MobX) is in the dependency tree. Three things made that workable.

The state is shallow and loosely coupled. Its five concerns (identity, claims, notifications, theme, and the user directory) rarely need to read each other's internal state, unlike a large e-commerce or IDE-style application where dozens of features share one normalized store.

Each Context also owns the Firestore real-time listener (`onSnapshot`) for its own domain, so Firestore already acts as the single source of truth that Redux is meant to enforce. Adding Redux would mean keeping a client-side store in sync with a server-side real-time store, which duplicates bookkeeping for no benefit.

Context with plain `useState` and `useCallback` also avoids Redux's action types, reducers, and dispatch boilerplate. For a solo academic project, that means less code to maintain and less code for a grader to read when checking correctness.

The cost is that a Context re-renders every consumer on any state change, which does not scale to a large, deeply nested store. Here each Context has a small consumer tree of a handful of pages and components, so those re-renders are cheap.

=== Firebase as Backend-as-a-Service

Using Firebase (Auth, Firestore, and Storage) instead of a custom server shaped more of the codebase than any other implementation decision.

There is no server to run: no REST or GraphQL API layer, no server-side session management, and no infrastructure to patch, scale, or monitor. `src/services/firebaseService.ts` talks to Firestore directly from the browser, and `firestore.rules` holds the only backend logic, written declaratively.

Firestore also supplies real-time listeners. The Verification Queue, the notification bell, and the admin console's Incident Queue and Audit Log all use `onSnapshot()`, which would otherwise have needed a hand-written WebSocket server and client reconnection logic.

The Firebase Local Emulator Suite (Auth on port 9099, Firestore on 8080, Storage on 9199, and an inspection UI on 4000, started with `npm run emulators`) reproduces the whole backend on the local machine. That is what made the module-by-module, hand-checked approach practical: every module could be built and tested against a real local Firestore instance from the first day, without touching production data or needing a network connection.

With the backend taken care of, effort could go to the parts that are new in this project (the Jaccard duplicate engine, the weighted consensus formula, the OCR and WhatsApp-chrome cleanup pipeline, and the OKLCH-aware PNG card renderer) instead of auth flows, session tokens, and database drivers, which Firebase already provides.

== Coding details and code efficiency

*Coding approach by module.*

Each of the 8 core modules is a small cluster of focused files. Three conventions apply across all of them:

- Algorithmic logic is written as pure functions. Jaccard duplicate similarity (`src/lib/duplicateDetection.ts`) and weighted consensus scoring (`src/lib/confidenceScore.ts`), the two parts of the system whose correctness depends on the math, take plain data in and return plain data out, and neither file imports React or Firebase. Both can therefore be called from a Node REPL or a throwaway script for manual verification (see 5.3.1) without the UI or the database running.
- Strict TypeScript interfaces guard every boundary. `src/lib/types.ts` defines the canonical `Claim`, `Verification`, `User`, and `Verdict` shapes. Every function that handles Firestore data (for example `mapFirestoreDocToClaim` in `src/services/firebaseService.ts`) narrows the untyped document into one of these interfaces as soon as it is read, so a malformed or legacy-shaped document cannot slip `undefined` fields into the consensus computation.
- Context providers are the only stateful layer. Components get state only through `useAuth()`, `useClaims()`, `useNotifications()`, and the other Context hooks, and no component touches Firestore directly. All Firestore reads and writes stay in a handful of files (`src/services/firebaseService.ts` and the five Context files), which keeps them easy to audit.

*Duplicate Detection Engine (`src/lib/duplicateDetection.ts`)*

The engine normalizes text (lowercase, strip punctuation, collapse whitespace), splits it into a set of words longer than 3 characters, which works as a lightweight stop-word filter, and computes the Jaccard index between the incoming claim and every existing claim.

`findDuplicate()` then scans the existing claims one by one, keeps the highest-scoring match at or above the `0.75` threshold, and returns `null` if nothing reaches it. A duplicate submission is only ever redirected to the existing claim and is never merged into it automatically, so the calling code in `ClaimsContext` decides what happens next.

*Weighted Consensus Engine (`src/lib/confidenceScore.ts`)*

Once a claim has verifications, `calculateConfidenceScore()` combines three separately computed components, each on a scale of 0 to 100, into the final confidence percentage.

The function does not care where `verifierReputation` and `sourceQuality` come from. Before calling it, `ClaimsContext.tsx` looks up each verifier's live reputation and turns the cited source URL's domain into a `high` / `medium` / `low` tier with `determineSourceQuality()` (exported from `src/lib/confidenceScore.ts` alongside the scorer), then into a number with `sourceQualityToScore()`. Keeping that lookup out of the scoring math is what lets the math be tested by hand on its own (5.3.1).

*Other Modules*

- *Auth #sym.amp Reputation* (`AuthContext.tsx`) wraps Firebase Auth's email/password and Google OAuth flows and copies the signed-in user's Firestore `users/{uid}` profile (including `reputation`, which starts at 50) into React state through a live listener.
- *Ingestion #sym.amp OCR* (`Submit.tsx`, `ocrService.ts`, `imageCompression.ts`) runs client-side image compression, a Tesseract.js WebAssembly OCR pass, and a regex cleanup of WhatsApp chrome (`cleanExtractedOcrText()`) before the user sees the extracted text for confirmation.
- *Verification Queue* (`VerifyQueue.tsx`, `VerifyDetail.tsx`) lists pending claims and passes every submitted verdict through `validateVerdictExplanation()` in `src/lib/security.ts` (at least 50 characters and 8 words) before it reaches `ClaimsContext`.
- *Card Generator* (`FactCheckCard.tsx`) is a plain, deterministic React component laid out at a card width of 540px. On export, `html-to-image` rasterizes it in the browser at `pixelRatio: 2`, producing a 1080px-wide PNG with no server round-trip.
- *Analytics Dashboard* (`Dashboard.tsx`, `weeklyReport.ts`) builds all of its charts from data already held in `ClaimsContext` and `UsersContext`, and issues no Firestore queries of its own.

#heading(level: 3, outlined: true)[Code efficiency]

*Vite manual chunk splitting*

`vite.config.ts` splits the production bundle into six named vendor chunks instead of leaving chunking to Vite's defaults.

Tesseract.js and the Firebase SDK are both large, and they change far less often than the application's own code. Without explicit splitting, any change to the application code would invalidate one large bundle containing everything. With `vendor-ocr` and `vendor-firebase` in their own chunks, a returning user's browser keeps serving them from cache across most deployments. Combined with route-level lazy loading, a user who never opens `/submit`, and so never needs OCR, can also skip downloading the Tesseract WASM chunk on first load.

*Embedded verifications in the Firestore schema*

Verifications are stored as an embedded array on each `Claim` document instead of in a separate `verifications` subcollection keyed by claim ID. With this denormalization, the real-time claims listener (`subscribeClaimsRealtime` in `firebaseService.ts`) can build a complete `Claim`, with its text, status, verdict, and every verification, from a single document read. A subcollection would need one query for the claims and another for each claim's verifications, an N+1 pattern that would make Firestore read costs grow linearly with the number of claims shown in the Verification Queue list. The trade-off is that each claim document must stay under Firestore's 1 MiB limit. That is acceptable because a claim needs only a 3-verification quorum, not an open-ended comment thread, and the same limit is why screenshots are compressed before they are embedded.

*Client-side image compression before Firestore writes*

Screenshots attached to a claim are compressed in the browser (`src/lib/imageCompression.ts`, using the HTML5 Canvas API) to a bounded resolution, then base64-encoded and written directly onto the claim document. This keeps the claim text, verification array, and screenshot together under Firestore's 1 MiB document limit without a paid Cloud Storage bucket for images. It also means the OCR pass in `ocrService.ts` works on a smaller, already-normalized image, which is faster and uses memory more predictably inside the Tesseract.js WebAssembly worker than an uncompressed multi-megapixel photo would.

*Memoization and real-time listeners in Contexts*

Each Context opens exactly one Firestore real-time listener (`onSnapshot`) for its domain and derives everything else from that subscription instead of querying again for each consumer. Expensive derived values, such as the weekly trending-misinformation report in `weeklyReport.ts` and the dashboard's category and verdict aggregations, are wrapped in `useMemo` keyed on the `claims` array reference, so a re-render caused by something unrelated, such as toggling the theme, does not re-run the 7-day aggregation. Every `useEffect` that opens an `onSnapshot` subscription returns its unsubscribe function. Without that cleanup, each time a component using `useClaims()` mounted and unmounted (for example, when the user leaves the Verification Queue and comes back), another listener would be left running and Firestore read billing would climb.

== Testing approach

The FactStamp repository has no automated test runner. `package.json` defines only `dev`, `build`, `preview`, `typecheck`, `emulators` (with its `:persist` and `:export` variants), `seed:db`, `create:admin`, and `create:user`. There is no `test` script, and no `*.test.ts` or `*.spec.ts` file exists anywhere under `src/`. Quality assurance was therefore done by hand, with no Jest or Vitest suite running in CI. The one automated check is the `typecheck-and-build` job in `.github/workflows/ci.yml`, which runs `npm ci`, `npm run typecheck` (`tsc --noEmit`), and `npm run build` (`tsc -b && vite build`) on every push. It catches type errors and broken builds, but not logic or behavior regressions. Within that limit, manual testing was organized in three layers: unit checks of the two pure algorithmic modules, integration tests across the Firebase service boundary using the Local Emulator Suite, and end-to-end system and beta walkthroughs of real user journeys.

#heading(level: 3, outlined: true)[Unit testing]

Since `duplicateDetection.ts` and `confidenceScore.ts` are pure TypeScript functions with no dependencies, they were checked by calling them directly with hand-built inputs and comparing each result with a value worked out by hand. This is the same check an automated `it(...)` block would make, run manually because there is no test runner.

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

Case 3 tests the threshold's precision/recall trade-off. The two claims share a topic (garlic curing coronavirus) but differ enough in wording that treating them as one claim could fold two separate viral variants into a single verdict. Re-running `findDuplicate()` by hand confirmed that it redirects Cases 1 and 2 and creates a new claim for Case 3, as the `J >= 0.75` threshold in Chapter 4's algorithm design specifies.

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

Worked by hand, Case 1 comes out at 88, which is exactly what `Math.round()` returns. Case 3 exercises the function's explicit early return (`if (verifications.length === 0) return { score: 0, ... }`), which prevents a division by zero. The guard was added because a claim can in theory be read mid-write with no verifications attached yet, and in that moment the UI has to show `0%`, not `NaN`.

#heading(level: 3, outlined: true)[Integration testing]

Integration tests cover the boundary between the modules and Firebase itself, which unit checks of `duplicateDetection.ts` and `confidenceScore.ts` cannot reach. All of them ran against the Firebase Local Emulator Suite (`npm run emulators`, or `npm run emulators:persist` to keep state between runs), with Auth on port `9099`, Firestore on `8080`, Storage on `9199`, and the inspection UI on `4000`. This let Auth, Firestore, and Storage rules be tested together without touching the production project or using up quota.

The main scenarios run by hand against the emulator were:

+ *End-to-end quorum consensus.* After seeding the emulator (`npm run seed:db`), three different seeded verifier accounts signed in one after another and each submitted a verdict through `VerifyDetail.tsx` on the same pending claim. The test confirmed that (a) each verification was appended to the claim's embedded `verifications` array, and `firestore.rules` rejected any write that tried to increment `verificationCount` by anything other than exactly 1; (b) when the third verification arrived, `ClaimsContext` recomputed the verdict, called `calculateConfidenceScore()`, and moved the claim's `status` from `pending` to `verified` in the same Firestore write; and (c) the confidence score shown in `ClaimDetail.tsx` matched the value worked out by hand for the same three verdicts with the formula from 5.3.1.
+ *Firestore rules rejecting a forged write.* Using the Firestore emulator's REST endpoint to bypass the app's UI, a verification was written with a `verifierReputation` higher than the signed-in user's live profile value. `firestore.rules` rejected the write. The client-side consensus math in `ClaimsContext.tsx` cannot be trusted on its own; this server-side rule is where enforcement actually happens.
+ *Storage and Auth for screenshot claims.* Submitting a claim with an attached screenshot while signed out was rejected by both `firestore.rules` (`match /claims/{claimId}` #sym.arrow.r `allow create: if request.auth != null`) and `storage.rules` (`match /claim_screenshots/{fileName}` #sym.arrow.r `allow write: if request.auth != null`). Claim submission is therefore an authenticated-only path, consistent with `/submit` being wrapped in `ProtectedRoute` in `src/App.tsx`. The same submission succeeded once signed in, with the file-type and size checks from `src/lib/security.ts` still enforced on the client.
+ *Self-verification lock.* The user who submitted a claim tried to verify that same claim. The anti-Sybil self-verification check in the verification workbench blocked the submission on the client before anything reached Firestore.
+ *Admin dual-layer authorization.* On a non-admin seeded account signed in through the emulator, the documented DevTools bypass `sessionStorage.setItem('fs_admin_session_unlocked', 'true')` was tried. On the next render, `AdminRoute.tsx` re-derived `hasVerifiedAdminRole` from the live Firestore-backed `user.isAdmin` snapshot, discarded the stale session flag, and sent the user back to the login gate.

#heading(level: 3, outlined: true)[System testing]

System and beta testing meant walking through complete, realistic user journeys by hand on a running copy of the application, both locally with `npm run dev` against the emulators and separately on a deployed build. The walkthroughs are scripted and repeatable but executed manually: the repository has no Playwright or Cypress configuration, just as `package.json` has no `test` script.

*Public submitter journey:*

+ Sign up through `SignUp.tsx` with email and password, and confirm that a new `users/{uid}` Firestore profile is created with a base reputation of 50.
+ Submit a claim through `Submit.tsx` as a screenshot upload, and confirm that client-side compression runs, Tesseract.js OCR puts readable text into the form, and `cleanExtractedOcrText()` removes WhatsApp timestamps and checkmarks from the extracted string.
+ Confirm that the duplicate check runs against the existing claims before the new claim is queued. Submitting a known near-duplicate redirects to the existing claim's page and creates nothing new.
+ Confirm that the new claim appears in `VerifyQueue.tsx` for other users, and that the submitter gets a real-time in-app notification once three verifications resolve it.
+ Open `ClaimDetail.tsx` after resolution, check that the verdict badge, confidence percentage, and source list render properly, and export the fact-check PNG via `html-to-image` (1080px wide, from a 540px card at `pixelRatio: 2`, with height growing to fit the claim text and source list). Confirm that the OKLCH theme colors rasterize correctly, which is exactly where the legacy canvas parser failed (see Section 5.4).

*Community verifier journey:*

+ Sign in as a seeded verifier, open the Verification Queue, and select a pending claim.
+ Try to submit a verdict with a short, low-effort explanation ("fake"), and confirm that `validateVerdictExplanation()` rejects it for falling below the 50-character / 8-word minimum, with an error message that says what to fix.
+ Submit a verdict with a real citation URL, and confirm that `determineSourceQuality()` derives the right source-quality tier from the domain and that the tier shows up in the eventual confidence score.
+ Confirm that the verifier's own reputation changes once the claim reaches consensus, according to whether their verdict matched the majority.

*Admin console walkthrough:*

+ Go directly to the unlisted `/admin` route and sign in through the `AdminRoute.tsx` login gate.
+ Work through all five tabs: System Overview (KPI cards and Recharts charts), Verifier Directory (search and filter, edit reputation, toggle `isAdmin`), Claims Moderation (override a verdict, flag a claim for expedited review), Incident Queue (create and resolve a `ModerationReport`), and Audit #sym.amp Tools. In the last tab, confirm that every mutating action from the earlier steps produced an `AdminAuditLog` entry, then run "force-run consensus expiry" and the JSON database export.
+ Confirm that "Lock Console" clears the session flag and returns to the login gate on the next render.

All of these walkthroughs were re-run by hand after each change described in 5.4, to check that the change had not broken an adjacent journey. Without an automated suite in CI, this is the project's regression check.

== Modifications and improvements

Several features were revised after their first delivery, either to fix a defect found during manual testing (5.3) or to replace a weaker first version. The changes below come from the project's changelog and its architectural notes.

*1. Verification queue auto-replenishment (bug fix)*

During manual testing, the Verification Queue at `/verify` sometimes showed no pending claims at all. The cause was in `applyLocalExpiry()` in `ClaimsContext.tsx`. The 7-day consensus-expiry logic, which settles claims that miss the 3-verifier quorum by their `consensusDeadline` as `CONTESTED`, was working as intended, but nothing refilled the queue with new pending claims. A batch of seeded demo claims could therefore all expire together and leave the queue empty.

`scripts/seed-db.mjs` now gives each generated claim a deadline 3 to 6 days after the script runs. `applyLocalExpiry()` was changed so that whenever expiry leaves no `pending` claims, it adds fresh seed claims, each with a new future `consensusDeadline`, to the in-memory claims list, so the Verification Queue never goes empty. The cleanup in `subscribeClaimsRealtime()` was also fixed to tear down both the primary ordered-query listener and its unindexed fallback query, closing a duplicate-listener leak that could produce the same symptom. To re-verify the fix, seeded claims were left to run past their deadlines in the emulator, and the queue kept showing at least one claim to act on.

*2. Authentication hardening and rate limiting*

The original sign-in flow did nothing about repeated failed logins. `src/lib/security.ts` gained a rate limiter that tracks failed attempts both per account and globally per browser client, using `localStorage` with a `sessionStorage` fallback so that reloading the tab or closing the browser does not reset the count. Five failed attempts trigger a 15-minute lockout (`LOCKOUT_DURATION_MS = 15 * 60 * 1000`). `formatLockoutRemaining()` drives a live countdown in the sign-in UI, and `resetLoginAttempts()` clears the count as soon as a login succeeds. `SignIn.tsx` now checks the rate-limit state before sending anything to Firebase Auth, shows an "X/5 attempts left" indicator, and uses the same generic "Invalid email or password" message for every credential error, so an attacker cannot tell which emails are registered. The login gate in `AdminRoute.tsx` uses the same rate-limiting functions.

*3. Sliding dual-icon theme toggle across the app*

Pages used to have their own inconsistent, icon-only theme buttons. These were replaced with one reusable `<ThemeToggle />` component: a small pill with a thumb that slides between Lucide's `Sun` and `Moon` icons, fully usable from the keyboard. `ThemeContext.tsx` now exposes an explicit `setTheme` alongside the existing `toggleTheme`. The toggle now appears in the same form on every surface that lacked one or had a custom variant: the desktop Navbar and mobile navigation drawer, the Admin Command Center's header and Tools tab, the admin authentication gate, the Sign In / Sign Up panels, and the global footer.

*4. Pan-Indic typography migration (font-stack rework)*

The original setup loaded three Google Font families (`DM Sans`, `JetBrains Mono`, `Lora`), over 120 KB across twelve font files, and had no Devanagari support, so Hindi or Marathi text in a WhatsApp forward rendered with broken baselines. `DM Sans` was replaced with a single variable Latin font, Plus Jakarta Sans, and Noto Sans Devanagari was added for Hindi and Marathi. `JetBrains Mono` was dropped. Reputation ratios, case IDs, and countdown timers now use the CSS `font-variant-numeric: tabular-nums` property, which gives the same fixed-width alignment with no extra download. `Lora` was removed from quoted forward text, which now uses plain message typography.

*5. `html-to-image` replacing a legacy canvas parser*

The first card exporter used a hand-written canvas-based CSS parser to rasterize `FactCheckCard.tsx` into a PNG. That parser understood only `rgb()` and hex colors, so once the design system moved to Tailwind v4's OKLCH/OKLAB colors it could not read the card's computed styles, and exports came out broken or completely black. The exporter was rewritten around `html-to-image`, which rasterizes DOM nodes through the browser's own SVG `<foreignObject>` rendering instead of a custom CSS interpreter. It resolves `oklch()` and `oklab()` exactly as the page does, which removes this whole class of color-parsing bug. Cards now export at 1080px wide from the 540px card at a 2#sym.times device pixel ratio, with height following the card's content and no layout distortion.

*Summary comparison*

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
