# Diagram Tooling Rules — FactStamp Docs

Hybrid architecture, decided after peer review: **PlantUML for UML diagram types, Graphviz for graph-oriented diagrams (topology, dependency, directed-flow, relationship graphs), native Typst for linear/tabular content.** Each tool used where it's actually the right fit, not where it's merely possible.

**Current state:** all 16 built diagrams are PlantUML — the DFDs and PERT chart were converted from Graphviz, so no `.dot` sources remain in the book. Graphviz stays documented and permitted (Rule 2); PlantUML is the default for anything new.

## Master Required Diagrams Checklist

| # | Diagram Name | Syllabus Section | Tool Actually Used | Status (aspect W/H) |
|---|---|---|---|---|
| 1 | PERT Chart | Ch 3.3 (Planning & Scheduling) | PlantUML (`.puml` → `.svg`) | Built — `pert_chart.svg` (0.46, portrait) |
| 2 | GANTT Chart | Ch 3.3 (Planning & Scheduling) | PlantUML `@startgantt` (`.puml` → `.svg`) | Built — `gantt_chart.svg` (2.05, landscape; legible unrotated; colour-coded by phase) |
| 3 | Data Flow Diagram (DFD) — Level 0 (Context) | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `dfd_level_0.svg` (0.69) |
| 4 | Data Flow Diagram (DFD) — Level 1 | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `dfd_level_1.svg` (0.75, tuned to fill the embed box) |
| 5 | Data Flow Diagram (DFD) — Level 2 | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `dfd_level_2.svg` (0.66) |
| 6 | Use Case Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `use_case_diagram.svg` (0.46) |
| 7 | Activity Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `activity_diagram.svg` (0.34) |
| 8 | State Diagram (State Machine) | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `state_diagram.svg` (0.98) |
| 9 | Sequence Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `sequence_diagram.svg` (0.47) |
| 10 | Class Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `class_diagram.svg` (0.48) |
| 11 | Object Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `object_diagram.svg` (0.73) |
| 12 | Package Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `package_diagram.svg` (0.77) |
| 13 | Deployment Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `deployment_diagram.svg` (0.83) |
| 14 | Component Diagram | Ch 3.6 (Conceptual Models) | PlantUML (`.puml` → `.svg`) | Built — `component_diagram.svg` (0.60) |
| 15 | Entity-Relationship (E-R) Diagram | Ch 3.6 (Conceptual Models) & Ch 4.2 (Data Design) | PlantUML (`.puml` → `.svg`) | Built — `er_diagram.svg` (0.45) |
| 16 | UI Wireframes & Screen Layouts | Ch 4.3 & Ch 6.1 (UI & Manual) | SVG / high-res mockups | **Outstanding** — needs the running UI |
| 17 | Overall System Architecture Diagram | Ch 5.1 (Implementation Approach) | PlantUML (`.puml` → `.svg`) | Built — `system_architecture.svg` (1.04) |

All 16 built diagrams live in the relevant chapter's `attachments/` folder alongside their `.puml` source, and are embedded with `#align(center)[#image("attachments/<name>.svg", …)]` (see Workflow, below). Aspect ratio is width ÷ height; A4's text block is ≈ 0.667, so anything below that is comfortably portrait. Only the Gantt exceeds 1.0, and it was verified legible on the page without rotation.

## Rule 1 — PlantUML (`.puml` → `svg` → `#image()`) for UML diagrams

Anything that IS formally a UML diagram type gets PlantUML's native UML DSL instead of Graphviz's record-label string hacks.

| Diagram type | Why PlantUML over Graphviz |
|---|---|
| ER Diagrams | Native `entity` blocks + crow's-foot relations (`||--o{`) — no manual record-string escaping |
| Class Diagrams | Native `class`/`abstract class`, `--|>` inheritance, `..>` dependency — ~60% less code than Graphviz record hacks, and a single missing `\l` can't silently break the layout anymore |
| Object Diagrams | Native `object` keyword, same instance-vs-type clarity as Class without record syntax |
| Component Diagrams | Native `component`/`interface` blocks with clean port notation |
| Package Diagrams | Native `package` blocks — same nesting Graphviz needed `subgraph cluster_x` hacks for, without the hacks |
| Deployment Diagrams | Native `node`/`artifact` syntax, purpose-built for this exact diagram type |
| Use Case Diagrams | Native `actor`/`usecase`, built-in `<<include>>`/`<<extend>>` stereotypes |
| State Diagrams | Native `state` blocks, `[*]` for initial/final — purpose-built, not a topological hack |

**Rule of thumb:** if the diagram type has an official UML notation, it's PlantUML — full stop, regardless of node count.

## Rule 2 — Graphviz (`dot` → `svg` → `#image()`) for graph-oriented diagrams

Use Graphviz/DOT primarily for **graph-oriented diagrams** such as topology, dependency, directed-flow, and relationship graphs. PlantUML does not provide native DFD notation, so DFDs may be represented using appropriate PlantUML constructs or Graphviz/DOT when needed.

**Status on this project: every one of the 16 built diagrams is PlantUML.** The DFDs and the PERT chart were originally authored in Graphviz and later converted, so no `.dot` sources remain. Graphviz stays documented and permitted by this rule — it is a legitimate choice for the diagram types below — but a contributor adding a diagram should default to PlantUML for consistency with what is already in the book.

| Diagram type | Notes |
|---|---|
| DFDs (Level 0/1/2, Context Diagram) | Not a UML type. PlantUML has no native DFD notation, so borrow shapes deliberately: `usecase` (ellipse) = process, `database` (cylinder) = data store, `rectangle` = external entity. Graphviz gives those shapes directly instead of by analogy, which is its main advantage here. |
| PERT / precedence networks | A directed acyclic precedence graph. Both tools handle a linear chain well; PlantUML `rectangle` + `usecase` milestones is what this project used. |
| Dependency graphs, generic flowcharts | Any non-UML node/edge graph with no standard UML equivalent. |

Everything that **is** a UML type stays on Rule 1 (PlantUML).

### Layout-control equivalence (correction — previously stated wrongly here)

An earlier version of this rule claimed Graphviz's rank-control primitives were "not expressible in PlantUML." **That is false**, and the DFD conversion disproved it directly. The mapping is:

| Graphviz | PlantUML equivalent |
|---|---|
| `style=invis` (invisible spine edge) | `-[hidden]->` |
| `constraint=false` (edge that does not affect ranking) | `-[norank]->` |
| `ranksep` / `nodesep` | `skinparam ranksep` / `skinparam nodesep` (passed through to dot) |
| `{ rank=same; ... }` | **no equivalent** — but usually redundant if every node already has exactly one constrained-or-hidden in-edge |

Every `constraint=false` edge in the original DFD sources ported one-for-one, and all three DFDs held their portrait orientation after conversion.

Two PlantUML-specific gotchas worth knowing, both hit during that conversion:

- **Rank follows written order, not arrow direction.** Writing a return flow as `SYS --> VER` ranks `VER` *below* `SYS`. Write it `VER <-- SYS` to keep `VER` above. Getting this wrong made DFD Level 0 compile landscape (842 × 647) instead of portrait.
- **Inline line styles silently reset stroke width.** `#line.dashed` drops the border back to 1px, discarding a `BorderThickness 2.5`. Use a stereotype with its own skinparams if you need both.

Note also that PlantUML itself shells out to Graphviz for most non-sequence diagram types (`plantuml -testdot` confirms the dependency), so choosing PlantUML does not remove `dot` from the toolchain — it just puts a layer over it.

### Sizing for the page, not for the ratio metric

A lower width÷height ratio is **not** automatically better. Diagrams are embedded with `fit: "contain"` inside a fixed box (for the full-page diagrams, `width: 100%, height: 86%` ≈ 16.0 × 21.2 cm, box ratio ≈ **0.755**). Below that ratio the image becomes *height-bound*, leaving horizontal space unused, so pushing the ratio lower actively shrinks the printed result.

DFD Level 1 is the worked example: at ratio 0.686 it printed 14.6 × 21.2 cm; retuning `ranksep` to 110 brought it to 0.754 and it now prints 16.0 × 21.2 cm — the same content, ~10% more area, with no source restructuring.

**Raising the diagram's font size does not help.** Bumping DFD Level 1 from `UsecaseFontSize 19` to `24` grew the SVG canvas proportionally (1701 × 2255 → 2122 × 2403), and `fit: "contain"` scaled it straight back down: printed text went 1.79 mm → 1.81 mm, a 1% change. The only real levers on printed legibility are reducing content, matching the box ratio, or giving the diagram more page.

## Rule 3 — Native Typst (or `fletcher`) for linear/tabular content

| Case | Why native is right here |
|---|---|
| Sequence diagrams | Fletcher (or hand-drawn) gives 100% font-consistency with the rest of the document and searchable PDF text. **Note:** PlantUML is equally acceptable here and is what this project actually used — PlantUML draws sequence diagrams natively rather than via Graphviz auto-layout, so lifeline/timing layout is well handled, and it keeps the sequence diagram consistent with the other 11 PlantUML diagrams. Either tool is fine; pick one and stay consistent. |
| Event Tables | Tabular data, not a diagram — `#table()`, see Rule 4 |
| Small 2–3 box inline callouts | Too trivial to justify an external compile step |

## Rule 4 — Event Table is not a diagram

Event Tables (Event | Trigger | Source | Activity | Response | Destination columns) are tabular data. Use a native Typst `#table()` with the `styled-table()` helper from `typst-format.md` — never `columns: N` equal division, see that file for why.

## Rule 5 — Vertical orientation, always

**All diagrams in this blackbook are printed on A4 portrait pages, so every diagram must end up reading top-to-bottom on the printed page, never left-to-right.** A wide horizontal diagram either overflows the page width or gets shrunk so small it's unreadable in print — and once the book is bound, there's no fixing that after the fact.

- **PlantUML** defaults to top-to-bottom already for most UML types. Never add `left to right direction` to a `.puml` file in this project — if a diagram naturally wants to sprawl sideways (e.g. many actors/use-cases at the same level), let it grow taller instead by restructuring relationships, not by switching to horizontal.
- **Graphviz** defaults to `rankdir=TB` (top-to-bottom) when `rankdir` is omitted, but state it explicitly (`rankdir=TB`) in every `.dot` file rather than relying on the implicit default — explicit beats implicit when a whole book depends on it.
- **Don't blindly compile-and-check.** Before generating anything, look at the diagram's actual shape: how many nodes sit at the same conceptual level (same rank), how long are the labels, how many parallel edges cross. Think through whether forcing that content into a tall/narrow vertical layout will produce something genuinely readable, or just a diagram that's technically vertical but cramped, overlapping, or absurdly elongated. A 3-actor Use Case diagram restructures cleanly. A Deployment diagram with six parallel nodes at the same layer usually doesn't — forcing it vertical just trades a wide unreadable diagram for a tall unreadable one.
- **Decide before building, not after:**
  1. If the content naturally restructures top-to-bottom without crowding → build it vertical directly (default `rankdir=TB` / no `left to right direction`). This is the common case — most UML types.
  2. If the content is inherently wide (many same-rank nodes, long horizontal label chains) and forcing it vertical would genuinely look worse than horizontal → **build the diagram in its natural horizontal layout, then rotate the compiled SVG** for the printed page, per Rule 5a. Don't fight the diagram's natural shape into a bad vertical version just to avoid rotation.
- Either way, before committing an `.svg`, open it and check the aspect ratio against which path you took. If you built vertical, it should read cleanly top-to-bottom with no overlap. If you built horizontal-to-rotate, confirm Rule 5a's `reflow: true` step actually produces a clean rotated result before moving on — don't assume it worked.

### Rule 5a — When the diagram genuinely can't go vertical

Some diagrams resist top-to-bottom restructuring without becoming unreadable — wide Component/Deployment diagrams with many parallel nodes, or a Use Case diagram with several actors that would otherwise stack absurdly tall. For these, rotate the SVG image with Typst's `rotate()`, but keep the page itself portrait:

```typst
#align(center)[
  #rotate(-90deg, reflow: true)[
    #image("attachments/deployment_diagram.svg", width: 90%)
  ]
]
```

- **`reflow: true` is mandatory.** Without it, Typst rotates the image in place without resizing its allocated layout box, so a wide diagram rotated 90° either gets clipped or leaves huge dead space around it. `reflow: true` lets the now-tall-and-narrow rotated box actually claim the right amount of vertical space on the page.
- **`-90deg` vs `90deg`** just changes which side the "top" of the original diagram ends up on — pick whichever reads more naturally when the physical book page is turned (test both, they're not equivalent for a reader rotating a bound page).
- **The catch, unavoidable with this approach:** every label, class name, and arrow annotation *inside* the SVG rotates along with the diagram. The image itself becomes readable again once the reader physically turns the book sideways — but on the page as printed (unrotated), all text runs vertically. This is fine for a diagram the reader is expected to turn the book for, same as the landscape-page approach — the difference is purely whether the *page boundary* rotates (Rule 5a alt: `#page(flipped: true)`) or just the *image* rotates within a portrait page (this rule). Rotating the image keeps the rest of that page's portrait content (captions, body text) upright and normal, which is the main reason to prefer this over a full landscape page when the diagram shares a page with regular text.
- Add a one-line caption near the image either way: *"Turn page sideways to view Figure X.X"* — the reader has no other visual cue that rotation is expected.
- Still try restructuring the diagram vertically first (fewer nodes per rank, splitting one large diagram into two) — reach for rotation only when that's genuinely not workable, since a rotated figure breaks reading flow more than a normal one.

## Workflow — two build chains now

```bash
# PlantUML diagrams (Rule 1 — Class, ER, Object, Component, Package, Deployment, Use Case, State)
plantuml -tsvg diagram.puml
# outputs diagram.svg next to the .puml

# Graphviz diagrams (Rule 2 — DFD only)
dot -Tsvg diagram.dot -o diagram.svg

# Embed either in Typst identically
#align(center)[ #image("attachments/diagram.svg", width: 90%) ]

# Compile the submission
typst compile main.typ main.pdf
```

**New dependency, worth knowing before deadline week:** PlantUML needs a JVM (`java -jar plantuml.jar` under the hood, or the `plantuml` CLI wrapper). Verify `java -version` and `plantuml -version` both work *now*, not the night before a submission — this is the one new failure point the hybrid approach introduces. Graphviz's `dot` stays a native binary with no such dependency, which is exactly why DFDs stayed on it.

Keep `.puml`/`.dot` sources + their compiled `.svg` inside the submission's `attachments/` subfolder either way — same convention regardless of which tool produced the file.

## Quick decision check

1. Is it an Event Table? → Native Typst `#table()`.
2. Is it a Sequence Diagram or ≤3-box callout? → Native Typst / fletcher (PlantUML is also acceptable for Sequence — see Rule 3).
3. Is it a DFD or Context Diagram? → Graphviz with explicit `rankdir=TB` (preferred, for shape control); PlantUML constructs are permitted if you prefer a single toolchain — see Rule 2.
4. Is it another graph-oriented diagram with no UML equivalent (PERT/precedence network, dependency graph, generic flowchart)? → Graphviz, explicit `rankdir=TB`.
5. Is it any other UML type (ER, Class, Object, Component, Package, Deployment, Use Case, State)? → PlantUML, top-to-bottom (default).
6. Does the diagram naturally have many same-rank nodes or long horizontal chains that would crowd or overlap if forced vertical? → Build it in its natural horizontal layout and rotate the SVG instead — see Rule 5a. Otherwise → build vertical directly (Rule 5).
7. Compiled `.svg` still comes out wider than tall despite building vertical? → Fix the source restructuring, don't just shrink `width:` in Typst — see Rule 5.

---

## Rule 6 — Modern Professional Engineering Typography & High Legibility

**All diagrams use modern, clean, engineering-grade sans-serif typography (`Liberation Sans` / `Helvetica-Bold` / `Arial`) with high-contrast borders and large font sizing to match production software architecture specifications.**

### PlantUML skinparam block (prepend to every `.puml` file)

```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold

skinparam backgroundColor white
skinparam ArrowColor black
skinparam ArrowThickness 2.5
skinparam ArrowFontSize 17
skinparam ArrowFontStyle bold

skinparam EntityBorderColor black
skinparam EntityBorderThickness 2.5
skinparam EntityBackgroundColor #F8F9FA
skinparam EntityFontSize 22
skinparam EntityFontStyle bold

skinparam ClassBorderColor black
skinparam ClassBorderThickness 2.5
skinparam ClassBackgroundColor #F8F9FA
skinparam ClassFontSize 22
skinparam ClassFontStyle bold
skinparam ClassAttributeFontSize 18

skinparam UsecaseBorderColor black
skinparam UsecaseBorderThickness 2.5
skinparam UsecaseBackgroundColor #F8F9FA
skinparam UsecaseFontSize 19
skinparam UsecaseFontStyle bold

skinparam ActorBorderColor black
skinparam ActorBorderThickness 2.5
skinparam ActorBackgroundColor #FFFFFF
skinparam ActorFontSize 20
skinparam ActorFontStyle bold

skinparam RectangleBorderColor black
skinparam RectangleBorderThickness 2.5
skinparam RectangleBackgroundColor transparent
skinparam RectangleFontSize 20
skinparam RectangleFontStyle bold

title FactStamp - <Diagram Name>
```

- **Bold Labels**: In entity attribute lists, mark critical field names and types with markdown bold `**fieldName** : type` for maximum clarity.
- **Heavy Borders**: Use `skinparam ArrowThickness 2.5` and border thickness `2.5` so lines are crisp, solid, and high-contrast.

### Graphviz block (DFD only — Professional Sans-Serif Typography)

```dot
digraph DFD {
  bgcolor="white"
  fontname="Liberation Sans Bold"
  label="FactStamp - <Diagram Name>"
  labelloc=t
  fontsize=32
  rankdir=TB
  nodesep=0.5
  ranksep=0.8
  margin=0.05

  node [fontname="Liberation Sans Bold", fontsize=24, style="filled,bold", fillcolor="#F8F9FA", color="#000000", penwidth=3.0]
  edge [fontname="Liberation Sans Bold", fontsize=18, color="#000000", penwidth=2.5]

  node [shape=circle]  // processes
  node [shape=box]     // external entities — override per-node
  User [shape=box, fontname="Liberation Sans Bold", fontsize=24, margin="0.2,0.15"]
  User -> "1.0 Submit Claim" [label=" 1. Forward Text/Screenshot ", fontname="Liberation Sans Bold", fontsize=18]
}
```

- **Bold Graphviz Fonts**: Use `fontname="Liberation Sans Bold"` (or `fontname="Helvetica-Bold"`) for all node labels, edge labels, and titles.
- **Heavy Penwidth**: `penwidth=3.0` for nodes and `penwidth=2.5` for edges ensures crisp rendering at all scale factors.

## Per-diagram-type templates

### ER Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam EntityFontSize 22
skinparam EntityFontStyle bold
skinparam ClassAttributeFontSize 18
skinparam ArrowThickness 2.5
title FactStamp - ER Diagram

entity Claim {
  * id : string
  --
  text : string
  status : string
}

entity Verifier {
  * id : string
  --
  reputation : int
}

entity Verdict {
  * id : string
  --
  type : string
  source : string
}

Verifier ||--o{ Verdict : submits
Claim ||--o{ Verdict : "has many"
@enduml
```

### Class Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ClassFontSize 22
skinparam ClassFontStyle bold
skinparam ClassAttributeFontSize 18
skinparam ArrowThickness 2.5
title FactStamp - Class Diagram

abstract class BaseVerifier {
  +id: string
  +reputation: int
  +submitVerdict()
}

class CommunityVerifier {
  +weight()
}

class Claim {
  +id: string
  +text: string
  +status: string
  +addVerification()
}

class Verification {
  +verdict: string
  +source: string
}

CommunityVerifier --|> BaseVerifier
CommunityVerifier ..> Verification : submits
Claim "1" *-- "many" Verification : has
@enduml
```
`--|>` inheritance, `..>` dependency, `*--` composition, `o--` aggregation — native PlantUML arrows, no `arrowhead=` fiddling.

### Object Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
title FactStamp - Object Diagram

object "verifier_042 : CommunityVerifier" as v1 {
  reputation = 78
  weight = 1.5
}

object "claim_017 : Claim" as c1 {
  status = "contested"
}

v1 --> c1 : verified
@enduml
```

### Component Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
title FactStamp - Component Diagram

component Frontend
component API
database Firestore
component WasmOCR

Frontend --> API : REST
Frontend --> WasmOCR : In-Browser OCR
API --> Firestore
@enduml
```

### Package Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
title FactStamp - Package Diagram

package "Auth Module" {
  class Login
  class Signup
}

package "Verification Module" {
  class Queue
  class Consensus
}

"Auth Module" --> "Verification Module"
@enduml
```

### Deployment Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
title FactStamp - Deployment Diagram

node "Client Device" {
  [Browser]
  [WasmOCR]
}

node "Vercel" {
  [Frontend]
  [ServerlessFn]
}

node "Google Cloud" {
  database Firestore
}

[Browser] --> [Frontend] : HTTPS
[Browser] --> [WasmOCR] : In-browser OCR
[ServerlessFn] --> Firestore
@enduml
```

### State Diagram (PlantUML)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
title FactStamp - State Diagram

[*] --> Pending
Pending --> UnderReview : 3rd verifier joins
UnderReview --> Resolved : consensus reached
UnderReview --> Contested : 7 days, no consensus
Resolved --> [*]
Contested --> [*]
@enduml
```

### Use Case Diagram (PlantUML — Left-to-Right 2-Column Standard)
```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 18
skinparam defaultFontStyle bold
skinparam titleFontSize 24
skinparam titleFontStyle bold
skinparam ArrowThickness 2.5
skinparam ArrowFontSize 15
skinparam ArrowFontStyle bold
skinparam UsecaseFontSize 18
skinparam UsecaseFontStyle bold
skinparam ActorFontSize 19
skinparam ActorFontStyle bold

title FactStamp - Use Case Diagram
left to right direction

actor "Public Submitter" as User
actor "Community Verifier" as Verifier
actor "System Engine" as Engine

rectangle "FactStamp System Boundary" {
  usecase "Submit Claim" as UC1
  usecase "Check Duplicate" as UC2
  usecase "View Confidence" as UC3
  usecase "Export Fact Card" as UC4
  usecase "Review Queue" as UC5
  usecase "Submit Verdict" as UC6
  usecase "Compute Consensus" as UC7
}

User --> UC1
User --> UC3
User --> UC4
UC1 ..> UC2 : <<include>>
Verifier --> UC5
Verifier --> UC6
UC6 ..> UC7 : <<trigger>>
Engine --> UC2
Engine --> UC7
@enduml
```

### DFD (Graphviz — the one type on dot)
```dot
digraph DFD {
  bgcolor="white"
  fontname="Liberation Sans Bold"
  label="FactStamp - Data Flow Diagram Level 0"
  labelloc=t
  fontsize=32
  rankdir=TB
  nodesep=0.5
  ranksep=0.8
  margin=0.05
  node [fontname="Liberation Sans Bold", fontsize=24, style="filled,bold", fillcolor="#F8F9FA", color="#000000", penwidth=3.0]
  edge [fontname="Liberation Sans Bold", fontsize=18, color="#000000", penwidth=2.5]
  node [shape=circle]
  node [shape=box]
  User [shape=box, margin="0.2,0.15"]
  User -> "1.0 Submit Claim" [label=" 1. Forward Text/Screenshot "]
}
```

## File naming & location

### Folder & File Naming Rule
- **Folder Name**: **MUST EXACTLY MATCH** the title/prompt specified by the user (e.g. `Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/`).
- **Sub-file Names (`.typ` & `.pdf`)**: Use a concise **descriptive title slug** with lowercase words and underscores (e.g. `data_integrity_and_security_issues.typ` & `data_integrity_and_security_issues.pdf`).

Each submission folder gets an `attachments/` subfolder holding **all** source (`.puml` or `.dot`) + `.svg` pairs — same convention regardless of which tool produced the diagram.

```
Submission of Chp 4: 4.2.2 Data Integrity and Constraints, 4.4 Security Issues/
│  data_integrity_and_security_issues.typ
│  data_integrity_and_security_issues.pdf
└─ attachments/
   │  er_diagram.puml
   │  er_diagram.svg
   │  class_diagram_core.puml
   └  class_diagram_core.svg
```

```
Submission of 3.6 Conceptual Models - Data Flow Diagram/
│  data_flow_diagram.typ
│  data_flow_diagram.pdf
└─ attachments/
   │  dfd_level_0.puml
   │  dfd_level_0.svg
   │  dfd_level_1.puml
   │  dfd_level_1.svg
   │  dfd_level_2.puml
   └  dfd_level_2.svg
```

(These are the real filenames as built. They were `.dot` originally — the `.svg` names are unchanged by the conversion, which is what let the Typst `#image()` calls stay untouched.)

Rules:
- One source file + one `.svg` per diagram, even if two diagrams are related — don't combine ER + Class into one `.puml`.
- Filenames are `<diagram_type>_<qualifier>.puml` or `.dot` — lowercase, underscores, no spaces.
- Reference from Typst as `#image("attachments/er_diagram.svg", width: 100%)` — identical regardless of source tool.
- Commit the `.svg` files too — don't `.gitignore` `attachments/`.
- Multi-level DFDs all live in the same `attachments/` folder — filename qualifier is enough, no per-level subfolders.

## Full worked example

`attachments/class_diagram_core.puml` — complete file, title/skinparam block + real diagram body:

```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 20
skinparam defaultFontStyle bold
skinparam titleFontSize 26
skinparam titleFontStyle bold
skinparam backgroundColor white
skinparam ArrowColor black
skinparam ArrowThickness 2.5
skinparam ArrowFontSize 17
skinparam ArrowFontStyle bold
skinparam ClassBorderColor black
skinparam ClassBorderThickness 2.5
skinparam ClassBackgroundColor #F8F9FA
skinparam ClassFontSize 22
skinparam ClassFontStyle bold
skinparam ClassAttributeFontSize 18
title FactStamp - Class Diagram

abstract class BaseVerifier {
  +id: string
  +reputation: int
  +submitVerdict()
}

class CommunityVerifier {
  +weight()
}

class Claim {
  +id: string
  +text: string
  +status: string
}

class Verification {
  +verdict: string
  +source: string
}

CommunityVerifier --|> BaseVerifier
CommunityVerifier ..> Verification : submits
Claim "1" *-- "many" Verification : has
@enduml
```

Compile:
```bash
plantuml -tsvg attachments/class_diagram_core.puml
typst compile class_diagram_er.typ class_diagram_er.pdf
```

Every other UML diagram type follows this same skeleton — skinparam block stays identical, only the diagram body changes per the templates above. DFDs are the one exception and keep using the Graphviz worked example (dot → svg, large-font block).

