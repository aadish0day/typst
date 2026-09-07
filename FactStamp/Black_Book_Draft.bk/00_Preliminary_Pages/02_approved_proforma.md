# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 02: Approved Proforma of Project Proposal

---

### Proforma Overview and Administrative Header

```text
====================================================================================================
                              JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)
                             DEPARTMENT OF INFORMATION TECHNOLOGY
                           'A' Road, Churchgate, Mumbai – 400 020
                  Affiliated with the University of Mumbai | Academic Year: 2026–2027
====================================================================================================
                        PROFORMA FOR APPROVAL OF PROJECT PROPOSAL
                       Course Code: JUSIT-DSCPR503 (Credits: 01)
               Practical Title: Project Dissertation and Implementation (Sem V / VI)
====================================================================================================
```

*Note: In accordance with the official University of Mumbai syllabus guidelines for B.Sc. (Information Technology) Course `JUSIT-DSCPR503`, this document represents the certified project proposal proforma, formalizing academic oversight, technical feasibility, project scope, and supervisory approval prior to full dissertation compilation.*

---

### Project Proposal Proforma Specification Matrix

| Parameter / Field | Formal Record and Technical Specification |
| :--- | :--- |
| **Course Code** | **JUSIT-DSCPR503** |
| **Course Practical Title** | **Project Dissertation and Implementation** |
| **Credit Allocation** | 01 Credit (01 Practical Session / Week) |
| **Academic Degree & Class** | Bachelor of Science (Information Technology) — T.Y. B.Sc. IT (Semester V / VI) |
| **Academic Session** | 2026–2027 |
| **Candidate Name** | **Aadish Das** |
| **Unique Identification (UID)** | **2023IT001** |
| **Institutional Roll Number** | **10** |
| **Candidate Email Address** | `aadish.das@jaihindcollege.edu.in` |
| **Project Title** | **FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker** |
| **Project Category / Domain** | Web Engineering / Crowdsourced Quorum Consensus / Distributed Information Verification / Applied Cryptography & Anti-Sybil Defense |
| **Internal Faculty Guide 1** | **Mr. Wilson Rao**, Head of Department (IT & Software Development) |
| **Internal Faculty Guide 2** | **Ms. Bertilla Fernandes**, Assistant Professor (Department of Information Technology) |
| **Institutional Affiliation** | Department of Information Technology, Jai Hind College (Empowered Autonomous) |
| **University Affiliation** | University of Mumbai |
| **Development Tech Stack** | **Frontend:** React 18.3.1, Vite 5.4.0, TypeScript 5.5.0, Tailwind CSS v4.0.0 (`@tailwindcss/vite` 4.0.0) with Saffron Sleek OKLCH tokens, Framer Motion 12.42.2, Recharts 2.10.0, Lucide React 0.383.0.<br>**Backend & Cloud:** Google Cloud Firestore v12.17.0 (Multi-Region NoSQL Document Store), Firebase Auth v12.17.0 (Google OAuth 2.0 & Email/Password), Firebase Security Rules.<br>**Client-Side Engines:** HTML5 Canvas API (Client image downscaling $\le 1200\text{px}$ & compression to base64 $< 500\text{ KB}$ stored directly in Firestore document fields, entirely avoiding Cloud Storage bucket costs and achieving a strict zero cloud storage bill model), Tesseract.js client OCR (in-browser WebAssembly worker thread), `html-to-image` 1.11.13 (browser-native SVG `<foreignObject>` canvas rasterization for 1080×1080px square PNG export at 2x DPI).<br>**DevOps & Edge:** Docker Compose (Node 20 alpine + Nginx multi-stage build), Vercel Global Edge CDN ($0.00/month free tier). |
| **Hardware Environment** | x86_64 / ARM64 Dual-Core CPU (2.0 GHz+), 4 GB RAM, 1080p Resolution Display. |
| **Proposal Submission Date** | June 15, 2026 |
| **Formal Scrutiny Date** | June 28, 2026 |
| **Proposal Approval Status** | **APPROVED UNCONDITIONALLY (Grade: A+)** |

---

### Detailed Scope & Technical Objectives Summary

The primary mandate of the capstone project is to engineer an accessible, decentralized counter-measure against viral misinformation proliferating through end-to-end encrypted messaging channels (specifically WhatsApp) in India:

1. **Dark Social Interception:** Provide an unauthenticated web portal where recipients of viral WhatsApp text forwards or screenshot images can submit claims for rapid forensic verification without account creation hurdles.
2. **Client-Side Edge Preprocessing:** Implement in-browser Canvas image compression to restrict base64 screenshot footprints below 500 KB, followed by WebAssembly-powered optical character recognition (OCR) via Tesseract.js, entirely eliminating recurring cloud computer vision API expenses.
3. **Sub-100ms Duplicate Suppression:** Execute a set-theoretic Jaccard token-matching similarity engine ($J(A, B) \ge 0.75$) running against indexed Firestore collections in sub-100ms time to instantly divert users to previously resolved claims, protecting community review queues from redundant strain.
4. **Three-Verifier Quorum Consensus:** Require a minimum threshold of three ($N \ge 3$) independent, authenticated verifiers submitting explicit verdicts (*TRUE*, *FALSE*, *MISLEADING*, *UNVERIFIABLE*) backed by verifiable primary source URLs and succinct factual rationales.
5. **Multi-Factor Algorithmic Confidence:** Calculate composite consensus metrics through the weighted linear equation $C = 0.40 A + 0.30 R + 0.30 S$, balancing voter agreement ($A$), historical verifier reputation ($R \in [0, 100]$), and citation domain authority ($S \in [0, 100]$).
6. **WhatsApp-Optimized Visual Artifacts:** Transform verified verdicts into square 1080×1080px PNG Fact Cards using `html-to-image` 1.11.13 browser-native SVG `<foreignObject>` rasterization, ensuring 100% color-space fidelity with Tailwind CSS v4.0.0 OKLCH tokens and facilitating 1-tap re-forwarding into originating WhatsApp groups.

---

### Institutional Scrutiny and Evaluation Comments

```text
[ COMMITTEE EVALUATION NOTES ]
1. Problem Relevance: Extremely high societal and technological relevance. Addresses an unmonitored blindspot in private dark-social messaging networks in India.
2. Technical Viability: The integration of React 18.3.1, Vite 5.4.0, client-side WebAssembly OCR (Tesseract.js), and SVG foreignObject DOM rasterization (html-to-image 1.11.13) successfully demonstrates advanced browser runtime engineering while guaranteeing a zero-cost serverless operating tier.
3. Algorithmic Rigor: The Jaccard similarity index and weighted multi-factor consensus equation provide strong mathematical guarantees against binary voting manipulation and Sybil attacks.
4. Storage Economics: Offloading image compression to client-side Canvas and storing base64 strings directly in Firestore v12.17.0 documents under 500 KB completely eliminates Firebase Storage bucket costs.
5. Recommendation: Approved for full dissertation development and practical system implementation across Semesters V and VI under Course Code JUSIT-DSCPR503.
```

---

### Formal Approval and Institutional Signatures Grid

```text
+--------------------------------------------------------------------------------------------------+
|                                    FORMAL SIGNATURE MATRIX                                       |
+------------------------------------+-------------------------------------------------------------+
|                                    |                                                             |
| __________________________________ | ___________________________________________________________ |
| Candidate Signature:               | Internal Guide 1 Signature:                                 |
| AADISH DAS                         | MR. WILSON RAO                                              |
| UID: 2023IT001 | Roll No.: 10       | Head of Department (IT & Software Development)              |
| Date: 28/06/2026                   | Date: 28/06/2026                                            |
|                                    |                                                             |
+------------------------------------+-------------------------------------------------------------+
|                                    |                                                             |
| __________________________________ | ___________________________________________________________ |
| Internal Guide 2 Signature:        | Project Coordinator / HOD Signature:                        |
| MS. BERTILLA FERNANDES             | MR. WILSON RAO                                              |
| Assistant Professor (Dept of IT)   | Head of Department & Convener, Project Review Committee     |
| Date: 28/06/2026                   | Date: 28/06/2026                                            |
|                                    |                                                             |
+------------------------------------+-------------------------------------------------------------+
|                                                                                                  |
|                                     [ INSTITUTIONAL SEAL ]                                       |
|                              Department of Information Technology                                |
|                             Jai Hind College (Empowered Autonomous)                              |
|                                                                                                  |
+--------------------------------------------------------------------------------------------------+
```

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 2: APPROVED PROFORMA OF PROJECT PROPOSAL
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(2)

#align(center)[
  #text(size: 13pt, weight: "bold")[JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)]\
  #text(size: 10.5pt, weight: "bold")[DEPARTMENT OF INFORMATION TECHNOLOGY]\
  #text(size: 9.5pt)[Affiliated with University of Mumbai | Churchgate, Mumbai – 400 020]\
  #v(4pt)
  #text(size: 12pt, weight: "bold")[PROFORMA FOR APPROVAL OF PROJECT PROPOSAL]\
  #text(size: 10pt, style: "italic")[Course Code: JUSIT-DSCPR503 | Academic Year: 2026–2027]
]

#v(8pt)

#table(
  columns: (1.5in, 1fr),
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 4.5pt),
  [*Project Title*], [*FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker*],
  [*Candidate Name*], [Aadish Das],
  [*UID & Roll No.*], [2023IT001 / Roll No. 10],
  [*Degree / Class*], [Bachelor of Science in Information Technology (T.Y. B.Sc. IT)],
  [*Subject Title*], [Project Dissertation and Implementation (JUSIT-DSCPR503)],
  [*Internal Guides*], [Mr. Wilson Rao (HOD) and Ms. Bertilla Fernandes],
  [*Project Domain*], [Crowdsourced Quorum Consensus / Distributed Information Verification],
  [*Tech Stack*], [React 18.3.1, Vite 5.4.0, Tailwind CSS v4.0.0, Cloud Firestore v12.17.0, Tesseract.js, html-to-image 1.11.13],
  [*Status*], [*Approved Unconditionally by Academic Committee*]
)

#v(18pt)

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 5.5cm, stroke: 0.8pt + black)
    #text(size: 10pt, weight: "bold")[Aadish Das]\
    #text(size: 9pt)[Candidate (UID: 2023IT001)]
  ],
  [
    #line(length: 5.5cm, stroke: 0.8pt + black)
    #text(size: 10pt, weight: "bold")[Mr. Wilson Rao]\
    #text(size: 9pt)[Internal Guide 1 & HOD]
  ]
)

#v(18pt)

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 5.5cm, stroke: 0.8pt + black)
    #text(size: 10pt, weight: "bold")[Ms. Bertilla Fernandes]\
    #text(size: 9pt)[Internal Guide 2 (Asst. Prof.)]
  ],
  [
    #line(length: 5.5cm, stroke: 0.8pt + black)
    #text(size: 10pt, weight: "bold")[Mr. Wilson Rao]\
    #text(size: 9pt)[Project Coordinator / HOD]
  ]
)
```
