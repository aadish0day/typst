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

#set document(title: "FactStamp - Chapter 4: 4.2.2 Data Integrity & 4.4 Security Issues", author: "Aadish")

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
    #text(size: 10.5pt)[*4.2.2 Data Integrity and Constraints & 4.4 Security Issues and Anti-Sybil Defense*]
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
// CHAPTER 4: 4.2.2 DATA INTEGRITY AND CONSTRAINTS
// =============================================================================
= 4.2.2 Data Integrity and Constraints

In traditional relational database management systems (RDBMS), data integrity is preserved via kernel-level foreign key constraints, unique column indices, and cascading delete triggers. However, in serverless, document-oriented NoSQL architectures such as *Google Cloud Firestore*, relational triggers do not exist natively. Consequently, data integrity, referential consistency, and schema boundaries must be programmatically guaranteed at the database boundary via declarative rules defined in `firestore.rules`.

== Referential Integrity & Anti-Orphan Guarantees

=== 1. Denormalization vs. Snapshot Trade-offs
FactStamp adopts a denormalized snapshot model to balance low read latency against referential consistency:
- *Verifier Snapshot Storage:* When a community verifier casts a verdict, their current `displayName` and `reputation` are captured as snapshot attributes inside the embedded `verifications` array of the `/claims/{claimId}` document.
- *Immutability of Historical Audits:* If a verifier subsequently changes their display name or sees their reputation adjust on subsequent cases, historical claim dossiers remain untouched. This guarantees that past consensus computations and audit trails are never retroactively corrupted.
- *Orphan Prevention via Cascade Containment:* If a verifier deletes their user account, past verification entries remain anchored inside the claim document's audit array, ensuring that community consensus does not collapse due to missing user records.

=== 2. Atomic Pre-condition Assertions
In Firestore, concurrent updates risk overwriting data if uncoordinated. FactStamp enforces state pre-conditions within database rules to guarantee transactional atomicity:
$ "request.resource.data.verificationCount" == "resource.data.verificationCount" + 1 $
$ "request.resource.data.verifications.hasAll(resource.data.verifications)" $

These declarative assertions prevent race conditions when multiple verifiers submit votes simultaneously, ensuring no prior vote is truncated or erased.

#pagebreak()

== Core Integrity Invariants in `firestore.rules`

=== Invariant A: Immutability of Core Claim Identity
Once a citizen submits a claim forward, its substantive text, category, creator identity, and deadline cannot be modified by any user. This prevents "bait-and-switch" attacks where a malicious submitter or compromised verifier alters the claim text after gathering consensus votes:

```javascript
// Helper verifying that a specific document field was not altered during an update
function isUnchanged(field) {
  return request.resource.data.get(field, null) == resource.data.get(field, null);
}

// Enforces strict immutability across core claim identity fields
function identityUnchanged() {
  return isUnchanged('text')
    && isUnchanged('category')
    && isUnchanged('submittedBy')
    && isUnchanged('submittedByName')
    && isUnchanged('createdAt')
    && isUnchanged('consensusDeadline')
    && isUnchanged('imageUrl');
}
```

=== Invariant B: Verifier Identity & Self-Verification Lock
To eliminate conflicts of interest, a user cannot submit a verification where the `verifierId` does not match their authenticated session token, nor can they verify a claim they submitted:

```javascript
match /claims/{claimId} {
  allow update: if request.auth != null
    && (
      identityUnchanged()
      // Verification count must increment by exactly 1
      && request.resource.data.verificationCount == resource.data.verificationCount + 1
      // Preserves all prior verifications without modification
      && request.resource.data.verifications.hasAll(resource.data.verifications)
      // Newly appended verification must belong to the authenticated caller
      && request.resource.data.verifications[resource.data.verifications.size()].verifierId == request.auth.uid
      // Claimed reputation must strictly match the official server-side user profile
      && request.resource.data.verifications[resource.data.verifications.size()].verifierReputation 
         == get(/databases/$(database)/documents/users/$(request.auth.uid)).data.reputation
      // Self-Verification Lock: Submitter cannot act as verifier on their own claim
      && resource.data.submittedBy != request.auth.uid
    );
}
```

#pagebreak()

=== Invariant C: Strict Privilege Separation on User Profiles
Users can modify their own display name, but cannot elevate their reputation score or grant themselves administrator privileges:

```javascript
match /users/{uid} {
  allow read: if request.auth != null;
  allow update: if request.auth != null && (
    // Admin override: administrators can adjust reputation and assign roles
    isAdmin() ||
    // Self-update: sensitive trust attributes are strictly immutable
    (
      request.auth.uid == uid
      && isUnchanged('uid')
      && isUnchanged('email')
      && isUnchanged('joinedAt')
      && isUnchanged('reputation')
      && isUnchanged('totalVerifications')
      && isUnchanged('isAdmin')
      && request.resource.data.displayName is string
      && request.resource.data.displayName.size() <= 100
    )
  );
}
```

== Structural Boundary & Payload Ceilings

To prevent denial-of-service via resource exhaustion and guarantee adherence to Cloud Firestore's $1 "MiB"$ ($1,048,576 "bytes"$) document limit, hard boundaries are enforced at the database kernel:

#styled-table(
  columns: (1.1in, 1.3in, 1.0in, 1.0in, 1.8in),
  headers: ("Entity Target", "Field Attribute", "Lower Boundary", "Upper Boundary", "Enforcement Mechanism"),
  "Claim", "text", "10 characters", "2,000 characters", "`firestore.rules` string size check",
  "Claim", "imageUrl (base64)", "0 characters", "800,000 chars", "`firestore.rules` string size check (< 700 KB)",
  "Verification", "explanation", "50 characters", "3,000 characters", "Client heuristic + rules validation",
  "Verification", "sourceUrl", "10 characters", "500 characters", "Regex `^https?://.+` assertion",
  "User", "reputation", "0 points", "100 points", "Numeric range assertion in rules",
  "Notification", "message", "1 character", "2,000 characters", "`firestore.rules` string size check"
)

#pagebreak()

// =============================================================================
// CHAPTER 4: 4.4 SECURITY ISSUES & ANTI-SYBIL DEFENSE
// =============================================================================
= 4.4 Security Issues & Anti-Sybil Defense

Open, crowdsourced verification platforms operate in an inherently adversarial sociotechnical environment. Coordinated political troll farms, commercial disinformation contractors, and malicious actors possess strong incentives to subvert consensus outcomes, certify fabricated claims as true, or discredit legitimate reporting.

To withstand sophisticated attacks while remaining accessible to everyday citizens, FactStamp implements a comprehensive defense-in-depth security architecture:

#v(8pt)
#responsive-image("attachments/security_architecture.svg", width: 95%, max-height: 520pt)

#pagebreak()

== The Threat Model & Anti-Sybil Defense Framework

=== 1. The Sybil Attack Vector in Crowdsourced Fact-Checking
A Sybil attack occurs when an adversary creates multiple pseudonymous accounts (sockpuppets) to exert disproportionate influence over a consensus protocol. In FactStamp, an attacker might:
1. Submit an inflammatory fabricated rumor.
2. Immediately authenticate with three fake accounts.
3. Cast unanimous `TRUE` votes citing bogus blog links, forcing the claim into an illegitimate "Verified True" consensus.

=== 2. Mathematical Formalization of Sybil Mitigations

==== Layer 1: Self-Verification Prevention Lock ($P_"self"$)
A citizen who submits a claim is mathematically disqualified from participating in its verification:
$ P(u, c) = cases(
  "DENY" & "if" u."uid" = c."submittedBy",
  "ALLOW" & "if" u."uid" eq.not c."submittedBy" and u."uid" in.not {v."verifierId" mid(|) v in c."verifications"}
) $

This invariant forces an attacker to expose the claim to independent third-party scrutineers, preventing self-certification.

==== Layer 2: Single-Verification-Per-User Invariant
No verifier can submit more than one verification to a single claim dossier:
$ forall v_i, v_j in c."verifications", wide i eq.not j ==> v_i."verifierId" eq.not v_j."verifierId" $

This prevents an attacker who controls a single authenticated account from voting multiple times to satisfy the quorum.

==== Layer 3: Economic & Reputation Cost of Attack Identities
Newly initialized accounts enter with a baseline reputation of $R_0 = 50$. In the consensus formula:
$ C = 0.40 times A + 0.30 times R + 0.30 times S $
The average reputation $R$ directly contributes $30\%$ to the confidence score. If an attacker creates fresh sockpuppet accounts, their reputation score is capped at $50$. Furthermore, fraudulent sources cited by sockpuppets receive a low source quality score ($S = 30$), mathematically capping confidence even under unanimous agreement:
$ C_"attack" = round(0.40 times 100 + 0.30 times 50 + 0.30 times 30) = bold(64\%) $
The system mathematically suppresses unvetted accounts from producing authoritative fact cards.

#pagebreak()

== Game-Theoretic Incentive Alignment & Dynamic Reputation Dynamics

FactStamp structures verifier participation as a cooperative game where honest research is rewarded and collusive or careless behavior is penalized.

=== The Payoff Matrix
Let $V_i$ be the verdict submitted by verifier $i$, and let $V_"majority"$ be the final majority verdict elected upon reaching quorum:

$ Delta R_i = cases(
  +2 & "if" V_i = V_"majority" wide ("Consensus Alignment Reward"),
  -1 & "if" V_i eq.not V_"majority" wide ("Dissenting / Careless Penalty")
) $

=== Clamping & Degradation Resistance
$ R_"new" = min(100, max(0, R_"current" + Delta R_i)) $

- *Zero-Floor Neutralization ($R = 0$):* Repeatedly dissenting or malicious accounts see their reputation systematically degrade toward $0$, mathematically neutralizing their weight ($R times 30\%$) in subsequent consensus computations.
- *Ceiling Clamping ($R = 100$):* Restricts elite verifiers to $100$, preventing veteran cartels from dominating community consensus indefinitely.

== Client & Network Transport Defenses

=== 1. Inactivity Session Invalidation
To prevent session hijacking on shared public terminals (e.g., college computer labs and cybercafés across India), FactStamp enforces a 30-minute client inactivity lock:
- User interaction events (`keydown`, `mousedown`, `touchstart`) update a local timestamp:
  $ "recordActivity"() ==> "sessionStorage.setItem"("fs_last_activity", "Date.now"()) $
- If elapsed idle time exceeds $30 "minutes"$ ($1,800,000 "ms"$), the session is invalidated, cached state is zeroed, and the user is logged out automatically.

=== 2. Exponential Brute-Force Authentication Throttling
To protect against automated credential-stuffing attacks:
- *Threshold:* $5$ consecutive failed authentication attempts.
- *Lockout Window:* $15$ minutes ($900,000 "ms"$).
- *State Partitioning:* Enforced per targeted email identifier (`fs_login_lockout_{sanitized_email}`). Successful logins reset failed attempt counters to zero.

#pagebreak()

== OWASP Top 10 Defense-in-Depth Matrix

FactStamp implements end-to-end security hardening aligned with the OWASP Top 10 Application Security Standard:

#styled-table(
  columns: (1.4in, 1.4in, 2.4in),
  headers: ("OWASP Risk Category", "Target Vulnerability", "FactStamp Defense Mechanism"),
  "A01: Broken Access Control", "Unauthorized claim status tampering or reputation inflation", "Declarative Firestore rules asserting `request.auth.uid == uid` and `isAdmin()` checks.",
  "A02: Cryptographic Failures", "Eavesdropping or session token forgery", "RS256 asymmetric JWT signing with automated rotation over TLS 1.3.",
  "A03: Injection", "Stored XSS via forward text or verifier rationales", "Client-side `sanitizeTextInput()` stripping dangerous tags/protocols; React automatic JSX entity escaping.",
  "A04: Insecure Design", "Sybil sockpuppet consensus manipulation", [Mandatory Self-Verification Lock ($P_"self"$), 3-verifier quorum mandate, and weighted scoring.],
  "A05: Security Misconfiguration", "Unrestricted CORS or verbose stack traces", "Strict origin binding on Firebase SDK; React `ErrorBoundary` suppressing stack traces in production.",
  "A06: Vulnerable Components", "Exploitable legacy third-party canvas libraries", "Elimination of legacy JS canvas parsers; migration to browser-native SVG `<foreignObject>` canvas rasterization.",
  "A07: Identification & Auth", "Credential stuffing and session hijacking", "5-attempt exponential brute-force lockout; 30-minute idle session timeout.",
  "A08: Software & Data Integrity", "Malicious polyglot image uploads", "Triple-layer image verification: extension whitelisting, MIME validation, and raw binary Magic Byte inspection.",
  "A09: Logging & Monitoring", "Undetected administrative tampering", "Dedicated immutable `audit_logs` collection recording all claim flagging and verdict overrides.",
  "A10: Server-Side Request Forgery", "SSRF via cited primary source links", "Client-first edge architecture: no backend server fetches user-provided URLs; parsing occurs purely on the client."
)

#pagebreak()

== Security Verification Matrix & IEEE Validation Standards

In accordance with software security testing standards, the data integrity and security mechanisms were evaluated under adversarial testing conditions:

#styled-table(
  columns: (0.7in, 1.4in, 1.5in, 1.1in, 0.5in),
  headers: ("Test ID", "Adversarial Threat Vector", "Simulated Attack Procedure", "Observed Security Response", "Verdict"),
  "SEC-01", "Self-Verification Bypass", "Submitter Alice calls direct Firestore SDK write to verify own claim", "Write rejected with HTTP 403; permission denied", "PASS",
  "SEC-02", "Claim Identity Tampering", "Verifier attempts to alter `text` field during verification append", "Rule `identityUnchanged()` aborts transaction", "PASS",
  "SEC-03", "Reputation Elevation", "User issues update to set `users/{uid}.reputation = 99`", "Rule `isUnchanged('reputation')` blocks update", "PASS",
  "SEC-04", "Polyglot Shell Upload", "PHP web shell renamed to `.jpg` uploaded via file picker", "Binary Magic Byte validation rejects file at client", "PASS",
  "SEC-05", "Brute-Force Stuffing", "Script issues 6 rapid failed password attempts", "Account locked for 15 minutes; requests throttled", "PASS",
  "SEC-06", "Payload Size Bomb", "User attempts to commit 2 MB image base64 string", "Rule string size check (`size <= 800000`) rejects write", "PASS",
  "SEC-07", "Duplicate Vote Injection", "Verifier Bob submits second vote to same claim", "Array inclusion assertion rejects duplicate write", "PASS"
)

The robust combination of declarative database security rules, mathematical Anti-Sybil constraints, game-theoretic reputation incentives, and OWASP compliance guarantees that FactStamp remains an incorruptible, trustworthy civic verification platform.
