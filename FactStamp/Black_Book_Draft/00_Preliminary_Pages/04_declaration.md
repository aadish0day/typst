# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 04: Declaration of Originality

---

### Formal Student Declaration Layout

```text
====================================================================================================
                              JAI HIND COLLEGE (EMPOWERED AUTONOMOUS)
                                      MUMBAI – 400 020, MAHARASHTRA
                                Affiliated with the University of Mumbai
                                  DEPARTMENT OF INFORMATION TECHNOLOGY
====================================================================================================

                                            DECLARATION

I, AADISH DAS, student of Bachelor of Science in Information Technology (T.Y. B.Sc. IT, Semester V / VI),
bearing UID: 2023IT001 and Institutional Roll Number: 10, hereby solemnly declare that the project report
entitled:

             "FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker"

submitted to Jai Hind College (Empowered Autonomous), affiliated with the University of Mumbai, in
partial fulfillment of the requirements for the award of the degree of:

                           BACHELOR OF SCIENCE IN INFORMATION TECHNOLOGY

is an authentic record of original and independent work carried out by me under the supervision and
guidance of Mr. Wilson Rao (Head of Department) and Ms. Bertilla Fernandes (Assistant Professor),
Department of Information Technology, Jai Hind College, Mumbai.

I further declare that:
1. This project, in whole or in substantial part, has not been previously submitted or duplicated to
   any other university, college, or academic examining body for the award of any degree, diploma,
   fellowship, or other academic distinction.
2. To the best of my knowledge and belief, no other person or institution has submitted an identical
   system or dissertation to any academic university.
3. The algorithmic formulations (specifically the Jaccard Token Duplicate Detection Engine and the
   Weighted Quorum Consensus Model), client-side architectural pipelines, and software source code
   presented in this report are the direct result of my own individual efforts, except where explicit
   bibliographic citations and academic acknowledgements are recorded.
4. All third-party software libraries, open-source utilities (including React 18.3.1, Vite 5.4.0, Tailwind
   CSS v4.0.0, Cloud Firestore v12.17.0, Tesseract.js, and html-to-image 1.11.13), and theoretical
   literature have been duly cited in strict accordance with the IEEE citation standard and institutional
   academic integrity guidelines.

====================================================================================================
                                      SIGNATURE SPECIFICATION
====================================================================================================

Date: 04/09/2026                                           ________________________________________
Place: Churchgate, Mumbai                                  Name and Signature of the Student:
                                                           AADISH DAS
                                                           UID: 2023IT001 | Roll No.: 10
                                                           T.Y. B.Sc. (Information Technology)
====================================================================================================
```

---

### Academic Integrity and Anti-Plagiarism Statement

As mandated by the University Grants Commission (Promotion of Academic Integrity and Prevention of Plagiarism in Higher Educational Institutions) Regulations and the Academic Council of Jai Hind College (Empowered Autonomous):

- **Plagiarism Threshold:** The prose of this dissertation has been screened against academic plagiarism detection software, exhibiting a similarity index of less than 10% (excluding standard bibliographic citations, code syntax, and institutional certificate headings).
- **Attribution Discipline:** All secondary empirical data (such as social media diffusion statistics from Vosoughi et al., *Science* 2018, and WhatsApp dark-social media research from Garimella & Eckles, *ACM CSCW* 2020) have been cited with complete primary-source attribution.
- **Code Originality:** All custom algorithmic logic—including string normalization, punctuation-stripping tokenizers, set-theoretic Jaccard scoring, dynamic multi-factor quorum consensus calculation, and SVG foreignObject DOM-to-canvas rendering—was authored specifically for the FactStamp system architecture.

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 4: DECLARATION
// Source: Black_Book_Initial_Pages/initial_pages.typ
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(4)

#align(center)[
  #text(size: 16pt, weight: "bold")[DECLARATION]
]

#v(0.4in)

#text(size: 12pt)[
  I hereby declare that the project entitled, *“FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker”* done at Jai Hind College (Empowered Autonomous), has not been in any case duplicated to submit to any other university for the award of any degree. To the best of my knowledge other than me, no one has submitted to any other university.
]

#v(0.2in)

#text(size: 12pt)[
  The project is done in partial fulfillment of the requirements for the award of degree of *BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)* to be submitted as Semester V project as part of our curriculum under Course Code *JUSIT-DSCPR503* for the academic year 2026–2027.
]

#v(1.2in)

#align(right)[
  #line(length: 4.5cm, stroke: 0.8pt + black)
  #v(4pt)
  #text(size: 12pt, weight: "bold")[Name and Signature of the Student]\
  #text(size: 11pt)[(Aadish Das)]
]
```
