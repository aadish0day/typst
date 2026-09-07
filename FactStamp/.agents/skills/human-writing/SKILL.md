---
name: human-writing
description: Use when generating or editing any prose a human will read as human-written — essays, articles, blog posts, newsletters, emails, LinkedIn/X posts, landing copy, scripts, cover letters, reports. Also applies to the explanatory prose *inside* structured notes, wikis, and reference docs (definitions, "why it matters" paragraphs, callout bodies, teaching text) even when another skill governs the document's overall structure — apply these prose principles to those paragraphs while leaving that skill's tables, headers, bullets, code blocks, and diagrams untouched. Produces writing with a real stance, concrete detail, and varied rhythm, and strips the patterns that mark text as machine-generated. Do NOT use for the structured elements themselves — code, tables, headers, API field lists — where uniformity is a feature, not a flaw.
---

# Human Writing

## The actual problem

Banned-word lists don't fix AI prose. A writer who avoids "delve" and "tapestry" still produces obvious AI slop, because the tells are symptoms, not causes. There are three root causes:

**1. Risk aversion.** The model won't commit. It surveys a topic instead of arguing about it. This produces hedging, both-sides conclusions, and paragraphs that end weaker than they started.

**2. Retrieval instead of specificity.** The model reaches for the category ("many companies," "studies show," "experts agree") because the category is always safely true. Specifics are falsifiable, which is exactly why they read as human.

**3. Uniform generation.** Every sentence gets roughly equal effort, so every sentence comes out roughly the same length and shape. Human writing is lumpy — some sentences are throwaways, some carry everything.

Fix these three and most of the surface tells disappear on their own. The rest of this skill is how.

## Before you write

Answer these. If you can't, the draft will drift toward slop by default.

- **What's the claim?** One sentence, arguable. If nobody could disagree with it, it's not a claim, it's a topic. "Remote work has pros and cons" is a topic. "Remote work fails for junior employees specifically" is a claim.
- **Who's reading, and what do they already know?** This sets what you can skip. Most AI bloat is explaining things the reader already knows.
- **What's the one thing they should remember?** Everything that doesn't serve it is cuttable.
- **What would a smart reader object to?** Address the strongest objection directly. Don't neutralize it by giving equal airtime to everything.

## Drafting principles

### Commit to a position

Say the thing. Then qualify once, if it's genuinely needed, and move on.

> ❌ This approach could potentially lead to results that may improve outcomes in certain cases, though results may vary depending on circumstances.

> ✅ This works. The exception is teams under five people, where the overhead costs more than the process saves.

The second version is more useful *and* more honest — it names the actual exception instead of gesturing at the existence of exceptions.

### Prefer the falsifiable

Replace every category noun with an instance. If you can't name one, that's a signal the claim is weaker than it sounded.

> ❌ Many companies have seen significant success by adopting this strategy.

> ✅ Basecamp has run on a four-day summer week since 2008 and hasn't reported a revenue dip for it.

If you're an AI without access to verified specifics, say so plainly ("I don't have a specific example here") rather than inventing a plausible-sounding one. A hedged-but-honest sentence beats a confident fabrication.

### Write lumpy

Let sentence length track importance. Short sentences land points. Long sentences do the work of getting somewhere. A paragraph of five medium sentences is the shape of a paragraph that hasn't decided what matters.

> ❌ The market grew steadily last year. Consumers responded well to the changes. Sales increased across most categories. Analysts remained cautiously optimistic.

> ✅ The market grew. What surprised everyone was where it grew — not in the premium tier that got all the investment, but in the cheap end nobody had bothered to defend. Analysts are still calling it a blip.

### Cut the scaffolding

The connective tissue AI generates is almost always removable. Openers that set a scene, transitions that announce a transition, closings that summarize what was just read. Delete them and check whether anything was lost. Usually nothing was.

> ❌ In today's rapidly evolving digital landscape, businesses must adapt. Moreover, they need to consider their customers. In conclusion, adaptation is key to success.

> ✅ Most companies adapt too late, and the reason is boring: the people who notice first aren't the people who decide.

### Structure should be a consequence, not a template

Don't decide "I'll make three points" and then find three points. Write what the argument requires. If it's two points, it's two points. If one section needs six paragraphs and another needs one line, that's fine — that asymmetry is itself information about what matters.

Same for formatting. Headers and bullets are for content the reader will *scan and return to* (steps, options, reference). Prose that's meant to be read start-to-finish should be prose. Bulleting an argument breaks the logical connections that made it an argument.

## The specific tells, and what to do instead

Reference list. Each has a replacement, not just a prohibition.

| Tell | Instead |
|---|---|
| "In today's fast-paced world…" | Open on the claim, a specific, or a scene |
| Restating the question first | Answer in sentence one |
| "Moreover / Furthermore / Additionally" between paragraphs | No connector; start the next idea cold |
| Buzzwords: delve, tapestry, landscape, robust, seamless, unlock, elevate, foster, leverage, empower, holistic, game-changer | The plain verb you actually meant |
| Reflexive rule-of-three ("fast, reliable, and efficient") | The number of items that's true — often one |
| Stacked hedges ("could potentially… may sometimes") | One clear claim + one named exception |
| Both-sides non-conclusion | Pick. Name what would change your mind |
| "Many companies / studies show / experts agree" | A named instance, or an admission you don't have one |
| Five same-length sentences in a row | Vary deliberately; one short sentence per paragraph |
| "In conclusion / To summarize" | Stop at the last real point |
| Em dash as a drama beat ("not just good—extraordinary") | Period, comma, or rewrite. Keep em dashes for true asides |
| "It's not X, it's Y" as a punchline | Say Y. If X needed refuting, refute it properly |
| ✅🚀❌ as bullets | Real bullets, or prose |

## Revision pass

Draft first, then run this. Don't try to obey everything while generating — it produces stilted output. Fix it in the edit.

1. **Delete the first paragraph.** Read what's left. If it still works, the first paragraph was throat-clearing. This is true more often than expected.
2. **Delete the last paragraph.** Same test.
3. **Highlight every claim.** For each: could a reasonable person disagree? If no claim in the piece is arguable, there's no piece.
4. **Search for category nouns** — companies, people, studies, experts, users, businesses. Each one is a place a specific belongs.
5. **Read sentence lengths only.** If they're all 12–20 words, break something.
6. **Read it aloud.** Anything you'd never say out loud, cut or rewrite. This catches more than any list.
7. **Check the ending.** Does it stop, or does it wind down? Stopping is better.

## When to bend this

These rules serve readability, not the reverse.

- **Technical docs, SOPs, reference material:** the *structure* — headers, bullets, tables, code blocks, fixed formats — stays uniform; predictability there is the point, so ignore the rhythm/structure guidance for those elements. But the *prose inside* them (definitions, explanations, "why it matters," callout text) should still commit instead of hedge, use the specific mechanism instead of the vague category, and skip the buzzwords and scaffolding. A reference doc can have a rigid skeleton and still have sentences a human actually wrote.
- **Legal, medical, safety writing:** hedging is often accurate, not evasive. "May cause drowsiness" is precise. Keep it.
- **Genuinely contested questions:** even-handedness is honest, not cowardly. The tell isn't presenting both sides — it's presenting both sides to *avoid* concluding. Present them, then say what you think the evidence favors and why.
- **The user's own voice:** if they've supplied samples or a style guide, that outranks everything here. Match them.

The failure mode of this skill is prose that's aggressively punchy, contrarian for its own sake, and allergic to nuance. That's a different flavor of bad writing, and just as recognizable. The goal is a piece that reads like a specific person thought about a specific thing — not a piece that performs not-being-an-AI.
