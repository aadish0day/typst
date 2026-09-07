#let project-title = "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"
#let student-name = "Aadish Das"
#let student-uid = "2023IT001 / 10"
#let academic-year = "2026-27"
#let semester = "Semester V"
#let guide-1 = "Mr. Wilson Rao"
#let guide-2 = "Ms. Bertilla Fernandes"
#let logo-path = "assets/college_logo.jpg"

// // Page setup with mandatory black border
// #set page(
//   paper: "a4",
//   margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
//   numbering: "1",
//   number-align: center,
//   background: place(
//     center + horizon,
//     rect(
//       width: 100% - 1.5cm,
//       height: 100% - 1.5cm,
//       stroke: 1pt + black,
//     ),
//   ),
// )

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
// PAGE 4: ACKNOWLEDGEMENT
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
