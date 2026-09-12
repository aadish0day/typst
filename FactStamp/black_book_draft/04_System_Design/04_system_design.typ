#import "../lib/helpers.typ": *

= System design

// Plain-text Diagram Placeholder Helper (no #image() call on a non-existent asset)
#let diagram-placeholder(caption) = align(center)[
  #block(
    width: 92%,
    stroke: 0.6pt + luma(140),
    fill: rgb("FAFAFA"),
    radius: 3pt,
    inset: 18pt,
  )[
    #align(center)[
      #text(size: 10pt, weight: "bold", fill: luma(110))[DIAGRAM PENDING]
      #v(4pt)
      #text(size: 9.5pt, fill: luma(110))[#caption]
    ]
  ]
]

This chapter turns the functional requirements and data models from Chapter 3 into a working design. It covers the eight functional modules, the Cloud Firestore schema and the declarative server-side security rules that govern it, the duplicate-detection and consensus algorithms, the custom component interface, the defense-in-depth security policies, and the end-to-end test suite. Every specification here matches the implementation in the repository (`/home/aadish/Documents/Github/FactStamp`).

== Basic modules

The system splits its runtime responsibilities across eight modules. Each module maps to its own source files and handles part of the claim lifecycle (submission #sym.arrow.r duplicate check #sym.arrow.r verification queue #sym.arrow.r consensus #sym.arrow.r card generation #sym.arrow.r analytics aggregation). Module 8 supplies the security and notification services that the others share.

*Module 1: Authentication & Verifier Reputation.* Core files: `src/contexts/AuthContext.tsx`, `src/pages/SignIn.tsx`, `src/pages/SignUp.tsx`, `src/services/firebaseService.ts`. `AuthContext.tsx` wraps the Firebase Authentication SDK in a React Context and exposes session state and the authentication methods (`signIn`, `signUp`, `signInWithGoogle`, `signOut`, `updateUser`) to the whole component tree. Users register with email credentials or Google OAuth. On registration, `firebaseService.ts` creates a `users/{uid}` document in Firestore with `reputation` set to 50 (on a 0 to 100 scale), `totalVerifications` at 0, and `isAdmin` set to false. `firestore.rules` checks these initial values on write, so a client cannot change them. Other modules rely on these authenticated identities: Module 2 records the submitter, Module 4 ties each verification to its author, and Module 5 reads each voter's reputation when it calculates consensus.

*Module 2: Forward Submission / Ingestion & OCR.* Core files: `src/pages/Submit.tsx`, `src/services/ocrService.ts`, `src/lib/imageCompression.ts`. `Submit.tsx` accepts a claim as pasted text or as a screenshot. For an image, `imageCompression.ts` first rescales and compresses the bitmap in the browser with the HTML5 Canvas API. `ocrService.ts` then runs Tesseract.js OCR in a WebAssembly browser worker, so the image is never uploaded to an external server. `cleanExtractedOcrText()` strips WhatsApp UI artifacts such as timestamps, sender headers, and delivery checkmarks from the output, and the user can review and edit the parsed text before confirming. On confirmation, `Submit.tsx` runs the Module 3 duplicate check before saving a new `claims/{claimId}` record.

*Module 3: Duplicate Detection Engine.* Core file: `src/lib/duplicateDetection.ts`. This file compares the candidate claim text with every existing claim in Firestore using word-token Jaccard similarity. Text is lowercased, stripped of punctuation, and whitespace-collapsed, then split into a set of words longer than three characters. For each existing claim the module computes the token-overlap similarity between the two claims. If the best match reaches 0.75 or higher, the UI blocks the submission and shows an inline notice linking to the existing claim. Otherwise the claim is saved as a new `pending` record and appears in the Module 4 verification queue.

*Module 4: Verification Queue.* Core files: `src/pages/VerifyQueue.tsx`, `src/pages/VerifyDetail.tsx`, `src/contexts/ClaimsContext.tsx`. `VerifyQueue.tsx` lists every claim in `pending` status, with admin-flagged items sorted to the top. `VerifyDetail.tsx` is the verifier's review screen. The verifier picks a verdict (`TRUE`, `FALSE`, `MISLEADING`, or `UNVERIFIABLE`; `CONTESTED` is reserved for automatic timeout settlement), enters a source URL that `determineSourceQuality()` classifies into a quality tier, and writes an explanation. `validateVerdictExplanation()` in `src/lib/security.ts` requires the explanation to have at least 50 characters and 8 words. A valid submission appends one element to `claims.verifications[]` and increments `verificationCount` by 1, and both the React context and the server-side `firestore.rules` enforce this. When `verifications.length` reaches the quorum of 3, `ClaimsContext.tsx` calls Module 5 to calculate consensus and saves the final verdict in the same write.

*Module 5: Weighted Consensus and Confidence Engine.* Core file: `src/lib/confidenceScore.ts`. `calculateConfidenceScore()` combines the verifications into a single outcome, weighting the majority agreement ratio at 40%, the mean verifier reputation at 30%, and the mean source quality at 30%.

The module also handles consensus timeouts. When a `pending` claim passes its 7-day `consensusDeadline` without reaching the 3-verifier quorum, an expiry sweep calculates a confidence score from whatever verifications exist and assigns the verdict `CONTESTED`. Once a claim's status becomes `verified`, Module 5 has Module 8 send an in-app notification to the original submitter, and the claim becomes available for export in Module 6.

*Module 6: Fact-Check Card Generator.* Core files: `src/components/FactCheckCard.tsx`, `src/pages/ClaimDetail.tsx`. Together these render a resolved verdict as a graphic summary. The `html-to-image` library rasterizes the component in the browser into a PNG 1080px wide: a 540px DOM container rendered at `pixelRatio: 2`, with its height growing to fit the claim text and citations. The library serializes the DOM through SVG `<foreignObject>`, which keeps Tailwind CSS v4's `oklch()` and `oklab()` color values intact without raster artifacts. Users download the image and share it in their messaging groups.

*Module 7: Misinformation Analytics Dashboard.* Core files: `src/pages/Dashboard.tsx`, `src/components/DashboardChart.tsx`, `src/lib/weeklyReport.ts`. These files turn historical verification data into public charts. `weeklyReport.ts` looks at claims resolved within a 7-day sliding window and derives category distributions, verdict frequencies, and the most prominent refuted claims. Recharts draws the charts with custom tooltip formatters. The dashboard is read-only: it uses data already in the active React context and makes no extra database writes.

*Module 8: System Security & Notifications.* Core files: `src/lib/security.ts`, `src/contexts/NotificationsContext.tsx`, `src/components/NotificationBell.tsx`, `firestore.rules`. These files handle the protection and notification services the other modules share. `security.ts` covers input sanitization, spam mitigation, magic-byte file validation, session timeouts, and client rate limiting. `NotificationsContext.tsx` and `NotificationBell.tsx` deliver real-time in-app alerts when a claim is resolved. `firestore.rules` validates every mutation independently on Firebase's servers.

#v(6pt)
#align(center)[*Table 4.1.1: Cross-Module Interaction Summary*]
#styled-table(
  columns: (1.6fr, 0.85fr, 0.85fr, 1.9fr),
  headers: ("Trigger", "Calling Module", "Called Module", "Effect"),
  "User submits claim text/screenshot", "2", "3", "Jaccard check against existing claims before a new document is created",
  [Best similarity of 0.75 or higher against an existing claim], "3", "2", "Submission blocked; user offered a direct link to the existing claim page",
  "Verifier submits a verdict", "4", "8", [`validateVerdictExplanation()` validates input before the Firestore write],
  [`verifications.length` reaches 3], "4", "5", [`calculateConfidenceScore()` computes final verdict; status #sym.arrow.r `verified`],
  [`consensusDeadline` passes with count below 3], "5", "4", "Claim force-settled with verdict CONTESTED",
  "Claim reaches verified status", "5", "8", "Submitter notified; verifier reputation updated",
  "Claim reaches verified status", "5", "6", "Claim becomes eligible for PNG card export",
  [Every write to `users`, `claims`, `notifications`, `reports`, `audit_logs`], "1, 2, 4, 5", "8", [Server-side field-level validation independent of client checks],
)

== Data design

FactStamp stores application state in Cloud Firestore, a NoSQL document database, across five root collections: `users`, `claims`, `notifications`, `reports`, and `audit_logs`. The type interfaces are declared in `src/lib/types.ts`, and `firestore.rules` checks the write constraints on every write.

=== Schema design
<fig-schema>

#align(center)[*Table 4.2.1(a): `users` Collection*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`uid`], "string", "Firebase Auth user ID (document ID)", "Immutable after creation",
  [`displayName`], "string", "Verifier's display name", "Max 100 characters",
  [`email`], "string", "Account email address", [Must match the Auth token email; immutable],
  [`avatarUrl`], "string?", "Profile picture URL", "Optional",
  [`reputation`], "number", "Verifier reputation score, 0 to 100", "Defaults to 50 at signup; admin-writable only thereafter",
  [`totalVerifications`], "number", "Lifetime verifications submitted", "Defaults to 0; admin-writable only",
  [`joinedAt`], "string (ISO 8601)", "Account creation timestamp", "Immutable",
  [`isAdmin`], "boolean?", "Staff clearance flag", "Defaults to false; only an existing admin can flip it",
)

#v(4pt)
#align(center)[*Table 4.2.1(b): `claims` Collection*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Claim document ID", "Firestore auto-ID",
  [`text`], "string", "Normalized claim text", "10 to 2000 characters, server-enforced",
  [`category`], "enum", [`health` \| `political` \| `religious` \| `financial` \| `other`], "Fixed whitelist",
  [`status`], "enum", [`pending` \| `verified`], [`verified` covers quorum and CONTESTED outcomes],
  [`createdAt`], "string (ISO)", "Submission timestamp", "Immutable",
  [`verifiedAt`], "string?", "Final-verdict timestamp", "Set once, on resolution",
  [`consensusDeadline`], "string (ISO)", [`createdAt` + 7 days], "Immutable; drives expiry sweep",
  [`submittedBy`], "string", [Submitter `uid`], "Immutable",
  [`submittedByName`], "string", "Display-name snapshot", "Max 100 chars; immutable",
  [`imageUrl`], "string?", "Base64 data URI or HTTPS URL", [At most 800,000 chars (~800 KB); pattern-matched],
  [`verdict`], "enum?", [TRUE \| FALSE \| MISLEADING \| UNVERIFIABLE \| CONTESTED], "Set only once resolved",
  [`confidenceScore`], "number?", "Final weighted confidence, 0 to 100", "Computed by Module 5",
  [`verifications`], [array of Verification], "Embedded verification records", "Starts as empty array",
  [`verificationCount`], "number", [`verifications.length`, denormalized], "Must be 0 at creation; increments by exactly 1 per write",
  [`agreementRatio`], "number?", "Agreement-ratio component", "Denormalized",
  [`avgVerifierReputation`], "number?", "Avg. reputation component", "Denormalized",
  [`sourceQualityScore`], "number?", "Avg. source-quality component", "Denormalized",
  [`adminFlagged`], "boolean?", "Expedited-review flag", "Admin-writable only",
  [`adminFlaggedAt`], "string?", "Flag timestamp", "Admin-writable only",
)

#v(4pt)
#align(center)[*Table 4.2.1(c): Embedded `Verification` Sub-schema (element of `claims.verifications[]`)*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Verification identifier", "Client-generated",
  [`claimId`], "string", "Parent claim ID", "Redundant convenience field",
  [`verdict`], "enum", [TRUE \| FALSE \| MISLEADING \| UNVERIFIABLE], "CONTESTED is system-assigned only",
  [`sourceUrl`], "string", "Cited source URL", [Max 500 chars; matches `^https?://.+`],
  [`sourceQuality`], "enum", [`high` \| `medium` \| `low`], "Derived from domain whitelist",
  [`explanation`], "string", "Verifier's written rationale", "50 to 1500 chars client-side; 50 to 3000 server-side",
  [`verifierId`], "string", [Voting verifier's `uid`], [Must equal `request.auth.uid`],
  [`verifierName`], "string", "Verifier display-name snapshot", "Max 100 characters",
  [`verifierReputation`], "number", "Reputation at moment of voting", [Must equal the live reputation on `users/{uid}`],
  [`createdAt`], "string (ISO)", "Verification timestamp", "Immutable",
)

#v(4pt)
#align(center)[*Table 4.2.1(d): `notifications` Collection*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Notification document ID", "Firestore auto-ID",
  [`userId`], "string", [Recipient's `uid`], "Immutable; scoped read access",
  [`type`], "enum", [`claim_verified` \| `reputation_update` \| `weekly_report` \| `verdict_submitted`], "Immutable after creation",
  [`title`], "string", "Short heading", "Max 200 characters",
  [`message`], "string", "Notification body", "Max 2000 characters",
  [`createdAt`], "string (ISO)", "Creation timestamp", "Immutable",
  [`isRead`], "boolean", "Read/unread state", "Only field a recipient may self-update",
  [`claimId`], "string?", "Related claim, if applicable", "Immutable",
)

#v(4pt)
#align(center)[*Table 4.2.1(e): `reports` Collection (Moderation Incident Tickets)*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Report document ID", "Firestore auto-ID",
  [`targetType`], "enum", [`claim` \| `user` \| `verification`], "Fixed whitelist",
  [`targetId`], "string", "ID of the reported entity", "None",
  [`targetTitle`], "string", "Human-readable target label", "Max 300 characters",
  [`reason`], "enum", [`misinformation_spam` \| `harassment` \| `low_quality_source` \| `fake_account` \| `manipulation` \| `hate_speech` \| `other`], "Fixed whitelist",
  [`details`], "string?", "Reporter's free-text description", "Optional in the TS interface; required by the create rule; max 3000 characters",
  [`reportedBy`], "string", [Reporter's `uid`], [Must equal `request.auth.uid`],
  [`reportedByName`], "string", "Reporter display-name snapshot", "None",
  [`reportedAt`], "string (ISO)", "Submission timestamp", "None",
  [`status`], "enum", [`pending` \| `investigating` \| `resolved` \| `dismissed`], [Must be `pending` at creation],
  [`severity`], "enum", [`low` \| `medium` \| `high`], "Fixed whitelist",
  [`actionTaken`], "string?", "Admin's resolution note", "Admin-writable only",
  [`resolvedAt`], "string?", "Resolution timestamp", "Admin-writable only",
  [`resolvedBy`], "string?", [Resolving admin's `uid`], "Admin-writable only",
)

#v(4pt)
#align(center)[*Table 4.2.1(f): `audit_logs` Collection (Immutable)*]
#styled-table(
  columns: (1.75fr, 0.7fr, 1.55fr, 1.3fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Log entry ID", "Firestore auto-ID",
  [`timestamp`], "string (ISO)", "When the admin action occurred", "None",
  [`adminId`], "string", [Acting admin's `uid`], "None",
  [`adminName`], "string", "Admin display-name snapshot", "None",
  [`action`], "string", "Description of the action taken", "Max 200 characters",
  [`targetType`], "enum", [`claim` \| `user` \| `report` \| `system`], "Fixed whitelist",
  [`targetId`], "string", "ID of the entity acted upon", "None",
  [`details`], "string", "Additional context", "Max 2000 characters",
)

=== Data integrity and constraints

`firestore.rules` evaluates every incoming write before it is persisted, and the database rejects malformed or unauthorized writes outright.

*Field-level write validation.* The rules check `request.resource.data` field by field. Creating a `claims/{claimId}` document requires `text.size()` between 10 and 2000 characters, a `category` from an explicit whitelist, `status == "pending"`, `verificationCount == 0`, and an empty `verifications == []` array. A client therefore cannot create a claim that already carries votes or has text outside the length bounds.

*The `isAdmin()` helper.* Privileged operations check the caller's authority through an `isAdmin()` helper that reads the caller's Firestore document at evaluation time.


Only a caller who is already an admin can change the `isAdmin` flag on `users/{uid}`, so a user cannot grant themselves admin rights from the client.

*Append exactly one verification per write.* A write that adds a verification to a claim must meet all of these conditions at once: `verificationCount` increments by exactly 1, every earlier `verifications` entry is still present (checked with `hasAll()`), `verifierId` matches the caller's `request.auth.uid`, and `verifierReputation` equals the caller's live reputation in `users/{uid}`. The verdict must be one of `TRUE`, `FALSE`, `MISLEADING`, or `UNVERIFIABLE`, and `sourceUrl` and `explanation` must pass their length and regex checks. These rules mirror the client-side validation in `validateVerdictExplanation()`, so the database rejects invalid records even when a request bypasses the browser interface.

*Immutability rules.* The helper functions `isUnchanged()` and `identityUnchanged()` lock key fields once a document exists. `text`, `category`, `submittedBy`, `submittedByName`, `createdAt`, `consensusDeadline`, and `imageUrl` stay read-only through normal verification and timeout sweeps, and only administrators can override them. The `audit_logs` collection allows neither `update` nor `delete`, so its record of admin actions cannot be altered.

*Embedded storage and quorum atomicity.* Verifications are stored as an embedded array on each `Claim` document for two reasons. First, Module 5 resolves quorum atomically by reading `verifications.length` in the same snapshot as the verification append. With a subcollection, the count would need either an aggregation query or a separate counter kept in sync across several writes, which opens a race when quorum triggers. Second, any screen that shows a claim can load its metadata and full verification history in a single document read. `firestore.rules` still declares an unused legacy `verdicts` subcollection, but the application reads and writes only the embedded array. Firestore caps documents at 1 MiB, and with at most three verifications and a 3000-character explanation limit, a claim document stays well under that.

*Image payload constraints.* Screenshots are stored as base64 data URIs in `claims/{claimId}.imageUrl`. Base64 inflates binary data by about 33%, so `firestore.rules` enforces `imageUrl.size() <= 800000` characters to keep the whole document, including the `verifications` array, under Firestore's 1 MiB limit. On the client, images are scaled to a maximum dimension of 1280 pixels, and JPEG quality steps down from 0.72 (to no lower than 0.4) until the payload is below 700,000 bytes. The repository also contains a `storage.rules` configuration for authenticated uploads under 10 MB, but the client uses only the embedded data URI path.

*Server-side rule enforcement.* Client-side validation gives the user immediate feedback, but a direct call to the Firestore SDK skips the browser entirely. `firestore.rules` therefore holds the authoritative version of every constraint: enum membership, field length bounds, user ownership, quorum increment arithmetic, immutable fields, and administrator roles. The database applies these rules to every incoming operation regardless of what the client did.

== Procedural design

=== Logic diagrams

The control flow follows a claim from submission through duplicate evaluation and peer verification to final consensus, in nine stages: (1) the user submits claim text or an image screenshot; (2) an image goes through canvas compression, OCR extraction, WhatsApp header stripping, and user review before joining the text path; (3) the text is normalized and tokenized; (4) its tokens are compared against existing claims using the Jaccard index; (5) if a best similarity of 0.75 or higher, the submission is rejected with a link to the matching claim, and a lower score creates a new `pending` claim with a 7-day `consensusDeadline`; (6) the claim enters the verification queue, where independent verifiers each supply a verdict, a source URL, and a written explanation; (7) when `verifications.length` reaches 3, the consensus engine calculates the final score and marks the claim `verified`, while claims with fewer verifications stay `pending`; (8) an automated sweep settles any under-quorum claim past its 7-day deadline with the verdict `CONTESTED`; and (9) a verified claim triggers a submitter notification, becomes available for card generation, and updates the dashboard metrics.

#figure(
  image("attachments/claim_lifecycle_flow.svg", width: 100%, height: 88%, fit: "contain"),
  caption: [Claim Lifecycle Control Flow],
  kind: "diagram",
  supplement: "Diagram",
) <fig-lifecycle>

=== Data structures

The core data structures are declared once in `src/lib/types.ts`, and every module in Section 4.1 imports them from there instead of redeclaring them.

The `Verdict` type includes `CONTESTED`, which only the Module 5 consensus-expiry logic assigns; `VerifyDetail.tsx` does not offer it to verifiers. `Claim.verifications` is typed as an embedded array to match the storage design in Section 4.2.2. Because TypeScript strict mode forces every reader of an optional (`?`) field to handle the unset case, the dashboard components have to deal explicitly with `pending` records that have no `confidenceScore` yet.

== User interface design

FactStamp's components are custom-built, with no external UI component library. The interactive primitives (`Button`, `Input`, `Modal`, `Badge`, `CategoryBadge`, `VerdictPill`, `Avatar`, `SourceQualityDot`, `EmptyState`, `ErrorState`, `Skeletons`, `ThemeToggle`, `LoadingButton`, `PasswordStrength`, `ShimmerText`, `Marquee`, `FlowButton`, `InteractiveHoverButton`, `SpotlightCard`) live in `src/components/ui/` and are styled with Tailwind CSS v4 custom properties, so switching themes only means updating root-level variables. Framer Motion animates the navigation components and verdict badges, Recharts draws the charts in the dashboard and admin console, and React Context (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, `UsersContext`) holds application state.

#align(center)[*Table 4.4.1: Routing Table*]
#styled-table(
  columns: (1fr, 1.1fr, 1fr, 1.9fr),
  headers: ("Route", "Component", "Guard", "Notes"),
  [`/`], [`Home.tsx`], "Public", "Landing page",
  [`/signin`], [`SignIn.tsx`], "Public", "Email/password + Google OAuth",
  [`/signup`], [`SignUp.tsx`], "Public", "Account registration",
  [`/submit`], [`Submit.tsx`], "Protected", "Requires authenticated session",
  [`/claim`, `/claims`], "Redirect", "Public", [Redirects to `/verify`],
  [`/claim/:claimId`], [`ClaimDetail.tsx`], "Public", "Claim + fact-check card, viewable by anyone",
  [`/verify`], [`VerifyQueue.tsx`], "Protected", "Verification queue listing",
  [`/verify/:claimId`], [`VerifyDetail.tsx`], "Protected", "Verifier workbench for one claim",
  [`/dashboard`], [`Dashboard.tsx`], "Public (intentional)", [\"Public transparency, gated participation\"],
  [`/profile`], [`Profile.tsx`], "Protected", "User's own reputation/history",
  [`/admin`], [`Admin.tsx`], "Admin-guarded", "Unlisted route; dual-layer auth (see Section 4.5)",
  [`*`], [`NotFound.tsx`], "Public", "404 fallback",
)

*Home (`/`).* The hero section explains what FactStamp does and offers buttons to submit a claim or browse the queue. Below it are live platform counters (`AnimatedCounter`) and a walkthrough of the system's architecture. A persistent navigation bar shows authentication state, the theme toggle, notifications, and profile links.

#figure(
  image("attachments/wireframe_home.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Home Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-home>

*Submit (`/submit`, protected).* Users choose between 'Text Forward' and 'Screenshot (OCR)' modes. Screenshot mode compresses the image and runs Tesseract.js OCR inline with loading feedback, then fills an editable text area with the filtered output. Below that is the category grid of `CategoryBadge` cards with five options: 'Health & Medical', 'Political & Govt', 'Financial & Loans', 'Religious & Culture', and 'Other Topics'. The duplicate check runs when the text area loses focus. If it finds a match, an inline alert links to the existing claim and the submit button is disabled.

#figure(
  image("attachments/wireframe_submit.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Submit Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-submit>

*VerifyQueue (`/verify`, protected).* A scrollable feed of `ClaimCard` components shows each claim's text excerpt, category badge, timestamp, and verification progress on a three-segment `ConsensusStepper`. Cards also carry a deadline countdown, a priority badge for admin-flagged claims, and an indicator when an image is attached. Admin-flagged claims sit at the top of the feed, which also has category filters and search.

#figure(
  image("attachments/wireframe_verify_queue.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Verify Queue],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-queue>

*VerifyDetail (`/verify/:claimId`, protected).* The workbench shows the claim text or screenshot above a verification progress indicator. Review is blind: verifiers cannot see other verdicts before submitting their own, which guards against anchoring and bandwagon effects. The form has a `VerdictPill` selector (without the system-assigned `CONTESTED` option), a source URL input whose domain quality `SourceQualityDot` classifies as the user types, and an explanation field checked by `validateVerdictExplanation()`.

#figure(
  image("attachments/wireframe_verify_detail.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Verify Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-detail>

*ClaimDetail (`/claim/:claimId`, public).* This public page shows the claim text, any image evidence, the resolved verdict pill, the confidence score with a breakdown of its components, and the contributing verifications with citation links. An export button generates a 1080px-wide PNG fact-check card via `html-to-image` (a 540px layout rendered at `pixelRatio: 2`).

#figure(
  image("attachments/wireframe_claim_detail.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Claim Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-claim-detail>

*Dashboard (`/dashboard`, public).* Recharts charts show category distribution and verdict proportions, alongside a 7-day rolling trend list and verifier leaderboards, all with custom tooltips.

#figure(
  image("attachments/wireframe_dashboard.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Dashboard],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-dashboard>

*Profile (`/profile`, protected).* The profile page shows account details, the user's reputation score and tier (Novice, Trusted, Expert, or Elite), their submission and verification history, and profile preferences.

#figure(
  image("attachments/wireframe_profile.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Profile],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-profile>

*Admin (`/admin`, admin-guarded).* The console is an unlisted route that does not appear in public navigation. `AdminRoute.tsx` requires admin authentication before showing its five tabs:
- System Overview: platform KPI metrics, category bar charts, verdict distributions, and reputation tier distributions.
- Verifier Directory: a searchable table of `User` records with controls to adjust reputation, toggle admin status, and remove accounts.
- Claims Moderation: lets administrators inspect claims, toggle expedited-review flags, edit categories or text, override verdicts, and delete records.
- Incident Queue: manages `ModerationReport` tickets, with filters for status and severity.
- Audit and Tools: a real-time viewer for `AdminAuditLog` records, a manual trigger for the consensus-expiry sweep, a broadcast notification tool, and JSON database export.

Every mutating admin operation goes through the shared `addAuditLog()` utility.

#figure(
  image("attachments/wireframe_admin.png", width: 100%, height: 90%, fit: "contain"),
  caption: [Wireframe — Admin Console],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-admin>

== Security issues

FactStamp uses defense in depth. Client-side controls give immediate feedback and stop casual invalid input, and server-side `firestore.rules` enforce constraints on every database write that a client cannot get around.

*Dual-layer admin authentication.* Access to `/admin` requires two independent checks: a `sessionStorage` unlock flag (`fs_admin_session_unlocked`) set when the admin submits credentials, and a live Firestore authorization check on every render. `AdminRoute.tsx` confirms that `user?.isAdmin === true` on the active profile snapshot. If the session flag is present but the user document has no admin privileges, the client clears the flag and redirects to the login screen. Setting `fs_admin_session_unlocked` by hand in browser storage therefore gets an attacker nothing, because the route also requires `isAdmin` to be true on the live Firestore profile.

*Login rate limiting.* `checkLoginRateLimit()`, `recordFailedLogin()`, and `resetLoginAttempts()` defend sign-in against brute-force attacks. `SignIn.tsx` keys its attempt counters by email, while `AdminRoute.tsx` uses a single client-wide counter. After `MAX_LOGIN_ATTEMPTS = 5` failed attempts for one identifier, that identifier is locked out for 15 minutes (`LOCKOUT_DURATION_MS = 15 times 60 times 1000` ms). A global counter runs alongside the per-identifier ones, and 10 failed attempts in total trigger a client-wide lockout. The counters persist in both `localStorage` and `sessionStorage`, and a successful login clears them all. `formatLockoutRemaining()` displays the remaining lockout time as `MM:SS`.

*Idle session timeout.* `recordActivity()` and `isSessionExpired()` enforce a 30-minute idle timeout (`SESSION_TIMEOUT_MS = 30 times 60 times 1000` ms). Each user interaction writes a timestamp to `sessionStorage`. Once inactivity passes the threshold, the session expires and the user must sign in again, which limits the risk from an unattended browser tab. On logout, `clearSecuritySession()` removes both the timestamp and the admin session flag.

*Triple-layer file upload validation.* `validateImageUpload()` checks the file size first and then verifies the file type three separate ways:
+ Size: files may not exceed 5 MB (`MAX_UPLOAD_SIZE_BYTES = 5 times 1024 times 1024`), and empty files are rejected.
+ Extension whitelist: only `.jpg`, `.jpeg`, `.png`, `.webp`, and `.gif` are accepted.
+ MIME type whitelist: the declared content type must be `image/jpeg`, `image/png`, `image/webp`, or `image/gif`.
+ Magic-byte signature: the first 12 bytes of the file must match a known image signature (JPEG `FF D8 FF`, PNG `89 50 4E 47`, GIF `47 49 46 38`, or WebP RIFF `52 49 46 46`). Renaming a file fakes its extension and editing request headers fakes its MIME type, but neither changes the leading bytes, so this check stops non-image payloads from being processed.

*Verdict-explanation anti-spam validation.* `validateVerdictExplanation()` applies eight filters: a minimum of 50 characters; a maximum of 1500 characters (the server allows up to 3000); a minimum of 8 words; detection of repeated characters (6 or more identical in a row); detection of repeated words (3 identical in a row); a blacklist of cop-out phrases (`just trust me`, `trust me bro`, `check it yourself`, `search it on google`, `search google`, `idk`, `i don't know`, `random text to fill space`, `asdfasdf`, `qwertyuiop`); rejection of explanations that copy 30 or more characters of the claim text; and prompts that steer the verifier toward a constructive explanation.

*XSS input sanitization.* `sanitizeTextInput()` strips dangerous HTML elements (`script`, `iframe`, `object`, `embed`, `form`, `link`, `meta`, `style`, `svg`, `math`, `base`, `applet`), event-handler and related attributes (`on*`, `srcdoc`, `formaction`, `xlink:href`), dangerous URI schemes (`javascript:`, `vbscript:`, `data:`), and null bytes. This runs on top of React's automatic JSX encoding.

*Server-side rule enforcement.* `firestore.rules` validates data independently of the client code. Client-side checks make the interface responsive, but only the server rules protect against direct API calls. The 50 to 3000 character bound on `explanation` caps its size, regular expressions validate `sourceUrl`, the append-only verification logic allows exactly one new entry per write, `verifierId` and `verifierReputation` are checked against the caller's live profile, and the `imageUrl` size cap limits stored payloads. `isAdmin()` checks on the server block any administrative change from a non-admin.

== Test cases design

The test cases below cover the functional pipeline (registration #sym.arrow.r submission #sym.arrow.r duplicate detection #sym.arrow.r verification #sym.arrow.r consensus) and the security paths (rate-limited authentication, administrative access control) described in Sections 4.2, 4.4, and 4.5. Each expected result traces back to an enforced rule. Chapters 5 and 6 contain the full execution logs and observed outcomes.

#styled-table(
  columns: (0.55fr, 0.85fr, 1.5fr, 1.5fr, 1.9fr),
  headers: ("Test ID", "Module", "Test Condition", "Input", "Expected Result"),
  "TC-01", "Auth (M1)", "New user registers with valid credentials", "Valid email, 8+ char password with 1 uppercase and 1 digit, display name", [Account created; `users/{uid}` seeded with `reputation: 50`, `totalVerifications: 0`, `isAdmin: false`],
  "TC-02", "Auth (M1)", "User logs in with valid credentials", "Correct email + password", [Session established; login-attempt counter reset via `resetLoginAttempts()`],
  "TC-03", "Auth (M1)", "User logs in with invalid credentials", "Incorrect password, valid email", [Login rejected; `recordFailedLogin()` increments the attempt counter],
  "TC-04", "Auth / Security (M1, M8)", "User exceeds login attempt limit", "5 consecutive failed attempts, same identifier", [6th attempt blocked; `isLockedOut: true`; UI shows MM:SS countdown],
  "TC-05", "Ingestion (M2)", "User submits a claim as plain text", "Text, 20 to 500 chars (the Submit.tsx bound, inside the server rule's 10 to 2000 range), valid category", [Claim created: `status: pending`, `verificationCount: 0`, `consensusDeadline` = now + 7 days],
  "TC-06", "Ingestion / OCR (M2)", "User submits via WhatsApp screenshot", "Valid JPEG/PNG, at most 5 MB", [Image compressed, OCR-extracted; WhatsApp chrome stripped; text shown for review],
  "TC-07", "Duplicate Detection (M3)", "New submission closely matches an existing claim", [Text with similarity of 0.75 or higher], "Submission blocked; inline warning links to the existing claim; no new document created",
  "TC-08", "Duplicate Detection (M3)", "New submission is sufficiently distinct", [Text with best similarity below 0.75], "New document created; claim enters the Verification Queue",
  "TC-09", "Verification Queue (M4)", "Verifier submits a verdict below quorum", "1st/2nd verification, valid fields", [`verificationCount` +1; `status` remains `pending`],
  "TC-10", "Verification Queue (M4)", "Explanation fails anti-spam validation", [Explanation under 50 chars, or repeated-char spam, or a copy of the claim text], [`validateVerdictExplanation()` rejects client-side; no write attempted],
  "TC-11", "Queue / Consensus (M4, M5)", "Verification reaches exactly quorum", "3rd verification submitted", [`calculateConfidenceScore()` invoked; verdict/confidence set; `status` #sym.arrow.r `verified`],
  "TC-12", "Consensus Engine (M5)", "Claim remains under quorum past deadline", [`verificationCount < 3`, `consensusDeadline` elapsed], [Expiry sweep force-settles `verdict = CONTESTED`, `status = verified`],
  "TC-13", "Admin Console (M8)", "Admin overrides a claim's verdict", "Admin session; claim ID; new verdict", [Claim updated via Case A rule; action recorded in `audit_logs`],
  "TC-14", "Security / Admin Access", [Unauthorized `/admin` access attempt], [No valid admin session, or forged session flag with `isAdmin != true`], [Login gate shown; forged flag discarded; access denied],
  "TC-15", "Data Integrity", "Client attempts to forge a verification's reputation", [Direct SDK write with inflated `verifierReputation`], [Write rejected: value must match caller's live `users/{uid}.reputation`],
  "TC-16", "File Upload Validation (M2, M8)", "User uploads a disguised non-image file", [A renamed file with a spoofed `image/png` MIME type], [Magic-byte check fails; upload rejected],
)
