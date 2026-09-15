#let project-title = "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"
#let student-name = "Aadish Das"
#let student-uid = "2023IT001 / 10"
#let academic-year = "2026-27"
#let semester = "Semester V"
#let guide-1 = "Mr. Wilson Rao"
#let guide-2 = "Ms. Bertilla Fernandes"
#let logo-path = "assets/college_logo.jpg"

// Typography rules: Times New Roman, 12pt justified content
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)

// ==============================================================================
// PAGE 1: TITLE / COVER PAGE
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
// PAGE 2: CERTIFICATE
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
// PAGE 3: DECLARATION
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[DECLARATION]
]

#v(0.4in)

#text(size: 12pt)[
  I declare that the project entitled, *"#project-title"*, completed at Jai Hind College (Empowered Autonomous), has not been duplicated and submitted to any other university for the award of a degree. To the best of my knowledge, no one else has submitted this work elsewhere.
]

#v(0.2in)

#text(size: 12pt)[
  This project is submitted in partial fulfillment of the requirements for the degree of *BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)* as my #semester project.
]

#v(1.2in)

#align(right)[
  #line(length: 4.5cm, stroke: 0.8pt + black)
  #v(4pt)
  #text(size: 12pt, weight: "bold")[Name and Signature of the Student]\
  #text(size: 11pt)[(#student-name)]
]

// ==============================================================================
// PAGE 4: ACKNOWLEDGEMENT
// ==============================================================================
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[ACKNOWLEDGEMENT]
]

#v(0.35in)

#text(size: 12pt)[
  I am grateful for the guidance of our Head of Department (Information Technology & Software Development), *#guide-1*. He guided me throughout the project, offering advice and providing the necessary information to complete the system.
]

#v(0.18in)

#text(size: 12pt)[
  I would also like to thank the people who helped me during this project. I am grateful to *Prof. #guide-2* for her continued encouragement and support.
]

#v(0.18in)

#text(size: 12pt)[
  Finally, I want to thank my friends and seniors who supported me and shared their ideas regarding the technology stack and system design. I also thank my family for their constant support.
]

// ==============================================================================
// PAGE 5: ABSTRACT
// ==============================================================================
#pagebreak()

#v(0.4in)

#align(center)[
  #text(size: 16pt, weight: "bold")[ABSTRACT]
  #v(6pt)
]

#v(0.4in)

#{
  set par(justify: true, leading: 0.85em)
  [
    *FactStamp* is a web-based platform designed to collect, verify, and counter misinformation circulating across WhatsApp forwards through community-driven consensus. With over 500 million active users in India, WhatsApp serves as a primary everyday communication channel; however, its private, end-to-end encrypted architecture enables unverified rumors, doctored media, and fraudulent schemes to proliferate unchecked by traditional web search crawlers or centralized fact-checking desks.

    The platform introduces a decentralized, crowdsourced verification ecosystem. Users submit suspicious text forwards or screenshots directly through an unauthenticated intake interface. An in-browser Optical Character Recognition (OCR) pipeline using Tesseract.js WebAssembly extracts text from screenshots, while a token-level Jaccard similarity algorithm identifies previously evaluated claims to provide instant debunks and eliminate redundant queue backlog.

    Unresolved claims enter a public Verification Queue where authenticated community verifiers examine primary evidence and submit categorized verdicts alongside source citations. A weighted consensus scoring engine computes a composite confidence score by evaluating the verifier agreement ratio (40%), verifier reputation ratings (30%), and primary source credibility tiers (30%). Upon consensus, FactStamp automatically generates a standardized, downloadable 1080#text[×]1080px digital counter-card containing the verdict stamp, confidence rating, and citation sources, enabling users to forward evidence-based corrections directly back into messaging threads.
  ]
}

