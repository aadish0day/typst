#import "../lib/helpers.typ": *

= Survey of Technologies

== Introduction

FactStamp runs as a single-page application in the browser and leans on Firebase's managed services, so there is no server of its own to run or maintain. The technologies below were chosen to fit that model: a fast React interface, sign-in and a real-time database from Firebase, and OCR and image export that happen on the user's own device.

#pagebreak()
== Front-End Technologies

=== React 18

Every screen in FactStamp is built from React components, and version 18.3.1 is used throughout. Rather than pull in a separate state library, the app shares its state, the signed-in user, the claims, and notifications, through React Context.

*Advantages:*
- Reusable components
- Virtual DOM for fast updates
- Large ecosystem, including Firebase bindings
- Built-in Context API for shared state

=== TypeScript 5.5

The whole codebase is written in strict TypeScript 5.5. This matters because Firestore does not enforce a schema, so the types declared in the code are what guarantee that a claim or verification read back from the database carries the fields the app expects.

*Advantages:*
- Catches errors at compile time
- Clear data types for claims, users, and verifications
- Better editor autocompletion
- Safer refactoring

=== Vite 5

Vite 5 serves the app during development and bundles it for release. Large dependencies such as Firebase and Tesseract.js are split into their own chunks, which lets the browser cache them between visits instead of downloading them again.

*Advantages:*
- Very fast development server
- Instant hot module reloading
- Optimized production builds
- Simple configuration

=== Tailwind CSS 4

Styling is written with Tailwind CSS v4 utility classes. The verdict colours and the light and dark themes are defined once as OKLCH colour tokens, which keeps them consistent everywhere they appear.

*Advantages:*
- Faster UI development
- Responsive utility classes
- Consistent design tokens
- No unused CSS in the final build

=== Framer Motion 12

The motion in the interface, page transitions, the reveal of claim cards, and the animated statistics counters, is handled by Framer Motion 12.

*Advantages:*
- Smooth, physics-based animations
- Simple React API
- Coordinated animation of groups of elements

=== Recharts

The charts that break down claims by category and verdict, both on the public dashboard and in the admin console, are drawn with Recharts.

*Advantages:*
- Charts written as React components
- Responsive by default
- Built-in tooltips and legends

#pagebreak()
== Back-End Technologies

=== Firebase Authentication

Accounts and sign-in are handled by Firebase Authentication, using either an email and password or a Google account. FactStamp therefore never stores or checks a password itself.

*Advantages:*
- Secure, managed sign-in
- Email/password and Google sign-in
- Built-in protection against repeated login attempts
- No server code required

=== Cloud Firestore

FactStamp keeps its data in Cloud Firestore, Google's NoSQL document database, across the users, claims, claim screenshots, notifications, reports, and audit-log collections. Firestore streams changes straight to the browser, which is what keeps the verification queue and the dashboard current without a refresh.

*Advantages:*
- Real-time updates without a custom server
- Flexible document structure
- Scales automatically
- Free tier suitable for the project

=== Firestore Security Rules

Before any read or write reaches the database, Google's servers check it against the Firestore Security Rules. These rules carry the platform's core constraints, one verdict per verifier, no self-verification, and admin-only actions, so the constraints hold even when a request skips the app entirely.

*Advantages:*
- Server-side protection of all data
- Cannot be bypassed from the browser
- Rules written declaratively in one file

=== Cloud Functions

Reputation is the one value the browser is not trusted to change. A single Cloud Function, triggered whenever a verification is saved, recalculates each verifier's reputation on the server.

*Advantages:*
- Trusted code that users cannot modify
- Runs automatically on database changes
- No server to manage

#pagebreak()
== Supporting Libraries

=== Tesseract.js 7

Because WhatsApp forwards often arrive as screenshots, FactStamp reads their text with Tesseract.js 7, an OCR engine compiled to WebAssembly. It runs inside the browser, so a screenshot never leaves the user's device.

*Advantages:*
- Free, with no API cost
- Protects user privacy
- Works on the user's own device

=== html-to-image

The fact-check card is exported with html-to-image, which turns the on-screen card into a 1080 px wide PNG. Since the browser itself does the rendering, the card's OKLCH colours come out exactly as they appear on screen.

*Advantages:*
- Exports exactly what the page shows
- Supports modern CSS colours
- Runs entirely in the browser

#pagebreak()
== Development Tools

*Visual Studio Code*

Visual Studio Code is the code editor, chosen for its TypeScript support and extensions.

*Git and GitHub*

Git is used for version control, and GitHub stores the repository and runs automatic type checks and builds on every push.

*Firebase CLI and Emulator Suite*

The Firebase CLI runs a local copy of Authentication and Firestore for testing, and deploys the application to Firebase Hosting.

*Docker and Vercel*

Docker packages the application with Nginx for self-hosting, and Vercel provides an alternative static hosting option.
