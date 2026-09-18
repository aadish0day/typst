// ==============================================================================
// LIST OF FIGURES
// Front-matter partial: included by master_draft.typ.
// Hand-maintained list of figures and diagrams with dynamic page numbers.
// ==============================================================================

#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[LIST OF FIGURES]
]
#v(6pt)

// Helper: one clickable entry row styled to match the Table of Contents
// (11pt text, baseline-aligned dotted leader, right-aligned page number).
#let fig-entry(number, title, lbl) = {
  block(below: 0.9em, text(size: 11pt, link(lbl, grid(
    columns: (auto, 1fr, auto),
    column-gutter: 4pt,
    align: (bottom, bottom, bottom),
    [#number.#h(0.6em)#title],
    box(width: 1fr, inset: (x: 3pt), repeat[.]),
    context {
      let target = query(lbl)
      if target.len() > 0 {
        str(counter(page).at(target.first().location()).first())
      } else {
        "??"
      }
    },
  ))))
}

#fig-entry(1, "PERT Chart", <fig-pert>)
#fig-entry(2, "Gantt Chart", <fig-gantt>)
#fig-entry(3, "Event Table", <fig-event-table>)
#fig-entry(4, "ER Diagram", <fig-er>)
#fig-entry(5, "Class Diagram", <fig-class>)
#fig-entry(6, "Object Diagram", <fig-object>)
#fig-entry(7, "Use Case Diagram", <fig-usecase>)
#fig-entry(8, "Activity Diagram", <fig-activity>)
#fig-entry(9, "Sequence Diagram", <fig-sequence>)
#fig-entry(10, "State Diagram", <fig-state>)
#fig-entry(11, "Package Diagram", <fig-package>)
#fig-entry(12, "Component Diagram", <fig-component>)
#fig-entry(13, "Deployment Diagram", <fig-deployment>)
#fig-entry(14, "Data Flow Level 0 Diagram", <fig-dfd0>)
#fig-entry(15, "Data Flow Level 1 Diagram", <fig-dfd1>)
#fig-entry(16, "Data Flow Level 2 Diagram", <fig-dfd2>)
#fig-entry(17, "Database Schema Design", <fig-schema>)
