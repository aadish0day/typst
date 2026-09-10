#import "../lib/helpers.typ": *

= Results and Discussion

// Screenshot Placeholder Helper: plain text, no #image() call on a
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
    #text(style: "italic", size: 9.5pt, fill: luma(90))[[SCREENSHOT: #label (pending)]]
  ]
]

== Test Reports and Empirical Metrics

This section reports the results of running the test cases designed and described in Chapter 5 (5.3 Testing Approach, 5.5 Test Cases) against the real implementation at `/home/aadish/Documents/Github/FactStamp`. The numbers, formulas, and worked examples come directly from the source (`src/lib/duplicateDetection.ts`, `src/lib/confidenceScore.ts`). At the scale of a BSc IT project, testing was manual and functional. It involved a single developer running the application with a few seeded demo accounts created via `scripts/create-user.mjs` and `scripts/seed-db.mjs`. The repository has no automated test runner (`package.json` defines no `test` script, and there is no Jest/Vitest/Playwright/Cypress configuration). Every test case executed was a structured manual walkthrough based on Section 5.3. The only automated check in `.github/workflows/ci.yml` is the `typecheck-and-build` job (`npm ci` #sym.arrow.r `npm run typecheck` #sym.arrow.r `npm run build`), which catches type and build errors but does not catch behavioral problems.

=== Summary Results Table

Test cases are grouped by the 8 core system modules and the Admin console. The "Open / Deferred" items are documented, non-blocking behaviors identified during testing. They were left as known limitations rather than patched, for reasons discussed at the end of this section.

#styled-table(
  columns: (auto, 2.3fr, 0.9fr, 0.7fr, 0.9fr, 0.8fr),
  headers: ("#", "Module Under Test", "Executed", "Passed", "Open / Deferred", "Pass Rate"),
  "1", [Auth #sym.amp Verifier Reputation], "8", "8", "0", "100%",
  "2", [Forward Submission #sym.amp OCR Ingestion], "9", "8", "1", "89%",
  "3", "Duplicate Detection Engine (Jaccard)", "6", "6", "0", "100%",
  "4", [Verification Queue #sym.amp Workbench], "7", "7", "0", "100%",
  "5", [Weighted Consensus #sym.amp Confidence Engine], "6", "6", "0", "100%",
  "6", "Fact-Check Card Generator", "5", "5", "0", "100%",
  "7", "Misinformation Analytics Dashboard", "5", "5", "0", "100%",
  "8", [System Security #sym.amp Notifications], "6", "5", "1", "83%",
  [N/A], "Admin Console (5 tabs)", "9", "9", "0", "100%",
  "", [*Total*], [*61*], [*59*], [*2*], [*96.7%*],
)

#v(4pt)

Both open items trace to specific, understood behaviors rather than crashes or data-loss defects:

+ *Module 2 (OCR):* On heavily recompressed or slightly rotated WhatsApp screenshots, the Tesseract.js pass in `ocrService.ts` occasionally drops the last line of text. The Submit page already shows the extracted text in an editable field before submission. The user can review and complete the text using the current UI. The OCR accuracy limitation itself was left open because it relates to the lightweight client-side WASM OCR engine rather than a coding error.
+ *Module 8 (Security):* The 30-minute idle session countdown, driven by `setInterval`, showed a timer drift of a few seconds during a throttled-CPU test. The session still times out and logs the user out correctly, but the displayed countdown occasionally lags its true value by 1 to 3 seconds. This is left open until a `requestAnimationFrame`-based timer is implemented.

=== Duplicate Detection Accuracy: Worked Examples

`src/lib/duplicateDetection.ts` computes Jaccard word-overlap similarity between a submitted claim and existing claims. Text is lowercased, stripped of punctuation, and tokenized on whitespace, keeping only tokens longer than 3 characters (`tokenize()`). Similarity is $J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|)$. Any existing claim scoring $>= 0.75$ redirects the submitter to that claim instead of opening a new one.

To verify this against real behavior, the three worked examples below start from the real demo claim shown in the FactStamp home page animation (`src/pages/Home.tsx`):

#block(fill: rgb("FAFAFA"), stroke: 0.4pt + luma(180), inset: 8pt, radius: 2pt, width: 100%)[
  *Base Claim (A):* _"Drinking hot water with lemon cures dengue fever completely in 24 hours, confirmed by AIIMS doctors. Share with family!"_
]

#v(4pt)

After normalization, Claim A's significant token set (words longer than 3 characters) is `{drinking, water, with, lemon, cures, dengue, fever, completely, hours, confirmed, aiims, doctors, share, family}`, totaling 14 tokens.

#styled-table(
  columns: (auto, 2.6fr, 0.8fr, 0.8fr, 0.8fr, 1.3fr),
  headers: ("#", "Scenario (Second Claim B)", [$|S_A inter S_B|$], [$|S_A union S_B|$], [$J(A,B)$], "Duplicate Engine Result"),
  "1", [Real re-forward: same text, added urgency words #sym.amp emoji], "14", "16", "0.875", "Flagged as duplicate",
  "2", "Literal copy-paste: only case / punctuation / emoji differ", "14", "14", "1.000", "Flagged as duplicate",
  "3", "Heavy paraphrase: same underlying claim, different wording", "4", "22", "0.182", "Not flagged (new claim)",
)

#v(4pt)

Examples 1 and 2 confirm the $>= 0.75$ threshold catches the most common case on WhatsApp: a message copy-pasted or lightly re-forwarded with cosmetic additions like punctuation, emoji, or a few extra words. This is how most messages spread. Example 3 illustrates a point discussed later: a heavily reworded retelling of the same claim with almost no shared vocabulary beyond some nouns falls below the threshold and is treated as a new claim. This happens because token-overlap similarity works this way, rather than being a bug.

=== Confidence Score Engine: Worked Numeric Examples

`src/lib/confidenceScore.ts` computes a final confidence score once a claim reaches its 3-verifier quorum:

$ C = (A times 40%) + (R times 30%) + (S times 30%) $

where $A$ (Agreement Ratio) is the percentage of verifiers whose verdict matches the majority verdict, $R$ (Average Reputation) is the mean of the participating verifiers' reputation scores ($0$ to $100$), and $S$ (Average Source Quality) is the mean of each verifier's cited-source quality score (`sourceQualityToScore`: high = 100, medium = 70, low = 30). All three inputs are already on a $0$ to $100$ scale before weighting.

*Primary worked example (3 verifiers, 2 vote TRUE, 1 votes FALSE):*

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

Final verdict: *TRUE, 66% confidence.* This matches the `calculateConfidenceScore()` implementation's `Math.round()` behavior. The result is deliberately moderate rather than high. The formula penalizes the outcome for the dissenting FALSE vote and for the low-quality source, even though a 2-to-1 majority might look stronger than 66%.

*Contrasting examples:*

#styled-table(
  columns: (2.1fr, 1fr, 0.9fr, 0.9fr, 0.7fr, 1.8fr),
  headers: ("Scenario", "A", "R", "S", "C", "Practical Outcome"),
  [Unanimous, well-sourced (TRUE, TRUE, TRUE)], "100%", "81.67", "100", [*95*], [High-confidence TRUE (the common case for well-documented claims)],
  [2 to 1 split (primary example above)], "66.67%", "65", "66.67", [*66*], "Moderate-confidence TRUE",
  [Three-way split (TRUE, FALSE, MISLEADING)], "33.33%", "60", "56.67", [*48*], [Low-confidence (if unresolved by day 7, settles as `CONTESTED`)],
)

#v(4pt)

The behavior across all three scenarios is internally consistent. Confidence scales down smoothly as agreement, reputation, and source quality degrade, rather than jumping discontinuously. This matches the intended design goal of a weighted consensus formula over a simple majority vote.

=== Discussion: What Worked Well and Known Limitations

*What worked well:*
- The Jaccard duplicate-detection engine reliably catches the most common WhatsApp pattern (a forward being copy-pasted or lightly re-forwarded with cosmetic additions) at zero server cost and entirely client-side. No false positives were observed among the distinct-claim pairs exercised during testing.
- The weighted confidence formula produces expected results. Unanimous, well-sourced verdicts trend toward the 90s, a single dissenting vote pulls a majority down into the 60s, and a three-way split collapses below 50. This correctly allows unresolved claims to settle as `CONTESTED` rather than forcing a majority.
- The dual-layer admin authorization (client-side `AdminRoute` re-check plus server-side `firestore.rules` `isAdmin()`) held up against a manual `sessionStorage` tampering attempt during Module 8 security testing.
- Client-side OCR extracted clean, usable text from typical sharp WhatsApp screenshots. The WhatsApp interface cleanup (`cleanExtractedOcrText()`) stripped timestamps, delivery checkmarks, and battery status text in every screenshot tested.

*Known limitations:*
- Jaccard token-overlap similarity is syntactic, not semantic. As Example 3 above shows, a heavily reworded retelling of the same claim falls below the 0.75 threshold and is queued as a new claim, causing redundant verification effort. This happens because the bag-of-words approach runs client-side with no infrastructure cost. A semantic similarity model would catch more paraphrases but requires a server-side inference call or a larger client-side model, which goes against the serverless design constraints described in Section 1.3.2.
- Confidence-score source-quality tiering depends on a fixed domain list (`HQ_DOMAINS` / `MQ_DOMAINS` in `confidenceScore.ts`). A verifier citing a credible source that is not on the list defaults to the lowest tier ($30/100$), which can lower confidence for a well-evidenced verdict.
- OCR accuracy on blurry, rotated, or heavily recompressed screenshots is imperfect. The user must manually review and correct extracted text before submission. This was verified against a small set of screenshots rather than an extensive accuracy study.
- All functional and beta testing involved the developer and seeded demo accounts, not a live population of independent verifiers. Real-world consensus dynamics (group voting, expert disagreement, adversarial voting) remain unobserved and are noted as future work in Chapter 7.
- No load or performance testing at production scale was conducted. Firestore free-tier read/write quotas were checked logically against expected traffic for a college deployment, not stress-tested against concurrent load.

== User Documentation

Role-based user manual for FactStamp, matching the routes defined in `src/App.tsx`. Screenshots are captured separately according to the `Only_module/how_to.md` conventions. Every screen below carries a plain text placeholder marking where the captured image belongs. It is organized into two parts: For End Users (public routes) and For Administrators (the `/admin` console).

=== For End Users

==== Home (`/`)

Home is a public landing page that does not require an account. It opens with a hero section showing an animated "Forward #sym.arrow Stamped Card" transformation using a real example claim turning into a verdict stamp. It includes live platform statistics and two buttons, "Submit a Forward" and "Explore Verification Queue". Below the hero, a "Recently Debunked Claims" feed shows the most recently resolved claims from Firestore so visitors can see real verdicts before registering.

#screenshot-placeholder("Home")

==== Sign In (`/signin`)

A public email/password and Google OAuth login form. Login attempts use a client-side rate limiter (`checkLoginRateLimit`) that locks an account for 15 minutes after 5 failed attempts and displays a live countdown. A collapsible "Demo Accounts for Testing" panel lets evaluators fill demo verifier credentials with one click, allowing app review without making a new account.

#screenshot-placeholder("Sign In")

==== Sign Up (`/signup`)

A public registration form collecting display name, email, and password, with live password-strength feedback. Submitting the form creates a Firebase Authentication account and a matching Firestore `users/{uid}` profile, starting at the base reputation score of 50 (Novice Verifier tier).

#screenshot-placeholder("Sign Up")

==== Submit (`/submit`)

A signed-in user reports a suspicious claim via two tabs. The Text tab accepts 20 to 500 characters of claim text and checks it against existing claims using the duplicate-detection engine. If a match $>= 0.75$ similarity is found, a banner appears with a link to the existing verdict instead of creating a duplicate. The Screenshot (OCR) tab accepts a pasted or dropped WhatsApp screenshot, runs it through the Tesseract.js OCR engine, strips WhatsApp interface elements, and populates the text into an editable field for review before submission.

#screenshot-placeholder("Submit a Claim")

==== Claim Detail (`/claim/:claimId`)

A public page showing the full lifecycle of a claim. It displays the claim text, a `VerdictStamp` badge colored by verdict (emerald TRUE, crimson FALSE, amber MISLEADING, slate UNVERIFIABLE, blue CONTESTED), and its computed confidence percentage. It shows verifier explanations and cited sources. A "Download WhatsApp Card (PNG)" button rasterizes the card client-side via `html-to-image` into a PNG. It is sized and styled to be forwarded back into WhatsApp.

#screenshot-placeholder("Claim Detail")

==== Verify Queue (`/verify`)

The community verification workbench entry point lists claims awaiting their 3-verifier quorum. A search box filters by text, a sort control reorders the list, and category chips narrow the results. Claims flagged by an administrator for expedited review float to the top of the queue.

#screenshot-placeholder("Verify Queue")

==== Verify Detail (`/verify/:claimId`)

A verifier casts a verdict via a 3-step wizard. Step 1 selects a verdict rating. Step 2 requires a source evidence URL, which derives the source-quality score. Step 3 requires a written explanation, validated by `validateVerdictExplanation()` (minimum 50 characters or 8 words, plus spam and copy-paste prevention checks).

#screenshot-placeholder("Verify Detail")

==== Dashboard (`/dashboard`)

A public analytics page. KPI cards summarize registered verifiers, total claims, and verifications logged. A rolling weekly "Misinformation Trends" report shows claim volume and most-debunked claims. A category-distribution chart breaks volume down across Health, Political, Financial, Religious, and Other. A community claims directory sits alongside a top-verifiers leaderboard.

#screenshot-placeholder("Dashboard")

==== Profile (`/profile`)

A signed-in verifier's personal reputation page. It displays an animated counter showing their current reputation score, a sparkline chart of that score's history, and their current tier: Novice Verifier ($0$ to $30$), Trusted Analyst ($31$ to $60$), Expert Fact-Checker ($61$ to $85$), or Elite Guardian ($86$ to $100$). It includes a progress indicator toward the next tier and a history of submitted verdicts.

Each tier is labelled in the UI with a consensus vote-weight: Novice Verifier and Trusted Analyst read "Standard $1.0 times$", Expert Fact-Checker reads "Elevated $1.25 times$", and Elite Guardian reads "Maximal $1.5 times$". The first two tiers are mechanically identical. This vote weight is presentational. The label is produced by `repLevel()` in `src/pages/Profile.tsx` and is not consumed elsewhere. The consensus engine applies no tier multiplier because `calculateConfidenceScore()` takes the arithmetic mean of the participating verifiers' reputations. Reputation influences confidence through that averaged term, not through the per-tier multiplier shown in the UI.

#screenshot-placeholder("Profile")

=== For Administrators

The Admin Command Center lives at `/admin`. It is not linked in the public `Navbar` or `Footer` and is reachable only by typing the URL directly. Access requires dual-layer authorization: a client-side `AdminRoute` guard re-derives clearance from the live Firestore `isAdmin` field on every render, backed by the `isAdmin()` check enforced server-side in `firestore.rules`. The console is a single page with 5 tabs.

==== Admin: System Overview

The default tab on entering `/admin` displays KPI cards for registered verifiers, total claims, verifications logged, and incident-queue size. It includes two Recharts visualizations (a claims-by-category bar chart and a verdict-consensus pie chart) and a verifier reputation-tier breakdown presented as a plain counts grid.

#screenshot-placeholder("Admin - System Overview")

==== Admin: Verifier Directory

A searchable, filterable table of every registered `User`. Per-row actions let an administrator edit a verifier's reputation score via a slider, toggle their `isAdmin` flag, or delete the account. Every write is checked against `firestore.rules` `isAdmin()` on the server side.

#screenshot-placeholder("Admin - Verifier Directory")

==== Admin: Claims Moderation

A searchable, filterable table of every `Claim` in the system. Per-row actions let an administrator toggle an expedited-review flag on a claim, override its verdict/confidence/status, edit the text or category, inspect or delete an individual verification attached to it, or hard-delete the claim entirely.

#screenshot-placeholder("Admin - Claims Moderation")

==== Admin: Incident Queue

A `ModerationReport` ticket queue filterable by status and severity. An administrator can open a new incident report against a claim, user, or verification. They can dismiss unfounded reports or mark them resolved once handled.

#screenshot-placeholder("Admin - Incident Queue")

==== Admin: Audit #sym.amp Tools

An immutable, real-time audit-log viewer (`AdminAuditLog`) records every mutating admin action taken across the other four tabs. It sits alongside system-wide tools to force-run consensus expiry on claims past their 7-day deadline, broadcast a notification to all registered users, and export a full JSON database backup covering claims, users, incident reports, and the audit log.

#screenshot-placeholder("Admin - Audit and Tools")
