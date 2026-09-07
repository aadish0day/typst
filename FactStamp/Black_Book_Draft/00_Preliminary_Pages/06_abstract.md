# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 06: Abstract

---

### Formal Academic Abstract

```text
====================================================================================================
                                             ABSTRACT
====================================================================================================
```

Digital misinformation proliferating across end-to-end encrypted messaging clients represents a critical threat to public health, social stability, and democratic discourse in India. Operating across more than 535 million domestic users, WhatsApp functions as India’s primary informal communications backbone. However, its architectural privacy—enforced via the Signal protocol—creates an unmonitored "dark social" blindspot where search engines, computational linguists, and regulatory monitors are structurally blind to viral falsehoods. Fabricated medical cures, altered political rhetoric, and financial scams circulate rapidly through high-trust kinship networks, bypassing critical cognitive scrutiny. Conventional investigative fact-checking organizations perform thorough forensic analyses but suffer from a debilitating latency deficit, routinely requiring 24 to 72 hours to publish a debunking article—long after a rumor’s 2-hour viral window has inflicted real-world harm. Moreover, long-form text links trigger defensive interpersonal resistance when shared in family or community groups.

**FactStamp** resolves this socio-technical dilemma through a decentralized, community-driven fact-checking platform that couples client-side edge computation with rigorous mathematical consensus. The system ingests suspicious forwards as raw plaintext or screenshot images without requiring user authentication. To maintain a completely free-tier serverless operating model, client-side Canvas compression restricts image payloads below 500 KB, while an in-browser Tesseract.js WebAssembly pipeline extracts textual claims directly in client memory. An automated Jaccard similarity engine ($J(A, B) \ge 0.75$) tokenizes and benchmarks incoming claims against Firestore database collections in sub-100ms time, instantly returning certified verdicts for previously resolved rumors and preventing queue congestion.

Unique claims enter an open verification registry requiring a strict quorum of three ($N \ge 3$) independent, authenticated community verifiers. Rather than relying on vulnerable binary voting, FactStamp deploys a multi-factor weighted consensus engine computing composite confidence scores: $C = 0.40 A + 0.30 R + 0.30 S$, synthesizing raw agreement ratio ($A$), historical verifier reputation ($R \in [0, 100]$), and primary institutional citation domain credibility ($S \in [0, 100]$). A dynamic reputation mechanism rewards consensus alignment ($+2$) and penalizes outlier votes ($-3$), while declarative database security rules eliminate Sybil voting rings.

Crucially, FactStamp alters the medium of counter-narrative dissemination. Using `html-to-image` 1.11.13 with browser-native SVG `<foreignObject>` canvas rasterization, the platform compiles verified claims into pixel-perfect, 1080×1080px square PNG Fact Cards. These cards natively render Tailwind CSS v4.0.0 OKLCH color spaces, dynamic SVG Trust Rings, and authoritative source domain pills. By enabling users to download and forward visual, objective stamps directly back into originating WhatsApp threads, FactStamp weaponizes native forwarding mechanics to extinguish viral rumors with verified truth.

```text
====================================================================================================
                                             KEYWORDS
====================================================================================================
Digital Misinformation; WhatsApp Forwards; Quorum Consensus; Jaccard Similarity; Client-Side OCR; 
Decentralized Fact-Checking; SVG ForeignObject Rasterization; Serverless Architecture.
====================================================================================================
```

---

### Abstract Specification & Key Metrics

| Metric | Measured Parameter | Academic Standard Adherence |
| :--- | :--- | :--- |
| **Word Count** | **354 Words** (Body Text) | Compliant with standard 300–400 word university dissertation abstract guidelines. |
| **Problem Definition** | WhatsApp dark social, E2EE blindspot, 535M Indian users, 24–72hr fact-checking latency deficit. | Fully articulated with empirical context. |
| **Algorithmic Methods** | Jaccard Token Similarity ($J \ge 0.75$), Multi-Factor Consensus ($C = 0.40A + 0.30R + 0.30S$). | Formally stated with mathematical variables. |
| **Client-Side Technologies** | HTML5 Canvas compression, Tesseract.js WebAssembly OCR, `html-to-image` 1.11.13 SVG `<foreignObject>`. | Detailed client edge computation model. |
| **Security & Economics** | Anti-Sybil self-verification locks, zero-dollar cloud operational expense on Firebase Spark tier. | Concrete architectural boundaries established. |
| **Output Artifact** | Standardized 1080×1080px square PNG card with OKLCH color-space fidelity. | Tailored specifically for WhatsApp re-forwarding. |

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 6: ABSTRACT
// Source: Submission of ABSTRACT, 1.4 Achievements, 1.5 Organization of Report
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(6)

#align(center)[
  #text(size: 16pt, weight: "bold")[ABSTRACT]
]

#v(0.25in)

#set par(justify: true, leading: 0.7em)

Digital misinformation proliferating across end-to-end encrypted messaging clients represents a critical threat to public health, social stability, and democratic discourse in India. Operating across more than 535 million domestic users, WhatsApp functions as India’s primary informal communications backbone. However, its architectural privacy—enforced via the Signal protocol—creates an unmonitored "dark social" blindspot where search engines, computational linguists, and regulatory monitors are structurally blind to viral falsehoods. Fabricated medical cures, altered political rhetoric, and financial scams circulate rapidly through high-trust kinship networks, bypassing critical cognitive scrutiny. Conventional investigative fact-checking organizations perform thorough forensic analyses but suffer from a debilitating latency deficit, routinely requiring 24 to 72 hours to publish a debunking article—long after a rumor’s 2-hour viral window has inflicted real-world harm. Moreover, long-form text links trigger defensive interpersonal resistance when shared in family or community groups.

*FactStamp* resolves this socio-technical dilemma through a decentralized, community-driven fact-checking platform that couples client-side edge computation with rigorous mathematical consensus. The system ingests suspicious forwards as raw plaintext or screenshot images without requiring user authentication. To maintain a completely free-tier serverless operating model, client-side Canvas compression restricts image payloads below 500 KB, while an in-browser Tesseract.js WebAssembly pipeline extracts textual claims directly in client memory. An automated Jaccard similarity engine ($J(A, B) >= 0.75$) tokenizes and benchmarks incoming claims against Firestore database collections in sub-100ms time, instantly returning certified verdicts for previously resolved rumors and preventing queue congestion.

Unique claims enter an open verification registry requiring a strict quorum of three ($N >= 3$) independent, authenticated community verifiers. Rather than relying on vulnerable binary voting, FactStamp deploys a multi-factor weighted consensus engine computing composite confidence scores: $C = 0.40 A + 0.30 R + 0.30 S$, synthesizing raw agreement ratio ($A$), historical verifier reputation ($R in [0, 100]$), and primary institutional citation domain credibility ($S in [0, 100]$). A dynamic reputation mechanism rewards consensus alignment ($+2$) and penalizes outlier votes ($-3$), while declarative database security rules eliminate Sybil voting rings.

Crucially, FactStamp alters the medium of counter-narrative dissemination. Using `html-to-image` with browser-native SVG `<foreignObject>` canvas rasterization, the platform compiles verified claims into pixel-perfect, 1080#text[×]1080px square PNG Fact Cards. These cards natively render Tailwind CSS v4 OKLCH color spaces, dynamic SVG Trust Rings, and authoritative source domain pills. By enabling users to download and forward visual, objective stamps directly back into originating WhatsApp threads, FactStamp weaponizes native forwarding mechanics to extinguish viral rumors with verified truth.

#v(0.2in)

#text(weight: "bold")[Keywords:] Digital Misinformation, WhatsApp Forwards, Quorum Consensus, Jaccard Similarity, Client-Side OCR, Decentralized Fact-Checking, SVG ForeignObject Rasterization, Serverless Architecture.
```
