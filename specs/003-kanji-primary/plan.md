# Implementation Plan: Kanji Module (Grade 1)

**Branch**: `003-kanji-primary` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/003-kanji-primary/spec.md`

## Summary

Enable the Kanji module with the 80 grade 1 kanji and the same six functions as Hiragana and Katakana.
The data is generated once by a script from KANJIDIC2 (list, readings, stroke count, English and Spanish
meanings) and KanjiVG (strokes), and shipped as Dart seed code plus a small stroke asset. Existing screens
(Learn, Practice, Flashcards, Vocabulary, Games, home progress) are generalized to a second kind of character,
`kanji`, instead of duplicated; the only new screen is the kanji Reference with its detail sheet. The schema
goes from 12 to 13 with one new table and a migration that keeps all progress. Grades 2 to 6 later need
only new data.

## Technical Context

**Language/Version**: Dart 3.9 / Flutter 3.35.2 (Android only)

**Primary Dependencies**: flutter_riverpod 2.6, go_router 17, drift 2.31, flutter_tts, audioplayers, gen_l10n; no new dependency

**Storage**: Drift/SQLite, schema 12 -> 13: new table `kanji_details`; new rows in `item_groups` and `items`; module `kanji` enabled

**Testing**: no unit tests (constitution VII); generator checks in `tool/make_kanji.py`, `flutter analyze`, emulator and real Fold in the 8 combinations

**Target Platform**: Android (Galaxy Z Fold closed and open; breakpoint 600 dp)

**Project Type**: mobile-app

**Performance Goals**: Reference and Learn open without visible delay (80 kanji); stroke asset parsed once and cached like the kana one

**Constraints**: fully offline; no new permissions; app size grows well under 1 MB (data and strokes only); washi style tokens only

**Scale/Scope**: 80 kanji, about 6 vocabulary sections and 100 to 150 words, 2 new screens (Reference, detail sheet), ~10 existing screens generalized, 3 new quiz modes, 1 migration

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Architecture**: seed and data in `lib/core/data`, strokes loader in `lib/features/learn`, new screen in `lib/features/reference`; Riverpod, go_router and Drift only; one schema migration with a version bump and an `onUpgrade` step.
- [x] **II. Foldable**: the module uses the existing two-pane home and 2x3 grid (`isExpanded`); the Reference grid and detail sheet adapt to width; scrolling kept.
- [x] **III. Look**: tokens from the washi style only (no new colors); light and dark both; the drawing board already inverts in dark.
- [x] **IV. Languages**: new strings in both ARB files; meanings follow the app language with English fallback; kanji are content, not UI text.
- [x] **V. Offline and Private**: all data and strokes are bundled; no network at runtime; credits for KANJIDIC2 (CC BY-SA 4.0) and KanjiVG (CC BY-SA 3.0) in Settings. The generator uses the network only at development time.
- [x] **VI. Low friction**: same module structure and finite rounds; grade 1 only keeps it small; no new settings.
- [x] **VII. Verification**: no unit tests; analyze plus the device and emulator matrix.

Post-design re-check: all gates pass. The constitution text on vocabulary ("Hiragana vocabulary only hiragana, readings in
romaji") needs a minor amendment to describe Kanji vocabulary (only module kanji, romaji and hiragana readings); it is a polish task.

## Project Structure

### Documentation (this feature)

```text
specs/003-kanji-primary/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── kanji-data.md
│   ├── quiz-modes.md
│   └── screen-flows.md
└── tasks.md             # /speckit-tasks (not created here)
```

### Source Code (repository root)

```text
tool/
├── make_kanji.py            # downloads KANJIDIC2 + KanjiVG, validates, writes the seed and the strokes
└── kanji_words.txt          # curated vocabulary (kanji word, hiragana, romaji, EN, ES, section)
assets/kanji/
├── strokes.json             # grade 1 strokes (KanjiVG), same format as assets/kana/strokes.json
└── LICENSE-KANJIDIC2.txt
lib/
├── core/data/
│   ├── tables.dart          # + KanjiDetails
│   ├── database.dart        # schema 13, onUpgrade step
│   ├── seed.dart            # kanji module enabled on create, upgradeToV13
│   ├── seed_kanji.dart      # generated: group, items, details
│   ├── seed_kanji_words.dart# generated: word groups and items
│   └── providers.dart       # moduleProgressProvider counts kanji too; kanjiDetailsProvider
├── features/
│   ├── learn/ (kana_strokes.dart loads the strokes by module; learn_screen.dart prompt for kanji)
│   ├── practice/ (prompt shows meaning and reading for kanji)
│   ├── quiz/ (quiz_engine.dart kanji modes; mode_setup_screen.dart sets for kanji)
│   ├── reference/kanji_reference_screen.dart   # new
│   ├── vocabulary/ (hide Word search for kanji; Kanji sections)
│   ├── games/ (memory with kanji meaning pairs; build with words; no Word search for kanji)
│   └── home/module_menu.dart   # scriptLabel for kanji; route Reference to the kanji screen
└── l10n/                   # kanji strings and credit line
```

**Structure Decision**: one Flutter project in the existing layout. The data pipeline is a script kept in `tool/`
(like `make_sfx.py`), and its generated Dart files live next to the other seeds.

## Complexity Tracking

No gate violations. One note: vocabulary words for kanji are hand-curated (not imported) to stay small and checkable.
