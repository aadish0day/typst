# FactStamp: Black Book Preliminary Pages (Front-Matter) Master Index

This directory (`Black_Book/00_Preliminary_Pages/`) contains the complete, publication-grade markdown specifications and Typst source templates for all preliminary front-matter pages of the **FactStamp** capstone dissertation, submitted for Course **JUSIT-DSCPR503** (Project Dissertation and Implementation) for the degree of **Bachelor of Science in Information Technology (B.Sc. IT)** at **Jai Hind College (Empowered Autonomous)**, affiliated with the **University of Mumbai** (Academic Year 2026–2027).

---

## 1. Chronological Preliminary Pages Sequence & Pagination Matrix

As prescribed by the official University Syllabus (`Project_syllabus.md`, Section `1.1 PROJECT REPORT:`) and institutional black book binding guidelines, the front-matter pages strictly adhere to the following sequence:

| Document File | Section Title | Institutional Content Description | Pagination Style |
| :--- | :--- | :--- | :---: |
| [`01_title_page.md`](01_title_page.md) | **Title / Cover Page** | Project title, degree designation, candidate name (Aadish Das, UID: 2023IT001 / Roll No: 10), guides (Mr. Wilson Rao & Ms. Bertilla Fernandes), college logo, department, city, academic year (2026–27). | *Unnumbered* (`numbering: none`) |
| [`02_approved_proforma.md`](02_approved_proforma.md) | **Approved Proforma** | Original Copy of Approved Project Proposal proforma matrix (Course Code JUSIT-DSCPR503, Practical Title, Student & Guide info, tech stack with React 18.3.1, Vite 5.4.0, Tailwind CSS v4.0.0, Cloud Firestore v12.17.0, zero cloud storage bill model, approval status, signature grid). | `ii` |
| [`03_certificate.md`](03_certificate.md) | **Certificate** | Certificate of Authenticated Work (Bonafide certificate with College Seal, Guide, Coordinator, and External Examiner signature blocks). | `iii` |
| [`04_declaration.md`](04_declaration.md) | **Declaration** | Student declaration affirming original and un-duplicated work in accordance with UGC anti-plagiarism guidelines. | `iv` |
| [`05_role_and_responsibility.md`](05_role_and_responsibility.md) | **Role & Responsibility Form** | Formal SDLC breakdown of technical responsibilities (100% individual contribution across 8 modules). | `v` |
| [`06_abstract.md`](06_abstract.md) | **Abstract** | Formal 354-word academic abstract detailing WhatsApp dark social, Jaccard duplicate detection ($J \ge 0.75$), 3-verifier quorum consensus ($C = 0.40A + 0.30R + 0.30S$), html-to-image 1.11.13 card export, and 8 keywords. | `vi` |
| [`07_acknowledgement.md`](07_acknowledgement.md) | **Acknowledgement** | Formal institutional appreciation to HOD Wilson Rao, Prof. Bertilla Fernandes, college administration, peers, and family. | `vii` |
| [`08_table_of_contents.md`](08_table_of_contents.md) | **Table of Contents (TOC)** | Comprehensive Table of Contents matching the 7 chapters of Project_syllabus.md across dedicated pages, plus an exhaustive 33 Curricular Submission Milestones Cross-Reference Directory. | `viii`–`ix` |
| [`09_table_of_figures_and_tables.md`](09_table_of_figures_and_tables.md) | **Table of Figures & Tables** | Complete list of 24 UML/DFD/PERT figures and 19 tables across the dissertation. | `x` |

---

## 2. Institutional Formatting & Typographic Compliance Rules

1. **Mandatory Solid Black Page Border:**
   Every preliminary page includes a solid black border (`stroke: 1pt + black`) offset by `1.5cm` from the sheet boundary (`width: 100% - 1.5cm`, `height: 100% - 1.5cm`).
2. **Binding Margins:**
   Page layout adheres strictly to standard single-sided dissertation binding margins:
   - **Left Margin:** `1.5 inches` (`38.1mm`) to accommodate the physical hardcover binding spine.
   - **Right, Top, and Bottom Margins:** `1.0 inch` (`25.4mm`).
3. **Typography Standard:**
   - **Font Family:** Times New Roman (`"Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"`).
   - **Main Body Text Size:** `12pt`, Justified (`par(justify: true, leading: 0.65em)`).
   - **Major Headings:** `16pt`, Bold.
   - **Tables & Grids:** `10pt` font size with `#styled-table` academic borders.
4. **Pagination Control:**
   - The Cover Page is completely unnumbered.
   - Preliminary pages 2 through 10 use lowercase Roman numerals starting at `ii` (`#counter(page).update(2)`).
   - Main body (Chapter 1 onwards) restarts numbering in Arabic numerals at 1 (`#counter(page).update(1)`).

---

## 3. Directory File Map

```text
Black_Book/00_Preliminary_Pages/
├── 01_title_page.md                   # Cover / Title Page specification & template
├── 02_approved_proforma.md            # Approved Project Proposal Proforma & signature grid
├── 03_certificate.md                  # Bonafide Certificate with Guide & Examiner blocks
├── 04_declaration.md                  # Student Declaration of Originality
├── 05_role_and_responsibility.md      # SDLC 100% individual contribution breakdown
├── 06_abstract.md                     # 354-word academic abstract & keywords
├── 07_acknowledgement.md              # Institutional acknowledgements
├── 08_table_of_contents.md            # 7-chapter TOC & 33 Submission Milestones Directory
├── 09_table_of_figures_and_tables.md  # Complete list of figures and tables
└── README.md                          # Master index and front-matter documentation
```
