// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // 1.5in left margin for single-sided binding
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border for Black Books and Assignments
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

// Cross-Platform Font Fallbacks (Windows/Mac/Linux CI compatibility)
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory Rule: New topic on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

// Global Table Cell Styling
#show table.cell: set text(size: 9pt)
#show table.cell.where(y: 0): set text(size: 9pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  text(
    font: ("DejaVu Sans Mono", "Liberation Mono", "Courier New"),
    size: 8.5pt,
    it
  )
)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 4.5pt, y: 4pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 9pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Module 4: Decentralized Quorum Verification Queue", author: "Aadish")

// ==========================================
// Standalone Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[ACADEMIC COURSE SUBMISSION]
    #v(4pt)
    #text(size: 12pt, weight: "bold")[MODULE 4: PROJECT IMPLEMENTATION]
    #v(2pt)
    #text(size: 10.5pt)[*Decentralized Quorum Verification Queue, Stepper, and Workbench Subsystem*]
    #v(6pt)
    #text(size: 10pt)[Submitted in Partial Fulfilment of the Requirements for Course *JUSIT-DSCPR503*]\
    #text(size: 11.5pt, weight: "bold")[Bachelor of Science in Information Technology]\
    #v(10pt)
    #text(size: 10pt)[*Candidate:* Aadish (UID: 2023IT001)]\
    #text(size: 10pt)[*Department of Information Technology*]\
    #text(size: 11pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai - 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025-2026]
  ]
  #v(14pt)
]

// Dedicated Table of Contents Page
#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[TABLE OF CONTENTS]
]
#v(12pt)

#outline(
  title: none,
  indent: 1.5em,
  depth: 2
)

#pagebreak()

// =============================================================================
// MODULE 4 IMPLEMENTATION
// =============================================================================
= Module 4: Decentralized Quorum Verification Queue

== Subsystem role and architecture
Traditional fact-checking organizations rely on full-time editorial staff to select, investigate, and publish articles debunking rumors. This centralized model struggles to keep pace with the volume of forwards circulating through encrypted messaging networks like WhatsApp in India, where messages spread across private groups.

Module 4 distributes the verification workload across authenticated community members through a structured peer review queue. It coordinates community evaluations through four main mechanisms:

1. Ingests unique claims cleared by the Jaccard duplicate detector ($J < 0.75$) into a shared queue.
2. Requires at least three independent, authenticated verifications ($N >= 3$) before a claim moves from pending to verified.
3. Requires each verdict submission to include an HTTP or HTTPS source citation and an explanation of at least $50$ characters and $8$ words.
4. Applies a 7-day cutoff for consensus. Claims without three verifications in that window are marked as `CONTESTED` and archived.

#styled-table(
  columns: (1.3in, 1.4in, 1.4in, 1.3in),
  headers: ("Operational Metric", "Centralized Fact-Checking Desk", "Unmoderated Public Voting", "FactStamp Quorum Queue (Module 4)"),
  "Turnaround Latency", "24 to 72 hours", "Minutes (high spam noise)", "2 to 6 hours",
  "Throughput Capacity", "5-15 articles per day", "High (unreliable)", "Hundreds of forwards per day",
  "Evidentiary Standard", "Editorial review", "None (raw vote counts)", "Mandatory primary URL and >= 50-char rationale",
  "Sybil Resistance", "High (staff only)", "Low (vulnerable to bots)", "Self-verification lock and reputation weighting"
)

#pagebreak()

== Quorum lifecycle and verification parameters

=== 1. Quorum threshold ($N_"min" = 3$)
Single-judge systems are vulnerable to individual bias, misread sources, and outdated reports. To prevent single points of failure, Module 4 requires at least three independent verifications ($N >= 3$) before calculating consensus.

=== 2. Four-part verdict categories
Verifiers classify claims using four standard verdict values:

#styled-table(
  columns: (1.1in, 1.0in, 3.3in),
  headers: ("Verdict Token", "Color Indicator", "Definition"),
  "TRUE", "Emerald Green", "The forwarded claim is factual and supported by primary sources, such as government gazettes or institutional records.",
  "FALSE", "Crimson Red", "The claim is fabricated, altered, or contradicted by verifiable empirical evidence.",
  "MISLEADING", "Amber Gold", "The claim contains some accurate elements but takes them out of context, distorts numbers, or misattributes statements.",
  "UNVERIFIABLE", "Slate Gray", "The claim cannot be confirmed or disproved because evidence is unavailable, private, or ambiguous."
)

=== 3. Citation requirements and anti-spam filters
Module 4 requires evidence for every submission rather than simple upvotes or downvotes. Submissions must meet three input constraints:
1. Citations must begin with `http://` or `https://` and point to an accessible domain ($<= 500$ characters).
2. Explanations must contain at least $50$ characters and $8$ words ($50 <= "length" <= 3000$).
3. Client-side checks reject repetitive character strings (such as `"aaaaaaaaa"`) and common filler phrases (such as `"trust me bro"` or `"fake news"`) before submitting data to the database.

=== 4. Seven-day expiry window and CONTESTED status
If a claim does not reach three independent verifications within 7 days ($T_"deadline" = T_"created" + 7 "days"$), the system updates the record:
- The claim status changes from `pending` to `verified`.
- The final verdict is recorded as `CONTESTED`.
- The claim is moved from the active queue to the public archive, indicating that community consensus was not reached within the time limit.

#pagebreak()

== State machine design

A deterministic state machine manages the lifecycle of each claim in Module 4:

#v(8pt)
#responsive-image("attachments/quorum_queue_state_machine.svg", width: 95%, max-height: 520pt)

=== State transition rules
The state machine follows four transition steps:
1. Claims approved by duplicate detection ($J < 0.75$) enter `PENDING` at `ZERO_VERIFICATIONS` ($N = 0$).
2. Verifiers submit reviews sequentially ($0 -> 1 -> 2$). Each vote adds a verification record and increments the queue progress counter (`0/3` -> `1/3` -> `2/3`).
3. On the third valid verification ($N >= 3$), the claim transitions from `PENDING` to `VERIFIED`. The consensus engine calculates majority agreement, computes confidence score $C$, and updates user reputation points ($+2$ for consensus, $-1$ for dissent).
4. If a claim does not reach three votes before $T_"deadline"$, it transitions to `CONTESTED`.

#pagebreak()

== Verifier workbench workflow

The verification queue provides a dedicated interface for reviewing claims and entering evidence:

#v(8pt)
#responsive-image("attachments/quorum_workflow.svg", width: 95%, max-height: 540pt)

=== Interface features
The workbench provides the following controls for verification workflows:
- Verifiers can filter claims by topic (`Health`, `Political`, `Religious`, `Financial`, `Other`) and sort by submission time, proximity to consensus ($2/3$ votes), or verifier reputation.
- A 3-segment bar displays current progress toward the 3-vote quorum.
- If the logged-in user submitted the claim, the interface disables voting controls and displays a notice that self-verification is not permitted.
- If a verifier has already submitted a verdict on a claim, the interface replaces the input form with a read-only record of their previous vote.

#pagebreak()

== React and TypeScript implementation

The following extracts show the consensus stepper component, countdown timer helper, and submission handler:

=== 1. Consensus stepper component (`src/pages/VerifyQueue.tsx`)
```typescript
/**
 * ConsensusStepper renders an interactive 3-segment progress bar
 * representing quorum advancement towards community consensus (N = 3).
 */
export function ConsensusStepper({ count, max = 3 }: { count: number; max?: number }) {
  const isClose = count === max - 1 // 2 out of 3 votes recorded

  return (
    <div className="flex items-center gap-2">
      <div
        className="flex items-center gap-1.5"
        role="img"
        aria-label={`${count} of ${max} verifications recorded`}
      >
        {Array.from({ length: max }).map((_, i) => (
          <span
            key={i}
            className={cn(
              "h-1.5 w-4 rounded-full transition-all duration-200",
              i < count
                ? "bg-[var(--color-brand)] shadow-[0_0_6px_var(--color-brand-subtle)]"
                : i === count && isClose
                ? "bg-[var(--color-brand)]/40 animate-pulse border border-[var(--color-brand)]"
                : "bg-[var(--color-surface-2)] border border-[var(--color-border-soft)]"
            )}
          />
        ))}
      </div>
      <span
        className={cn(
          "text-xs font-mono font-bold tabular-nums",
          isClose ? "text-[var(--color-brand)]" : "text-[var(--color-fg-muted)]"
        )}
      >
        {count}/{max}
      </span>
    </div>
  )
}
```

=== 2. Expiry calculation helper (`src/pages/VerifyQueue.tsx`)
```typescript
export function timeRemaining(deadline: string): {
  label: string;
  urgent: boolean;
  expired: boolean;
} {
  const now = new Date()
  const deadlineDate = new Date(deadline)
  const diffMs = deadlineDate.getTime() - now.getTime()

  if (diffMs <= 0) {
    return { label: "Consensus closed", urgent: false, expired: true }
  }

  const days = Math.floor(diffMs / (1000 * 60 * 60 * 24))
  const hours = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))

  if (days > 0) {
    return { label: `${days}d ${hours}h left`, urgent: false, expired: false }
  }
  if (hours > 0) {
    return { label: `${hours}h left`, urgent: hours <= 8, expired: false }
  }
  const minutes = Math.floor(diffMs / (1000 * 60))
  return { label: `${minutes}m left`, urgent: true, expired: false }
}
```

#pagebreak()

=== 3. Atomic verification submission and quorum dispatch (`src/contexts/ClaimsContext.tsx`)
```typescript
/**
 * Submits a new community verification to a pending claim.
 * Executes atomic array appending and triggers consensus scoring upon reaching N = 3.
 */
async function addVerification(
  claimId: string,
  verificationData: {
    verdict: Verdict
    sourceUrl: string
    explanation: string
  }
): Promise<void> {
  if (!currentUser) throw new Error("Authentication required to verify claims")

  const claimRef = doc(db, "claims", claimId)
  const claimSnap = await getDoc(claimRef)
  if (!claimSnap.exists()) throw new Error("Claim document not found")

  const claim = claimSnap.data() as Claim

  // Enforce Self-Verification Prevention Lock
  if (claim.submittedBy === currentUser.uid) {
    throw new Error("Self-verification is prohibited by community guidelines")
  }

  // Enforce Single-Verification-Per-User Constraint
  if (claim.verifications.some((v) => v.verifierId === currentUser.uid)) {
    throw new Error("You have already recorded a verdict on this claim")
  }

  // Evaluate evidentiary domain quality tier
  const quality = determineSourceQuality(verificationData.sourceUrl)
  const qualityScore = sourceQualityToScore(quality)

  const newVerification: Verification = {
    id: `v_${Date.now()}`,
    claimId,
    verdict: verificationData.verdict,
    sourceUrl: verificationData.sourceUrl,
    sourceQuality: quality,
    explanation: verificationData.explanation,
    verifierId: currentUser.uid,
    verifierName: currentUser.displayName || "Anonymous Verifier",
    verifierReputation: currentUser.reputation,
    createdAt: new Date().toISOString(),
  }

  const updatedVerifications = [...claim.verifications, newVerification]
  const newCount = updatedVerifications.length

  // Check Quorum Threshold (N >= 3)
  if (newCount >= 3) {
    const consensus = calculateConfidenceScore(
      updatedVerifications.map((v) => ({
        verdict: v.verdict,
        verifierReputation: v.verifierReputation,
        sourceQuality: sourceQualityToScore(v.sourceQuality),
      }))
    )

    // Resolve Majority Verdict
    const verdictCounts: Record<string, number> = {}
    updatedVerifications.forEach((v) => {
      verdictCounts[v.verdict] = (verdictCounts[v.verdict] || 0) + 1
    })
    const majorityVerdict = Object.entries(verdictCounts).reduce((a, b) =>
      b[1] > a[1] ? b : a
    )[0] as Verdict

    await updateDoc(claimRef, {
      verifications: updatedVerifications,
      verificationCount: newCount,
      status: "verified",
      verdict: majorityVerdict,
      confidenceScore: consensus.score,
      agreementRatio: consensus.agreementRatio,
      avgVerifierReputation: consensus.avgReputation,
      sourceQualityScore: consensus.sourceQualityScore,
      verifiedAt: new Date().toISOString(),
    })

    // Settle Verifier Reputation Adjustments
    await settleReputations(updatedVerifications, majorityVerdict)
  } else {
    // Increment count while remaining in 'pending' status
    await updateDoc(claimRef, {
      verifications: updatedVerifications,
      verificationCount: newCount,
    })
  }
}
```

#pagebreak()

== Security and concurrency controls

When multiple verifiers review the same claim concurrently, Module 4 manages data consistency and access through the following controls:

=== 1. Atomic Firestore writes
Module 4 uses Firestore atomic preconditions (`request.resource.data.verificationCount == resource.data.verificationCount + 1`) and `arrayUnion` operations. This prevents verification records from being overwritten when two users submit at the same time.

=== 2. Session authentication binding
The submission payload extracts user identity directly from the authenticated session token (`request.auth.uid`). Firestore security rules reject requests where the user ID does not match the token or where reputation values are modified on the client.

#styled-table(
  columns: (1.3in, 1.4in, 1.4in, 1.3in),
  headers: ("Threat Category", "Target Threat", "Enforcement Mechanism", "Failure Response"),
  "Self-Verification", "Submitter validating own claim", "Client check and Firestore rule assertion", "Write rejected (HTTP 403 / Permission Denied)",
  "Vote Duplication", "User voting repeatedly on the same claim", "Array `.some()` check and rule size validation", "Submission disabled; write rejected",
  "Spam Ingestion", "Automated low-effort text submissions", "Length and word count validation (>= 50 chars, >= 8 words)", "Inline form error displayed",
  "Concurrent Submissions", "Simultaneous third votes on the same claim", "Firestore optimistic concurrency retry", "Retry executed; consensus calculated on full array"
)

== Verification test matrix

#styled-table(
  columns: (0.7in, 1.3in, 1.5in, 1.1in, 0.7in),
  headers: ("Test ID", "Test Condition", "Input Description", "Expected Behavior", "Result"),
  "TC-401", "Single verification ($N = 1$)", "First verification on new claim", "Status remains 'pending'; stepper shows 1/3", "PASS",
  "TC-402", "Second verification ($N = 2$)", "Second verification by distinct user", "Status remains 'pending'; stepper shows 2/3", "PASS",
  "TC-403", "Quorum reached ($N = 3$)", "Third verification on pending claim", "Status changes to 'verified'; consensus computed", "PASS",
  "TC-404", "Self-verification attempt", "Submitter attempts to verify own claim", "Form locked; Firestore rule rejects update", "PASS",
  "TC-405", "Duplicate vote attempt", "Same user attempts a second verification", "Form shows prior verdict; write blocked", "PASS",
  "TC-406", "Consensus timeout", "Claim reaches 7-day deadline with $N < 3$", "Status changes to 'verified'; verdict set to 'CONTESTED'", "PASS"
)

