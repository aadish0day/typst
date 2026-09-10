// ==============================================================================
// LIST OF FIGURES
// Front-matter partial: included by master_draft.typ.
// Hand-maintained because diagrams are bare #image() calls (no #figure()
// wrappers), so Typst's automatic #outline(target: figure...) returns empty.
// Each entry uses a <label> placed next to its diagram for live page numbers.
// ==============================================================================

#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[LIST OF FIGURES]
]
#v(12pt)

// Helper: generates a single clickable entry row with dotted leader and page number
#let fig-entry(number, title, lbl) = {
  link(lbl, grid(
    columns: (auto, 1fr, auto),
    column-gutter: 4pt,
    align: (left, left, right),
    text(size: 11pt)[#number.#h(6pt)#title],
    repeat[.],
    context {
      let target = query(lbl)
      if target.len() > 0 {
        let page-num = counter(page).at(target.first().location()).first()
        text(size: 11pt, str(page-num))
      } else {
        text(size: 11pt, "??")
      }
    },
  ))
  v(5pt)
}

#fig-entry(1, "Gantt Chart", <fig-gantt>)
#fig-entry(2, "PERT Chart", <fig-pert>)
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
#fig-entry(16, "Database Schema Design", <fig-schema>)
