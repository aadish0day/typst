// ==============================================================================
// PRELIMINARY PAGES (FRONT-MATTER)
// Based on Black_Book_Initial_Pages/initial_pages.typ & Project_syllabus.md
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Jai Hind College (Empowered Autonomous), University of Mumbai
// Candidate: Aadish Das (UID: 2023IT001 / Roll No.: 10)
// ==============================================================================

#let project-title = "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"
#let student-name = "Aadish Das"
#let student-uid = "2023IT001 / 10"
#let academic-year = "2026-27"
#let semester = "Semester V"
#let guide-1 = "Mr. Wilson Rao"
#let guide-2 = "Ms. Bertilla Fernandes"
#let logo-path = "assets/college_logo.jpg"

// ==============================================================================
// PAGE 1: TITLE / COVER PAGE (Unnumbered)
// ==============================================================================
#align(center)[
  #set par(justify: false, leading: 0.6em)

  #v(0.1in)
  #text(size: 17pt, weight: "bold")[
    FactStamp: A Community-Powered WhatsApp \
    Misinformation Fact-Checker
  ]

  #v(0.2in)
  #text(size: 13.5pt, weight: "bold")[A Project Report]

  #v(0.1in)
  #text(size: 11.5pt)[
    Submitted in partial fulfillment of the \
    Requirements for the award of the Degree \
    of
  ]

  #v(0.1in)
  #text(
    size: 12.5pt,
    weight: "bold",
  )[BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)]

  #v(0.18in)
  #text(size: 11.5pt, weight: "bold")[By]

  #v(0.08in)
  #text(size: 13.5pt)[#student-name]

  #v(0.04in)
  #text(size: 12.5pt)[UID / Roll No. : #student-uid]

  #v(0.18in)
  #text(size: 11.5pt, weight: "bold")[Under the esteemed guidance of]\
  #v(3pt)
  #text(size: 12.5pt, weight: "bold")[#guide-1 and #guide-2]

  #v(0.16in)
  #image(logo-path, width: 2.4cm)

  #v(0.1in)
  #text(size: 12pt, weight: "bold")[
    DEPARTMENT \
    OF \
    INFORMATION TECHNOLOGY
  ]

  #v(0.06in)
  #text(size: 12.5pt, weight: "bold")[JAI HIND COLLEGE (Empowered Autonomous)]

  #v(0.06in)
  #text(size: 12pt, weight: "bold")[
    MUMBAI, \
    400020 \
    MAHARASHTRA \
    #academic-year
  ]
]

// ==============================================================================
// PRELIMINARY PAGES NUMBERING SETUP: Roman numerals starting at ii
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(2)

// ==============================================================================
// PAGE 2: APPROVED PROFORMA
// ==============================================================================
#align(center)[
  #text(size: 13.5pt, weight: "bold")[JAI HIND COLLEGE (Empowered Autonomous)]\
  #text(size: 10.5pt, style: "italic")[DEPARTMENT OF INFORMATION TECHNOLOGY]\
  #v(2pt)
  #text(size: 14pt, weight: "bold")[PROFORMA FOR APPROVAL OF PROJECT PROPOSAL]
]

#v(0.08in)
#table(
  columns: (1.8in, 1fr),
  stroke: (x, y) => if y == 0 {
    (bottom: 1.2pt + black, top: 1.2pt + black)
  } else { 0.5pt + luma(160) },
  fill: (x, y) => if y == 0 { rgb("F4F5F7") } else { none },
  inset: (x: 4.5pt, y: 3.8pt),
  table.header([*Item Parameter*], [*Project Proposal Details*]),
  [1. Course Code & Title],
  [JUSIT-DSCPR503: Project Dissertation and Implementation],

  [2. Degree & Semester],
  [Bachelor of Science (Information Technology), #semester],

  [3. Academic Year], [#academic-year],
  [4. Name of Student], [*#student-name*],
  [5. UID / Roll Number], [#student-uid],
  [6. Title of Project], [*#project-title*],
  [7. Broad Subject Area],
  [Decentralized Web Application, Social Computing, Knowledge Graph Analysis & Client-Edge OCR],

  [8. Project Nature / Scope],
  [Design, implementation, empirical verification testing, and academic dissertation],

  [9. Project Guide(s)], [#guide-1 (HOD) \ #guide-2 (Assistant Professor)],
  [10. Technological Stack],
  [React 18, Vite 5, TypeScript 5.5, Tailwind CSS v4, OKLCH Tokens, Plus Jakarta Sans, Noto Sans Devanagari, Cloud Firestore, Firebase Auth, html-to-image, Recharts, Graphify],

  [11. Core Algorithmic Focus],
  [Jaccard Token Similarity ($J >= 0.75$), Quorum Consensus ($C = 0.40A + 0.30R + 0.30S$), Dynamic Queue Settlement & Replenishment, Rate Limiting Guard],

  [12. Status of Proposal],
  [*APPROVED* (Recommended for Implementation & Dissertation)],
)

#v(0.16in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[Signature of Student]
  ],
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[Signature of Guide(s)]
  ],
)
#v(0.14in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[Signature of Coordinator]
  ],
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[Head of Department / College Seal]
  ],
)

// ==============================================================================
// PAGE 3: CERTIFICATE (From initial_pages.typ)
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[JAI HIND COLLEGE]\
  #text(size: 11pt, style: "italic", weight: "bold")[(Empowered Autonomous)]\
  #v(2pt)
  #text(size: 11pt)[MUMBAI, 400020 MAHARASHTRA]\
  #v(6pt)
  #text(size: 14pt, weight: "bold")[DEPARTMENT OF INFORMATION TECHNOLOGY]

  #v(0.2in)
  #image(logo-path, width: 1.8cm)

  #v(0.25in)
  #text(size: 16pt, weight: "bold")[CERTIFICATE]
]

#v(0.25in)
#text(size: 12pt)[
  This is to certify that the project entitled, *"#project-title"*, is bonafide work of *#student-name* bearing UID / Roll No. : *#student-uid* submitted in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE in INFORMATION TECHNOLOGY* from Jai Hind College Empowered Autonomous (University of Mumbai).
]

#v(0.6in)

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [*Internal Guide*], [*Coordinator*],
)

#v(0.6in)
#align(center)[
  #text(weight: "bold")[External Examiner]
]

#v(0.6in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [*Date:* #datetime.today().display("[day]/[month]/[year]")], [*College Seal*],
)

// ==============================================================================
// PAGE 4: DECLARATION (From initial_pages.typ)
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[DECLARATION]
]

#v(0.4in)

#text(size: 12pt)[
  I hereby declare that the project entitled, *"#project-title"* done at Jai Hind College (Empowered Autonomous), has not been in any case duplicated to submit to any other university for the award of any degree. To the best of my knowledge other than me, no one has submitted to any other university.
]

#v(0.2in)

#text(size: 12pt)[
  The project is done in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)* to be submitted as #semester project as part of our curriculum.
]

#v(1.2in)

#align(right)[
  #line(length: 4.5cm, stroke: 0.8pt + black)
  #v(4pt)
  #text(size: 12pt, weight: "bold")[Name and Signature of the Student]\
  #text(size: 11pt)[(#student-name)]
]

// ==============================================================================
// PAGE 5: ROLE AND RESPONSIBILITY FORM
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 13.5pt, weight: "bold")[JAI HIND COLLEGE (Empowered Autonomous)]\
  #text(size: 10.5pt, style: "italic")[DEPARTMENT OF INFORMATION TECHNOLOGY]\
  #v(2pt)
  #text(size: 14pt, weight: "bold")[ROLE AND RESPONSIBILITY FORM]
]

#v(0.08in)
#text(size: 10.5pt)[
  This document records the allocation of individual technical responsibilities across the Software Development Life Cycle (SDLC) for the project entitled *"#project-title"*.
]

#v(0.06in)
#table(
  columns: (1.5in, 1fr, 0.75in),
  stroke: (x, y) => if y == 0 {
    (bottom: 1.2pt + black, top: 1.2pt + black)
  } else { 0.5pt + luma(160) },
  fill: (x, y) => if y == 0 { rgb("F4F5F7") } else { none },
  inset: (x: 4.5pt, y: 3.5pt),
  table.header(
    [*SDLC Phase / Area*],
    [*Technical Responsibilities & Deliverables*],
    [*Contribution*],
  ),
  [Requirements & Planning],
  [IEEE Std 830-1998 SRS drafting, WBS construction, PERT critical path analysis, and feasibility study.],
  [100%],

  [System Architecture],
  [Decoupled SPA design, Firestore NoSQL schema, security rules, and Graphify codebase knowledge graph mapping (89 files, 1,743 nodes, 3,640 edges, 94 communities).],
  [100%],

  [Algorithmic Engines],
  [Client-side WASM OCR pipeline, token-level Jaccard duplicate detection ($J >= 0.75$), multi-factor weighted quorum consensus engine ($C = 0.40A + 0.30R + 0.30S$), and verification queue settlement with dynamic replenishment.],
  [100%],

  [Frontend & UI/UX],
  [React 18 concurrent UI, Saffron Sleek OKLCH design tokens, universal kinetic sliding dual-icon ThemeToggle, Pan-Indic typography (Plus Jakarta Sans + Noto Sans Devanagari + CSS tabular-nums), and Recharts analytics.],
  [100%],

  [Security & Authentication],
  [Multi-tiered rate limiting (5 attempts, 15-min lockout, MM:SS countdown), brute-force guard, anti-enumeration error handling, and Firestore/Storage declarative security rules.],
  [100%],

  [Graphic Generation],
  [Client-side DOM-to-PNG compilation using `html-to-image` via SVG `<foreignObject>` for WhatsApp-native 1080#text[×]1080px cards.],
  [100%],

  [Testing & Validation],
  [Unit testing, Firebase Local Emulator rules testing, multi-tier hardware benchmarking ($N=500$), and 25-user beta usability trials.],
  [100%],

  [Documentation],
  [Complete academic dissertation, UML/DFD models, operational user manuals, and Typst typesetting.],
  [100%],
)

#v(0.14in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[#student-name]\
    #text(size: 9pt)[Student (UID: #student-uid)]
  ],
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10pt, weight: "bold")[#guide-1]\
    #text(size: 9pt)[Head of Department]
  ],
)

// ==============================================================================
// PAGE 6: ABSTRACT
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[ABSTRACT]
]

#v(0.14in)

#block[
  #set text(size: 11pt)
  #set par(justify: true, leading: 0.58em)

  Digital misinformation propagating through encrypted peer-to-peer messaging applications (commonly designated as dark social) represents an acute sociotechnical vulnerability in emerging digital economies. In India, where WhatsApp has over 535 million active users, the frictionless forwarding of unverified medical claims, financial scams, sectarian rumors, and doctored media causes direct societal harm. Traditional fact-checking institutions face clear structural constraints: end-to-end encryption under the Signal Protocol prevents automated web crawlers from inspecting message traffic, centralized journalistic investigations require 24 to 72 hours per claim, and external web hyperlinks rarely exceed 5% click-through rates within chat groups.

  This dissertation presents *FactStamp*, an open-source, community-governed misinformation defense platform designed to reduce verification latency while preserving cryptographic chat privacy. Operating under an unauthenticated client-edge ingestion model, FactStamp allows users to submit forwarded text snippets or screenshots directly. In-browser WebAssembly (Tesseract.js) runs optical character recognition (OCR) inside client Web Workers without invoking recurring cloud vision APIs. Token-level Jaccard duplicate detection ($J >= 0.75$) matches recurring viral variants in an average of 78.4 ms with 96.4% recall, routing users immediately to existing certified records.

  Unverified claims enter a decentralized quorum verification queue requiring $N >= 3$ independent reviews. Consensus is calculated deterministically using a multi-factor confidence engine ($C = 0.40A + 0.30R + 0.30S$) integrating agreement ratio ($40\%$), verifier reputation ($30\%$), and domain citation authority ($30\%$). To prevent queue stagnation, an automated settlement mechanism (`applyLocalExpiry`) resolves unverified claims after a 7-day deliberation deadline into `CONTESTED` status while dynamically replenishing active claims. The system certifies five distinct verdict states: `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, and `CONTESTED`. Verified outcomes compile into square $1080 times 1080$ px PNG fact cards in under 650 ms via `html-to-image` using browser-native SVG `<foreignObject>` canvas rasterization, avoiding color-parsing failures with OKLCH CSS tokens.

  FactStamp incorporates multi-tiered authentication rate limiting and brute-force protection (5-attempt threshold, 15-minute lockout, and active countdown timer), a kinetic dual-icon sliding `<ThemeToggle />`, and a Pan-Indic typography setup combining `Plus Jakarta Sans` for Latin text, `Noto Sans Devanagari` for Hindi and Marathi scripts, and native CSS `tabular-nums` at zero extra payload. The codebase architecture is mapped via the Graphify knowledge graph engine across 89 files, 1,743 nodes, 3,640 edges, and 94 communities. Empirical beta trials across 25 participants yielded a System Usability Scale (SUS) score of 84.2 ± 4.6 (Grade A), operating within Google Cloud Firestore and Vercel free tiers (\$0.00/month recurring cost).

  #v(0.12in)
  #text(weight: "bold")[Keywords:] Digital Misinformation, WhatsApp Forwards, Quorum Consensus, Jaccard Similarity, Client-Side OCR, Knowledge Graph, Pan-Indic Typography, Serverless Architecture.
]

// ==============================================================================
// PAGE 7: ACKNOWLEDGEMENT (From initial_pages.typ)
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[ACKNOWLEDGEMENT]
]

#v(0.35in)

#text(size: 12pt)[
  I express my sincere gratitude to *#guide-1*, Head of the Department of Information Technology and Software Development, for his continuous guidance, technical reviews, and constructive critiques throughout the planning and execution of this dissertation.
]

#v(0.18in)

#text(size: 12pt)[
  I am equally thankful to *Prof. #guide-2* for her steady encouragement, architectural advice, and detailed reviews during each stage of development.
]

#v(0.18in)

#text(size: 12pt)[
  I thank my peers and seniors who tested early prototypes, evaluated the verification workflows, and provided candid feedback on the interface design. Finally, I thank my family for their patience and support throughout the course of this work.
]

// ==============================================================================
// PAGE 8-9: TABLE OF CONTENTS
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[TABLE OF CONTENTS]
]
#v(16pt)

#outline(
  title: none,
  indent: 1.5em,
  depth: 2,
)

// ==============================================================================
// PAGE 10: TABLE OF FIGURES & TABLES
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 15pt, weight: "bold")[TABLE OF FIGURES & TABLES]
]
#v(8pt)

#block[
  #set text(size: 9.5pt)
  #set par(leading: 0.48em)
  #outline(
    title: none,
    target: figure.where(kind: image),
    indent: 1.2em,
  )
]
