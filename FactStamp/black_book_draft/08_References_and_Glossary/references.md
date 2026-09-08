# References

*(Draft status: content-complete. Numbered academic bibliography for the unnumbered "REFERENCES" back-matter section that follows Chapter 7 — Conclusions, per `Rules/Project_syllabus.md`. Citation style mirrors `Project Synopsis/project_synopsis.typ` §14 "References & Academic Bibliography" exactly, extended with official technology documentation for every tool named in Chapter 2 — Survey of Technologies. No fabricated sources: every entry below is a real, verifiable standard, paper, or vendor documentation page.)*

---

1. IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
2. Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
3. Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146–1151, 2018.
4. Garimella, K., & Eckles, D., *"Images and misinformation in political groups: Evidence from WhatsApp in India,"* _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
5. Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547–579, 1901.
6. OWASP Foundation, *"OWASP Top Ten,"* Open Worldwide Application Security Project, 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
7. Meta Platforms, Inc., *"React — The Library for Web and Native User Interfaces,"* React Documentation, 2025. [Online]. Available: `https://react.dev/`.
8. Evan You & Vite Contributors, *"Vite — Next Generation Frontend Tooling,"* Vite Documentation, 2025. [Online]. Available: `https://vite.dev/`.
9. Microsoft Corporation, *"TypeScript — JavaScript With Syntax for Types,"* TypeScript Documentation, 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
10. Tailwind Labs Inc., *"Tailwind CSS v4 Documentation,"* 2025. [Online]. Available: `https://tailwindcss.com/docs`.
11. World Wide Web Consortium (W3C), *"CSS Color Module Level 4 (OKLCH / OKLAB Color Spaces),"* W3C Candidate Recommendation Draft, 2026. [Online]. Available: `https://www.w3.org/TR/css-color-4/`.
12. Google LLC, *"Cloud Firestore Documentation — Data Model, Security Rules & Realtime Snapshot Listeners,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
13. Google LLC, *"Firebase Authentication Documentation,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
14. Remix Software, Inc., *"React Router Documentation,"* 2025. [Online]. Available: `https://reactrouter.com/`.
15. Recharts Group, *"Recharts — A Composable Charting Library Built on React Components,"* 2025. [Online]. Available: `https://recharts.org/`.
16. Project Naptha and Tesseract.js Contributors, *"Tesseract.js — Pure JavaScript OCR for 100 Languages,"* Open-Source Software Documentation, 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
17. Bubkoo, *"html-to-image: Generates Images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

---

## Citation Notes

- Entries 1–6 are the foundational standards, methodology guide, security taxonomy, and academic literature underpinning the project's algorithmic design (Jaccard-based Duplicate Detection, Weighted Consensus) and its motivating socio-technical problem (WhatsApp misinformation in India).
- Entries 3 and 4 are the two peer-reviewed academic papers grounding the Problem Statement (Chapter 3, §3.1) and Literature Survey: Vosoughi et al. (2018) is the landmark large-scale empirical study on the differential spread velocity of false versus true news, and Garimella & Eckles (2020) is a direct empirical study of image-borne misinformation on WhatsApp in India — the exact platform and geography FactStamp targets.
- Entry 5 (Jaccard, 1901) is the original source of the Jaccard similarity coefficient that FactStamp's Duplicate Detection engine (`src/lib/duplicateDetection.ts`) implements at a $J \geq 0.75$ threshold.
- Entries 7–17 are official, vendor/maintainer-published documentation for every runtime technology named in Chapter 2 — Survey of Technologies and used in the working FactStamp codebase at `/home/aadish/Documents/Github/FactStamp` (verified against `package.json`).
- No entry in this list is invented. Where certainty about an author, title, venue, or year could not be established, the source was omitted rather than approximated.
