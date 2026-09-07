# CLAUDE.md — FactStamp Typst Workspace

This is the academic dissertation/black-book workspace for **FactStamp** (BSc IT, Jai Hind College, `JUSIT-DSCPR503`). It is Typst + Markdown documentation for the project whose actual source code lives at `/home/aadish/Documents/Github/FactStamp`.

## Mandatory Rule: Reading Before Black Book Work

**Before writing, editing, or assembling any black book content** (a chapter, a `Submission of ...` deliverable, front matter, or the final assembled black book), you **MUST** read all of the following first:

1. **Every `.md` file in [`Rules/`](file:///home/aadish/Documents/typst/FactStamp/Rules/)** — `Typst_format.md`, `Diagram-rules.md`, `Diagrams-Checklist.md`, `Template-rules.md`, `CODE_PATHS_AND_NOTES.md`, `Admin-rules.md`, `Module-rules.md`, `Project_syllabus.md`.
2. **Every `.md` file in [`template/`](file:///home/aadish/Documents/typst/FactStamp/template/)**:
   - `README.md`
   - `srs_template-ieee.md`
   - `2020-Scrum-Guide-US.md`
   - `SCRUM_Model.md`
   - `SDLC_Software_Process_Models.md`
   - `Extreme_Programming.md`
   - `Kanban.md`
   - `FDD.md`
3. **[`INDEX.md`](file:///home/aadish/Documents/typst/FactStamp/INDEX.md)** (root) — master reference and single source of truth for the whole project.
4. **[`Only_module/how_to.md`](file:///home/aadish/Documents/typst/FactStamp/Only_module/how_to.md)** — only if the section includes code screenshots.

Do not skip any of these on the assumption they're irrelevant to the specific section — the templates and rules cross-reference each other (e.g. `Template-rules.md` names which `template/*.md` file governs which chapter section), and skipping one produces content that's structurally inconsistent with the rest of the book.

## Where Things Live

| What | Where |
|---|---|
| Formatting rules (fonts, margins, front matter) | `Rules/Typst_format.md` |
| Diagram tooling (PlantUML / Graphviz / Typst) | `Rules/Diagram-rules.md` |
| Which `template/*.md` to use for which chapter | `Rules/Template-rules.md` |
| Codebase file/path inventory | `Rules/CODE_PATHS_AND_NOTES.md` |
| Admin console (`/admin`) reference | `Rules/Admin-rules.md` |
| 8 core system modules → source files | `Rules/Module-rules.md` |
| Master required-diagrams checklist | `Rules/Diagrams-Checklist.md` |
| Code screenshot pipeline | `Only_module/how_to.md` |
| Official chapter/syllabus structure | `Rules/Project_syllabus.md` |
| Master project index | `INDEX.md` |

## Source Code

FactStamp's actual application code is **not** in this repo — it's at `/home/aadish/Documents/Github/FactStamp`. Read `Rules/CODE_PATHS_AND_NOTES.md`, `Rules/Module-rules.md`, and `Rules/Admin-rules.md` for the mapping before describing any feature; do not invent functionality that isn't in the linked source files.
