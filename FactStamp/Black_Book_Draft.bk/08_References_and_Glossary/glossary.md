# Comprehensive Technical Glossary

---

## Overview

This glossary provides authoritative, alphabetical definitions for specialized technical terms, algorithms, standards, and architectural concepts utilized throughout the **FactStamp** academic dissertation and software implementation. Each entry details the formal definition, its specific operational context within FactStamp, and its mathematical or architectural significance.

---

### A

#### Accessible Perceptual Contrast Algorithm (APCA)
An advanced, perception-based contrast prediction algorithm developed for the upcoming W3C Web Content Accessibility Guidelines (WCAG) 3.0. Unlike legacy WCAG 2.1 flat mathematical ratios (which treat light-on-dark and dark-on-light contrast identically), APCA computes lightness contrast ($L^c$) taking into account spatial frequency, ocular adaptation, font weight, and non-linear human visual perception.  
*FactStamp Context:* Used to calibrate the `Saffron Sleek` theme palette, guaranteeing body text achieves $|L^c| \ge 75$ (exceeding WCAG 3.0 fluent reading standards) and buttons achieve $|L^c| \ge 60$ across both light and dark display modes.

#### Agreement Ratio ($A$)
A normalized quantitative metric ($0–100\%$) indicating the degree of consensus among independent verifiers participating in a quorum. Computed as the number of votes supporting the majority verdict candidate divided by the total number of submitted verifications ($A = \frac{N_{\text{majority}}}{N_{\text{total}}} \times 100$).  
*FactStamp Context:* Represents a primary component (weighted at $40\%$) in the multi-factor confidence scoring formula ($C = 0.40A + 0.30R + 0.30S$).

---

### C

#### Client-Side Rasterization
The process of converting Document Object Model (DOM) tree structures, styled cascading stylesheets, and vectorized typography directly into raster pixel grids (e.g., PNG format) entirely within the user's web browser, without transmitting layout data to an intermediate cloud rendering server.  
*FactStamp Context:* Performed by `html-to-image` via browser-native SVG `<foreignObject>` canvas rasterization to compile 1080×1080px fact-check PNG cards in $< 650$ ms.

#### Cloud Firestore
A managed, globally distributed, multi-region NoSQL document database provided by Google Cloud and Firebase. Features native WebSocket-based real-time snapshot listeners (`onSnapshot`), sub-50ms synchronization latencies, offline edge persistence, and declarative security rules.  
*FactStamp Context:* Serves as FactStamp's primary cloud datastore for the `claims`, `verifications`, `users`, and `notifications` collections within the zero-cost Spark tier.

#### Confidence Score ($C$)
A composite algorithmic rating ($0–100\%$) expressing the mathematical certainty of a certified fact-check verdict. Calculated once a claim achieves the minimum 3-verifier quorum.  
*FactStamp Context:* Computed via the weighted linear combination $C = (A \times 40\%) + (R \times 30\%) + (S \times 30\%)$, combining verifier agreement ($A$), average historical reputation ($R$), and source credibility ($S$).

#### Contested Claim
A formal system state assigned to a submitted forward when participating verifiers submit equally divided votes (split decision) and cannot converge on a majority verdict within the mandatory 7-day deliberation window.  
*FactStamp Context:* Indicated visually with a violet status badge and queued for administrative escalation or extended quorum ($N = 5$) review.

---

### D

#### Dark Social
Communication channels and digital interactions that occur within private, encrypted, or closed peer-to-peer applications (such as WhatsApp, Signal, Telegram, and private email threads) rather than public broadcast social networks (such as Twitter/X or public Facebook posts). Dark social referrals cannot be indexed by search engine crawlers or tracked by public web analytics.  
*FactStamp Context:* The core operational domain targeted by FactStamp. Because WhatsApp misinformation spreads inside dark social family and community groups, FactStamp empowers users to extract claims and return visual counter-cards directly into the closed originating chat.

#### Data Flow Diagram (DFD)
A formal visual modeling notation representing the functional decomposition of a software system, illustrating the paths through which information moves from external entities through transformation processes to data repositories.  
*FactStamp Context:* Developed in Chapter 3 at Level 0 (Context Diagram), Level 1 (Subsystem Overview), and Level 2 (Detailed Module Logic) using Graphviz `.dot` syntax.

---

### E

#### End-to-End Encryption (E2EE)
A secure communications mechanism where data is encrypted on the sender's device and decrypted only on the recipient's final device, preventing intermediate network switches, telecom providers, and server operators from intercepting or reading message plaintext.  
*FactStamp Context:* Governs WhatsApp private messages. FactStamp respects E2EE completely by operating strictly as an external, user-initiated verification tool rather than an invasive chat scraper.

---

### F

#### ForeignObject (SVG `<foreignObject>`)
An element in the Scalable Vector Graphics (SVG) 2.0 specification that permits the direct inclusion and layout rendering of arbitrary HTML and CSS DOM fragments within an SVG drawing canvas.  
*FactStamp Context:* The core rendering technology used by `html-to-image` to bypass buggy JavaScript CSS parsers and rasterize live Tailwind CSS v4 OKLCH elements into high-resolution PNG images.

---

### H

#### HTML5 Canvas API
A standard browser JavaScript interface allowing dynamic, scriptable 2D rendering and pixel manipulation on a bitmap surface element (`<canvas>`).  
*FactStamp Context:* Utilized in `src/lib/imageCompression.ts` to downsample user-uploaded screenshots to a maximum 1200px boundary, achieving an $89.2\%$ file size reduction before base64 encoding.

---

### I

#### IndicBERT
A state-of-the-art multilingual ALBERT-based transformer model pre-trained on 12 major Indian languages (Hindi, Marathi, Bengali, Tamil, Telugu, Gujarati, Kannada, Malayalam, Odia, Punjabi, Assamese, and English).  
*FactStamp Context:* Highlighted in Chapter 7.3 as the planned neural vector embedding backbone for cross-lingual duplicate detection between English and vernacular language forwards.

---

### J

#### Jaccard Similarity Index
A set-theoretic statistic used for gauging the similarity and diversity of sample sets, defined mathematically as the size of the intersection divided by the size of the union of two sets:
$$J(A, B) = \frac{|A \cap B|}{|A \cup B|}$$
*FactStamp Context:* Powers the duplicate detection engine (`src/lib/duplicateDetection.ts`). Claims with normalized token overlap $J \ge 0.75$ are classified as duplicates, achieving $96.4\%$ suppression accuracy in $82.4$ ms.

---

### N

#### NoSQL Document Database
A non-relational database architecture that organizes data into flexible, semi-structured document records (typically JSON or BSON) grouped into collections, rather than rigid relational tabular schemas.  
*FactStamp Context:* Implemented via Google Cloud Firestore, enabling hierarchical nesting of verification arrays within claim documents.

---

### O

#### OKLCH / Oklab Color Space
A modern cylindrical color model designed by Björn Otten based on the Oklab color appearance space, specified by Lightness ($L \in [0, 1]$), Chroma ($C \ge 0$), and Hue angle ($H \in [0, 360^\circ]$). Unlike sRGB, OKLCH provides uniform perceptual lightness across different hues, eliminating visual brightness distortion.  
*FactStamp Context:* The native color specification used in FactStamp's Tailwind CSS v4 design tokens (`Saffron Sleek`), enabling precise APCA contrast compliance.

#### Optical Character Recognition (OCR)
The computational conversion of images containing typed, handwritten, or printed text into machine-encoded character strings.  
*FactStamp Context:* Handled client-side via Tesseract.js WebAssembly (`tesseract.js`), extracting forward text from uploaded screenshots with $92.6\%$ overall character accuracy.

---

### P

#### Progressive Web App (PWA)
A software application delivered through the web, built using common web technologies (HTML, CSS, JavaScript, WebAssembly), intended to function on any platform that uses a standards-compliant browser with native-like capabilities (offline caching, background sync, installability).  
*FactStamp Context:* Articulated in Chapter 7.3 as a planned enhancement utilizing Service Workers and IndexedDB for low-bandwidth rural offline usage.

---

### Q

#### Quorum Consensus
A distributed decision-making protocol in which an action or state transition is certified only after receiving independent approval from a predetermined minimum threshold of participating nodes or actors ($N \ge 3$).  
*FactStamp Context:* Governs the Verification Queue (Module 4). A submitted claim remains pending until three distinct community verifiers independently review evidence and cast votes.

---

### R

#### Recharts
A declarative, React-native charting library built on SVG rendering and React component lifecycles.  
*FactStamp Context:* Utilized in Module 7 (`src/components/DashboardChart.tsx`) to visualize weekly misinformation trends, category distributions, and verifier leaderboards.

#### Reputation Score ($R$)
A dynamic numerical metric ($0–100$ scale) assigned to each authenticated verifier representing their historical veracity record. New verifiers initialize at a baseline of 50. Accurate votes that match certified quorum consensus reward points ($+5$ to $+10$), while bad-faith outlier votes deduct points ($-15$).  
*FactStamp Context:* Weighted at $30\%$ in the consensus confidence scoring formula.

#### Role-Based Access Control (RBAC)
A computer security approach that restricts system access to authorized users based on predefined organizational roles (`User`, `Verifier`, `Admin`).  
*FactStamp Context:* Enforced via Firestore Security Rules and client-side route guards (`src/components/AdminRoute.tsx`).

---

### S

#### Saffron Sleek Design System
FactStamp's bespoke aesthetic and token architecture, combining Sleek precision with Editorial warmth. Built upon Deep Saffron primary accents (`oklch(0.50 0.18 48)`), Deep Ink surfaces, warm cream paper textures (`oklch(0.97 0.012 55)`), DM Sans typography, and JetBrains Mono tabular metrics, strictly banning generic AI-generated purple aesthetics.  
*FactStamp Context:* Governs the global CSS stylesheet (`src/index.css`) and UI component library.

#### Service Worker
A client-side programmable network proxy running in a background browser thread, capable of intercepting HTTP requests, serving cached responses, and synchronizing offline background tasks.  
*FactStamp Context:* Planned in Chapter 7.3 for Workbox-powered offline caching.

#### Small Language Model (SLM)
A lightweight neural generative language model (typically 100M to 2B parameters) quantized to low-bit representations (4-bit INT4) capable of executing efficiently on consumer device hardware without cloud server dependencies.  
*FactStamp Context:* Planned in Chapter 7.3 for client-side WebGPU claim extraction.

#### Source Credibility Score ($S$)
A normalized score ($0–100$) evaluating the trustworthiness of external evidence URLs cited by verifiers:
- **Tier 1 (High Quality, 100 pts):** Official government, WHO, ICMR, court records.
- **Tier 2 (Medium Quality, 70 pts):** Accredited national news organizations and wire services.
- **Tier 3 (Low Quality, 30 pts):** Unverified blogs or social media commentary.  
*FactStamp Context:* Weighted at $30\%$ in the consensus formula.

#### Sybil Attack
A security vulnerability in distributed and peer-to-peer networks where an adversary undermines system reputation and consensus by creating a large number of pseudonymous identities.  
*FactStamp Context:* Neutralized in FactStamp through weighted reputation scoring, strict self-verification blocks, and domain quality requirements.

---

### T

#### Tesseract.js
A pure JavaScript and WebAssembly compilation of the open-source Tesseract OCR engine, running entirely within web browser client workers.  
*FactStamp Context:* Used for client-side text extraction from WhatsApp screenshots.

#### Trust Ring
A circular SVG progress indicator rendered around verifier profile avatars in FactStamp.  
*FactStamp Context:* Dynamically visualizes a verifier's reputation score on a 0–100 scale using color-coded progress strokes (green for high trust, blue for good, amber for baseline, red for probationary).

---

### V

#### Verdict Stamp
A high-impact, rectangular visual badge designed to resemble an official physical rubber stamp, displayed on verified claims and exported PNG cards.  
*FactStamp Context:* Renders one of five certified states: `TRUE`, `FALSE`, `MISLEADING`, `UNVERIFIABLE`, or `CONTESTED`, featuring subtle tilt angles, color-blind safe iconography, and high APCA contrast.

#### Vite
A high-performance modern frontend build tool and development server created by Evan You, featuring native ECMAScript Module (ESM) serving and extremely fast Hot Module Replacement (HMR).  
*FactStamp Context:* Powers the FactStamp application build pipeline and development environment.

---

### W

#### WebAssembly (WASM)
A binary instruction format for a stack-based virtual machine, designed as a portable compilation target for programming languages (C, C++, Rust), enabling near-native execution speed inside web browsers.  
*FactStamp Context:* Executes the Tesseract.js OCR engine and planned future Whisper/SLM inference engines directly within the client browser.

#### WebGPU
A modern web API providing hardware-accelerated 3D graphics and generalized parallel compute capabilities directly to web applications, replacing legacy WebGL.  
*FactStamp Context:* Identified in Chapter 7.3 as the underlying compute runtime for in-browser SLM inference.

#### Work Breakdown Structure (WBS)
A hierarchical decomposition of the total scope of work to be carried out by the project team to accomplish the project objectives and create the required deliverables.  
*FactStamp Context:* Utilized in Chapter 3 to schedule sprints, milestones, and deliverables.
