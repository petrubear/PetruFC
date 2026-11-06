# Tasks: Kanji Module (Grade 1)

**Input**: Design documents from `/specs/003-kanji-primary/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Not requested. Constitution VII: no unit tests; verification is `flutter analyze`, the generator's data checks, and the emulator plus real Fold walk in `quickstart.md`.

**Organization**: Tasks are grouped by user story. The data pipeline and schema are foundational (every story needs the 80 kanji in the database). US1 to US3 are P1, in order; US4 and US5 are P2.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: US1 browse and Reference, US2 Learn and Practice, US3 Flashcards, US4 Vocabulary, US5 Games and progress
- Paths are relative to the repository root

## Conventions

- Read visual values only through `context.pt.<token>`; no hard-coded colors, radii or fonts in screens.
- Strings go through `context.l10n` in English and Spanish; meanings follow the app language (`Item.meaning(lang)`, English fallback).
- Kanji are content (the character text), not UI text; no Japanese interface strings.
- Done for a changed file: `flutter analyze` clean and the screen checked on the emulator.
- No unit tests. Generated files (`seed_kanji*.dart`, `strokes.json`) are never edited by hand: change the script or the word list and regenerate.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Folder, license and the data generator

- [X] T001 Create `assets/kanji/` with `LICENSE-KANJIDIC2.txt` (KANJIDIC2, EDRDG, CC BY-SA 4.0, link and attribution text) and declare `assets/kanji/` under flutter assets in `pubspec.yaml`
- [X] T002 Write `tool/make_kanji.py` (stdlib only): download `kanjidic2.xml.gz` from edrdg.org and the 80 KanjiVG SVGs from raw.githubusercontent.com/KanjiVG/kanjivg; keep characters with `<grade>1</grade>` in list order; build each item (character, romaji and hiragana of the main reading = first kun without okurigana marks else first on in hiragana, primary EN and ES meaning, on and kun readings, stroke count); convert the SVG strokes to the compact `{"p": [...], "n": [...]}` format of `assets/kana/strokes.json`; validate per `data-model.md` (80 kanji, unique primary meanings per language, stroke count equals number of paths); write `lib/core/data/seed_kanji.dart` and `assets/kanji/strokes.json`
- [X] T003 Run the generator, fix any validation failure it reports (for example duplicate primary meanings: pick the next meaning) and confirm 80 kanji, 80 stroke entries and a small file size

## Phase 2: Foundational (Schema, Seed and Shared Plumbing)

**Purpose**: Everything every story needs. No story starts before this is done.

- [X] T004 Add the `KanjiDetails` table (item id primary key, grade, stroke count, on readings, kun readings) to `lib/core/data/tables.dart`, register it in `lib/core/data/database.dart` and regenerate with `dart run build_runner build --delete-conflicting-outputs`
- [X] T005 Move the schema to 13 in `lib/core/data/database.dart` and add `if (from < 13) await upgradeToV13(this);` at the end of `onUpgrade` (create the table first; the existing steps stay untouched)
- [X] T006 In `lib/core/data/seed.dart`: insert the kanji module as enabled on a fresh install, call the kanji seed from `seedDatabase`, and add `upgradeToV13` (create `kanji_details`, set `modules.kanji.enabled = 1`, insert the group, items and details from `seed_kanji.dart`) in the same pattern as `upgradeToV7`
- [X] T007 Add `kanjiDetailsProvider` (map item id to details) in `lib/core/data/providers.dart` and make `moduleProgressProvider` count the groups of kind `kanji` as well as `kana`
- [X] T008 Generalize the strokes loader in `lib/features/learn/kana_strokes.dart`: add `strokesProvider` family by module id that loads `assets/kana/strokes.json` for kana and `assets/kanji/strokes.json` for `kanji`, keeping the current kana behavior and caching
- [X] T009 Add `kanji` to `scriptLabel` in `lib/features/home/module_menu.dart` (eyebrow `漢字`, example glyph, word glyph) and add the localized name of the group `kanji_g1` ("Grade 1" / "Grado 1") in `lib/core/l10n/group_names.dart`
- [X] T010 Add the new strings to `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb` (reading types kun/on, stroke count, grade, on and kun labels, the three kanji mode labels and badges, detail sheet title, KANJIDIC2 credit line) and run `flutter gen-l10n`
- [X] T011 Checkpoint: `flutter analyze` clean; install on the emulator over the current release with progress and confirm the Kanji card is enabled and nothing else changed (migration runs, kana progress intact)

## Phase 3: User Story 1 - Open the Kanji module and browse (Priority: P1) MVP

**Purpose**: The module is enabled, reachable on phone and Fold, and the Reference shows the 80 kanji with a detail.

**Independent Test**: From home open Kanji, open Reference, tap 山 and see meaning, readings, stroke count and grade, in light and dark, English and Spanish, Fold open and closed.

- [X] T012 [US1] Create `lib/features/reference/kanji_reference_screen.dart`: a section per grade (grade 1: 80 kanji) with a grid of tiles using `Mastery` colors from `statsProvider`, the count in the section title, scrolling, washi tokens and 48 dp minimum tiles
- [X] T013 [US1] Create the detail bottom sheet in `lib/features/reference/kanji_detail_sheet.dart`: kanji in display type, meaning in the app language, on readings, kun readings, stroke count, grade, and a speaker button that speaks the main reading (`audioText`); scrolls if it does not fit
- [X] T014 [US1] In `lib/app/router.dart` route `/m/:module/reference` to `KanjiReferenceScreen` when the module is `kanji` (kana modules keep `ReferenceScreen`)
- [X] T015 [US1] Check the home and open-Fold panels for the Kanji module in `lib/features/home/home_screen.dart` and `lib/features/home/module_menu.dart` (card color from tokens, progress bar and percentage, selectable in the left panel, header glyph and eyebrow, 2x3 grid); fix anything hard-coded to two modules
- [X] T016 [US1] Verify US1 on the emulator and the Fold: open the module, Reference, detail sheet for several kanji (many readings, long Spanish meaning), light and dark, English and Spanish, fold and unfold keep the place

## Phase 4: User Story 2 - Learn and Practice writing (Priority: P1)

**Purpose**: Stroke-by-stroke Learn and finger Practice with the same behavior as kana.

**Independent Test**: Learn 山 with numbered strokes and animation, draw it, leave and return to the same kanji; in Practice draw from memory, Check, see the percentage and grade.

- [X] T017 [US2] Adapt `lib/features/learn/learn_screen.dart` for the kanji module: use `strokesProvider('kanji')`, a single drawing box (no two-glyph layout), the label shows the meaning in the app language, the speaker plays the main reading, and the last position is remembered per module (kana behavior unchanged)
- [X] T018 [US2] Adapt `lib/features/practice/practice_session.dart` and `lib/features/practice/practice_screen.dart` for kanji: the prompt shows the meaning and the main reading, the board is the same, Check reveals the correct kanji with the existing percentage (`stroke_score.dart` unchanged) and the grading buttons save the answer
- [X] T019 [US2] Check that kanji with many strokes (for example 校 with 10 and 森 with 12) show the guide, numbers and animation legibly and that the drawing board and results do not clip on phone and Fold, light and dark
- [X] T020 [US2] Verify US2 on the emulator and the Fold: Learn, Practice, grading saves to mastery (the Reference tile color changes), dark board is inverted like kana

## Phase 5: User Story 3 - Flashcards by grade (Priority: P1)

**Purpose**: The three kanji modes with correct, unambiguous options.

**Independent Test**: Run a round in each mode; no option repeats a meaning or is also a valid reading; results saved; summary and daily goal work.

- [X] T021 [US3] In `lib/features/quiz/quiz_engine.dart` add `QuizMode.kanjiToMeaning`, `meaningToKanji` and `kanjiToReading` with `kind = 'kanji'`, their labels, badges (`山→mountain`, `mountain→山`, `山→やま`), prompts and answers per `contracts/quiz-modes.md`; build kanji reading options only from readings that are not valid for the asked kanji (all on and kun converted to hiragana), and expose the reading type (kun or on) for the question label
- [X] T022 [US3] In `lib/features/quiz/quiz_session.dart` and `lib/features/quiz/quiz_screen.dart` show the reading type next to the prompt in Kanji to Reading, accept any valid reading as correct, size the answer text for Japanese or meaning options, and keep the restart on language change
- [X] T023 [US3] In `lib/features/quiz/mode_setup_screen.dart` and `lib/app/router.dart` pass `kind: 'kanji'` for the Kanji module, show the grade sets in the set list (generalize `_isKana` and `SetList` to the kinds `kana` and `kanji`, at least one set stays on, grade 1 on by default) and keep the multiple selection option
- [X] T024 [US3] Verify US3 on the emulator and the Fold: the three modes, 20 questions each with no duplicate or double-correct option, summary, mastery color change, Spanish and English meanings, large system font

## Phase 6: User Story 4 - Vocabulary with kanji (Priority: P2)

**Purpose**: About 6 sections of words written only with the 80 kanji, with Reference and Practice.

**Independent Test**: Open each section, read its words with reading and meaning, practice both directions; no Word search entry.

- [X] T025 [P] [US4] Write `tool/kanji_words.txt` with the curated words (tab separated: section, word, hiragana, romaji, English, Spanish) in the sections `numbers`, `nature`, `body_people`, `school`, `time`, `animals_colors`, each with at least 8 words made only of the 80 grade 1 kanji (include several words of two or more characters, for example 日本, 山川, 四日)
- [X] T026 [US4] Extend `tool/make_kanji.py` to read the word list, validate (only grade 1 kanji, no duplicates, at least 8 words per section, readings and both meanings present) and write `lib/core/data/seed_kanji_words.dart` (groups `kanji_<section>` of kind `word`, items with romaji `reading`, hiragana `audioText`); run it
- [X] T027 [US4] Include the word groups and items in `seedDatabase` and `upgradeToV13` in `lib/core/data/seed.dart`, and add the localized section names in `lib/core/l10n/group_names.dart` (EN and ES)
- [X] T028 [US4] In `lib/features/vocabulary/vocab_menus.dart` hide Word search for the Kanji module (section menu keeps Reference and Practice) and make the section list work for the new groups
- [X] T029 [US4] In `lib/features/vocabulary/vocab_reference_screen.dart` show the hiragana reading (`audioText`) with the word and the meaning in the app language for kanji words, wrapping long text; Practice keeps the existing `wordToMeaning` and `meaningToWord` modes
- [X] T030 [US4] Verify US4 on the emulator and the Fold: section list, Reference, both practice directions, no Word search entry, light and dark, English and Spanish

## Phase 7: User Story 5 - Games and progress (Priority: P2)

**Purpose**: Memory and Build the Word with kanji, and the progress and daily goal integration.

**Independent Test**: Play both games, then check the home percentage and the daily minutes.

- [X] T031 [US5] In `lib/features/games/games_menu.dart` hide the Word search entry for the Kanji module, and in `lib/features/games/game_setup_screen.dart` offer the scopes Characters (kanji) and Vocabulary with the grade set or section selector
- [X] T032 [US5] In `lib/features/games/memory_game.dart` pair the kanji with its meaning in the app language for the Characters scope of the Kanji module (words with their meaning for Vocabulary); in `lib/features/games/build_word_game.dart` use only words of two or more characters for the Kanji module
- [X] T033 [US5] Verify US5 on the emulator and the Fold: both games, the home percentage rises after mastering kanji, the day minutes grow, "Continue where you left off" resumes a Kanji study screen, and sounds and haptics behave as in other modules

## Phase 8: Polish and Cross-Cutting Concerns

**Purpose**: Credits, final matrix, safety, docs and governance.

- [X] T034 Add the KANJIDIC2 credit (EDRDG, CC BY-SA 4.0) next to the KanjiVG one in the Settings credit text in `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`; confirm it fits on one or two lines on the Fold and the phone
- [ ] T035 Run the full `specs/003-kanji-primary/quickstart.md` on the emulator and the real Fold: the 8 combinations plus a large system font; fix any clipping or overflow in the affected files
- [X] T036 Verify upgrade safety: install the previous release (1.14.2) with progress, install this build over it; kana progress, streaks, settings, daily goal and last route are intact and Kanji appears enabled
- [X] T037 Run `flutter analyze` and `flutter gen-l10n` clean; confirm the APK grows by less than 1 MB of data and that `pubspec.yaml` only gained the `assets/kanji/` entry
- [X] T038 Update `README.md` (Funciones, Stack, credits): the Kanji module with grade 1, data sources and the generator script
- [X] T039 Amend `.specify/memory/constitution.md` (minor bump 1.3.0): the vocabulary rule covers Kanji (only kanji of the module, readings in romaji and hiragana), KANJIDIC2 added to the data sources, and update the Sync Impact Report
- [X] T040 Release only when asked: bump `version` in `pubspec.yaml`, run `scripts/build_apk.sh`, copy the APK to the OneDrive phone folder (commit only when asked)

## Dependencies and Execution Order

- Setup -> Foundational (schema, seed, providers, strings) -> user stories.
- US1 first (module reachable and Reference), then US2 (Learn and Practice), then US3 (Flashcards); US4 and US5 follow and are independent of each other.
- T025 (word list) can be written in parallel with any earlier work; T026 depends on T002 and T025.
- Tasks that touch the same file never run at the same time (`seed.dart`, `module_menu.dart`, `vocab_menus.dart`, `app_en.arb`).
- Polish is last; T040 only when asked.

## Parallel Examples

After the foundational phase these edit different files:

```text
Task: Create lib/features/reference/kanji_reference_screen.dart
Task: Adapt lib/features/learn/learn_screen.dart
Task: Add the kanji modes in lib/features/quiz/quiz_engine.dart
```

The word list can be written while screens are built:

```text
Task: Write tool/kanji_words.txt
Task: Adapt lib/features/practice/practice_session.dart
```

## Implementation Strategy

### MVP first (US1)

Phases 1 to 3: the data pipeline, the migration and a working Kanji module with its Reference. Validate on the emulator and the Fold.

### Incremental delivery

1. US1 -> validate.
2. US2 (writing) and US3 (flashcards) -> validate: the core learning loop.
3. US4 (vocabulary) and US5 (games, progress) -> validate: full parity with kana.
4. Polish: credits, matrix, upgrade safety, docs, constitution.

### Notes

- Do not remove or change any kana function; kana behavior is the default path in every generalized screen.
- Grades 2 to 6 later need only a new generator run (change the grade filter) and the new sets appear automatically.
- Commit and version bump only when asked.
