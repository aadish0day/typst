# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker


# Introduction

## Background

WhatsApp is used by hundreds of millions of people in India, and forwarded messages are one of the main ways misinformation spreads. Because chats are end-to-end encrypted and forwards move inside private groups, false claims about health, politics, government schemes, or money spread quickly without search engines or fact-checkers seeing them. By the time a fact-checking article is published, the forward has usually already been shared many times.

Existing solutions have clear limits. Institutional fact-checkers such as PIB Fact Check and newsrooms are accurate but have small teams, and their long web articles rarely reach the WhatsApp groups where a rumour started. A group member replying "this is fake" is quick, but gives no source, leaves no lasting record, and does not recognise the same claim when it comes back reworded.

FactStamp is a web application that brings these two approaches together. A user submits a forward as text or as a screenshot, and the system checks whether the claim has already been verified. New claims are reviewed by at least three independent community verifiers who cite sources, and the system calculates a verdict and confidence score. The result can be downloaded as a PNG card and shared back into the WhatsApp group.

#pagebreak(weak: true)

## Objectives

The main objectives of the FactStamp project are:

1. To let users submit suspicious WhatsApp forwards directly, as text or as a screenshot.
2. To avoid checking the same claim twice by detecting duplicates with Jaccard similarity (threshold 0.75).
3. To require at least three independent verifications before a verdict is settled.
4. To calculate a confidence score from verifier agreement, verifier reputation, and source quality.
5. To produce a shareable PNG fact-check card that can be forwarded on WhatsApp.
6. To make submission easy by reading text from screenshots with in-browser OCR.
7. To keep verifiers accountable with a reputation score that rises or falls with their accuracy.
8. To show misinformation trends on a public analytics dashboard.

#pagebreak()
## Purpose, Scope, and Applicability

### Purpose

The purpose of FactStamp is to give WhatsApp users a quick, community-driven way to check suspicious forwards and receive a sourced, shareable correction, without depending on a professional editorial team.

### Scope

The system supports three kinds of users:
- Visitor (can browse claims and the dashboard)
- Registered Verifier (can submit and verify claims)
- Administrator (moderates the platform)

Major functionalities include:
- Sign-in with email/password or Google
- Claim submission as text or screenshot, with in-browser OCR
- Duplicate detection
- A verification queue requiring three verifiers
- Weighted confidence scoring and verifier reputation
- Settling overdue claims as `CONTESTED` after 7 days
- Shareable PNG fact-check cards
- A public analytics dashboard
- An admin console for users, claims, incident reports, and the audit log

The current version does not integrate directly with WhatsApp, does not use automated or AI fact-checking, reads only English text from screenshots, and is a web application rather than a native mobile app. It works on desktops, tablets, and mobile phones through a modern browser.

### Applicability

FactStamp is useful for:
- Family and neighbourhood WhatsApp groups where health tips, rumours, and financial schemes circulate.
- Student and civic groups that want a simple, open verification process.
- Media-literacy programmes that teach people to check claims against evidence.

#pagebreak()
## Achievements

The major achievements of the FactStamp project are:

- Developed a working web application deployable on Firebase Hosting, Vercel, or Docker.
- Implemented sign-in with email/password and Google, with idle-session timeout.
- Built claim submission with in-browser OCR that removes WhatsApp timestamps and status text.
- Implemented duplicate detection that blocks near-identical claims.
- Built a verification queue with one verdict per verifier and no self-verification.
- Implemented weighted consensus scoring and a reputation system updated by a Cloud Function.
- Added PNG fact-check card export for sharing on WhatsApp.
- Built a public analytics dashboard with category trends and the most debunked claims.
- Built an admin console with five tabs and a permanent audit log.
- Secured the database with Firestore Security Rules, checked by an automated test script.
- Added light and dark themes and support for Devanagari text.

#pagebreak()
## Organization of Report

The report is organised into the following chapters:

- **Chapter 1: Introduction** explains the background, objectives, scope, and achievements of FactStamp.
- **Chapter 2: Survey of Technologies** describes the front-end, back-end, and supporting technologies used.
- **Chapter 3: Requirements and Analysis** covers the problem definition, requirements, planning, hardware and software requirements, module descriptions, and diagrams.
- **Chapter 4: System Design** presents the modules, database design, user interface design, security, and test cases.
- **Chapter 5: Implementation and Testing** explains how the system was built and tested.
- **Chapter 6: Results and Discussion** shows the working application screen by screen.
- **Chapter 7: Conclusions** summarises the project, its limitations, and future scope.
- **References and Glossary** list the sources used and explain the main terms.


# Survey of Technologies

## Introduction

FactStamp runs as a single-page application in the browser and leans on Firebase's managed services, so there is no server of its own to run or maintain. The technologies below were chosen to fit that model: a fast React interface, sign-in and a real-time database from Firebase, and OCR and image export that happen on the user's own device.

#pagebreak()
## Front-End Technologies

### React 18

Every screen in FactStamp is built from React components, and version 18.3.1 is used throughout. Rather than pull in a separate state library, the app shares its state, the signed-in user, the claims, and notifications, through React Context.

**Advantages:**
- Reusable components
- Virtual DOM for fast updates
- Large ecosystem, including Firebase bindings
- Built-in Context API for shared state

### TypeScript 5.5

The whole codebase is written in strict TypeScript 5.5. This matters because Firestore does not enforce a schema, so the types declared in the code are what guarantee that a claim or verification read back from the database carries the fields the app expects.

**Advantages:**
- Catches errors at compile time
- Clear data types for claims, users, and verifications
- Better editor autocompletion
- Safer refactoring

### Vite 5

Vite 5 serves the app during development and bundles it for release. Large dependencies such as Firebase and Tesseract.js are split into their own chunks, which lets the browser cache them between visits instead of downloading them again.

**Advantages:**
- Very fast development server
- Instant hot module reloading
- Optimized production builds
- Simple configuration

### Tailwind CSS 4

Styling is written with Tailwind CSS v4 utility classes. The verdict colours and the light and dark themes are defined once as OKLCH colour tokens, which keeps them consistent everywhere they appear.

**Advantages:**
- Faster UI development
- Responsive utility classes
- Consistent design tokens
- No unused CSS in the final build

### Framer Motion 12

The motion in the interface, page transitions, the reveal of claim cards, and the animated statistics counters, is handled by Framer Motion 12.

**Advantages:**
- Smooth, physics-based animations
- Simple React API
- Coordinated animation of groups of elements

### Recharts

The charts that break down claims by category and verdict, both on the public dashboard and in the admin console, are drawn with Recharts.

**Advantages:**
- Charts written as React components
- Responsive by default
- Built-in tooltips and legends

#pagebreak()
## Back-End Technologies

### Firebase Authentication

Accounts and sign-in are handled by Firebase Authentication, using either an email and password or a Google account. FactStamp therefore never stores or checks a password itself.

**Advantages:**
- Secure, managed sign-in
- Email/password and Google sign-in
- Built-in protection against repeated login attempts
- No server code required

### Cloud Firestore

FactStamp keeps its data in Cloud Firestore, Google's NoSQL document database, across the users, claims, claim screenshots, notifications, reports, and audit-log collections. Firestore streams changes straight to the browser, which is what keeps the verification queue and the dashboard current without a refresh.

**Advantages:**
- Real-time updates without a custom server
- Flexible document structure
- Scales automatically
- Free tier suitable for the project

### Firestore Security Rules

Before any read or write reaches the database, Google's servers check it against the Firestore Security Rules. These rules carry the platform's core constraints, one verdict per verifier, no self-verification, and admin-only actions, so the constraints hold even when a request skips the app entirely.

**Advantages:**
- Server-side protection of all data
- Cannot be bypassed from the browser
- Rules written declaratively in one file

### Cloud Functions

Reputation is the one value the browser is not trusted to change. A single Cloud Function, triggered whenever a verification is saved, recalculates each verifier's reputation on the server.

**Advantages:**
- Trusted code that users cannot modify
- Runs automatically on database changes
- No server to manage

#pagebreak()
## Supporting Libraries

### Tesseract.js 7

Because WhatsApp forwards often arrive as screenshots, FactStamp reads their text with Tesseract.js 7, an OCR engine compiled to WebAssembly. It runs inside the browser, so a screenshot never leaves the user's device.

**Advantages:**
- Free, with no API cost
- Protects user privacy
- Works on the user's own device

### html-to-image

The fact-check card is exported with html-to-image, which turns the on-screen card into a 1080 px wide PNG. Since the browser itself does the rendering, the card's OKLCH colours come out exactly as they appear on screen.

**Advantages:**
- Exports exactly what the page shows
- Supports modern CSS colours
- Runs entirely in the browser

#pagebreak()
## Development Tools

**Visual Studio Code**

Visual Studio Code is the code editor, chosen for its TypeScript support and extensions.

**Git and GitHub**

Git is used for version control, and GitHub stores the repository and runs automatic type checks and builds on every push.

**Firebase CLI and Emulator Suite**

The Firebase CLI runs a local copy of Authentication and Firestore for testing, and deploys the application to Firebase Hosting.

**Docker and Vercel**

Docker packages the application with Nginx for self-hosting, and Vercel provides an alternative static hosting option.


# Requirement and Analysis

## Problem Definition

WhatsApp is the main private-messaging platform in India, and forwarded messages are one of the largest channels for misinformation. Because chats are end-to-end encrypted and forwards move inside closed groups, a false claim about health, politics, government schemes, or money can reach thousands of people before any fact-checker sees it. Institutional fact-checkers are accurate but slow and publish long web articles that rarely reach those groups, while a group member replying "this is fake" is fast but gives no source and leaves no lasting record.

FactStamp addresses this problem with a community fact-checking web application. A user submits a forward as text or as a screenshot, and the system checks whether the claim has already been verified. New claims are reviewed by at least three independent verifiers who cite sources, a weighted consensus produces a verdict and confidence score, and the result is exported as a PNG card that can be shared back into the WhatsApp group.

#pagebreak()
## Requirement Specification

The requirements of FactStamp are divided into functional requirements and non-functional requirements.

### Functional Requirements

The system shall provide the following functions:

**Authentication and Reputation Module**
- Register and sign in with email/password or Google
- Give every new user a reputation score of 50
- Increase reputation by 2 when a verdict matches the final verdict, and decrease it by 1 when it does not
- End the session after 30 minutes of inactivity
- Lock sign-in for 15 minutes after 5 failed attempts

**Claim Submission Module**
- Submit a claim as text or as a screenshot (JPEG, PNG, WebP, or GIF, up to 5 MB)
- Extract text from the screenshot with in-browser OCR
- Remove WhatsApp timestamps and status text from the extracted text
- Compress the screenshot before saving it
- Suggest a category: health, political, religious, financial, or other

**Duplicate Detection Module**
- Compare a new claim with existing claims using Jaccard similarity
- Block the submission and link to the existing claim when similarity is 0.75 or higher
- Otherwise create a new pending claim with a 7-day deadline

**Verification Queue Module**
- Show pending claims to signed-in users
- Record a verdict (TRUE, FALSE, MISLEADING, or UNVERIFIABLE) with a source URL and an explanation
- Allow only one verdict per user per claim, and stop users verifying their own claims
- Rate the source as high, medium, or low quality from its domain
- Reject explanations shorter than 50 characters or 8 words

**Consensus Module**
- Settle a claim once it has 3 verifications
- Compute the confidence score: 40% agreement, 30% average reputation, 30% source quality
- Let an administrator settle overdue claims as CONTESTED after 7 days

**Fact-Check Card Module**
- Show the verdict, confidence score, and sources on the claim page
- Export the result as a 1080 px wide PNG card for sharing

**Analytics Dashboard Module**
- Show weekly claim trends by category
- Show the most debunked claims and the most active verifiers
- Count claims closed without quorum separately

**Security and Notifications Module**
- Sanitize text input against script injection
- Validate uploaded images by extension, file type, and file signature
- Enforce all data rules on the server with Firestore Security Rules
- Send in-app notifications when a claim is settled

**Admin Module**
- Restrict the `/admin` console to administrator accounts
- Manage users, reputation, and admin rights
- Flag, edit, override, or delete claims
- Handle incident reports
- Record every admin action in an audit log

### Non-Functional Requirements

The system should satisfy the following quality requirements:

**Performance**
- New claims appear in the verification queue within 2 seconds
- OCR on a typical screenshot finishes within 8 seconds
- A fact-check card exports within 3 seconds

**Security**
- All communication with Firebase uses HTTPS
- Admin-only writes are rejected by the server for non-admin users
- Reputation can only be changed by the server-side Cloud Function

**Reliability**
- Overdue claims can always be settled instead of staying pending forever
- If OCR fails, the user can still type the claim manually

**Usability**
- Visitors can browse the dashboard and claim pages without signing in
- Verdicts are shown with both colour and label
- The interface works on mobile, tablet, and desktop screens

**Scalability**
- Verifications are stored inside the claim document, so one read loads a claim and all its verdicts
- Normal usage stays within Firebase's free-tier database quotas

#pagebreak()
## Planning and Scheduling

### PERT Chart

![](attachments/pert_chart.svg)

#pagebreak()
## Software and Hardware Requirements

### Software Requirements

| Software | Purpose |
|---|---|
| Windows 10/11, macOS, or Linux | Operating system |
| Visual Studio Code | Code editor |
| Node.js 20 or 22 and npm | Running the build tools and scripts |
| React 18 and TypeScript 5.5 | Front-end development |
| Vite 5 | Build tool and development server |
| Tailwind CSS 4 | Styling |
| Firebase 12 (Authentication, Firestore, Cloud Functions) | Sign-in, database, and reputation updates |
| Tesseract.js 7 | In-browser OCR |
| html-to-image | PNG card export |
| Recharts | Dashboard charts |
| Firebase CLI | Local emulators and deployment |
| Git and GitHub | Version control and CI |
| Chrome, Firefox, Safari, or Edge (2023 or newer) | Running the application |

### Hardware Requirements

| Hardware | Minimum Requirement |
|---|---|
| Processor | Dual-core 64-bit CPU (quad-core recommended for development) |
| RAM | 8 GB for development; 2 GB on the user's device |
| Storage | 10 GB free space for development |
| Display | 1366 × 768 (desktop) or 360 × 640 (mobile) |
| Internet | Broadband or 4G connection |
| Input devices | Keyboard and mouse, or touchscreen |

#pagebreak()
## Preliminary Product Description

**1. Authentication and Reputation Module**

Users register and sign in with email/password or Google. Every account starts with a reputation of 50, which rises or falls depending on whether the user's verdicts match the final result.

**2. Claim Submission Module**

Users submit a WhatsApp forward as text or as a screenshot. Screenshots are compressed and read with in-browser OCR, and the user can correct the extracted text before submitting.

**3. Duplicate Detection Module**

Before a claim is saved, it is compared with existing claims. If it is too similar to one of them, the submission is blocked and the user is shown the existing claim instead.

**4. Verification Queue Module**

Signed-in users pick pending claims from the queue and submit a verdict with a source and an explanation. Users cannot verify their own claims or verify the same claim twice.

**5. Consensus Module**

When a claim receives three verifications, the system settles the majority verdict and calculates a confidence score from agreement, verifier reputation, and source quality. Claims that miss the 7-day deadline can be settled as CONTESTED by an administrator.

**6. Fact-Check Card Module**

A settled claim can be downloaded as a PNG card showing the verdict, confidence score, and sources, ready to share on WhatsApp.

**7. Analytics Dashboard Module**

The public dashboard shows claim trends by category, the most debunked claims, and the most active verifiers.

**8. Security and Notifications Module**

This module sanitizes input, validates uploads, and times out idle sessions, while Firestore Security Rules protect the data on the server. It also notifies users when their claims are settled.

**9. Admin Module**

Administrators use the `/admin` console to manage users, moderate claims, handle incident reports, and review the audit log of admin actions.

#pagebreak()
## Conceptual Models

### Gantt Chart

![](attachments/gantt_chart.svg)

#pagebreak()
### Event Table

![](attachments/event_table.svg)

#pagebreak()
### Entity-Relationship (E-R) Diagram

![](attachments/er_diagram.svg)

#pagebreak()
### Class Diagram

![](attachments/class_diagram.svg)

#pagebreak()
### Object Diagram

![](attachments/object_diagram.svg)

#pagebreak()
### Use Case Diagram

![](attachments/use_case_diagram.svg)

#pagebreak()
### Activity Diagram

![](attachments/activity_diagram.svg)

#pagebreak()
### Sequence Diagram

![](attachments/sequence_diagram.svg)

#pagebreak()
### State Diagram

![](attachments/state_diagram.svg)

#pagebreak()
### Package Diagram

![](attachments/package_diagram.svg)

#pagebreak()
### Component Diagram

![](attachments/component_diagram.svg)

#pagebreak()
### Deployment Diagram

![](attachments/deployment_diagram.svg)

#pagebreak()
### Data Flow Diagrams

![](attachments/dfd_level_0.svg)

#pagebreak()
![](attachments/dfd_level_1.svg)

#pagebreak()
![](attachments/dfd_level_2.svg)


# System design

## Basic modules

**1. Authentication and Reputation Module**

Users register and sign in with email/password or Google through Firebase Authentication. A new profile starts with a reputation of 50, which only the server-side Cloud Function can change: +2 when a verdict matches the final verdict and -1 when it does not.

**2. Claim Submission Module**

The Submit page accepts a claim as text or as a screenshot. A screenshot is compressed in the browser, read with Tesseract.js OCR, and cleaned of WhatsApp timestamps and status text, and the user can edit the result before submitting.

**3. Duplicate Detection Module**

Before a claim is saved, its words are compared with recent claims using Jaccard similarity. A match of 0.75 or higher blocks the submission and links to the existing claim; otherwise a new pending claim is created with a 7-day deadline.

**4. Verification Queue Module**

Signed-in users see pending claims they are allowed to verify. A verifier chooses TRUE, FALSE, MISLEADING, or UNVERIFIABLE, adds a source URL and an explanation, and the verification is added to the claim. Users cannot verify their own claims or verify the same claim twice.

**5. Consensus Module**

When a claim has three verifications, the majority verdict is settled and the confidence score is calculated as 40% agreement, 30% average reputation, and 30% source quality. Claims still short of three verifications after 7 days can be settled as CONTESTED by an administrator.

**6. Fact-Check Card Module**

Once a claim is settled, its page brings together the verdict, the confidence score, and the cited sources. From there the reader can export the whole thing as a 1080 px wide PNG card, generated with html-to-image, and forward it back into WhatsApp.

**7. Analytics Dashboard Module**

The dashboard is open to anyone, with no sign-in. It follows how many claims arrive each week in each category, which claims have been debunked most, who the most active verifiers are, and how many claims closed without ever reaching a quorum.

**8. Security and Notifications Module**

Cutting across the others is a layer that cleans user input, checks uploaded images, and ends idle sessions, while the Firestore Security Rules enforce the same limits on the server. This layer also raises the notification a user sees when their claim is settled.

**9. Admin Module**

Administrators work from an unlisted `/admin` console. There they manage accounts, moderate or override claims, work through incident reports, trigger consensus expiry on overdue claims, and read the audit log of what other administrators have done.

#pagebreak()
## Data design

FactStamp stores its data in Cloud Firestore in six collections: `users`, `claims`, `claim_media`, `notifications`, `reports`, and `audit_logs`.

### Schema design

**users**
| Field | Type | Description | PK |
|---|---|---|---|
| uid | string | Unique user ID | **Yes** |
| displayName | string | User name | No |
| email | string | Email address | No |
| avatarUrl | string | Profile picture (optional) | No |
| reputation | number | Reputation score, 0 to 100 (starts at 50) | No |
| totalVerifications | number | Number of verdicts given | No |
| isAdmin | boolean | Administrator flag | No |
| joinedAt | string | Account creation date | No |

**claims**
| Field | Type | Description | PK |
|---|---|---|---|
| id | string | Unique claim ID | **Yes** |
| text | string | Claim text (10 to 2000 characters) | No |
| category | string | Health, political, religious, financial, or other | No |
| status | string | Pending or verified | No |
| verdict | string | TRUE, FALSE, MISLEADING, UNVERIFIABLE, or CONTESTED | No |
| confidenceScore | number | Confidence score, 0 to 100 | No |
| verifications | array | Verifications given for the claim | No |
| verificationCount | number | Number of verifications | No |
| submittedBy | string | ID of the user who submitted it | No |
| consensusDeadline | string | Date 7 days after submission | No |
| thumbnailUrl | string | Small screenshot preview (optional) | No |
| adminFlagged | boolean | Marked for faster review | No |
| createdAt | string | Submission date | No |
| verifiedAt | string | Date the verdict was settled | No |

**Verification (stored inside a claim)**
| Field | Type | Description | PK |
|---|---|---|---|
| id | string | Unique verification ID | **Yes** |
| verdict | string | TRUE, FALSE, MISLEADING, or UNVERIFIABLE | No |
| sourceUrl | string | Link to the evidence | No |
| sourceQuality | string | High, medium, or low | No |
| explanation | string | Verifier's reasoning | No |
| verifierId | string | ID of the verifier | No |
| verifierReputation | number | Verifier's reputation when voting | No |
| createdAt | string | Date of the verification | No |

**claim_media**
| Field | Type | Description | PK |
|---|---|---|---|
| claimId | string | ID of the claim | **Yes** |
| imageUrl | string | Full screenshot image | No |
| createdAt | string | Upload date | No |

**notifications**
| Field | Type | Description | PK |
|---|---|---|---|
| id | string | Unique notification ID | **Yes** |
| userId | string | User who receives it | No |
| type | string | Kind of notification | No |
| title | string | Notification title | No |
| message | string | Notification text | No |
| isRead | boolean | Whether it has been read | No |
| createdAt | string | Date sent | No |

**reports**
| Field | Type | Description | PK |
|---|---|---|---|
| id | string | Unique report ID | **Yes** |
| targetType | string | Claim, user, or verification | No |
| targetId | string | ID of the reported item | No |
| reason | string | Reason for the report | No |
| severity | string | Low, medium, or high | No |
| status | string | Pending, investigating, resolved, or dismissed | No |
| reportedBy | string | ID of the admin who filed it | No |
| reportedAt | string | Date filed | No |

**audit_logs**
| Field | Type | Description | PK |
|---|---|---|---|
| id | string | Unique log ID | **Yes** |
| adminId | string | Admin who performed the action | No |
| action | string | Action performed | No |
| targetType | string | Claim, user, report, or system | No |
| targetId | string | ID of the affected item | No |
| details | string | Extra information | No |
| timestamp | string | Date and time of the action | No |

### Data integrity and constraints

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
## User interface design

**1. Home:** Introduction · Submit a claim · Browse the queue

![Wireframe — Home Page](attachments/wireframe_home.png)
*Wireframe — Home Page*

**2. Submit:** Text or screenshot · OCR · Category · Duplicate warning

![Wireframe — Submit Page](attachments/wireframe_submit.png)
*Wireframe — Submit Page*

**3. Verify Queue:** Claim cards · Progress · Deadline · Filters

![Wireframe — Verify Queue](attachments/wireframe_verify_queue.png)
*Wireframe — Verify Queue*

**4. Verify Detail:** Claim · Verdict · Source URL · Explanation

![Wireframe — Verify Detail](attachments/wireframe_verify_detail.png)
*Wireframe — Verify Detail*

**5. Claim Detail:** Verdict · Confidence score · Sources · Download card

![Wireframe — Claim Detail](attachments/wireframe_claim_detail.png)
*Wireframe — Claim Detail*

**6. Dashboard:** Statistics · Category chart · Weekly trends · Top verifiers

![Wireframe — Dashboard](attachments/wireframe_dashboard.png)
*Wireframe — Dashboard*

**7. Profile:** Reputation · Tier · History

![Wireframe — Profile](attachments/wireframe_profile.png)
*Wireframe — Profile*

**8. Admin Console:** Overview · Verifiers · Claims · Incidents · Audit and Tools

![Wireframe — Admin Console](attachments/wireframe_admin.png)
*Wireframe — Admin Console*

#pagebreak()
## Security issues

Because FactStamp lets the public submit and judge claims, security is enforced both in the browser and on the server. Browser checks give quick feedback, while Firestore Security Rules protect the data even if someone bypasses the web interface.

**Security Measures Implemented**

1. **Managed authentication:** Firebase Authentication handles passwords and Google sign-in, so the application never stores passwords.
2. **Server-side rules:** Firestore Security Rules validate every write, including one verdict per verifier, no self-verification, and at most three verifications.
3. **Role-based access:** Only administrators can open the admin console, change other users, or read all profiles.
4. **Trusted reputation:** Reputation is changed only by a Cloud Function, never by the browser.
5. **Login cooldown:** After 5 failed sign-in attempts the account is locked for 15 minutes in the browser, backed by Firebase's own server-side throttling.
6. **Session timeout:** Users are signed out after 30 minutes of inactivity.
7. **Upload validation:** Images are checked by size (up to 5 MB), extension, file type, and file signature.
8. **Input sanitization:** Text is cleaned of scripts and dangerous HTML before it is saved or shown.
9. **Spam filtering:** Verdict explanations must have at least 50 characters and 8 words and must not copy the claim.
10. **Audit log:** Every admin action is recorded in a log that cannot be edited or deleted.

#pagebreak()
## Test cases design

| Test Condition | Input Selected | Expected Result | Actual Result |
|---|---|---|---|
| User Registration | Valid name, email and password | User should be registered with a starting reputation of 50 | User registered successfully |
| User Login | Valid email and password | User should be signed in and shown the dashboard | User logged in successfully |
| Invalid Login | Correct email, wrong password | An error message should be shown | Error message displayed |
| Repeated Failed Login | 5 wrong password attempts | Sign-in should be locked for 15 minutes | Sign-in locked successfully |
| Submit Text Claim | Valid claim text and category | A pending claim should be created | Claim created successfully |
| Submit Screenshot | JPEG/PNG image under 5 MB | Text should be extracted and shown for review | Text extracted successfully |
| Invalid File Upload | Renamed non-image file | The upload should be rejected | Upload rejected successfully |
| Duplicate Detection | Text similar to an existing claim | Submission should be blocked with a link to the existing claim | Duplicate blocked successfully |
| Submit Verdict | Verdict, source URL and explanation | The verification should be saved to the claim | Verification saved successfully |
| Short Explanation | Explanation under 50 characters | A validation message should be shown | Validation message displayed |
| Self-Verification | Submitter opens their own claim | Verification should not be allowed | Verification blocked successfully |
| Reach Consensus | Third valid verification | The claim should be verified with a verdict and score | Claim verified successfully |
| Consensus Expiry | Admin runs expiry after 7 days | The claim should be settled as CONTESTED | Claim settled successfully |
| Download Card | Click Download on a verified claim | A PNG fact-check card should be downloaded | Card downloaded successfully |
| Admin Access | Non-admin opens the /admin page | Access should be denied | Access denied successfully |
| Admin Override | Admin changes a claim's verdict | The claim should be updated and the action logged | Verdict updated and logged successfully |
| User Logout | Click Logout | User should be logged out and returned to the login page | User logged out successfully |


# Implementation and testing

## Implementation approach

### Project summary

FactStamp is a community fact-checking web application for WhatsApp forwards. Users submit claims as text or screenshots, duplicates are detected automatically, community verifiers review each claim, and a weighted consensus produces a verdict that can be shared as a PNG card. The system is built as a single-page application with React, TypeScript, and Tailwind CSS, and uses Firebase for sign-in, the database, and one Cloud Function. It grew one module at a time: each was wired up and checked against the Firebase Local Emulator Suite before the next was started, so a problem in the duplicate check or the consensus engine surfaced before anything downstream depended on it.

#pagebreak()
## Coding details and code efficiency

Each of the eight modules from Chapter 4 keeps to its own part of the codebase, from authentication through to the security layer. Where two of them need the same logic, such as scoring a cited source or checking an explanation, that logic sits in one shared function instead of being copied, and a write the database refuses surfaces as an error to the user rather than being swallowed.

### Coding details

#### Main modules

The three modules below contain the core logic that makes FactStamp different from a normal submission form. Their code is shown in full, exactly as it appears in the source files.

**1. Duplicate Detection Engine**

The engine normalizes the claim text, splits it into words longer than three characters, and calculates Jaccard similarity (shared words divided by all distinct words) against existing claims. If the best match is 0.75 or higher, the Submit page shows the existing claim and blocks the new submission, so the same claim is not queued twice.

```typescript
function normalize(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s]/g, '')   // remove punctuation
    .replace(/\s+/g, ' ')      // normalize whitespace
    .trim()
}

function tokenize(text: string): Set<string> {
  return new Set(
    normalize(text)
      .split(/\s+/)
      .filter((word) => word.length > 3) // ignore short words
  )
}

function jaccardSimilarity(a: string, b: string): number {
  const setA = tokenize(a)
  const setB = tokenize(b)

  if (setA.size === 0 && setB.size === 0) return 1
  if (setA.size === 0 || setB.size === 0) return 0

  let intersection = 0
  for (const word of setA) {
    if (setB.has(word)) intersection++
  }

  const union = setA.size + setB.size - intersection
  return intersection / union
}

export function findDuplicate(
  text: string,
  existingClaims: Array<{ id: string; text: string }>,
  threshold = 0.75
): { id: string; text: string; similarity: number } | null {
  const normalized = normalize(text)

  let bestMatch: { id: string; text: string; similarity: number } | null = null

  for (const claim of existingClaims) {
    const similarity = jaccardSimilarity(normalized, claim.text)
    if (similarity >= threshold && (!bestMatch || similarity > bestMatch.similarity)) {
      bestMatch = { id: claim.id, text: claim.text, similarity }
    }
  }

  return bestMatch
}
```

```tsx
  const checkDuplicate = useCallback(() => {
    if (claimText.trim().length < 20) return
    const result = findDuplicate(claimText, claims.map((c) => ({ id: c.id, text: c.text })))
    if (result && !duplicateFound) {
      toast('Similar claim found', {
        description: `This matches an existing claim (${Math.round(result.similarity * 100)}% similar). View the existing verdict to avoid duplication.`,
        icon: <AlertTriangle className="w-5 h-5 text-[var(--color-v-mislead)]" />,
      })
    }
    setDuplicateFound(result)
  }, [claimText, claims, duplicateFound])

  // inside handleSubmitAction(): a duplicate stops the submission
    if (duplicateFound) {
      toast.error('Duplicate claim', {
        description: 'This claim has already been verified by the community. View the existing verdict instead.',
      })
      throw new Error('Duplicate claim')
    }
```

**2. Community Verification System**

A claim can be verified only by a signed-in user who did not submit it and has not already verified it, and only until three verifications are reached. The verifier gives a verdict, a source URL, and an explanation; the explanation is checked for length and spam, and the verification is then added to the claim and saved to Firestore.

```typescript
export function canVerify(claim: Claim, uid: string | undefined): boolean {
  if (!uid) return false
  if (claim.status !== 'pending') return false
  if (claim.submittedBy === uid) return false
  if (claim.verificationCount >= REQUIRED_VERIFICATIONS) return false
  return !claim.verifications.some((v) => v.verifierId === uid)
}
```

```typescript
export interface ExplanationValidationResult {
  valid: boolean
  error?: string
  warning?: string
  charCount: number
  wordCount: number
  minChars: number
  maxChars: number
  minWords: number
}

export function validateVerdictExplanation(
  rawText: string,
  claimText?: string
): ExplanationValidationResult {
  const minChars = 50
  const maxChars = 1500
  const minWords = 8

  const text = rawText.trim()
  const charCount = text.length
  const words = text ? text.split(/\s+/).filter(Boolean) : []
  const wordCount = words.length

  // 1. Minimum character length (defense against empty/incomplete verification)
  if (charCount < minChars) {
    return {
      valid: false,
      error: `Explanation is too short (${charCount}/${minChars} characters). Please detail why the source supports your verdict.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 2. Maximum character length (defense against payload bloat & Firestore document limit)
  if (charCount > maxChars) {
    return {
      valid: false,
      error: `Explanation exceeds the maximum limit (${charCount}/${maxChars} characters). Please keep it concise.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 3. Minimum word count (prevents single-word gibberish string padding like 'aaaaa...')
  if (wordCount < minWords) {
    return {
      valid: false,
      error: `Explanation must contain at least ${minWords} words (currently ${wordCount}). Please write complete sentences explaining the facts.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 4. Excessive repetitive character spam (e.g., 'aaaaaa', '......', '!!!!!!')
  if (/(.)\1{5,}/.test(text)) {
    return {
      valid: false,
      error: 'Explanation contains repetitive character patterns. Please write substantive reasoning.',
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 5. Repeated word spam (e.g., 'fake fake fake fake')
  const lowerWords = words.map((w) => w.toLowerCase().replace(/[^a-z0-9]/g, ''))
  for (let i = 0; i < lowerWords.length - 2; i++) {
    if (lowerWords[i] && lowerWords[i] === lowerWords[i + 1] && lowerWords[i] === lowerWords[i + 2]) {
      return {
        valid: false,
        error: 'Explanation contains repetitive words. Please provide diverse factual evidence.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 6. Generic cop-out & filler phrases
  const lower = text.toLowerCase()
  const copOuts = [
    'just trust me',
    'trust me bro',
    'check it yourself',
    'search it on google',
    'search google',
    'idk',
    'i don\'t know',
    'random text to fill space',
    'asdfasdf',
    'qwertyuiop',
  ]
  for (const phrase of copOuts) {
    if (lower.includes(phrase)) {
      return {
        valid: false,
        error: 'Explanation contains low-effort filler phrases. Please cite concrete findings from the source.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 7. Duplicate of claim text check (copy-pasting the claim back)
  if (claimText && claimText.trim().length >= 30) {
    const cleanClaim = claimText.trim().toLowerCase()
    if (lower === cleanClaim || (lower.includes(cleanClaim) && text.length < claimText.length + 30)) {
      return {
        valid: false,
        error: 'Explanation cannot simply repeat the claim text. Please explain your research findings.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 8. Constructive quality guidance
  let warning: string | undefined
  const hasEvidenceTerms = /(source|report|article|study|ministry|official|evidence|archive|debunk|confirmed|stated|found|according|data|analysis|fact)/i.test(text)
  if (!hasEvidenceTerms) {
    warning = 'Tip: Mention specific evidence or quotes from your cited source to increase community trust.'
  }

  return {
    valid: true,
    warning,
    charCount,
    wordCount,
    minChars,
    maxChars,
    minWords,
  }
}
```

```tsx
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    const newErrors: Record<string, string> = {}
    if (!verdict) newErrors.verdict = 'Please select a verdict rating.'

    if (!sourceUrl.trim()) {
      newErrors.sourceUrl = 'Please provide a valid source URL.'
    } else {
      try {
        const parsed = new URL(sourceUrl.trim())
        if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
          newErrors.sourceUrl = 'Only standard HTTP or HTTPS links are permitted.'
        }
      } catch {
        newErrors.sourceUrl = 'Please enter a valid URL (e.g. https://pib.gov.in).'
      }
    }

    const cleanExplanation = sanitizeTextInput(explanation.trim())
    const explValidation = validateVerdictExplanation(cleanExplanation, claim.text)
    if (!explValidation.valid) {
      newErrors.explanation = explValidation.error || 'Please provide a detailed explanation of your findings.'
    }

    setErrors(newErrors)
    if (Object.keys(newErrors).length > 0) {
      toast.error('Please resolve the errors below before submitting.')
      return
    }

    setLoading(true)

    try {
      await addVerification(claim.id, {
        verdict: verdict!,
        sourceUrl: sourceUrl.trim(),
        explanation: cleanExplanation,
        verifierId: user?.uid || '',
        verifierName: user?.displayName || 'Independent Verifier',
        verifierReputation: user?.reputation ?? 50,
      })
      toast.success('Verdict recorded successfully.')
      setSubmitted(true)
    } catch (err) {
      // Success is only claimed once the database has accepted the verdict.
      console.error('Verdict write failed:', err)
      toast.error('Your verdict was not saved.', {
        description: 'The database rejected the write. Check your connection and try again.',
      })
    } finally {
      setLoading(false)
    }
  }
```

```tsx
  const addVerification = useCallback(
    async (claimId: string, data: AddVerificationInput): Promise<void> => {
      const target = claims.find((c) => c.id === claimId)
      if (!target) throw new Error('That claim no longer exists.')

      const updatedClaim = computeUpdatedClaim(target, data)

      localClaimsRef.current = [
        updatedClaim,
        ...localClaimsRef.current.filter((c) => c.id !== claimId),
      ]

      setClaims((prev) =>
        prev.map((c) => (c.id === claimId ? updatedClaim : c))
      )

      if (isFirebaseConfigured) {
        try {
          // This used to be fire-and-forget with a console.warn. A verdict the
          // rules rejected still showed "recorded successfully" and vanished on
          // the next reload, so the write result now decides what the UI says.
          await updateClaimInFirestore(updatedClaim)
        } catch (err) {
          // Roll the optimistic update back so the UI matches the database.
          localClaimsRef.current = [
            target,
            ...localClaimsRef.current.filter((c) => c.id !== claimId),
          ]
          setClaims((prev) => prev.map((c) => (c.id === claimId ? target : c)))
          throw err
        }
      }
    },
    [claims, user]
  )
```

**3. Confidence Scoring and Consensus Engine**

The confidence score combines the agreement ratio (40%), the average reputation of the verifiers (30%), and the average source quality (30%). Source quality is 100 for trusted official domains, 70 for established news sites, and 30 for any other link. Each new verification recalculates the majority verdict and score, and the claim is marked verified once it has three verifications. After a verification is saved, a Cloud Function updates each verifier's reputation: +2 if their verdict matched the final verdict and -1 if it did not.

```typescript
export function calculateConfidenceScore(
  verifications: Array<{
    verdict: string;
    verifierReputation: number;
    sourceQuality: number; // 0–100
  }>,
): {
  score: number;
  agreementRatio: number;
  avgReputation: number;
  sourceQualityScore: number;
} {
  if (verifications.length === 0) {
    return {
      score: 0,
      agreementRatio: 0,
      avgReputation: 0,
      sourceQualityScore: 0,
    };
  }

  // 1. Agreement ratio: How many verifications agree with the majority verdict
  const verdicts = verifications.map((v) => v.verdict);
  const majorityCount = Math.max(
    ...Array.from(new Set(verdicts)).map(
      (v) => verdicts.filter((x) => x === v).length,
    ),
  );
  const agreementRatio = (majorityCount / verifications.length) * 100;

  // 2. Average reputation of all verifiers
  const avgReputation =
    verifications.reduce((sum, v) => sum + v.verifierReputation, 0) /
    verifications.length;

  // 3. Source quality score (average)
  const sourceQualityScore =
    verifications.reduce((sum, v) => sum + v.sourceQuality, 0) /
    verifications.length;

  // Weighted calculation
  const score = Math.round(
    agreementRatio * 0.4 + avgReputation * 0.3 + sourceQualityScore * 0.3,
  );

  return {
    score: Math.min(100, Math.max(0, score)),
    agreementRatio,
    avgReputation,
    sourceQualityScore,
  };
}

const HQ_DOMAINS = new Set([
  "who.int",
  "nih.gov",
  "ncbi.nlm.nih.gov",
  "pib.gov.in",
  "eci.gov.in",
  "mohfw.gov.in",
  "icmr.gov.in",
  "ayush.gov.in",
  "ceodelhi.gov.in",
  "wikipedia.org",
  "indiacode.nic.in",
  "rbi.org.in",
]);
const MQ_DOMAINS = new Set([
  "timesofindia.indiatimes.com",
  "indianexpress.com",
  "thehindu.com",
  "bbc.com",
  "bbc.in",
  "reuters.com",
  "apnews.com",
  "ndtv.com",
  "economictimes.com",
  "factcheck.org",
  "iitm.org",
  "snopes.com",
]);

function hostMatches(host: string, domain: string): boolean {
  return host === domain || host.endsWith("." + domain);
}

export function determineSourceQuality(url: string): "high" | "medium" | "low" {
  try {
    const parsed = new URL(url);
    if (parsed.protocol !== "http:" && parsed.protocol !== "https:") return "low";
    const host = parsed.hostname.toLowerCase().replace(/\.$/, "");
    if (Array.from(HQ_DOMAINS).some((hq) => hostMatches(host, hq))) return "high";
    if (Array.from(MQ_DOMAINS).some((mq) => hostMatches(host, mq))) return "medium";
    return "low";
  } catch {
    return "low";
  }
}

export function sourceQualityToScore(
  quality: "high" | "medium" | "low",
): number {
  switch (quality) {
    case "high":
      return 100;
    case "medium":
      return 70;
    case "low":
      return 30;
  }
}
```

```typescript
function computeUpdatedClaim(claim: Claim, data: AddVerificationInput): Claim {
  const sourceQuality = determineSourceQuality(data.sourceUrl)

  const newVerification: Verification = {
    id: `v${Date.now()}`,
    claimId: claim.id,
    verdict: data.verdict,
    sourceUrl: data.sourceUrl,
    sourceQuality,
    explanation: data.explanation,
    verifierId: data.verifierId,
    verifierName: data.verifierName,
    verifierReputation: data.verifierReputation,
    createdAt: new Date().toISOString(),
  }

  const updatedVerifications = [...claim.verifications, newVerification]

  // Calculate new confidence score
  const verifData = updatedVerifications.map((v) => ({
    verdict: v.verdict,
    verifierReputation: v.verifierReputation,
    sourceQuality: sourceQualityToScore(v.sourceQuality),
  }))
  const confidence = calculateConfidenceScore(verifData)

  // Determine majority verdict
  const verdictCounts: Record<string, number> = {}
  updatedVerifications.forEach((v) => {
    verdictCounts[v.verdict] = (verdictCounts[v.verdict] || 0) + 1
  })
  const majorityVerdict = Object.entries(verdictCounts).sort(
    (a, b) => b[1] - a[1]
  )[0][0] as Verdict

  // A claim is 'verified' when it has at least 3 verifications
  const isVerified = updatedVerifications.length >= 3

  return {
    ...claim,
    verifications: updatedVerifications,
    verificationCount: updatedVerifications.length,
    status: isVerified ? 'verified' : 'pending',
    // Stamp the moment consensus closed. Without this, claims verified through
    // the app had no verifiedAt at all and every "recently verified" list fell
    // back to createdAt.
    ...(isVerified ? { verifiedAt: claim.verifiedAt ?? new Date().toISOString() } : {}),
    verdict: majorityVerdict,
    confidenceScore: confidence.score,
    agreementRatio: confidence.agreementRatio,
    avgVerifierReputation: confidence.avgReputation,
    sourceQualityScore: confidence.sourceQualityScore,
  }
}
```

```javascript
import { onDocumentUpdated } from 'firebase-functions/v2/firestore'
import { initializeApp } from 'firebase-admin/app'
import { getFirestore, FieldValue } from 'firebase-admin/firestore'

initializeApp()
const db = getFirestore()

// Mirrors the client's optimistic display maths in computeUpdatedClaim().
const AGREE_REWARD = 2
const DISAGREE_PENALTY = -1
const clamp = (n) => Math.max(0, Math.min(100, n))

export const awardVerificationReputation = onDocumentUpdated('claims/{claimId}', async (event) => {
  const before = event.data?.before.data()
  const after = event.data?.after.data()
  if (!before || !after) return

  const oldList = Array.isArray(before.verifications) ? before.verifications : []
  const newList = Array.isArray(after.verifications) ? after.verifications : []

  if (newList.length !== oldList.length + 1) return

  const appended = newList[newList.length - 1]
  const appendedBy = appended?.verifierId
  if (typeof appendedBy !== 'string' || !appendedBy) return

  const justSettled = before.status === 'pending' && after.status === 'verified'
  const alreadySettled = before.status === 'verified'
  const finalVerdict = after.verdict

  const deltas = new Map()
  if (finalVerdict) {
    const scored = justSettled ? newList : alreadySettled ? [appended] : []
    for (const v of scored) {
      const uid = v?.verifierId
      if (typeof uid !== 'string' || !uid) continue
      const delta = v.verdict === finalVerdict ? AGREE_REWARD : DISAGREE_PENALTY
      deltas.set(uid, (deltas.get(uid) ?? 0) + delta)
    }
  }

  const involved = new Set([appendedBy, ...deltas.keys()])
  const refs = [...involved].map((uid) => ({ uid, ref: db.doc(`users/${uid}`) }))

  await db.runTransaction(async (tx) => {
    const snaps = await Promise.all(refs.map(({ ref }) => tx.get(ref)))

    refs.forEach(({ uid }, i) => {
      const snap = snaps[i]
      if (!snap.exists) return

      const updates = {}
      if (uid === appendedBy) updates.totalVerifications = FieldValue.increment(1)

      const delta = deltas.get(uid)
      if (delta) {
        const current = typeof snap.data().reputation === 'number' ? snap.data().reputation : 50
        updates.reputation = clamp(current + delta)
      }

      if (Object.keys(updates).length > 0) tx.update(snap.ref, updates)
    })
  })
})
```

#### Basic modules

The supporting modules use standard techniques, so only their key function is shown.

**Authentication and Verifier Profile** (`src/services/firebaseService.ts`)

Registers the user with Firebase Authentication and creates their Firestore profile with a starting reputation of 50.

```typescript
export async function signUpWithEmail(
  name: string, email: string, pass: string,
): Promise<User> {
  const userCredential =
    await createUserWithEmailAndPassword(auth, email, pass)
  const firebaseUser = userCredential.user

  const profileData: User = {
    uid: firebaseUser.uid,
    displayName: name || firebaseUser.displayName || 'Verifier',
    email: firebaseUser.email || email,
    reputation: 50, // Default reputation starting score
    totalVerifications: 0,
    joinedAt: new Date().toISOString(),
  }

  // Store Verifier Profile in Firestore
  await setDoc(doc(db, COLLECTIONS.USERS, firebaseUser.uid), {
    ...profileData,
    createdAt: serverTimestamp(),
  })
  return profileData
}
```

**Forward Submission** (`src/services/ocrService.ts`)

Removes WhatsApp interface text (timestamps, "Forwarded" labels, network indicators) from the text that Tesseract.js extracts from a screenshot.

```typescript
export function cleanExtractedOcrText(raw: string): string {
  const lines = raw.split(/\r?\n/)
  const cleanedLines: string[] = []

  const ignorePatterns = [
    /^\s*([↪\->*#]+\s*)?forwarded\s*(many\s*times)?\s*$/i,
    /^\s*(today|yesterday|\d{1,2}\/\d{1,2}\/\d{2,4})\s*$/i,
    /^\s*(lte|4g|5g|volte|vo-wifi|wifi|jio|airtel|vi|bsnl|vodafone)\s*$/i,
    /^\s*\d{1,3}%\s*$/,
    /^\s*(type a message|message|unread messages?)\s*$/i,
  ]

  for (const line of lines) {
    const trimmed = line.trim()
    if (!trimmed) continue
    if (ignorePatterns.some((pattern) => pattern.test(trimmed))) continue
    cleanedLines.push(trimmed)
  }
  // ... paragraphs are then re-joined
}
```

**Fact-Check Card Generator** (`src/pages/ClaimDetail.tsx`)

Converts the rendered card into a 1080 px wide PNG in the browser with `html-to-image` and downloads it.

```typescript
const handleDownloadCard = async () => {
  const wrapper = document.getElementById(
    'whatsapp-fact-check-card') as HTMLElement | null
  if (!wrapper) return

  const dataUrl = await toPng(wrapper, {
    pixelRatio: 2, // Crisp 2x high resolution (1080px wide)
    backgroundColor: '#fffbf5',
    cacheBust: true,
    skipFonts: true,
  })

  const link = document.createElement('a')
  link.download = `factstamp-${claim.id}.png`
  link.href = dataUrl
  link.click()
}
```

### Code efficiency

- **Reusable functions:** duplicate detection and confidence scoring are plain functions that do not depend on React or Firebase.
- **One read per claim:** verifications are stored inside the claim document, so a claim and its verdicts load in a single read.
- **Limited data:** the app listens only to the 200 most recent claims instead of the whole collection.
- **Smaller images:** screenshots are compressed in the browser, and lists load a small thumbnail instead of the full image.
- **Code splitting:** large libraries such as Firebase, Tesseract.js, and Recharts are loaded as separate files and cached by the browser.
- **Real-time updates:** Firestore listeners update the page automatically, so the app does not need to poll the database.
- **Validation first:** input is checked in the browser before any database write is attempted.

#pagebreak()
## Testing approach

Testing was done at three levels: unit testing, integration testing, and system testing. Application testing was done by hand, and the Firestore Security Rules are also checked by an automated script (`npm run test:rules`).

### Unit testing

Unit testing checks each function on its own.

Two identical claims produced a similarity of 1.00 and were marked as duplicates, whereas two claims on the same topic worded differently scored below 0.75 and stayed separate. For the confidence formula, three FALSE verdicts with reputations of 80, 60, and 70 and source scores of 100, 100, and 70 came out at 88, matching the value worked out by hand. An empty list of verifications returned 0 rather than raising an error, and an explanation shorter than 50 characters was rejected.

### Integration testing

Integration testing checks that the modules work correctly with Firebase, using the local emulator.

When three different users each verified the same claim, it became verified with the expected score. A write carrying a fake reputation value was refused by the Security Rules, a signed-out user could not submit a claim, and no user could verify their own claim. Faking the admin session flag as a non-admin got nowhere: the next render returned the user to the login screen. The `test:rules` script rounded this out with 28 checks, among them forged verdicts, double voting, and direct edits to reputation, and every write it was meant to block was denied.

### System testing

System testing checks complete user journeys on the running application.

A new account was created and its profile opened at a reputation of 50, then signed in cleanly. A screenshot was submitted and OCR filled in the claim text; a near-duplicate claim was submitted and the system blocked it; and a verdict with a short explanation drew the expected error. One claim was carried through its third verification and the resulting PNG card downloaded, an administrator overrode a verdict and the change showed up in the audit log, and the interface was switched between light and dark themes.

#pagebreak()
## Modifications and improvements

Several changes were made during development to fix problems found in testing and to improve the system:

- **Real data only:** the app first filled an empty queue with demo claims and settled overdue claims only in the browser; it now shows only real Firestore data, and administrators settle overdue claims.
- **Login protection:** a 15-minute lockout after 5 failed attempts was added to the sign-in page and the admin console.
- **Theme toggle:** one reusable light/dark theme toggle replaced different buttons on each page.
- **Fonts:** the font set was reduced to Plus Jakarta Sans and Noto Sans Devanagari, adding support for Hindi and Marathi text.
- **Card export:** the first card exporter could not read the app's modern colours, so it was replaced with html-to-image.
- **Security fixes:** the Security Rules were tightened to stop forged verdicts and double voting, demo accounts lost admin rights, and reputation updates moved to a Cloud Function.
- **Faster screenshots:** full screenshots were moved to a separate collection so lists load only small thumbnails.


# Results and discussion

![](attachments/)

## User documentation

This user manual explains how to use each screen of FactStamp. The first part is for regular users and the second part is for administrators.

### Home

The home page is open to everyone. It explains what FactStamp does, shows live platform statistics, and lists recently debunked claims, with buttons to submit a forward or open the verification queue.

![](attachments/home.png)

### Sign In

Users sign in with their email and password or with Google. After 5 failed attempts, sign-in is locked for 15 minutes and a countdown is shown.

![](attachments/signin.png)

### Sign Up

New users register with a display name, email, and password, and the page shows how strong the password is. Every new account starts with a reputation of 50.

![](attachments/signup.png)

### Submit a Claim

A signed-in user submits a suspicious forward as text or as a screenshot. For a screenshot, the text is read automatically and can be corrected before submitting. If a very similar claim already exists, a warning links to it and the submission is blocked.

![](attachments/submit.png)

### Claim Detail

This public page shows the claim, its verdict stamp, the confidence score, and each verifier's explanation and source. Once a claim is verified, the user can download it as a PNG card to share on WhatsApp.

![](attachments/claim_detail.png)

### Verification Queue

This page lists claims waiting for verification, with search, sorting, and category filters. Claims flagged by an administrator appear first, and the user's own claims and claims they have already verified are hidden.

![](attachments/verify_queue.png)

### Verify a Claim

The verifier chooses a verdict, adds a source URL, and writes an explanation of at least 50 characters. The source is rated automatically, and the verdict is saved once it passes validation. Users cannot verify their own claims or verify a claim twice.

![](attachments/verify_detail.png)

### Dashboard

The public dashboard shows the number of claims with a verdict, false claims debunked, the average confidence score, and claims closed without quorum. It also shows weekly trends, a category chart, the most debunked claims, and the most active verifiers.

![](attachments/dashboard.png)

### Profile

The profile page shows the user's reputation score, their tier (Novice, Trusted, Expert, or Elite), progress to the next tier, and the verdicts they have given.

![](attachments/profile.png)

### Admin: System Overview

Administrators open the unlisted `/admin` page. The first tab shows platform statistics, claims by category, verdict distribution, and the number of verifiers in each tier.

![](attachments/admin_overview.png)

### Admin: Verifier Directory

This tab lists all users. An administrator can change a user's reputation, give or remove admin rights, or delete the account.

![](attachments/admin_verifiers.png)

### Admin: Claims Moderation

This tab lists all claims. An administrator can flag a claim for faster review, edit it, override its verdict, remove a verification, or delete the claim.

![](attachments/admin_moderation.png)

### Admin: Incident Queue

This tab manages incident reports. Reports can be filtered by status and severity, and an administrator can create, resolve, or dismiss them.

![](attachments/admin_incidents.png)

### Admin: Audit and Tools

This tab shows the audit log of all admin actions. It also lets the administrator settle overdue claims as CONTESTED, send a notification to all users, and export a backup of the data.

![](attachments/admin_audit.png)


# Conclusion

## Conclusion

The FactStamp project was developed to help people check suspicious WhatsApp forwards quickly and share a sourced correction. The system lets users submit claims as text or screenshots, blocks duplicate claims, sends new claims to community verifiers, and settles a verdict only after three independent verifications. A weighted confidence score based on agreement, verifier reputation, and source quality makes each verdict more reliable than a simple vote, and the result can be shared on WhatsApp as a PNG card. With its public dashboard, admin console, and server-side security rules, FactStamp meets its main objectives and provides a working, community-driven way to fight misinformation.

#pagebreak()
## Limitations of the system

- OCR reads only English text, so Hindi and other regional-language forwards must be typed manually.
- In-browser OCR is less accurate on blurry or low-quality screenshots.
- There is no direct WhatsApp integration; users must upload screenshots or paste text themselves.
- While the community is small, a group of fake accounts could outvote honest verifiers.
- Source quality is based on a fixed list of domains, so some credible sources are rated low.
- Overdue claims are settled only when an administrator runs consensus expiry.
- Most testing was manual; only the security rules have an automated test script.
- Each screenshot is limited to about 900 KB because images are stored in Firestore.
- Duplicate detection checks only the 200 most recent claims.

#pagebreak()
## Future scope of the project

- OCR support for Hindi and other Indian languages.
- A community-maintained list of trusted sources.
- Automatic settlement of overdue claims on a schedule.
- A public verifier leaderboard that does not expose private profile data.
- An appeal process for CONTESTED claims.
- Automated tests for duplicate detection and confidence scoring.
- A WhatsApp chatbot so users can forward messages directly to FactStamp.
- A mobile app with push notifications.
- Support for Telegram and SMS forwards.


#heading(numbering: none)[References]

- IEEE Computer Society, **"IEEE Recommended Practice for Software Requirements Specifications,"** IEEE Std 830-1998, 1998.
- Schwaber, K., & Sutherland, J., **"The Scrum Guide,"** Scrum.org, Nov. 2020.
- Vosoughi, S., Roy, D., & Aral, S., **"The spread of true and false news online,"** _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
- Garimella, K., & Eckles, D., **"Images and misinformation in political groups: Evidence from WhatsApp in India,"** _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
- Jaccard, P., **"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"** _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
- OWASP Foundation, **"OWASP Top Ten,"** 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
- Meta Platforms, Inc., **"React Documentation,"** 2025. [Online]. Available: `https://react.dev/`.
- Vite Contributors, **"Vite Documentation,"** 2025. [Online]. Available: `https://vite.dev/`.
- Microsoft Corporation, **"TypeScript Documentation,"** 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
- Tailwind Labs Inc., **"Tailwind CSS v4 Documentation,"** 2025. [Online]. Available: `https://tailwindcss.com/docs`.
- Google LLC, **"Cloud Firestore Documentation,"** 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
- Google LLC, **"Firebase Authentication Documentation,"** 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
- Recharts Group, **"Recharts Documentation,"** 2025. [Online]. Available: `https://recharts.org/`.
- Project Naptha and Tesseract.js Contributors, **"Tesseract.js Documentation,"** 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
- Bubkoo, **"html-to-image,"** 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

#heading(numbering: none)[Glossary]

| Term | Definition |
|---|---|
| Admin Console | The staff-only moderation page at the unlisted `/admin` route, with five tabs: System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit and Tools. |
| Agreement Ratio | The percentage of verifiers who voted for the majority verdict. It carries 40% of the Confidence Score. |
| BaaS (Backend-as-a-Service) | A managed platform that provides backend services directly to the app. FactStamp uses Firebase, so it needs no custom application server. |
| Claim | A WhatsApp forward submitted for checking, as text or as a screenshot. |
| Claim Category | The topic of a claim: Health, Political, Financial, Religious, or Other. |
| Claim Media | The `claim_media` Firestore collection that holds each claim's full screenshot, loaded only when the claim is opened. |
| Cloud Function | Server-side code that Firebase runs when an event occurs. FactStamp's single function updates verifier reputation when a verification is stored. |
| Confidence Score | A score from 0 to 100 combining Agreement Ratio (40%), Verifier Reputation (30%), and Source Quality (30%). |
| Consensus Deadline | The 7-day limit for a claim to receive 3 verifications. If it passes first, an administrator can settle the claim as `CONTESTED`. |
| Duplicate Detection | Checking a new claim against existing ones with Jaccard Similarity. A match blocks the submission and links to the existing verdict. |
| Fact-Check Card | A 1080 px wide PNG image showing a claim's verdict, confidence score, and sources, made for sharing on WhatsApp. |
| Firebase Authentication | The Firebase service that handles sign-in with email and password or Google. |
| Firestore | Google's NoSQL cloud database, used as FactStamp's only data store. |
| Firestore Security Rules | Server-side rules that validate every database read and write, independent of the app code. |
| html-to-image | A JavaScript library that converts part of a web page into a PNG image. Used to create the Fact-Check Card. |
| Jaccard Similarity | The overlap between two sets of words: shared words divided by total distinct words. Claims scoring 0.75 or higher are duplicates. |
| OCR (Optical Character Recognition) | Extracting text from an image. FactStamp reads WhatsApp screenshots in the browser. |
| Quorum | The minimum of three independent verifications a claim needs before its verdict is settled. |
| React | The JavaScript library used to build FactStamp's user interface. |
| Recharts | The React charting library used for the dashboard and admin charts. |
| Reputation Tier | A verifier's level based on reputation: Novice, Trusted, Expert, or Elite. |
| Source Quality | A credibility score for a cited website: 100 for official sources, 70 for news sites, and 30 for all others. |
| SPA (Single-Page Application) | A web app that changes pages in the browser without reloading from the server. |
| Tailwind CSS | The CSS framework used to style the application. |
| Tesseract.js | An OCR engine that runs inside the browser, so screenshots never leave the user's device. |
| TypeScript | A typed version of JavaScript used to write the codebase. |
| Verdict | The result given to a claim: `TRUE`, `FALSE`, `MISLEADING` (partly true but distorted), `UNVERIFIABLE` (not enough evidence), or `CONTESTED` (no quorum before the deadline). |
| Verification | One verifier's review of a claim: a verdict, a source link, and a written explanation. |
| Verification Queue | The list of claims waiting for verifiers to review them. |
| Verifier | A signed-in user who reviews claims and submits verdicts. |
| Verifier Reputation | A score from 0 to 100, starting at 50, that rises when a verifier agrees with the final consensus and falls when they do not. Only a Cloud Function can change it. |
| Vite | The build tool and development server used for the project. |
| Weighted Consensus | The method that settles a claim's verdict and Confidence Score from its verifications. |
