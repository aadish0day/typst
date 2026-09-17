#import "../lib/helpers.typ": *

= Survey of Technologies

== Introduction

Building a modern web application requires technologies that are secure, fast, and easy to maintain. FactStamp is a single-page web application built with React and backed by Firebase, so it needs no custom application server. The selected technologies provide a responsive user interface, secure sign-in, a real-time database, and in-browser processing for OCR and image export.

#pagebreak()
== Front-End Technologies

=== React 18

React is an open-source JavaScript library for building component-based user interfaces. FactStamp uses React 18.3.1 for every page, with application state shared through React Context.

*Advantages:*
- Reusable components
- Virtual DOM for fast updates
- Large ecosystem, including Firebase bindings
- Built-in Context API for shared state

=== TypeScript 5.5

TypeScript adds static types to JavaScript. FactStamp is written in strict TypeScript, so data read from Firestore is checked against defined types before it is used.

*Advantages:*
- Catches errors at compile time
- Clear data types for claims, users, and verifications
- Better editor autocompletion
- Safer refactoring

=== Vite 5

Vite is the build tool and development server. It serves the project instantly during development and produces an optimized production bundle split into cached vendor chunks.

*Advantages:*
- Very fast development server
- Instant hot module reloading
- Optimized production builds
- Simple configuration

=== Tailwind CSS 4

Tailwind CSS is a utility-first CSS framework. FactStamp uses Tailwind CSS v4 with OKLCH colour tokens for the verdict colours and the light and dark themes.

*Advantages:*
- Faster UI development
- Responsive utility classes
- Consistent design tokens
- No unused CSS in the final build

=== Framer Motion 12

Framer Motion is a React animation library. It is used for page transitions, card reveals, and animated counters.

*Advantages:*
- Smooth, physics-based animations
- Simple React API
- Coordinated animation of groups of elements

=== Recharts

Recharts is a React charting library. It draws the category and verdict charts on the analytics dashboard and in the admin console.

*Advantages:*
- Charts written as React components
- Responsive by default
- Built-in tooltips and legends

#pagebreak()
== Back-End Technologies

=== Firebase Authentication

Firebase Authentication manages user accounts. FactStamp supports sign-in with email and password or with a Google account, so no custom password handling is needed.

*Advantages:*
- Secure, managed sign-in
- Email/password and Google sign-in
- Built-in protection against repeated login attempts
- No server code required

=== Cloud Firestore

Cloud Firestore is Google's NoSQL document database. It stores users, claims, claim screenshots, notifications, reports, and audit logs, and pushes changes to the browser in real time.

*Advantages:*
- Real-time updates without a custom server
- Flexible document structure
- Scales automatically
- Free tier suitable for the project

=== Firestore Security Rules

Security Rules run on Google's servers and check every read and write to the database. They enforce who may change what, such as one verdict per verifier and admin-only actions.

*Advantages:*
- Server-side protection of all data
- Cannot be bypassed from the browser
- Rules written declaratively in one file

=== Cloud Functions

Cloud Functions run server-side code when an event happens. FactStamp uses one function to update verifier reputation whenever a verification is saved.

*Advantages:*
- Trusted code that users cannot modify
- Runs automatically on database changes
- No server to manage

#pagebreak()
== Supporting Libraries

=== Tesseract.js 7

Tesseract.js is an OCR engine compiled to WebAssembly. It reads the text from WhatsApp screenshots directly in the browser, so images are never sent to an external service.

*Advantages:*
- Free, with no API cost
- Protects user privacy
- Works on the user's own device

=== html-to-image

html-to-image converts a part of the web page into a PNG image. FactStamp uses it to export the 1080 px wide fact-check card, with the browser rendering the card's OKLCH colours correctly.

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
