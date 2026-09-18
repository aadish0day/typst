#import "../lib/helpers.typ": *

= Implementation and testing

== Implementation approach

=== Project summary

FactStamp is a community fact-checking web application for WhatsApp forwards. Users submit claims as text or screenshots, duplicates are detected automatically, community verifiers review each claim, and a weighted consensus produces a verdict that can be shared as a PNG card. The system is built as a single-page application with React, TypeScript, and Tailwind CSS, and uses Firebase for sign-in, the database, and one Cloud Function. It grew one module at a time: each was wired up and checked against the Firebase Local Emulator Suite before the next was started, so a problem in the duplicate check or the consensus engine surfaced before anything downstream depended on it.

#pagebreak()
== Coding details and code efficiency

Each of the eight modules from Chapter 4 keeps to its own part of the codebase, from authentication through to the security layer. Where two of them need the same logic, such as scoring a cited source or checking an explanation, that logic sits in one shared function instead of being copied, and a write the database refuses surfaces as an error to the user rather than being swallowed.

=== Coding details

==== Main modules

The three modules below contain the core logic that makes FactStamp different from a normal submission form. Their code is shown in full, exactly as it appears in the source files.

*1. Duplicate Detection Engine*

The engine normalizes the claim text, splits it into words longer than three characters, and calculates Jaccard similarity (shared words divided by all distinct words) against existing claims. If the best match is 0.75 or higher, the Submit page shows the existing claim and blocks the new submission, so the same claim is not queued twice.

#block(sticky: true)[*`src/lib/duplicateDetection.ts` (full file)*]

```typescript
function normalize(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s]/g, '')   // remove punctuation
    .replace(/\s+/g, ' ')      // normalize whitespace
    .trim()
}

function tokenize(text: string): Set<string> {
  return new Set(
    normalize(text)
      .split(/\s+/)
      .filter((word) => word.length > 3) // ignore short words
  )
}

function jaccardSimilarity(a: string, b: string): number {
  const setA = tokenize(a)
  const setB = tokenize(b)

  if (setA.size === 0 && setB.size === 0) return 1
  if (setA.size === 0 || setB.size === 0) return 0

  let intersection = 0
  for (const word of setA) {
    if (setB.has(word)) intersection++
  }

  const union = setA.size + setB.size - intersection
  return intersection / union
}

export function findDuplicate(
  text: string,
  existingClaims: Array<{ id: string; text: string }>,
  threshold = 0.75
): { id: string; text: string; similarity: number } | null {
  const normalized = normalize(text)

  let bestMatch: { id: string; text: string; similarity: number } | null = null

  for (const claim of existingClaims) {
    const similarity = jaccardSimilarity(normalized, claim.text)
    if (similarity >= threshold && (!bestMatch || similarity > bestMatch.similarity)) {
      bestMatch = { id: claim.id, text: claim.text, similarity }
    }
  }

  return bestMatch
}
```

#block(sticky: true)[*`src/pages/Submit.tsx` (where the engine is used)*]

```tsx
  const checkDuplicate = useCallback(() => {
    if (claimText.trim().length < 20) return
    const result = findDuplicate(claimText, claims.map((c) => ({ id: c.id, text: c.text })))
    if (result && !duplicateFound) {
      toast('Similar claim found', {
        description: `This matches an existing claim (${Math.round(result.similarity * 100)}% similar). View the existing verdict to avoid duplication.`,
        icon: <AlertTriangle className="w-5 h-5 text-[var(--color-v-mislead)]" />,
      })
    }
    setDuplicateFound(result)
  }, [claimText, claims, duplicateFound])

  // inside handleSubmitAction(): a duplicate stops the submission
    if (duplicateFound) {
      toast.error('Duplicate claim', {
        description: 'This claim has already been verified by the community. View the existing verdict instead.',
      })
      throw new Error('Duplicate claim')
    }
```

*2. Community Verification System*

A claim can be verified only by a signed-in user who did not submit it and has not already verified it, and only until three verifications are reached. The verifier gives a verdict, a source URL, and an explanation; the explanation is checked for length and spam, and the verification is then added to the claim and saved to Firestore.

#block(sticky: true)[*`src/lib/types.ts` (who may verify a claim)*]

```typescript
export function canVerify(claim: Claim, uid: string | undefined): boolean {
  if (!uid) return false
  if (claim.status !== 'pending') return false
  if (claim.submittedBy === uid) return false
  if (claim.verificationCount >= REQUIRED_VERIFICATIONS) return false
  return !claim.verifications.some((v) => v.verifierId === uid)
}
```

#block(sticky: true)[*`src/lib/security.ts` (explanation validation)*]

```typescript
export interface ExplanationValidationResult {
  valid: boolean
  error?: string
  warning?: string
  charCount: number
  wordCount: number
  minChars: number
  maxChars: number
  minWords: number
}

export function validateVerdictExplanation(
  rawText: string,
  claimText?: string
): ExplanationValidationResult {
  const minChars = 50
  const maxChars = 1500
  const minWords = 8

  const text = rawText.trim()
  const charCount = text.length
  const words = text ? text.split(/\s+/).filter(Boolean) : []
  const wordCount = words.length

  // 1. Minimum character length (defense against empty/incomplete verification)
  if (charCount < minChars) {
    return {
      valid: false,
      error: `Explanation is too short (${charCount}/${minChars} characters). Please detail why the source supports your verdict.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 2. Maximum character length (defense against payload bloat & Firestore document limit)
  if (charCount > maxChars) {
    return {
      valid: false,
      error: `Explanation exceeds the maximum limit (${charCount}/${maxChars} characters). Please keep it concise.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 3. Minimum word count (prevents single-word gibberish string padding like 'aaaaa...')
  if (wordCount < minWords) {
    return {
      valid: false,
      error: `Explanation must contain at least ${minWords} words (currently ${wordCount}). Please write complete sentences explaining the facts.`,
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 4. Excessive repetitive character spam (e.g., 'aaaaaa', '......', '!!!!!!')
  if (/(.)\1{5,}/.test(text)) {
    return {
      valid: false,
      error: 'Explanation contains repetitive character patterns. Please write substantive reasoning.',
      charCount,
      wordCount,
      minChars,
      maxChars,
      minWords,
    }
  }

  // 5. Repeated word spam (e.g., 'fake fake fake fake')
  const lowerWords = words.map((w) => w.toLowerCase().replace(/[^a-z0-9]/g, ''))
  for (let i = 0; i < lowerWords.length - 2; i++) {
    if (lowerWords[i] && lowerWords[i] === lowerWords[i + 1] && lowerWords[i] === lowerWords[i + 2]) {
      return {
        valid: false,
        error: 'Explanation contains repetitive words. Please provide diverse factual evidence.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 6. Generic cop-out & filler phrases
  const lower = text.toLowerCase()
  const copOuts = [
    'just trust me',
    'trust me bro',
    'check it yourself',
    'search it on google',
    'search google',
    'idk',
    'i don\'t know',
    'random text to fill space',
    'asdfasdf',
    'qwertyuiop',
  ]
  for (const phrase of copOuts) {
    if (lower.includes(phrase)) {
      return {
        valid: false,
        error: 'Explanation contains low-effort filler phrases. Please cite concrete findings from the source.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 7. Duplicate of claim text check (copy-pasting the claim back)
  if (claimText && claimText.trim().length >= 30) {
    const cleanClaim = claimText.trim().toLowerCase()
    if (lower === cleanClaim || (lower.includes(cleanClaim) && text.length < claimText.length + 30)) {
      return {
        valid: false,
        error: 'Explanation cannot simply repeat the claim text. Please explain your research findings.',
        charCount,
        wordCount,
        minChars,
        maxChars,
        minWords,
      }
    }
  }

  // 8. Constructive quality guidance
  let warning: string | undefined
  const hasEvidenceTerms = /(source|report|article|study|ministry|official|evidence|archive|debunk|confirmed|stated|found|according|data|analysis|fact)/i.test(text)
  if (!hasEvidenceTerms) {
    warning = 'Tip: Mention specific evidence or quotes from your cited source to increase community trust.'
  }

  return {
    valid: true,
    warning,
    charCount,
    wordCount,
    minChars,
    maxChars,
    minWords,
  }
}
```

#block(sticky: true)[*`src/pages/VerifyDetail.tsx` (submitting a verdict)*]

```tsx
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    const newErrors: Record<string, string> = {}
    if (!verdict) newErrors.verdict = 'Please select a verdict rating.'

    if (!sourceUrl.trim()) {
      newErrors.sourceUrl = 'Please provide a valid source URL.'
    } else {
      try {
        const parsed = new URL(sourceUrl.trim())
        if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
          newErrors.sourceUrl = 'Only standard HTTP or HTTPS links are permitted.'
        }
      } catch {
        newErrors.sourceUrl = 'Please enter a valid URL (e.g. https://pib.gov.in).'
      }
    }

    const cleanExplanation = sanitizeTextInput(explanation.trim())
    const explValidation = validateVerdictExplanation(cleanExplanation, claim.text)
    if (!explValidation.valid) {
      newErrors.explanation = explValidation.error || 'Please provide a detailed explanation of your findings.'
    }

    setErrors(newErrors)
    if (Object.keys(newErrors).length > 0) {
      toast.error('Please resolve the errors below before submitting.')
      return
    }

    setLoading(true)

    try {
      await addVerification(claim.id, {
        verdict: verdict!,
        sourceUrl: sourceUrl.trim(),
        explanation: cleanExplanation,
        verifierId: user?.uid || '',
        verifierName: user?.displayName || 'Independent Verifier',
        verifierReputation: user?.reputation ?? 50,
      })
      toast.success('Verdict recorded successfully.')
      setSubmitted(true)
    } catch (err) {
      // Success is only claimed once the database has accepted the verdict.
      console.error('Verdict write failed:', err)
      toast.error('Your verdict was not saved.', {
        description: 'The database rejected the write. Check your connection and try again.',
      })
    } finally {
      setLoading(false)
    }
  }
```

#block(sticky: true)[*`src/contexts/ClaimsContext.tsx` (saving the verification)*]

```tsx
  const addVerification = useCallback(
    async (claimId: string, data: AddVerificationInput): Promise<void> => {
      const target = claims.find((c) => c.id === claimId)
      if (!target) throw new Error('That claim no longer exists.')

      const updatedClaim = computeUpdatedClaim(target, data)

      localClaimsRef.current = [
        updatedClaim,
        ...localClaimsRef.current.filter((c) => c.id !== claimId),
      ]

      setClaims((prev) =>
        prev.map((c) => (c.id === claimId ? updatedClaim : c))
      )

      if (isFirebaseConfigured) {
        try {
          // This used to be fire-and-forget with a console.warn. A verdict the
          // rules rejected still showed "recorded successfully" and vanished on
          // the next reload, so the write result now decides what the UI says.
          await updateClaimInFirestore(updatedClaim)
        } catch (err) {
          // Roll the optimistic update back so the UI matches the database.
          localClaimsRef.current = [
            target,
            ...localClaimsRef.current.filter((c) => c.id !== claimId),
          ]
          setClaims((prev) => prev.map((c) => (c.id === claimId ? target : c)))
          throw err
        }
      }
    },
    [claims, user]
  )
```

*3. Confidence Scoring and Consensus Engine*

The confidence score combines the agreement ratio (40%), the average reputation of the verifiers (30%), and the average source quality (30%). Source quality is 100 for trusted official domains, 70 for established news sites, and 30 for any other link. Each new verification recalculates the majority verdict and score, and the claim is marked verified once it has three verifications. After a verification is saved, a Cloud Function updates each verifier's reputation: +2 if their verdict matched the final verdict and -1 if it did not.

#block(sticky: true)[*`src/lib/confidenceScore.ts` (full file)*]

```typescript
export function calculateConfidenceScore(
  verifications: Array<{
    verdict: string;
    verifierReputation: number;
    sourceQuality: number; // 0–100
  }>,
): {
  score: number;
  agreementRatio: number;
  avgReputation: number;
  sourceQualityScore: number;
} {
  if (verifications.length === 0) {
    return {
      score: 0,
      agreementRatio: 0,
      avgReputation: 0,
      sourceQualityScore: 0,
    };
  }

  // 1. Agreement ratio: How many verifications agree with the majority verdict
  const verdicts = verifications.map((v) => v.verdict);
  const majorityCount = Math.max(
    ...Array.from(new Set(verdicts)).map(
      (v) => verdicts.filter((x) => x === v).length,
    ),
  );
  const agreementRatio = (majorityCount / verifications.length) * 100;

  // 2. Average reputation of all verifiers
  const avgReputation =
    verifications.reduce((sum, v) => sum + v.verifierReputation, 0) /
    verifications.length;

  // 3. Source quality score (average)
  const sourceQualityScore =
    verifications.reduce((sum, v) => sum + v.sourceQuality, 0) /
    verifications.length;

  // Weighted calculation
  const score = Math.round(
    agreementRatio * 0.4 + avgReputation * 0.3 + sourceQualityScore * 0.3,
  );

  return {
    score: Math.min(100, Math.max(0, score)),
    agreementRatio,
    avgReputation,
    sourceQualityScore,
  };
}

const HQ_DOMAINS = new Set([
  "who.int",
  "nih.gov",
  "ncbi.nlm.nih.gov",
  "pib.gov.in",
  "eci.gov.in",
  "mohfw.gov.in",
  "icmr.gov.in",
  "ayush.gov.in",
  "ceodelhi.gov.in",
  "wikipedia.org",
  "indiacode.nic.in",
  "rbi.org.in",
]);
const MQ_DOMAINS = new Set([
  "timesofindia.indiatimes.com",
  "indianexpress.com",
  "thehindu.com",
  "bbc.com",
  "bbc.in",
  "reuters.com",
  "apnews.com",
  "ndtv.com",
  "economictimes.com",
  "factcheck.org",
  "iitm.org",
  "snopes.com",
]);

function hostMatches(host: string, domain: string): boolean {
  return host === domain || host.endsWith("." + domain);
}

export function determineSourceQuality(url: string): "high" | "medium" | "low" {
  try {
    const parsed = new URL(url);
    if (parsed.protocol !== "http:" && parsed.protocol !== "https:") return "low";
    const host = parsed.hostname.toLowerCase().replace(/\.$/, "");
    if (Array.from(HQ_DOMAINS).some((hq) => hostMatches(host, hq))) return "high";
    if (Array.from(MQ_DOMAINS).some((mq) => hostMatches(host, mq))) return "medium";
    return "low";
  } catch {
    return "low";
  }
}

export function sourceQualityToScore(
  quality: "high" | "medium" | "low",
): number {
  switch (quality) {
    case "high":
      return 100;
    case "medium":
      return 70;
    case "low":
      return 30;
  }
}
```

#block(sticky: true)[*`src/contexts/ClaimsContext.tsx` (consensus after each verification)*]

```typescript
function computeUpdatedClaim(claim: Claim, data: AddVerificationInput): Claim {
  const sourceQuality = determineSourceQuality(data.sourceUrl)

  const newVerification: Verification = {
    id: `v${Date.now()}`,
    claimId: claim.id,
    verdict: data.verdict,
    sourceUrl: data.sourceUrl,
    sourceQuality,
    explanation: data.explanation,
    verifierId: data.verifierId,
    verifierName: data.verifierName,
    verifierReputation: data.verifierReputation,
    createdAt: new Date().toISOString(),
  }

  const updatedVerifications = [...claim.verifications, newVerification]

  // Calculate new confidence score
  const verifData = updatedVerifications.map((v) => ({
    verdict: v.verdict,
    verifierReputation: v.verifierReputation,
    sourceQuality: sourceQualityToScore(v.sourceQuality),
  }))
  const confidence = calculateConfidenceScore(verifData)

  // Determine majority verdict
  const verdictCounts: Record<string, number> = {}
  updatedVerifications.forEach((v) => {
    verdictCounts[v.verdict] = (verdictCounts[v.verdict] || 0) + 1
  })
  const majorityVerdict = Object.entries(verdictCounts).sort(
    (a, b) => b[1] - a[1]
  )[0][0] as Verdict

  // A claim is 'verified' when it has at least 3 verifications
  const isVerified = updatedVerifications.length >= 3

  return {
    ...claim,
    verifications: updatedVerifications,
    verificationCount: updatedVerifications.length,
    status: isVerified ? 'verified' : 'pending',
    // Stamp the moment consensus closed. Without this, claims verified through
    // the app had no verifiedAt at all and every "recently verified" list fell
    // back to createdAt.
    ...(isVerified ? { verifiedAt: claim.verifiedAt ?? new Date().toISOString() } : {}),
    verdict: majorityVerdict,
    confidenceScore: confidence.score,
    agreementRatio: confidence.agreementRatio,
    avgVerifierReputation: confidence.avgReputation,
    sourceQualityScore: confidence.sourceQualityScore,
  }
}
```

#block(sticky: true)[*`functions/index.js` (reputation update, full file)*]

```javascript
import { onDocumentUpdated } from 'firebase-functions/v2/firestore'
import { initializeApp } from 'firebase-admin/app'
import { getFirestore, FieldValue } from 'firebase-admin/firestore'

initializeApp()
const db = getFirestore()

// Mirrors the client's optimistic display maths in computeUpdatedClaim().
const AGREE_REWARD = 2
const DISAGREE_PENALTY = -1
const clamp = (n) => Math.max(0, Math.min(100, n))

export const awardVerificationReputation = onDocumentUpdated('claims/{claimId}', async (event) => {
  const before = event.data?.before.data()
  const after = event.data?.after.data()
  if (!before || !after) return

  const oldList = Array.isArray(before.verifications) ? before.verifications : []
  const newList = Array.isArray(after.verifications) ? after.verifications : []

  if (newList.length !== oldList.length + 1) return

  const appended = newList[newList.length - 1]
  const appendedBy = appended?.verifierId
  if (typeof appendedBy !== 'string' || !appendedBy) return

  const justSettled = before.status === 'pending' && after.status === 'verified'
  const alreadySettled = before.status === 'verified'
  const finalVerdict = after.verdict

  const deltas = new Map()
  if (finalVerdict) {
    const scored = justSettled ? newList : alreadySettled ? [appended] : []
    for (const v of scored) {
      const uid = v?.verifierId
      if (typeof uid !== 'string' || !uid) continue
      const delta = v.verdict === finalVerdict ? AGREE_REWARD : DISAGREE_PENALTY
      deltas.set(uid, (deltas.get(uid) ?? 0) + delta)
    }
  }

  const involved = new Set([appendedBy, ...deltas.keys()])
  const refs = [...involved].map((uid) => ({ uid, ref: db.doc(`users/${uid}`) }))

  await db.runTransaction(async (tx) => {
    const snaps = await Promise.all(refs.map(({ ref }) => tx.get(ref)))

    refs.forEach(({ uid }, i) => {
      const snap = snaps[i]
      if (!snap.exists) return

      const updates = {}
      if (uid === appendedBy) updates.totalVerifications = FieldValue.increment(1)

      const delta = deltas.get(uid)
      if (delta) {
        const current = typeof snap.data().reputation === 'number' ? snap.data().reputation : 50
        updates.reputation = clamp(current + delta)
      }

      if (Object.keys(updates).length > 0) tx.update(snap.ref, updates)
    })
  })
})
```

==== Basic modules

The supporting modules use standard techniques, so only their key function is shown.

#block(breakable: false)[
*Authentication and Verifier Profile* (`src/services/firebaseService.ts`)

Registers the user with Firebase Authentication and creates their Firestore profile with a starting reputation of 50.

```typescript
export async function signUpWithEmail(
  name: string, email: string, pass: string,
): Promise<User> {
  const userCredential =
    await createUserWithEmailAndPassword(auth, email, pass)
  const firebaseUser = userCredential.user

  const profileData: User = {
    uid: firebaseUser.uid,
    displayName: name || firebaseUser.displayName || 'Verifier',
    email: firebaseUser.email || email,
    reputation: 50, // Default reputation starting score
    totalVerifications: 0,
    joinedAt: new Date().toISOString(),
  }

  // Store Verifier Profile in Firestore
  await setDoc(doc(db, COLLECTIONS.USERS, firebaseUser.uid), {
    ...profileData,
    createdAt: serverTimestamp(),
  })
  return profileData
}
```
]

#block(breakable: false)[
*Forward Submission* (`src/services/ocrService.ts`)

Removes WhatsApp interface text (timestamps, "Forwarded" labels, network indicators) from the text that Tesseract.js extracts from a screenshot.

```typescript
export function cleanExtractedOcrText(raw: string): string {
  const lines = raw.split(/\r?\n/)
  const cleanedLines: string[] = []

  const ignorePatterns = [
    /^\s*([↪\->*#]+\s*)?forwarded\s*(many\s*times)?\s*$/i,
    /^\s*(today|yesterday|\d{1,2}\/\d{1,2}\/\d{2,4})\s*$/i,
    /^\s*(lte|4g|5g|volte|vo-wifi|wifi|jio|airtel|vi|bsnl|vodafone)\s*$/i,
    /^\s*\d{1,3}%\s*$/,
    /^\s*(type a message|message|unread messages?)\s*$/i,
  ]

  for (const line of lines) {
    const trimmed = line.trim()
    if (!trimmed) continue
    if (ignorePatterns.some((pattern) => pattern.test(trimmed))) continue
    cleanedLines.push(trimmed)
  }
  // ... paragraphs are then re-joined
}
```
]

#block(breakable: false)[
*Fact-Check Card Generator* (`src/pages/ClaimDetail.tsx`)

Converts the rendered card into a 1080 px wide PNG in the browser with `html-to-image` and downloads it.

```typescript
const handleDownloadCard = async () => {
  const wrapper = document.getElementById(
    'whatsapp-fact-check-card') as HTMLElement | null
  if (!wrapper) return

  const dataUrl = await toPng(wrapper, {
    pixelRatio: 2, // Crisp 2x high resolution (1080px wide)
    backgroundColor: '#fffbf5',
    cacheBust: true,
    skipFonts: true,
  })

  const link = document.createElement('a')
  link.download = `factstamp-${claim.id}.png`
  link.href = dataUrl
  link.click()
}
```
]

=== Code efficiency

- *Reusable functions:* duplicate detection and confidence scoring are plain functions that do not depend on React or Firebase.
- *One read per claim:* verifications are stored inside the claim document, so a claim and its verdicts load in a single read.
- *Limited data:* the app listens only to the 200 most recent claims instead of the whole collection.
- *Smaller images:* screenshots are compressed in the browser, and lists load a small thumbnail instead of the full image.
- *Code splitting:* large libraries such as Firebase, Tesseract.js, and Recharts are loaded as separate files and cached by the browser.
- *Real-time updates:* Firestore listeners update the page automatically, so the app does not need to poll the database.
- *Validation first:* input is checked in the browser before any database write is attempted.

#pagebreak()
== Testing approach

Testing was done at three levels: unit testing, integration testing, and system testing. Application testing was done by hand, and the Firestore Security Rules are also checked by an automated script (`npm run test:rules`).

=== Unit testing

Unit testing checks each function on its own.

Two identical claims produced a similarity of 1.00 and were marked as duplicates, whereas two claims on the same topic worded differently scored below 0.75 and stayed separate. For the confidence formula, three FALSE verdicts with reputations of 80, 60, and 70 and source scores of 100, 100, and 70 came out at 88, matching the value worked out by hand. An empty list of verifications returned 0 rather than raising an error, and an explanation shorter than 50 characters was rejected.

=== Integration testing

Integration testing checks that the modules work correctly with Firebase, using the local emulator.

When three different users each verified the same claim, it became verified with the expected score. A write carrying a fake reputation value was refused by the Security Rules, a signed-out user could not submit a claim, and no user could verify their own claim. Faking the admin session flag as a non-admin got nowhere: the next render returned the user to the login screen. The `test:rules` script rounded this out with 28 checks, among them forged verdicts, double voting, and direct edits to reputation, and every write it was meant to block was denied.

=== System testing

System testing checks complete user journeys on the running application.

A new account was created and its profile opened at a reputation of 50, then signed in cleanly. A screenshot was submitted and OCR filled in the claim text; a near-duplicate claim was submitted and the system blocked it; and a verdict with a short explanation drew the expected error. One claim was carried through its third verification and the resulting PNG card downloaded, an administrator overrode a verdict and the change showed up in the audit log, and the interface was switched between light and dark themes.

#pagebreak()
== Modifications and improvements

Several changes were made during development to fix problems found in testing and to improve the system:

- *Real data only:* the app first filled an empty queue with demo claims and settled overdue claims only in the browser; it now shows only real Firestore data, and administrators settle overdue claims.
- *Login protection:* a 15-minute lockout after 5 failed attempts was added to the sign-in page and the admin console.
- *Theme toggle:* one reusable light/dark theme toggle replaced different buttons on each page.
- *Fonts:* the font set was reduced to Plus Jakarta Sans and Noto Sans Devanagari, adding support for Hindi and Marathi text.
- *Card export:* the first card exporter could not read the app's modern colours, so it was replaced with html-to-image.
- *Security fixes:* the Security Rules were tightened to stop forged verdicts and double voting, demo accounts lost admin rights, and reputation updates moved to a Cloud Function.
- *Faster screenshots:* full screenshots were moved to a separate collection so lists load only small thumbnails.
