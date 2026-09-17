#import "../lib/helpers.typ": *

#heading(numbering: none)[References]

+ IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
+ Schwaber, K., & Sutherland, J., *"The Scrum Guide,"* Scrum.org, Nov. 2020.
+ Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
+ Garimella, K., & Eckles, D., *"Images and misinformation in political groups: Evidence from WhatsApp in India,"* _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
+ Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
+ OWASP Foundation, *"OWASP Top Ten,"* 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
+ Meta Platforms, Inc., *"React Documentation,"* 2025. [Online]. Available: `https://react.dev/`.
+ Vite Contributors, *"Vite Documentation,"* 2025. [Online]. Available: `https://vite.dev/`.
+ Microsoft Corporation, *"TypeScript Documentation,"* 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
+ Tailwind Labs Inc., *"Tailwind CSS v4 Documentation,"* 2025. [Online]. Available: `https://tailwindcss.com/docs`.
+ Google LLC, *"Cloud Firestore Documentation,"* 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
+ Google LLC, *"Firebase Authentication Documentation,"* 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
+ Recharts Group, *"Recharts Documentation,"* 2025. [Online]. Available: `https://recharts.org/`.
+ Project Naptha and Tesseract.js Contributors, *"Tesseract.js Documentation,"* 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
+ Bubkoo, *"html-to-image,"* 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

#heading(numbering: none)[Glossary]

#styled-table(
  columns: (1.5in, 1fr),
  headers: ("Term", "Definition"),
  [Admin Console], [The staff-only moderation page at the unlisted `/admin` route, with five tabs: System Overview, Verifier Directory, Claims Moderation, Incident Queue, and Audit and Tools.],
  [Agreement Ratio], [The percentage of verifiers who voted for the majority verdict. It carries 40% of the Confidence Score.],
  [BaaS (Backend-as-a-Service)], [A managed platform that provides backend services directly to the app. FactStamp uses Firebase, so it needs no custom application server.],
  [Claim], [A WhatsApp forward submitted for checking, as text or as a screenshot.],
  [Claim Category], [The topic of a claim: Health, Political, Financial, Religious, or Other.],
  [Claim Media], [The `claim_media` Firestore collection that holds each claim's full screenshot, loaded only when the claim is opened.],
  [Cloud Function], [Server-side code that Firebase runs when an event occurs. FactStamp's single function updates verifier reputation when a verification is stored.],
  [Confidence Score], [A score from 0 to 100 combining Agreement Ratio (40%), Verifier Reputation (30%), and Source Quality (30%).],
  [Consensus Deadline], [The 7-day limit for a claim to receive 3 verifications. If it passes first, an administrator can settle the claim as `CONTESTED`.],
  [Duplicate Detection], [Checking a new claim against existing ones with Jaccard Similarity. A match blocks the submission and links to the existing verdict.],
  [Fact-Check Card], [A 1080 px wide PNG image showing a claim's verdict, confidence score, and sources, made for sharing on WhatsApp.],
  [Firebase Authentication], [The Firebase service that handles sign-in with email and password or Google.],
  [Firestore], [Google's NoSQL cloud database, used as FactStamp's only data store.],
  [Firestore Security Rules], [Server-side rules that validate every database read and write, independent of the app code.],
  [html-to-image], [A JavaScript library that converts part of a web page into a PNG image. Used to create the Fact-Check Card.],
  [Jaccard Similarity], [The overlap between two sets of words: shared words divided by total distinct words. Claims scoring 0.75 or higher are duplicates.],
  [OCR (Optical Character Recognition)], [Extracting text from an image. FactStamp reads WhatsApp screenshots in the browser.],
  [Quorum], [The minimum of three independent verifications a claim needs before its verdict is settled.],
  [React], [The JavaScript library used to build FactStamp's user interface.],
  [Recharts], [The React charting library used for the dashboard and admin charts.],
  [Reputation Tier], [A verifier's level based on reputation: Novice, Trusted, Expert, or Elite.],
  [Source Quality], [A credibility score for a cited website: 100 for official sources, 70 for news sites, and 30 for all others.],
  [SPA (Single-Page Application)], [A web app that changes pages in the browser without reloading from the server.],
  [Tailwind CSS], [The CSS framework used to style the application.],
  [Tesseract.js], [An OCR engine that runs inside the browser, so screenshots never leave the user's device.],
  [TypeScript], [A typed version of JavaScript used to write the codebase.],
  [Verdict], [The result given to a claim: `TRUE`, `FALSE`, `MISLEADING` (partly true but distorted), `UNVERIFIABLE` (not enough evidence), or `CONTESTED` (no quorum before the deadline).],
  [Verification], [One verifier's review of a claim: a verdict, a source link, and a written explanation.],
  [Verification Queue], [The list of claims waiting for verifiers to review them.],
  [Verifier], [A signed-in user who reviews claims and submits verdicts.],
  [Verifier Reputation], [A score from 0 to 100, starting at 50, that rises when a verifier agrees with the final consensus and falls when they do not. Only a Cloud Function can change it.],
  [Vite], [The build tool and development server used for the project.],
  [Weighted Consensus], [The method that settles a claim's verdict and Confidence Score from its verifications.],
)
