// ==============================================================================
// FACTSTAMP: MASTER BLACK BOOK DISSERTATION
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Jai Hind College (Empowered Autonomous), University of Mumbai
// Candidate: Aadish Das (UID: 2023IT001 / Roll No.: 10)
// ==============================================================================

// Shared helpers (styled-table, responsive-image). Chapter partials import
// this same file directly, because #let bindings do not cross #include.
#import "lib/helpers.typ": *

// Master Page Setup: Mandatory solid black border & binding margins
// This is now the ONLY place page setup/border lives in the whole book:
// every per-chapter .typ file has had its own duplicate copy of this block removed.
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

// PDF metadata. Chapter partials no longer declare their own #set document(),
// so this is the single declaration and it applies to the whole assembled book.
#set document(
  title: "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker",
  author: "Aadish Das",
)

// Heading Styling Hierarchy
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")
#show heading.where(level: 4): set text(size: 12pt, weight: "bold", style: "italic")

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



// ==============================================================================
// 1. PRELIMINARY FRONT-MATTER PAGES (Cover, Certificate, Declaration, Acknowledgement, etc.)
// ==============================================================================
#include "00_Preliminary_Pages/initial_pages.typ"

// ==============================================================================
// 1b. MASTER TABLE OF CONTENTS (single, book-wide; supersedes any per-chapter TOC)
// ==============================================================================
#include "00_Preliminary_Pages/table_of_contents.typ"

// ==============================================================================
// 1c. TABLE OF FIGURES (hand-maintained; captions baked into diagram SVGs)
// ==============================================================================
#include "00_Preliminary_Pages/list_of_figures.typ"

// ==============================================================================
// 2. MAIN BODY CHAPTERS: Restart page counter at Arabic 1
// ==============================================================================
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

// CHAPTER 1: INTRODUCTION
#include "01_Introduction/01_introduction.typ"

// CHAPTER 2: SURVEY OF TECHNOLOGIES
#include "02_Survey_of_Technologies/02_survey_of_technologies.typ"

// CHAPTER 3: REQUIREMENTS AND ANALYSIS
#include "03_Requirements_and_Analysis/03_requirements_and_analysis.typ"

// CHAPTER 4: SYSTEM DESIGN
#include "04_System_Design/04_system_design.typ"

// CHAPTER 5: IMPLEMENTATION AND TESTING
#include "05_Implementation_and_Testing/05_implementation_and_testing.typ"

// CHAPTER 6: RESULTS AND DISCUSSION
#include "06_Results_and_Discussion/06_results_and_discussion.typ"

// CHAPTER 7: CONCLUSIONS
#include "07_Conclusions/07_conclusions.typ"

// CHAPTER 8: REFERENCES AND GLOSSARY
#include "08_References_and_Glossary/08_references_and_glossary.typ"
