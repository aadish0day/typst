# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 01: Title / Cover Page

---

### Formal Institutional Cover Page Layout

```text
====================================================================================================
                                            FACTSTAMP:
                   A COMMUNITY-POWERED WHATSAPP MISINFORMATION FACT-CHECKER
====================================================================================================

                                         A Project Report
                                           Submitted in
                                   Partial Fulfillment of the
                                  Requirements for the Award of
                                          the Degree of

                           BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)

                                                By

                                            AADISH DAS
                                    UID / Roll No.: 2023IT001 / 10

                                Under the Esteemed Guidance of
                                        MR. WILSON RAO
                          Head of Department (IT & Software Development)
                                             and
                                    MS. BERTILLA FERNANDES
                         Assistant Professor, Department of Information Technology

                                       [COLLEGE EMBLEM / LOGO]

                                DEPARTMENT OF INFORMATION TECHNOLOGY
                              JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)
                               Affiliated with the University of Mumbai
                                Churchgate, Mumbai – 400 020, Maharashtra

                                        ACADEMIC YEAR 2026–2027
====================================================================================================
```

---

### Metadata and Document Attributes

| Parameter | Official Specification Details |
| :--- | :--- |
| **Project Full Title** | FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker |
| **Project Short Title** | FactStamp |
| **Document Type** | Final Capstone Project Report / Black Book Dissertation |
| **Academic Degree** | Bachelor of Science in Information Technology (B.Sc. IT) |
| **Course Code** | JUSIT-DSCPR503 (Project Dissertation and Implementation) |
| **Academic Year** | 2026–2027 |
| **Academic Term / Semester** | Semester V / Semester VI |
| **Candidate Name** | Aadish Das |
| **Candidate UID** | 2023IT001 |
| **Candidate Roll Number** | 10 |
| **Internal Guide 1** | Mr. Wilson Rao, Head of Department (Information Technology & Software Development) |
| **Internal Guide 2** | Ms. Bertilla Fernandes, Assistant Professor (Department of Information Technology) |
| **Institution** | Jai Hind College (Empowered Autonomous) |
| **Affiliated University** | University of Mumbai |
| **Campus Location** | 'A' Road, Churchgate, Mumbai – 400 020, Maharashtra, India |
| **Pagination Mode** | Suppressed / Unnumbered (Precedes Lowercase Roman Numeral sequence) |
| **Page Border Requirement** | Mandatory 1pt Solid Black Border (`100% - 1.5cm` rectangle, `stroke: 1pt + black`) |

---

### Layout and Typographic Standards (Typst Mapping)

1. **Page Geometry & Binding**:
   - Paper Size: ISO A4 (`210mm × 297mm`).
   - Margins: Left margin `1.5 inches` (`38.1mm`) to accommodate single-sided hardcover binding spine; Top, Right, and Bottom margins `1.0 inch` (`25.4mm`).
   - Page Border: Solid black border offset by `1.5cm` margin from sheet edges, centered and horizon-aligned (`rect(width: 100% - 1.5cm, height: 100% - 1.5cm, stroke: 1pt + black)`).
   - Numbering: None (`#set page(numbering: none)`).

2. **Typography Hierarchy**:
   - **Project Main Title**: `17pt` to `18pt`, Bold, Centered, Line-height `0.6em`.
   - **Report Descriptor**: `13.5pt`, Bold, Centered (`A Project Report`).
   - **Submission Clause**: `11.5pt`, Regular, Centered (`Submitted in partial fulfillment...`).
   - **Degree Designation**: `12.5pt`, Bold, All-Caps (`BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)`).
   - **Candidate Attribution**: `11.5pt` Bold (`By`), followed by Candidate Name in `13.5pt` Bold (`Aadish Das`), UID & Roll Number in `12.5pt` Regular (`UID / Roll No. : 2023IT001 / 10`).
   - **Supervisory Guidance**: `11.5pt` Bold (`Under the esteemed guidance of`), followed by Guide Names in `12.5pt` Bold (`Mr. Wilson Rao and Ms. Bertilla Fernandes`).
   - **Institutional Insignia**: High-resolution College Crest / Emblem (`assets/college_logo.jpg`), centered, target width `2.4cm` (`~180px`).
   - **Departmental Header**: `12pt`, Bold, All-Caps (`DEPARTMENT OF INFORMATION TECHNOLOGY`).
   - **College Name**: `12.5pt`, Bold, All-Caps (`JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)`).
   - **Institutional Location & Session**: `12pt`, Bold, All-Caps (`MUMBAI, 400020 MAHARASHTRA 2026-27`).

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 1: TITLE / COVER PAGE (FactStamp Dissertation)
// Source: Black_Book_Initial_Pages/initial_pages.typ
// ==============================================================================
#let project-title = "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"
#let student-name = "Aadish Das"
#let student-uid = "2023IT001 / 10"
#let academic-year = "2026-27"
#let semester = "Semester V"
#let guide-1 = "Mr. Wilson Rao"
#let guide-2 = "Ms. Bertilla Fernandes"
#let logo-path = "assets/college_logo.jpg"

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: none,
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    ),
  ),
)

#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt,
  lang: "en",
  hyphenate: true,
)

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
  #text(size: 13.5pt, weight: "bold")[#student-name]

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
```
