// ==============================================================================
// TABLE OF CONTENTS
// Front-matter partial: included by master_draft.typ.
// Do not compile standalone: #outline() only finds headings from the document
// that includes it, so on its own this file produces an empty contents list.
// ==============================================================================

#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[TABLE OF CONTENTS]
]
#v(6pt)

// depth: 3, but level-3 headings are hidden by a show rule in master_draft.typ;
// only the nine the syllabus lists (1.3.x, 4.2.x, 5.2.1, 5.3.x) opt back in.
#text(size: 11pt)[
  #outline(
    title: none,
    indent: 1.5em,
    depth: 3,
  )
]

// ==============================================================================
// TABLE OF FIGURES
//
// NOTE: this CANNOT be auto-generated in this book. Rules/Typst_format.md:410
// mandates "No #figure() wrapper (captions are baked into diagram images as per
// college format)", and #outline(target: figure...) only finds #figure elements.
// All 16 diagrams are embedded as bare #image() calls with their titles rendered
// inside the SVG itself, so an automatic list would come back empty.
//
// The Table of Figures therefore has to be a hand-maintained list. The 16
// diagrams currently embedded, in page order:
//   Ch 3.3: Gantt Chart, PERT Chart
//   Ch 3.6: ER, Class, Object, Use Case, Activity, State, Sequence,
//           Package, Component, Deployment, DFD Level 0 / 1 / 2
//   Ch 5.1: Overall System Architecture
// Still outstanding: UI wireframes (checklist item 16) and Ch 6.2 screenshots.
// ==============================================================================

// #pagebreak()
// #align(center)[
//   #text(size: 14pt, weight: "bold")[TABLE OF FIGURES]
// ]
// #v(12pt)
// #outline(
//   title: none,
//   target: figure.where(kind: image),
// )

// ==============================================================================
// TABLE OF TABLES: same, uncomment once tables are wrapped in #figure().
// ==============================================================================

// #pagebreak()
// #align(center)[
//   #text(size: 14pt, weight: "bold")[TABLE OF TABLES]
// ]
// #v(12pt)
// #outline(
//   title: none,
//   target: figure.where(kind: table),
// )
