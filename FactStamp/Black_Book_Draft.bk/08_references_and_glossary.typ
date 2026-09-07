// =============================================================================
// FACTSTAMP: REFERENCES & GLOSSARY (DISSERTATION BACK-MATTER)
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Jai Hind College (Empowered Autonomous), University of Mumbai
// Candidate: Aadish Das (UID: 2023IT001 / Roll No.: 10)
// =============================================================================

#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

#heading(level: 1, numbering: none)[REFERENCES]

#set par(justify: true, leading: 0.65em, spacing: 0.85em)

[1] IEEE Computer Society, "IEEE Recommended Practice for Software Requirements Specifications," _IEEE Std 830-1998_, pp. 1–40, Oct. 1998, doi: 10.1109/IEEESTD.1998.88286.

[2] K. Schwaber and J. Sutherland, "The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game," _Scrum.org_, Nov. 2020. [Online]. Available: `https://scrumguides.org/scrum-guide.html`.

[3] R. S. Pressman and B. R. Maxim, _Software Engineering: A Practitioner's Approach_, 9th ed., New York, NY, USA: McGraw-Hill Education, 2020.

[4] I. Sommerville, _Software Engineering_, 10th ed., Boston, MA, USA: Pearson Education, 2015.

[5] K. Beck, _Extreme Programming Explained: Embrace Change_, 2nd ed., Boston, MA, USA: Addison-Wesley Professional, 2004.

[6] S. Vosoughi, D. Roy, and S. Aral, "The spread of true and false news online," _Science_, vol. 359, no. 6380, pp. 1146–1151, Mar. 2018, doi: 10.1126/science.aap9559.

[7] K. Garimella and D. Eckles, "Images and Misinformation in Political Groups: Evidence from WhatsApp in India," in _Proc. ACM Hum.-Comput. Interact._, vol. 4, no. CSCW2, Article 130, pp. 1–25, Oct. 2020, doi: 10.1145/3415201.

[8] G. Pennycook and D. G. Rand, "Lazy, not biased: Susceptibility to partisan fake news is better explained by lack of reasoning than by motivated reasoning," _Cognition_, vol. 188, pp. 39–50, Jul. 2019, doi: 10.1016/j.cognition.2018.06.011.

[9] P. Resnick, H. R. Zeckhauser, E. Friedman, and K. Kuwabara, "Reputation systems," _Communications of the ACM_, vol. 43, no. 12, pp. 45–48, Dec. 2000, doi: 10.1145/355112.355122.

[10] A. Bessi, F. Zollo, M. Del Vicario, A. Scala, G. Caldarelli, and W. Quattrociocchi, "Trend of narratives and misinformation in the digital age," _PLOS ONE_, vol. 10, no. 8, p. e0134989, Aug. 2015, doi: 10.1371/journal.pone.0134989.

[11] S. Bhaumik et al., "Misinformation in WhatsApp groups in India: A mixed-methods study," _The Lancet Global Health_, vol. 10, p. S18, Mar. 2022, doi: 10.1016/S2214-109X(22)00147-3.

[12] P. Jaccard, "Étude comparative de la distribution florale dans une portion des Alpes et des Jura," _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547–579, 1901.

[13] V. I. Levenshtein, "Binary codes capable of correcting deletions, insertions, and reversals," _Soviet Physics Doklady_, vol. 10, no. 8, pp. 707–710, Feb. 1966.

[14] C. D. Manning, P. Raghavan, and H. Schütze, _Introduction to Information Retrieval_, Cambridge, UK: Cambridge University Press, 2008.

[15] A. Z. Broder, "On the resemblance and containment of documents," in _Proc. Compression and Complexity of Sequences (SEQUENCES'97)_, Positano, Italy, 1997, pp. 21–29, doi: 10.1109/SEQUEN.1997.666900.

[16] M. Levinson, "Tesseract.js: Pure Javascript OCR for more than 100 Languages," 2023. [Online]. Available: `https://tesseract.projectnaptha.com`.

[17] J. R. Douceur, "The Sybil Attack," in _Peer-to-Peer Systems (IPTPS 2001)_, Lecture Notes in Computer Science, vol. 2429, P. Druschel, F. Kaashoek, and A. Rowstron, Eds. Berlin, Heidelberg: Springer, 2002, pp. 251–260, doi: 10.1007/3-540-45748-8_24.

[18] L. Lamport, R. Shostak, and M. Pease, "The Byzantine Generals Problem," _ACM Transactions on Programming Languages and Systems (TOPLAS)_, vol. 4, no. 3, pp. 382–401, Jul. 1982, doi: 10.1145/357172.357176.

[19] M. Castro and B. Liskov, "Practical Byzantine Fault Tolerance," in _Proc. 3rd USENIX Symp. Operating Systems Design and Implementation (OSDI '99)_, New Orleans, LA, USA, 1999, pp. 173–186.

[20] E. J. Friedman and P. Resnick, "The Social Cost of Cheap Pseudonyms," _Journal of Economics & Management Strategy_, vol. 10, no. 2, pp. 173–199, Jun. 2001, doi: 10.1162/105864001300122576.

[21] React Development Team, "React v18.0: Concurrent Features & Suspense Architecture," Meta Open Source, Mar. 2022. [Online]. Available: `https://react.dev/blog/2022/03/29/react-v18`.

[22] E. You et al., "Vite: Next Generation Frontend Tooling," Vite Core Documentation, 2024. [Online]. Available: `https://vitejs.dev`.

[23] Tailwind Labs, "Tailwind CSS v4.0: High-Performance Rust Engine & Modern Color Systems," Tailwind CSS Documentation, 2024. [Online]. Available: `https://tailwindcss.com`.

[24] W3C, "Scalable Vector Graphics (SVG) 2.0 Specification," World Wide Web Consortium, W3C Candidate Recommendation Draft, 2023. [Online]. Available: `https://www.w3.org/TR/SVG2/`.

[25] Bubkoo, "html-to-image: Generates images from HTML nodes using SVG foreignObject and Canvas," Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

[26] B. Otten, "A perceptual color space for image processing (Oklab)," 2020. [Online]. Available: `https://bottosson.github.io/posts/oklab/`.

[27] M. D. Fairchild, _Color Appearance Models_, 3rd ed., Chichester, UK: John Wiley & Sons, 2013.

[28] A. Somers, "Accessible Perceptual Contrast Algorithm (APCA): Advanced Contrast Model for WCAG 3.0," Inclusive Reading Technologies, Inc. / W3C Silver Task Force, 2024. [Online]. Available: `https://github.com/Myndex/SAPC-APCA`.

[29] W3C, "Web Content Accessibility Guidelines (WCAG) 2.1," W3C Recommendation, World Wide Web Consortium, Jun. 2018. [Online]. Available: `https://www.w3.org/TR/WCAG21/`.

[30] Google Firebase Documentation, "Cloud Firestore Security Rules & Realtime Snapshot Listeners," Google Developers, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.

[31] D. Hardt, Ed., "The OAuth 2.0 Authorization Framework," Internet Engineering Task Force (IETF), RFC 6749, Oct. 2012, doi: 10.17487/RFC6749.

[32] M. Jones, J. Bradley, and N. Sakimura, "JSON Web Token (JWT)," Internet Engineering Task Force (IETF), RFC 7519, May 2015, doi: 10.17487/RFC7519.

[33] OWASP Foundation, "OWASP Top 10: 2021 The Ten Most Critical Web Application Security Risks," Open Web Application Security Project, 2021. [Online]. Available: `https://owasp.org/Top10/`.

[34] W3C, "Content Security Policy Level 3," W3C Working Draft, World Wide Web Consortium, 2023. [Online]. Available: `https://www.w3.org/TR/CSP3/`.

[35] M. Haug and L. Mädler, "Typst: A Programmable Markup-Based Typesetting System," Berlin, Germany: Typst GmbH, 2023. [Online]. Available: `https://typst.app`.

[36] Typst Community, "Typst Documentation & Package Ecosystem," Typst Documentation, 2024. [Online]. Available: `https://typst.app/docs`.

[37] W3C, "CSS Fonts Module Level 4: Font Variant and Numeric Properties," World Wide Web Consortium, W3C Candidate Recommendation Draft, 2024. [Online]. Available: `https://www.w3.org/TR/css-fonts-4/`.

[38] Graphify Development Team, "Graphify: AST-Driven Codebase Knowledge Graph & Topological Dependency Analysis," 2026. [Online]. Available: `https://github.com/aadish0day/FactStamp/tree/main/graphify-out`.

#pagebreak()

#heading(level: 1, numbering: none)[GLOSSARY]

#set par(justify: true, leading: 0.65em, spacing: 0.65em)

This glossary provides authoritative, alphabetical definitions for 44 specialized technical terms, algorithms, standards, and architectural concepts utilized throughout the *FactStamp* academic dissertation and software implementation. Each entry details the formal computing definition alongside its specific operational context and architectural significance within the FactStamp platform.

#v(8pt)

#styled-table(
  columns: (2.0in, 1fr),
  headers: ("Term / Acronym", "Academic Definition & Operational Significance in FactStamp"),
  [*Accessible Perceptual Contrast Algorithm (APCA)*], [An advanced, perception-based contrast prediction algorithm developed for the upcoming W3C Web Content Accessibility Guidelines (WCAG) 3.0. Unlike legacy WCAG 2.1 flat mathematical ratios, APCA computes lightness contrast ($L_c$) considering spatial frequency, ocular adaptation, font weight, and non-linear visual perception. \
  _FactStamp Context:_ Used to calibrate the OKLCH theme palette, guaranteeing body text achieves $|L_c| >= 75$ and interactive controls achieve $|L_c| >= 60$ across both light and dark display modes under harsh Indian ambient sunlight.],

  [*Admin Command Center*], [A dedicated administrative console (`/admin`, `src/pages/Admin.tsx`) providing real-time datastore synchronization, claim queue moderation, verifier auditing, and platform management tools. \
  _FactStamp Context:_ Implemented in Milestone 1 with integrated dark/light theme controls, an Admin Route password gate (`src/components/AdminRoute.tsx`), and real-time moderation report inspection.],

  [*Agreement Ratio ($A$)*], [A normalized quantitative metric ($0–100\%$) indicating the degree of consensus among independent verifiers participating in a quorum. Computed as the count of votes supporting the majority verdict candidate divided by total submitted verifications: $A = (N_("majority") / N_("total")) times 100$. \
  _FactStamp Context:_ Represents a primary component (weighted at 40%) in the multi-factor confidence scoring formula ($C = 0.40A + 0.30R + 0.30S$).],

  [*Base64 Encoding*], [A binary-to-text encoding scheme translating arbitrary binary data into printable ASCII strings using a radix-64 representation. \
  _FactStamp Context:_ In FactStamp, compressed screenshot canvas bitmaps are encoded as data URIs (`data:image/jpeg;base64,...`) and stored directly within Firestore claim documents, strictly clamped under 500 KB to eliminate external cloud storage egress costs.],

  [*Byzantine Fault Tolerance (BFT)*], [The dependability property of a distributed computing system where nodes must reach consensus in the presence of arbitrary, potentially malicious failures or adversarial actors (the Byzantine Generals Problem). \
  _FactStamp Context:_ FactStamp incorporates BFT principles into its 3-verifier quorum model, ensuring consensus can be safely finalized despite the presence of bad-faith outlier votes or burner accounts.],

  [*ClaimReview Schema*], [A globally standardized schema.org JSON-LD semantic markup framework maintained by Google and the International Fact-Checking Network (IFCN). \
  _FactStamp Context:_ Planned in Chapter 7.3 for search engine indexing of community verdicts and bi-directional federation with the Google Fact Check Tools API.],

  [*ClaimStatus*], [The formal lifecycle enumeration of a claim record in the FactStamp database (`src/lib/types.ts`), taking one of two states: `'pending'` (active in the verification queue) or `'verified'` (resolved by quorum consensus or deliberation timeout). \
  _FactStamp Context:_ Used by `ClaimsContext.tsx` and Firestore queries to partition pending investigative queues from certified public dossiers.],

  [*Client-Side Rasterization*], [The process of converting Document Object Model (DOM) tree structures, styled cascading stylesheets, and vectorized typography directly into raster pixel grids (e.g., PNG format) entirely within the user's web browser, without transmitting layout data to an intermediate cloud rendering server. \
  _FactStamp Context:_ Performed by `html-to-image` via browser-native SVG `<foreignObject>` canvas rasterization to compile 1080×1080px fact-check PNG cards in $< 650$ ms.],

  [*Cloud Firestore*], [A managed, globally distributed, multi-region NoSQL document database provided by Google Cloud and Firebase. Features native WebSocket-based real-time snapshot listeners (`onSnapshot`), sub-50ms synchronization latencies, offline edge persistence, and declarative security rules. \
  _FactStamp Context:_ Serves as FactStamp's primary cloud datastore for `claims`, `verifications`, `users`, and `notifications` within the zero-cost Spark tier.],

  [*Confidence Score ($C$)*], [A composite algorithmic rating ($0–100\%$) expressing the mathematical certainty of a certified fact-check verdict once a claim achieves the minimum 3-verifier quorum ($N >= 3$). \
  _FactStamp Context:_ Computed via the weighted linear combination $C = (A times 40%) + (R times 30%) + (S times 30%)$, combining verifier agreement ratio ($A$), average historical reputation ($R$), and primary source credibility ($S$).],

  [*Contested Verdict (CONTESTED)*], [An official certified verdict state (`src/lib/types.ts`) assigned to a claim when participating verifiers submit split, non-converging votes or when unverified claims exceed the mandatory 7-day deliberation window (`applyLocalExpiry`). \
  _FactStamp Context:_ Rendered with an electric blue badge (`hexColor: #2563eb`, `hexBg: #eff6ff`), signaling an unresolved controversy or evidentiary impasse.],

  [*Dark Social*], [Communication channels and digital interactions that occur within private, encrypted, or closed peer-to-peer applications (such as WhatsApp, Signal, Telegram, and private chat groups) rather than public broadcast social networks. Dark social referrals cannot be indexed by search engine crawlers or tracked by public web analytics. \
  _FactStamp Context:_ The core operational domain targeted by FactStamp. Because WhatsApp misinformation spreads inside dark social groups, FactStamp empowers users to extract claims and return visual counter-cards directly into the closed originating chat.],

  [*Data Flow Diagram (DFD)*], [A formal visual modeling notation representing the functional decomposition of a software system, illustrating the paths through which information moves from external entities through transformation processes to data repositories. \
  _FactStamp Context:_ Developed in Chapter 3 at Level 0 (Context Diagram), Level 1 (Subsystem Overview), and Level 2 (Detailed Module Logic) using Graphviz `.dot` syntax.],

  [*Devanagari Script Normalization*], [The computational linguistics process of normalizing Unicode codepoints for text written in Devanagari script (Hindi, Marathi), standardizing matras (vowel signs), viramas, and conjuncts prior to set-theoretic tokenization. \
  _FactStamp Context:_ Handled prior to duplicate detection and paired with `Noto Sans Devanagari` font rendering to prevent broken typography baselines.],

  [*Duplicate Detection Engine*], [The subsystem responsible for identifying semantically recurring WhatsApp forwards to eliminate redundant human verification labor. \
  _FactStamp Context:_ Implemented in `src/lib/duplicateDetection.ts` using set-theoretic tokenized Jaccard similarity, achieving a mean resolution latency of 78.4 ms at $J >= 0.75$.],

  [*End-to-End Encryption (E2EE)*], [A secure communications mechanism where data is encrypted on the sender's device and decrypted only on the recipient's final device, preventing intermediate network switches, telecom providers, and server operators from intercepting message plaintext. \
  _FactStamp Context:_ Governs WhatsApp communications. FactStamp respects E2EE completely by operating strictly as an external, user-initiated verification tool rather than an invasive chat scraper.],

  [*False Verdict (FALSE)*], [An official certified verdict state (`src/lib/types.ts`) assigned when quorum consensus establishes that a forwarded claim is factually fabricated, doctored, or debunked by authoritative primary evidence. \
  _FactStamp Context:_ Rendered with a high-contrast crimson badge (`hexColor: #dc2626`, `hexBg: #fef2f2`) and double-encoded with an `XCircle` icon.],

  [*ForeignObject (SVG `<foreignObject>`)*], [An element in the Scalable Vector Graphics (SVG) 2.0 specification that permits the direct inclusion and layout rendering of arbitrary HTML and CSS DOM fragments within an SVG drawing canvas. \
  _FactStamp Context:_ The core rendering technology used by `html-to-image` to bypass buggy JavaScript CSS parsers and rasterize live Tailwind CSS v4 OKLCH elements into high-resolution PNG images.],

  [*Google Fact Check Tools API*], [A globally standardized REST API maintained by Google and the IFCN allowing programmatic access to verified fact-checks published worldwide. \
  _FactStamp Context:_ Outlined in Chapter 7.3 for bi-directional federation to reduce cold-start verification latency for known viral claims from 4.2 hours to $< 5$ minutes.],

  [*Graphify Knowledge Graph*], [An AST-driven code intelligence engine that extracts topological dependencies, community clusters, and god-node centrality from source code without API costs. \
  _FactStamp Context:_ Integrated in Milestone 2 (`graphify-out/`), mapping FactStamp's 89 files, 1,743 nodes, 3,640 edges, and 94 architectural communities, revealing core abstractions like `useAuth()`, `cn()`, and `firebaseService.ts`.],

  [*HTML5 Canvas API*], [A standard browser JavaScript interface allowing dynamic, scriptable 2D rendering and pixel manipulation on a bitmap surface element (`<canvas>`). \
  _FactStamp Context:_ Utilized in `src/pages/Submit.tsx` to downsample user-uploaded screenshots to a maximum 1200px boundary, achieving an 89.2% file size reduction before base64 encoding.],

  [*html-to-image*], [A lightweight client-side DOM-to-image library that utilizes SVG `<foreignObject>` and Canvas rasterization to compile HTML elements into PNG bitmaps. \
  _FactStamp Context:_ Powers FactStamp's Fact-Check Card engine (`src/components/FactCheckCard.tsx`), producing WhatsApp-optimized 1080×1080px square PNGs in sub-650 ms.],

  [*IndicBERT*], [A multilingual ALBERT-based transformer model pre-trained on 12 major Indian languages and English. \
  _FactStamp Context:_ Proposed in Chapter 7.3 as a future dense vector embedding backbone for cross-lingual duplicate detection between English and regional vernacular forwards ($cos(theta) >= 0.88$).],

  [*Jaccard Similarity Index*], [A set-theoretic statistic used for gauging the similarity and diversity of sample sets, defined mathematically as the size of the intersection divided by the size of the union of two sets: \
  $J(A, B) = (|A inter B|) / (|A union B|)$ \
  _FactStamp Context:_ Powers the duplicate detection engine (`src/lib/duplicateDetection.ts`). Claims with normalized token overlap $J >= 0.75$ are classified as duplicates, achieving 96.4% suppression accuracy in 78.4 ms.],

  [*Levenshtein Distance*], [The minimum number of single-character edits (insertions, deletions, or substitutions) required to transform one string into another. \
  _FactStamp Context:_ Evaluated in Chapter 2 during string algorithm benchmarks; superseded by token-level Jaccard similarity due to $O(M times N)$ asymptotic overhead on long forwarded paragraphs.],

  [*Misleading Verdict (MISLEADING)*], [An official certified verdict state (`src/lib/types.ts`) assigned when a claim contains a kernel of truth but is selectively edited, decontextualized, or presented with exaggerated causal links. \
  _FactStamp Context:_ Rendered with an amber badge (`hexColor: #d97706`, `hexBg: #fffbeb`) and double-encoded with an `AlertTriangle` icon.],

  [*Multi-Tiered Rate Limiting & Brute-Force Guard*], [An enterprise security mechanism engineered to protect verifier accounts and administrative gates against credential-stuffing and automated dictionary attacks (`src/lib/security.ts`). \
  _FactStamp Context:_ Implemented in Milestone 5, enforcing a 5-attempt threshold, 15-minute lockout (`LOCKOUT_DURATION_MS = 15 * 60 * 1000`), dual-level account and client tracking in `localStorage` with `sessionStorage` fallback, real-time ticking MM:SS countdowns (`formatLockoutRemaining()`), and generic anti-enumeration errors.],

  [*NoSQL Document Database*], [A non-relational database architecture that organizes data into flexible, semi-structured document records (typically JSON or BSON) grouped into collections, rather than rigid relational tabular schemas. \
  _FactStamp Context:_ Implemented via Google Cloud Firestore, enabling hierarchical nesting of verification arrays within claim documents.],

  [*OKLCH Color Model*], [A modern cylindrical color space based on the Oklab appearance space, defined by Lightness ($L$), Chroma ($C$), and Hue angle ($H$). Unlike sRGB, OKLCH provides uniform perceptual lightness across different hues, eliminating visual brightness distortion. \
  _FactStamp Context:_ The native color model for FactStamp's Tailwind CSS v4 design tokens (`DESIGN.md`). Pure black (`#000000`) is strictly banned in favor of warm charcoal ink (`oklch(0.14 0.020 55)`).],

  [*Optical Character Recognition (OCR)*], [The computational conversion of images containing typed or printed text into machine-encoded character strings. \
  _FactStamp Context:_ Handled client-side via Tesseract.js WebAssembly (`tesseract.js`), extracting forward text from uploaded screenshots with 98.2% character accuracy on digital captures.],

  [*Pan-Indic Typography Architecture*], [FactStamp's high-trust typographic system engineered in Milestone 6 to replace heavy multi-font stacks with an authoritative, vernacular-ready newsroom aesthetic. \
  _FactStamp Context:_ Combines variable `Plus Jakarta Sans` (400..800) for Latin editorial clarity, `Noto Sans Devanagari` (400..700) for native Hindi/Marathi forwards with zero broken baselines, native CSS `tabular-nums` at 0 KB extra payload, and quarantined forward quotes banning romantic serifs.],

  [*Progressive Web App (PWA)*], [A software application delivered through the web, built using common web technologies (HTML, CSS, JavaScript, WebAssembly), intended to function on any platform with native-like capabilities (offline caching, background sync). \
  _FactStamp Context:_ Articulated in Chapter 7.3 as a planned enhancement utilizing Service Workers and IndexedDB for low-bandwidth rural offline usage.],

  [*Quorum Consensus ($N >= 3$)*], [A distributed decision-making protocol in which an action or state transition is certified only after receiving independent approval from a predetermined minimum threshold of participating nodes or actors ($N >= 3$). \
  _FactStamp Context:_ Governs the Verification Queue. A submitted claim remains pending until three distinct community verifiers independently review evidence and cast votes.],

  [*Recharts*], [A declarative, React-native charting library built on SVG rendering and React component lifecycles. \
  _FactStamp Context:_ Utilized in `src/components/DashboardChart.tsx` to visualize weekly misinformation trends, category distributions, and verifier leaderboards.],

  [*Reputation Score ($R$)*], [A dynamic numerical metric ($0–100$ scale) assigned to each authenticated verifier representing their historical veracity record. New verifiers initialize at a baseline of 50. Accurate votes that match certified quorum consensus reward points ($+5$ to $+10$), while bad-faith outlier votes deduct points ($-15$). \
  _FactStamp Context:_ Weighted at 30% in the consensus confidence scoring formula.],

  [*Role-Based Access Control (RBAC)*], [A computer security approach that restricts system access to authorized users based on predefined organizational roles (`User`, `Verifier`, `Admin`). \
  _FactStamp Context:_ Enforced via Firestore Security Rules and client-side route guards (`src/components/AdminRoute.tsx`).],

  [*Small Language Model (SLM)*], [A lightweight neural generative language model (typically 100M to 2B parameters) quantized to low-bit representations (4-bit INT4) capable of executing efficiently on consumer device hardware without cloud server dependencies. \
  _FactStamp Context:_ Planned in Chapter 7.3 for in-browser claim decomposition and assisted verifier draft generation via WebGPU.],

  [*Source Credibility Score ($S$)*], [A normalized score ($0–100$) evaluating the trustworthiness of external evidence URLs cited by verifiers: \
  - *Tier 1 (High Quality, 100 pts):* Official government, WHO, ICMR, court records. \
  - *Tier 2 (Medium Quality, 70 pts):* Accredited national news organizations and wire services. \
  - *Tier 3 (Low Quality, 30 pts):* Unverified blogs or social media commentary. \
  _FactStamp Context:_ Weighted at 30% in the consensus formula.],

  [*Sybil Attack*], [A security vulnerability in distributed and peer-to-peer networks where an adversary undermines system reputation and consensus by creating a large number of pseudonymous identities. \
  _FactStamp Context:_ Neutralized in FactStamp through weighted reputation scoring, strict self-verification blocks, and domain quality requirements.],

  [*Tabular Figures (CSS tabular-nums)*], [An OpenType typographic feature (`font-variant-numeric: tabular-nums`) where all numerals share an identical fixed advance width, preventing visual jitter during counter and timer animations. \
  _FactStamp Context:_ Implemented in Milestone 6 across all countdown timers (`5d 23h left`), consensus ratios (`0/3`), and case IDs (`#C19`) at 0 KB additional network payload.],

  [*Tesseract.js*], [A pure JavaScript and WebAssembly compilation of the open-source Tesseract OCR engine, running entirely within web browser client workers. \
  _FactStamp Context:_ Used for client-side text extraction from WhatsApp screenshots at zero cloud API cost.],

  [*True Verdict (TRUE)*], [An official certified verdict state (`src/lib/types.ts`) assigned when quorum consensus establishes that a forwarded claim is factually accurate and corroborated by authoritative primary evidence. \
  _FactStamp Context:_ Rendered with a forest emerald badge (`hexColor: #16a34a`, `hexBg: #f0fdf4`) and double-encoded with a `CheckCircle` icon.],

  [*Trust Ring*], [A circular SVG progress indicator rendered around verifier profile avatars in FactStamp. \
  _FactStamp Context:_ Dynamically visualizes a verifier's reputation score on a 0–100 scale using color-coded progress strokes (green for high trust, blue for good, amber for baseline, red for probationary).],

  [*Universal Sliding Theme Toggle (`<ThemeToggle />`)*], [A bespoke, kinetic dual-icon sliding pill component (`src/components/ui/ThemeToggle.tsx`) engineered in Milestone 3. \
  _FactStamp Context:_ Features a compact `w-16 h-8` pill container, animated sliding thumb with 300ms transitions, dual-state Lucide Sun and Moon icons, and universal deployment across Navbar, Admin Header & Tools, Admin Route Gate, AuthLayout, and Footer.],

  [*Unverifiable Verdict (UNVERIFIABLE)*], [An official certified verdict state (`src/lib/types.ts`) assigned when an ingested forward represents an unfalsifiable subjective opinion, personal belief, prophecy, or claim lacking empirical documentation. \
  _FactStamp Context:_ Rendered with a slate gray badge (`hexColor: #475569`, `hexBg: #f8fafc`) and double-encoded with a `HelpCircle` icon.],

  [*Verdict Stamp*], [A high-impact visual badge designed to resemble an official physical rubber stamp, displayed on verified claims and exported PNG cards. \
  _FactStamp Context:_ Renders one of five certified states: `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, or `CONTESTED`, featuring tactile depression animations, color-blind safe iconography, and high APCA contrast.],

  [*Verification Queue Settlement & Dynamic Replenishment*], [An automated lifecycle management engine in `src/contexts/ClaimsContext.tsx` delivered in Milestone 4. \
  _FactStamp Context:_ Solved the empty queue issue by settling overdue unverified claims after 7 days into `CONTESTED` status via `applyLocalExpiry` while dynamically generating seed claims with future deadlines (3–6 days), guaranteeing verifiers always have active claims to review.],

  [*Vite 5*], [A high-performance modern frontend build tool and development server created by Evan You, featuring native ECMAScript Module (ESM) serving and extremely fast Hot Module Replacement (HMR). \
  _FactStamp Context:_ Powers the FactStamp application build pipeline and development environment.],

  [*WebAssembly (WASM)*], [A binary instruction format for a stack-based virtual machine, designed as a portable compilation target for programming languages (C, C++, Rust), enabling near-native execution speed inside web browsers. \
  _FactStamp Context:_ Executes the Tesseract.js OCR engine and planned future Whisper/SLM inference engines directly within the client browser.],

  [*WebGPU*], [A modern web API providing hardware-accelerated 3D graphics and generalized parallel compute capabilities directly to web applications, replacing legacy WebGL. \
  _FactStamp Context:_ Identified in Chapter 7.3 as the underlying compute runtime for in-browser SLM inference.],

  [*Whisper.wasm*], [A lightweight, WebAssembly-compiled implementation of OpenAI's Whisper automatic speech recognition model. \
  _FactStamp Context:_ Planned for in-browser transcription of forwarded WhatsApp `.opus` vernacular voice notes directly into Unicode text strings.],

  [*Work Breakdown Structure (WBS)*], [A hierarchical decomposition of the total scope of work to be carried out by the project team to accomplish the project objectives and create the required deliverables. \
  _FactStamp Context:_ Utilized in Chapter 3 to schedule sprints, milestones, and deliverables under Course JUSIT-DSCPR503.],

  [*Zero-Knowledge / Privacy-Preserving Architecture*], [A system design principle ensuring that sensitive user communications, personal phone numbers, and private chat contexts are never logged, decrypted, or transmitted to centralized server backends. \
  _FactStamp Context:_ FactStamp enforces this by performing image compression, OCR, and card rasterization locally within the client browser.]
)
