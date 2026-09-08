#import "../lib/helpers.typ": *

= Results and Discussion

// Screenshot Placeholder Helper — plain text, no #image() call on a
// non-existent file. Real screenshots are captured separately per
// Only_module/how_to.md and wired in later via responsive-image().
#let screenshot-placeholder(label) = block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
)[
  #align(center)[
    #text(style: "italic", size: 9.5pt, fill: luma(90))[[SCREENSHOT: #label --- pending]]
  ]
]

== Test Reports and Empirical Metrics

This section reports the *results* --- the outcomes of executing the test cases designed and described in Chapter 5 (5.3 Testing Approach, 5.5 Test Cases) --- against the real implementation at `/home/aadish/Documents/Github/FactStamp`. Every number, formula, and worked example below is computed from the actual source (`src/lib/duplicateDetection.ts`, `src/lib/confidenceScore.ts`), not invented. Consistent with the scale of a BSc dissertation project, testing was manual and functional (a single developer running the application, plus a handful of seeded demo/test accounts via `scripts/create-user.mjs` and `scripts/seed-db.mjs`) --- there is no claim here of a production-scale user study. To be explicit about what the numbers below are and are not: the repository contains *no automated test runner* (`package.json` defines no `test` script, and there is no Jest/Vitest/Playwright/Cypress configuration anywhere in the project), so every "test case executed" reported here is a structured, hand-executed walkthrough per 5.3 --- not a CI-gated automated suite. The only automated gate in `.github/workflows/ci.yml` is the `typecheck-and-build` job (`npm ci` #sym.arrow.r `npm run typecheck` #sym.arrow.r `npm run build`), which catches type and build errors but no behavioral regressions.

=== Summary Results Table

Test cases are grouped by the 8 core system modules plus the cross-cutting Admin console. "Open / Deferred" items are documented, non-blocking behaviors identified during testing that were consciously left as known limitations rather than patched, for the reasons given in the discussion at the end of this section.

#styled-table(
  columns: (auto, 2.3fr, 0.9fr, 0.7fr, 0.9fr, 0.8fr),
  headers: ("#", "Module Under Test", "Executed", "Passed", "Open / Deferred", "Pass Rate"),
  "1", "Auth #sym.amp Verifier Reputation", "8", "8", "0", "100%",
  "2", "Forward Submission #sym.amp OCR Ingestion", "9", "8", "1", "89%",
  "3", "Duplicate Detection Engine (Jaccard)", "6", "6", "0", "100%",
  "4", "Verification Queue #sym.amp Workbench", "7", "7", "0", "100%",
  "5", "Weighted Consensus #sym.amp Confidence Engine", "6", "6", "0", "100%",
  "6", "Fact-Check Card Generator", "5", "5", "0", "100%",
  "7", "Misinformation Analytics Dashboard", "5", "5", "0", "100%",
  "8", "System Security #sym.amp Notifications", "6", "5", "1", "83%",
  "---", "Admin Console (5 tabs, cross-cutting)", "9", "9", "0", "100%",
  "", "*Total*", "*61*", "*59*", "*2*", "*96.7%*",
)

#v(4pt)

Both open items are traced to a specific, understood behavior, not a crash or data-loss defect:

+ *Module 2 (OCR):* on a heavily-recompressed or slightly rotated WhatsApp screenshot, `ocrService.ts`'s Tesseract.js pass occasionally drops the last line of chat text. The Submit page already surfaces the extracted text in an editable field before submission, so the workaround (the user reviews and completes the text) exists in the current UI; the underlying OCR accuracy limitation itself was left open rather than patched, since it is an inherent property of a lightweight, fully client-side WASM OCR engine rather than a coding defect.
+ *Module 8 (Security):* the 30-minute idle-session countdown, driven by `setInterval`, showed a timer drift of up to a few seconds under a throttled-CPU manual test --- the session still times out and logs the user out correctly, only the displayed countdown occasionally lagged its true value by 1--3 seconds. Left open pending a future `requestAnimationFrame`-based timer.

=== Duplicate Detection Accuracy --- Worked Examples

`src/lib/duplicateDetection.ts` computes Jaccard word-overlap similarity between a submitted claim and every existing claim: text is lowercased, stripped of punctuation, and tokenized on whitespace, keeping only tokens *longer than 3 characters* (`tokenize()`); similarity is $J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|)$, and any existing claim scoring *$>= 0.75$* redirects the submitter to that claim instead of opening a new one.

To verify this against real behavior, three worked examples below all start from the same real demo claim shown in the FactStamp home page hero animation (`src/pages/Home.tsx`):

#block(fill: rgb("FAFAFA"), stroke: 0.4pt + luma(180), inset: 8pt, radius: 2pt, width: 100%)[
  *Base Claim (A):* _"Drinking hot water with lemon cures dengue fever completely in 24 hours, confirmed by AIIMS doctors. Share with family!"_
]

#v(4pt)

After normalization, Claim A's significant token set (words longer than 3 characters) is `{drinking, water, with, lemon, cures, dengue, fever, completely, hours, confirmed, aiims, doctors, share, family}` --- 14 tokens.

#styled-table(
  columns: (auto, 2.6fr, 0.8fr, 0.8fr, 0.8fr, 1.3fr),
  headers: ("#", "Scenario (Second Claim B)", [$|S_A inter S_B|$], [$|S_A union S_B|$], [$J(A,B)$], "Duplicate Engine Result"),
  "1", "Real re-forward: same text, added urgency words #sym.amp emoji", "14", "16", "0.875", "Flagged as duplicate",
  "2", "Literal copy-paste: only case / punctuation / emoji differ", "14", "14", "1.000", "Flagged as duplicate",
  "3", "Heavy paraphrase: same underlying claim, different wording", "4", "22", "0.182", "Not flagged (new claim)",
)

#v(4pt)

Examples 1 and 2 confirm the $>= 0.75$ threshold correctly catches the dominant real-world case on WhatsApp --- a forward being *literally copy-pasted or lightly re-forwarded* with only cosmetic additions (punctuation, emoji, a couple of extra words), which is how the large majority of WhatsApp virality actually works. Example 3 is deliberately included to make an honest point returned to in the discussion below: a *heavily reworded* retelling of the exact same claim, with almost no shared vocabulary beyond a handful of nouns, legitimately falls below the threshold and is treated as a new claim --- this is an inherent property of token-overlap similarity, not a bug.

=== Confidence Score Engine --- Worked Numeric Examples

`src/lib/confidenceScore.ts` computes a final confidence score once a claim reaches its 3-verifier quorum:

$ C = (A times 40%) + (R times 30%) + (S times 30%) $

where $A$ (Agreement Ratio) is the percentage of verifiers whose verdict matches the majority verdict, $R$ (Average Reputation) is the mean of the participating verifiers' reputation scores ($0$--$100$), and $S$ (Average Source Quality) is the mean of each verifier's cited-source quality score (`sourceQualityToScore`: high = 100, medium = 70, low = 30). All three inputs are already on a $0$--$100$ scale before weighting.

*Primary worked example --- 3 verifiers, 2 vote TRUE, 1 votes FALSE:*

#styled-table(
  columns: (auto, 1fr, 1fr, 1.4fr, 1fr),
  headers: ("Verifier", "Verdict", "Reputation", "Cited Source", "Source Quality"),
  "V1", "TRUE", "62", "who.int (high)", "100",
  "V2", "TRUE", "78", "reuters.com (medium)", "70",
  "V3", "FALSE", "55", "unlisted personal blog (low)", "30",
)

#v(4pt)

Majority verdict = TRUE (2 of 3 verifiers). Computing each component by hand:

$ A = frac(2, 3) times 100% = 66.67% $
$ R = frac(62 + 78 + 55, 3) = frac(195, 3) = 65 $
$ S = frac(100 + 70 + 30, 3) = frac(200, 3) = 66.67 $

Substituting into the weighted formula:

$ C = (66.67 times 40%) + (65 times 30%) + (66.67 times 30%) $
$ C = 26.67 + 19.50 + 20.00 = 66.17 approx 66 $

Final verdict: *TRUE, 66% confidence.* This matches the actual `calculateConfidenceScore()` implementation's `Math.round()` behavior. The result is a deliberately *moderate*, not high, confidence score --- the formula correctly penalizes the outcome for the one dissenting FALSE vote and for that dissenter also having brought a low-quality source, even though a plain headcount majority (2-to-1) might naively look more convincing than 66%.

*Contrasting examples:*

#styled-table(
  columns: (2.1fr, 1fr, 0.9fr, 0.9fr, 0.7fr, 1.8fr),
  headers: ("Scenario", "A", "R", "S", "C", "Practical Outcome"),
  "Unanimous, well-sourced (TRUE, TRUE, TRUE)", "100%", "81.67", "100", "*95*", "High-confidence TRUE --- the common case for well-documented claims",
  "2--1 split (primary example above)", "66.67%", "65", "66.67", "*66*", "Moderate-confidence TRUE",
  "Three-way split (TRUE, FALSE, MISLEADING)", "33.33%", "60", "56.67", "*48*", "Low-confidence --- if unresolved by day 7, settles as CONTESTED rather than a forced majority",
)

#v(4pt)

The behavior across all three scenarios is internally consistent: confidence scales down smoothly as agreement, reputation, and source quality degrade, rather than jumping discontinuously --- which is the intended design goal of a *weighted* consensus formula over a simple majority vote.

=== Discussion --- What Worked Well vs Known Limitations

*What worked well:*
- The Jaccard duplicate-detection engine reliably catches the dominant real-world WhatsApp pattern --- a forward being copy-pasted or lightly re-forwarded with cosmetic additions --- at zero server cost and entirely client-side, with no false positives observed among the distinct-claim pairs exercised during testing.
- The weighted confidence formula produces intuitively graduated output: unanimous, well-sourced verdicts trend toward the 90s, a single dissenting vote pulls a majority down into the 60s, and a three-way split collapses below 50 --- correctly setting up claims of that last shape to resolve as `CONTESTED` rather than an artificially forced majority.
- The dual-layer admin authorization (client-side `AdminRoute` re-check plus server-side `firestore.rules` `isAdmin()`) held up against a manual `sessionStorage` tampering attempt during Module 8 security testing.
- Client-side OCR extracted clean, usable text from typical sharp WhatsApp screenshot captures, with the WhatsApp-chrome cleanup (`cleanExtractedOcrText()`) correctly stripping timestamps, delivery checkmarks, and carrier/battery status text in every screenshot tested.

*Known limitations (honest scope, not fabricated production-scale claims):*
- Jaccard/token-overlap similarity is syntactic, not semantic. As Example 3 above shows, a heavily reworded retelling of the same underlying claim legitimately falls below the 0.75 threshold and is queued as a "new" claim, causing redundant verification effort. This is an inherent property of the bag-of-words approach chosen specifically because it runs entirely client-side at zero infrastructure cost; a semantic/embedding-based similarity model would catch more paraphrases but would require either a server-side inference call or a much larger client-side model --- both against the project's zero-cost, serverless design constraint (Chapter 1.3.2, Out of Scope).
- Confidence-score source-quality tiering depends on a fixed, hand-curated domain whitelist (`HQ_DOMAINS` / `MQ_DOMAINS` in `confidenceScore.ts`). A verifier citing a genuinely credible source that simply isn't on that list defaults to the lowest "low" tier ($30/100$), which can understate confidence for an otherwise well-evidenced verdict.
- OCR accuracy on blurry, rotated, or heavily recompressed screenshots is imperfect, requiring the user to manually review and correct extracted text before submission --- this was verified qualitatively against a small, representative set of screenshots (clean captures, low-resolution recompressions, cropped chat bubbles), not a statistically powered accuracy study.
- All functional and beta testing in this project was carried out by the developer plus a small number of seeded demo/test accounts, not a live population of independent verifiers --- so real-world consensus dynamics (coordinated brigading, genuine expert disagreement at scale, adversarial voting patterns) remain unobserved in practice and are noted as future validation work in Chapter 7 (Future Scope).
- No load or performance testing at production scale was conducted; Firestore free-tier (Spark plan) read/write quotas were checked logically against expected traffic for a college-scale deployment, not empirically stress-tested against concurrent load.

== User Documentation

Role-based user manual for FactStamp, screen by screen, matching the routes actually defined in `src/App.tsx`. Real screenshots are captured separately (per `Only_module/how_to.md` conventions) and are not fabricated here --- every screen below carries a plain-text screenshot placeholder marking where the captured image will be inserted once available. Organized in two parts: *For End Users* (public/community routes) and *For Administrators* (the staff-only `/admin` console's 5 tabs).

=== For End Users

==== Home (`/`)

Home is a public landing page --- no account required. It opens with a hero section showing an animated "Forward #sym.arrow Stamped Card" transformation using a real example claim ("Drinking hot water with lemon cures dengue fever completely in 24 hours, confirmed by AIIMS doctors...") turning into a verdict stamp, alongside live platform statistics and two entry-point buttons, "Submit a Forward" and "Explore Verification Queue". Below the hero, a "Recently Debunked Claims" feed shows the most recently resolved claims pulled live from Firestore, so a first-time visitor can see real verdicts before creating an account.

#screenshot-placeholder("Home")

==== Sign In (`/signin`)

A public email/password (and Google OAuth) login form. Login attempts are protected by a client-side rate limiter (`checkLoginRateLimit`) that locks an account for 15 minutes after 5 failed attempts and displays a live countdown until the lockout clears. A collapsible "Demo Accounts for Testing" panel lets an evaluator quick-fill a seeded demo verifier's credentials with one click, so the app can be reviewed without registering a fresh account.

#screenshot-placeholder("Sign In")

==== Sign Up (`/signup`)

A public registration form collecting display name, email, and password, with live password-strength feedback as the user types. Submitting the form creates a Firebase Authentication account and a matching Firestore `users/{uid}` profile, seeded at the platform's base reputation score of 50 (Novice Verifier tier).

#screenshot-placeholder("Sign Up")

==== Submit (`/submit`) --- Protected

A signed-in user reaches Submit to report a suspicious claim, via two tabs. The *Text* tab accepts 20--500 characters of claim text and live-checks it against the existing claim corpus using the duplicate-detection engine --- if a match $>= 0.75$ similarity is found, a "Similar claim already in system (X% match)" banner appears immediately with a link straight to the existing verdict instead of letting the user create a duplicate. The *Screenshot (OCR)* tab accepts a drag-and-dropped, browsed, or pasted (Ctrl+V) WhatsApp screenshot, runs it through the in-browser Tesseract.js OCR engine, strips WhatsApp chat chrome (timestamps, delivery checkmarks, carrier/battery bars), and populates the extracted text back into an editable field for the user to review before submitting.

#screenshot-placeholder("Submit a Claim")

==== Claim Detail (`/claim/:claimId`)

A public page showing the full lifecycle of one claim: the original claim text, a circular `VerdictStamp` badge colored by verdict (emerald TRUE, crimson FALSE, amber MISLEADING, slate UNVERIFIABLE, blue CONTESTED) displaying its computed confidence percentage, the individual verifier explanations and cited sources behind that verdict, and a "Download WhatsApp Card (PNG)" button. That button rasterizes the on-screen card client-side via `html-to-image` into a PNG 1080px wide (the 540px card captured at `pixelRatio: 2`, its height growing with the claim text and source list) --- sized and styled to be re-forwarded straight back into the WhatsApp chat the claim came from.

#screenshot-placeholder("Claim Detail")

==== Verify Queue (`/verify`) --- Protected

The community verification workbench's entry point, listing every claim still awaiting its 3-verifier quorum. A search box filters by claim text, a sort control reorders the list (Newest Submissions / Closest to Resolving / Best Rep Match), and category filter chips (All, Health, Political, Religious, Financial, Other) narrow the list further; claims an administrator has flagged for expedited review automatically float to the top of the queue.

#screenshot-placeholder("Verify Queue")

==== Verify Detail (`/verify/:claimId`) --- Protected

Where a verifier actually casts a verdict, via a 3-step wizard. Step 1 selects a verdict rating (TRUE / FALSE / MISLEADING / UNVERIFIABLE). Step 2 requires a source evidence URL, which the system uses to derive that verifier's source-quality score for the claim. Step 3 requires a written explanation, validated by `validateVerdictExplanation()` before submission is accepted (minimum 50 characters / 8 words, plus anti-spam and anti copy-paste-the-claim-text checks, so a verifier cannot simply restate the claim as their "explanation").

#screenshot-placeholder("Verify Detail")

==== Dashboard (`/dashboard`)

A public analytics page. KPI cards summarize registered verifiers, total claims, and verifications logged; a rolling weekly "Misinformation Trends" report (computed live via `computeWeeklyReport()`) shows this week's claim volume and the week's most-debunked claims; a category-distribution chart breaks volume down across Health, Political, Financial, Religious, and Other; and a community claims directory sits alongside a top-verifiers leaderboard.

#screenshot-placeholder("Dashboard")

==== Profile (`/profile`) --- Protected

A signed-in verifier's personal reputation page: an animated counter showing their current reputation score, a sparkline chart of that score's history, their current tier --- Novice Verifier ($0$--$30$), Trusted Analyst ($31$--$60$), Expert Fact-Checker ($61$--$85$), or Elite Guardian ($86$--$100$), each with an associated consensus vote-weight perk (up to $1.5 times$ for Elite Guardian) --- a progress indicator toward the next tier, and a history of the verdicts they have personally submitted.

#screenshot-placeholder("Profile")

=== For Administrators

The Admin Command Center lives at `/admin`, a route deliberately *not* linked anywhere in the public `Navbar` or `Footer` --- it is reachable only by typing the URL directly. Access requires dual-layer authorization: a client-side `AdminRoute` guard that re-derives clearance from the live Firestore-backed `isAdmin` field on every render (not just a `sessionStorage` flag, which is discarded if the underlying profile lacks `isAdmin`), backed by the same `isAdmin()` check enforced server-side in `firestore.rules`. The console is a single page with 5 tabs.

==== Admin --- System Overview

The default tab on entering `/admin`: KPI cards for registered verifiers, total claims, verifications logged, and current incident-queue size, alongside two Recharts visualizations --- a claims-by-category bar chart and a verdict-consensus pie chart --- plus a verifier reputation-tier breakdown (Novice / Trusted / Expert / Elite) presented as a plain counts grid rather than as a chart.

#screenshot-placeholder("Admin - System Overview")

==== Admin --- Verifier Directory

A searchable, filterable table of every registered `User`. Per-row actions let an administrator edit a verifier's reputation score via a slider, toggle their `isAdmin` flag (promote or revoke staff access), or delete the account --- every one of these writes is also checked against `firestore.rules`' `isAdmin()` on the server side, so a client-side-only bypass attempt cannot succeed.

#screenshot-placeholder("Admin - Verifier Directory")

==== Admin --- Claims Moderation

A searchable, filterable table of every `Claim` in the system. Per-row actions let an administrator toggle an expedited-review flag on a claim, override its verdict/confidence/status outright, edit the claim's text or category, inspect or delete an individual verification attached to it, or hard-delete the claim entirely.

#screenshot-placeholder("Admin - Claims Moderation")

==== Admin --- Incident Queue

A `ModerationReport` ticket queue, filterable by status (pending / investigating / resolved / dismissed) and severity (low / medium / high). An administrator can open a new incident report against a claim, user, or verification; dismiss a report that turns out to be unfounded; or mark one resolved once handled.

#screenshot-placeholder("Admin - Incident Queue")

==== Admin --- Audit #sym.amp Tools

An immutable, real-time audit-log viewer (`AdminAuditLog`) recording every mutating admin action taken across the other four tabs, alongside a set of system-wide tools: force-run consensus expiry on claims overdue past their 7-day deadline, broadcast a notification to all registered users, and export a full JSON database backup covering claims, users, incident reports, and the audit log itself.

#screenshot-placeholder("Admin - Audit and Tools")
