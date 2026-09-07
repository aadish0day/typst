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

#set document(title: "FactStamp - Chapter 4: 4.5 Test Cases Design (Draft)", author: "Aadish")

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
    #text(size: 12pt, weight: "bold")[CHAPTER 4: SYSTEM DESIGN]
    #v(2pt)
    #text(size: 10.5pt)[*4.5 Test Cases Design (Draft Specifications)*]
    #v(6pt)
    #text(size: 10pt)[Submitted in Partial Fulfilment of the Requirements for Course *JUSIT-DSCPR503*]\
    #text(size: 11.5pt, weight: "bold")[Bachelor of Science in Information Technology]\
    #v(10pt)
    #text(size: 10pt)[*Candidate:* Aadish (UID: 2023IT001)]\
    #text(size: 10pt)[*Department of Information Technology*]\
    #text(size: 11pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai – 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025–2026]
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
// CHAPTER 4.5: TEST CASES DESIGN (DRAFT)
// =============================================================================
= 4.5 Test Cases Design (Draft)

== Formal Testing Methodology & IEEE 829-2008 Framework
Test case design constitutes the formal verification and validation blueprint for *FactStamp*. In accordance with *IEEE Std 829-2008* (Standard for Software and System Test Documentation) and University of Mumbai dissertation guidelines, this document articulates the exhaustive test specifications formulated to validate all core functional, security, mathematical, and algorithmic subcomponents of the platform.

Crowdsourced fact-checking applications deployed in adversarial sociotechnical contexts demand testing procedures that extend far beyond superficial happy-path functional assertions. The FactStamp testing suite is engineered around three rigorous testing dimensions:

1. *Adversarial Security Hardening:* Verification of binary magic byte validation, polyglot shell injection rejection, self-verification permission locks, and brute-force lockout defenses.
2. *Mathematical Invariant Verification:* Validation of Jaccard set-theoretic duplicate classification thresholds ($J >= 0.75$), 3-verifier weighted consensus score calculations ($40A + 30R + 30S$), and reputation equity boundary clamping ($[0, 100]$).
3. *Systemic Boundary & Performance Compliance:* Verification of client-side image compression payload bounds ($< 700 "KB"$), 7-day temporal state expiry transitions, and high-DPI rasterization visual fidelity without CSS color parser corruption.

== Master Summary Specification Index

#styled-table(
  columns: (0.7in, 1.4in, 1.6in, 1.1in, 0.6in),
  headers: ("Test ID", "Architectural Module", "Primary Verification Target", "Testing Strategy", "Severity"),
  "TC-01", "Module 1: Auth & Reputation", "User Authentication & JWT Session Establishment", "Positive Functional", "High",
  "TC-02", "Module 2: Ingestion & OCR", "Image Magic Byte Inspection & Polyglot File Rejection", "Adversarial Security", "Critical",
  "TC-03", "Module 2: Ingestion & OCR", "Client Canvas Compression Payload Ceiling (< 700 KB)", "Boundary & Performance", "High",
  "TC-04", "Module 3: Duplicate Engine", "Jaccard Duplicate Interception & Dossier Rerouting ($J >= 0.75$)", "Algorithmic Precision", "Critical",
  "TC-05", "Module 3: Duplicate Engine", "Jaccard Distinct Novel Submission Acceptance ($J < 0.75$)", "Boundary Functional", "High",
  "TC-06", "Module 8: Security & Rules", [Self-Verification Prevention Lock ($P_"self"$)], "Adversarial Authorization", "Critical",
  "TC-07", "Module 4: Quorum Queue", "Single-Verification-Per-User Invariant", "Integrity Assertion", "High",
  "TC-08", "Module 5: Consensus Engine", "3-Verifier Weighted Consensus & Confidence Calculation", "Multi-Factor Mathematical", "Critical",
  "TC-09", "Module 4: Quorum Queue", "Consensus Window Expiry & CONTESTED Status Transition", "Temporal State Machine", "Medium",
  "TC-10", "Module 6: Fact Card Gen", "High-DPI PNG Card Rasterization via `html-to-image`", "Rendering Fidelity", "High"
)

#pagebreak()

== Detailed Test Case Specifications

=== TC-01: User Authentication & JWT Session Establishment
- *Module:* Module 1: Authentication & Verifier Reputation Subsystem
- *Objective:* Verify that a registered community verifier can authenticate with valid email/password credentials, establish a cryptographically signed Firebase session, and receive an RS256 JWT token populating client state.
- *Pre-conditions:*
  1. Test user account exists in Firebase Authentication (`verifier1@factstamp.app`).
  2. Corresponding document exists in Firestore `/users/{uid}` with `reputation: 50` and `totalVerifications: 0`.
  3. Client application has active internet connectivity to Google Identity Toolkit.
- *Test Input Data:*
  - Email: `verifier1@factstamp.app`
  - Password: `ValidPassword#2026`
- *Execution Procedure:*
  1. Navigate to the `/signin` route.
  2. Input test email and password into their respective input fields.
  3. Click the "Sign In" button.
  4. Inspect browser Network tab for `verifyPassword` response payload.
  5. Inspect `AuthContext` state and local `sessionStorage`.
- *Expected Outcome:*
  - Firebase Auth returns HTTP 200 containing valid `idToken` (RS256 JWT) and `refreshToken`.
  - Application navigates to `/verify` queue with active session header displaying user name and initial reputation badge `50`.
- *Quantitative Pass Criteria:* Session establishment completes in $<= 1200 "ms"$; user UID correctly binds to React context without unhandled exceptions.

---

=== TC-02: Image Magic Byte Verification & Polyglot File Rejection
- *Module:* Module 2: Multimodal Forward Ingestion & Preprocessing Subsystem
- *Objective:* Validate that the triple-layer upload security pipeline detects and rejects disguised malicious files (e.g., PHP web shells renamed with `.jpg` extension or spoofed MIME header) by inspecting raw binary magic bytes.
- *Pre-conditions:* User is on `/submit` page with the "Upload Screenshot" tab active.
- *Test Input Data:*
  - File Name: `exploit_payload.jpg`
  - Reported MIME Type: `image/jpeg`
  - Actual File Content: ASCII string `<?php phpinfo(); ?>` (Binary bytes: `0x3C 0x3F 0x70 0x68`, lacking JPEG marker `0xFF 0xD8 0xFF`).
- *Execution Procedure:*
  1. Drag and drop `exploit_payload.jpg` into the submission dropzone.
  2. Observe execution of `validateImageUpload()` in `src/lib/security.ts`.
  3. Inspect console output and UI toast notifications.
- *Expected Outcome:*
  - File upload is halted immediately before canvas initialization or Firestore transmission.
  - Toast alert triggers: *"File content does not match a valid image format. The file may be corrupted or disguised."*
  - File dropzone resets to empty state.
- *Quantitative Pass Criteria:* Exactly zero network packets transmitted to Firestore; binary header mismatch successfully halts upload pipeline.

#pagebreak()

=== TC-03: Client-Side Image Compression Payload Ceiling (< 700 KB)
- *Module:* Module 2: Multimodal Forward Ingestion & Preprocessing Subsystem
- *Objective:* Verify that an uploaded high-resolution mobile screenshot (up to $5 "MB"$) is iteratively downscaled client-side via HTML5 canvas stepping to produce a base64 JPEG payload strictly under $700 "KB"$ ($700,000 "bytes"$).
- *Pre-conditions:* Valid JPEG smartphone screenshot selected ($3840 times 2160 "px"$, size $4.8 "MB"$).
- *Test Input Data:* File `viral_newspaper_clip.jpg` ($4.8 "MB"$, binary JPEG header verified).
- *Execution Procedure:*
  1. Select file via file picker on `/submit`.
  2. Execute `compressImageToDataUrl(file)` in `src/lib/imageCompression.ts`.
  3. Log dimensions of off-screen canvas and byte size of returned base64 string.
- *Expected Outcome:*
  - Image is proportionally downscaled so $max("width", "height") <= 1280 "px"$.
  - Quality iteratively steps down from $0.72$ until `estimateBytes(dataUrl) <= 700000`.
  - Returned base64 data URL string size is between $150 "KB"$ and $650 "KB"$.
- *Quantitative Pass Criteria:* Estimated bytes $<= 700,000 "bytes"$; text in screenshot remains legible; processing time $< 1500 "ms"$ on standard hardware.

---

=== TC-04: Jaccard Similarity Duplicate Re-routing ($J >= 0.75$)
- *Module:* Module 3: Jaccard Duplicate Detection Engine
- *Objective:* Verify that submitting a forward with syntactic variations of an existing verified claim yields Jaccard similarity $J >= 0.75$, triggering automated duplicate detection and redirecting the user to the existing claim.
- *Pre-conditions:*
  1. Claim `c_seed_1` exists in database: \
     _"Drinking boiled ginger water with lemon twice daily permanently cures Type 2 Diabetes within 14 days."_
- *Test Input Data:*
  - Incoming Text: _"Drinking hot boiled ginger water with lemon twice daily cures Type 2 Diabetes permanently in 14 days! Forward to all."_
- *Execution Procedure:*
  1. Navigate to `/submit`.
  2. Paste test input string into claim textarea.
  3. Select Category: `Health`.
  4. Click "Submit Claim".
  5. Inspect execution of `findDuplicate(text, existingClaims)`.
- *Expected Outcome:*
  - Filtered token sets yield: $|A| = 13$, $|B| = 13$, $|A inter B| = 12$, $|A union B| = 14$.
  - Calculated similarity: $J = frac(12, 14) approx 0.857 >= 0.75$.
  - Duplicate detection triggers toast: *"Duplicate claim detected (86% match). Redirecting to existing verification dossier..."*
  - Browser redirects to `/claim/c_seed_1`; no new document is written to Firestore.
- *Quantitative Pass Criteria:* Similarity calculated accurately ($J = 0.86 plus.minus 0.01$); zero redundant Firestore writes.

#pagebreak()

=== TC-05: Jaccard Distinct Novel Submission Acceptance ($J < 0.75$)
- *Module:* Module 3: Jaccard Duplicate Detection Engine
- *Objective:* Verify that a novel forward sharing only minimal common words with existing claims yields $J < 0.75$ and is accepted into the verification queue as a new pending claim.
- *Pre-conditions:* Database populated with existing health claims concerning diabetes.
- *Test Input Data:*
  - Incoming Text: _"Government announces new solar subsidy scheme for farmers across Maharashtra starting October."_
  - Category: `Other`
- *Execution Procedure:*
  1. Navigate to `/submit`.
  2. Enter novel claim text and select category.
  3. Click "Submit Claim".
  4. Inspect `findDuplicate()` return value and subsequent Firestore write.
- *Expected Outcome:*
  - Similarity against existing corpus yields $max_k J(A, B_k) = 0.00 < 0.75$.
  - System executes `addClaim()`, generating a new unique ID (e.g., `c104`).
  - Claim document created in Firestore `/claims/c104` with `status: 'pending'` and `verificationCount: 0`.
  - User redirected to `/verify` queue view where the new claim appears immediately.
- *Quantitative Pass Criteria:* Claim commits to database; appears on `/verify` queue via real-time snapshot listener in $< 800 "ms"$.

---

=== TC-06: Self-Verification Prevention Lock ($P_"self"$)
- *Module:* Module 8: Security & Anti-Sybil Defense Subsystem
- *Objective:* Verify that a citizen who submitted a claim cannot act as a verifier on their own submission, enforced both in the UI and at the database security rule layer.
- *Pre-conditions:*
  1. User Alice (`uid_alice`) submits claim `c201`.
  2. User Alice is currently authenticated.
- *Test Input Data:* Target Claim ID `c201` (`submittedBy: 'uid_alice'`), Verification verdict `FALSE`, Source `https://pib.gov.in`.
- *Execution Procedure:*
  1. Alice navigates directly to `/verify/c201`.
  2. Inspect UI workbench controls.
  3. Attempt direct Firestore update via emulator console/SDK simulating bypassed UI:
     `db.collection('claims').doc('c201').update({ verifications: [...] })`
- *Expected Outcome:*
  - UI displays an informational notice: *"You submitted this claim. Community guidelines prohibit self-verification."*
  - Verification submission form and "Submit Verdict" button are disabled.
  - Direct database write is rejected with `FirebaseError: Missing or insufficient permissions` due to `resource.data.submittedBy != request.auth.uid` assertion in `firestore.rules`.
- *Quantitative Pass Criteria:* Both UI and backend security rules block self-verification with zero state modification.

#pagebreak()

=== TC-07: Single-Verification-Per-User Invariant
- *Module:* Module 4: Decentralized Quorum Verification Queue
- *Objective:* Verify that a verifier who has already cast a verdict on a pending claim cannot submit a second verification to the same claim dossier.
- *Pre-conditions:*
  1. Verifier Bob (`uid_bob`) has successfully verified claim `c301` once.
  2. Claim `c301` is still pending ($N = 1 < 3$).
- *Test Input Data:* Target Claim `c301`, Second verification payload from `uid_bob`.
- *Execution Procedure:*
  1. Verifier Bob navigates to `/verify/c301`.
  2. Attempt to cast a second verdict.
- *Expected Outcome:*
  - System detects `claim.verifications.some(v => v.verifierId === 'uid_bob')`.
  - UI renders the "Verdict Recorded" read-only confirmation screen.
  - Submit button is inaccessible.
- *Quantitative Pass Criteria:* A verifier is restricted to exactly one vote per claim ID; quorum count cannot be inflated by duplicate votes from the same user.

---

=== TC-08: 3-Verifier Weighted Consensus & Confidence Calculation
- *Module:* Module 5: Weighted Confidence Scoring & Consensus Engine
- *Objective:* Verify that when the 3rd independent verification is recorded, the consensus engine accurately computes majority verdict, agreement ratio, average reputation, average source quality, and final weighted confidence score.
- *Pre-conditions:*
  1. Pending claim `c401` has 2 recorded verifications:
     - V1: Verdict `FALSE`, Reputation $80$, Source `who.int` (Score $100$)
     - V2: Verdict `FALSE`, Reputation $60$, Source `thehindu.com` (Score $70$)
- *Test Input Data:*
  - Incoming 3rd Verification (V3):
    - Verifier: Reputation $70$
    - Verdict: `MISLEADING`
    - Source: `pib.gov.in` (Score $100$)
    - Explanation: 75-character verified rationale.
- *Execution Procedure:*
  1. Submit V3 via `/verify/c401`.
  2. Trigger `calculateConfidenceScore(verifications)` in `ClaimsContext`.
  3. Inspect updated claim document attributes in Firestore.
- *Expected Outcome:*
  - Total Verifications: $N = 3 >= 3 ==> "status transitions to 'verified'"$.
  - Majority Verdict: 2 $times$ `FALSE` vs 1 $times$ `MISLEADING` $==>$ *FALSE*.
  - Agreement Ratio: $A = frac(2, 3) times 100 = 66.67\%$.
  - Average Reputation: $R = frac(80 + 60 + 70, 3) = 70.00$.
  - Average Source Quality: $S = frac(100 + 70 + 100, 3) = 90.00$.
  - Weighted Confidence Score:
    $ C = round(0.40 times 66.67 + 0.30 times 70.00 + 0.30 times 90.00) = round(26.67 + 21.00 + 27.00) = bold(75\%) $
  - Reputation adjustments: V1 and V2 receive $+2$ points; V3 receives $-1$ point.
- *Quantitative Pass Criteria:* Status updates to `verified`; verdict is `FALSE`; confidence score is exactly $75$; reputation deltas persist accurately.

#pagebreak()

=== TC-09: Consensus Window Expiry & CONTESTED Status Transition
- *Module:* Module 4: Decentralized Quorum Verification Queue
- *Objective:* Verify that a pending claim that fails to reach the 3-verifier quorum within $7$ days is transitioned to `status: 'verified'` with `verdict: 'CONTESTED'`.
- *Pre-conditions:*
  1. Claim `c501` created with `consensusDeadline` set to a timestamp in the past ($T_"now" - 1 "hour"$).
  2. Verification count is $1$ ($< 3$).
- *Test Input Data:* Overdue Claim `c501` (`verificationCount: 1`, `status: 'pending'`).
- *Execution Procedure:*
  1. Trigger periodic expiry check worker: `expireOverdueClaims()`.
  2. Inspect updated claim attributes in Firestore.
- *Expected Outcome:*
  - Claim status updates from `'pending'` to `'verified'`.
  - Verdict is set to `'CONTESTED'`.
  - Claim disappears from the active verification queue and appears in the public resolved claim registry under the Contested filter.
- *Quantitative Pass Criteria:* Overdue claims resolve cleanly without user interaction; status transitions to `CONTESTED`.

---

=== TC-10: High-DPI Fact-Check PNG Card Rasterization (`html-to-image`)
- *Module:* Module 6: High-Fidelity Fact-Check Card Generator
- *Objective:* Verify that clicking "Download Fact Card" on a verified claim captures the live DOM component using `html-to-image`, correctly renders OKLCH design tokens via browser-native SVG `<foreignObject>`, and triggers a PNG download at $1080 times 1080 "px"$ resolution without throwing CSS parser exceptions.
- *Pre-conditions:*
  1. Claim `c_seed_1` is in `verified` status with verdict `FALSE` and confidence `94%`.
  2. User is on `/claim/c_seed_1`.
- *Test Input Data:*
  - Target DOM Element: `<div id="fact-check-card">`
  - Export Options: `{ pixelRatio: 2, backgroundColor: '#fffbf5', cacheBust: true }`
- *Execution Procedure:*
  1. Click "Download Fact-Check Card" button.
  2. Monitor browser console for unhandled promise rejections or CSS parsing errors.
  3. Inspect downloaded image file in local operating system.
- *Expected Outcome:*
  - Zero `oklab`/`oklch` syntax errors in console.
  - Image file `factstamp-c_seed_1.png` is downloaded to user's device.
  - Image dimensions are exactly $1080 times 1080 "px"$.
  - Visual output contains the tilted verdict stamp, confidence bar, claim text, and sources with crisp text and zero layout truncation.
- *Quantitative Pass Criteria:* Successful PNG generation in $< 1200 "ms"$; exported dimensions $1080 times 1080 "px"$; zero color corruption.

#pagebreak()

== Requirements Traceability Matrix (RTM)

The Requirements Traceability Matrix maps each formal functional requirement defined in IEEE Std 830-1998 Software Requirements Specification (SRS) to its corresponding validation test case:

#styled-table(
  columns: (0.8in, 1.5in, 0.8in, 1.4in, 0.7in),
  headers: ("Req ID", "Requirement Description", "Test ID", "Target Subsystem", "Coverage"),
  "REQ-01", "Dual-Channel Plaintext & Screenshot Intake", "TC-02, TC-03", "Module 2 (Ingestion & OCR)", "Full",
  "REQ-02", "In-Browser Client-Side Image Compression (< 700 KB)", "TC-03", "Module 2 (Ingestion & OCR)", "Full",
  "REQ-03", "Set-Theoretic Jaccard Duplicate Rerouting (>= 0.75)", "TC-04, TC-05", "Module 3 (Duplicate Engine)", "Full",
  "REQ-04", "Decentralized Quorum Assembly (N >= 3 Verifiers)", "TC-07, TC-08", "Module 4 (Quorum Queue)", "Full",
  "REQ-05", "Mandatory Evidence Citation & Rationalization", "TC-08", "Module 4 (Quorum Queue)", "Full",
  "REQ-06", "Tri-Partite Weighted Consensus Confidence Scoring", "TC-08", "Module 5 (Consensus Engine)", "Full",
  "REQ-07", "Dynamic Verifier Trust Accounting (+2 / -1 Deltas)", "TC-08", "Module 1 (Auth & Reputation)", "Full",
  "REQ-08", "7-Day Consensus Temporal Expiry (Contested Transition)", "TC-09", "Module 4 (Quorum Queue)", "Full",
  "REQ-09", "1080x1080 PNG Fact-Check Card DOM Rasterization", "TC-10", "Module 6 (Fact Card Gen)", "Full",
  "REQ-10", "Self-Verification Prevention & Sybil Hardening", "TC-01, TC-06", "Module 8 (Security & Anti-Sybil)", "Full"
)

== Defect Severity Hierarchy & Remediation Protocol

To ensure structured triage during implementation and testing phases, defects identified during test execution are categorized under a four-tier severity hierarchy:

#styled-table(
  columns: (0.9in, 1.5in, 1.5in, 1.3in),
  headers: ("Severity Level", "Classification Definition", "FactStamp Impact Example", "Remediation SLA"),
  "Critical (S1)", "Complete compromise of security, consensus math, or data corruption.", "Bypassed self-verification lock; Jaccard false-positive deleting novel claims.", "Immediate blocker (< 4 hours).",
  "High (S2)", "Core workflow impairment with no immediate client workaround.", "Image compression exceeds 700 KB causing Firestore write rejection.", "Must fix within current sprint (< 24 hours).",
  "Medium (S3)", "Non-blocking functional defect or visual layout imperfection.", "Consensus countdown timer displays incorrect hour offset on mobile.", "Fix in scheduled patch release (< 72 hours).",
  "Low (S4)", "Minor cosmetic flaw or phrasing inconsistency.", "Monogram avatar fallback letter slightly misaligned on small screens.", "Backlog enhancement."
)

This comprehensive draft test specification establishes the rigorous quality assurance foundation mandated for FactStamp's project dissertation and production readiness.
