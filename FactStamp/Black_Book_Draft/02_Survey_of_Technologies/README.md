# CHAPTER 2: SURVEY OF TECHNOLOGIES

> **FactStamp: A Community-Powered WhatsApp Misinformation Fact-Checker**  
> *Academic Course Submission — Course Code: JUSIT-DSCPR503*  
> *Candidate:* Aadish Das (UID: 2023IT001 / Roll No.: 10)  
> *Guides:* Mr. Wilson Rao (HOD) & Ms. Bertilla Fernandes  
> *Department of Information Technology, Jai Hind College (Empowered Autonomous), Mumbai*

---

## Chapter 2 Document Overview & Master Index

This directory (`Black_Book/02_Survey_of_Technologies/`) contains the complete comparative evaluations, architectural decision records, benchmark data, and technology selection rationales for **Chapter 2: Survey of Technologies** of the FactStamp capstone dissertation.

```text
Black_Book/02_Survey_of_Technologies/
├── 2.1_web_architectures.md            # Monolithic SSR vs Serverless Edge vs Decoupled SPA (ADR-01)
├── 2.2_frontend_frameworks.md          # React 18.3.1, Vite 5.4.0, Concurrent Mode, Fiber (ADR-02)
├── 2.3_styling_and_design_tokens.md    # Tailwind CSS v4.0.0, Saffron Sleek OKLCH tokens, APCA (ADR-03)
├── 2.4_cloud_databases.md              # Cloud Firestore v12.17.0, WebSocket sync, Security Rules (ADR-04)
├── 2.5_ocr_engines.md                  # Tesseract.js client WASM OCR, $0.00 vision cost (ADR-05)
├── 2.6_card_export_engines.md          # html-to-image 1.11.13 SVG foreignObject, html2canvas deprecation (ADR-06)
├── 2.7_consensus_models.md             # Multi-Factor Quorum (C = 0.40A+0.30R+0.30S), Anti-Sybil (ADR-07)
├── 2.8_technology_selection_matrix.md  # 10-layer selection matrix, budget breakdown ($0.00/mo)
└── README.md                           # Master index for Chapter 2
```

---

## 1. Summary of Evaluated Subsystems & Architectural Choices

1. **Web Architecture (Section 2.1):** Selected **Decoupled Serverless SPA with BaaS** (React 18.3.1 + Vite 5.4.0 + Cloud Firestore v12.17.0) over Monolithic SSR and Hybrid Edge SSR. Offloads compute tasks to client browsers to guarantee a zero-dollar operating baseline.
2. **Frontend UI Framework (Section 2.2):** Selected **React 18.3.1 + Vite 5.4.0** over Next.js 14, Vue 3, and Angular 17. Leverages Concurrent React (`useTransition`, `useDeferredValue`) for non-blocking duplicate detection and instant 60 FPS mobile rendering.
3. **Styling & Design System (Section 2.3):** Selected **Tailwind CSS v4.0.0** with the **Saffron Sleek** design system (`#BA3E03`, `#FFFDF8`, dark mode `oklch(0.115 0.018 55)`). Color tokens are formulated in OKLCH to satisfy APCA lightness contrast ($L_c > 75$). Bundles Plus Jakarta Sans and Noto Sans Devanagari with zero-cost CSS `tabular-nums`.
4. **Cloud Persistence & Sync (Section 2.4):** Selected **Google Cloud Firestore v12.17.0** over Supabase and MongoDB Atlas. Connects directly via WebSocket snapshot listeners (`onSnapshot`) with sub-120ms updates, local IndexedDB caching, and declarative atomic security rules.
5. **In-Browser OCR (Section 2.5):** Selected **Tesseract.js WebAssembly** over Google Cloud Vision API and AWS Textract. Processes screenshot pixels entirely inside background Web Workers within device RAM, ensuring 100% user privacy and eliminating commercial API fees.
6. **Graphic Card Compilation (Section 2.6):** Selected **`html-to-image` 1.11.13** via browser-native SVG `<foreignObject>` canvas rasterization. Permanently deprecated legacy `html2canvas` due to fatal parsing exceptions on Tailwind v4 OKLCH color spaces. Exports high-DPI 1080×1080px cards in 340 ms.
7. **Distributed Consensus & Anti-Sybil (Section 2.7):** Selected **Multi-Factor Weighted Quorum Consensus** ($C = 0.40A + 0.30R + 0.30S$, $N \ge 3$) over Simple Majority and Blockchain PoS. Balances agreement ($40\%$), verifier reputation ($30\%$), and primary citation credibility ($30\%$) with an automated $+2$/$-3$ reputation feedback loop and anti-self-verification locks.
8. **Selection Matrix & Budget (Section 2.8):** Comprehensive 10-layer selection matrix proving that the entire platform operates at **$0.00 per month** across Vercel Edge CDN and Firebase Spark free tiers, supported by a client-side Canvas compression pipeline storing base64 strings under 500 KB to eliminate cloud storage bucket fees.
