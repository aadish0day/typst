# Typst Project & Document Generation Rules

These rules apply to all Typst documents generated in this workspace across all projects, black books, dissertations, and assignments/submissions.

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
   - Headers: bold and centered, top/bottom black borders (`1.2pt + black`), subtle background (`rgb("F4F5F7")`).
   - Cell borders: thin light gray (`0.4pt + luma(180)`).
   - Text size: `10pt` or `10.5pt`.

4. **Submissions & Folder Naming**:
   - Folder name must match the assignment/submission prompt.
   - Files inside should use descriptive snake_case slugs (`.typ` and `.pdf`).

---

## 3. Black Book Preliminary Pages (Front-Matter) Sequence

As prescribed by the official University Syllabus (`Project_syllabus.md`, Course `JUSIT-DSCPR503`, Section `1.1 PROJECT REPORT:`), the preliminary pages **MUST** follow this exact chronological sequence:

| Page # | Section Title | Description / Content | Pagination Style |
| :---: | :--- | :--- | :---: |
| **1** | **Title / Cover Page** | Project Title, Degree (`B.Sc. IT`), Student Name, UID/Roll No., Guide Names, College Logo, Department, City, Academic Year. | *Unnumbered* (`numbering: none`) |
| **2** | **Approved Proforma** | Original Copy of the Approved Proforma of Project Proposal. Includes Course Code, Domain, Tech Stack, Status, and Signatures (Student, Guide, Coordinator, HOD). | `ii` |
| **3** | **Certificate** | Certificate of Authenticated Work (Bonafide certificate with College Seal, Guide, Coordinator, and External Examiner signature blocks). | `iii` |
| **4** | **Declaration** | Student declaration of original and un-duplicated work. | `iv` |
| **5** | **Role and Responsibility Form** | Formal SDLC breakdown of technical responsibilities and individual contribution percentage with signature blocks. | `v` |
| **6** | **Abstract** | High-level technical summary of problem, methodology, algorithms, findings, and 6–8 keywords. | `vi` |
| **7** | **Acknowledgement** | Formal institutional appreciation to HOD, Guides, faculty members, peers, and family. | `vii` |
| **8–9** | **Table of Contents (TOC)** | `#outline(...)` or structured table. **MUST** be placed on its own dedicated page(s), enclosed with `#pagebreak()` before and after. | `viii`–`ix` |
| **10** | **Table of Figures & Tables** | Complete list of UML, DFD, and PERT figures + key data matrices. | `x` |

### Front-Matter Pagination Rule:
- **Cover Page**: Suppress page numbering (`#set page(numbering: none)`).
- **Preliminary Pages (2 to 10)**: Lowercase Roman numerals (`#set page(numbering: "i")`, `#counter(page).update(2)`).
- **Chapter 1 Onwards (Main Body)**: Arabic numerals restarting at 1 (`#set page(numbering: "1")`, `#counter(page).update(1)`).

---

## 4. Black Book Chapter Structure & Syllabus Organization

The main body of the Black Book dissertation must strictly adhere to the 7-chapter structure from `Project_syllabus.md`:

- **CHAPTER 1: INTRODUCTION**
  - 1.1 Background
  - 1.2 Objectives
  - 1.3 Purpose, Scope, and Applicability (1.3.1 Purpose, 1.3.2 Scope, 1.3.3 Applicability)
  - 1.4 Achievements
  - 1.5 Organisation of Report
- **CHAPTER 2: SURVEY OF TECHNOLOGIES**
  - Comparative analysis of frameworks, databases, libraries, and runtime architecture.
- **CHAPTER 3: REQUIREMENTS AND ANALYSIS**
  - 3.1 Problem Definition
  - 3.2 Requirements Specification (IEEE Std 830-1998 REQ-1 to REQ-10)
  - 3.3 Planning and Scheduling (PERT Chart, WBS & Milestones)
  - 3.4 Software and Hardware Requirements Specifications
  - 3.5 Preliminary Product Description
  - 3.6 Conceptual Models (Use Case, DFD Level 0/1, E-R, Class, Object Diagrams)
- **CHAPTER 4: SYSTEM DESIGN**
  - 4.1 Basic Modules
  - 4.2 Data Design (4.2.1 Schema Design, 4.2.2 Data Integrity and Constraints)
  - 4.3 Procedural Design (4.3.1 Logic Diagrams, 4.3.2 Data Structures, 4.3.3 Algorithms Design)
  - 4.4 User Interface Design
  - 4.5 Security Issues & Anti-Sybil Defense
  - 4.6 Test Cases Design
- **CHAPTER 5: IMPLEMENTATION AND TESTING**
  - 5.1 Implementation Approaches
  - 5.2 Coding Details and Code Efficiency (5.2.1 Code Efficiency)
  - 5.3 Testing Approach (5.3.1 Unit Testing, 5.3.2 Integrated Testing, 5.3.3 Beta Testing)
  - 5.4 Modifications and Improvements
  - 5.5 Test Cases Execution Matrix
- **CHAPTER 6: RESULTS AND DISCUSSION**
  - 6.1 Test Reports & Empirical Metrics
  - 6.2 User Documentation
- **CHAPTER 7: CONCLUSIONS**
  - 7.1 Conclusion (7.1.1 Significance of the System)
  - 7.2 Limitations of the System
  - 7.3 Future Scope of the Project
- **REFERENCES** (IEEE Citation Style)
- **GLOSSARY**

---

## 5. Diagram & Visual Standards

1. **UML Diagrams**: Must use **PlantUML** (`.puml` → `.svg`) with strict modern styles (`skinparam style strictuml`, clean white background, high contrast).
2. **Data Flow Diagrams (DFDs)**: Must use **Graphviz** (`.dot` → `.svg`) for Level 0, Level 1, and Level 2 DFDs.
3. **Embed Syntax**:
   - Embed full width with `#image("attachments/diagram.svg", width: 100%)`.
   - Never clip text inside diagrams.
   - For ultra-wide diagrams, use a dedicated rotated layout or landscape page.
