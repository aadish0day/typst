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

Once a claim is settled, its page brings together the verdict, the confidence score, and the cited sources. From there the reader can export the whole thing as a 1080 px wide PNG card, generated with html-to-image, and forward it back into WhatsApp.

*7. Analytics Dashboard Module*

The dashboard is open to anyone, with no sign-in. It follows how many claims arrive each week in each category, which claims have been debunked most, who the most active verifiers are, and how many claims closed without ever reaching a quorum.

*8. Security and Notifications Module*

Cutting across the others is a layer that cleans user input, checks uploaded images, and ends idle sessions, while the Firestore Security Rules enforce the same limits on the server. This layer also raises the notification a user sees when their claim is settled.

*9. Admin Module*

Administrators work from an unlisted `/admin` console. There they manage accounts, moderate or override claims, work through incident reports, trigger consensus expiry on overdue claims, and read the audit log of what other administrators have done.

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
  "agreementRatio", "number", "Agreement ratio among verifiers (used in score)", "No",
  "avgVerifierReputation", "number", "Average reputation of the verifiers (used in score)", "No",
  "sourceQualityScore", "number", "Average source quality of the verifications (used in score)", "No",
  "verifications", "array", "Verifications given for the claim", "No",
  "verificationCount", "number", "Number of verifications", "No",
  "submittedBy", "string", "ID of the user who submitted it", "No",
  "submittedByName", "string", "Display name of the submitter", "No",
  "consensusDeadline", "string", "Date 7 days after submission", "No",
  "consensusDeadlineMs", "number", "Deadline as epoch milliseconds (used by security rules)", "No",
  "hasScreenshot", "boolean", "Whether the claim has an attached screenshot", "No",
  "thumbnailUrl", "string", "Small screenshot preview (optional)", "No",
  "imageUrl", "string", "Legacy inline screenshot before claim_media migration", "No",
  "adminFlagged", "boolean", "Marked for faster review", "No",
  "adminFlaggedAt", "string", "Timestamp when admin flagged the claim", "No",
  "createdAt", "string", "Submission date", "No",
  "verifiedAt", "string", "Date the verdict was settled", "No",
)

*Verification (stored inside a claim)*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique verification ID", [*Yes*],
  "claimId", "string", "ID of the parent claim", "No",
  "verdict", "string", "TRUE, FALSE, MISLEADING, or UNVERIFIABLE", "No",
  "sourceUrl", "string", "Link to the evidence", "No",
  "sourceQuality", "string", "High, medium, or low", "No",
  "explanation", "string", "Verifier's reasoning", "No",
  "verifierId", "string", "ID of the verifier", "No",
  "verifierName", "string", "Display name of the verifier", "No",
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
  "claimId", "string", "ID of the related claim", "No",
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
  "targetTitle", "string", "Title or text of the reported item", "No",
  "reason", "string", "Reason for the report", "No",
  "details", "string", "Additional details of the report", "No",
  "severity", "string", "Low, medium, or high", "No",
  "status", "string", "Pending, investigating, resolved, or dismissed", "No",
  "reportedBy", "string", "ID of the admin who filed it", "No",
  "reportedByName", "string", "Display name of the admin who filed it", "No",
  "reportedAt", "string", "Date filed", "No",
  "actionTaken", "string", "Description of the resolution action", "No",
  "resolvedAt", "string", "Date the report was resolved", "No",
  "resolvedBy", "string", "ID of the admin who resolved it", "No",
)

*audit_logs*
#styled-table(
  columns: (1.5fr, 1fr, 2.3fr, 0.45fr),
  headers: ("Field", "Type", "Description", "PK"),
  "id", "string", "Unique log ID", [*Yes*],
  "adminId", "string", "Admin who performed the action", "No",
  "adminName", "string", "Display name of the admin", "No",
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

#block(breakable: false)[
*1. Home:* Introduction · Submit a claim · Browse the queue

#v(1em)
#figure(
  image("attachments/wireframe_home.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Home Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-home>
]

#block(breakable: false)[
*2. Submit:* Text or screenshot · OCR · Category · Duplicate warning

#v(1em)
#figure(
  image("attachments/wireframe_submit.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Submit Page],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-submit>
]

#block(breakable: false)[
*3. Verify Queue:* Claim cards · Progress · Deadline · Filters

#v(1em)
#figure(
  image("attachments/wireframe_verify_queue.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Verify Queue],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-queue>
]

#block(breakable: false)[
*4. Verify Detail:* Claim · Verdict · Source URL · Explanation

#v(1em)
#figure(
  image("attachments/wireframe_verify_detail.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Verify Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-verify-detail>
]

#block(breakable: false)[
*5. Claim Detail:* Verdict · Confidence score · Sources · Download card

#v(1em)
#figure(
  image("attachments/wireframe_claim_detail.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Claim Detail],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-claim-detail>
]

#block(breakable: false)[
*6. Dashboard:* Statistics · Category chart · Weekly trends · Top verifiers

#v(1em)
#figure(
  image("attachments/wireframe_dashboard.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Dashboard],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-dashboard>
]

#block(breakable: false)[
*7. Profile:* Reputation · Tier · History

#v(1em)
#figure(
  image("attachments/wireframe_profile.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Profile],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-profile>
]

#block(breakable: false)[
*8. Admin Console:* Overview · Verifiers · Claims · Incidents · Audit and Tools

#v(1em)
#figure(
  image("attachments/wireframe_admin.png", width: 100%, height: 87%, fit: "contain"),
  caption: [Wireframe — Admin Console],
  kind: "diagram",
  supplement: "Diagram",
) <fig-wireframe-admin>
]

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
7. *Upload validation:* Images are checked by size (up to 5 MB on upload, compressed to about 900 KB for Firestore storage), extension, file type, and file signature.
8. *Input sanitization:* Text is cleaned of scripts and dangerous HTML before it is saved or shown.
9. *Spam filtering:* Verdict explanations must have at least 50 characters and 8 words and must not copy the claim.
10. *Audit log:* Every admin action is recorded in a log that cannot be edited or deleted.

#pagebreak()
== Test cases design

#styled-table(
  columns: (1.15fr, 1.5fr, 1.75fr, 1.4fr),
  headers: ("Test Condition", "Input Selected", "Expected Result", "Actual Result"),
  "User Registration", "Valid name, email and password", "User should be registered with a starting reputation of 50", "User registered successfully",
  "User Login", "Valid email and password", "User should be signed in and shown the dashboard", "User logged in successfully",
  "Invalid Login", "Correct email, wrong password", "An error message should be shown", "Error message displayed",
  "Repeated Failed Login", "5 wrong password attempts", "Sign-in should be locked for 15 minutes", "Sign-in locked successfully",
  "Submit Text Claim", "Valid claim text and category", "A pending claim should be created", "Claim created successfully",
  "Submit Screenshot", "JPEG/PNG image under 5 MB", "Text should be extracted and shown for review", "Text extracted successfully",
  "Invalid File Upload", "Renamed non-image file", "The upload should be rejected", "Upload rejected successfully",
  "Duplicate Detection", "Text similar to an existing claim", "Submission should be blocked with a link to the existing claim", "Duplicate blocked successfully",
  "Submit Verdict", "Verdict, source URL and explanation", "The verification should be saved to the claim", "Verification saved successfully",
  "Short Explanation", "Explanation under 50 characters", "A validation message should be shown", "Validation message displayed",
  "Self-Verification", "Submitter opens their own claim", "Verification should not be allowed", "Verification blocked successfully",
  "Reach Consensus", "Third valid verification", "The claim should be verified with a verdict and score", "Claim verified successfully",
  "Consensus Expiry", "Admin runs expiry after 7 days", "The claim should be settled as CONTESTED", "Claim settled successfully",
  "Download Card", "Click Download on a verified claim", "A PNG fact-check card should be downloaded", "Card downloaded successfully",
  "Admin Access", "Non-admin opens the /admin page", "Access should be denied", "Access denied successfully",
  "Admin Override", "Admin changes a claim's verdict", "The claim should be updated and the action logged", "Verdict updated and logged successfully",
  "User Logout", "Click Logout", "User should be logged out and returned to the login page", "User logged out successfully",
)
