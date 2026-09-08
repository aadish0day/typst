#import "../lib/helpers.typ": *

= System Design

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

FactStamp's system design translates the requirements and conceptual models of Chapter 3 into a concrete, source-grounded architecture: eight functional modules, a Firestore document schema with server-enforced integrity constraints, the two core algorithms (Jaccard duplicate detection and weighted consensus scoring) that drive the platform's central value proposition, a fully custom user-interface layer, a defense-in-depth security architecture, and a formal test-case design. Every fact in this chapter is grounded in the real, deployed FactStamp codebase (`/home/aadish/Documents/Github/FactStamp`) rather than an idealized or hypothetical design.

== Basic Modules

FactStamp is decomposed into *8 core system modules*, each traceable to real source files. Chapter 3.5 (Preliminary Product Description) introduced these modules at a summary level; this section documents each module's internal responsibilities, key functions, and how the modules call into one another across the end-to-end claim lifecycle (submission #sym.arrow.r duplicate check #sym.arrow.r verification queue #sym.arrow.r consensus #sym.arrow.r shareable card #sym.arrow.r analytics), with Module 8 (Security & Notifications) cutting across all of the above.

*Module 1 --- Authentication & Verifier Reputation.* Core files: `src/contexts/AuthContext.tsx`, `src/pages/SignIn.tsx`, `src/pages/SignUp.tsx`, `src/services/firebaseService.ts`. `AuthContext.tsx` wraps the Firebase Auth SDK in a React Context so every screen can read the current session and call `signIn`, `signUp`, `signInWithGoogle`, `signOut`, and `updateUser`. Registration supports both email/password and Google OAuth. On first sign-up, `firebaseService.ts` creates a `users/{uid}` Firestore document seeded with `reputation: 50` (the midpoint of the 0--100 scale), `totalVerifications: 0`, and `isAdmin: false` --- enforced server-side too, since `firestore.rules` only allows a self-created profile with exactly these seed values. Every other module depends on Module 1: Module 2 needs an authenticated `uid` to attach to a claim as `submittedBy`; Module 4 needs one to attach a verification as `verifierId`; Module 5 reads each verifier's *current* reputation directly out of their profile at the moment they vote.

*Module 2 --- Forward Submission / Ingestion & OCR.* Core files: `src/pages/Submit.tsx`, `src/services/ocrService.ts`, `src/lib/imageCompression.ts`. Accepts a claim as raw pasted text or an uploaded WhatsApp forward screenshot. A screenshot passes through client-side compression (`imageCompression.ts`) and then Tesseract.js WebAssembly OCR (`ocrService.ts`, `createWorker`) entirely in-browser --- no image ever leaves the client. Raw OCR output is passed through `cleanExtractedOcrText()`, which strips WhatsApp chat chrome (timestamps, delivery checkmarks, carrier/battery status text). The user always reviews and can correct the cleaned text before submission. Once confirmed, `Submit.tsx` calls directly into *Module 3* before any `claims/{claimId}` document is created.

*Module 3 --- Duplicate Detection Engine.* Core file: `src/lib/duplicateDetection.ts`. Implements token-level Jaccard word-overlap similarity: the incoming and every existing claim's text are normalized and tokenized (words $> 3$ characters only), and $J(A,B) = |S_A inter S_B| \/ |S_A union S_B|$ is computed against each existing claim. A best match at or above the $0.75$ threshold blocks the submission and raises an inline duplicate warning linking to the existing claim instead of creating a duplicate (full algorithm in §4.3.3). Only a claim that clears no existing match proceeds to create a new `pending` document and enters Module 4's queue.

*Module 4 --- Verification Queue.* Core files: `src/pages/VerifyQueue.tsx`, `src/pages/VerifyDetail.tsx`, `src/contexts/ClaimsContext.tsx`. `VerifyQueue.tsx` lists every `pending` claim (admin-flagged claims surfaced first). `VerifyDetail.tsx` is the verifier's workbench: a verdict selection (`TRUE`/`FALSE`/`MISLEADING`/`UNVERIFIABLE` --- never `CONTESTED`, which is system-assigned only), a source URL whose domain is auto-classified into a source-quality rating by `determineSourceQuality()`, and a written explanation, gated by `validateVerdictExplanation()` in `src/lib/security.ts` (minimum 50 characters / 8 words, anti-spam checks --- full detail in §4.5). A valid submission appends to the claim's embedded `verifications[]` array and increments `verificationCount` by exactly 1, independently re-validated by `firestore.rules` (§4.2.2). *The moment `verifications.length` reaches 3, `ClaimsContext.tsx` calls directly into Module 5* to compute the final verdict and confidence score in the same write.

*Module 5 --- Weighted Consensus & Confidence Engine.* Core file: `src/lib/confidenceScore.ts`. `calculateConfidenceScore()` computes the majority verdict's agreement ratio, the mean verifier reputation, and the mean source-quality score across the claim's verifications, then combines them:

$ C = (A times 0.40) + (R times 0.30) + (S times 0.30) $

Module 5 also owns *consensus expiry*: a periodic sweep finds any `pending` claim whose 7-day `consensusDeadline` has passed with `verificationCount < 3`, computes a confidence score from whatever verifications exist, and force-settles the verdict to `CONTESTED` --- the only path that produces this verdict, ensuring no claim sits in the queue indefinitely. Once `status` flips to `verified`, Module 5 triggers Module 8 to notify the submitter, and the claim becomes eligible for Module 6.

*Module 6 --- Fact-Check Card Generator.* Core files: `src/components/FactCheckCard.tsx`, `src/pages/ClaimDetail.tsx`. Once a claim carries a final verdict and confidence score, `ClaimDetail.tsx` renders a styled DOM card that `html-to-image` rasterizes client-side into a 1080px-wide PNG --- the card is laid out at a 540px CSS width and captured at `pixelRatio: 2`, so its height is not fixed but grows with the claim text length and the number of cited sources --- via the browser's native SVG `foreignObject` path --- chosen because a legacy canvas parser could not interpret the `oklch()`/`oklab()` colors used throughout the design tokens. The user downloads and forwards the PNG back into the originating WhatsApp chat. This module is a pure consumer of Module 5's output.

*Module 7 --- Misinformation Analytics Dashboard.* Core files: `src/pages/Dashboard.tsx`, `src/components/DashboardChart.tsx`, `src/lib/weeklyReport.ts`. Deliberately a *public* route (§4.4) so platform transparency is not gated behind login. `weeklyReport.ts` computes a rolling 7-day window: category distribution, verdict distribution, and a "most-debunked" trending list, rendered as Recharts visualizations with custom tooltips. Reads exclusively from claims Module 5 has already finalized (plus live `pending` counts for queue-size metrics); performs no writes.

*Module 8 --- System Security & Notifications.* Core files: `src/lib/security.ts`, `src/contexts/NotificationsContext.tsx`, `src/components/NotificationBell.tsx`, `firestore.rules`. The cross-cutting layer every other module calls into. `security.ts` supplies XSS sanitization, explanation anti-spam validation, upload validation, idle-session timeout, and login rate-limiting (full detail in §4.5). `NotificationsContext.tsx` and `NotificationBell.tsx` provide real-time in-app alerts that Module 5 fires into on claim resolution. `firestore.rules` is the server-side backstop for every client-side check in this module (§4.2.2, §4.5).

#v(6pt)
#align(center)[*Table 4.1.1 --- Cross-Module Interaction Summary*]
#styled-table(
  columns: (1.6fr, 0.85fr, 0.85fr, 1.9fr),
  headers: ("Trigger", "Calling Module", "Called Module", "Effect"),
  "User submits claim text/screenshot", "2", "3", "Jaccard check against existing claims before a new document is created",
  [$max J(A,B) >= 0.75$ against an existing claim], "3", "2", "Submission blocked; user offered a direct link to the existing claim page",
  "Verifier submits a verdict", "4", "8", [`validateVerdictExplanation()` gates acceptance before the Firestore write],
  [`verifications.length` reaches 3], "4", "5", [`calculateConfidenceScore()` computes final verdict; status #sym.arrow.r `verified`],
  [`consensusDeadline` passes with count $< 3$], "5", "4", "Claim force-settled with verdict CONTESTED",
  "Claim reaches verified status", "5", "8", "Submitter notified; verifier reputation updated",
  "Claim reaches verified status", "5", "6", "Claim becomes eligible for PNG card export",
  [Every write to `users`, `claims`, `notifications`, `reports`, `audit_logs`], "1, 2, 4, 5", "8", [Server-side field-level validation independent of client checks],
)

== Data Design

FactStamp uses *Cloud Firestore*, a NoSQL document-oriented database, as its sole persistence layer --- there is no separate relational database or custom REST API. Five top-level collections hold all application state: `users`, `claims`, `notifications`, `reports`, and `audit_logs`. Every collection's shape is defined once in `src/lib/types.ts` and independently re-validated on every write by `firestore.rules`, so the schema below is mechanically enforced server-side, not merely a design intention.

=== Schema Design

#align(center)[*Table 4.2.1(a) --- `users` Collection*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`uid`], "string", "Firebase Auth user ID (document ID)", "Immutable after creation",
  [`displayName`], "string", "Verifier's display name", "Max 100 characters",
  [`email`], "string", "Account email address", [Must match `request.auth.token.email`; immutable],
  [`avatarUrl`], "string?", "Profile picture URL", "Optional",
  [`reputation`], "number", "Verifier reputation score, 0--100", "Defaults to 50 at signup; admin-writable only thereafter",
  [`totalVerifications`], "number", "Lifetime verifications submitted", "Defaults to 0; admin-writable only",
  [`joinedAt`], "string (ISO 8601)", "Account creation timestamp", "Immutable",
  [`isAdmin`], "boolean?", "Staff clearance flag", "Defaults to false; only an existing admin can flip it",
)

#v(4pt)
#align(center)[*Table 4.2.1(b) --- `claims` Collection*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Claim document ID", "Firestore auto-ID",
  [`text`], "string", "Normalized claim text", "10--2000 characters, server-enforced",
  [`category`], "enum", [`health` \| `political` \| `religious` \| `financial` \| `other`], "Fixed whitelist",
  [`status`], "enum", [`pending` \| `verified`], [`verified` covers quorum and CONTESTED outcomes],
  [`createdAt`], "string (ISO)", "Submission timestamp", "Immutable",
  [`verifiedAt`], "string?", "Final-verdict timestamp", "Set once, on resolution",
  [`consensusDeadline`], "string (ISO)", "`createdAt` + 7 days", "Immutable; drives expiry sweep",
  [`submittedBy`], "string", "Submitter `uid`", "Immutable",
  [`submittedByName`], "string", "Display-name snapshot", "Max 100 chars; immutable",
  [`imageUrl`], "string?", "Base64 data URI or HTTPS URL", [$<=$ 800,000 chars (~800 KB); pattern-matched],
  [`verdict`], "enum?", [TRUE \| FALSE \| MISLEADING \| UNVERIFIABLE \| CONTESTED], "Set only once resolved",
  [`confidenceScore`], "number?", "Final weighted confidence, 0--100", "Computed by Module 5",
  [`verifications`], [array of Verification], "Embedded verification records", "Starts as empty array",
  [`verificationCount`], "number", "`verifications.length`, denormalized", "Must be 0 at creation; increments by exactly 1 per write",
  [`agreementRatio`], "number?", "Agreement-ratio component", "Denormalized",
  [`avgVerifierReputation`], "number?", "Avg. reputation component", "Denormalized",
  [`sourceQualityScore`], "number?", "Avg. source-quality component", "Denormalized",
  [`adminFlagged`], "boolean?", "Expedited-review flag", "Admin-writable only",
  [`adminFlaggedAt`], "string?", "Flag timestamp", "Admin-writable only",
)

#v(4pt)
#align(center)[*Table 4.2.1(c) --- Embedded `Verification` Sub-schema (element of `claims.verifications[]`)*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Verification identifier", "Client-generated",
  [`claimId`], "string", "Parent claim ID", "Redundant convenience field",
  [`verdict`], "enum", [TRUE \| FALSE \| MISLEADING \| UNVERIFIABLE], "CONTESTED is system-assigned only",
  [`sourceUrl`], "string", "Cited source URL", [Max 500 chars; matches `^https?://.+`],
  [`sourceQuality`], "enum", [`high` \| `medium` \| `low`], "Derived from domain whitelist",
  [`explanation`], "string", "Verifier's written rationale", "50--1500 chars client-side; 50--3000 server-side",
  [`verifierId`], "string", "Voting verifier's `uid`", "Must equal `request.auth.uid`",
  [`verifierName`], "string", "Verifier display-name snapshot", "Max 100 characters",
  [`verifierReputation`], "number", "Reputation at moment of voting", "Must equal the live `users/{uid}.reputation` value",
  [`createdAt`], "string (ISO)", "Verification timestamp", "Immutable",
)

#v(4pt)
#align(center)[*Table 4.2.1(d) --- `notifications` Collection*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Notification document ID", "Firestore auto-ID",
  [`userId`], "string", "Recipient's `uid`", "Immutable; scoped read access",
  [`type`], "enum", [`claim_verified` \| `reputation_update` \| `weekly_report` \| `verdict_submitted`], "Immutable after creation",
  [`title`], "string", "Short heading", "Max 200 characters",
  [`message`], "string", "Notification body", "Max 2000 characters",
  [`createdAt`], "string (ISO)", "Creation timestamp", "Immutable",
  [`isRead`], "boolean", "Read/unread state", "Only field a recipient may self-update",
  [`claimId`], "string?", "Related claim, if applicable", "Immutable",
)

#v(4pt)
#align(center)[*Table 4.2.1(e) --- `reports` Collection (Moderation Incident Tickets)*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Report document ID", "Firestore auto-ID",
  [`targetType`], "enum", [`claim` \| `user` \| `verification`], "Fixed whitelist",
  [`targetId`], "string", "ID of the reported entity", "--",
  [`targetTitle`], "string", "Human-readable target label", "Max 300 characters",
  [`reason`], "enum", "misinformation_spam / harassment / low_quality_source / fake_account / manipulation / hate_speech / other", "Fixed whitelist",
  [`details`], "string?", "Reporter's free-text description", "Optional in the TS interface; required by the create rule; max 3000 characters",
  [`reportedBy`], "string", "Reporter's `uid`", "Must equal `request.auth.uid`",
  [`reportedByName`], "string", "Reporter display-name snapshot", "--",
  [`reportedAt`], "string (ISO)", "Submission timestamp", "--",
  [`status`], "enum", [`pending` \| `investigating` \| `resolved` \| `dismissed`], "Must be `pending` at creation",
  [`severity`], "enum", [`low` \| `medium` \| `high`], "Fixed whitelist",
  [`actionTaken`], "string?", "Admin's resolution note", "Admin-writable only",
  [`resolvedAt`], "string?", "Resolution timestamp", "Admin-writable only",
  [`resolvedBy`], "string?", "Resolving admin's `uid`", "Admin-writable only",
)

#v(4pt)
#align(center)[*Table 4.2.1(f) --- `audit_logs` Collection (Immutable)*]
#styled-table(
  columns: (1fr, 0.85fr, 1.9fr, 1.5fr),
  headers: ("Field", "Type", "Description", "Notes"),
  [`id`], "string", "Log entry ID", "Firestore auto-ID",
  [`timestamp`], "string (ISO)", "When the admin action occurred", "--",
  [`adminId`], "string", "Acting admin's `uid`", "--",
  [`adminName`], "string", "Admin display-name snapshot", "--",
  [`action`], "string", "Description of the action taken", "Max 200 characters",
  [`targetType`], "enum", [`claim` \| `user` \| `report` \| `system`], "Fixed whitelist",
  [`targetId`], "string", "ID of the entity acted upon", "--",
  [`details`], "string", "Additional context", "Max 2000 characters",
)

=== Data Integrity and Constraints

Every constraint above is a design intention until it is enforced somewhere the client cannot bypass. FactStamp enforces the entire schema server-side via `firestore.rules`, evaluated on every Firestore write attempt --- a malicious or buggy client can send whatever payload it likes, but Firestore rejects any write that fails the matching rule.

*Field-level write validation.* Every create/update rule inspects `request.resource.data` field-by-field rather than trusting the document as a whole. Creating a `claims/{claimId}` document requires `text.size()` between 10 and 2000, `category` against the fixed enum, `status == "pending"`, `verificationCount == 0`, and `verifications == []` --- a client cannot create a claim that is already verified, pre-seeded with fake verifications, or outside the text-length bounds.

*The `isAdmin()` helper.* Nearly every privileged write path gates on a single helper that performs a *live server-side read* of the caller's own `users/{uid}` document at write time:

```
function isAdmin() {
  return request.auth != null
    && get(/databases/$(database)/documents/users/$(request.auth.uid))
         .data.get('isAdmin', false) == true;
}
```

Because `isAdmin` on a `users/{uid}` document can only be changed by an existing admin (the self-update branch requires the field stay unchanged), there is no path by which a normal user can grant themselves admin privileges, even by calling the Firestore SDK directly from a browser console.

*Append-exactly-one-verification-per-write.* The most intricate rule governs adding a verification to a claim. It requires, simultaneously: `verificationCount` increases by exactly 1; the existing `verifications` array is fully preserved (`hasAll`); the newly appended element's `verifierId` equals the caller's own `uid`; that element's `verifierReputation` exactly matches the caller's *live* reputation value read at write time (preventing a client from inflating its own reported reputation to skew the consensus formula); the verdict is restricted to `TRUE`/`FALSE`/`MISLEADING`/`UNVERIFIABLE` (never `CONTESTED`); and `sourceUrl`/`explanation` satisfy their format and length bounds. This rule is the server-side mirror of Module 4's client-side `validateVerdictExplanation()` check (§4.5) --- the client check exists for immediate UX feedback, but this rule is what actually prevents a forged or malformed verification from ever being persisted.

*Immutability rules.* Several fields are permanently frozen once a claim is created, enforced via `isUnchanged()`/`identityUnchanged()` helpers: `text`, `category`, `submittedBy`, `submittedByName`, `createdAt`, `consensusDeadline`, and `imageUrl` cannot be altered by the "add a verification" or "consensus expiry" update paths --- only an admin override may touch them. `audit_logs` documents disallow `update` and `delete` entirely: an audit trail that could itself be edited or erased after the fact would defeat its own purpose.

*Why `verifications[]` is an embedded array, not a subcollection --- and the trade-off.* (`firestore.rules` does still declare a `claims/{claimId}/verdicts/{verdictId}` subcollection, a residue of an earlier design iteration, but no application code reads from or writes to it; every verification in the running system lives in the embedded array.) This choice was made because (1) *atomic quorum checks* --- Module 5's decision to finalize a verdict the instant the third verification arrives depends on reading `verifications.length` synchronously in the same document snapshot as the write that adds it; a subcollection would require a separate aggregation read or a denormalized counter kept in sync across two writes, introducing a race window a quorum-triggering computation cannot tolerate; and (2) *single-read hydration* --- every screen that displays a claim needs the full verification list alongside claim metadata, avoiding an extra subcollection query per view. The trade-off is real: Firestore documents are capped at 1 MiB, and an embedded array grows unbounded with the number of verifications a claim receives. In practice this is a non-issue for FactStamp's use case --- the 3-verifier quorum settles most claims quickly, and each `Verification` element is bounded by the 3000-character explanation cap, staying orders of magnitude under the 1 MiB ceiling. A subcollection would become necessary only if the project later supported an unbounded, post-consensus commentary stream, which it deliberately does not.

*The 800 KB image-URI cap.* A submitted screenshot is stored as a base64 data URI directly inside `claims/{claimId}.imageUrl` (no Firebase Storage bucket is used). Base64 encoding inflates binary size by roughly 33%, and the field must leave headroom under Firestore's 1 MiB document cap alongside the embedded `verifications[]` array, so `firestore.rules` enforces `imageUrl.size() <= 800000` characters on top of client-side compression that downsizes the image before it is ever encoded (max dimension 1280 px, JPEG quality stepped down from 0.72 to a floor of 0.4 until the payload is under ~700,000 bytes). A `storage.rules` file is nevertheless deployed alongside the Firestore ruleset, permitting authenticated image uploads under 10 MB to `claim_screenshots/{fileName}` with public read; no application code path currently uses it, so it is a locked-down placeholder rather than part of the live image flow.

*Client cannot be fully trusted --- the general principle.* Every client-side check documented in §4.5 exists purely for responsiveness and user experience; none of them is the actual security boundary. A user with browser DevTools open can call the Firestore SDK directly and bypass every client-side check trivially. `firestore.rules` therefore duplicates every constraint that matters for data integrity --- enum whitelists, length bounds, ownership checks, quorum-increment arithmetic, immutability locks, the admin gate --- at the rules layer, because that is the one layer the client genuinely cannot circumvent.

== Procedural Design

=== Logic Diagrams

The primary control-flow logic in FactStamp is the claim lifecycle: submission #sym.arrow.r duplicate check #sym.arrow.r verification queue #sym.arrow.r consensus. A logic/flow diagram of this pipeline would show: (1) the user submits a claim as typed text or an uploaded screenshot; (2) if a screenshot, the flow branches through compression #sym.arrow.r OCR extraction #sym.arrow.r WhatsApp-chrome cleanup #sym.arrow.r user review, before rejoining the text path; (3) the candidate text is normalized and tokenized; (4) it is Jaccard-compared against every existing claim; (5) a decision node asks whether $max J(A,B) >= 0.75$ --- *yes* blocks the submission and offers an inline link to the existing claim, ending the flow, *no* creates a new `pending` document with a 7-day `consensusDeadline`; (6) the claim enters the Verification Queue, where independent verifiers each contribute a verdict, a source URL (whose domain is auto-classified for source quality), and an explanation; (7) a decision node asks whether `verifications.length` $>= 3$ --- *yes* triggers the Consensus Engine to compute the final verdict and confidence score and flips status to `verified`; *no* the claim remains `pending`, looping back to step 6 unless the parallel deadline sweep (8) fires first; (8) independently, a periodic sweep force-settles any claim whose 7-day deadline has passed under quorum, with verdict `CONTESTED`; (9) a verified claim notifies its submitter and becomes eligible for card generation and dashboard aggregation.

#diagram-placeholder[Claim submission #sym.arrow.r duplicate check #sym.arrow.r verification queue #sym.arrow.r consensus flow diagram --- to be produced per `Rules/Diagram-rules.md` Rule 2 (Graphviz, `rankdir=TB`) as `attachments/claim_lifecycle_flow.dot` #sym.arrow.r `.svg`]

=== Data Structures

The system's core data structures are declared once, in `src/lib/types.ts`, and shared across every module in §4.1 --- there is no duplicate type definition elsewhere in the codebase.

```typescript
export type Verdict = 'TRUE' | 'FALSE' | 'MISLEADING' | 'UNVERIFIABLE' | 'CONTESTED'
export type ClaimStatus = 'pending' | 'verified'
export type ClaimCategory = 'health' | 'political' | 'religious' | 'financial' | 'other'
export type SourceQuality = 'high' | 'medium' | 'low'

export interface User {
  uid: string
  displayName: string
  email: string
  avatarUrl?: string
  reputation: number
  totalVerifications: number
  joinedAt: string
  isAdmin?: boolean
}

export interface Claim {
  id: string
  text: string
  category: ClaimCategory
  status: ClaimStatus
  createdAt: string
  verifiedAt?: string
  consensusDeadline: string
  submittedBy: string
  submittedByName: string
  imageUrl?: string
  verdict?: Verdict
  confidenceScore?: number
  verifications: Verification[]
  verificationCount: number
  agreementRatio?: number
  avgVerifierReputation?: number
  sourceQualityScore?: number
  adminFlagged?: boolean
  adminFlaggedAt?: string
}

export interface Verification {
  id: string
  claimId: string
  verdict: Verdict
  sourceUrl: string
  sourceQuality: SourceQuality
  explanation: string
  verifierId: string
  verifierName: string
  verifierReputation: number
  createdAt: string
}

export type NotificationType =
  | 'claim_verified' | 'reputation_update' | 'weekly_report' | 'verdict_submitted'

export interface AppNotification {
  id: string
  userId: string
  type: NotificationType
  title: string
  message: string
  createdAt: string
  isRead: boolean
  claimId?: string
}

export type ReportTargetType = 'claim' | 'user' | 'verification'
export type ReportReason =
  | 'misinformation_spam' | 'harassment' | 'low_quality_source'
  | 'fake_account' | 'manipulation' | 'hate_speech' | 'other'
export type ReportStatus = 'pending' | 'investigating' | 'resolved' | 'dismissed'
export type ReportSeverity = 'low' | 'medium' | 'high'

export interface ModerationReport {
  id: string
  targetType: ReportTargetType
  targetId: string
  targetTitle: string
  reason: ReportReason
  details?: string
  reportedBy: string
  reportedByName: string
  reportedAt: string
  status: ReportStatus
  severity: ReportSeverity
  actionTaken?: string
  resolvedAt?: string
  resolvedBy?: string
}

export interface AdminAuditLog {
  id: string
  timestamp: string
  adminId: string
  adminName: string
  action: string
  targetType: 'claim' | 'user' | 'report' | 'system'
  targetId: string
  details: string
}
```

`Verdict` includes `CONTESTED` as a full member of the enum even though no verifier can directly select it in `VerifyDetail.tsx`'s UI --- it is reachable only through the Module 5 consensus-expiry path, which is why the type system models it as something a claim can ultimately carry rather than restricting the verifier-facing form to a narrower sub-union. `Claim.verifications` is typed as a plain embedded array rather than a subcollection reference, the type-level expression of the architectural decision explained in §4.2.2. TypeScript's strict mode forces every module that reads an optional field (`?`) to explicitly handle the "not yet set" case --- which is what prevents, for example, a dashboard chart from crashing on a still-`pending` claim with no `confidenceScore` yet.

=== Algorithms Design

*Algorithm 1 --- Jaccard Duplicate Detection* (`src/lib/duplicateDetection.ts`). Purpose: decide whether an incoming claim is a near-duplicate of an already-submitted claim, so the same misinformation forward is never queued for verification twice under slightly different wording.

+ Normalize the input text $T$: lowercase, strip punctuation, collapse whitespace.
  $ "Norm"(T) = "collapseWhitespace"("stripPunctuation"("lowercase"(T))) $
+ Tokenize into a set of significant words, discarding tokens of length $<= 3$:
  $ S_T = { w in "split"("Norm"(T)) | |w| > 3 } $
+ For incoming claim $A$ and each existing claim $B$, compute:
  $ J(A, B) = frac(|S_A inter S_B|, |S_A union S_B|) $
+ Track the best match clearing the threshold $tau = 0.75$ (special cases: both sets empty #sym.arrow.r similarity $1$; exactly one empty #sym.arrow.r similarity $0$).
+ Decision rule:
  $ "Action" = cases(
    "Block submission, link to best-matching claim" & "if" max_(B in "Claims") J(A, B) >= tau,
    "Create new claim, enter Verification Queue" & "otherwise"
  ) $

```
function findDuplicate(text, existingClaims, threshold = 0.75):
    normalizedInput <- normalize(text)
    bestMatch <- null
    for each claim in existingClaims:
        similarity <- jaccardSimilarity(normalizedInput, claim.text)
        if similarity >= threshold and (bestMatch is null or similarity > bestMatch.similarity):
            bestMatch <- { id: claim.id, text: claim.text, similarity }
    return bestMatch   // null => no duplicate found
```

Complexity is $O(n dot m)$ where $n$ is the number of existing claims scanned and $m$ the average token-set size --- acceptable at FactStamp's target scale, though an inverted-index or MinHash/LSH structure would be needed to scale to a web-wide claim corpus (an explicitly acknowledged limitation).

*Algorithm 2 --- Weighted Consensus & Confidence Scoring* (`src/lib/confidenceScore.ts`). Purpose: once a claim has accumulated enough independent verifications, synthesize them into a single verdict and a numeric confidence score reflecting agreement, verifier trustworthiness, and source credibility.

+ Given verifications $V = {v_1, ..., v_N}$ (triggered once $N >= 3$), group by `verdict` and take the majority group's count $N_("majority")$.
+ Agreement Ratio:
  $ A = frac(N_("majority"), N_("total")) times 100 $
+ Average Verifier Reputation (each $R_i in [0,100]$, read live from `users/{uid}.reputation` at vote time):
  $ R = frac(1, N) sum_(i=1)^N R_i $
+ Average Source Quality Score (each verification's `sourceQuality` string mapped by `sourceQualityToScore()`: high #sym.arrow.r 100, medium #sym.arrow.r 70, low #sym.arrow.r 30, itself derived from `determineSourceQuality()`'s domain-whitelist classification):
  $ S = frac(1, N) sum_(i=1)^N Q(v_i) $
+ Combine into the final weighted confidence score:
  $ C = (A times 0.40) + (R times 0.30) + (S times 0.30) $
+ Clamp $C$ to $[0, 100]$ and round to the nearest integer.
+ Assign `verdict` = majority verdict, `confidenceScore = C`, `agreementRatio = A`, `avgVerifierReputation = R`, `sourceQualityScore = S`; flip `status` to `verified`.

```
function calculateConfidenceScore(verifications):
    if verifications.length == 0:
        return { score: 0, agreementRatio: 0, avgReputation: 0, sourceQualityScore: 0 }

    verdictCounts <- groupAndCount(verifications, by = verdict)
    majorityCount <- max(verdictCounts.values())
    agreementRatio <- (majorityCount / verifications.length) * 100

    avgReputation <- mean(v.verifierReputation for v in verifications)
    sourceQualityScore <- mean(v.sourceQuality for v in verifications)   // already numeric 0-100

    score <- round(agreementRatio * 0.40 + avgReputation * 0.30 + sourceQualityScore * 0.30)
    score <- clamp(score, 0, 100)

    return { score, agreementRatio, avgReputation, sourceQualityScore }
```

The consensus-expiry sweep (§4.1, Module 5) reuses this same function unmodified: a `pending` claim past its deadline with fewer than 3 verifications still has `calculateConfidenceScore()` invoked over whatever verifications exist, and the resulting verdict is overridden to `CONTESTED` regardless of the majority computed, since an under-quorum result is definitionally inconclusive.

== User Interface Design

FactStamp's frontend is a fully custom component system --- there is no third-party UI kit. Every interactive primitive (`Button`, `Input`, `Modal`, `Badge`, `CategoryBadge`, `VerdictPill`, `Avatar`, `SourceQualityDot`, `EmptyState`, `ErrorState`, `Skeletons`, `ThemeToggle`, `LoadingButton`, `PasswordStrength`, `ShimmerText`, `Marquee`, `FlowButton`, `InteractiveHoverButton`, `SpotlightCard`) lives in `src/components/ui/` and is styled with *Tailwind CSS v4*, using CSS custom properties rather than hard-coded utility colors so the app can flip between light and dark themes by swapping root-level values. *Framer Motion* drives the app's "tactile stamp" motion language (verdict badges mounting with a physical stamp-impact scale/rotation animation) and shared transitions across the Navbar, Footer, and Admin console. *Recharts* renders every chart in the Dashboard and Admin Overview tab, with custom tooltip components replacing default chrome. State is managed exclusively through *React Context* (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, `UsersContext`) --- no Redux or other external state library.

#align(center)[*Table 4.4.1 --- Routing Table*]
#styled-table(
  columns: (1fr, 1.1fr, 1fr, 1.9fr),
  headers: ("Route", "Component", "Guard", "Notes"),
  [`/`], [`Home.tsx`], "Public", "Landing page",
  [`/signin`], [`SignIn.tsx`], "Public", "Email/password + Google OAuth",
  [`/signup`], [`SignUp.tsx`], "Public", "Account registration",
  [`/submit`], [`Submit.tsx`], "Protected", "Requires authenticated session",
  [`/claim`, `/claims`], "--", "Public", [Redirects to `/verify`],
  [`/claim/:claimId`], [`ClaimDetail.tsx`], "Public", "Claim + fact-check card, viewable by anyone",
  [`/verify`], [`VerifyQueue.tsx`], "Protected", "Verification queue listing",
  [`/verify/:claimId`], [`VerifyDetail.tsx`], "Protected", "Verifier workbench for one claim",
  [`/dashboard`], [`Dashboard.tsx`], "Public (intentional)", [\"Public transparency, gated participation\"],
  [`/profile`], [`Profile.tsx`], "Protected", "User's own reputation/history",
  [`/admin`], [`Admin.tsx`], "Admin-guarded", "Unlisted route; dual-layer auth (§4.5)",
  [`*`], [`NotFound.tsx`], "Public", "404 fallback",
)

*Home (`/`).* A hero section explaining FactStamp's purpose with a call-to-action to submit or browse the queue, live platform statistics via `AnimatedCounter`, a "how it works" walkthrough, and a persistent Navbar exposing Sign In/Sign Up when logged out or avatar/`NotificationBell`/`ThemeToggle` when logged in.

#diagram-placeholder[Home screen wireframe --- pending]

*Submit (`/submit`, protected).* A toggle between "Paste Text" and "Upload Screenshot" modes. Screenshot mode triggers inline compression and Tesseract.js OCR with a loading state, populating an editable textarea with cleaned output. A category selector (`CategoryBadge`: Health, Political, Religious, Financial, Other) sits below. The Jaccard duplicate check runs when the claim textarea loses focus; a match raises an inline warning with a button linking to the existing claim and disables the Submit button, so no new claim can be created.

#diagram-placeholder[Submit screen wireframe --- pending]

*VerifyQueue (`/verify`, protected).* A scrollable list of `ClaimCard` components showing text excerpt, category badge, timestamp, and verification progress ("1 of 3"). Admin-flagged claims are visually distinguished and sorted to the top, with a category filter and search bar above the list.

#diagram-placeholder[VerifyQueue screen wireframe --- pending]

*VerifyDetail (`/verify/:claimId`, protected).* Full claim text/screenshot at top, followed by existing verifications (verdict, source, explanation, author reputation tier), then the current user's own verification form: a `VerdictPill` selector (Contested is never selectable, being system-assigned only), a source URL input with a `SourceQualityDot` domain-classification indicator, and an explanation textarea with a live counter validated against `validateVerdictExplanation()`.

#diagram-placeholder[VerifyDetail screen wireframe --- pending]

*ClaimDetail (`/claim/:claimId`, public).* Publicly viewable regardless of login state: claim text/screenshot, the final verdict as a large color-coded `VerdictPill` (or an under-review progress indicator if still `pending`), the confidence score with its three-component breakdown, contributing verifications with cited sources, and a "Download Fact-Check Card" button triggering the PNG export, 1080px wide (a 540px-wide card captured at 2#sym.times pixel ratio) with a content-dependent height.

#diagram-placeholder[ClaimDetail screen wireframe --- pending]

*Dashboard (`/dashboard`, public).* A grid of Recharts visualizations: category-distribution bar chart, verdict-distribution pie chart, rolling 7-day trending list, and a top-verifiers leaderboard, all with custom tooltips.

#diagram-placeholder[Dashboard screen wireframe --- pending]

*Profile (`/profile`, protected).* Account details, reputation score with a tier indicator (Novice/Trusted/Expert/Elite), a history of submitted claims and cast verifications, and account settings.

#diagram-placeholder[Profile screen wireframe --- pending]

*Admin (`/admin`, admin-guarded) --- 5 Tabs.* Reached only by typing the unlisted `/admin` URL directly; deliberately absent from the public Navbar/Footer. `AdminRoute.tsx` shows a login gate before any tab renders (§4.5). Once authenticated, exactly 5 tabs are exposed:
- *System Overview* --- KPI cards plus two Recharts visualizations (a claims-by-category bar chart and a verdict-consensus pie chart), together with a reputation-tier breakdown rendered as a plain counts grid rather than as a chart.
- *Verifier Directory* --- searchable table of `User` records; per-row edit reputation, toggle `isAdmin`, delete account.
- *Claims Moderation* --- searchable table of `Claim` records; per-row toggle `adminFlagged`, override verdict/confidence/status, edit text/category, inspect/delete verifications, hard-delete claim.
- *Incident Queue* --- `ModerationReport` tickets filterable by status/severity; create, resolve, dismiss.
- *Audit & Tools* --- immutable real-time `AdminAuditLog` viewer, plus force-run consensus expiry, broadcast notification, and export a full JSON database backup.

Every mutating action in any tab funnels through a shared `addAuditLog()` helper.

#diagram-placeholder[Admin console (5-tab) wireframe --- pending]

== Security Issues

FactStamp's security architecture follows a *defense-in-depth* model: every client-side hardening measure exists for immediate UX feedback and to raise the cost of casual abuse, but none of them is treated as the actual trust boundary --- that boundary is always the server-side `firestore.rules` evaluation, which runs independently of, and cannot be bypassed by, any client-side code path.

*Dual-layer admin authentication.* The `/admin` console is protected by two independent layers that must both pass: (1) a client-side `sessionStorage` flag (`fs_admin_session_unlocked`) set on successful login, purely for UX persistence; and (2) a *live Firestore role re-check on every render* --- `AdminRoute.tsx` computes `hasVerifiedAdminRole = user?.isAdmin === true` from the live, Firestore-backed session snapshot regardless of the flag. If the flag is present but the profile lacks `isAdmin`, the flag is discarded and the user is bounced back to the login gate. This second layer exists specifically to defeat a DevTools bypass of the form `sessionStorage.setItem('fs_admin_session_unlocked', 'true')` --- setting the flag alone grants nothing, since the render-time check re-derives admin status from the actual Firestore profile every time, and `isAdmin` can only be changed by an existing admin server-side.

*Login rate-limiting.* `checkLoginRateLimit()`, `recordFailedLogin()`, and `resetLoginAttempts()` implement brute-force protection used by both `/signin` and the `/admin` gate --- `SignIn.tsx` passes the entered email so counters are keyed per-identifier, while `AdminRoute.tsx` calls them without an identifier and so shares the client-wide `global` counter: *`MAX_LOGIN_ATTEMPTS = 5`* failed attempts against a given identifier triggers a *15-minute lockout* (`LOCKOUT_DURATION_MS = 15 times 60 times 1000` ms). Attempt counters are tracked per-identifier and mirrored into a global client-wide counter; if global failed attempts reach $5 times 2 = 10$, a separate global lockout also triggers. Counters persist in both `localStorage` and `sessionStorage`; a successful login resets both counters. `formatLockoutRemaining()` renders remaining lockout time as `MM:SS`.

*Idle session timeout.* `recordActivity()` and `isSessionExpired()` implement a *30-minute* idle timeout (`SESSION_TIMEOUT_MS = 30 times 60 times 1000` ms). Activity timestamps are stamped in `sessionStorage` on meaningful interactions; a session idle beyond the threshold is treated as expired, requiring re-authentication --- mitigating the risk of an unattended, still-logged-in browser tab. `clearSecuritySession()` clears both the activity timestamp and the admin session-unlock flag together on logout.

*Triple-layer file upload validation.* `validateImageUpload()` performs, in order: (1) *size ceiling* --- 5 MB maximum (`MAX_UPLOAD_SIZE_BYTES = 5 times 1024 times 1024`), zero-byte files rejected; (2) *extension whitelist* --- `.jpg`, `.jpeg`, `.png`, `.webp`, `.gif`; (3) *MIME type whitelist* --- `image/jpeg`, `image/png`, `image/webp`, `image/gif`; (4) *magic-byte signature verification* --- the first 12 bytes of actual file content are compared against known binary signatures (JPEG `FF D8 FF`, PNG `89 50 4E 47`, GIF `47 49 46 38`, WebP's RIFF header `52 49 46 46`). The fourth layer is what actually matters against a deliberate attacker: extension and MIME checks alone can be trivially spoofed by renaming a file or forging `Content-Type`, but the magic-byte check inspects the real binary header, catching a disguised non-image file regardless of its claimed extension or MIME type.

*Verdict-explanation anti-spam validation.* `validateVerdictExplanation()` applies, in sequence: minimum *50 characters*; maximum *1500 characters* (the server-side cap on the same field is more permissive at 3000); minimum *8 words* (defeats character-padding gibberish); repeated-character detection (a single character repeated 6+ times consecutively); repeated-word detection (the same word three times in a row); a fixed black-list of generic cop-out phrases (`just trust me`, `trust me bro`, `check it yourself`, `search it on google`, `search google`, `idk`, `i don't know`, `random text to fill space`, `asdfasdf`, `qwertyuiop`); copy-paste-the-claim detection (rejecting an explanation that is identical to, or nearly wholly contains, a claim text of at least 30 characters); and a non-blocking constructive-quality nudge if the explanation contains none of a set of evidence-indicating terms.

*XSS input sanitization.* `sanitizeTextInput()` provides defense-in-depth on top of React's own automatic JSX escaping. It strips dangerous HTML tags (`script`, `iframe`, `object`, `embed`, `form`, `link`, `meta`, `style`, `svg`, `math`, `base`, `applet`), dangerous event-handler/injection-prone attributes (`on*` handlers, `srcdoc`, `formaction`, `xlink:href`), dangerous URI schemes (`javascript:`, `vbscript:`, `data:`), and null bytes.

*The client cannot be fully trusted --- server-side backing.* Every mechanism above is client-side JavaScript, bypassable by a user who calls the underlying Firebase SDK directly. `firestore.rules` re-implements the constraints that actually protect data integrity, independently of the client (§4.2.2): the 50--3000 character bound on `explanation` backs up the stricter client-side bound; the `sourceUrl` format check is re-validated server-side; the append-exactly-one-verification arithmetic, the `verifierId` ownership check, and the live `verifierReputation` cross-check are enforced *only* by `firestore.rules`, with no client-side equivalent, because they are structural integrity guarantees that must hold regardless of which client issued the write; the `imageUrl` cap is enforced identically whether the image was compressed as intended or pushed raw via the SDK; and the `isAdmin()` gate is what actually prevents privilege escalation, with the client-side `AdminRoute.tsx` re-check being a UX convenience that happens to align with the same rule rather than an independent boundary. The general principle: *client-side validation exists to give immediate feedback and filter unintentional or low-effort abuse before a network round-trip; server-side Firestore Security Rules exist to make the constraint actually true*, because the server is the only party in this architecture that cannot be tampered with by the party trying to bypass a rule.

== Test Cases Design

The test cases below cover the core functional pipeline (registration #sym.arrow.r submission #sym.arrow.r duplicate detection #sym.arrow.r verification #sym.arrow.r consensus) and the security-critical paths (rate-limited login, admin access control) described in §4.2, §4.4, and §4.5. Every expected result traces to an actual enforced rule rather than an assumed one; full execution logs and pass/fail results belong to Chapter 5 (Implementation and Testing) and Chapter 6 (Results and Discussion).

#styled-table(
  columns: (0.55fr, 0.85fr, 1.5fr, 1.5fr, 1.9fr),
  headers: ("Test ID", "Module", "Test Condition", "Input", "Expected Result"),
  "TC-01", "Auth (M1)", "New user registers with valid credentials", "Valid email, 8+ char password with 1 uppercase and 1 digit, display name", [Account created; `users/{uid}` seeded with `reputation: 50`, `totalVerifications: 0`, `isAdmin: false`],
  "TC-02", "Auth (M1)", "User logs in with valid credentials", "Correct email + password", [Session established; login-attempt counter reset via `resetLoginAttempts()`],
  "TC-03", "Auth (M1)", "User logs in with invalid credentials", "Incorrect password, valid email", [Login rejected; `recordFailedLogin()` increments the attempt counter],
  "TC-04", "Auth / Security (M1, M8)", "User exceeds login attempt limit", "5 consecutive failed attempts, same identifier", [6th attempt blocked; `isLockedOut: true`; UI shows MM:SS countdown],
  "TC-05", "Ingestion (M2)", "User submits a claim as plain text", "Text, 20--500 chars (the Submit.tsx bound, inside the server rule's 10--2000 range), valid category", [Claim created: `status: pending`, `verificationCount: 0`, `consensusDeadline` = now + 7 days],
  "TC-06", "Ingestion / OCR (M2)", "User submits via WhatsApp screenshot", "Valid JPEG/PNG, $<=$ 5 MB", [Image compressed, OCR-extracted; WhatsApp chrome stripped; text shown for review],
  "TC-07", "Duplicate Detection (M3)", "New submission closely matches an existing claim", [Text with $J(A,B) >= 0.75$], "Submission blocked; inline warning links to the existing claim; no new document created",
  "TC-08", "Duplicate Detection (M3)", "New submission is sufficiently distinct", [Text with $max J(A,B) < 0.75$], "New document created; claim enters the Verification Queue",
  "TC-09", "Verification Queue (M4)", "Verifier submits a verdict below quorum", "1st/2nd verification, valid fields", [`verificationCount` +1; `status` remains `pending`],
  "TC-10", "Verification Queue (M4)", "Explanation fails anti-spam validation", [Explanation $<$ 50 chars, or repeated-char spam, or a copy of the claim text], [`validateVerdictExplanation()` rejects client-side; no write attempted],
  "TC-11", "Queue / Consensus (M4, M5)", "Verification reaches exactly quorum", "3rd verification submitted", [`calculateConfidenceScore()` invoked; verdict/confidence set; `status` #sym.arrow.r `verified`],
  "TC-12", "Consensus Engine (M5)", "Claim remains under quorum past deadline", [`verificationCount < 3`, `consensusDeadline` elapsed], [Expiry sweep force-settles `verdict = CONTESTED`, `status = verified`],
  "TC-13", "Admin Console (M8)", "Admin overrides a claim's verdict", "Admin session; claim ID; new verdict", [Claim updated via Case A rule; action recorded in `audit_logs`],
  "TC-14", "Security / Admin Access", "Unauthorized `/admin` access attempt", [No valid admin session, or forged session flag with `isAdmin != true`], [Login gate shown; forged flag discarded; access denied],
  "TC-15", "Data Integrity", "Client attempts to forge a verification's reputation", "Direct SDK write with inflated `verifierReputation`", [Write rejected --- must equal the caller's live `users/{uid}.reputation`],
  "TC-16", "File Upload Validation (M2, M8)", "User uploads a disguised non-image file", [A renamed file with a spoofed `image/png` MIME type], [Magic-byte check fails; upload rejected],
)
