// ==============================================================================
// FACTSTAMP: MASTER BLACK BOOK DISSERTATION
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Jai Hind College (Empowered Autonomous), University of Mumbai
// Candidate: Aadish Das (UID: 2023IT001 / Roll No.: 10)
// ==============================================================================

// Master Page Setup: Mandatory solid black border & binding margins
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // Standard single-sided binding margin
  number-align: center,
  // Mandatory Black Page Border for Black Books and Dissertations
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  )
)

// Typography Rules: Times New Roman, 12pt justified body
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

// Heading Styling Hierarchy
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory: Every major section / Level 1 Heading starts on a new page
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
    size: 9.5pt,
    it
  )
)

// Figure & Caption Styling
#show figure.caption: set text(size: 10pt, style: "italic")

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// ==============================================================================
// 1. PRELIMINARY FRONT-MATTER PAGES (Cover, Certificate, Declaration, Acknowledgement, etc.)
// ==============================================================================
#include "00_preliminary.typ"

// ==============================================================================
// 2. MAIN BODY CHAPTERS: Restart page counter at Arabic 1
// ==============================================================================
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

// CHAPTER 1: INTRODUCTION
#include "01_introduction.typ"

// CHAPTER 2: SURVEY OF TECHNOLOGIES
#include "02_survey_of_technologies.typ"

// CHAPTER 3: REQUIREMENTS AND ANALYSIS
#include "03_requirements_and_analysis.typ"

// CHAPTER 4: SYSTEM DESIGN
#include "04_system_design.typ"

// CHAPTER 5: IMPLEMENTATION AND TESTING
#include "05_implementation_and_testing.typ"

// CHAPTER 6: RESULTS AND DISCUSSION
#include "06_results_and_discussion.typ"

// CHAPTER 7: CONCLUSIONS
#include "07_conclusions.typ"

// CHAPTER 8: REFERENCES AND GLOSSARY
#include "08_references_and_glossary.typ"
