# FactStamp — Black Book Master Dissertation Draft

> **Course Code:** `JUSIT-DSCPR503` (*Project Dissertation and Implementation*)  
> **Degree:** Bachelor of Science in Information Technology (B.Sc. IT) — Semester V & VI  
> **Institution:** Department of Information Technology, Jai Hind College (Empowered Autonomous), Mumbai  
> **Affiliation:** University of Mumbai, Churchgate, Mumbai – 400 020  
> **Candidate:** Aadish Das (UID: `2023IT001` / Roll No: `10`)  
> **Project Guides:** Mr. Wilson Rao (Head of Department) & Ms. Bertilla Fernandes (Assistant Professor)  
> **Academic Year:** 2026–2027  
> **Repository Status:** Complete Master Draft Synchronized across all 7 Chapters, Front-Matter, and Back-Matter  

---

## Executive Summary

**FactStamp** is an open-source, community-powered misinformation fact-checking platform engineered specifically to combat the virulent transmission of fake news, doctored quotes, financial scams, and dangerous medical panaceas circulating within encrypted peer-to-peer messaging networks ("dark social"), primarily WhatsApp in India. 

Operating under the strict privacy constraints of End-to-End Encryption (E2EE), FactStamp bridges the fatal latency gap between sensational forwarded hoaxes and slow journalistic debunks. It achieves this through a novel socio-technical paradigm uniting:
1. **Sub-85ms Token-Level Jaccard Duplicate Suppression ($J \ge 0.75$):** Eliminates redundant human labor by routing recurring viral forwards directly to existing verified verdicts.
2. **Sybil-Resilient Multi-Factor Quorum Consensus ($N \ge 3$):** Mathematically combines agreement ratio ($A \times 40\%$), verifier reputation ($R \times 30\%$), and external source domain authority ($S \times 30\%$).
3. **Client-Side Visual Counter-Artifact Generation:** Compiles high-resolution $1080 \times 1080\text{px}$ square PNG fact-check cards in sub-650ms via `html-to-image` using browser-native SVG `<foreignObject>` canvas rasterization, perfectly resolving OKLCH CSS Color Level 4 rendering crashes.
4. **Accessible Perceptual Contrast Algorithm (APCA) Compliance:** Guarantees $|L^c| \ge 75$ body text contrast under harsh ambient sunlight with dual-encoded color-blind safe visual stamps.
5. **Zero-Cost Serverless Architecture:** Offloads heavy compute (HTML5 Canvas JPEG compression $< 700\text{ KB}$, Tesseract.js WASM OCR, and PNG rasterization) directly to client browser runtimes, operating comfortably within Google Cloud Firestore's free Spark tier ($16.9\%$ read and $9.1\%$ write quota utilization under 1,000 DAU).

---

## 🗂️ Master Chapter & Directory Inventory

The dissertation follows the official University of Mumbai syllabus structure (`Project_syllabus.md` for Course `JUSIT-DSCPR503`):

| Directory | Chapter / Section Title | Syllabus Reference | Files Count | Key Scope & Technical Content |
| :--- | :--- | :---: | :---: | :--- |
| [`00_Preliminary_Pages/`](./00_Preliminary_Pages/) | **Preliminary Front-Matter Pages** | § 1.1 | 10 files | Title page, Approved Proforma (`ii`), Certificate of Authenticated Work (`iii`), Declaration (`iv`), Role and Responsibility Form (`v`), Abstract (`vi`), Acknowledgement (`vii`), Table of Contents (`viii`–`ix`), Table of Figures & Tables (`x`). |
| [`01_Introduction/`](./01_Introduction/) | **CHAPTER 1: INTRODUCTION** | § 1 | 6 files | Background (1.1), Objectives REQ-1–REQ-8 (1.2), Purpose, Scope, and Applicability (1.3), Achievements (1.4), Organisation of Report (1.5). |
| [`02_Survey_of_Technologies/`](./02_Survey_of_Technologies/) | **CHAPTER 2: SURVEY OF TECHNOLOGIES** | § 2 | 9 files | Comparative analysis of architectures (2.1), Frontend frameworks (2.2), Styling systems (2.3), Cloud databases (2.4), OCR engines (2.5), Card export engines (2.6), Consensus algorithms (2.7), Technology selection matrix (2.8). |
| [`03_Requirements_and_Analysis/`](./03_Requirements_and_Analysis/) | **CHAPTER 3: REQUIREMENTS AND ANALYSIS** | § 3 | 7 files | Problem definition (3.1), IEEE Std 830-1998 SRS (3.2), Planning, PERT & WBS (3.3), Hardware/Software requirements (3.4), Preliminary product description (3.5), Conceptual models (3.6: DFD L0/L1/L2, Use Case, ER, Class, Sequence, Activity, State, Object, Event Table). |
| [`04_System_Design/`](./04_System_Design/) | **CHAPTER 4: SYSTEM DESIGN** | § 4 | 7 files | 8 Core modules (4.1), Data design & Firestore NoSQL schemas (4.2), Procedural logic & Big-$O$ algorithms (4.3), Saffron Sleek UI design (4.4), Security issues & anti-Sybil defense (4.5), Test cases design TC-01–TC-10 (4.6). |
| [`05_Implementation_and_Testing/`](./05_Implementation_and_Testing/) | **CHAPTER 5: IMPLEMENTATION AND TESTING** | § 5 | 6 files | Client-first edge execution model (5.1), Coding details & formal asymptotic complexity proofs (5.2), ISO/IEC/IEEE 29119 testing approach (5.3: Unit, Integration, 25-User Beta trials), `html-to-image` SVG `<foreignObject>` migration (5.4), Test cases execution matrix (5.5). |
| [`06_Results_and_Discussion/`](./06_Results_and_Discussion/) | **CHAPTER 6: RESULTS AND DISCUSSION** | § 6 | 3 files | Test reports & empirical benchmarks across 4 hardware tiers, Jaccard sweeps, APCA matrix, 25-user student peer trial metrics ($N=25$, 84.2 SUS score) (6.1), Persona-driven user manuals for Submitter, Verifier, and Admin with 5 ASCII layouts (6.2). |
| [`07_Conclusions/`](./07_Conclusions/) | **CHAPTER 7: CONCLUSIONS** | § 7 | 4 files | Conclusion & societal significance (7.1), Limitations: cold-start latency, WhatsApp JPEG mold, volunteer fatigue, multilingual gap (7.2), Future scope: WebGPU SLMs, ClaimReview JSON-LD, PWA offline sync, Whisper.wasm, IndicBERT (7.3). |
| [`08_References_and_Glossary/`](./08_References_and_Glossary/) | **REFERENCES & GLOSSARY** | Back-Matter | 3 files | 34 IEEE-formatted academic references across 7 domains, comprehensive 30+ entry technical glossary. |

---

## 📦 Master Inventory of Compiled Typst Submissions (33 Deliverables)

All 33 incremental course deliverables compiled during the academic year are preserved and cross-referenced below:

| # | Submission Title / Course Phase | Source Typst Code (`.typ`) | Compiled PDF Artifact (`.pdf`) |
| :---: | :--- | :--- | :--- |
| **1** | Chp 5.4 Modifications & Chp 6.1 User Documentation | [`modifications_improvements_and_user_documentation.typ`](../Submission%20of%205.4%20Modifications%20and%20Improvements%2C%206.1%20User%20Documentation%28User%20manual%20with%20screen%20Layouts%29/modifications_improvements_and_user_documentation.typ) | [`modifications_improvements_and_user_documentation.pdf`](../Submission%20of%205.4%20Modifications%20and%20Improvements%2C%206.1%20User%20Documentation%28User%20manual%20with%20screen%20Layouts%29/modifications_improvements_and_user_documentation.pdf) |
| **2** | Chp 5.1 Project Summary, 5.2 Coding Details & Code Efficiency | [`implementation_approach_coding_details_and_code_efficiency.typ`](../Submission%20of%205.1%20Implementation%20Approach%20%3A%E2%80%A2%20Project%20Summary%2C5.2%20Coding%20Details%20and%20Code%20Efficiency%2C5.2.1%20Code%20Efficiency/implementation_approach_coding_details_and_code_efficiency.typ) | [`implementation_approach_coding_details_and_code_efficiency.pdf`](../Submission%20of%205.1%20Implementation%20Approach%20%3A%E2%80%A2%20Project%20Summary%2C5.2%20Coding%20Details%20and%20Code%20Efficiency%2C5.2.1%20Code%20Efficiency/implementation_approach_coding_details_and_code_efficiency.pdf) |
| **3** | GANTT Chart & 4.2 Data Design: Database and Schema Design | [`gantt_chart_and_data_design.typ`](../Submission%20of%20GANTT%20chart%2C4.2%20Data%20Design%3A%20Database%20and%20Schema%20Design/gantt_chart_and_data_design.typ) | [`gantt_chart_and_data_design.pdf`](../Submission%20of%20GANTT%20chart%2C4.2%20Data%20Design%3A%20Database%20and%20Schema%20Design/gantt_chart_and_data_design.pdf) |
| **4** | Abstract, 1.4 Achievements, 1.5 Organization of Report | [`abstract_achievements_and_organization_of_report.typ`](../Submission%20of%20ABSTRACT%2C%201.4%20Achievements%2C%201.5%20Organization%20of%20Report/abstract_achievements_and_organization_of_report.typ) | [`abstract_achievements_and_organization_of_report.pdf`](../Submission%20of%20ABSTRACT%2C%201.4%20Achievements%2C%201.5%20Organization%20of%20Report/abstract_achievements_and_organization_of_report.pdf) |
| **5** | Chp 7. Conclusion, Limitations, Future Scope & References | [`conclusion_limitations_future_scope_and_references.typ`](../Submission%20of%207.%20CONCLUSION%287.1%20Conclusion%2C%207.2%20Limitations%20of%20the%20System%2C%207.3%20Future%20Scope%20of%20the%20Project%2C%20References/conclusion_limitations_future_scope_and_references.typ) | [`conclusion_limitations_future_scope_and_references.pdf`](../Submission%20of%207.%20CONCLUSION%287.1%20Conclusion%2C%207.2%20Limitations%20of%20the%20System%2C%207.3%20Future%20Scope%20of%20the%20Project%2C%20References/conclusion_limitations_future_scope_and_references.pdf) |
| **6** | Module 7: Trending Misinformation Analytics Dashboard | [`module_7_trending_misinformation_analytics_dashboard.typ`](../Submission%20of%20Module%207/module_7_trending_misinformation_analytics_dashboard.typ) | [`module_7_trending_misinformation_analytics_dashboard.pdf`](../Submission%20of%20Module%207/module_7_trending_misinformation_analytics_dashboard.pdf) |
| **7** | Chp 5.3 Testing Approach (Unit, Integrated, Beta Testing) | [`testing_approach_unit_integrated_and_beta_testing.typ`](../Submission%20of%205.3%20Testing%20Approach/testing_approach_unit_integrated_and_beta_testing.typ) | [`testing_approach_unit_integrated_and_beta_testing.pdf`](../Submission%20of%205.3%20Testing%20Approach/testing_approach_unit_integrated_and_beta_testing.pdf) |
| **8** | Chp 5.1 Implementation Approach (Input/Output, Database, System) | [`implementation_approach_input_output_database_and_system.typ`](../Submission%20of%20Chp%205.%20IMPLEMENTATION%20AND%20TESTING%20%3A%205.1%20Implementation%20Approach%20-Introduction%2CInput%20and%20Output%20Design%20Implementation%2CDatabase%20Implementation%2CTable%20Structures%2CCode%20Module%2CSystem%20Implementation/implementation_approach_input_output_database_and_system.typ) | [`implementation_approach_input_output_database_and_system.pdf`](../Submission%20of%20Chp%205.%20IMPLEMENTATION%20AND%20TESTING%20%3A%205.1%20Implementation%20Approach%20-Introduction%2CInput%20and%20Output%20Design%20Implementation%2CDatabase%20Implementation%2CTable%20Structures%2CCode%20Module%2CSystem%20Implementation/implementation_approach_input_output_database_and_system.pdf) |
| **9** | Module 6: Fact-Check Card Generator | [`module_6_fact_check_card_generator.typ`](../Submission%20of%20Module%206/module_6_fact_check_card_generator.typ) | [`module_6_fact_check_card_generator.pdf`](../Submission%20of%20Module%206/module_6_fact_check_card_generator.pdf) |
| **10** | Chp 4.2.2 Data Integrity & 4.4 Security Issues | [`data_integrity_and_security_issues.typ`](../Submission%20of%20Chp%204%3A%204.2.2%20Data%20Integrity%20and%20Constraints%2C%204.4%20Security%20Issues/data_integrity_and_security_issues.typ) | [`data_integrity_and_security_issues.pdf`](../Submission%20of%20Chp%204%3A%204.2.2%20Data%20Integrity%20and%20Constraints%2C%204.4%20Security%20Issues/data_integrity_and_security_issues.pdf) |
| **11** | Conceptual Models: Component Diagram | [`conceptual_models_component_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Component%20Diagram/conceptual_models_component_diagram.typ) | [`conceptual_models_component_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Component%20Diagram/conceptual_models_component_diagram.pdf) |
| **12** | Conceptual Models: Data Flow Diagram (DFD L0/L1) | [`conceptual_models_data_flow_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Data%20Flow%20Diagram/conceptual_models_data_flow_diagram.typ) | [`conceptual_models_data_flow_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Data%20Flow%20Diagram/conceptual_models_data_flow_diagram.pdf) |
| **13** | Module 5: Weighted Confidence & Consensus Engine | [`module_5_weighted_confidence_and_consensus_engine.typ`](../Submission%20of%20Module%205/module_5_weighted_confidence_and_consensus_engine.typ) | [`module_5_weighted_confidence_and_consensus_engine.pdf`](../Submission%20of%20Module%205/module_5_weighted_confidence_and_consensus_engine.pdf) |
| **14** | Conceptual Models: Package & Deployment Diagrams | [`conceptual_models_package_and_deployment_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Package%20Diagram%2C%20Deployment%20Diagram/conceptual_models_package_and_deployment_diagram.typ) | [`conceptual_models_package_and_deployment_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Package%20Diagram%2C%20Deployment%20Diagram/conceptual_models_package_and_deployment_diagram.pdf) |
| **15** | 4.3 User Interface Design & Wireframes | [`user_interface_design_and_wireframes.typ`](../Submission%20of%204.3%20User%20Interface%20Design%20%28Wireframes%29/user_interface_design_and_wireframes.typ) | [`user_interface_design_and_wireframes.pdf`](../Submission%20of%204.3%20User%20Interface%20Design%20%28Wireframes%29/user_interface_design_and_wireframes.pdf) |
| **16** | 4.5 Test Cases Design (Draft) | [`test_cases_design_draft.typ`](../Submission%20of%204.5%20Test%20Cases%20Design%28Draft%29/test_cases_design_draft.typ) | [`test_cases_design_draft.pdf`](../Submission%20of%204.5%20Test%20Cases%20Design%28Draft%29/test_cases_design_draft.pdf) |
| **17** | Module 4: Decentralized Quorum Verification Queue | [`module_4_decentralized_quorum_verification_queue.typ`](../Submission%20of%20Module%204/module_4_decentralized_quorum_verification_queue.typ) | [`module_4_decentralized_quorum_verification_queue.pdf`](../Submission%20of%20Module%204/module_4_decentralized_quorum_verification_queue.pdf) |
| **18** | Conceptual Models: Sequence Diagram | [`conceptual_models_sequence_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Sequence%20Diagram/conceptual_models_sequence_diagram.typ) | [`conceptual_models_sequence_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Sequence%20Diagram/conceptual_models_sequence_diagram.pdf) |
| **19** | Chp 4. System Design: 4.1 Modules & 4.2 Data Design | [`system_design_modules_and_data_design.typ`](../Submission%20of%204.%20SYSTEM%20DESIGN%20%284.1%20Basic%20Modules%2C4.2%20Data%20Design%2C4.2.1%20Schema%20Design%20%28Data%20Dictionary%29%29/system_design_modules_and_data_design.typ) | [`system_design_modules_and_data_design.pdf`](../Submission%20of%204.%20SYSTEM%20DESIGN%20%284.1%20Basic%20Modules%2C4.2%20Data%20Design%2C4.2.1%20Schema%20Design%20%28Data%20Dictionary%29%29/system_design_modules_and_data_design.pdf) |
| **20** | 3.5 Preliminary Product Description | [`preliminary_product_description.typ`](../Submission%20of%20%283.5%20Preliminary%20Product%20Description%29/preliminary_product_description.typ) | [`preliminary_product_description.pdf`](../Submission%20of%20%283.5%20Preliminary%20Product%20Description%29/preliminary_product_description.pdf) |
| **21** | Conceptual Models: Activity & State Diagrams | [`conceptual_models_activity_and_state_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Activity%20Diagram%2C%20State%20Diagram/conceptual_models_activity_and_state_diagram.typ) | [`conceptual_models_activity_and_state_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20Activity%20Diagram%2C%20State%20Diagram/conceptual_models_activity_and_state_diagram.pdf) |
| **22** | Module 3: Jaccard Duplicate Detection Engine | [`module_3_jaccard_duplicate_detection_engine.typ`](../Submission%20of%20Module%203/module_3_jaccard_duplicate_detection_engine.typ) | [`module_3_jaccard_duplicate_detection_engine.pdf`](../Submission%20of%20Module%203/module_3_jaccard_duplicate_detection_engine.pdf) |
| **23** | Conceptual Models: Use Case Diagram | [`conceptual_models_use_case_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-Use%20Case%20Diagram/conceptual_models_use_case_diagram.typ) | [`conceptual_models_use_case_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-Use%20Case%20Diagram/conceptual_models_use_case_diagram.pdf) |
| **24** | Conceptual Models: Event Table & Object Diagram | [`conceptual_models_event_table_and_object_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-Event%20Table%2C%20Object%20Diagram/conceptual_models_event_table_and_object_diagram.typ) | [`conceptual_models_event_table_and_object_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-Event%20Table%2C%20Object%20Diagram/conceptual_models_event_table_and_object_diagram.pdf) |
| **25** | ER, Class, Object Diagrams & Module 2 Implementation | [`er_class_object_and_module_2.typ`](../Submission%20of%20ER%20Diagram%2C%20Class%20Diagram%2CObject%20Diagram%20%5BProject%20Dissertation%5D%20and%20Module%202%5BProject%20Implementation%5D/er_class_object_and_module_2.typ) | [`er_class_object_and_module_2.pdf`](../Submission%20of%20ER%20Diagram%2C%20Class%20Diagram%2CObject%20Diagram%20%5BProject%20Dissertation%5D%20and%20Module%202%5BProject%20Implementation%5D/er_class_object_and_module_2.pdf) |
| **26** | Module 2: Multimodal Claim Ingestion & OCR | [`module_2_multimodal_claim_ingestion_and_ocr.typ`](../Submission%20of%20Module%202/module_2_multimodal_claim_ingestion_and_ocr.typ) | [`module_2_multimodal_claim_ingestion_and_ocr.pdf`](../Submission%20of%20Module%202/module_2_multimodal_claim_ingestion_and_ocr.pdf) |
| **27** | Conceptual Models: E-R & Class Diagrams | [`conceptual_models_er_and_class_diagram.typ`](../Submission%20of%203.6%20Conceptual%20Models%20-%20E-R%20Diagram%20%2C%20Class%20Diagram/conceptual_models_er_and_class_diagram.typ) | [`conceptual_models_er_and_class_diagram.pdf`](../Submission%20of%203.6%20Conceptual%20Models%20-%20E-R%20Diagram%20%2C%20Class%20Diagram/conceptual_models_er_and_class_diagram.pdf) |
| **28** | Chp 3: Requirements & Analysis (3.1–3.4) | [`requirements_and_analysis.typ`](../Submission%20of%20CHAPTER%203%3A%20REQUIREMENTS%20AND%20ANALYSIS%203.1%20Problem%20Definition%203.2%20Requirements%20Specification%203.3%20Planning%20and%20Scheduling%203.4%20Software%20and%20Hardware%20Requirements/requirements_and_analysis.typ) | [`requirements_and_analysis.pdf`](../Submission%20of%20CHAPTER%203%3A%20REQUIREMENTS%20AND%20ANALYSIS%203.1%20Problem%20Definition%203.2%20Requirements%20Specification%203.3%20Planning%20and%20Scheduling%203.4%20Software%20and%20Hardware%20Requirements/requirements_and_analysis.pdf) |
| **29** | Chapter 2: Survey of Technologies | [`survey_of_technologies.typ`](../CHAPTER%202%3A%20SURVEY%20OF%20TECHNOLOGIES/survey_of_technologies.typ) | [`survey_of_technologies.pdf`](../CHAPTER%202%3A%20SURVEY%20OF%20TECHNOLOGIES/survey_of_technologies.pdf) |
| **30** | Chp 1: Introduction (1.1 Background, 1.2 Objectives, 1.3 Scope) | [`introduction_background_objectives_and_scope.typ`](../Submission%20of%20CHAPTER%201%3A%20INTRODUCTION%201.1%20Background%201.2%20Objectives%201.3%20Purpose%2C%20Scope%2C%20and%20Applicability%201.3.1%20Purpose%201.3.2%20Scope%201.3.3%20Applicability/introduction_background_objectives_and_scope.typ) | [`introduction_background_objectives_and_scope.pdf`](../Submission%20of%20CHAPTER%201%3A%20INTRODUCTION%201.1%20Background%201.2%20Objectives%201.3%20Purpose%2C%20Scope%2C%20and%20Applicability%201.3.1%20Purpose%201.3.2%20Scope%201.3.3%20Applicability/introduction_background_objectives_and_scope.pdf) |
| **31** | Planning (PERT Chart), Event Table, Use Case & Module 1 | [`planning_pert_event_table_usecase_and_module_1.typ`](../Submission%20of%203.3%20Planning%20and%20Scheduling%28PERT%20Chart%29%2C%20Event%20Table%2C%20Use%20case%20diagram%20%5BProject%20Dissertation%5D%20and%20Module%201%5BProject%20Implementation%5D/planning_pert_event_table_usecase_and_module_1.typ) | [`planning_pert_event_table_usecase_and_module_1.pdf`](../Submission%20of%203.3%20Planning%20and%20Scheduling%28PERT%20Chart%29%2C%20Event%20Table%2C%20Use%20case%20diagram%20%5BProject%20Dissertation%5D%20and%20Module%201%5BProject%20Implementation%5D/planning_pert_event_table_usecase_and_module_1.pdf) |
| **32** | Consolidated Chp 1, Chp 2, Chp 3 Submission | [`introduction_survey_and_requirements.typ`](../Submission%20of%201.%20INTRODUCTION%202.%20SURVEY%20OF%20TECHNOLOGIES%203.%20REQUIREMENT%20AND%20ANALYSIS/introduction_survey_and_requirements.typ) | [`introduction_survey_and_requirements.pdf`](../Submission%20of%201.%20INTRODUCTION%202.%20SURVEY%20OF%20TECHNOLOGIES%203.%20REQUIREMENT%20AND%20ANALYSIS/introduction_survey_and_requirements.pdf) |
| **33** | Project Synopsis (Initial Proposal & Approval) | [`project_synopsis.typ`](../Project%20Synopsis/project_synopsis.typ) | [`project_synopsis.pdf`](../Project%20Synopsis/project_synopsis.pdf) |

---

## 🔬 Core Empirical Findings & Validation Summary

Across the 500-claim benchmark corpus, 4 client hardware profiles, and a 25-user student peer beta trial at Jai Hind College, Mumbai, FactStamp demonstrated the following validated performance characteristics:

```
                                    FACTSTAMP EMPIRICAL PERFORMANCE RADAR
                                    
                   Jaccard Duplicate Latency (82.4ms)
                                  100
                                   ▲
                                   │  * (96.4% Recall)
                                   │
      Zero-Cost Headroom (5.9x) ───┼─── Fact Card Export (460.5ms)
                                   │
                                   │  * (84.2 SUS Usability)
                                   ▼
                       APCA Contrast (|Lc| >= 75)
```

1. **Jaccard Token Matching ($J \ge 0.75$):**
   - Mean resolution latency: **$82.4\text{ ms}$** ($p50 = 64.1\text{ ms}$, $p90 = 118.6\text{ ms}$, $p99 = 145.2\text{ ms}$).
   - Duplicate suppression accuracy (recall): **$96.4\%$** with **$0.0\%$ false-positive collisions**.
   - Peak client memory allocation: **$1.84\text{ MB}$** ($O(|S_A| + |S_B|)$ space complexity).

2. **Client-Side Image Pre-Processing & Payload Clamping:**
   - HTML5 Canvas adaptive downscaling to $\le 1280\text{px}$ dimension.
   - Iterative JPEG compression stepping ($0.72 \to 0.40$) enforcing a strict base64 ceiling **$\le 700\text{ KB}$** (averaging $168\text{ KB}$ to $382\text{ KB}$, an $86.0\%$ to $92.9\%$ reduction).
   - In-browser Tesseract.js WebAssembly OCR achieving **$92.6\%$ character accuracy** ($98.2\%$ on digital screenshots).

3. **Fact-Check Card Rasterization (`html-to-image`):**
   - Abandoned legacy JavaScript canvas parsers that crashed on Tailwind CSS v4 OKLCH color strings.
   - Migrated to browser-native SVG `<foreignObject>` canvas rasterization at `pixelRatio: 2.0`.
   - Generates $1080 \times 1080\text{px}$ crisp PNG artifacts in **$460.5\text{ ms}$ average latency** ($648\text{ ms}$ on budget Android mobile, $284\text{ ms}$ on desktop).

4. **Student Peer Beta Trial ($N = 25$):**
   - Conducted over 7 days with 25 student participants (10 submitters, 15 peer verifiers).
   - 68 real-world WhatsApp forwards evaluated across 204 individual peer verifications.
   - Average quorum turnaround time: **$18.4\text{ hours}$**.
   - Fact Card export success rate: **$100.0\%$** ($204 / 204$ successful downloads).
   - System Usability Scale (SUS) score: **$84.2 \pm 4.6$** (Grade A, superior to the $68.0$ industry average).

5. **Accessibility & APCA Lightness Contrast:**
   - Body typography: $|L^c| = -92.4$ (Light mode) and $|L^c| = +88.6$ (Dark mode), substantially exceeding the $|L^c| \ge 75$ threshold for fluent reading.
   - Saffron Action controls: $|L^c| = -68.2$, exceeding the $|L^c| \ge 60$ requirement for bold controls.
   - Dual visual encoding: Every verdict state pairs its color theme with unique geometric icons (`lucide-react`) and explicit textual labels, achieving $100\%$ discriminability across color blindness simulators.

6. **Serverless Scalability within Google Firebase Free Tier:**
   - 1,000 daily active users generate $8,450$ document reads ($16.9\%$ of 50,000 free quota, **$5.9\times$ safety margin**).
   - 1,000 daily active users generate $1,820$ document writes ($9.1\%$ of 20,000 free quota, **$11.0\times$ safety margin**).
   - Production bundle weight: **$178.4\text{ KB}$** gzipped JavaScript via Vite 5, achieving First Contentful Paint of $0.65\text{s}$ on 4G mobile networks.

---

## 📌 Academic Quality & Syllabus Verification Checklist

- [x] **Page Border Enforcement:** Solid 1pt black border applied across all compiled Typst documents (`rect(width: 100% - 1.5cm, height: 100% - 1.5cm, stroke: 1pt + black)`).
- [x] **Strict 12pt Justified Typography:** Set to Times New Roman with Liberation Serif/Nimbus Roman fallbacks, 12pt body, line leading 0.65em.
- [x] **Standard Heading Hierarchy:** Level 1 (16pt Bold, starts on new page), Level 2 (14pt Bold), Level 3 (13pt Bold).
- [x] **Front-Matter Chronology:** Exactly 10 preliminary pages in prescribed order (Title, Approved Proforma, Certificate, Declaration, Role & Responsibility, Abstract, Acknowledgement, Table of Contents, Table of Figures & Tables) with Roman numeral pagination (`ii`–`x`).
- [x] **7-Chapter Syllabus Alignment:** Full adherence to Course `JUSIT-DSCPR503` structure.
- [x] **Zero Placeholder Policy:** No abbreviations, placeholder strings, or missing sections across any of the 45+ markdown files in the repository draft.
- [x] **IEEE Citation Reference Standard:** 34 comprehensive academic citations with complete DOIs, authors, titles, and publication venues.
- [x] **Technical Glossary:** 30+ formal terms mapped to mathematical formulations and architectural implementations in FactStamp.
