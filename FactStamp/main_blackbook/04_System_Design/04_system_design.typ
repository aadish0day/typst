#import "../lib/helpers.typ": *

= System design

== Basic modules

*1. Authentication and Reputation Module*

Users register and sign in with email/password or Google through Firebase Authentication. A new profile starts with a reputation of 50, which only the server-side Cloud Function can change: +2 when a verdict matches the final verdict and -1 when it does not.

*2. Claim Submission Module*

The Submit page accepts a claim as text or as a screenshot. A screenshot is compressed in the browser, read with Tesseract.js OCR, and cleaned of WhatsApp timestamps and status text, and the user can edit the result before submitting.

*3. Duplicate Detection Module*

Before a claim is saved, its words are compared with recent claims using Jaccard similarity. A match of 0.75 or higher blocks the submission and links to the existing claim; otherwise a new pending claim is created with a 7-day deadline.

*4. Verification Queue Module*

Signed-in users see pending claims they are allowed to verify. A verifier chooses TRUE, FALSE, MISLEADING, or UNVERIFIABLE, adds a source URL and an explanation, and the verification is added to the claim. Users cannot verify their own claims or verify the same claim twice.

*5. Consensus Module*

When a claim has three verifications, the majority verdict is settled and the confidence score is calculated as 40% agreement, 30% average reputation, and 30% source quality. Claims still short of three verifications after 7 days can be settled as CONTESTED by an administrator.

*6. Fact-Check Card Module*

The claim page shows the verdict, confidence score, and sources, and exports them as a 1080 px wide PNG card using html-to-image.

*7. Analytics Dashboard Module*

The public dashboard shows weekly claim trends by category, the most debunked claims, the most active verifiers, and the number of claims closed without quorum.

*8. Security and Notifications Module*

This module sanitizes input, validates uploaded images, times out idle sessions, and sends in-app notifications when a claim is settled. Firestore Security Rules check every database write on the server.

*9. Admin Module*

The unlisted `/admin` console lets administrators manage users, moderate claims, handle incident reports, run consensus expiry, and view the audit log.

#pagebreak()
== Data design

FactStamp stores its data in Cloud Firestore in six collections: `users`, `claims`, `claim_media`, `notifications`, `reports`, and `audit_logs`.

#heading(level: 3, outlined: true)[Schema design]
<fig-schema>

*users*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "uid", "string", "Unique user ID", [*Yes*],
  "displayName", "string", "User name", "No",
  "email", "string", "Email address", "No",
  "avatarUrl", "string", "Profile picture (optional)", "No",
  "reputation", "number", "Reputation score, 0 to 100 (starts at 50)", "No",
  "totalVerifications", "number", "Number of verdicts given", "No",
  "isAdmin", "boolean", "Administrator flag", "No",
  "joinedAt", "string", "Account creation date", "No",
)

*claims*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique claim ID", [*Yes*],
  "text", "string", "Claim text (10 to 2000 characters)", "No",
  "category", "string", "Health, political, religious, financial, or other", "No",
  "status", "string", "Pending or verified", "No",
  "verdict", "string", "TRUE, FALSE, MISLEADING, UNVERIFIABLE, or CONTESTED", "No",
  "confidenceScore", "number", "Confidence score, 0 to 100", "No",
  "verifications", "array", "Verifications given for the claim", "No",
  "verificationCount", "number", "Number of verifications", "No",
  "submittedBy", "string", "ID of the user who submitted it", "No",
  "consensusDeadline", "string", "Date 7 days after submission", "No",
  "thumbnailUrl", "string", "Small screenshot preview (optional)", "No",
  "adminFlagged", "boolean", "Marked for faster review", "No",
  "createdAt", "string", "Submission date", "No",
  "verifiedAt", "string", "Date the verdict was settled", "No",
)

*Verification (stored inside a claim)*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique verification ID", [*Yes*],
  "verdict", "string", "TRUE, FALSE, MISLEADING, or UNVERIFIABLE", "No",
  "sourceUrl", "string", "Link to the evidence", "No",
  "sourceQuality", "string", "High, medium, or low", "No",
  "explanation", "string", "Verifier's reasoning", "No",
  "verifierId", "string", "ID of the verifier", "No",
  "verifierReputation", "number", "Verifier's reputation when voting", "No",
  "createdAt", "string", "Date of the verification", "No",
)

*claim_media*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "claimId", "string", "ID of the claim", [*Yes*],
  "imageUrl", "string", "Full screenshot image", "No",
  "createdAt", "string", "Upload date", "No",
)

*notifications*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique notification ID", [*Yes*],
  "userId", "string", "User who receives it", "No",
  "type", "string", "Kind of notification", "No",
  "title", "string", "Notification title", "No",
  "message", "string", "Notification text", "No",
  "isRead", "boolean", "Whether it has been read", "No",
  "createdAt", "string", "Date sent", "No",
)

*reports*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique report ID", [*Yes*],
  "targetType", "string", "Claim, user, or verification", "No",
  "targetId", "string", "ID of the reported item", "No",
  "reason", "string", "Reason for the report", "No",
  "severity", "string", "Low, medium, or high", "No",
  "status", "string", "Pending, investigating, resolved, or dismissed", "No",
  "reportedBy", "string", "ID of the admin who filed it", "No",
  "reportedAt", "string", "Date filed", "No",
)

*audit_logs*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique log ID", [*Yes*],
  "adminId", "string", "Admin who performed the action", "No",
  "action", "string", "Action performed", "No",
  "targetType", "string", "Claim, user, report, or system", "No",
  "targetId", "string", "ID of the affected item", "No",
  "details", "string", "Extra information", "No",
  "timestamp", "string", "Date and time of the action", "No",
)

#heading(level: 3, outlined: true)[Data integrity and constraints]

Firestore Security Rules check every write on the server, so invalid data is rejected even if someone bypasses the web interface. The main constraints are:

- A new claim must have 10 to 2000 characters of text, a valid category, pending status, and no verifications.
- The submitter's ID and name must belong to the signed-in user.
- Each write may add exactly one verification, from a user who has not already verified the claim and did not submit it.
- A claim cannot hold more than three verifications.
- A verifier's recorded reputation must match their real profile.
- Claim text, category, submitter, and dates cannot be changed after creation, except by an administrator.
- Users can read only their own profile; only administrators can read all profiles or change admin rights.
- Reputation can only be changed by the Cloud Function.
- Audit log entries can never be edited or deleted.

#pagebreak()
== User interface design

*1. Home:* Introduction · Submit a claim · Browse the queue

#v(1em)
#figure(
  image("attachments/wireframe_home.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Home Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-home>

*2. Submit:* Text or screenshot · OCR · Category · Duplicate warning

#v(1em)
#figure(
  image("attachments/wireframe_submit.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Submit Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-submit>

*3. Verify Queue:* Claim cards · Progress · Deadline · Filters

#v(1em)
#figure(
  image("attachments/wireframe_verify_queue.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Verify Queue],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-queue>

*4. Verify Detail:* Claim · Verdict · Source URL · Explanation

#v(1em)
#figure(
  image("attachments/wireframe_verify_detail.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Verify Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-detail>

*5. Claim Detail:* Verdict · Confidence score · Sources · Download card

#v(1em)
#figure(
  image("attachments/wireframe_claim_detail.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Claim Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-claim-detail>

*6. Dashboard:* Statistics · Category chart · Weekly trends · Top verifiers

#v(1em)
#figure(
  image("attachments/wireframe_dashboard.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Dashboard],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-dashboard>

*7. Profile:* Reputation · Tier · History

#v(1em)
#figure(
  image("attachments/wireframe_profile.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Profile],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-profile>

*8. Admin Console:* Overview · Verifiers · Claims · Incidents · Audit and Tools

#v(1em)
#figure(
  image("attachments/wireframe_admin.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Admin Console],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-admin>

#pagebreak()
== Security issues

Because FactStamp lets the public submit and judge claims, security is enforced both in the browser and on the server. Browser checks give quick feedback, while Firestore Security Rules protect the data even if someone bypasses the web interface.

*Security Measures Implemented*

1. *Managed authentication:* Firebase Authentication handles passwords and Google sign-in, so the application never stores passwords.
2. *Server-side rules:* Firestore Security Rules validate every write, including one verdict per verifier, no self-verification, and at most three verifications.
3. *Role-based access:* Only administrators can open the admin console, change other users, or read all profiles.
4. *Trusted reputation:* Reputation is changed only by a Cloud Function, never by the browser.
5. *Login cooldown:* After 5 failed sign-in attempts the account is locked for 15 minutes in the browser, backed by Firebase's own server-side throttling.
6. *Session timeout:* Users are signed out after 30 minutes of inactivity.
7. *Upload validation:* Images are checked by size (up to 5 MB), extension, file type, and file signature.
8. *Input sanitization:* Text is cleaned of scripts and dangerous HTML before it is saved or shown.
9. *Spam filtering:* Verdict explanations must have at least 50 characters and 8 words and must not copy the claim.
10. *Audit log:* Every admin action is recorded in a log that cannot be edited or deleted.

#pagebreak()
== Test cases design

#styled-table(
  columns: (1.2fr, 1.4fr, 1.9fr),
  headers: ("Test Condition", "Input", "Expected Result"),
  "User registration", "Valid name, email, and password", "Account created with reputation 50",
  "User login", "Correct email and password", "Signed in successfully",
  "User login", "Wrong password", "Error message shown",
  "Repeated failed login", "5 wrong passwords", "Sign-in locked for 15 minutes",
  "Submit text claim", "Valid claim text and category", "Claim created as pending",
  "Submit screenshot", "JPEG/PNG under 5 MB", "Text extracted and shown for review",
  "Upload invalid file", "Renamed non-image file", "Upload rejected",
  "Duplicate claim", "Text similar to an existing claim", "Submission blocked with link to existing claim",
  "Submit verdict", "Verdict, source URL, and explanation", "Verification saved",
  "Short explanation", "Explanation under 50 characters", "Validation message shown",
  "Verify own claim", "Submitter opens their own claim", "Verification not allowed",
  "Third verification", "Third valid verdict", "Claim verified with verdict and score",
  "Overdue claim", "Admin runs expiry after 7 days", "Claim settled as CONTESTED",
  "Download card", "Click Download on a verified claim", "PNG card downloaded",
  "Admin access", "Non-admin opens /admin", "Access denied",
  "Admin override", "Admin changes a verdict", "Claim updated and action logged",
)
