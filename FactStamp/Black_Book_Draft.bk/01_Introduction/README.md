# CHAPTER 1: INTRODUCTION

> **FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker**  
> *Academic Course Submission — Course Code: JUSIT-DSCPR503*  
> *Candidate:* Aadish Das (UID: 2023IT001 / Roll No.: 10)  
> *Guides:* Mr. Wilson Rao (HOD) & Ms. Bertilla Fernandes  
> *Department of Information Technology, Jai Hind College (Empowered Autonomous), Mumbai*

---

## Chapter 1 Document Overview & Master Index

This directory (`Black_Book/01_Introduction/`) compiles the complete academic prose, empirical statistics, mathematical formulations, and organizational mappings for **Chapter 1: Introduction** of the FactStamp capstone dissertation.

```text
Black_Book/01_Introduction/
├── 1.1_background.md                 # Background, dark social, E2EE, psychological biases, latency deficit
├── 1.2_objectives.md                 # 8 quantifiable engineering & algorithmic objectives
├── 1.3_purpose_scope_applicability.md# Purpose, 4-tier scope, workflow lifecycle, multi-stakeholder utility
├── 1.4_achievements.md               # Empirical benchmark achievements, zero-dollar cloud model, APCA
├── 1.5_organisation_of_report.md     # 7-chapter roadmap, detailed chapter summaries, inter-dependency matrix
└── README.md                         # Master index for Chapter 1
```

---

## 1.1 Summary of Background & Problem Statement
- **WhatsApp in India:** 535M+ domestic users, functioning as the informal societal OS for news, family communication, and civic life.
- **The Dark Social Blindspot:** End-to-end encryption (Signal protocol) creates an opaque information enclave inaccessible to automated search indexing or AI moderation.
- **Psychological Biases:** High-trust interpersonal forwarding from kinship networks bypasses cognitive skepticism; 1-tap forwarding reduces friction to under 2 seconds.
- **Asymmetric Viral Velocity:** Vosoughi et al. (*Science*, 2018) proved false news diffuses 70% faster and farther than truth due to emotional optimization.
- **Centralized Fact-Checking Latency Deficit:** AltNews, BOOM Live, and Snopes require 24–72 hours to publish a 1,500-word debunking article, while a WhatsApp rumor's viral window is under 3 hours.
- **Counter-Narrative Friction:** Text hyperlinks trigger defensive interpersonal conflict and are rarely read in mobile group chats.

---

## 1.2 Summary of 8 Core Engineering Objectives
1. **Frictionless Multimodal Ingestion:** Unauthenticated submission of plaintext (up to 2,000 chars) and screenshot uploads (up to 5 MB).
2. **In-Browser WebAssembly OCR:** Local client-side text extraction via Tesseract.js in Web Workers ($0.00 cloud vision cost, complete privacy).
3. **Token-Level Jaccard Duplicate Suppression:** String normalization and Jaccard similarity ($J \ge 0.75$) resolving duplicates in $<100\text{ ms}$ (94.2% recall).
4. **Democratic 3-Verifier Quorum Queue:** Real-time Firestore v12.17.0 verification queue requiring $N \ge 3$ independent reviews with mandatory primary citation URLs.
5. **Multi-Factor Weighted Consensus Engine:** Algorithmic scoring formula $C = 0.40A + 0.30R + 0.30S$ synthesizing agreement, verifier reputation, and source credibility.
6. **Tamper-Resistant Anti-Sybil Defense:** Reputation ledger initialized at $R_0 = 50$, dynamic $+2$/$-3$ update loop, and declarative Firestore security rules blocking self-verification.
7. **WhatsApp-Native Visual Fact Cards:** `html-to-image` 1.11.13 browser-native SVG `<foreignObject>` rasterization generating 1080×1080px square PNG cards with 100% Tailwind CSS v4.0.0 OKLCH color fidelity in 340 ms.
8. **Public Analytical Misinformation Surveillance:** Recharts 2.10.0 real-time analytics visualizing 7-day rolling claim volumes, category distributions, and verifier leaderboards.

---

## 1.3 Key Architectural Parameters & Empirical Achievements
- **Frontend Stack:** React 18.3.1, Vite 5.4.0, Tailwind CSS v4.0.0 with Saffron Sleek OKLCH color space tokens.
- **Backend & Cloud:** Google Cloud Firestore v12.17.0 (Multi-Region NoSQL), Firebase Auth v12.17.0, Vercel Global Edge CDN.
- **Operating Economics:** **$0.00 / month** perpetual serverless free tier; client-side Canvas compression to base64 $< 500\text{ KB}$ stored in Firestore document fields achieves a strict **zero cloud storage bill model**.
- **Accessibility:** APCA lightness contrast $L_c > 75$ across all light/dark theme surfaces, exceeding standard WCAG 2.1 AAA benchmarks.
