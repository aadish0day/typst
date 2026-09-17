#import "../lib/helpers.typ": *

= Requirement and Analysis

== Problem Definition

WhatsApp is the main private-messaging platform in India, and forwarded messages are one of the largest channels for misinformation. Because chats are end-to-end encrypted and forwards move inside closed groups, a false claim about health, politics, government schemes, or money can reach thousands of people before any fact-checker sees it. Institutional fact-checkers are accurate but slow and publish long web articles that rarely reach those groups, while a group member replying "this is fake" is fast but gives no source and leaves no lasting record.

FactStamp addresses this problem with a community fact-checking web application. A user submits a forward as text or as a screenshot, and the system checks whether the claim has already been verified. New claims are reviewed by at least three independent verifiers who cite sources, a weighted consensus produces a verdict and confidence score, and the result is exported as a PNG card that can be shared back into the WhatsApp group.

#pagebreak()
== Requirement Specification

The requirements of FactStamp are divided into functional requirements and non-functional requirements.

=== Functional Requirements

The system shall provide the following functions:

*Authentication and Reputation Module*
- Register and sign in with email/password or Google
- Give every new user a reputation score of 50
- Increase reputation by 2 when a verdict matches the final verdict, and decrease it by 1 when it does not
- End the session after 30 minutes of inactivity
- Lock sign-in for 15 minutes after 5 failed attempts

*Claim Submission Module*
- Submit a claim as text or as a screenshot (JPEG, PNG, WebP, or GIF, up to 5 MB)
- Extract text from the screenshot with in-browser OCR
- Remove WhatsApp timestamps and status text from the extracted text
- Compress the screenshot before saving it
- Suggest a category: health, political, religious, financial, or other

*Duplicate Detection Module*
- Compare a new claim with existing claims using Jaccard similarity
- Block the submission and link to the existing claim when similarity is 0.75 or higher
- Otherwise create a new pending claim with a 7-day deadline

*Verification Queue Module*
- Show pending claims to signed-in users
- Record a verdict (TRUE, FALSE, MISLEADING, or UNVERIFIABLE) with a source URL and an explanation
- Allow only one verdict per user per claim, and stop users verifying their own claims
- Rate the source as high, medium, or low quality from its domain
- Reject explanations shorter than 50 characters or 8 words

*Consensus Module*
- Settle a claim once it has 3 verifications
- Compute the confidence score: 40% agreement, 30% average reputation, 30% source quality
- Let an administrator settle overdue claims as CONTESTED after 7 days

*Fact-Check Card Module*
- Show the verdict, confidence score, and sources on the claim page
- Export the result as a 1080 px wide PNG card for sharing

*Analytics Dashboard Module*
- Show weekly claim trends by category
- Show the most debunked claims and the most active verifiers
- Count claims closed without quorum separately

*Security and Notifications Module*
- Sanitize text input against script injection
- Validate uploaded images by extension, file type, and file signature
- Enforce all data rules on the server with Firestore Security Rules
- Send in-app notifications when a claim is settled

*Admin Module*
- Restrict the `/admin` console to administrator accounts
- Manage users, reputation, and admin rights
- Flag, edit, override, or delete claims
- Handle incident reports
- Record every admin action in an audit log

=== Non-Functional Requirements

The system should satisfy the following quality requirements:

*Performance*
- New claims appear in the verification queue within 2 seconds
- OCR on a typical screenshot finishes within 8 seconds
- A fact-check card exports within 3 seconds

*Security*
- All communication with Firebase uses HTTPS
- Admin-only writes are rejected by the server for non-admin users
- Reputation can only be changed by the server-side Cloud Function

*Reliability*
- Overdue claims can always be settled instead of staying pending forever
- If OCR fails, the user can still type the claim manually

*Usability*
- Visitors can browse the dashboard and claim pages without signing in
- Verdicts are shown with both colour and label
- The interface works on mobile, tablet, and desktop screens

*Scalability*
- Verifications are stored inside the claim document, so one read loads a claim and all its verdicts
- Normal usage stays within Firebase's free-tier database quotas

#pagebreak()
== Planning and Scheduling

=== PERT Chart

#v(1em)
#align(center)[#image("attachments/pert_chart.svg", width: 100%, height: 85%, fit: "contain")]
<fig-pert>

#pagebreak()
== Software and Hardware Requirements

=== Software Requirements

#styled-table(
  columns: (1.4fr, 2fr),
  headers: ("Software", "Purpose"),
  "Windows 10/11, macOS, or Linux", "Operating system",
  "Visual Studio Code", "Code editor",
  "Node.js 20 or 22 and npm", "Running the build tools and scripts",
  "React 18 and TypeScript 5.5", "Front-end development",
  "Vite 5", "Build tool and development server",
  "Tailwind CSS 4", "Styling",
  "Firebase 12 (Authentication, Firestore, Cloud Functions)", "Sign-in, database, and reputation updates",
  "Tesseract.js 7", "In-browser OCR",
  "html-to-image", "PNG card export",
  "Recharts", "Dashboard charts",
  "Firebase CLI", "Local emulators and deployment",
  "Git and GitHub", "Version control and CI",
  "Chrome, Firefox, Safari, or Edge (2023 or newer)", "Running the application",
)

=== Hardware Requirements

#styled-table(
  columns: (1.2fr, 2.2fr),
  headers: ("Hardware", "Minimum Requirement"),
  "Processor", "Dual-core 64-bit CPU (quad-core recommended for development)",
  "RAM", "8 GB for development; 2 GB on the user's device",
  "Storage", "10 GB free space for development",
  "Display", "1366 × 768 (desktop) or 360 × 640 (mobile)",
  "Internet", "Broadband or 4G connection",
  "Input devices", "Keyboard and mouse, or touchscreen",
)

#pagebreak()
== Preliminary Product Description

*1. Authentication and Reputation Module*

Users register and sign in with email/password or Google. Every account starts with a reputation of 50, which rises or falls depending on whether the user's verdicts match the final result.

*2. Claim Submission Module*

Users submit a WhatsApp forward as text or as a screenshot. Screenshots are compressed and read with in-browser OCR, and the user can correct the extracted text before submitting.

*3. Duplicate Detection Module*

Before a claim is saved, it is compared with existing claims. If it is too similar to one of them, the submission is blocked and the user is shown the existing claim instead.

*4. Verification Queue Module*

Signed-in users pick pending claims from the queue and submit a verdict with a source and an explanation. Users cannot verify their own claims or verify the same claim twice.

*5. Consensus Module*

When a claim receives three verifications, the system settles the majority verdict and calculates a confidence score from agreement, verifier reputation, and source quality. Claims that miss the 7-day deadline can be settled as CONTESTED by an administrator.

*6. Fact-Check Card Module*

A settled claim can be downloaded as a PNG card showing the verdict, confidence score, and sources, ready to share on WhatsApp.

*7. Analytics Dashboard Module*

The public dashboard shows claim trends by category, the most debunked claims, and the most active verifiers.

*8. Security and Notifications Module*

This module sanitizes input, validates uploads, and times out idle sessions, while Firestore Security Rules protect the data on the server. It also notifies users when their claims are settled.

*9. Admin Module*

Administrators use the `/admin` console to manage users, moderate claims, handle incident reports, and review the audit log of admin actions.

#pagebreak()
== Conceptual Models

=== Gantt Chart

// Wide timeline: turned to landscape so it prints at a readable size.
#align(center)[#rotate(-90deg, reflow: true)[#image("attachments/gantt_chart.svg", width: 8.6in)]]
<fig-gantt>

#pagebreak()
=== Event Table

#v(1em)
#align(center)[#image("attachments/event_table.svg", width: 100%)]
<fig-event-table>

#pagebreak()
=== Entity-Relationship (E-R) Diagram

#v(1em)
#align(center)[#image("attachments/er_diagram.svg", width: 100%, height: 88%, fit: "contain")]
<fig-er>

#pagebreak()
=== Class Diagram

#v(1em)
#align(center)[#image("attachments/class_diagram.svg", width: 100%, height: 90%, fit: "contain")]
<fig-class>

#pagebreak()
=== Object Diagram

#v(1em)
#align(center)[#image("attachments/object_diagram.svg", width: 88%)]
<fig-object>

#pagebreak()
=== Use Case Diagram

#v(1em)
#align(center)[#image("attachments/use_case_diagram.svg", width: 100%, height: 88%, fit: "contain")]
<fig-usecase>

#pagebreak()
=== Activity Diagram

#v(1em)
#align(center)[#image("attachments/activity_diagram.svg", width: 100%, height: 90%, fit: "contain")]
<fig-activity>

#pagebreak()
=== Sequence Diagram

#v(1em)
#align(center)[#image("attachments/sequence_diagram.svg", width: 100%)]
<fig-sequence>

#pagebreak()
=== State Diagram

#v(1em)
#align(center)[#image("attachments/state_diagram.svg", width: 85%)]
<fig-state>

#pagebreak()
=== Package Diagram

#v(1em)
#align(center)[#image("attachments/package_diagram.svg", width: 88%)]
<fig-package>

#pagebreak()
=== Component Diagram

#v(1em)
#align(center)[#image("attachments/component_diagram.svg", width: 100%, height: 88%, fit: "contain")]
<fig-component>

#pagebreak()
=== Deployment Diagram

#v(1em)
#align(center)[#image("attachments/deployment_diagram.svg", width: 92%)]
<fig-deployment>

#pagebreak()
=== Data Flow Diagrams

#v(1em)
#align(center)[#image("attachments/dfd_level_0.svg", width: 85%)]
<fig-dfd0>

#pagebreak()
#align(center)[#image("attachments/dfd_level_1.svg", width: 100%, height: 92%, fit: "contain")]
<fig-dfd1>

#pagebreak()
#align(center)[#image("attachments/dfd_level_2.svg", width: 100%, height: 92%, fit: "contain")]
<fig-dfd2>
