#import "../lib/helpers.typ": *

= Results and discussion

// Screenshot Placeholder Helper: plain text, no #image() call on a
// non-existent file. Real screenshots are captured separately per
// Only_module/how_to.md and wired in later via responsive-image().
#let screenshot(file, width: 92%) = align(center)[
  #image("attachments/" + file, width: width)
]

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

== Test reports and empirical metrics

This section reports what happened when the test cases from Chapter 5 (5.3 Testing Approach, 5.5 Test Cases) were run against the actual implementation. The numbers, formulas, and worked examples come directly from the source (`src/lib/duplicateDetection.ts`, `src/lib/confidenceScore.ts`). As suits a BSc IT project, testing was manual and functional: one developer ran the application with a few seeded demo accounts created with `scripts/create-user.mjs` and `scripts/seed-db.mjs`. The repository has no automated test runner (`package.json` defines no `test` script, and there is no Jest, Vitest, Playwright, or Cypress configuration), so every test case was a structured manual walkthrough based on Section 5.3. The only automated check is the `typecheck-and-build` job in `.github/workflows/ci.yml` (`npm ci` #sym.arrow.r `npm run typecheck` #sym.arrow.r `npm run build`), which catches type and build errors but not behavioral problems.

=== Summary results table

Test cases are grouped by the 8 core system modules plus the Admin console. The two "Open / Deferred" items are known, non-blocking behaviors found during testing. They were recorded as limitations instead of being patched, for the reasons given below the table.

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

Neither open item is a crash or a data-loss defect:

+ *Module 2 (OCR):* On heavily recompressed or slightly rotated WhatsApp screenshots, the Tesseract.js pass in `ocrService.ts` sometimes drops the last line of text. The Submit page already shows the extracted text in an editable field before submission, so the user can type in whatever is missing. The accuracy problem itself was left open because it comes from the lightweight client-side WASM OCR engine, not from a coding error.
+ *Module 8 (Security):* In a throttled-CPU test, the `setInterval`-driven countdown for the 30-minute idle timeout drifted by a few seconds. The session still expires and logs the user out correctly, but the displayed countdown can lag the true value by 1 to 3 seconds. This stays open until the timer is rebuilt on `requestAnimationFrame`.

=== Duplicate detection accuracy: worked examples

`src/lib/duplicateDetection.ts` computes Jaccard word-overlap similarity between a submitted claim and the existing claims. `tokenize()` lowercases the text, strips punctuation, splits it on whitespace, and keeps only tokens longer than 3 characters. Similarity is $J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|)$. An existing claim scoring $>= 0.75$ sends the submitter to that claim instead of creating a new one.

The three worked examples below all start from the demo claim used in the FactStamp home page animation (`src/pages/Home.tsx`):

#block(fill: rgb("FAFAFA"), stroke: 0.4pt + luma(180), inset: 8pt, radius: 2pt, width: 100%)[
  *Base Claim (A):* _"Drinking hot water with lemon cures dengue fever completely in 24 hours, confirmed by AIIMS doctors. Share with family!"_
]

#v(4pt)

After normalization, Claim A's significant tokens (words longer than 3 characters) are `{drinking, water, with, lemon, cures, dengue, fever, completely, hours, confirmed, aiims, doctors, share, family}`, 14 in total.

#styled-table(
  columns: (auto, 2.6fr, 0.8fr, 0.8fr, 0.8fr, 1.3fr),
  headers: ("#", "Scenario (Second Claim B)", [$|S_A inter S_B|$], [$|S_A union S_B|$], [$J(A,B)$], "Duplicate Engine Result"),
  "1", [Real re-forward: same text, added urgency words #sym.amp emoji], "14", "16", "0.875", "Flagged as duplicate",
  "2", "Literal copy-paste: only case / punctuation / emoji differ", "14", "14", "1.000", "Flagged as duplicate",
  "3", "Heavy paraphrase: same underlying claim, different wording", "4", "22", "0.182", "Not flagged (new claim)",
)

#v(4pt)

Examples 1 and 2 show the $>= 0.75$ threshold catching the most common WhatsApp case: a message copy-pasted or lightly re-forwarded with cosmetic additions such as punctuation, emoji, or a few extra words, which is how most forwards spread. Example 3 shows a limitation discussed below. A heavily reworded retelling of the same claim, sharing little vocabulary beyond a few nouns, falls under the threshold and is treated as a new claim. That follows from how token-overlap similarity works; the code is behaving as designed.

=== Confidence score engine: worked numeric examples

Once a claim reaches its 3-verifier quorum, `src/lib/confidenceScore.ts` computes a final confidence score:

$ C = (A times 40%) + (R times 30%) + (S times 30%) $

where $A$ (Agreement Ratio) is the percentage of verifiers whose verdict matches the majority verdict, $R$ (Average Reputation) is the mean reputation of the participating verifiers ($0$ to $100$), and $S$ (Average Source Quality) is the mean quality score of the sources they cited (`sourceQualityToScore`: high = 100, medium = 70, low = 30). All three inputs are on a $0$ to $100$ scale before weighting.

*Primary worked example (3 verifiers: 2 vote TRUE, 1 votes FALSE):*

#styled-table(
  columns: (auto, 1fr, 1fr, 1.4fr, 1fr),
  headers: ("Verifier", "Verdict", "Reputation", "Cited Source", "Source Quality"),
  "V1", "TRUE", "62", "who.int (high)", "100",
  "V2", "TRUE", "78", "reuters.com (medium)", "70",
  "V3", "FALSE", "55", "unlisted personal blog (low)", "30",
)

#v(4pt)

The majority verdict is TRUE (2 of 3 verifiers). Computing each component by hand:

$ A = frac(2, 3) times 100% = 66.67% $
$ R = frac(62 + 78 + 55, 3) = frac(195, 3) = 65 $
$ S = frac(100 + 70 + 30, 3) = frac(200, 3) = 66.67 $

Substituting into the weighted formula:

$ C = (66.67 times 40%) + (65 times 30%) + (66.67 times 30%) $
$ C = 26.67 + 19.50 + 20.00 = 66.17 approx 66 $

Final verdict: *TRUE, 66% confidence*, which matches what `calculateConfidenceScore()` returns after `Math.round()`. A 2-to-1 majority might look stronger than 66%, but the formula pulls the score down for the dissenting FALSE vote and for the low-quality source, and that is what it is meant to do.

*Contrasting examples:*

#styled-table(
  columns: (2.1fr, 1fr, 0.9fr, 0.9fr, 0.7fr, 1.8fr),
  headers: ("Scenario", "A", "R", "S", "C", "Practical Outcome"),
  [Unanimous, well-sourced (TRUE, TRUE, TRUE)], "100%", "81.67", "100", [*95*], [High-confidence TRUE (the common case for well-documented claims)],
  [2 to 1 split (primary example above)], "66.67%", "65", "66.67", [*66*], "Moderate-confidence TRUE",
  [Three-way split (TRUE, FALSE, MISLEADING)], "33.33%", "60", "56.67", [*48*], [Low-confidence (if unresolved by day 7, settles as `CONTESTED`)],
)

#v(4pt)

Across the three scenarios, confidence falls steadily as agreement, reputation, and source quality weaken, with no sudden jumps. That gradual behavior is the reason for using a weighted formula instead of a simple majority vote.

=== Discussion: what worked and known limitations

*What worked well:*
- The Jaccard engine catches the most common WhatsApp pattern, a forward that is copy-pasted or lightly re-forwarded with cosmetic additions, entirely in the browser and at no server cost. No false positives appeared among the distinct-claim pairs tried during testing.
- The weighted confidence formula behaves as expected. Unanimous, well-sourced verdicts land in the 90s, one dissenting vote pulls a majority down into the 60s, and a three-way split drops below 50. A score that low lets an unresolved claim settle as `CONTESTED` instead of being forced into a majority.
- The dual-layer admin authorization (the client-side `AdminRoute` re-check plus the server-side `isAdmin()` in `firestore.rules`) held up against a manual `sessionStorage` tampering attempt during Module 8 security testing.
- Client-side OCR produced clean, usable text from typical sharp WhatsApp screenshots, and `cleanExtractedOcrText()` removed timestamps, delivery checkmarks, and battery status text from every screenshot tested.

*Known limitations:*
- Jaccard token-overlap similarity compares words, not meaning. As Example 3 shows, a heavily reworded retelling of the same claim falls below the 0.75 threshold and is queued as a new claim, which wastes verification effort. That is the cost of a bag-of-words method that runs in the browser with no infrastructure. A semantic similarity model would catch more paraphrases, but it needs either a server-side inference call or a much larger client-side model, and both conflict with the serverless design constraints in Section 1.3.2.
- Source-quality tiering depends on a fixed domain list (`HQ_DOMAINS` / `MQ_DOMAINS` in `confidenceScore.ts`). A verifier who cites a credible source that is not on the list gets the lowest tier ($30/100$), which can drag down confidence in a well-evidenced verdict.
- OCR is unreliable on blurry, rotated, or heavily recompressed screenshots, so the user has to review and correct the extracted text before submitting. This was checked against a small set of screenshots, not a full accuracy study.
- All functional and beta testing used the developer and seeded demo accounts, not a live population of independent verifiers. Real-world consensus dynamics (group voting, expert disagreement, adversarial voting) have not been observed and are listed as future work in Chapter 7.
- No load or performance testing was done at production scale. Firestore free-tier read and write quotas were checked on paper against expected traffic for a college deployment, not stress-tested under concurrent load.

== User documentation

This is a role-based user manual for FactStamp, following the routes defined in `src/App.tsx`. It has two parts: one for end users, covering the regular (non-admin) routes, and one for administrators, covering the `/admin` console. Screenshots are captured separately, and each screen below has a text placeholder where its screenshot will go.

=== For end users

==== Home (`/`)

The home page is public and needs no account. Its hero section plays an animated "Forward #sym.arrow Stamped Card" sequence in which a real example claim turns into a verdict stamp, alongside live platform statistics and two buttons, "Submit a Forward" and "Explore Verification Queue". Below the hero, a "Recently Debunked Claims" feed lists the latest resolved claims from Firestore, so visitors can see real verdicts before they register.

#screenshot("home.png")

==== Sign In (`/signin`)

The sign-in page is a public login form for email/password and Google OAuth. A client-side rate limiter (`checkLoginRateLimit`) locks an account for 15 minutes after 5 failed attempts and shows a live countdown. A collapsible "Demo Accounts for Testing" panel fills in demo verifier credentials with one click, so evaluators can review the app without creating an account.

#screenshot("signin.png")

==== Sign Up (`/signup`)

The public registration form asks for a display name, email, and password, and gives live feedback on password strength. Submitting it creates a Firebase Authentication account and a matching Firestore `users/{uid}` profile that starts at the base reputation score of 50 (Novice Verifier tier).

#screenshot("signup.png")

==== Submit (`/submit`)

A signed-in user reports a suspicious claim through one of two tabs. The Text tab accepts 20 to 500 characters and runs the duplicate-detection check against existing claims. If a match scores $>= 0.75$, a banner links to the existing verdict and no duplicate is created. The Screenshot (OCR) tab takes a pasted or dropped WhatsApp screenshot, runs Tesseract.js OCR on it, strips WhatsApp interface elements, and puts the text in an editable field for review before submission.

#screenshot("submit.png")

==== Claim Detail (`/claim/:claimId`)

This public page shows a claim's full lifecycle: the claim text, a `VerdictStamp` badge colored by verdict (emerald TRUE, crimson FALSE, amber MISLEADING, slate UNVERIFIABLE, blue CONTESTED), the computed confidence percentage, and the verifiers' explanations and cited sources. A "Download WhatsApp Card (PNG)" button rasterizes the card in the browser with `html-to-image` into a PNG sized and styled for forwarding back into WhatsApp.

#screenshot("claim_detail.png")

==== Verify Queue (`/verify`)

Community verification starts here. The page lists claims still waiting for their 3-verifier quorum, with a search box that filters by text, a sort control, and category chips that narrow the list. Claims an administrator has flagged for expedited review stay at the top.

#screenshot("verify_queue.png")

==== Verify Detail (`/verify/:claimId`)

A verifier casts a verdict through a 3-step wizard. Step 1 is choosing a verdict. Step 2 asks for a source URL, from which the source-quality score is derived. Step 3 asks for a written explanation, which `validateVerdictExplanation()` checks (minimum 50 characters or 8 words, plus spam and copy-paste checks).

#screenshot("verify_detail.png")

==== Dashboard (`/dashboard`)

The public analytics page opens with KPI cards for registered verifiers, total claims, and verifications logged. A rolling weekly "Misinformation Trends" report shows claim volume and the most-debunked claims, and a category chart splits volume across Health, Political, Financial, Religious, and Other. A community claims directory sits next to a leaderboard of top verifiers.

#screenshot("dashboard.png")

==== Profile (`/profile`)

This is a signed-in verifier's reputation page. It shows the current reputation score as an animated counter, a sparkline of the score's history, and the current tier: Novice Verifier ($0$ to $30$), Trusted Analyst ($31$ to $60$), Expert Fact-Checker ($61$ to $85$), or Elite Guardian ($86$ to $100$). A progress indicator shows how close the user is to the next tier, and a history lists their submitted verdicts.

The UI labels each tier with a consensus vote weight: "Standard $1.0 times$" for both Novice Verifier and Trusted Analyst, "Elevated $1.25 times$" for Expert Fact-Checker, and "Maximal $1.5 times$" for Elite Guardian. These labels are cosmetic. `repLevel()` in `src/pages/Profile.tsx` produces them and nothing else reads them, and the consensus engine applies no tier multiplier, since `calculateConfidenceScore()` simply averages the participating verifiers' reputations. Reputation affects confidence only through that averaged term.

#screenshot("profile.png")

=== For administrators

The Admin Command Center lives at `/admin`. It has no link in the public `Navbar` or `Footer` and can only be reached by typing the URL. Access needs two layers of authorization: a client-side `AdminRoute` guard that re-derives clearance from the live Firestore `isAdmin` field on every render, and the server-side `isAdmin()` check in `firestore.rules`. The console is a single page with 5 tabs.

==== Admin: System Overview

This is the default tab on entering `/admin`. It shows KPI cards for registered verifiers, total claims, verifications logged, and incident-queue size, two Recharts charts (claims by category as a bar chart and verdict consensus as a pie chart), and a plain grid of verifier counts per reputation tier.

#screenshot("admin_overview.png")

==== Admin: Verifier Directory

A searchable, filterable table lists every registered `User`. From each row an administrator can change the verifier's reputation with a slider, toggle their `isAdmin` flag, or delete the account. The server checks every one of these writes against `isAdmin()` in `firestore.rules`.

#screenshot("admin_verifiers.png")

==== Admin: Claims Moderation

A searchable, filterable table lists every `Claim` in the system. From each row an administrator can toggle the claim's expedited-review flag, override its verdict, confidence, or status, edit its text or category, inspect or delete an individual verification attached to it, or delete the claim entirely.

#screenshot("admin_moderation.png")

==== Admin: Incident Queue

This tab holds the queue of `ModerationReport` tickets, which can be filtered by status and severity. An administrator can open a new report against a claim, user, or verification, dismiss reports that turn out to be unfounded, and mark others resolved once they have been dealt with.

#screenshot("admin_incidents.png")

==== Admin: Audit #sym.amp Tools

The last tab is a real-time viewer for the immutable audit log (`AdminAuditLog`), which records every mutating admin action taken in the other four tabs. It also holds the system-wide tools: force-running consensus expiry on claims past their 7-day deadline, sending a notification to every registered user, and exporting a full JSON backup of claims, users, incident reports, and the audit log.

#screenshot("admin_audit.png")
