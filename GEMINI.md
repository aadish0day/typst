# Typst Project & Document Generation Rules

These rules apply to all Typst documents generated in this workspace across all projects, black books, and assignments/submissions.

---

## 1. Page Border Enforcement (Mandatory)

For all **Black Book** project reports/dissertations and **Assignments / Submissions**, every page **MUST** include a solid **black border** (`stroke: 1pt + black`).

### Implementation Boilerplate:
```typst
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in), // Standard binding margins
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  )
)
```

---

## 2. General Formatting & Typography Rules

1. **Font & Paragraph Settings**:
   ```typst
   #set text(
     font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
     size: 12pt, // Mandatory 12pt for content
     lang: "en",
     hyphenate: true,
   )
   #set par(justify: true, leading: 0.65em, first-line-indent: 0pt) // Mandatory Justified Content
   #set heading(numbering: "1.1")
   ```

2. **Heading & Subheading Hierarchy**:
   - **Headings (Level 1)**: `16pt`, **Bold**
   - **Subheadings (Level 2)**: `14pt`, **Bold**
   - **Sub-subheadings (Level 3)**: `13pt`, **Bold**
   - **New Topic on New Page (Mandatory)**: Every new topic or major section (Level 1 Heading) **MUST** start on a new page.
   ```typst
   #show heading.where(level: 1): set text(size: 16pt, weight: "bold")
   #show heading.where(level: 2): set text(size: 14pt, weight: "bold")
   #show heading.where(level: 3): set text(size: 13pt, weight: "bold")

   // Mandatory: New topic on new page
   #show heading.where(level: 1): it => {
     pagebreak(weak: true)
     it
   }
   ```

3. **Tables**:
   - Headers: bold and centered, top/bottom black borders (`1.2pt + black`).
   - Cell borders: thin light gray (`0.4pt + luma(180)`).

4. **Submissions & Folder Naming**:
   - Folder name must match the assignment/submission prompt.
   - Files inside should use descriptive snake_case slugs (`.typ` and `.pdf`).

5. **Table of Contents (TOC)**:
   - When included, the Table of Contents (`#outline(...)`) **MUST** be placed on its own dedicated page, enclosed with `#pagebreak()` before and after.

