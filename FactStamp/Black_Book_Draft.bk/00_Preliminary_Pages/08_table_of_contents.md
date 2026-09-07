# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 08: Table of Contents

---

### Formal Academic Table of Contents Layout

```text
====================================================================================================
                                         TABLE OF CONTENTS
====================================================================================================
Title / Section Caption                                                                    Page No.
====================================================================================================

PRELIMINARY PAGES
  Title / Cover Page ....................................................................        --
  Approved Proforma of Project Proposal .................................................        ii
  Certificate of Authenticated Work .....................................................       iii
  Declaration of Originality ............................................................        iv
  Role and Responsibility Form ..........................................................         v
  Abstract ..............................................................................        vi
  Acknowledgement .......................................................................       vii
  Table of Contents .....................................................................  viii–ix
  Table of Figures and Tables ...........................................................         x

CHAPTER 1: INTRODUCTION .................................................................         1
  1.1 Background ........................................................................         1
      1.1.1 The Proliferation of WhatsApp in India ......................................         1
      1.1.2 The "Dark Social" Blindspot and End-to-End Encryption .......................         2
      1.1.3 Psychological Dynamics of Interpersonal Forwarding ..........................         3
      1.1.4 Asymmetric Viral Velocity of Misinformation .................................         4
      1.1.5 The Centralized Fact-Checking Latency Deficit ...............................         5
      1.1.6 Cognitive and Social Friction of Counter-Narratives .........................         6
      1.1.7 The FactStamp Solution ......................................................         7
  1.2 Objectives ........................................................................         8
  1.3 Purpose, Scope, and Applicability .................................................        10
      1.3.1 Purpose .....................................................................        10
      1.3.2 Scope and Technical Boundaries ..............................................        11
      1.3.3 Applicability Across Stakeholders ...........................................        13
  1.4 Achievements ......................................................................        14
  1.5 Organisation of Report ............................................................        16

CHAPTER 2: SURVEY OF TECHNOLOGIES .......................................................        18
  2.1 Introduction & Survey Methodology .................................................        18
  2.2 Web Architectures for Distributed Verification ....................................        19
  2.3 Frontend Frameworks & Modern Build Toolchains (React 18.3.1 & Vite 5.4.0) .........        21
  2.4 Styling Architectures & Design Systems (Tailwind CSS v4.0.0 & Saffron Sleek OKLCH) .        23
  2.5 Cloud Database Engines & Real-Time Sync (Google Cloud Firestore v12.17.0) ........        25
  2.6 Optical Character Recognition Technologies (Tesseract.js WebAssembly OCR) ........        27
  2.7 Client-Side Graphic Compilation Engines (html-to-image 1.11.13 SVG foreignObject) .        29
  2.8 Text Tokenization & Duplicate Detection (Jaccard Word-Overlap J >= 0.75) ..........        31
  2.9 Distributed Consensus & Reputation Models (Multi-Factor Quorum C = 0.40A+0.30R+0.30S)       33
  2.10 Layered Technology Stack Architecture ............................................        35
  2.11 Master Technology Selection Matrix ...............................................        36

CHAPTER 3: REQUIREMENTS AND ANALYSIS ....................................................        38
  3.1 Problem Definition ................................................................        38
  3.2 Requirements Specification (IEEE Std 830-1998 Compliant) ..........................        40
      3.2.1 Functional Requirements (REQ-1 to REQ-10) ...................................        40
      3.2.2 Non-Functional Requirements (NFR-1 to NFR-5) ................................        43
  3.3 Planning and Scheduling ...........................................................        45
      3.3.1 Work Breakdown Structure (WBS) & Milestones .................................        45
      3.3.2 Program Evaluation and Review Technique (PERT) Critical Path Analysis .......        47
      3.3.3 GANTT Chart Project Execution Timeline ......................................        49
  3.4 Software and Hardware Requirements Specifications .................................        51
  3.5 Preliminary Product Description ...................................................        53
  3.6 Conceptual Models .................................................................        55
      3.6.1 Data Flow Modeling (Level 0 Context, Level 1 Subsystem, Level 2 Detailed DFD)        55
      3.6.2 Use Case Modeling, Actors, and Event Table ..................................        59
      3.6.3 Activity Diagram and Dynamic Control Flow ...................................        62
      3.6.4 State Machine Diagram (Claim Lifecycle) .....................................        64
      3.6.5 Sequence Diagram (Claim Ingestion to Quorum Consensus) ......................        66
      3.6.6 Class Diagram and Static Structural Relationships ...........................        68
      3.6.7 Object Diagram (Instantiated Verification Snapshot) .........................        70
      3.6.8 Package, Component, and Deployment Diagrams .................................        72
      3.6.9 Entity-Relationship (E-R) Conceptual and Logical Model ......................        75

CHAPTER 4: SYSTEM DESIGN ................................................................        78
  4.1 Basic Modules (Comprehensive Decomposition of 8 Core Modules) .....................        78
  4.2 Data Design .......................................................................        83
      4.2.1 Schema Design (Firestore Collections: users, claims, verifications) ........        83
      4.2.2 Data Integrity, Constraints, and Indexing Strategies ........................        87
  4.3 Procedural Design .................................................................        90
      4.3.1 Architectural Logic Diagrams and Process Workflows ..........................        90
      4.3.2 Data Structures and TypeScript Type Interfaces ..............................        92
      4.3.3 Algorithms Design: Jaccard Token Duplicate Detection Engine .................        95
      4.3.4 Algorithms Design: Multi-Factor Weighted Quorum Consensus Engine ............        98
  4.4 User Interface Design (Saffron Sleek Theme, Design Tokens, & Wireframes) ..........       101
  4.5 Security Issues, Anti-Sybil Defense & Declarative Database Rules ..................       106
  4.6 Test Cases Design .................................................................       110

CHAPTER 5: IMPLEMENTATION AND TESTING ...................................................       113
  5.1 Implementation Approaches (Agile Scrum Sprint Realization) ........................       113
  5.2 Coding Details and Code Efficiency ................................................       117
      5.2.1 Code Efficiency & Asymptotic Complexity Analysis ............................       121
  5.3 Testing Approach ..................................................................       124
      5.3.1 Unit Testing (Algorithms, Tokenizers, Normalization) ........................       124
      5.3.2 Integrated Testing (Real-Time Firestore Sync, Auth Lifecycle) ...............       127
      5.3.3 Beta Testing and Mobile Field Evaluation ....................................       129
  5.4 Modifications and Improvements (5 Architectural Evolutions) .......................       131
  5.5 Test Cases Execution Matrix & Validation Results ..................................       134

CHAPTER 6: RESULTS AND DISCUSSION .......................................................       138
  6.1 Test Reports, Empirical Benchmarks & Performance Metrics ..........................       138
      6.1.1 Duplicate Detection Latency and Recall Benchmarks ...........................       138
      6.1.2 Consensus Derivation and Weight Distribution Analysis .......................       140
      6.1.3 Image Processing Throughput and Card Rasterization Times ....................       142
  6.2 User Documentation and Operating Manual ...........................................       144
      6.2.1 Operational Manual with 8 Step-by-Step Screen Layouts .......................       144
      6.2.2 Error Handling, Edge Cases, and Recovery Procedures .........................       151
      6.2.3 Frequently Asked Questions (FAQ) ............................................       153

CHAPTER 7: CONCLUSIONS ..................................................................       155
  7.1 Conclusion ........................................................................       155
      7.1.1 Significance of the System ..................................................       156
  7.2 Limitations of the System .........................................................       158
  7.3 Future Scope of the Project .......................................................       160

REFERENCES & ACADEMIC BIBLIOGRAPHY (IEEE Citation Format) ...............................       163
GLOSSARY & ABBREVIATIONS ................................................................       168
====================================================================================================
```

---

### Curricular Submission Milestones Cross-Reference Index (33 Milestones)

To demonstrate rigorous alignment between periodic academic milestones and the final Black Book dissertation, the table below maps each of the **33 formal course submission deliverables** directly to its corresponding chapter, section, and Typst source package:

| Milestone ID | Course Submission Deliverable Title | Corresponding Black Book Chapter & Section | Source Typst Deliverable Directory | Curricular Status |
| :---: | :--- | :--- | :--- | :---: |
| **M01** | Black Book Initial Pages (Front-Matter) | Preliminary Pages (i–x) | `Black_Book_Initial_Pages/` | **Approved** |
| **M02** | Master Academic Synopsis & Problem Formulation | Chapter 1 & Chapter 3 Overview | `Project Synopsis/` | **Approved** |
| **M03** | Chapter 1: Background, Objectives & Scope | Chapter 1 (1.1, 1.2, 1.3) | `Submission of CHAPTER 1: INTRODUCTION.../` | **Approved** |
| **M04** | Chapter 1: Abstract, Achievements & Report Org | Chapter 1 (Abstract, 1.4, 1.5) | `Submission of ABSTRACT, 1.4 Achievements.../` | **Approved** |
| **M05** | Chapter 2: Comprehensive Survey of Technologies | Chapter 2 (2.1 to 2.11) | `CHAPTER 2: SURVEY OF TECHNOLOGIES/` | **Approved** |
| **M06** | Tri-Chapter Academic Synthesis Report | Chapters 1, 2, and 3 Review | `Submission of 1. INTRODUCTION 2. SURVEY.../` | **Approved** |
| **M07** | Chapter 3: Requirements & Analysis Core | Chapter 3 (3.1, 3.2, 3.3, 3.4) | `Submission of CHAPTER 3: REQUIREMENTS.../` | **Approved** |
| **M08** | Planning, PERT Chart, Event Table & Module 1 Auth | Section 3.3, 3.6.2 & Module 1 | `Submission of 3.3 Planning and Scheduling.../` | **Approved** |
| **M09** | Preliminary Product Description & Workflow | Section 3.5 | `Submission of (3.5 Preliminary Product Description)/` | **Approved** |
| **M10** | Conceptual Models: Data Flow Diagrams (0/1/2) | Section 3.6.1 (DFDs) | `Submission of 3.6 Conceptual Models - Data Flow.../`| **Approved** |
| **M11** | Conceptual Models: Use Case Diagram & Actors | Section 3.6.2 (Use Case) | `Submission of 3.6 Conceptual Models -Use Case.../` | **Approved** |
| **M12** | Conceptual Models: Event Table & Object Diagram | Section 3.6.2 & 3.6.7 | `Submission of 3.6 Conceptual Models -Event Table.../`| **Approved** |
| **M13** | Conceptual Models: Activity & State Machine Diagrams | Section 3.6.3 & 3.6.4 | `Submission of 3.6 Conceptual Models - Activity.../` | **Approved** |
| **M14** | Conceptual Models: Sequence Diagram | Section 3.6.5 (Sequence) | `Submission of 3.6 Conceptual Models - Sequence.../` | **Approved** |
| **M15** | Conceptual Models: E-R Diagram & Class Diagram | Section 3.6.6 & 3.6.9 | `Submission of 3.6 Conceptual Models -E-R.../` | **Approved** |
| **M16** | Conceptual Models: Component Diagram | Section 3.6.8 (Component) | `Submission of 3.6 Conceptual Models - Component.../`| **Approved** |
| **M17** | Conceptual Models: Package & Deployment Diagrams | Section 3.6.8 (Deployment) | `Submission of 3.6 Conceptual Models - Package.../` | **Approved** |
| **M18** | Structural Models & Module 2 Implementation | Section 3.6 & Module 2 | `Submission of ER Diagram, Class Diagram.../` | **Approved** |
| **M19** | GANTT Chart & Firestore Schema Design | Section 3.3.3 & 4.2.1 | `Submission of GANTT chart,4.2 Data Design.../` | **Approved** |
| **M20** | Chapter 4: Basic Modules & Data Dictionary | Section 4.1 & 4.2.1 | `Submission of 4. SYSTEM DESIGN (4.1 Basic.../` | **Approved** |
| **M21** | Data Integrity, Constraints & Security Architecture | Section 4.2.2 & 4.5 | `Submission of Chp 4: 4.2.2 Data Integrity.../` | **Approved** |
| **M22** | User Interface Design & Wireframes | Section 4.4 | `Submission of 4.3 User Interface Design.../` | **Approved** |
| **M23** | Test Cases Design Specification (Draft) | Section 4.6 | `Submission of 4.5 Test Cases Design(Draft)/` | **Approved** |
| **M24** | Module 2: Multimodal Claim Ingestion & Client OCR | Module 2 (Implementation) | `Submission of Module 2/` | **Approved** |
| **M25** | Module 3: Jaccard Token Duplicate Detection Engine | Module 3 (Implementation) | `Submission of Module 3/` | **Approved** |
| **M26** | Module 4: Community Verification Quorum Queue | Module 4 (Implementation) | `Submission of Module 4/` | **Approved** |
| **M27** | Module 5: Multi-Factor Weighted Consensus Engine | Module 5 (Implementation) | `Submission of Module 5/` | **Approved** |
| **M28** | Module 6: WhatsApp-Native Fact Card Generator | Module 6 (Implementation) | `Submission of Module 6/` | **Approved** |
| **M29** | Module 7: Misinformation Analytics Dashboard | Module 7 (Implementation) | `Submission of Module 7/` | **Approved** |
| **M30** | Chapter 5: Core Implementation Deliverable | Chapter 5 (5.1, I/O, DB, Code) | `Submission of Chp 5. IMPLEMENTATION AND TESTING.../`| **Approved** |
| **M31** | Implementation Approach & Code Efficiency | Section 5.1 & 5.2.1 | `Submission of 5.1 Implementation Approach.../` | **Approved** |
| **M32** | Testing Approach (Unit, Integrated, Beta Testing) | Section 5.3 | `Submission of 5.3 Testing Approach/` | **Approved** |
| **M33** | Modifications, Improvements & User Documentation | Section 5.4 & 6.2 | `Submission of 5.4 Modifications and Improvements.../`| **Approved** |
| **M34** | Chapter 7: Conclusions, Limitations & References | Chapter 7 & References | `Submission of 7. CONCLUSION.../` | **Approved** |

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGES 8–9: TABLE OF CONTENTS
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(8)

#align(center)[
  #text(size: 16pt, weight: "bold")[TABLE OF CONTENTS]
]

#v(14pt)

#outline(
  title: none,
  indent: 1.5em,
  depth: 3
)

#pagebreak()
```
