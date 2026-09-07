# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 03: Certificate of Authenticated Work

---

### Formal Institutional Certificate Layout

```text
====================================================================================================
                              JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)
                                      MUMBAI – 400 020, MAHARASHTRA
                                Affiliated with the University of Mumbai
                                  DEPARTMENT OF INFORMATION TECHNOLOGY
====================================================================================================

                                       [COLLEGE EMBLEM / LOGO]

                                             CERTIFICATE
                                       OF AUTHENTICATED WORK

This is to certify that the project entitled:

             "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"

is a bonafide record of original academic research and technical system engineering carried out by:

                                              AADISH DAS
                                    UID / Roll No.: 2023IT001 / 10

submitted in partial fulfillment of the academic requirements for the award of the degree of:

                           BACHELOR OF SCIENCE IN INFORMATION TECHNOLOGY
                                            (B.Sc. IT)

under the Department of Information Technology at Jai Hind College (Empowered Autonomous), Churchgate,
Mumbai, affiliated with the University of Mumbai, during the Academic Year 2026–2027.

It is further certified that the candidate has satisfactorily completed all experimental investigations,
algorithmic designs, software implementations, and dissertation documentation as prescribed by the
official University curriculum under Course Code JUSIT-DSCPR503 (Project Dissertation and Implementation).

====================================================================================================
                                      SIGNATURE SPECIFICATION
====================================================================================================

______________________________                             ______________________________
MR. WILSON RAO &                                           MR. WILSON RAO
MS. BERTILLA FERNANDES                                     Project Coordinator / HOD
Internal Project Guides                                    Dept. of Information Technology
Department of Information Technology                       Jai Hind College (Autonomous)


                                 ______________________________
                                        EXTERNAL EXAMINER
                                 Appointed by University of Mumbai /
                                      College Board of Studies


Date: 04/09/2026                                           [ INSTITUTIONAL SEAL ]
Place: Mumbai                                              Jai Hind College (Empowered Autonomous)
====================================================================================================
```

---

### Authentication Criteria & Examination Checklist

The project examination committee evaluates the authenticated work across four core dimensions:

1. **System Authenticity & Originality:** Verification that the platform architecture, client-side WebAssembly OCR pipeline, Jaccard similarity engine, and `html-to-image` 1.11.13 card generation logic are the student's original engineering work and not duplicated from commercial repositories or prior submissions.
2. **Software Lifecycle Rigor:** Evidence of disciplined execution across the Agile Scrum development lifecycle, including sprint burndown metrics, TypeScript type contracts, and comprehensive unit/integration test matrices.
3. **Mathematical & Algorithmic Soundness:** Validation of the set-theoretic duplicate suppression threshold ($J(A, B) \ge 0.75$) and the multi-factor weighted consensus formula ($C = 0.40 A + 0.30 R + 0.30 S$).
4. **Institutional Compliance:** Complete compliance with the University of Mumbai and Jai Hind College Empowered Autonomous curriculum standards for capstone project dissertations (Course `JUSIT-DSCPR503`).

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 3: CERTIFICATE OF AUTHENTICATED WORK
// Source: Black_Book_Initial_Pages/initial_pages.typ
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(3)

#align(center)[
  #text(size: 14pt, weight: "bold")[JAI HIND COLLEGE]\
  #text(size: 11pt, style: "italic", weight: "bold")[(Empowered Autonomous)]\
  #v(2pt)
  #text(size: 10.5pt)[MUMBAI, 400020 MAHARASHTRA]\
  #v(4pt)
  #text(size: 14pt, weight: "bold")[DEPARTMENT OF INFORMATION TECHNOLOGY]

  #v(0.2in)
  #image("assets/college_logo.jpg", width: 1.8cm)

  #v(0.25in)
  #text(size: 16pt, weight: "bold")[CERTIFICATE]
]

#v(0.25in)
#text(size: 12pt)[
  This is to certify that the project entitled, *“FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker”*, is bonafide work of *Aadish Das* bearing UID / Roll No. : *2023IT001 / 10* submitted in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE in INFORMATION TECHNOLOGY* from Jai Hind College Empowered Autonomous (University of Mumbai).
]

#v(0.6in)

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [*Internal Guides*\
  Mr. Wilson Rao & Ms. Bertilla Fernandes],
  [*Coordinator*\
  Mr. Wilson Rao],
)

#v(0.6in)
#align(center)[
  #text(weight: "bold")[External Examiner]
]

#v(0.6in)
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [*Date:* #datetime.today().display("[day]/[month]/[year]")], [*College Seal*],
)
```
