# Research: Kanji Module (Grade 1)

All Technical Context items are resolved; no NEEDS CLARIFICATION remain. Facts below were checked
against the real sources on 2026-11-06.

## R1 - Kanji list and per-kanji data

- **Decision**: Use KANJIDIC2 (EDRDG, CC BY-SA 4.0) as the single source for the grade 1 list, readings,
  stroke count and meanings. A generator script `tool/make_kanji.py` downloads it, keeps the characters with
  `<grade>1</grade>`, and writes `lib/core/data/seed_kanji.dart`.
- **Evidence**: the file has exactly 80 characters with grade 1, and all 80 have a Spanish meaning
  (`m_lang="es"`) plus the English one. 山 has on サン, セン, kun やま, meanings mountain / montaña.
- **Rationale**: one authoritative source; no hand-written readings; Spanish meanings come already reviewed
  by the dictionary, so no machine translation is needed.
- **Alternatives considered**: hand-typing the 80 (error prone); another dictionary (no Spanish).

## R2 - Stroke data

- **Decision**: Reuse KanjiVG (CC BY-SA 3.0), already credited in the app for kana. The same script downloads
  `kanji/<hex>.svg` for each of the 80, converts to the project's compact format (`{"p": [path...], "n": [[x,y]...]}`
  in a 109x109 box) and writes `assets/kanji/strokes.json` (about 100 KB).
- **Evidence**: KanjiVG files are reachable (HTTP 200 for 05c71.svg = 山); the kana loader `kana_strokes.dart`
  already parses KanjiVG paths (M and c commands) and numbers.
- **Rationale**: no new renderer; Learn and Practice reuse the painter.
- **Alternatives considered**: render from the font (no stroke order, no animation).

## R3 - Reference for Practice scoring

- **Decision**: Keep the current local scoring (`stroke_score.dart`) which rasterizes the glyph with the
  bundled Shippori Mincho and compares it with the drawing.
- **Evidence**: the bundled Shippori Mincho Bold contains all 80 grade 1 kanji (checked against its character map).
- **Rationale**: nothing new to build; spec asks for the same indicative percentage (Q5).
- **Alternatives considered**: score from KanjiVG paths (more code, needs a new rasterizer); validate stroke order (rejected in Q5).

## R4 - Data model

- **Decision**: Kanji are `items` rows (kind `kanji`, module `kanji`, group `kanji_g1`): `japanese` = the character,
  `reading` = romaji of the main reading, `audioText` = main reading in hiragana (used for speech and for the
  Kanji to Reading answer), `meaningEs` / `meaningEn` = primary meanings. A new table `kanji_details`
  (item id, grade, stroke count, on readings, kun readings) holds the rest. Words are ordinary `word` items
  in groups `kanji_<topic>`, with `reading` romaji, `audioText` hiragana reading and both meanings.
- **Rationale**: every existing mechanism (mastery, stats, active sets, daily goal, quiz pools, games) already
  works on `items`; the extra table avoids widening `items` for kana and words. Schema moves from 12 to 13.
- **Alternatives considered**: extra nullable columns on `items` (affects all rows); a JSON blob per kanji (not queryable).

## R5 - Flashcards modes and distractors

- **Decision**: Add `QuizMode.kind = 'kanji'` with `kanjiToMeaning`, `meaningToKanji`, `kanjiToReading`.
  Meaning options use the primary meaning in the app language and are unique across the 80. Reading options
  show the hiragana main reading; wrong options are drawn only from kanji whose readings (all on and kun,
  converted to hiragana) do not include the correct one. The question states the reading type (kun/on).
- **Rationale**: matches the clarified rule (Q1) and prevents two correct answers.
- **Alternatives considered**: two reading modes (Q1 option C, rejected).

## R6 - Words (vocabulary)

- **Decision**: Hand-curated list `tool/kanji_words.txt` of words written only with the 80 grade 1 kanji, with
  hiragana reading, romaji and both meanings, in about 6 topic sections (numbers, nature, body and people,
  school, time and days, animals and colors). The generator validates that every kanji of every word is in
  the grade 1 set and that each section has at least 8 words, then writes `seed_kanji_words.dart`.
- **Rationale**: JMdict is too large and licensed differently; a small checked list is enough for ~100 to 150 words.
- **Alternatives considered**: import JMdict (size, license, filtering effort).

## R7 - Games

- **Decision**: Memory with the "characters" scope pairs the kanji with its meaning in the app language
  (reading-only pairs are not offered); with the vocabulary scope it pairs the word with its meaning.
  Build the Word uses vocabulary words of two or more characters (for example 日本, 山川). Word search is hidden
  for the Kanji module (menu entry and vocabulary section entry).
- **Rationale**: follows Q4 and the existing games.
- **Alternatives considered**: Word search with kanji (grid would be trivial with 80 kanji).

## R8 - Reference and detail

- **Decision**: A new `KanjiReferenceScreen`: a section per grade with a grid of kanji tiles (mastery colors via
  `Mastery`), and a bottom sheet detail (kanji, meaning in the app language, on and kun lists, stroke count, grade,
  speaker button). The kana matrix table is not reused because kanji have no consonant/vowel layout.
- **Rationale**: closest to the kana Reference while fitting the data.
- **Alternatives considered**: reusing the matrix (no meaning).

## R9 - Progress and navigation

- **Decision**: Enable the `kanji` module in the DB migration; generalize `moduleProgressProvider` to count items of
  kind `kana` and `kanji`; add `kanji` to `scriptLabel`. The routes `/m/:module/...` already take the module id,
  so `StudyObserver` and "Continue" work without change.
- **Rationale**: minimal diffs; the Kanji card becomes active like the others.

## R10 - Credits and size

- **Decision**: Add a KANJIDIC2 credit (EDRDG, CC BY-SA 4.0) next to the KanjiVG one in Settings (EN and ES) and ship
  `assets/kanji/LICENSE-KANJIDIC2.txt`. Expected size increase is well under 1 MB.

## R11 - Verification

- **Decision**: The emulator and the real Fold (USB debugging is available) cover the 8 combinations; data
  checks (counts, uniqueness, word characters) run in the generator script, not as unit tests.
