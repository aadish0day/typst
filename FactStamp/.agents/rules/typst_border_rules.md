---
trigger: always_on
description: Mandatory black page border and styling rules for Typst black books and assignments
---

# Typst Rules: Mandatory Black Border for Black Books & Assignments

All generated Typst documents for **Black Book reports** and **Assignments / Submissions** must strictly include a solid black page border.

## Page Setup Template

```typst
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  )
)

// Font & Paragraph Settings
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt, // Mandatory 12pt for content
  lang: "en",
  hyphenate: true,
)
#set par(justify: true, leading: 0.65em, first-line-indent: 0pt) // Mandatory Justified Content
#set heading(numbering: "1.1")

// Heading & Subheading Hierarchy
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory: New topic on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}
```

