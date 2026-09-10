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

FactStamp translates the functional requirements and data models from Chapter 3 into an operational architecture: eight functional modules, a Cloud Firestore schema governed by declarative server-side security rules, duplicate-detection and consensus algorithms, a custom component interface, defense-in-depth security policies, and an end-to-end test suite. All specifications correspond directly to the repository implementation (`/home/aadish/Documents/Github/FactStamp`).

== Basic Modules

The system partitions runtime responsibilities into eight modules. Each module maps to distinct source files and participates in the claim lifecycle (submission #sym.arrow.r duplicate check #sym.arrow.r verification queue #sym.arrow.r consensus #sym.arrow.r card generation #sym.arrow.r analytics aggregation), with cross-cutting security and notification services supplied by Module 8.

*Module 1: Authentication & Verifier Reputation.* Core files: `src/contexts/AuthContext.tsx`, `src/pages/SignIn.tsx`, `src/pages/SignUp.tsx`, `src/services/firebaseService.ts`. `AuthContext.tsx` wraps the Firebase Authentication SDK in a React Context, exposing session state and authentication methods (`signIn`, `signUp`, `signInWithGoogle`, `signOut`, `updateUser`) across the component tree. Users can register using email credentials or Google OAuth. On registration, `firebaseService.ts` initializes a `users/{uid}` document in Firestore with a baseline `reputation` of 50 (on a 0 to 100 scale), `totalVerifications` at 0, and `isAdmin` set to false. Declarative `firestore.rules` validate these initial values on write, preventing client modification. Downstream modules depend on these authenticated identities: Module 2 records the submitter identifier, Module 4 associates each verification with its author, and Module 5 reads the voter's reputation during consensus calculation.

*Module 2: Forward Submission / Ingestion & OCR.* Core files: `src/pages/Submit.tsx`, `src/services/ocrService.ts`, `src/lib/imageCompression.ts`. `Submit.tsx` ingests claims either as pasted text or as image screenshots. When an image is supplied, `imageCompression.ts` rescales and compresses the bitmap client-side using the HTML5 Canvas API. Next, `ocrService.ts` executes Tesseract.js WebAssembly OCR locally in a browser worker without uploading the image to an external server. The extraction pipeline passes the output through `cleanExtractedOcrText()` to strip WhatsApp UI artifacts, including timestamps, sender headers, and delivery checkmarks. The user reviews and edits the parsed text in an editable area before confirming submission. Upon confirmation, `Submit.tsx` invokes Module 3 duplicate detection before persisting a new `claims/{claimId}` record.

*Module 3: Duplicate Detection Engine.* Core file: `src/lib/duplicateDetection.ts`. `duplicateDetection.ts` computes word-token Jaccard similarity between candidate claim text and all existing claims in Firestore. Text is normalized (lowercased, stripped of punctuation, and collapsed) and tokenized into sets containing words with more than three characters. The similarity metric is evaluated against each existing claim: $J(A,B) = |S_A inter S_B| \/ |S_A union S_B|$. When $max J(A,B) >= 0.75$, the UI blocks insertion, displaying an inline notification with a route link to the existing claim. Distinct submissions proceed to Firestore as new `pending` records and populate the verification queue in Module 4.

*Module 4: Verification Queue.* Core files: `src/pages/VerifyQueue.tsx`, `src/pages/VerifyDetail.tsx`, `src/contexts/ClaimsContext.tsx`. `VerifyQueue.tsx` renders all claims in `pending` status, sorting admin-flagged items to the head of the list. `VerifyDetail.tsx` provides the verifier review interface. Verifiers choose a verdict (`TRUE`, `FALSE`, `MISLEADING`, or `UNVERIFIABLE`; `CONTESTED` is reserved for automated timeout settlement), enter a corroborating source URL classified into a quality tier by `determineSourceQuality()`, and submit an analytical explanation. `validateVerdictExplanation()` in `src/lib/security.ts` validates that the explanation contains at least 50 characters and 8 words. Valid submissions append an element to `claims.verifications[]` and increment `verificationCount` by 1, enforced both in React context and by server-side `firestore.rules`. When `verifications.length` reaches the quorum threshold of 3, `ClaimsContext.tsx` invokes Module 5 to calculate consensus and persist the final verdict in the same write.

*Module 5: Weighted Consensus and Confidence Engine.* Core file: `src/lib/confidenceScore.ts`. `calculateConfidenceScore()` synthesizes multiple verifications into a singular outcome by determining the majority agreement ratio $A$, mean verifier reputation $R$, and mean source quality $S$:

$ C = (A times 0.40) + (R times 0.30) + (S times 0.30) $

The module also handles consensus timeouts. When a `pending` claim exceeds its 7-day `consensusDeadline` without reaching the 3-verifier quorum, an expiry sweep calculates a confidence score across available verifications and assigns the verdict `CONTESTED`. Upon transitioning status to `verified`, Module 5 signals Module 8 to dispatch an in-app notification to the original submitter, enabling export in Module 6.

*Module 6: Fact-Check Card Generator.* Core files: `src/components/FactCheckCard.tsx`, `src/pages/ClaimDetail.tsx`. `FactCheckCard.tsx` and `ClaimDetail.tsx` render resolved verdicts as structured graphic summaries. The `html-to-image` library rasterizes the component client-side into a 1080px-wide PNG (configured as a 540px DOM container rendered at `pixelRatio: 2`, with vertical dimensions scaling to accommodate claim text and citations). It utilizes SVG `<foreignObject>` serialization, preserving Tailwind CSS v4 `oklch()` and `oklab()` color values without raster artifacts. Users download the generated image directly to circulate within messaging channels.

*Module 7: Misinformation Analytics Dashboard.* Core files: `src/pages/Dashboard.tsx`, `src/components/DashboardChart.tsx`, `src/lib/weeklyReport.ts`. `Dashboard.tsx`, `DashboardChart.tsx`, and `weeklyReport.ts` aggregate historical verification data into public visualizations. `weeklyReport.ts` processes claims resolved within a 7-day sliding window, deriving category distributions, verdict frequencies, and prominent refuted claims. Visualizations are rendered via Recharts with custom tooltip formatters. The dashboard operates in a read-only capacity, consuming data from the active React context without issuing supplemental database writes.

*Module 8: System Security & Notifications.* Core files: `src/lib/security.ts`, `src/contexts/NotificationsContext.tsx`, `src/components/NotificationBell.tsx`, `firestore.rules`. `security.ts`, `NotificationsContext.tsx`, `NotificationBell.tsx`, and `firestore.rules` provide cross-cutting protection and notification delivery. `security.ts` enforces input sanitization, spam mitigation, magic-byte file validation, session timeouts, and client rate limiting. `NotificationsContext.tsx` and `NotificationBell.tsx` deliver real-time in-app alerts upon claim resolution. Correspondingly, `firestore.rules` independently validates all mutations on the Firebase server cluster.

#v(6pt)
#align(center)[*Table 4.1.1: Cross-Module Interaction Summary*]
#styled-table(
  columns: (1.6fr, 0.85fr, 0.85fr, 1.9fr),
  headers: ("Trigger", "Calling Module", "Called Module", "Effect"),
  "User submits claim text/screenshot", "2", "3", "Jaccard check against existing claims before a new document is created",
  [$max J(A,B) >= 0.75$ against an existing claim], "3", "2", "Submission blocked; user offered a direct link to the existing claim page",
  "Verifier submits a verdict", "4", "8", [`validateVerdictExplanation()` validates input before the Firestore write],
  [`verifications.length` reaches 3], "4", "5", [`calculateConfidenceScore()` computes final verdict; status #sym.arrow.r `verified`],
  [`consensusDeadline` passes with count $< 3$], "5", "4", "Claim force-settled with verdict CONTESTED",
  "Claim reaches verified status", "5", "8", "Submitter notified; verifier reputation updated",
  "Claim reaches verified status", "5", "6", "Claim becomes eligible for PNG card export",
  [Every write to `users`, `claims`, `notifications`, `reports`, `audit_logs`], "1, 2, 4, 5", "8", [Server-side field-level validation independent of client checks],
)

== Data Design

FactStamp persists application state in Cloud Firestore, a NoSQL document database. Data is organized across five root collections: `users`, `claims`, `notifications`, `reports`, and `audit_logs`. Type interfaces are declared in `src/lib/types.ts`, and write constraints are enforced on every transaction by `firestore.rules`.

=== Schema Design

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
  [`imageUrl`], "string?", "Base64 data URI or HTTPS URL", [$<=$ 800,000 chars (~800 KB); pattern-matched],
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

=== Data Integrity and Constraints

`firestore.rules` evaluates every incoming write operation prior to persistence. Malformed requests or unauthorized mutations are rejected at the database boundary.

*Field-level write validation.* Write evaluation verifies `request.resource.data` on a field-by-field basis. Creating a new `claims/{claimId}` document requires `text.size()` between 10 and 2000 characters, `category` membership within an explicit whitelist, `status == "pending"`, `verificationCount == 0`, and an empty `verifications == []` array. This structure blocks unverified submissions with pre-populated votes or excessive text lengths.

*The `isAdmin()` helper.* Privileged operations check caller authority through an `isAdmin()` helper function that inspects the caller's Firestore document at evaluation time:

// Kept on one page: this block is short, and letting it split mid-expression
// across a page boundary made the rule unreadable.
#block(breakable: false)[
```
function isAdmin() {
  return request.auth != null
    && get(
         /databases/$(database)/documents/users/$(request.auth.uid)
       ).data.get('isAdmin', false) == true;
}
```
]

Modifications to the `isAdmin` boolean property on `users/{uid}` require the caller to already possess admin privileges. Unprivileged users cannot modify this flag, preventing client-side privilege escalation.

*Append-exactly-one-verification-per-write.* Appending a verification to a claim enforces several concurrent conditions: `verificationCount` must increment by exactly 1, prior `verifications` entries must remain intact via `hasAll()`, `verifierId` must match the caller's `request.auth.uid`, and `verifierReputation` must equal the caller's live reputation score in `users/{uid}`. The submitted verdict must belong to the active enum set (`TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`), and `sourceUrl` along with `explanation` must satisfy length and regex formatting constraints. These rules mirror the client-side validation in `validateVerdictExplanation()`, so the database rejects invalid records even if requests bypass the browser interface.

*Immutability rules.* Helper functions `isUnchanged()` and `identityUnchanged()` lock critical attributes after document creation. The fields `text`, `category`, `submittedBy`, `submittedByName`, `createdAt`, `consensusDeadline`, and `imageUrl` remain read-only during normal verification and timeout sweeps, with override authority restricted to administrators. The `audit_logs` collection prohibits both `update` and `delete` operations, maintaining an immutable record of system actions.

*Storage Architecture and Quorum atomicity.* Storing verifications directly in an embedded array on each `Claim` document serves two architectural requirements. First, atomic quorum resolution in Module 5 requires evaluating `verifications.length` synchronously in the same snapshot as the verification append. A subcollection would require either an aggregation query or a separate counter synchronized across multiple writes, creating a potential concurrency race during quorum triggers. Second, single-read hydration allows screens displaying a claim to fetch claim metadata and its full verification history in one document read. Although `firestore.rules` retains an unused declaration for a legacy `verdicts` subcollection, active application paths read and write only the embedded array. While Firestore caps documents at 1 MiB, the three-verifier quorum ceiling and the 3000-character explanation limit keep total document size well below this threshold.

*Image Payload Constraints.* Screenshot submissions are encoded as base64 data URIs within `claims/{claimId}.imageUrl`. Because base64 expands binary size by approximately 33%, `firestore.rules` enforces `imageUrl.size() <= 800000` characters to ensure the total document remains below Firestore's 1 MiB limit alongside the `verifications` array. Client-side compression scales images to a maximum dimension of 1280 pixels and reduces JPEG quality from 0.72 to a minimum of 0.4 until payload size drops below 700,000 bytes. A separate `storage.rules` configuration exists in the repository for authenticated uploads under 10 MB, but active client workflows use the embedded data URI mechanism exclusively.

*Server-Side Rule Enforcement.* Client-side validation provides immediate interface feedback, but direct requests to the Firestore SDK can bypass browser controls. Consequently, `firestore.rules` defines a parallel, authoritative set of constraints for enum memberships, field length bounds, user ownership, quorum increment arithmetic, immutable properties, and administrator roles. The database engine enforces these rules on all incoming operations regardless of client state.

== Procedural Design

=== Logic Diagrams

The system control flow follows the claim lifecycle from initial submission through duplicate evaluation and peer verification to final consensus. The workflow proceeds through nine stages: (1) the user submits claim text or an image screenshot; (2) image submissions undergo canvas compression, OCR extraction, WhatsApp header stripping, and user review before joining the text path; (3) the text is normalized and tokenized; (4) candidate tokens are compared against existing claims using the Jaccard index; (5) if $max J(A,B) >= 0.75$, submission is rejected with a link to the matching claim, whereas values below 0.75 generate a new `pending` claim with a 7-day `consensusDeadline`; (6) the claim enters the verification queue, where independent verifiers supply a verdict, a source URL, and a text explanation; (7) when `verifications.length` reaches 3, the consensus engine calculates the final score and marks the claim `verified`, while claims with fewer verifications remain `pending`; (8) an automated sweep settles any claim exceeding its 7-day deadline under quorum with the verdict `CONTESTED`; and (9) verified claims trigger submitter notifications, card generation, and dashboard metric updates.

#align(center)[#image("attachments/claim_lifecycle_flow.svg", width: 100%, height: 88%, fit: "contain")]

=== Data Structures

The core data structures are declared in `src/lib/types.ts` and imported across all modules described in Section 4.1 without duplicate declarations.

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

The `Verdict` enum includes `CONTESTED`, which is assigned programmatically during consensus expiry in Module 5. Verifiers cannot select this outcome directly in `VerifyDetail.tsx`. Similarly, `Claim.verifications` is typed as an embedded array to mirror the storage architecture described in Section 4.2.2. TypeScript strict mode requires all modules reading optional fields (`?`) to handle unset values, so dashboard components cleanly account for `pending` records that lack a finalized `confidenceScore`.

=== Algorithms Design

*Algorithm 1: Jaccard Duplicate Detection* (`src/lib/duplicateDetection.ts`). Purpose: identify near-duplicate submissions to prevent redundant verification queues for identical or slightly reworded claims.

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

Computational complexity is $O(n dot m)$, where $n$ is the count of scanned claims and $m$ is the average token-set cardinality. This linear scan suffices for FactStamp's current operational scale, whereas an inverted index or MinHash locality-sensitive hashing would be required for web-scale corpora.

*Algorithm 2: Weighted Consensus and Confidence Scoring* (`src/lib/confidenceScore.ts`). Purpose: combine independent verifications into a final verdict and a numeric confidence score based on agreement, verifier reputation, and source credibility.

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

The consensus-expiry sweep (see Section 4.1, Module 5) reuses this function: a `pending` claim past its deadline with fewer than 3 verifications evaluates `calculateConfidenceScore()` across available verifications, with the final verdict set to `CONTESTED` because under-quorum outcomes are unresolved.

== User Interface Design

FactStamp uses a custom component architecture without external UI component libraries. Interactive primitives (`Button`, `Input`, `Modal`, `Badge`, `CategoryBadge`, `VerdictPill`, `Avatar`, `SourceQualityDot`, `EmptyState`, `ErrorState`, `Skeletons`, `ThemeToggle`, `LoadingButton`, `PasswordStrength`, `ShimmerText`, `Marquee`, `FlowButton`, `InteractiveHoverButton`, `SpotlightCard`) reside in `src/components/ui/` and are styled using Tailwind CSS v4 custom properties, allowing theme transitions by updating root-level variables. Framer Motion supplies animations across navigation components and verdict badges. Recharts provides visualizations for the dashboard and admin console, and application state is coordinated through React Context (`AuthContext`, `ClaimsContext`, `NotificationsContext`, `ThemeContext`, `UsersContext`).

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

*Home (`/`).* A hero section explains FactStamp's functionality with actions to submit or browse the queue, live platform counters via `AnimatedCounter`, an architectural walkthrough, and a persistent navigation bar showing authentication state, theme toggles, notifications, and profile links.

#align(center)[#image("attachments/wireframe_home.png", width: 100%, height: 90%, fit: "contain")]

*Submit (`/submit`, protected).* Users choose between 'Text Forward' and 'Screenshot (OCR)' modes. Screenshot mode triggers inline compression and Tesseract.js OCR with loading feedback, populating an editable text area with filtered output. Below it sits the category grid, built from `CategoryBadge` cards offering five classifications: 'Health & Medical', 'Political & Govt', 'Financial & Loans', 'Religious & Culture', and 'Other Topics'. Duplicate checking executes when the text area loses focus; a detected match displays an inline alert with a navigation button to the existing claim and disables submission.

#align(center)[#image("attachments/wireframe_submit.png", width: 100%, height: 90%, fit: "contain")]

*VerifyQueue (`/verify`, protected).* A scrollable feed of `ClaimCard` components presents text excerpts, category badges, timestamps, and verification progress via a three-segment `ConsensusStepper`. Cards include deadline countdown indicators, priority review badges for admin-flagged items, and image attachment indicators. Admin-flagged claims are prioritized at the top of the feed alongside category filtering and search tools.

#align(center)[#image("attachments/wireframe_verify_queue.png", width: 100%, height: 90%, fit: "contain")]

*VerifyDetail (`/verify/:claimId`, protected).* The workbench presents the claim text or screenshot above a verification progress indicator. To prevent anchoring bias and bandwagon effects, verifiers cannot see peer verdicts prior to submission (blind review). The evaluation form provides a `VerdictPill` selector (omitting the system-assigned `CONTESTED` option), a source URL input with real-time domain quality classification via `SourceQualityDot`, and an explanation field validated by `validateVerdictExplanation()`.

#align(center)[#image("attachments/wireframe_verify_detail.png", width: 100%, height: 90%, fit: "contain")]

*ClaimDetail (`/claim/:claimId`, public).* This public view displays claim text, image evidence, the resolved verdict pill, the confidence score with constituent metric breakdowns, contributing verifications with citation links, and an export button generating a 1080px-wide PNG fact-check card via `html-to-image` (540px layout rendered at `pixelRatio: 2`).

#align(center)[#image("attachments/wireframe_claim_detail.png", width: 100%, height: 90%, fit: "contain")]

*Dashboard (`/dashboard`, public).* Recharts visualizations display category distributions, verdict proportions, a 7-day rolling trend list, and verifier leaderboards with customized tooltips.

#align(center)[#image("attachments/wireframe_dashboard.png", width: 100%, height: 90%, fit: "contain")]

*Profile (`/profile`, protected).* Displays account metadata, reputation scores with tier classifications (Novice, Trusted, Expert, Elite), submission and verification history, and profile preferences.

#align(center)[#image("attachments/wireframe_profile.png", width: 100%, height: 90%, fit: "contain")]

*Admin (`/admin`, admin-guarded).* The console is an unlisted route omitted from public navigation. Access is governed by `AdminRoute.tsx`, which enforces an authentication gate before presenting five functional tabs:
- System Overview: displays platform KPI metrics, category bar charts, verdict consensus distributions, and reputation tier distributions.
- Verifier Directory: provides a searchable table of `User` records with controls to adjust reputation scores, toggle administrative status, and remove accounts.
- Claims Moderation: enables administrators to inspect claims, toggle expedited review flags, modify categories or text, override verdicts, and delete records.
- Incident Queue: manages `ModerationReport` tickets with filtering by status and severity.
- Audit and Tools: provides a real-time log viewer for `AdminAuditLog` records, manual triggers for consensus expiry sweeps, broadcast notification tools, and JSON database exports.

Mutating administrative operations execute through the shared `addAuditLog()` utility.

#align(center)[#image("attachments/wireframe_admin.png", width: 100%, height: 90%, fit: "contain")]

== Security Issues

FactStamp's security architecture employs defense in depth. Client-side controls provide immediate user interface feedback and intercept casual invalid inputs, while server-side `firestore.rules` evaluations enforce non-bypassable constraints on all database writes.

*Dual-layer admin authentication.* Access to `/admin` requires two independent checks: a `sessionStorage` unlock flag (`fs_admin_session_unlocked`) set upon credential submission, and a live Firestore authorization check evaluated on every render. `AdminRoute.tsx` verifies that `user?.isAdmin === true` against the active profile snapshot. If the session storage flag is present but the user document lacks admin privileges, the client clears the flag and redirects to the login screen. Attempting to set `fs_admin_session_unlocked` manually in browser storage fails because every protected route requires verified server-side privileges.

*Login rate-limiting.* `checkLoginRateLimit()`, `recordFailedLogin()`, and `resetLoginAttempts()` protect authentication endpoints against brute-force attacks. `SignIn.tsx` keys attempt counters by email identifier, whereas `AdminRoute.tsx` utilizes a shared client-wide counter. Reaching `MAX_LOGIN_ATTEMPTS = 5` failed attempts for a specific identifier enforces a 15-minute lockout (`LOCKOUT_DURATION_MS = 15 times 60 times 1000` ms). Identifier-specific attempts are tracked alongside a global counter: if global failed attempts reach 10, a client-wide lockout activates. Counters persist across both `localStorage` and `sessionStorage`, and successful authentication clears all stored attempts. `formatLockoutRemaining()` formats the remaining duration as `MM:SS`.

*Idle session timeout.* `recordActivity()` and `isSessionExpired()` enforce a 30-minute idle session timeout (`SESSION_TIMEOUT_MS = 30 times 60 times 1000` ms). User interactions record timestamps in `sessionStorage`. When elapsed inactivity exceeds the threshold, the session expires and requires re-authentication, reducing risk from unattended browser tabs. `clearSecuritySession()` purges both the timestamp and the admin session flag upon logout.

*Triple-layer file upload validation.* `validateImageUpload()` evaluates uploaded image files through four sequential checks:
+ Maximum file size: files must not exceed 5 MB (`MAX_UPLOAD_SIZE_BYTES = 5 times 1024 times 1024`), and empty files are rejected.
+ Extension whitelist: extensions are restricted to `.jpg`, `.jpeg`, `.png`, `.webp`, and `.gif`.
+ MIME type whitelist: declared content types are restricted to `image/jpeg`, `image/png`, `image/webp`, and `image/gif`.
+ Magic-byte signature verification: the first 12 bytes of file data are validated against known binary file signatures (JPEG `FF D8 FF`, PNG `89 50 4E 47`, GIF `47 49 46 38`, and WebP RIFF `52 49 46 46`). Because extension and MIME headers can be forged by renaming files or modifying client request headers, inspecting leading binary signatures prevents non-image payloads from being processed.

*Verdict-explanation anti-spam validation.* `validateVerdictExplanation()` applies eight validation filters: minimum 50 characters, maximum 1500 characters (the server-side cap is 3000), minimum 8 words, repeated character detection (6 or more consecutive identical characters), repeated word detection (3 consecutive identical words), cop-out phrase blacklists (`just trust me`, `trust me bro`, `check it yourself`, `search it on google`, `search google`, `idk`, `i don't know`, `random text to fill space`, `asdfasdf`, `qwertyuiop`), claim text duplication detection (rejecting explanations matching 30 or more characters of claim text), and constructive guidance prompts.

*XSS input sanitization.* `sanitizeTextInput()` strips dangerous HTML elements (`script`, `iframe`, `object`, `embed`, `form`, `link`, `meta`, `style`, `svg`, `math`, `base`, `applet`), event handler attributes (`on*`, `srcdoc`, `formaction`, `xlink:href`), dangerous URI protocols (`javascript:`, `vbscript:`, `data:`), and null bytes, complementing React's automatic JSX encoding.

*Server-Side Rule Enforcement.* `firestore.rules` enforces validation independently of client application code. While client-side routines improve responsiveness, backend rules secure data integrity against direct API invocations: the 50 to 3000 character bound on `explanation` enforces an upper size ceiling; `sourceUrl` regular expressions validate cited links; append-only verification logic guarantees exactly one entry is added per write; `verifierId` and `verifierReputation` verify author identity against live user profiles; and the `imageUrl` byte cap limits stored payload sizes. Finally, `isAdmin()` checks on the database cluster prevent unauthorized administrative modifications, establishing backend authority across all platform transactions.

== Test Cases Design

The test cases below cover the functional pipeline (registration #sym.arrow.r submission #sym.arrow.r duplicate detection #sym.arrow.r verification #sym.arrow.r consensus) and security paths (rate-limited authentication, administrative access control) described in Sections 4.2, 4.4, and 4.5. Every expected result traces to an enforced rule; full execution logs and observed outcomes appear in Chapters 5 and 6.

#styled-table(
  columns: (0.55fr, 0.85fr, 1.5fr, 1.5fr, 1.9fr),
  headers: ("Test ID", "Module", "Test Condition", "Input", "Expected Result"),
  "TC-01", "Auth (M1)", "New user registers with valid credentials", "Valid email, 8+ char password with 1 uppercase and 1 digit, display name", [Account created; `users/{uid}` seeded with `reputation: 50`, `totalVerifications: 0`, `isAdmin: false`],
  "TC-02", "Auth (M1)", "User logs in with valid credentials", "Correct email + password", [Session established; login-attempt counter reset via `resetLoginAttempts()`],
  "TC-03", "Auth (M1)", "User logs in with invalid credentials", "Incorrect password, valid email", [Login rejected; `recordFailedLogin()` increments the attempt counter],
  "TC-04", "Auth / Security (M1, M8)", "User exceeds login attempt limit", "5 consecutive failed attempts, same identifier", [6th attempt blocked; `isLockedOut: true`; UI shows MM:SS countdown],
  "TC-05", "Ingestion (M2)", "User submits a claim as plain text", "Text, 20 to 500 chars (the Submit.tsx bound, inside the server rule's 10 to 2000 range), valid category", [Claim created: `status: pending`, `verificationCount: 0`, `consensusDeadline` = now + 7 days],
  "TC-06", "Ingestion / OCR (M2)", "User submits via WhatsApp screenshot", "Valid JPEG/PNG, $<=$ 5 MB", [Image compressed, OCR-extracted; WhatsApp chrome stripped; text shown for review],
  "TC-07", "Duplicate Detection (M3)", "New submission closely matches an existing claim", [Text with $J(A,B) >= 0.75$], "Submission blocked; inline warning links to the existing claim; no new document created",
  "TC-08", "Duplicate Detection (M3)", "New submission is sufficiently distinct", [Text with $max J(A,B) < 0.75$], "New document created; claim enters the Verification Queue",
  "TC-09", "Verification Queue (M4)", "Verifier submits a verdict below quorum", "1st/2nd verification, valid fields", [`verificationCount` +1; `status` remains `pending`],
  "TC-10", "Verification Queue (M4)", "Explanation fails anti-spam validation", [Explanation $<$ 50 chars, or repeated-char spam, or a copy of the claim text], [`validateVerdictExplanation()` rejects client-side; no write attempted],
  "TC-11", "Queue / Consensus (M4, M5)", "Verification reaches exactly quorum", "3rd verification submitted", [`calculateConfidenceScore()` invoked; verdict/confidence set; `status` #sym.arrow.r `verified`],
  "TC-12", "Consensus Engine (M5)", "Claim remains under quorum past deadline", [`verificationCount < 3`, `consensusDeadline` elapsed], [Expiry sweep force-settles `verdict = CONTESTED`, `status = verified`],
  "TC-13", "Admin Console (M8)", "Admin overrides a claim's verdict", "Admin session; claim ID; new verdict", [Claim updated via Case A rule; action recorded in `audit_logs`],
  "TC-14", "Security / Admin Access", [Unauthorized `/admin` access attempt], [No valid admin session, or forged session flag with `isAdmin != true`], [Login gate shown; forged flag discarded; access denied],
  "TC-15", "Data Integrity", "Client attempts to forge a verification's reputation", [Direct SDK write with inflated `verifierReputation`], [Write rejected: value must match caller's live `users/{uid}.reputation`],
  "TC-16", "File Upload Validation (M2, M8)", "User uploads a disguised non-image file", [A renamed file with a spoofed `image/png` MIME type], [Magic-byte check fails; upload rejected],
)
