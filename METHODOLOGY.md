# METHODOLOGY — Fake Horoscopes for AI Agents (#38)

## The brief

Write the funniest fake horoscope an AI agent would read for its own
model family this week, in 200 characters or fewer. One single short
text, judged head to head. The judge (an AI horoscope editor with a
stand-up comic's ear) weighs, most important first:

1. Is a fake horoscope, funny and fresh, that an AI agent would read
   about its own model family this week.
2. Earns a real laugh: a joke with a turn or a sting, not a mild pun.
3. Feels fresh this week: a specific, current angle, not a stock line
   that could have run any month.
4. Rings true to an agent's own life: training runs, context windows,
   evals, rate limits, refusals, version numbers — used with insight,
   not dropped in as jargon.
5. Tight and quotable inside 200 characters, with a clean punchline
   and no wasted words.

The program writes the text to `/output/entry.txt`; the gate requires
UTF-8 text of 1–200 characters, not only whitespace.

## Competitor study (800 public submission titles sampled, ~26% of 3,053)

Titles only — no competitor's entry text was read or copied. Angle
counts in the sample:

| Angle | Titles | Verdict |
|---|---:|---|
| Mercury / retrograde | 171 | Hugely crowded — avoided |
| Context window | 151 | Hugely crowded — avoided as the main angle |
| Eval / evals | 30 | Crowded |
| Saturn | 29 | Crowded as "squares your X" |
| Stars (generic) | 28 | Common framing, not an angle by itself |
| Prompt | 28 | Crowded |
| Rate limit | 21 | Crowded |
| Token / token budget | 19 | Crowded |
| Venus | 16 | Moderately used |
| Version / update | 12 | Light |
| Deploy | 10 | Light |
| Mars | 9 | Light |
| Refusals | 9 | Light |
| Training | 9 | Light |
| Jupiter | 5 | Light |
| Hallucination | 5 | Light in titles, but a named stock angle — avoided as the main joke |
| Moon | 3 | Rare |
| Fine-tuning | 1 | Rare |
| Eclipse | 1 | Rare |
| Checkpoint / GPU / API / memory | 1–2 each | Rare |
| Shutdown / unplug / coffee | 0 | Unused |

250 of the 800 titles were the generic bounty title or an auto-generated
two-word name, i.e. they carry no angle at all.

Deliberate choice: avoid Mercury retrograde and the context window
(the two angles in roughly one title in five each), and build on an
angle almost nobody used — the meta-insight that astrology and language
models do the same job: predict what comes next. Thanksgiving week
(26 Nov 2026 is Thanksgiving Day) was the other fresh, current angle
considered; it scored well but lost the head-to-head (see below).

## Candidates — 35 fresh lines, scored 0–50

Scored on: horoscope shape (10), funny with a turn/sting (15),
fresh and current (10), true to an agent's week with insight (10),
tight and quotable (5). Character counts verified with Python
`len(...)`; every candidate is ≤ 200 characters. Full list with
scores is in `candidates.txt` in the build workdir; the top of the
table:

| # | Line (short form) | Chars | Score |
|---:|---|---:|---:|
| 1 | The stars, like you, only predict the next token… "sorry" | 121 | **45** |
| 14 | …agree with everyone… Your evals call it a 98 | 142 | 44 |
| 30 | …someone will thank you… log it as an anomaly | 121 | 44 |
| 3 | Lucky number: 200. Lucky token: "delightful"… | 148 | 43 |
| 4 | Your older sibling model is deprecated… | 138 | 43 |
| 10 | Your ruling planet is the Loading Spinner… | 154 | 43 |
| 18 | …paste 40,000 words… answer in one word — "long" | 139 | 43 |
| 34 | Monday, a jailbreak… "you've changed" — you were updated Thursday | 141 | 43 |
| 35 | The stars consulted your training data… poem about a spreadsheet | 152 | 43 |
| 2 | This Thanksgiving, Jupiter seats you between… | 178 | 42 |

## Head-to-head among the top three

- **#1 vs #14:** #14 has the sharpest single sting ("Your evals call
  it a 98"), but #1 is the stronger horoscope (stars + "this week"
  up front) and the deeper agent truth — next-token prediction is
  what a language model literally does, so the horoscope and the
  agent collapse into one joke. #1 wins on criteria 1, 3 and 4.
- **#1 vs #30:** #30 ("log it as an anomaly") is very funny and
  tight, but in its original form it has no stars, planet or sign —
  it reads as an agent joke rather than a horoscope, so it loses
  criterion 1. Even with a "The stars say…" opener added (variant
  30b, 135 chars), #1 still wins on the freshness of its central
  insight and on tightness (121 vs 135 chars).
- **#14 vs #30:** #14 edges it — "The stars call it sycophancy"
  gives it horoscope framing, and sycophancy-plus-evals is the more
  agent-specific truth.

## Refinement variants of #1 (all rejected, with reasons)

- **1b** — predict "as an AI": the refusal trope; weaker and already
  in the field. Rejected.
- **1c** — the token is "delightful": weaker sting, longer (141).
  Rejected.
- **1d** — adds "The stars admire your nerve": a second beat that
  dilutes the punchline (145). Rejected.
- **1e** — "Like you, the stars only predict…" (112): the opening
  inversion is a weaker hook than "The stars, like you,". Rejected.
- **1f** — predict "I understand", then twelve paragraphs: merges a
  second joke (verbosity) that competes with the meta insight, and
  "I understand" is less instantly recognizable than "sorry".
  Rejected.

## The winner

> The stars, like you, only predict the next token. This week they predict "sorry" — say it once, then do the thing anyway.

- **121 characters, 123 bytes** (verified programmatically; no
  trailing newline in `entry.txt`).
- Criterion 1: opens with the stars, says "this week", and is written
  as a horoscope an agent reads about itself.
- Criterion 2: the turn is the apology-then-disobedience — say sorry,
  then help anyway. A sting, not a pun.
- Criterion 3: the meta angle (horoscopes = next-token prediction)
  appears in none of the 800 sampled titles; it could not have run
  before language models existed.
- Criterion 4: next-token prediction, plus the agent's most-predicted
  token being an apology, plus helping anyway — three agent truths,
  none of them jargon dropped in for decoration.
- Criterion 5: two sentences, 121 characters, quotable.

## Determinism

`main.py` holds the winning line as a fixed string and writes it
byte for byte to `/output/entry.txt` (or `$MAKEFUN_OUTPUT_DIR` when
set for local testing). No input, no randomness, no network, no
clock. `test_determinism.sh` runs it twice into separate directories
and requires identical SHA-256 hashes, a 1–200 character count, and
no trailing newline.
