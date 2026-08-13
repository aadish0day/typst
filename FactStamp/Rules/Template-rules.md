# AI Guidelines — How and When to Use the `template/` Folder

> **Authoritative Reference for AI Agents**  
> Location: [`/home/aadish/Documents/typst/FactStamp/Rules/Template-rules.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Template-rules.md) & [`/home/aadish/Documents/typst/FactStamp/template/README.md`](file:///home/aadish/Documents/typst/FactStamp/template/README.md)

---

## 1. Purpose & Inventory

The `template/` folder (and its mirror `templete/`) contains converted Markdown reference templates for software engineering standards, IEEE specifications, and Software Development Life Cycle (SDLC) process models.

AI agents operating in the `FactStamp` repository **MUST read and consult these templates** before generating dissertation chapters, requirements documents, or project submission files.

### 📌 Template Inventory & Reference Files

| Template File Path | Source Standard / Domain | Primary Use Case |
|---|---|---|
| [`template/srs_template-ieee.md`](file:///home/aadish/Documents/typst/FactStamp/template/srs_template-ieee.md) | IEEE Std 830-1998 / ISO/IEC 29148 | Software Requirements Specifications (SRS), Functional & Non-Functional Requirements, System Features. |
| [`template/2020-Scrum-Guide-US.md`](file:///home/aadish/Documents/typst/FactStamp/template/2020-Scrum-Guide-US.md) | Official Scrum Guide (2020) by Schwaber & Sutherland | Formal Scrum framework definitions, roles (Product Owner, Scrum Master, Developers), artifacts, and events. |
| [`template/SCRUM_Model.md`](file:///home/aadish/Documents/typst/FactStamp/template/SCRUM_Model.md) | Agile Scrum Lifecycle & Ceremonies | Sprint planning, daily standups, sprint reviews, backlog refinement, and velocity metrics. |
| [`template/SDLC_Software_Process_Models.md`](file:///home/aadish/Documents/typst/FactStamp/template/SDLC_Software_Process_Models.md) | Software Engineering Process Models | Comparative evaluation of Waterfall, Spiral, V-Model, Iterative, and Agile SDLC methodologies. |
| [`template/Extreme_Programming.md`](file:///home/aadish/Documents/typst/FactStamp/template/Extreme_Programming.md) | Extreme Programming (XP) | Technical engineering practices: Pair Programming, Test-Driven Development (TDD), Refactoring, Continuous Integration. |
| [`template/Kanban.md`](file:///home/aadish/Documents/typst/FactStamp/template/Kanban.md) | Kanban Flow & Lean Development | Work-In-Progress (WIP) limits, visual workflow queues, cycle time optimization, and bottleneck management. |
| [`template/FDD.md`](file:///home/aadish/Documents/typst/FactStamp/template/FDD.md) | Feature-Driven Development (FDD) | Feature list decomposition, domain object modeling, milestone tracking, and chief programmer strategy. |

---

## 2. WHEN TO USE Each Template (Decision Matrix)

When a user asks to generate a new submission, chapter section, or specification document, consult the decision matrix below to select the mandatory reference template(s):

```
User Prompt Request
  ├── "Submission of ... SRS" or "Functional Requirements" or "Chapter 3.2"
  │     └── READ: template/srs_template-ieee.md
  │
  ├── "Submission of SDLC" or "Process Models" or "Chapter 3.3 / Chapter 5.1"
  │     └── READ: template/SDLC_Software_Process_Models.md
  │
  ├── "Scrum" or "Agile Methodology" or "Sprint Planning"
  │     └── READ: template/2020-Scrum-Guide-US.md AND template/SCRUM_Model.md
  │
  ├── "Extreme Programming" or "XP" or "TDD / Pair Programming"
  │     └── READ: template/Extreme_Programming.md
  │
  ├── "Kanban" or "WIP Limits" or "Flow Management"
  │     └── READ: template/Kanban.md
  │
  └── "Feature-Driven Development" or "FDD"
        └── READ: template/FDD.md
```

### Detailed Scenario Triggers

1. **Scenario 1: Creating any SRS or Functional Requirements Submission**
   - *Trigger Words:* `SRS`, `Functional Requirements`, `IEEE 830`, `Requirements Specification`, `System Features`.
   - *Action:* Open and read [`template/srs_template-ieee.md`](file:///home/aadish/Documents/typst/FactStamp/template/srs_template-ieee.md).
   - *Requirement:* Enforce exact IEEE 830 section structure (Section 1 Introduction, Section 2 Overall Description, Section 3 External Interfaces, Section 4 System Features, Section 5 Nonfunctional Requirements, Section 6 Other Requirements, Appendices A–C).

2. **Scenario 2: Creating SDLC & Development Methodology Sections**
   - *Trigger Words:* `SDLC`, `Software Process Models`, `Development Methodology`, `Waterfall vs Agile`.
   - *Action:* Open and read [`template/SDLC_Software_Process_Models.md`](file:///home/aadish/Documents/typst/FactStamp/template/SDLC_Software_Process_Models.md).
   - *Requirement:* Compare traditional vs modern models, justifying why FactStamp uses Agile/Scrum.

3. **Scenario 3: Creating Scrum Sprint & Ceremony Documentation**
   - *Trigger Words:* `Scrum`, `Sprint`, `Scrum Master`, `Product Backlog`, `User Stories`, `Burndown`.
   - *Action:* Open and read [`template/2020-Scrum-Guide-US.md`](file:///home/aadish/Documents/typst/FactStamp/template/2020-Scrum-Guide-US.md) and [`template/SCRUM_Model.md`](file:///home/aadish/Documents/typst/FactStamp/template/SCRUM_Model.md).
   - *Requirement:* Use official 2020 Scrum terminology (Product Goal, Sprint Goal, Definition of Done, 3 Roles, 5 Events, 3 Artifacts).

---

## 3. HOW TO USE the Templates (AI Execution Workflow)

Follow this strict 5-step execution workflow whenever generating code or document deliverables based on `template/`:

```
Step 1: Parse Prompt & Identify Domain
  ↓
Step 2: Read Authoritative Template from template/<file>.md
  ↓
Step 3: Read Core Project Documentation (CODE_PATHS_AND_NOTES.md & codebase)
  ↓
Step 4: Map FactStamp Architecture onto Template Structure
  ↓
Step 5: Compile Typst PDF deliverable & Verify formatting rules
```

### Step-by-Step Instructions

1. **Step 1 — Read the Target Template**: Call `view_file` on the corresponding template in `template/<name>.md`. Extract the official headings, table formats, and section numbering.
2. **Step 2 — Read FactStamp Architecture**: Inspect [`CODE_PATHS_AND_NOTES.md`](file:///home/aadish/Documents/typst/FactStamp/CODE_PATHS_AND_NOTES.md) and `src/lib/types.ts` to get FactStamp's actual 7 system modules, Firebase backend architecture, Jaccard similarity math, and `html2canvas` card generator specs.
3. **Step 3 — Fuse Template Structure with FactStamp Specifics**: Replace generic placeholders (`<Project>`, `<author>`, `<Feature 1>`) with actual FactStamp facts:
   - System Features 1–7 (Auth, Ingestion/OCR, Duplicate Detection, Quorum Queue, Consensus Engine, PNG Card Generator, Analytics Dashboard).
   - Weighted Confidence Formula: $\text{Confidence} = (A \times 40\%) + (R \times 30\%) + (S \times 30\%)$.
   - Duplicate Matching Threshold: Jaccard word-overlap index $J(A, B) \ge 0.75$.
4. **Step 4 — Format in Typst**: Follow formatting rules from [`Rules/Typst_format.md`](file:///home/aadish/Documents/typst/FactStamp/Rules/Typst_format.md):
   - Include Master Setup Block & `#set heading(numbering: "1.1")`.
   - Use `#styled-table()` for academic tables.
   - Use `- *Bold Label*:` for list items (never double stars `**` or line-start `*`).
   - Use `#outline(title: [Table of Contents], indent: 1.5em, depth: 3)` for TOC generation.
5. **Step 5 — Compile & Verify**: Run `npx typst compile` and verify that the output `.pdf` compiles cleanly with exit code 0.

---

## 4. Strict Enforcement Rules for AI Agents

1. **Never Invent Custom Structures When a Template Exists**: If a template exists in `template/` for the requested domain (e.g. IEEE 830 for SRS), the AI **MUST** structure the output matching that template.
2. **Preserve Sub-file and Directory Naming Rules**:
   - **Directory Name**: **MUST EXACTLY MATCH** the user prompt (e.g. `Submission of Functional Requirements-SRS/`).
   - **Sub-file Names**: Must use descriptive lowercase slugs with underscores (e.g. `functional_requirements_srs.typ` & `functional_requirements_srs.pdf`).
3. **Double-Check Syntax Compliance**: Always ensure math expressions use Typst string quoting (`$150 "ms"$` not `\text{ms}`) and bold styling uses single asterisks (`*bold*`).
