#import "../lib/helpers.typ": *

= Results and discussion

#let screenshot(file, width: 92%) = align(center)[
  #image("attachments/" + file, width: width)
]

== User documentation

This user manual explains how to use each screen of FactStamp. The first part is for regular users and the second part is for administrators.

#block(breakable: false)[
=== Home

The home page is open to everyone. It explains what FactStamp does, shows live platform statistics, and lists recently debunked claims, with buttons to submit a forward or open the verification queue.

#screenshot("home.png")
]

#block(breakable: false)[
=== Sign In

Users sign in with their email and password or with Google. After 5 failed attempts, sign-in is locked for 15 minutes and a countdown is shown.

#screenshot("signin.png")
]

#block(breakable: false)[
=== Sign Up

New users register with a display name, email, and password, and the page shows how strong the password is. Every new account starts with a reputation of 50.

#screenshot("signup.png")
]

#block(breakable: false)[
=== Submit a Claim

A signed-in user submits a suspicious forward as text or as a screenshot. For a screenshot, the text is read automatically and can be corrected before submitting. If a very similar claim already exists, a warning links to it and the submission is blocked.

#screenshot("submit.png")
]

#block(breakable: false)[
=== Claim Detail

This public page shows the claim, its verdict stamp, the confidence score, and each verifier's explanation and source. Once a claim is verified, the user can download it as a PNG card to share on WhatsApp.

#screenshot("claim_detail.png")
]

#block(breakable: false)[
=== Verification Queue

This page lists claims waiting for verification, with search, sorting, and category filters. Claims flagged by an administrator appear first, and the user's own claims and claims they have already verified are hidden.

#screenshot("verify_queue.png")
]

#block(breakable: false)[
=== Verify a Claim

The verifier chooses a verdict, adds a source URL, and writes an explanation of at least 50 characters. The source is rated automatically, and the verdict is saved once it passes validation. Users cannot verify their own claims or verify a claim twice.

#screenshot("verify_detail.png")
]

#block(breakable: false)[
=== Dashboard

The public dashboard shows the number of claims with a verdict, false claims debunked, the average confidence score, and claims closed without quorum. It also shows weekly trends, a category chart, the most debunked claims, and the most active verifiers.

#screenshot("dashboard.png")
]

#block(breakable: false)[
=== Profile

The profile page shows the user's reputation score, their tier (Novice, Trusted, Expert, or Elite), progress to the next tier, and the verdicts they have given.

#screenshot("profile.png")
]

#block(breakable: false)[
=== Admin: System Overview

Administrators open the unlisted `/admin` page. The first tab shows platform statistics, claims by category, verdict distribution, and the number of verifiers in each tier.

#screenshot("admin_overview.png")
]

#block(breakable: false)[
=== Admin: Verifier Directory

This tab lists all users. An administrator can change a user's reputation, give or remove admin rights, or delete the account.

#screenshot("admin_verifiers.png")
]

#block(breakable: false)[
=== Admin: Claims Moderation

This tab lists all claims. An administrator can flag a claim for faster review, edit it, override its verdict, remove a verification, or delete the claim.

#screenshot("admin_moderation.png")
]

#block(breakable: false)[
=== Admin: Incident Queue

This tab manages incident reports. Reports can be filtered by status and severity, and an administrator can create, resolve, or dismiss them.

#screenshot("admin_incidents.png")
]

#block(breakable: false)[
=== Admin: Audit and Tools

This tab shows the audit log of all admin actions. It also lets the administrator settle overdue claims as CONTESTED, send a notification to all users, and export a backup of the data.

#screenshot("admin_audit.png")
]
