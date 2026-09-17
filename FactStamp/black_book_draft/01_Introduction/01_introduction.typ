= Introduction

== Background

WhatsApp is used by hundreds of millions of people in India, and forwarded messages are one of the main ways misinformation spreads. Because chats are end-to-end encrypted and forwards move inside private groups, false claims about health, politics, government schemes, or money spread quickly without search engines or fact-checkers seeing them. By the time a fact-checking article is published, the forward has usually already been shared many times.

Existing solutions have clear limits. Institutional fact-checkers such as PIB Fact Check and newsrooms are accurate but have small teams, and their long web articles rarely reach the WhatsApp groups where a rumour started. A group member replying "this is fake" is quick, but gives no source, leaves no lasting record, and does not recognise the same claim when it comes back reworded.

FactStamp is a web application that brings these two approaches together. A user submits a forward as text or as a screenshot, and the system checks whether the claim has already been verified. New claims are reviewed by at least three independent community verifiers who cite sources, and the system calculates a verdict and confidence score. The result can be downloaded as a PNG card and shared back into the WhatsApp group.

#pagebreak(weak: true)

== Objectives

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
== Purpose, Scope, and Applicability

#heading(level: 3, outlined: true)[Purpose]

The purpose of FactStamp is to give WhatsApp users a quick, community-driven way to check suspicious forwards and receive a sourced, shareable correction, without depending on a professional editorial team.

#heading(level: 3, outlined: true)[Scope]

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

#heading(level: 3, outlined: true)[Applicability]

FactStamp is useful for:
- Family and neighbourhood WhatsApp groups where health tips, rumours, and financial schemes circulate.
- Student and civic groups that want a simple, open verification process.
- Media-literacy programmes that teach people to check claims against evidence.

#pagebreak()
== Achievements

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
== Organization of Report

The report is organised into the following chapters:

- *Chapter 1: Introduction* explains the background, objectives, scope, and achievements of FactStamp.
- *Chapter 2: Survey of Technologies* describes the front-end, back-end, and supporting technologies used.
- *Chapter 3: Requirements and Analysis* covers the problem definition, requirements, planning, hardware and software requirements, module descriptions, and diagrams.
- *Chapter 4: System Design* presents the modules, database design, user interface design, security, and test cases.
- *Chapter 5: Implementation and Testing* explains how the system was built and tested.
- *Chapter 6: Results and Discussion* shows the working application screen by screen.
- *Chapter 7: Conclusions* summarises the project, its limitations, and future scope.
- *References and Glossary* list the sources used and explain the main terms.
