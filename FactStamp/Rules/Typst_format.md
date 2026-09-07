# Typst Document Format Rules — FactStamp Submissions & Blackbook

Rebuilt from a real Jai Hind College blackbook (Medi-Reach, BVoc SD / BSc IT, 2025-26). One unified format used identically for every individual section submission and the final assembled blackbook. Companion to `Diagram-rules.md` (diagram tooling).

---

## 1. Master Starter Boilerplate (`template.typ` & Section `.typ` Files)

Copy-paste this single starter block at the top of any standalone submission file or master blackbook file. It defines cross-platform font fallbacks, page margins, paragraph spacing, raw code styling, and dual-mode compilation.

```typst
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
  size: 12pt,
  lang: "en",
  hyphenate: true, // Prevents text clipping in narrow table cells
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt) // Mandatory Justified Content (12pt Times New Roman)
#set heading(numbering: "1.1")

// Heading Styling Rules: Heading 16pt bold, Subheadings 14pt bold
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory Rule: New topic / major section on new page
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
    font: ("Fira Code", "DejaVu Sans Mono", "Courier New"),
    size: 9.5pt,
    it
  )
)
```

---

## 2. Heading, Typography & Layout Rules Summary

| Hierarchy / Element | Typography / Formatting Specification | Typst Implementation |
|---|---|---|
| **Font Family** | Times New Roman (Cross-platform serif fallbacks) | `font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif")` |
| **Content / Body** | **12pt**, **Justified**, `leading: 0.65em` | `#set text(size: 12pt)` & `#set par(justify: true)` |
| **Headings (Level 1)** | **16pt**, **Bold**, numbered `"1.1"` | `#show heading.where(level: 1): set text(size: 16pt, weight: "bold")` |
| **Subheadings (Level 2)** | **14pt**, **Bold** | `#show heading.where(level: 2): set text(size: 14pt, weight: "bold")` |
| **Sub-subheadings (Level 3)** | **13pt**, **Bold** | `#show heading.where(level: 3): set text(size: 13pt, weight: "bold")` |
| **New Topic on New Page** | **Mandatory** pagebreak before every Level 1 topic | `#show heading.where(level: 1): it => { pagebreak(weak: true); it }` |
| **Page Border** | Solid black border (`1pt + black`) | `rect(width: 100% - 1.5cm, height: 100% - 1.5cm, stroke: 1pt + black)` |
| **Binding Margin** | Left: `1.5in`, Right/Top/Bottom: `1in` | `margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in)` |


---

## 3. One Format, Dual-Mode Compilation

Same page setup, typography, heading style, table formats, and diagram rules apply to every individual submission `.typ` AND the final assembled blackbook. 

Using `sys.inputs.at("mode", default: "standalone")`, single files adapt automatically without manual editing:

| Component | Individual Submission (`mode=standalone`) | Assembled Blackbook (`mode=blackbook`) |
|---|---|---|
| **Title Block** | Auto-rendered simplified title block | Automatically hidden (replaced by full front matter) |
| **Front Matter** | Omitted | Full 9 preliminary pages (Title, Proforma, Certificate, Declaration, Role & Responsibility, Abstract, Acknowledgement, TOC, TOF/Tables) |
| **Page Numbering** | Standalone numbering restarting at `1` | Continuous pagination: Cover (none), Preliminary (`ii` to `x`), Body (`1` to `N`) |

### Dual-Mode Title Header Snippet
```typst
#if not is-assembly [
  #align(center)[
    #text(size: 16pt, weight: "bold")[FactStamp]
    #v(4pt)
    #text(size: 13pt)[A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(12pt)
    #text(size: 12pt, style: "italic")[Submission: 3.6 Conceptual Models — Data Flow Diagram]
    #v(20pt)
    #text(size: 10pt)[Aadish — BSc Information Technology, Semester 5]
    #text(size: 10pt)[Jai Hind College, Mumbai]
  ]
  #v(24pt)
]
```

### Build Commands
```bash
# Compile individual submission (standalone mode)
typst compile 3.6_dfd.typ 3.6_dfd.pdf

# Compile assembled blackbook (blackbook mode)
typst compile --input mode=blackbook master_blackbook.typ master_blackbook.pdf
```

---

## 4. Full Front Matter Drop-In Templates (Assembled Blackbook)

Pre-formatted, copy-pasteable Typst blocks for all 9 mandatory preliminary front-matter pages prescribed by `Project_syllabus.md` § 1.1.

### Mandatory Preliminary Sequence
1. **Title / Cover Page** (`numbering: none`)
2. **Original Copy of the Approved Proforma of the Project Proposal** (`ii`)
3. **Certificate of Authenticated Work** (`iii`)
4. **Declaration** (`iv`)
5. **Role and Responsibility Form** (`v`)
6. **Abstract with Keywords** (`vi`)
7. **Acknowledgement** (`vii`)
8. **Table of Contents** (`viii`–`ix`, enclosed with `#pagebreak()` before and after)
9. **Table of Figures & List of Tables** (`x`)

### A. Title / Cover Page Template
```typst
#align(center)[
  #set par(justify: false, leading: 0.6em)
  #v(0.05in)
  #text(size: 17pt, weight: "bold")[
    FactStamp: A Community-Powered WhatsApp \
    Misinformation Fact-Checker
  ]
  #v(0.18in)
  #text(size: 13.5pt, weight: "bold")[A Project Report]
  #v(0.08in)
  #text(size: 11.5pt)[
    Submitted in partial fulfillment of the \
    Requirements for the award of the Degree \
    of
  ]
  #v(0.08in)
  #text(size: 12.5pt, weight: "bold")[BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)]
  #v(0.15in)
  #text(size: 11.5pt, weight: "bold")[By]
  #v(0.06in)
  #text(size: 13.5pt)[Aadish Das]
  #v(0.03in)
  #text(size: 12pt)[UID / Roll No. : 2023IT001 / 10]
  #v(0.15in)
  #text(size: 11.5pt, weight: "bold")[Under the esteemed guidance of]\
  #v(3pt)
  #text(size: 12pt, weight: "bold")[Mr. Wilson Rao and Ms. Bertilla Fernandes]
  #v(0.14in)
  #image("assets/college_logo.jpg", width: 2.3cm)
  #v(0.08in)
  #text(size: 11.5pt, weight: "bold")[
    DEPARTMENT \
    OF \
    INFORMATION TECHNOLOGY
  ]
  #v(0.05in)
  #text(size: 12.5pt, weight: "bold")[JAI HIND COLLEGE (Empowered Autonomous)]
  #v(0.05in)
  #text(size: 11.5pt, weight: "bold")[
    MUMBAI, 400020 \
    MAHARASHTRA \
    2026-27
  ]
]
#pagebreak()
```

### B. Approved Proforma Template
```typst
#align(center)[
  #text(size: 13.5pt, weight: "bold")[JAI HIND COLLEGE (Empowered Autonomous)]\
  #text(size: 10.5pt, style: "italic")[DEPARTMENT OF INFORMATION TECHNOLOGY]\
  #v(2pt)
  #text(size: 14.5pt, weight: "bold")[PROFORMA FOR APPROVAL OF PROJECT PROPOSAL]
]

#v(0.1in)
#table(
  columns: (1.8in, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1.2pt + black, top: 1.2pt + black) } else { 0.5pt + luma(160) },
  fill: (x, y) => if y == 0 { rgb("F4F5F7") } else { none },
  table.header([*Item Parameter*], [*Project Proposal Details*]),
  [1. Course Code & Title], [JUSIT-DSCPR503 --- Project Dissertation and Implementation],
  [2. Degree & Semester], [Bachelor of Science (Information Technology) --- Semester V],
  [3. Academic Year], [2026-27],
  [4. Name of Student], [*Aadish Das*],
  [5. UID / Roll Number], [2023IT001 / 10],
  [6. Title of Project], [*FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker*],
  [7. Broad Subject Area], [Decentralized Web Application, Social Computing, Image Rasterization & NLP],
  [8. Project Nature / Scope], [Design, implementation, empirical verification testing, and academic dissertation],
  [9. Project Guide(s)], [Mr. Wilson Rao (HOD) \ Ms. Bertilla Fernandes (Assistant Professor)],
  [10. Technological Stack], [React 18, Vite 5, Tailwind CSS v4, Firestore, Firebase Auth, html-to-image, Recharts],
  [11. Core Algorithmic Focus], [Jaccard Token Similarity ($J >= 0.75$), Quorum Consensus ($C = 0.40A + 0.30R + 0.30S$)],
  [12. Status of Proposal], [*APPROVED* (Recommended for Implementation & Dissertation)]
)

#v(0.2in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10.5pt, weight: "bold")[Signature of Student]
  ],
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10.5pt, weight: "bold")[Signature of Guide(s)]
  ]
)
#v(0.18in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10.5pt, weight: "bold")[Signature of Coordinator]
  ],
  [
    #line(length: 4cm, stroke: 0.8pt + black)\
    #text(size: 10.5pt, weight: "bold")[Head of Department / College Seal]
  ]
)
#pagebreak()
```

### C. Certificate & Declaration Templates
```typst
// Certificate
#align(center)[
  #text(size: 14pt, weight: "bold")[JAI HIND COLLEGE]\
  #text(size: 11pt, style: "italic", weight: "bold")[(Empowered Autonomous)]\
  #text(size: 11pt)[MUMBAI, 400020 MAHARASHTRA]\
  #text(size: 13.5pt, weight: "bold")[DEPARTMENT OF INFORMATION TECHNOLOGY]
  #v(0.15in)
  #image("assets/college_logo.jpg", width: 1.8cm)
  #v(0.2in)
  #text(size: 16pt, weight: "bold")[CERTIFICATE]
]
#v(0.2in)
This is to certify that the project entitled, *“FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker”*, is bonafide work of *Aadish Das* bearing UID / Roll No. : *2023IT001 / 10* submitted in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE in INFORMATION TECHNOLOGY* from Jai Hind College Empowered Autonomous (University of Mumbai).
#v(0.5in)
#grid(columns: (1fr, 1fr), align: (left, right), [*Internal Guide*], [*Coordinator*])
#v(0.5in)
#align(center)[*External Examiner*]
#v(0.5in)
#grid(columns: (1fr, 1fr), align: (left, right), [*Date:* #datetime.today().display("[day]/[month]/[year]")], [*College Seal*])
#pagebreak()

// Declaration
#align(center)[#text(size: 16pt, weight: "bold")[DECLARATION]]
#v(0.35in)
I hereby declare that the project entitled, *“FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker”* done at Jai Hind College (Empowered Autonomous), has not been in any case duplicated to submit to any other university for the award of any degree. To the best of my knowledge other than me, no one has submitted to any other university.

The project is done in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)* to be submitted as Semester V project as part of our curriculum.
#v(1.1in)
#align(right)[
  #line(length: 4.5cm, stroke: 0.8pt + black)\
  #text(size: 12pt, weight: "bold")[Name and Signature of the Student]\
  #text(size: 11pt)[(Aadish Das)]
]
#pagebreak()
```

### D. Page Numbering Transition Sequence (Front Matter to Body)
```typst
// 1. Page 1: Unnumbered Cover Page
#set page(numbering: none)
// (Cover page content here...)

// 2. Pages 2 to 10: Lower-Roman Numerals for Front Matter
#pagebreak()
#set page(numbering: "i")
#counter(page).update(2)

// Approved Proforma (Page ii)
// Certificate (Page iii)
// Declaration (Page iv)
// Role & Responsibility Form (Page v)
// Abstract (Page vi)
// Acknowledgement (Page vii)
// Table of Contents (Pages viii-ix)
// Table of Figures & Tables (Page x)

// 3. Arabic Numerals starting at 1 for Chapter 1 (Main Body)
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

// = CHAPTER 1: INTRODUCTION
```

---

## 5. Formal Component Helpers

### A. Reusable Academic Table Helper (`styled-table`)
```typst
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)
```

### B. Custom 4-Column INDEX Table Format
```typst
#styled-table(
  columns: (auto, 1fr, auto, auto),
  headers: ("Sr No", "Particulars", "Page No.", "Date"),
  "1", "Introduction", "1-6", "04-12-2025",
  "", "1.1 Background", "1", "",
  "", "1.2 Objectives", "2", "",
  "3.6", "Conceptual Models", "17-25", "11-12-2025",
  "", "3.6.1 Data Flow Diagram", "17", "",
  "", "3.6.2 Use Case Diagram", "19", "",
)
```

### C. Responsive Image Helper (`responsive-image`)
Prevents diagrams from overflowing page height and producing blank orphan pages:
```typst
// Note: block() has no max-height param in Typst 0.15+; use image's own
// width/height/fit so oversized diagrams never overflow the page.
#let responsive-image(path, width: 90%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]
```

### D. Landscape Page Helper (`landscape-page`)
For wide diagrams (Level 2 DFDs, full Package Diagrams):
```typst
#let landscape-page(body) = [
  #set page(flipped: true, margin: (top: 1.5in, bottom: 1in, left: 1in, right: 1in))
  #body
]
```

---

## 6. Appendix & Back-Matter Section Setup

Transition to Back-Matter (Appendices) using a lettered heading numbering reset:

```typst
#let start-appendices() = {
  pagebreak()
  counter(heading).update(0)
  set heading(numbering: "A.1")
}

// Usage:
#start-appendices()

= Appendix A: Database Collection Schemas
Firestore JSON rules and indexes...

= Appendix B: API Endpoint Specifications
REST endpoints documentation...
```

---

## 7. PDF Quality & Submission Discipline

- **Mandatory Typography Hierarchy:**
  - **Headings (Level 1 / Topics):** `16pt`, **Bold** (`#show heading.where(level: 1): set text(size: 16pt, weight: "bold")`).
  - **Subheadings (Level 2):** `14pt`, **Bold** (`#show heading.where(level: 2): set text(size: 14pt, weight: "bold")`).
  - **Sub-subheadings (Level 3):** `13pt`, **Bold** (`#show heading.where(level: 3): set text(size: 13pt, weight: "bold")`).
  - **Content / Body Text:** `12pt`, **Justified** (`#set text(size: 12pt)` with `#set par(justify: true)`).
  - **Font Family:** **Times New Roman** with cross-platform serif fallbacks (`Liberation Serif`, `Nimbus Roman`, `DejaVu Serif`).
- **New Topic on New Page (Mandatory):** Every new topic or major section (Level 1 Heading) **MUST** start on a fresh new page (`#show heading.where(level: 1): it => { pagebreak(weak: true); it }` or explicit `#pagebreak()`).
- **Mandatory Black Page Border:** Every Black Book project document and Assignment/Submission **MUST** include a solid black border (`stroke: 1pt + black`) configured in `#set page(background: place(center + horizon, rect(width: 100% - 1.5cm, height: 100% - 1.5cm, stroke: 1pt + black)))`.
- **Exact Folder & Sub-file Naming Rule:** Submission directory names **MUST EXACTLY MATCH** the user's input/prompt string (e.g. `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/`). Inside the directory, `.typ` and `.pdf` files **MUST USE** a descriptive title slug (e.g. `data_integrity_and_security_issues.typ` and `data_integrity_and_security_issues.pdf`).
- **PDF Metadata:** Prepend `#set document(title: "FactStamp - <Section>", author: "Aadish")` to every `.typ` file.
- **Orphan Prevention:** Place `#pagebreak(weak: true)` before major section headings if near page bottom.
- **Diagram Embedding:** No `#figure()` wrapper (captions are baked into diagram images as per college format). Use `responsive-image("attachments/diagram.svg")`.
- **Compile Verification:** Always open and inspect the rendered PDF visually after compiling to check for page budget overflow or text clipping.
