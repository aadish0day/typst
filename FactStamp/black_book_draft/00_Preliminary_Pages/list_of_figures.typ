// ==============================================================================
// LIST OF FIGURES
// Front-matter partial: included by master_draft.typ.
// Hand-maintained list of figures and diagrams with dynamic page numbers.
// ==============================================================================

#pagebreak()

#align(center)[
  #text(size: 14pt, weight: "bold")[LIST OF FIGURES]
]
#v(10pt)

// Helper: generates a single clickable entry row with dotted leader and page number
#let fig-entry(number, title, lbl) = {
  link(lbl, grid(
    columns: (auto, 1fr, auto),
    column-gutter: 4pt,
    align: (left, left, right),
    text(size: 10.5pt)[#number.#h(6pt)#title],
    repeat[.],
    context {
      let target = query(lbl)
      if target.len() > 0 {
        let page-num = counter(page).at(target.first().location()).first()
        text(size: 10.5pt, str(page-num))
      } else {
        text(size: 10.5pt, "??")
      }
    },
  ))
  v(3pt)
}

#fig-entry(1, "Gantt Chart", <fig-gantt>)
#fig-entry(2, "PERT Chart", <fig-pert>)
#fig-entry(3, "Entity-Relationship (E-R) Diagram", <fig-er>)
#fig-entry(4, "Class Diagram", <fig-class>)
#fig-entry(5, "Object Diagram", <fig-object>)
#fig-entry(6, "Use Case Diagram", <fig-usecase>)
#fig-entry(7, "Activity Diagram", <fig-activity>)
#fig-entry(8, "State Diagram (State Machine)", <fig-state>)
#fig-entry(9, "Sequence Diagram", <fig-sequence>)
#fig-entry(10, "Package Diagram", <fig-package>)
#fig-entry(11, "Component Diagram", <fig-component>)
#fig-entry(12, "Deployment Diagram", <fig-deployment>)
#fig-entry(13, "Data Flow Level 0 Diagram (Context)", <fig-dfd0>)
#fig-entry(14, "Data Flow Level 1 Diagram", <fig-dfd1>)
#fig-entry(15, "Data Flow Level 2 Diagram", <fig-dfd2>)
#fig-entry(16, "Claim Lifecycle Control Flow Diagram", <fig-lifecycle>)
#fig-entry(17, "Wireframe — Home Page", <fig-wireframe-home>)
#fig-entry(18, "Wireframe — Submit Page", <fig-wireframe-submit>)
#fig-entry(19, "Wireframe — Verify Queue", <fig-wireframe-verify-queue>)
#fig-entry(20, "Wireframe — Verify Detail", <fig-wireframe-verify-detail>)
#fig-entry(21, "Wireframe — Claim Detail", <fig-wireframe-claim-detail>)
#fig-entry(22, "Wireframe — Misinformation Analytics Dashboard", <fig-wireframe-dashboard>)
#fig-entry(23, "Wireframe — User Profile", <fig-wireframe-profile>)
#fig-entry(24, "Wireframe — Admin Moderation Console", <fig-wireframe-admin>)
#fig-entry(25, "Overall System Architecture Diagram", <fig-system-arch>)
