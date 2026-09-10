// ==============================================================================
// SHARED HELPERS: single definition site for the whole black book.
//
// Why this file exists: in Typst, `#set` and `#show` rules propagate from a
// parent into an `#include`d file, but `#let` bindings do NOT - an included
// file is evaluated in its own module scope. So these helper functions cannot
// simply be defined in master_draft.typ; each chapter partial that calls them
// must `#import` them explicitly:
//
//     #import "../lib/helpers.typ": *
//
// Edit a helper here and every chapter picks up the change.
// ==============================================================================

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 5pt, y: 4.5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible): for the diagram assets
// that will be wired into Chapters 3 and 4 once PlantUML/Graphviz output exists.
#let responsive-image(path, width: 90%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]
