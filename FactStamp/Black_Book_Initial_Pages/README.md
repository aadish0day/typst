# Black Book Initial Pages Template

Extracted from: `Updated Final Black book Template for initital pages.docx`  
Institution: **Jai Hind College (Empowered Autonomous), Mumbai**  
Department: **Department of Information Technology**  
Degree: **Bachelor of Science (Information Technology)**  

---

## 1. Document Specifications & Setup

| Parameter | Specification | Typst Implementation |
| :--- | :--- | :--- |
| **Document Type** | Preliminary Pages for Final Black Book Project Dissertation | — |
| **Paper Size** | A4 (`210mm` × `297mm` / `8.27in` × `11.69in`) | `paper: "a4"` |
| **Margins (Page 1)** | Top: `1.25 in`, Bottom: `0.83 in`, Left: `1.18 in`, Right: `1.18 in` | `margin: (...)` |
| **Margins (Pages 2–4)** | Top: `1.31 in`, Bottom: `0.83 in`, Left: `0.98 in`, Right: `0.98 in` | `margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in)` |
| **Page Border** | **Mandatory** solid black border (`stroke: 1pt + black`) | `rect(width: 100% - 1.5cm, height: 100% - 1.5cm, stroke: 1pt + black)` |
| **Primary Font** | **Times New Roman** (with cross-platform serif fallbacks) | `font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif")` |
| **Headings (Level 1)** | **16pt**, **Bold** | `#show heading.where(level: 1): set text(size: 16pt, weight: "bold")` |
| **Subheadings (Level 2)**| **14pt**, **Bold** | `#show heading.where(level: 2): set text(size: 14pt, weight: "bold")` |
| **Sub-subheadings (Level 3)** | **13pt**, **Bold** | `#show heading.where(level: 3): set text(size: 13pt, weight: "bold")` |
| **Content / Body Text**| **12pt**, **Justified**, `leading: 0.65em`–`0.7em` | `#set text(size: 12pt)` & `#set par(justify: true)` |
| **New Topic on New Page** | **Mandatory**: Every new topic/section starts on a new page | `#pagebreak()` / `#show heading.where(level: 1): it => { pagebreak(weak: true); it }` |
| **Embedded Logo** | Jai Hind College Emblem (`assets/college_logo.jpg`) | `#image("assets/college_logo.jpg", ...)` |

---

## 2. Page-by-Page Extracted Content

---

### Page 1: Title / Cover Page

- **Running Header**: *None*
- **Running Footer**: `1`
- **Layout Alignment**: Centered title block, left-aligned guidance & department block, centered footer year.

#### Content:

```markdown
[Enter your Project Name]
```
*(Font: 16pt–18pt, Bold, Centered)*

```markdown
A Project Report
Submitted in partial fulfillment of the
Requirements for the award of the Degree
of
BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)
```
*(Lines 1 & 3: Bold, 12pt–14pt; Line 2: Regular, 12pt; Centered)*

```markdown
By
Name of Student
UID / Roll No.
```
*(`By`: Bold, 12pt; `Name` & `UID`: Regular, 14pt; Centered)*

```markdown
Under the esteemed guidance of
Mr. Wilson Rao and Ms. Bertilla Fernandes
```
*(Guidance label & Guide names: Centered, All Bold, 12pt–13pt)*

#### Emblem:
![Jai Hind College Logo](assets/college_logo.jpg)  
*(Placed centered above the department block)*

```markdown
DEPARTMENT
OF
INFORMATION TECHNOLOGY

JAI HIND COLLEGE (Empowered Autonomous)

MUMBAI,
400020
MAHARASHTRA
2026-27
```
*(Department & College: Bold, 12pt–13pt; City & Year: Bold, 12pt, Centered stacked)*

---

### Page 2: Certificate of Approval

- **Running Header**: `JAI HIND COLLEGE` *(Centered, Uppercase)*
- **Running Footer**: `2`
- **Page Transition**: **Mandatory Pagebreak** (Starts on a new page)
- **Institutional Heading & Subheadings**:
  - `(Empowered Autonomous)` *(Italic, 12pt, Centered)*
  - `MUMBAI, 400020 MAHARASHTRA` *(11pt–12pt, Centered)*
  - `DEPARTMENT OF INFORMATION TECHNOLOGY` *(Subheading: Bold, 14pt, Centered)*
  - Logo: ![Jai Hind College Logo](assets/college_logo.jpg) *(Centered)*
- **Document Title**: **`CERTIFICATE`** *(Heading 1: Bold, 16pt, Centered, Underlined or Spaced)*

#### Body Text *(Content: Justified, 12pt, Times New Roman)*:

> This is to certify that the project entitled, **“Project Name”**, is bonafied work of **Student Name** bearing UID / Roll No. : **UID/ roll no.** submitted in partial fulfillment of the requirements for the award of degree of BACHELOR OF SCIENCE in INFORMATION TECHNOLOGY from Jai Hind College Empowered Autonomous (University of Mumbai).

#### Signature Block *(12pt–14pt, Bold)*:

| Left Column | Right Column |
| :--- | :--- |
| **Internal Guide** | **Coordinator** |
| *(Signature space)* | *(Signature space)* |
| <br><br> | <br><br> |
| **External Examiner** *(Centered across page)* | |
| *(Signature space)* | |
| <br><br> | <br><br> |
| **Date:** | **College Seal** |

---

### Page 3: Declaration

- **Running Header**: `DECLARATION` *(Centered, Uppercase)*
- **Running Footer**: `3`
- **Page Transition**: **Mandatory Pagebreak** (Starts on a new page)
- **Document Title**: `DECLARATION` *(Heading 1: Bold, 16pt, Centered)*

#### Body Text *(Content: Justified, 12pt, Times New Roman)*:

> I hereby declare that the project entitled, **“Project Name”** done at Jai Hind College (Empowered Autonomous), has not been in any case duplicated to submit to any other university for the award of any degree. To the best of my knowledge other than me, no one has submitted to any other university.
>
> The project is done in partial fulfillment of the requirements for the award of degree of BACHELOR OF SCIENCE (INFORMATIONTECHNOLOGY) to be submitted as Semester V project as part of our curriculum.

#### Sign-off *(Right-aligned, Bold, 12pt–14pt)*:

```markdown
Name and Signature of the Student
```

---

### Page 4: Acknowledgement

- **Running Header**: `ACKNOWLEDGEMENT` *(Centered, Uppercase)*
- **Running Footer**: `4`
- **Page Transition**: **Mandatory Pagebreak** (Starts on a new page)
- **Document Title**: `ACKNOWLEDGEMENT` *(Heading 1: Bold, 16pt, Centered)*

#### Body Text *(Content: Justified, 12pt, Times New Roman)*:

> I am extremely grateful for the guidance of our Head of Department (Information Technology & Software Development) **Mr. Wilson Rao**. Sir had great involvement in making sure my project is a well-rounded and a flawless system by constantly guiding us till the completion of our project work by providing all the necessary information for developing a good system.
>
> I would like to express immense gratitude to the people who have helped me throughout the course of my project. I am grateful to **Prof. Ms. Bertilla Fernandes** for her constant encouragement and support.
>
> I would also like to thank all of my friends and my seniors who supported and helped me in completing the project, where they all had their own interesting takes on the technology stack, and the own interesting ideas on how to finesse the system even further. I would also like to thank my family for their constant support and encouragement.

---

## 3. FactStamp Project Mapping

When generating the actual initial pages for **FactStamp**, replace the template placeholders as follows:

| Template Placeholder | Replacement Value |
| :--- | :--- |
| `[Enter your Project Name]` / `“Project Name”` | **FactStamp** |
| `Name of Student` / `Student Name` | Student Name (Aadish ...) |
| `UID / Roll No.` | Student UID / Roll Number |
| Guide 1 | **Mr. Wilson Rao** (HOD, IT & Software Development) |
| Guide 2 | **Prof. Ms. Bertilla Fernandes** |
| Academic Year | **2026-27** |
| Semester | **Semester V** / **Semester VI** |

---

## 4. Extracted Assets

- `assets/college_logo.jpg` — Jai Hind College Emblem extracted directly from docx media.
- `assets/image1.jpg` — Original extracted JPEG file.
