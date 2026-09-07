# FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker

## Preliminary Pages — Document 09: Table of Figures and Tables

---

### Formal Academic Table of Figures Layout

```text
====================================================================================================
                                          LIST OF FIGURES
====================================================================================================
Figure No.  Figure Title / Description                                                     Page No.
====================================================================================================
Figure 1.1  End-to-End System Architecture & Operational Workflow Diagram ...............        11
Figure 1.2  Dissertation Structural Progression and Chapter Lifecycle ..................        16
Figure 2.1  Decoupled Serverless SPA with BaaS Architectural Topology ...................        20
Figure 2.2  Layered Technology Stack Architecture (Edge to Data Persistence) ...........        35
Figure 3.1  Work Breakdown Structure (WBS) & Milestone Decomposition ....................        46
Figure 3.2  Program Evaluation and Review Technique (PERT) Critical Path Network .......        48
Figure 3.3  Project Development Schedule (GANTT Chart Timeline) .........................        50
Figure 3.4  Data Flow Diagram (DFD) — Level 0 Context Diagram ...........................        56
Figure 3.5  Data Flow Diagram (DFD) — Level 1 Subsystem Decomposition ...................        57
Figure 3.6  Data Flow Diagram (DFD) — Level 2 Detailed Process Flow .....................        58
Figure 3.7  Use Case Diagram for FactStamp Multi-Stakeholder Platform ...................        60
Figure 3.8  Activity Diagram for Ingestion, Verification, and Consensus Workflows .......        63
Figure 3.9  State Machine Diagram for Claim Verification Lifecycle States ...............        65
Figure 3.10 Sequence Diagram for Multimodal Ingestion and Quorum Verification ...........        67
Figure 3.11 Class Diagram of FactStamp Core Domain Entities and Contexts ................        69
Figure 3.12 Object Diagram Representing Instantiated Verification Snapshot ..............        71
Figure 3.13 Component Diagram of Client and Cloud Subsystems ............................        73
Figure 3.14 Package and Deployment Diagram of Serverless Edge Topology ..................        74
Figure 3.15 Entity-Relationship (E-R) Conceptual and Logical Data Model .................        76
Figure 4.1  Subsystem Modularity & Inter-Module Communication Pipeline ..................        82
Figure 4.2  Jaccard Duplicate Detection Flowchart ($J \ge 0.75$) .........................        96
Figure 4.3  Multi-Factor Quorum Consensus Derivation Logic ($C = 0.40A + 0.30R + 0.30S$) .        99
Figure 4.4  Saffron Sleek Design System Wireframe — Homepage & Ingestion Workbench .....       103
Figure 4.5  Saffron Sleek Design System Wireframe — Verifier Quorum Review Interface ...       104
Figure 4.6  Saffron Sleek Design System Wireframe — 1080×1080px Fact Card Layout ........       105
Figure 4.7  Security Rule Architecture & Anti-Self-Verification Boundary Lock ..........       108
Figure 5.1  Agile Scrum 4-Sprint Burndown and Feature Velocity Trajectory ..............       115
Figure 5.2  Client-Side Image Downsampling and WASM OCR Execution Flow .................       119
Figure 5.3  SVG <foreignObject> DOM-to-Canvas High-DPI Card Rasterization Pipeline ......       120
Figure 6.1  Empirical Duplicate Detection Latency Distribution (P50, P90, P95) ..........       139
Figure 6.2  Consensus Confidence Weight Distribution Across 500 Test Claims ............       141
Figure 6.3  Fact Card Compilation Latency Benchmark Across Device Form-Factors ..........       143
Figure 6.4  User Documentation Screen 1: Unauthenticated Homepage & Claim Lookup ........       145
Figure 6.5  User Documentation Screen 2: Multimodal Claim Submission & OCR Preview ......       146
Figure 6.6  User Documentation Screen 3: Active Quorum Verification Queue ...............       147
Figure 6.7  User Documentation Screen 4: Verifier Evaluation Workbench & Citation Input .       148
Figure 6.8  User Documentation Screen 5: Final Claim Detail & 1080×1080px Card Download .       149
====================================================================================================
```

---

### Formal Academic List of Tables Layout

```text
====================================================================================================
                                           LIST OF TABLES
====================================================================================================
Table No.   Table Title / Description                                                      Page No.
====================================================================================================
Table 1.1   FactStamp Core Engineering & Algorithmic Objectives Matrix ..................         9
Table 1.2   System Scope Dimension Matrix and Technical Boundaries ......................        12
Table 1.3   Empirical System Achievements and Prior Art Comparison ......................        15
Table 1.4   Chapter Inter-Dependency Matrix Across Dissertation Lifecycle ..............        17
Table 2.1   Comparative Evaluation of Web Application Architectures .....................        20
Table 2.2   Comparative Benchmark of Modern Reactive Frontend Frameworks ................        22
Table 2.3   Comparative Analysis of Modern Styling Engines & Color Models ...............        24
Table 2.4   Comparative Evaluation of Cloud Database Engines & Real-Time Sync ...........        26
Table 2.5   Comparative Feature Matrix of Optical Character Recognition (OCR) Engines ...        28
Table 2.6   Comparative Evaluation of DOM-to-Image Graphic Compilation Engines ..........        30
Table 2.7   Comparative Evaluation of Text Tokenization & Similarity Algorithms .........        32
Table 2.8   Comparative Benchmark of Distributed Consensus & Reputation Paradigms .......        34
Table 2.9   Master Technology Selection Matrix & Architectural Justifications ...........        37
Table 3.1   IEEE Std 830-1998 Functional Requirements Specification (REQ-1 to REQ-10) ...        41
Table 3.2   Non-Functional Requirements Specification (NFR-1 to NFR-5) ..................        44
Table 3.3   Hardware and Software Operational Environment Specifications ................        52
Table 3.4   System Event Table for Actors, Triggers, Use Cases, and Responses ...........        61
Table 4.1   Comprehensive Decomposition of 8 Core Modules ...............................        79
Table 4.2   Cloud Firestore Database Collections & Schema Data Dictionary ...............        84
Table 4.3   Algorithmic Verdict Classification & Consensus Confidence Matrix ............       100
Table 4.4   Saffron Sleek Design System OKLCH Color Tokens & APCA Contrast Values .......       102
Table 4.5   Formal Test Cases Design Suite Specification ................................       111
Table 5.1   Agile Scrum Sprint Schedule and Module Delivery Milestones ...................       114
Table 5.2   Asymptotic Time and Space Complexity of Core Subsystems .....................       122
Table 5.3   Summary of 5 Major Architectural Modifications and Improvements .............       132
Table 5.4   Test Cases Execution Matrix & Empirical Validation Results ..................       135
Table 6.1   Duplicate Detection Query Latency Benchmarks by Claim Length ................       139
Table 6.2   Consensus Confidence Accuracy and Error Margin Analysis .....................       141
Table 6.3   DOM Rasterization Throughput Across Browser Rendering Engines ...............       143
====================================================================================================
```

---

### Technical Figure & Diagram Implementation Specifications

In compliance with `Rules/Diagram-rules.md` and university submission standards:

1. **UML Diagrams (Figures 3.7 to 3.15, Figures 4.1 to 4.3):** Generated using **PlantUML** (`.puml` → `.svg`) utilizing modern strict UML styling (`skinparam style strictuml`, clean monochrome/high-contrast palette, bold typography, 2.5px solid borders, and full-width responsive scaling).
2. **Data Flow Diagrams (Figures 3.4, 3.5, 3.6):** Rendered using **Graphviz** (`dot` → `.svg`) with standardized Gane-Sarson / Yourdon notations for external entities, processes, and data stores.
3. **Project Management Charts (Figures 3.1, 3.2, 3.3):** Compiled using vector charting tools (Mermaid / Graphviz / Typst native canvas) detailing critical paths, slack times, and sprint schedules.
4. **Tables (Tables 1.1 to 6.3):** Styled using Typst's `#styled-table` academic template featuring alternating row fills (`rgb("FAFAFA")`), bold headers with double horizontal borders (`1.2pt + black`), and subtle cell dividers (`0.4pt + luma(180)`).

---

### Typst Source Code Implementation Template

```typst
// ==============================================================================
// PAGE 10: LIST OF FIGURES AND TABLES
// ==============================================================================
#pagebreak()
#set page(numbering: "i")
#counter(page).update(10)

#align(center)[
  #text(size: 16pt, weight: "bold")[LIST OF FIGURES]
]

#v(10pt)

#table(
  columns: (1.0in, 1fr, 0.7in),
  stroke: none,
  inset: (x: 4pt, y: 4pt),
  [*Fig. 1.1*], [End-to-End System Architecture & Operational Workflow Diagram], [11],
  [*Fig. 1.2*], [Dissertation Structural Progression and Chapter Lifecycle], [16],
  [*Fig. 2.1*], [Decoupled Serverless SPA with BaaS Architectural Topology], [20],
  [*Fig. 2.2*], [Layered Technology Stack Architecture (Edge to Data Persistence)], [35],
  [*Fig. 3.1*], [Work Breakdown Structure (WBS) & Milestone Decomposition], [46],
  [*Fig. 3.2*], [Program Evaluation and Review Technique (PERT) Network Chart], [48],
  [*Fig. 3.3*], [Project Development Schedule (GANTT Chart)], [50],
  [*Fig. 3.4*], [Data Flow Diagram (DFD) — Level 0 Context Diagram], [56],
  [*Fig. 3.5*], [Data Flow Diagram (DFD) — Level 1 Subsystem Decomposition], [57],
  [*Fig. 3.6*], [Data Flow Diagram (DFD) — Level 2 Detailed Process Flow], [58],
  [*Fig. 3.7*], [Use Case Diagram for FactStamp Platform], [60],
  [*Fig. 3.8*], [Activity Diagram for Claim Ingestion, Verification, and Consensus], [63],
  [*Fig. 3.9*], [State Machine Diagram for Claim Lifecycle States], [65],
  [*Fig. 3.10*], [Sequence Diagram for Multimodal Ingestion and Quorum Consensus], [67],
  [*Fig. 3.11*], [Class Diagram of FactStamp Core Domain Models and Contexts], [69],
  [*Fig. 3.12*], [Object Diagram Representing Instantiated Verification Snapshot], [71],
  [*Fig. 3.13*], [Component Diagram of Client and Cloud Subsystems], [73],
  [*Fig. 3.14*], [Package and Deployment Diagram of Serverless Edge Topology], [74],
  [*Fig. 3.15*], [Entity-Relationship (E-R) Conceptual and Logical Data Model], [76]
)

#v(16pt)

#align(center)[
  #text(size: 16pt, weight: "bold")[LIST OF TABLES]
]

#v(10pt)

#table(
  columns: (1.0in, 1fr, 0.7in),
  stroke: none,
  inset: (x: 4pt, y: 4pt),
  [*Table 1.1*], [FactStamp Core Engineering & Algorithmic Objectives Matrix], [9],
  [*Table 1.2*], [System Scope Dimension Matrix and Technical Boundaries], [12],
  [*Table 1.3*], [Empirical System Achievements and Prior Art Comparison], [15],
  [*Table 1.4*], [Chapter Inter-Dependency Matrix Across Dissertation Lifecycle], [17],
  [*Table 2.1*], [Comparative Evaluation of Web Application Architectures], [20],
  [*Table 2.2*], [Comparative Benchmark of Modern Reactive Frontend Frameworks], [22],
  [*Table 2.3*], [Comparative Analysis of Modern Styling Engines & Color Models], [24],
  [*Table 2.4*], [Comparative Evaluation of Cloud Database Engines & Real-Time Sync], [26],
  [*Table 2.5*], [Comparative Feature Matrix of Optical Character Recognition (OCR)], [28],
  [*Table 2.6*], [Comparative Evaluation of DOM-to-Image Graphic Compilation Engines], [30],
  [*Table 2.7*], [Comparative Evaluation of Text Tokenization & Similarity Algorithms], [32],
  [*Table 2.8*], [Comparative Benchmark of Distributed Consensus & Reputation Paradigms], [34],
  [*Table 2.9*], [Master Technology Selection Matrix & Architectural Justifications], [37]
)
```
