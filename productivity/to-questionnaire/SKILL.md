---
name: to-questionnaire
description: Turn a decision you can't fully answer into a questionnaire for someone else to fill in.
disable-model-invocation: true
---

Turn something the user can't answer alone into a **questionnaire**: a Markdown document they hand to one person to fill in async, or fill out together over a meeting. The recipient holds knowledge the user lacks; the questionnaire pulls it out of them.

**Grill the send, not the subject.** Interview the user only about the _send_, which they can always answer: who it goes to, and what they need back. The questions in the document then target the **gap** between what the recipient knows and what the user needs.

1. **Who is it going to?** Ask, in one exchange, the recipient's role, expertise, and relationship to the user. This fixes the questionnaire's tone and how much context it must carry. Done when you know who the recipient is and what they know that the user doesn't.

2. **What do you need back?** Ask, in one exchange, the specific decisions or facts the user can't resolve alone and needs from this person. Done when you have a concrete list of what the user must walk away able to do or decide.

3. **Write the questionnaire.** Draft questions aimed at the gap from steps 1–2, following the Document structure below. Write it to `to-questionnaire-<slug>.md` in the current directory (slug from the topic) and report the path. Done when the file exists and every item the user named in step 2 is covered by a question.

## Asking for the gap (step 2, sharpened)

When you dig for what the user needs back, don't accept "they can tell me more about the feature." Push for the decisions:

- What will you *do* with the answer? ("I need to file the launch plan" → the questionnaire must end with launch decisions.)
- Which choice, if made wrongly today, would be expensive to reverse? Those are the questions to front-load.
- What have they already decided, so the questionnaire doesn't reopen settled ground?

Aim for a boundary, not a wish list: the questionnaire covers the gap and *only* the gap. Asking for things the user already knows wastes the recipient's goodwill and buries the real questions.

## Document structure

Frame the document as a **discovery questionnaire**: the user lacks context, the recipient holds it. Order questions most-important-first, since async means you may only get one pass, and group them under `##` headings by theme once there are more than a handful. Write it using the template below.

<questionnaire-template>

# <Questionnaire title>

**Purpose:** why this questionnaire exists and the decision riding on it.

**From:** <the user>, **To:** <the recipient>, **How your answers will be used:** <where they go>

## Context

One paragraph orienting a recipient who wasn't in the user's head. Enough to answer well, not a page.

## How to answer

Deadline and rough effort. Partial answers and "I don't know" are useful: flag anything you're unsure of rather than skipping it.

## <Theme heading>

One `##` section per theme. Under each, its questions, most-important-first. Every question is one idea, never compound, with an answer stub directly beneath, and a one-line _why this matters_ only where the question could be misread or invite a throwaway answer.

<question-example>
### What load is the system expected to handle at launch?

_Why this matters: it decides whether we provision for burst traffic now or defer it._

>
</question-example>

## Anything else?

A closing catch-all: anything we didn't ask that we should know?

</questionnaire-template>

## Question-crafting rules

- **One idea per question.** "What's the budget and who approves it?" is two questions; splitting them protects against the recipient answering only the half they know and skipping the rest.
- **Make it answerable, not essayable.** Prefer a bounded, concrete ask — a target number, a yes/no, a recommendation among named options, a priority ranking — over "how do you feel about X?" An answer stub (`>`) directly under each question makes it cheap to write and forces one concrete response.
- **Name the options when they exist.** If the user can enumerate the plausible answers ("EC2, Lambda, or managed DB?"), list them. It turns an open question into a decision and saves the recipient typing a blank page.
- **Ask for confidence, not just certainty.** When an answer will be relied on, invite a confidence marker ("How sure are you on a 1–5?"). It lets the user weigh the answer instead of trusting it blindly.
- **Respect the recipient's time.** Every question should trace back to a decision in step 2. If a question doesn't change what the user can do next, cut it.
- **Don't lead.** Avoid phrasing that nudges toward the user's preferred answer; the recipient's independent read is the whole point.