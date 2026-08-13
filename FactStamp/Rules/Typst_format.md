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
)

// Cross-Platform Font Fallbacks (Windows/Mac/Linux CI compatibility)
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt,
  lang: "en",
  hyphenate: true, // Prevents text clipping in narrow table cells
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)

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

## 2. One Format, Dual-Mode Compilation

Same page setup, typography, heading style, table formats, and diagram rules apply to every individual submission `.typ` AND the final assembled blackbook. 

Using `sys.inputs.at("mode", default: "standalone")`, single files adapt automatically without manual editing:

| Component | Individual Submission (`mode=standalone`) | Assembled Blackbook (`mode=blackbook`) |
|---|---|---|
| **Title Block** | Auto-rendered simplified title block | Automatically hidden (replaced by full front matter) |
| **Front Matter** | Omitted | Full Title, Certificate, Declaration, Acknowledgements, Abstract, INDEX |
| **Page Numbering** | Standalone numbering restarting at `1` | Continuous pagination (`1` to `N`), front matter lower-roman (`i`, `ii`) |

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

## 3. Full Front Matter Drop-In Templates (Assembled Blackbook)

Pre-formatted, copy-pasteable Typst blocks for all 5 mandatory front-matter pages. Uses flex vertical spacing (`#v(1fr)`) to ensure single-page containment regardless of title text length.

### A. Title Page Template
```typst
#let title-page(
  title: "FACTSTAMP",
  subtitle: "A Community-Powered WhatsApp Misinformation Fact-Checker",
  author: "Aadish",
  uid: "2023IT001",
  guide: "Prof. Jane Doe",
  year: "2025-2026"
) = [
  #set page(numbering: none)
  #align(center)[
    #v(1fr)
    #text(size: 18pt, weight: "bold")[#upper(title)]\
    #v(0.5em)
    #text(size: 12pt, style: "italic")[ (#subtitle) ]\
    #v(1.5fr)
    #text(size: 11pt)[A Project Report Submitted in Partial Fulfilment of the\ Requirements for the Award of Degree of]\
    #v(0.5em)
    #text(size: 13pt, weight: "bold")[BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)]\
    #v(1.5fr)
    #text(size: 11pt)[BY]\
    #v(0.3em)
    #text(size: 13pt, weight: "bold")[#author]\
    #text(size: 10pt)[UID: #uid]\
    #v(1.5fr)
    #text(size: 11pt)[UNDER THE GUIDANCE OF]\
    #v(0.3em)
    #text(size: 12pt, weight: "bold")[#guide]\
    #v(1.5fr)
    #text(size: 11pt, weight: "bold")[DEPARTMENT OF INFORMATION TECHNOLOGY]\
    #text(size: 12pt, weight: "bold")[JAI HIND COLLEGE]\
    #text(size: 10pt)[(EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[MUMBAI – 400 020]\
    #v(0.5em)
    #text(size: 11pt, weight: "bold")[#year]
    #v(1fr)
  ]
  #pagebreak()
]
```

### B. Certificate Page & Signature Grid Helper
```typst
#let signature-grid(..signatures) = block(width: 100%, breakable: false)[
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 2.5em,
    column-gutter: 2em,
    ..signatures.pos().map(sig => align(center + top)[
      #v(3em) // Wet signature & stamp space
      #line(length: 85%, stroke: 0.5pt)\
      #text(weight: "bold")[#sig.name]\
      #text(size: 9.5pt, style: "italic")[#sig.role]
    ])
  )
]

#let certificate-page(
  project-title: "FactStamp",
  student-name: "Aadish",
  uid: "2023IT001",
  guide-name: "Prof. Jane Doe",
  coord-name: "Prof. John Smith"
) = [
  #set page(numbering: none)
  #align(center)[
    #text(size: 12pt, weight: "bold")[JAI HIND COLLEGE]\
    #text(size: 10pt)[(EMPOWERED AUTONOMOUS)]\
    #text(size: 10pt)[MUMBAI - 400 020]\
    #v(1cm)
    #text(size: 14pt, weight: "bold")[#underline[CERTIFICATE]]
  ]
  #v(1.5cm)
  This is to certify that the project entitled "*#project-title*" is a bonafide work carried out by *#student-name* (UID: #uid) in partial fulfilment of the requirements for the award of the degree of *Bachelor of Science in Information Technology* during the academic year 2025-2026.
  
  #v(1fr)
  #signature-grid(
    (name: guide-name, role: "Internal Guide"),
    (name: coord-name, role: "Course Coordinator"),
    (name: "External Examiner", role: "Date: ____________"),
    (name: "College Seal", role: "Jai Hind College")
  )
  #v(1fr)
  #pagebreak()
]
```

### C. Declaration Page Template
```typst
#let declaration-page(student-name: "Aadish", project-title: "FactStamp") = [
  #set page(numbering: none)
  #align(center)[
    #text(size: 14pt, weight: "bold")[DECLARATION]
  ]
  #v(1.5cm)
  I hereby declare that the project entitled "*#project-title*" submitted by me to Jai Hind College, Mumbai, in partial fulfilment of the requirements for the award of the degree of Bachelor of Science in Information Technology, is an authentic record of my own work carried out under the guidance of my project guide.
  
  The matter embodied in this report has not been submitted by me for the award of any other degree or diploma.

  #v(1fr)
  #align(right)[
    #block(width: 6cm)[
      #v(3em)
      #line(length: 100%, stroke: 0.5pt)\
      #align(center)[
        *#student-name*\
        (Student Signature)
      ]
    ]
  ]
  #v(1fr)
  #pagebreak()
]
```

### D. Page Numbering State Sequence (Front Matter to Body)
```typst
// 1. Unnumbered Cover & Certificates
#title-page()
#certificate-page()
#declaration-page()

// 2. Lower-Roman Numerals for Front Matter
#set page(numbering: "i")
#counter(page).update(1)

// Acknowledgements
#align(center)[#text(size: 14pt, weight: "bold")[ACKNOWLEDGEMENTS]]
#v(1cm)
I would like to express my sincere gratitude to my guide...
#pagebreak()

// Abstract
#align(center)[#text(size: 14pt, weight: "bold")[ABSTRACT]]
#v(1cm)
FactStamp is a community-powered WhatsApp misinformation fact-checker...
#pagebreak()

// INDEX Table
#align(center)[#text(size: 14pt, weight: "bold")[INDEX]]
#v(0.8cm)
// [#styled-table(...)]
#pagebreak()

// 3. Arabic Numerals starting at 1 for Body
#set page(numbering: "1")
#counter(page).update(1)

// Chapter 1 Starts Here
```

---

## 4. Formal Component Helpers

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

## 5. Appendix & Back-Matter Section Setup

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

## 6. PDF Quality & Submission Discipline

- **Exact Folder & Sub-file Naming Rule:** Submission directory names **MUST EXACTLY MATCH** the user's input/prompt string (e.g. `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/`). Inside the directory, `.typ` and `.pdf` files **MUST USE** a descriptive title slug (e.g. `data_integrity_and_security_issues.typ` and `data_integrity_and_security_issues.pdf`).
- **PDF Metadata:** Prepend `#set document(title: "FactStamp - <Section>", author: "Aadish")` to every `.typ` file.
- **Orphan Prevention:** Place `#pagebreak(weak: true)` before major section headings if near page bottom.
- **Diagram Embedding:** No `#figure()` wrapper (captions are baked into diagram images as per college format). Use `responsive-image("attachments/diagram.svg")`.
- **Compile Verification:** Always open and inspect the rendered PDF visually after compiling to check for page budget overflow or text clipping.
