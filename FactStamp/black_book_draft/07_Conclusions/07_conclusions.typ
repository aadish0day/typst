= Conclusions

== Fulfillment of project objectives

FactStamp set out to close the gap described in Chapter 1: WhatsApp forwards spread misinformation faster than institutional fact-checkers or unstructured group chats can respond. The result is a working web application, and every claim in this report can be traced to a file in its source tree. The evaluation below maps the implementation against the eight objectives in Section 1.2:

+ *Reduce the time-to-debunk.* Users submit claims to the web app directly instead of waiting for an institutional fact-checker to notice a forward. The multimodal submission pipeline takes text or screenshots and routes both into the verification queue.
+ *Eliminate redundant verification effort.* The Jaccard token-overlap duplicate detector (`src/lib/duplicateDetection.ts`, threshold $>= 0.75$) recognizes a resubmitted claim even when its wording differs slightly, and returns the existing verdict instead of queueing the claim again.
+ *Replace single-source trust with a distributed quorum.* No single verifier or moderator can settle a verdict. `src/contexts/ClaimsContext.tsx` and `src/services/firebaseService.ts` both require at least three verifications before a claim resolves, and `firestore.rules` re-validates every verification write on the server (Case C of the `claims/{claimId}` update rule), so a client cannot forge or replace verifications.
+ *Weight consensus by evidence quality, not headcount.* The weighted confidence engine in `src/lib/confidenceScore.ts` uses the formula `Confidence = 0.40×Agreement + 0.30×Reputation + 0.30×SourceQuality`. Under it, a unanimous vote from low-reputation verifiers citing weak sources scores lower than one backed by trusted verifiers and authoritative citations.
+ *Make verified facts shareable in the native medium of the misinformation.* The `html-to-image`-based card generator (`src/components/FactCheckCard.tsx`) exports a 1080px-wide PNG, rasterized from a 540px-wide card at a 2#sym.times pixel ratio, with a height that grows with the claim text and source list. The card fits WhatsApp's dimensions and carries the verdict, confidence score, and cited sources back into the forward chains where the claim started.
+ *Lower the barrier to submission for non-technical users.* This objective is partially met. Client-side OCR (`src/services/ocrService.ts`, Tesseract.js) extracts text from screenshots and strips WhatsApp chat chrome automatically, but it currently works only for English-script forwards (see Section 7.2).
+ *Build verifier accountability over time.* A verifier's reputation rises or falls according to whether they agreed with the final consensus, and that score feeds the confidence weighting of every later claim they verify.
+ *Give the public visibility into misinformation trends.* The Recharts-powered analytics dashboard (`src/pages/Dashboard.tsx`, `src/lib/weeklyReport.ts`) shows category volumes and rolling weekly reports of the most frequently debunked claims.

Objective 6 is the only one not fully met. Section 7.2 covers the English-only OCR constraint in detail.

=== Significance of the system

FactStamp introduces no new algorithms and does not use AI to reach verdicts; it relies on human judgment and cited sources. Its contribution is architectural and social: it fills the gap between the two main ways fact-checking is done today.

Institutional fact-checkers such as PIB Fact Check, AltNews, and BOOM Live are reliable but slow. A small professional team cannot keep up with the daily volume of WhatsApp forwards about health, politics, finance, and religion, and a long-form article cannot compete for attention with a sensational message in a chat thread. Informal debunking in a group chat, usually someone replying that a message is fake, is fast, but it leaves no lasting record and no citations, and it cannot recognize the same claim when it comes back reworded.

FactStamp takes on both sets of problems. It is:

- *Decentralized*. Verification authority sits with a community quorum instead of an editorial desk, so throughput grows with the number of active verifiers rather than being capped by a newsroom's headcount.
- *Zero-infrastructure-cost*. The platform runs on Firebase's free Spark tier and static hosting, with no paid servers, paid vision APIs, or advertising revenue. The running costs that constrain institutional fact-checkers do not apply to it.
- *Privacy-preserving*. OCR runs on the user's device through WebAssembly. WhatsApp screenshots often show names and phone numbers in the chat header, and the system never sends them to a third-party cloud vision API. Everything stays on the device until the user submits the extracted text.
- *Source-transparent*. Every verdict comes with a visible list of cited URLs and an explicit confidence formula, which neither a newsroom's internal review nor an unsourced group-chat reply offers.

Within the scope of a BSc Information Technology capstone, the project shows that quorum-based verification, with human judgment and cited sources, can run at zero infrastructure cost.

== Limitations of the system

The current implementation has the following limitations, grouped by type of risk.

=== Coverage & accuracy limitations

- *English-only OCR.* The Tesseract.js model in `src/services/ocrService.ts` handles only Latin-script English text. For a WhatsApp forward in Devanagari or another Indic script, users cannot extract the text from a screenshot and have to type it in themselves. Much of India's WhatsApp misinformation is in Hindi and regional languages, so this limits which messages the system can take in easily.
- *Lower OCR accuracy than commercial cloud vision APIs.* Running OCR in the browser with WebAssembly protects privacy and costs nothing (Section 2.5), but it gives up accuracy. Cloud models such as Google Cloud Vision read low-resolution or heavily compressed WhatsApp screenshots better. `cleanExtractedOcrText()` removes chat-interface noise and users can correct the text by hand, but the browser-side WASM model still sets a lower ceiling on recognition quality.
- *No direct WhatsApp Business API integration.* FactStamp cannot read WhatsApp messages on its own. There is no chatbot or Business API listener inside WhatsApp, so users have to paste text or upload screenshots into the web app, and that manual step adds friction a native integration would remove.

=== Trust & governance limitations

- *Quorum consensus assumes baseline good-faith participation.* The 3-verifier quorum and the reputation-weighted confidence score make manipulation by fake accounts harder, but the system still depends on most participants acting honestly. While the user base is small, a coordinated group of malicious accounts could capture a quorum before the reputation system brings their scores down. Reputation weighting reduces this risk over time; it cannot remove it while the verifier pool stays small.
- *Source-quality scoring depends on a small hardcoded domain list.* `src/lib/confidenceScore.ts` sorts cited sources into high, medium, and low quality using fixed lists; for example, `who.int` and `pib.gov.in` are high and `bbc.com` is medium. Any credible domain missing from the lists, such as a regional newspaper, a medical journal, or a state government portal, falls to low quality. Valid verifications therefore lose weight only because their sources were never added.

=== Architectural & scaling limitations

- *Quorum threshold duplicated as a bare literal across the application layers.* The three-verification rule has no named constant. `>= 3` is hardcoded in six places across `ClaimsContext.tsx` and `firebaseService.ts`, so changing the quorum size means updating all six at once, and missing one would put the queue, the consensus trigger, and the expiry sweep out of step. `firestore.rules` checks the structure of each verification write (Case C of the `claims/{claimId}` update rule) but not the total count, so the quorum is enforced by the client, not by the database.
- *No automated test suite.* `package.json` defines scripts only for `dev`, `build`, `preview`, `typecheck`, `emulators`, `seed:db`, `create:admin`, and `create:user`. There is no `test` script and there are no unit or integration tests; CI runs only the typecheck and build, and verification relied on manual walkthroughs. Logic errors in duplicate detection, the consensus formula, or the security rules have to be caught by a human tester before deployment.
- *Image storage capped by the Firestore-embedded approach.* To stay on the Firebase free tier, `src/lib/imageCompression.ts` compresses uploaded screenshots and stores them as base64 strings inside the Firestore claim document. This avoids an object-storage bucket but caps each claim's image at about 800 KB, and at scale it will run into Firestore's document size limit and read costs. `storage.rules` already defines an unused `claim_screenshots` path, and moving the image flow onto it would allow much larger image volumes.

== Future scope of the project

The follow-up work comes from the limitations above. It splits into near-term changes to the current system and long-term changes that need larger architectural shifts.

=== Near-term scope

- *Multi-language OCR (Devanagari and other Indic scripts).* Adding trained Indic language models to the Tesseract.js pipeline would remove the English-only restriction and let the system read Hindi and regional-language forwards that currently have to be typed by hand. Since most Indian misinformation is in languages other than English, this is the highest-impact near-term change.
- *Expanding the source-quality domain list into a maintained, community-curatable credibility database.* Replacing the hardcoded domain list in `confidenceScore.ts` with a database the community can extend would let users add legitimate regional or specialist sources, so those sources stop defaulting to low quality just because nobody listed them. The confidence formula itself would not need to change.
- *Consolidating the quorum threshold into a single source of truth.* Replacing the hardcoded `>= 3` checks in the client Context and service layer with one shared constant, or a Firestore remote-config value, would mean a future change to the quorum size takes one edit instead of six. Putting the value in `firestore.rules` as well would let the server enforce the quorum.
- *An appeal / re-review workflow for CONTESTED claims.* Claims that become `CONTESTED` after the 7-day deadline currently have no way back into active review. An appeal flow would let fresh verifiers examine these ambiguous claims instead of leaving them unresolved, since an unresolved claim gives the public no clear answer.
- *A basic automated test suite.* Unit tests for the Jaccard duplicate-detection threshold and the weighted consensus formula, plus integration tests run against the Firebase Local Emulator Suite, would close the testing gap and catch regressions in the core scoring logic before deployment.

=== Long-term scope

- *WhatsApp Business API / chatbot-based direct submission.* Connecting FactStamp to the WhatsApp Business API would let users forward a suspicious message straight to a FactStamp bot number instead of copying text or uploading screenshots to the web app, so they could use the tool without leaving WhatsApp.
- *Migrating large images to Firebase Storage as the primary flow.* Screenshots are currently compressed into base64 strings inside Firestore documents, while the `claim_screenshots` path in `storage.rules` sits unused. Making Storage-backed images the default would remove the 800 KB-per-claim cap and let the platform handle far more images without hitting Firestore's document-size and read-cost limits.
- *A mobile app wrapper (React Native or installable PWA).* An installable Progressive Web App or a React Native wrapper would put FactStamp on users' home screens and give it native push notifications. Most WhatsApp forwarding happens on phones, where reopening a browser tab is a poor substitute for an app.
- *A browser extension for one-click submission.* A browser extension would let users right-click a web page or chat screenshot and send it to FactStamp without opening the web app first. That would make it easier to submit misinformation that starts on the open web before it reaches WhatsApp groups.
- *Push notifications (web push) instead of only in-app notifications.* Today, users learn that their claim has reached consensus only by opening the app. Web push notifications would tell them as soon as verification finishes.
- *Multi-tenant support for other messaging platforms (Telegram, SMS forwards).* The submission, duplicate-detection, and quorum-consensus pipeline is not specific to WhatsApp. Supporting Telegram forwards and SMS chain messages would let the same system check claims from other closed messaging networks, which hide misinformation from search engines in the same way.
