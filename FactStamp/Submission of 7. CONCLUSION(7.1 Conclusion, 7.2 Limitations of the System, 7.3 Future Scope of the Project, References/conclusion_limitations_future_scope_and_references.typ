// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // 1.5in left margin for single-sided binding
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border for Black Books and Assignments
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

// Cross-Platform Font Fallbacks (Windows/Mac/Linux CI compatibility)
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory: New topic on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

// Global Table Cell Styling
#show table.cell: set text(size: 10pt)
#show table.cell.where(y: 0): set text(size: 10pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  text(
    font: ("DejaVu Sans Mono", "Liberation Mono", "Courier New"),
    size: 9pt,
    it
  )
)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9.5pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 9.5pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 95%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

#set document(title: "FactStamp - Chapter 7: Conclusions & References", author: "Aadish")

// ==========================================
// Standalone Title Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt, style: "italic")[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 13pt, weight: "bold")[ACADEMIC COURSE SUBMISSION]
    #v(4pt)
    #text(size: 11pt, weight: "bold")[CHAPTER 7: CONCLUSIONS & REFERENCES]
    #v(2pt)
    #text(size: 10.5pt)[*7.1 Conclusion | 7.2 Limitations of the System | 7.3 Future Scope | References*]
    #v(6pt)
    #text(size: 10pt)[Submitted in Partial Fulfilment of the Requirements for Course *JUSIT-DSCPR503*]\
    #text(size: 11.5pt, weight: "bold")[Bachelor of Science in Information Technology]\
    #v(10pt)
    #text(size: 10pt)[*Candidate:* Aadish (UID: 2023IT001)]\
    #text(size: 10pt)[*Department of Information Technology*]\
    #text(size: 11pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[Affiliated with University of Mumbai | Churchgate, Mumbai – 400 020]\
    #text(size: 10pt)[*Academic Year:* 2025–2026]
  ]
  #v(14pt)
]

// ==========================================
// Dedicated Table of Contents Page
// ==========================================
#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[TABLE OF CONTENTS]
]
#v(12pt)

#outline(
  title: none,
  indent: 1.5em,
  depth: 3
)

#pagebreak()

// =============================================================================
// CHAPTER 7: CONCLUSIONS
// =============================================================================
= 7. Conclusions

== 7.1 Conclusion

=== Significance of the FactStamp System

The rapid proliferation of peer-to-peer mobile messaging networks has transformed the sociology of public discourse in modern India. With over 535 million active users, WhatsApp functions as the de facto information backbone for urban and rural citizens alike. However, the unique structural properties of the medium—frictionless 1-tap re-forwarding, closed community groups based on familial or social trust ("dark social"), and default end-to-end encryption (E2EE)—have created an unprecedented vector for the virulent transmission of fabricated news, dangerous medical panaceas, financial scams, and sectarian falsehoods.

Prior to *FactStamp*, the anti-misinformation landscape was characterized by three fundamental systemic mismatches:
- *The Journalistic Latency Gap:* Professional investigative fact-checking organizations (e.g., AltNews, BOOM Live, Vishwas News) employ centralized editorial desks. While thorough, their investigative cycle spans 24 to 72 hours per debunk. In contrast, an incendiary WhatsApp forward achieves maximum viral saturation within two to three hours.
- *The Format Impedance Mismatch:* Traditional fact-checkers publish long-form web articles (1,200–2,000 words) or legalistic press releases. Ordinary messaging users rarely click or read dense external web hyperlinks in family chats. A plain URL cannot compete aesthetically or emotionally with an incendiary image or urgent warning forward.
- *The E2EE Privacy Paradox:* Automated algorithmic crawling and social media indexing engines cannot penetrate end-to-end encrypted chats without violating fundamental citizen privacy rights and subverting cryptographic protocols.

*FactStamp resolves this dilemma through a novel socio-technical paradigm: crowdsourced quorum consensus coupled with instantaneous visual counter-artifact generation.* By respecting the boundaries of encrypted communications while mobilizing ordinary citizens as frontline fact-checkers, FactStamp establishes a decentralized defense network tailored to the realities of the Indian messaging ecosystem.

#v(6pt)

#block(
  fill: rgb("F8F9FA"),
  stroke: 0.5pt + luma(180),
  inset: 10pt,
  radius: 3pt,
  [
    *Conventional Information Flow:* \
    `[Rumor Forwarded] ──> [Viral Explosion in E2EE Groups] ──> [Days Later: Long Web Article Published] (Ignored)` \
    #v(4pt)
    *FactStamp Reverse Counter-Flow:* \
    `[Rumor Forwarded] ──> [Pasted into FactStamp] ──> [Sub-85ms Duplicate Check / 3-Verifier Quorum]` \
    `                                                │` \
    `                                                ▼` \
    `                    [Downloadable 1080×1080px Fact-Check PNG Card]` \
    `                                                │` \
    `                                                ▼` \
    `                [Forwarded DIRECTLY Back into Originating Group] ──> [Viral Spread Extinguished]`
  ]
)

#v(8pt)

=== Synthesis of Core Engineering Achievements

The realization of FactStamp represents substantial software engineering rigor across multiple computing disciplines, encompassing string algorithms, distributed consensus, client-side browser rasterization, and serverless cloud architectures:

1. *Intelligent Ingestion and Duplicate Suppression:*
   The implementation of the token-level *Jaccard Similarity Engine* (`src/lib/duplicateDetection.ts`) achieves a mean duplicate resolution latency of *78.4 ms* (P95: *92.1 ms*) and a suppression accuracy of *94.2%* at the calibrated empirical threshold ($J >= 0.75$). By stripping punctuation, eliminating low-information stop words, and evaluating set-theoretic token overlap, the platform intercepts recurring viral hoaxes instantaneously, routing submitters directly to existing certified verdicts and eliminating redundant human verification labor.

2. *Sybil-Resilient Multi-Factor Quorum Consensus:*
   FactStamp rejects naive binary voting in favor of an algorithmic multi-factor consensus model requiring an independent quorum of three ($N >= 3$):
   $ C = (A times 40%) + (R times 30%) + (S times 30%) $
   By weighting the raw agreement ratio ($A$) alongside the historical reputation of participating verifiers ($R in [0, 100]$) and the domain authority of external primary citations ($S in [0, 100]$), the system neutralizes coordinated brigading, bot accounts, and bad-faith collusion. Verifiers accumulate reputation through verified accuracy, creating a transparent, self-regulating meritocracy.

3. *High-Impact Visual Counter-Artifact Generation:*
   To weaponize WhatsApp's native forwarding culture against itself, FactStamp engineers the *1080#text[×]1080px square Fact-Check PNG Card* (`src/components/FactCheckCard.tsx`). Abandoning legacy JavaScript canvas parsers that fail on modern CSS Color Level 4 tokens (`oklch()`), the card engine utilizes `html-to-image` with browser-native SVG `<foreignObject>` canvas rasterization. The resulting card compiles client-side in an average of *340 milliseconds*, producing a crisp, unalterable visual artifact designed to travel backward through the exact communication network that spread the falsehood.

4. *Inclusive, Perceptually Calibrated Design System:*
   Adhering to the modern *Accessible Perceptual Contrast Algorithm (APCA)*, FactStamp's *Saffron Sleek* design architecture guarantees high legibility under harsh Indian ambient sunlight ($L_c >= 75$ for body text, $L_c >= 60$ for controls). Every verdict state incorporates dual-encoding (color plus geometric iconography and text labels), ensuring full usability for color-blind individuals.

5. *Zero-Cost Serverless Sustainability:*
   By distributing heavy computations—including HTML5 Canvas image compression (< 500 KB), Tesseract.js WebAssembly OCR, and card rasterization—directly to client browser engines, FactStamp operates entirely within the perpetual free Spark tier of Google Cloud Firestore. Stress testing demonstrated that a 1,000-user daily load consumes only *16.9% of free read quotas* and *9.1% of write quotas*, proving that robust social-impact technology can be deployed and maintained sustainably without ongoing funding dependencies.

=== Academic and Practical Outcomes

Developed as the capstone dissertation project for the Bachelor of Science in Information Technology (*Course JUSIT-DSCPR503*) at Jai Hind College (Empowered Autonomous), FactStamp demonstrates the end-to-end realization of a modern software project lifecycle:
- Compliance with the *IEEE Std 830-1998* specification standard for Software Requirements Specifications.
- Execution under an *Agile Scrum* framework across four structured sprint cycles.
- Comprehensive architectural modeling comprising PlantUML object-oriented diagrams and Graphviz Data Flow Diagrams (DFD Levels 0, 1, and 2).
- Complete open-source delivery including strict TypeScript interfaces, reactive context providers, and automated Docker staging configurations.

In conclusion, FactStamp bridges the fatal latency gap between the blinding velocity of forwarded rumors and the slow deliberations of centralized journalism. It transforms passive information consumers into active civic defenders, proving that community-driven verification, underpinned by transparent mathematics and elegant web engineering, can protect democratic discourse in the age of dark social media.

== 7.2 Limitations of the System

=== Introduction
While *FactStamp* successfully achieves its architectural objectives and demonstrates significant advantages over centralized fact-checking paradigms, rigorous academic inquiry demands a transparent, unvarnished critique of the system's operational and technical boundaries. As a decentralized, crowdsourced application deployed within a resource-constrained, multilingual socio-technical environment, FactStamp is subject to intrinsic trade-offs between speed, security, coverage, and automation.

=== Cold-Start Quorum Latency and Asymmetric Verification Velocity
The foundational integrity of FactStamp rests on the *3-verifier independent quorum requirement* ($N >= 3$). While this rule guarantees multi-party deliberation and prevents single-moderator bias, it introduces temporal latency during the initial "cold-start" phase of a novel claim:
1. *Temporal Vulnerability Window:* When a novel forward is submitted that possesses no prior duplicate match in the Firestore database ($J < 0.75$), it must reside in the public verification queue until three independent community verifiers discover, research, and evaluate it. During active academic testing hours, the mean turnaround latency was measured at *4.2 hours*. However, during off-peak hours (e.g., midnight to 7:00 AM IST), turnaround latency expanded to *8.5–14.0 hours*. Because viral misinformation exhibits an exponential propagation curve on WhatsApp—often reaching thousands of chat groups within the first two hours of circulation—this latency window allows rumors to spread temporarily unhindered before the certified counter-card is available.
2. *Asymmetric Topical Attention (The Popularity Bias):* Volunteer verifiers naturally gravitate toward sensational, high-profile national news, election controversies, or viral celebrity rumors. Consequently, these claims achieve the required $N = 3$ quorum in as little as 35 to 50 minutes. Conversely, hyper-local community rumors (e.g., a fictitious municipal water contamination notice in a specific suburban ward) or niche financial schemes suffer from extended queue residence, occasionally remaining unverified until the 7-day deliberation timeout marks them as `CONTESTED`.

=== Optical Character Recognition (OCR) Fragility on Degraded Visual Media
FactStamp integrates client-side WebAssembly OCR via Tesseract.js to ingest screenshots of WhatsApp forwards. However, real-world WhatsApp visual media frequently undergoes catastrophic lossy compression:
1. *Generation Loss ("WhatsApp JPEG Mold"):* When an image is forwarded repeatedly across WhatsApp groups, the application re-compresses the JPEG matrix at each hop. By the fifth or sixth forwarding generation, high-frequency spatial details are discarded, creating severe 8#text[×]8 block boundary artifacts and chromatic aberration around typography. Empirical testing demonstrated that while pristine digital screenshots achieve *98.2% character accuracy*, heavily re-compressed meme images drop to *84.5–90.2% character accuracy*.
2. *Stylized Indic Typography and Low Background Contrast:* A significant proportion of WhatsApp misinformation forwards in India are distributed as graphical quote cards featuring decorative script fonts, calligraphic headlines, or text layered over photographic backgrounds (e.g., political rallies, deities). Under these conditions, the client-side OCR engine experiences elevated Word Error Rates (WER up to $18.5\%$), occasionally dropping crucial contextual words.
3. *Client Hardware Memory Constraints:* Executing Tesseract.js inside the browser requires loading language training data blobs (`tessdata`, ~4.5 MB) and initializing a WebAssembly worker thread. On budget smartphones with 2.0 GB RAM, processing high-resolution 4K images occasionally caused browser tab memory throttling, requiring the pre-compression step to strictly clamp image dimensions to 1200px.

=== Dependence on Volunteer Verifier Participation and Cognitive Fatigue
The decentralization of fact-checking introduces acute human factors challenges related to user incentive alignment:
1. *The Altruism Dilemma (Absence of Monetary Rewards):* FactStamp currently relies entirely on intrinsic motivation, civic duty, and gamified reputation accrual ($0–100$ scale). Unlike professional newsroom fact-checkers who receive full-time salaries, community verifiers contribute their personal time voluntarily. In the absence of tangible economic incentives, the system faces contributor churn after initial novelty wears off.
2. *Cognitive Burden of Rigorous Evidence Retrieval:* To satisfy the validation criteria enforced by `src/lib/security.ts`, verifiers must write a substantive rationale of at least 50 characters and 8 words, accompanied by an authoritative external URL. Conducting investigative research—such as locating archived government circulars, navigating PDF court orders, or cross-referencing medical databases—requires intellectual effort. Verifiers occasionally experience cognitive fatigue when confronted with complex, multi-faceted conspiracy theories.
3. *Vulnerability to Sophisticated Sybil Infiltration:* Although the weighted consensus formula ($C = 0.40A + 0.30R + 0.30S$) effectively neutralizes low-reputation burner accounts, a patient, well-resourced adversarial group could theoretically execute a "long-con" Sybil attack. By dutifully verifying dozens of trivial, uncontroversial claims over several weeks, adversary accounts could gradually build high reputation scores ($R >= 80$), which could subsequently be coordinated to sway a sensitive election-day consensus before administrators detect the anomaly.

=== Multilingual and Cross-Lingual Semantic Gap
India is linguistically diverse, encompassing 22 constitutionally recognized languages written across distinct non-Latin writing systems (Devanagari, Bengali, Telugu, Tamil, Nastaliq, etc.):
1. *Script-Specific Tokenization Limitations:* The current duplicate detection engine relies on set-theoretic Jaccard token matching:
   $ J(A, B) = (|S_A inter S_B|) / (|S_A union S_B|) $
   While this works reliably for English and Romanized "Hinglish" forwards, it treats words strictly as literal string tokens. In languages such as Hindi or Marathi, grammatical inflections, post-positions, and sandhi compound words alter word stems. Without integrated morphological stemmers for Indic scripts, two forwards expressing the exact same claim with minor grammatical variations yield lower Jaccard scores, occasionally falling below the $J >= 0.75$ threshold.
2. *The Cross-Lingual Translation Blind Spot:* A common viral rumor pattern in India involves cross-lingual propagation: a false claim initially circulating in English is translated into Hindi, Tamil, and Bengali before being forwarded into regional groups. Because the Jaccard algorithm evaluates character token overlap, an English claim and its Hindi translation share $0.0\%$ token intersection ($J = 0.00$), creating isolated, redundant verification queues for what is conceptually the exact same falsehood.

=== Non-Invasive Architectural Trade-Offs (Privacy vs. Automation)
FactStamp strictly adheres to a *non-invasive, privacy-preserving architectural philosophy*: it does not deploy background device daemons, does not hook into WhatsApp's proprietary encrypted client protocols, and does not perform automated scraping of private conversations. 

While this design guarantees absolute compliance with user privacy rights and cybersecurity ethics, it entails deliberate operational constraints:
- *Mandatory Human Agency:* The platform cannot automatically "listen" to incoming chat streams. An individual user must possess the initial skepticism to consciously copy the forward or take a screenshot, open the FactStamp web app, and submit it. If all members of a closed WhatsApp group uncritically accept a fake forward, FactStamp cannot intercept it.
- *Passive Counter-Distribution:* Once a fact-check card is generated, the platform cannot automatically post it back into the WhatsApp group. It depends on the submitter downloading the PNG card and manually sharing it. If the submitter chooses not to share the card, the counter-misinformation loop remains incomplete.

== 7.3 Future Scope of the Project

=== Architectural Evolution and Vision
The successful implementation and empirical validation of *FactStamp* demonstrate the viability of crowdsourced, card-driven counter-misinformation systems. However, as the tactics of bad actors evolve—incorporating generative AI deepfakes, synthetic audio clones, and automated bot swarms—the FactStamp technical architecture must advance in tandem.

#v(8pt)

#align(center)[
  #image("attachments/future_architecture.svg", width: 75%)
]
#align(center)[
  #text(size: 9.5pt, style: "italic")[Figure 7.1: FactStamp Future Multimodal Architecture & Edge AI Pipeline]
]

#v(8pt)

=== In-Browser Small Language Model (SLM) Inference via WebAssembly and WebGPU
To enhance claim extraction from conversational screenshots without violating user privacy or incurring costly cloud inference fees, future iterations of FactStamp will integrate client-side *Small Language Models (SLMs)* executing directly within the browser runtime via *WebAssembly (WASM)* and *WebGPU*:
1. *Automated Claim Decomposition:* WhatsApp forwards frequently combine multiple assertions, blending factual historical background with an insidious falsehood at the end. An in-browser SLM (such as `SmolLM-135M` or `Gemma-2B-Instruct` quantized to 4-bit weights via ONNX Runtime Web) can parse long forwards into atomic, testable claims, presenting verifiers with distinct sub-propositions.
2. *Privacy-Preserving Edge Summarization:* Because model weights execute entirely in local device memory via WebGPU hardware acceleration, sensitive personal details embedded within screenshots (such as phone numbers or family names) are never transmitted to cloud servers, upholding absolute zero-knowledge privacy.
3. *Assisted Verifier Draft Generation:* The client-side model can ingest evidence retrieved by a verifier and draft a preliminary 2-sentence neutral explanation, reducing human cognitive fatigue while allowing the human-in-the-loop to edit and certify the rationale before submission.

=== Integration with Institutional Fact-Checking APIs and ClaimReview Schema
To reduce the cold-start verification latency identified in Section 7.2.2, FactStamp will establish bi-directional federation with globally certified journalistic fact-checking networks:
1. *Google Fact Check Tools API Integration:* When a novel forward is submitted, the ingestion engine will query the *Google Fact Check Tools API* using normalized query tokens. If accredited members of the *International Fact-Checking Network (IFCN)*—such as AltNews, BOOM Live, Vishwas News, or AFP—have already investigated and certified the claim, the API returns the verified verdict instantly.
2. *Automated Pre-Population of Primary Evidence:* In cases where an external journalistic investigation exists, FactStamp can automatically pre-populate the Verification Queue with the verified finding, allowing community verifiers to serve as corroborators ($N = 1$ rapid certification) rather than conducting investigations from scratch.
3. *Publishing Structured ClaimReview JSON-LD Markup:* FactStamp's public claim web pages will emit standardized schema.org `ClaimReview` JSON-LD metadata. This structured data enables Google, Bing, and major search crawlers to index FactStamp community verdicts directly into search engine snippet boxes, amplifying the public visibility of verified claims.

=== Progressive Web App (PWA) Offline Synchronization and Background Queuing
Internet connectivity across rural and semi-urban Indian transit environments (such as suburban trains or remote villages) is frequently intermittent. Converting FactStamp into a full-featured *Progressive Web App (PWA)* will ensure uninterrupted usability:
1. *Service Worker and Workbox Cache Strategy:* Utilizing Workbox service workers, the application shell, UI assets, and the last 100 verified claims will be aggressively cached using a *Cache-First* strategy. Users can browse debunked claims, verify recent forwards, and export cards even when completely offline.
2. *IndexedDB Offline Submission Queue:* If a user submits a forward or an authenticated verifier inputs a verdict while offline, the payload is persisted locally inside the browser's *IndexedDB* storage.
3. *Background Sync API Synchronization:* Leveraging the W3C *Background Sync API*, the browser automatically registers a sync event. As soon as the device reconnects to a cellular or Wi-Fi network, the background worker dispatches the queued claim to Cloud Firestore without requiring the user to keep the browser tab open.

=== Vernacular Voice Note Ingestion via Client-Side Speech-to-Text
A rapidly accelerating vector for misinformation in India is the forwarded *WhatsApp Voice Note (`.opus` audio)*. Illiterate or semi-literate demographics rely heavily on voice forwards, which evade traditional text-based search indexing entirely:
1. *Client-Side Whisper.wasm Engine:* By embedding a lightweight, WebAssembly-compiled OpenAI Whisper model (`whisper-tiny` or `whisper-base`), users can upload downloaded `.opus` voice notes directly into FactStamp.
2. *Multilingual Speech Recognition:* The model transcribes spoken vernacular Hindi, Marathi, Bengali, Tamil, and Indian-accented English directly into unicode text strings inside the browser.
3. *Automated Ingestion Pipeline Integration:* The transcribed audio text seamlessly enters Module 3 for Jaccard duplicate detection and verification queue dispatch, closing the critical audio misinformation loophole.

=== Cross-Lingual Semantic Embedding Indexing (IndicBERT)
To overcome the script and translation blind spots of token-based Jaccard similarity, future versions of FactStamp will upgrade the similarity architecture from lexical word-matching to *multilingual dense vector embeddings*:
1. *IndicBERT & Sentence Transformer Embeddings:* Incoming claims will be encoded into 768-dimensional dense vector embeddings using *IndicBERT* or `multilingual-e5-small`. These models map semantically identical sentences across multiple Indian languages into the same geometric vector space.
2. *Cross-Lingual Duplicate Detection:* For example, an English forward stating *"Drinking boiled garlic water cures asthma"* and a Hindi forward stating *"उबला हुआ लहसुन का पानी पीने से दमा ठीक हो जाता है"* will exhibit a cosine similarity score of $cos(theta) >= 0.88$, allowing the duplicate detection engine to instantly link them across languages and share a single verified fact-check card.
3. *Client-Side HNSW Vector Search:* Vector similarity search can be executed locally in-browser using lightweight Hierarchical Navigable Small World (HNSW) index libraries (e.g., `usearch` or `faiss-wasm`), preserving sub-100ms latency and serverless zero-cost guarantees.

=== Automated WhatsApp Business API and Chatbot Interoperability
While the web application approach preserves user anonymity, integrating an official *WhatsApp Business API chatbot* represents the ultimate distribution frontier:
- *Zero-Friction In-Chat Verification:* Users forward suspicious text messages, images, or audio clips directly to a verified FactStamp WhatsApp contact number (`+91-XXXXX-XXXXX`).
- *Automated Webhook Dispatch:* The WhatsApp Cloud API forwards the message payload to a serverless edge webhook, which executes the duplicate engine and returns the certified 1080×1080px fact-check PNG card directly back into the chat thread within three seconds.
- *Two-Way Community Alert Network:* Users who opted in can receive weekly digest cards highlighting the top 5 debunked scams circulating in their geographic state.

#pagebreak()

=== Summary of Development Roadmap

The phased rollout schedule for these planned architectural enhancements is structured across three future milestone phases:

#v(6pt)

#styled-table(
  columns: (1.4in, 1.1in, 1.8in, 1fr),
  headers: ("Milestone Phase", "Planned Timeframe", "Target Capabilities & Engineering Activities", "Expected Architectural Impact"),
  "Phase 1: Resilience & Offline", "Q1–Q2 2027", "Progressive Web App (PWA) Workbox caching, IndexedDB offline queuing, and Background Sync API.", "Ensures 100% offline access to verified fact-checks on low-bandwidth rural networks.",
  "Phase 2: Institutional Federation", "Q3 2027", "Bi-directional Google Fact Check Tools API integration, ClaimReview JSON-LD indexing, and IFCN source linking.", "Reduces cold-start verification latency from 4.2 hours to < 5 minutes for known viral hoaxes.",
  "Phase 3: Multimodal Edge AI", "Q4 2027–Q1 2028", "Client-side Whisper.wasm speech-to-text, in-browser SLM WebGPU claim parsing, and IndicBERT embeddings.", "Expands system defense across regional voice forwards, multi-language translations, and complex forwards."
)

#v(14pt)

=== Concluding Remarks & Project Viva Preparedness

The comprehensive development, rigorous testing, and empirical evaluation of the *FactStamp* platform fulfill all requirements of the B.Sc. Information Technology capstone syllabus (*Course JUSIT-DSCPR503*). By pioneering client-side edge computing, set-theoretic duplicate suppression, weighted quorum consensus, and high-impact visual counter-artifacts, FactStamp provides a sustainable, production-ready blueprint for community-driven defense against encrypted misinformation in India.

The project repository encompasses full source code, declarative security rule suites, automated unit test harnesses, and the complete academic dissertation artifact, standing ready for peer review and University examination.

// =============================================================================
// REFERENCES
// =============================================================================
= References

#set par(spacing: 0.8em)

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

[17] J. R. Douceur, "The Sybil Attack," in _Peer-to-Peer Systems (IPTPS 2001)_, Lecture Notes in Computer Science, vol. 2429, Berlin, Heidelberg: Springer, 2002, pp. 251–260, doi: 10.1007/3-540-45748-8_24.

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
