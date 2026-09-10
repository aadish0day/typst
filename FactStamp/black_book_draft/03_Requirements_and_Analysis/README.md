# Chapter 3: Requirements and Analysis — Draft Index

> Project: **FactStamp — A Community-Powered WhatsApp Misinformation Fact-Checker**
> Course: Project Dissertation and Implementation (`JUSIT-DSCPR503`) — BSc Information Technology, Semester V
> Student: Aadish Das | Guides: Mr. Wilson Rao (HOD) & Ms. Bertilla Fernandes
> Jai Hind College (Empowered Autonomous), Mumbai — 2026-27

This folder contains the Markdown draft content and the compilable Typst chapter document for **Chapter 3: Requirements and Analysis**, per the official syllabus structure in `Rules/Project_syllabus.md`.

## Chapter Description

Chapter 3 moves from the narrative background/technology-survey chapters (1–2) into a formal engineering specification: a structured problem statement, an IEEE Std 830-1998 requirements specification (functional requirements tagged by module, non-functional requirements by quality domain), the Agile/Scrum development plan and schedule, software/hardware requirements, a module-by-module preliminary product description, and the full set of conceptual/analysis models (ER, UML, DFD) that ground Chapter 4's detailed system design.

## Subsection Files

| File | Syllabus Section | Content |
|---|---|---|
| [`3.1_problem_definition.md`](3.1_problem_definition.md) | 3.1 Problem Definition | Formal problem statement: why institutional and ad-hoc WhatsApp fact-checking fail, and how FactStamp's approach differs |
| [`3.2_requirements_specification_ieee830.md`](3.2_requirements_specification_ieee830.md) | 3.2 Requirements Specification | Full IEEE 830-1998 SRS: Introduction, Overall Description, External Interfaces, System Features (FR-AUTH/INGEST/DUP/QUEUE/CONSENSUS/CARD/DASH/ADMIN/SEC), Non-Functional Requirements (NFR-PERF/SEC/REL/USE/SCALE) |
| [`3.3_planning_and_scheduling.md`](3.3_planning_and_scheduling.md) | 3.3 Planning and Scheduling | Agile/Scrum process, 8×2-week sprint schedule table, PERT/Gantt chart content description |
| [`3.4_software_and_hardware_requirements.md`](3.4_software_and_hardware_requirements.md) | 3.4 Software and Hardware Requirements | Dev-tooling and dependency software table; client-device and dev-machine hardware tables |
| [`3.5_preliminary_product_description.md`](3.5_preliminary_product_description.md) | 3.5 Preliminary Product Description | One paragraph per core module (8 modules + Admin console), higher-level than Chapter 4's detailed design |
| [`3.6_conceptual_models.md`](3.6_conceptual_models.md) | 3.6 Conceptual Models | Introduces every required diagram (ER, Class, Object, Use Case, Activity, State, Sequence, Package, Component, Deployment, DFD L0/L1/L2) plus a full Event Table |
| [`03_requirements_and_analysis.typ`](03_requirements_and_analysis.typ) | — | Compilable Typst chapter assembling all six subsections above |

## Diagram Status

Every diagram referenced in `3.6_conceptual_models.md` (and the Gantt/PERT charts referenced in `3.3_planning_and_scheduling.md`) is marked inline with a `[DIAGRAM: ... — pending, see Rules/Diagram-rules.md]` placeholder. Actual diagram generation is a **separate pipeline**, per `Rules/Diagram-rules.md`:

- **PlantUML** (`.puml` → `.svg`) for all UML diagram types (ER, Class, Object, Use Case, Activity, State, Package, Component, Deployment).
- **Graphviz** (`.dot` → `.svg`) for the three DFD levels only.
- **Native Typst / Fletcher** for the Sequence Diagram and this chapter's Event Table (which is data, not a diagram — Rule 4).

When those `.puml`/`.dot` sources and their compiled `.svg` assets are produced, they should be placed in an `attachments/` subfolder of this directory (per the naming convention in `Rules/Diagram-rules.md` the "File naming & location" section) and the placeholder text notes in `03_requirements_and_analysis.typ` replaced with `#responsive-image("attachments/<name>.svg")` calls.

## How to Compile

From inside this directory (`03_Requirements_and_Analysis/`):

```bash
# Standalone individual-submission mode (default)
typst compile 03_requirements_and_analysis.typ 03_requirements_and_analysis.pdf

# Assembled blackbook mode (when combined into the master document)
typst compile --input mode=blackbook 03_requirements_and_analysis.typ 03_requirements_and_analysis.pdf
```

The `.typ` file contains no `#image()` calls to any diagram file, since none of the `attachments/*.svg` assets exist yet — it compiles cleanly as plain text with placeholder notes standing in for every pending diagram, per the task constraint that this file must build without external diagram dependencies.
