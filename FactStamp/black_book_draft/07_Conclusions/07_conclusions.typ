= Conclusions

== Fulfillment of Project Objectives

FactStamp addresses the gap identified in Chapter 1. WhatsApp forwards spread misinformation faster than institutional fact-checkers and unstructured group chats can respond. The project resulted in a working web application. Every claim in this report traces back to a file in the source tree at `/home/aadish/Documents/Github/FactStamp`. The following evaluation maps the implementation against the eight objectives from Section 1.2:

+ *Reduce the time-to-debunk.* Users submit claims directly through the web app instead of waiting for an institutional fact-checker to notice a forward. The multimodal submission pipeline supports text and screenshots and routes them into the verification queue.
+ *Eliminate redundant verification effort.* The Jaccard token-overlap duplicate detector (`src/lib/duplicateDetection.ts`, threshold $>= 0.75$) identifies resubmitted claims with slightly different wording. It returns the existing verdict instead of adding the claim to the queue again.
+ *Replace single-source trust with a distributed quorum.* No single verifier or moderator can settle a verdict alone. Both `src/contexts/ClaimsContext.tsx` and `src/services/firebaseService.ts` enforce a minimum of three verifications before a claim resolves. Server-side rules in `firestore.rules` re-validate every verification write (Case C of the `claims/{claimId}` update rule) so clients cannot forge or replace verifications.
+ *Weight consensus by evidence quality, not headcount.* The weighted confidence engine in `src/lib/confidenceScore.ts` uses the formula `Confidence = 0.40×Agreement + 0.30×Reputation + 0.30×SourceQuality`. Unanimous votes from low-reputation verifiers with weak sources score lower than votes backed by trusted verifiers and authoritative citations.
+ *Make verified facts shareable in the native medium of the misinformation.* The `html-to-image`-based card generator (`src/components/FactCheckCard.tsx`) exports a 1080px-wide PNG. This 540px-wide card is rasterized at a 2#sym.times pixel ratio. Its height grows with the claim text and source list. It fits WhatsApp dimensions and brings the verdict, confidence score, and cited sources back into the original forward chains.
+ *Lower the barrier to submission for non-technical users.* This objective is partially complete. Client-side OCR (`src/services/ocrService.ts`, Tesseract.js) extracts text from screenshots and automatically removes WhatsApp chat chrome. This currently works only for English-script forwards (see Section 7.2).
+ *Build verifier accountability over time.* The reputation system raises or lowers a verifier's score based on how well they align with the final consensus. This directly feeds into the confidence-score weighting for future claims that the verifier participates in.
+ *Give the public visibility into misinformation trends.* The Recharts-powered analytics dashboard (`src/pages/Dashboard.tsx`, `src/lib/weeklyReport.ts`) shows category volumes and rolling weekly reports of the most frequently debunked claims.

Objective 6 is the only goal with a limitation. Section 7.2 examines the English-only OCR constraint in detail.

=== Significance of the System

FactStamp uses no new algorithms and avoids AI-generated verdicts. It relies on human judgment and cited sources. The project provides an architectural and social contribution by filling a gap between the two main fact-checking methods.

Institutional fact-checkers like PIB Fact Check, AltNews, and BOOM Live are reliable but slow. A small professional team cannot handle the daily volume of WhatsApp forwards about health, politics, finance, and religion. Their long-form articles also fail to compete visually with sensational messages in a chat thread. Informal group-chat debunking usually involves someone replying that a message is fake. This is fast but leaves no permanent record or citations. It also fails to identify the same claim when it appears again with different wording.

FactStamp addresses these problems by being:

- *Decentralized*. Verification authority belongs to a community quorum instead of an editorial desk. The system's throughput scales with the number of active verifiers and avoids the limits of a small newsroom team.
- *Zero-infrastructure-cost*. The platform runs on Firebase's free Spark tier and static hosting. It requires no subscription servers, paid vision APIs, or advertising revenue. The operating costs that limit institutional fact-checking do not apply to this system.
- *Privacy-preserving*. OCR runs locally on the client using WebAssembly. WhatsApp screenshots often contain names and phone numbers in the chat header. The system never sends these images to a third-party cloud vision API. All processing stays on the device until the user submits the extracted text.
- *Source-transparent*. Every verdict includes a visible chain of cited URLs and a mathematical confidence formula. This contrasts with opaque newsroom reviews and unverified group-chat replies.

A quorum-based verification process can run at zero infrastructure cost while maintaining human judgment and proper citations. As a BSc Information Technology capstone project, FactStamp delivers a working system that addresses the shortcomings of both institutional and informal fact-checking.

== Limitations of the System

These limitations exist in the source tree at `/home/aadish/Documents/Github/FactStamp`. They are grouped by risk category.

=== Coverage & Accuracy Limitations

- *English-only OCR.* The Tesseract.js model (`src/services/ocrService.ts`) only processes Latin and English text. Users cannot auto-extract text from screenshots of WhatsApp forwards in Devanagari or other regional Indic scripts. They must type the claim text manually. Since a large amount of Indian WhatsApp misinformation uses Hindi and regional languages, this restricts the types of messages the system can process easily.
- *Lower OCR accuracy than commercial cloud vision APIs.* Running OCR client-side with WebAssembly reduces privacy risks and costs (Section 2.5), but it limits accuracy. Cloud vision models like Google Cloud Vision extract text better from low-resolution or heavily compressed WhatsApp screenshots. The `cleanExtractedOcrText()` function reduces chat-interface noise, and users can manually correct the text. However, the browser-side WASM model limits the baseline recognition quality.
- *No direct WhatsApp Business API integration.* FactStamp cannot read WhatsApp messages automatically. Users have to copy and paste text or upload screenshots to the web app. The system lacks a chatbot or Business API listener inside WhatsApp. This manual process adds friction that a native integration would avoid.

=== Trust & Governance Limitations

- *Quorum consensus assumes baseline good-faith participation.* The 3-verifier quorum and reputation-weighted confidence score help prevent manipulation by fake accounts. However, the system still requires mostly honest users. With a small early user base, coordinated malicious accounts could take over a quorum before the reputation system lowers their scores. Reputation weighting reduces this risk over time but cannot remove it entirely while the verifier pool remains small.
- *Source-quality scoring depends on a small hardcoded domain list.* The `src/lib/confidenceScore.ts` file sorts cited sources into high, medium, or low quality using fixed lists. For example, it marks `who.int` and `pib.gov.in` as high-quality and `bbc.com` as medium-quality. Any credible domain missing from this list automatically defaults to low quality. This applies to regional newspapers, medical journals, and state government portals. Valid verifications receive lower weights simply because their source domains are missing from the hardcoded list.

=== Architectural & Scaling Limitations

- *Quorum threshold duplicated as a bare literal across the application layers.* The rule requiring three verifications does not use a single named constant. The codebase hardcodes `>= 3` in six places across `ClaimsContext.tsx` and `firebaseService.ts`. This design is fragile. Changing the quorum size requires updating every location at once. A single missed update would break the synchronization between the queue, the consensus trigger, and the expiry sweep. Although `firestore.rules` checks the structure of each verification write (Case C of the `claims/{claimId}` update rule), it does not validate the total count. As a result, the client enforces the quorum limit rather than the database engine.
- *No automated test suite.* The `package.json` file only defines scripts for `dev`, `build`, `preview`, `typecheck`, `emulators`, `seed:db`, `create:admin`, and `create:user`. The project lacks a `test` script and contains no unit or integration tests. Verification relied on manual walkthroughs instead of a continuous integration pipeline. A human tester has to catch logic errors in duplicate detection, consensus formulas, and security rules before deployment.
- *Image storage capped by the Firestore-embedded approach.* The application compresses uploaded screenshots and stores them as base64 strings inside the Firestore document (`src/lib/imageCompression.ts`) to stay on the Firebase free tier. This method avoids object-storage buckets but limits image payloads to about 800 KB per claim. This approach will face problems at scale due to Firestore document size limits and read costs. The `storage.rules` file contains an unused `claim_screenshots` path. Migrating the image flow to use this path would support larger image volumes.

== Future Scope of the Project

These limitations dictate the follow-up work. The tasks fall into near-term updates to improve the current system and long-term changes requiring major architectural shifts.

=== Near-Term Scope

- *Multi-language OCR (Devanagari and other Indic scripts).* Adding trained language models to the Tesseract.js pipeline will fix the English-only OCR problem. It will allow the system to process Hindi and regional-language WhatsApp forwards that currently require manual typing. Since most Indian misinformation uses non-English languages, this change offers the highest impact in the short term.
- *Expanding the source-quality domain list into a maintained, community-curatable credibility database.* Replacing the small hardcoded domain list in `confidenceScore.ts` with a community-extensible database will allow users to add legitimate regional or specialized sources. These sources will no longer default to low quality by omission. This solves the source-quality problem without requiring changes to the confidence formula.
- *Consolidating the quorum threshold into a single source of truth.* Replacing the hardcoded `>= 3` checks in the client Context and service layer with a single shared constant or Firestore-remote-config value will fix the system's architectural fragility. Any future changes to the quorum size will only require a single edit instead of updates in six separate files. Moving this value into `firestore.rules` will also make the server enforce the quorum limit.
- *An appeal / re-review workflow for CONTESTED claims.* Claims that enter the `CONTESTED` state after the 7-day deadline currently have no way back into active review. A structured appeal flow will allow fresh verifiers to examine ambiguous claims instead of leaving them unresolved. A claim stuck in the `CONTESTED` state fails to give the public clear answers.
- *A basic automated test suite.* The project needs unit tests for the Jaccard duplicate-detection threshold and the weighted consensus formula. It also requires integration tests for the Firebase Local Emulator Suite. These additions will close the testing gap and catch regressions in the core scoring logic before deployment.

=== Long-Term Scope

- *WhatsApp Business API / chatbot-based direct submission.* Connecting the system to the WhatsApp Business API will allow users to forward suspicious messages straight to a FactStamp bot number. This replaces the manual step of copying text or uploading screenshots to the web app. It lets users interact with the tool directly inside the messaging platform.
- *Migrating large images to Firebase Storage as the primary flow.* The current image flow compresses screenshots to base64 strings inside Firestore documents. The `storage.rules` file defines a `claim_screenshots` path, but the application code does not use it. Making Storage-backed images the default method will bypass the 800 KB limit per claim. The platform will handle more images without facing Firestore's document-size or read-cost constraints.
- *A mobile app wrapper (React Native or installable PWA).* Turning the web application into an installable Progressive Web App or a React Native wrapper will put FactStamp on user home screens. This provides access to native push notifications. Most WhatsApp forwarding happens on phones, so users need a mobile-friendly way to use the platform instead of reopening a browser tab.
- *A browser extension for one-click submission.* A browser extension will let users right-click a webpage or chat screenshot to submit it to FactStamp immediately. They will not need to open the web app first. This reduces submission friction for misinformation that starts on the open web before spreading to WhatsApp groups.
- *Push notifications (web push) instead of only in-app notifications.* Users currently find out their claim reached consensus only by checking the app. Web push notifications will alert them immediately when the verification finishes.
- *Multi-tenant support for other messaging platforms (Telegram, SMS forwards).* The submission, duplicate-detection, and quorum-consensus pipeline can work beyond WhatsApp. Adding support for Telegram forwards or SMS chain messages will let the same infrastructure verify claims from other closed messaging networks. These platforms share the same problem of hiding misinformation from standard search engines.
