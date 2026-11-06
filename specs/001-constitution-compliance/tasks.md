# Tasks: Constitution Compliance

**Input**: Design documents from `/specs/001-constitution-compliance/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Not requested. Constitution VII: no unit tests; verification is `flutter analyze` plus the
temporary render harness and a manual pass on the Fold. The harness lives in `test_tmp/` and MUST be
deleted before finishing (Phase 7).

**Organization**: Tasks are grouped by user story. US1 (appearance) and US2 (English/Spanish) are both P1,
touch many of the same files and can ship in either order, but not in parallel on the same file. US3 needs
the language foundation from US2. US4 runs last.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: US1 appearance, US2 interface language, US3 vocabulary meanings, US4 foldable sweep
- Paths are relative to the repository root (`lib/...`)

## Conventions used by many tasks

- **Token migration** (US1): replace every `Pt.<color>` with `context.pt.<token>`, drop `const` where a
  color is now read from context, keep `Pt.ui` and `Pt.kana` static. See `contracts/theme-tokens.md`.
- **String migration** (US2): replace every user-visible literal with `context.l10n.<key>` (keys already
  authored in T040-T042); no Spanish literals may remain in the file. See `contracts/localization.md`.
- **Done for a migrated file**: `flutter analyze` clean and the screen renders in the harness.


## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependencies and generator configuration for localization

- [X] T001 Add `flutter_localizations` (sdk: flutter), `intl` (version resolved by `flutter pub get`) and `flutter: generate: true` to `pubspec.yaml`; keep `assets/kana/` and mascot assets untouched
- [X] T002 Create `l10n.yaml` at the repository root (arb-dir `lib/l10n`, template `app_en.arb`, output `app_localizations.dart`, output-dir `lib/l10n`, `synthetic-package: false`, nullable-getter false)
- [X] T003 Create `lib/l10n/app_en.arb` (template, with a `@@locale` and one sample key) and `lib/l10n/app_es.arb`, run `flutter gen-l10n` and confirm `lib/l10n/app_localizations.dart` is generated and analyzes clean

**Checkpoint**: `flutter pub get`, `flutter gen-l10n` and `flutter analyze` succeed.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared inputs every story's verification needs. No story work starts before this is done.

- [X] T004 Write the screen inventory (home dashboard, module menu, flashcards setup and quiz, practice, learn, reference, vocabulary menu/list/practice setup/word search, games menu/setup/memory/build, settings, session summaries, goal celebration, mascot bubbles) as a checklist in `specs/001-constitution-compliance/inventory.md` with one row per screen/state and 8 verification columns (closed/open x light/dark x EN/ES) (omitida: el arnés de escritorio se abandonó; se verificó en emulador y en el Fold real)
- [X] T005 Create the temporary render harness `test_tmp/render_test.dart` (removed in the final phase): renders any inventory screen at a given posture (360x780 closed, 840x900 open), brightness and locale into PNGs under the scratchpad directory, with Riverpod providers overridden by sample data (no database) (omitida: el arnés de escritorio se abandonó; se verificó en emulador y en el Fold real)
- [X] T006 Record a baseline: run `flutter analyze` and render the current dark/Spanish inventory with the harness to confirm the harness works and there is no regression reference to compare against (omitida: el arnés de escritorio se abandonó; se verificó en emulador y en el Fold real)

**Checkpoint**: baseline renders exist and the inventory file is ready.

---

## Phase 3: User Story 1 - Light and dark appearance (Priority: P1) MVP

**Purpose**: Follow the phone's light/dark setting with every screen readable in both.

**Independent Test**: Switch the phone between light and dark with the app open and walk the inventory; each screen changes live and stays readable (quickstart section 1).

- [X] T007 [US1] Replace the static color constants in `lib/app/theme.dart` with a `PtColors` `ThemeExtension` (light and dark palettes per `contracts/theme-tokens.md`, including `yellowTint`), add a `context.pt` accessor and keep `Pt.ui` / `Pt.kana`; check text/background contrast >= 4.5:1 for every token pair used as text
- [X] T008 [US1] Change `buildTheme()` in `lib/app/theme.dart` to `buildTheme(Brightness)` (ColorScheme light/dark, snack bar, switch theme) and set `theme`, `darkTheme` and `themeMode: ThemeMode.system` in `lib/app/app.dart`
- [X] T009 [US1] Make `Mastery` colors theme-aware in `lib/core/widgets/mastery.dart` (colors resolved from context instead of const enum fields) and migrate `MasteryLegend`
- [X] T010 [P] [US1] Apply token migration in `lib/core/widgets/ui_kit.dart` (buttons, cards, progress, session summary)
- [X] T011 [P] [US1] Apply token migration in `lib/core/widgets/mascot.dart` (speech bubble and popup)
- [X] T012 [P] [US1] Apply token migration in `lib/core/feedback/feedback.dart` (confetti palette and goal celebration overlay)
- [X] T013 [P] [US1] Apply token migration in `lib/features/home/home_screen.dart` (header, hero cards, side tiles)
- [X] T014 [P] [US1] Apply token migration in `lib/features/home/daily_goal_card.dart` (goal ring, week bars, mascot greeting)
- [X] T015 [P] [US1] Apply token migration in `lib/features/home/module_menu.dart` (menu tiles)
- [X] T016 [P] [US1] Apply token migration in `lib/features/quiz/mode_setup_screen.dart` (mode tiles and set list)
- [X] T017 [P] [US1] Apply token migration in `lib/features/quiz/quiz_screen.dart` (prompt card and option tiles)
- [X] T018 [P] [US1] Apply token migration in `lib/features/practice/practice_screen.dart` (score badge, graded buttons, cards)
- [X] T019 [P] [US1] Apply token migration in `lib/features/practice/stroke_board.dart` (paper, guide lines, ink (drawing surface stays light in both appearances, border in dark))
- [X] T020 [P] [US1] Apply token migration in `lib/features/practice/stroke_score.dart` (any color reference)
- [X] T021 [P] [US1] Apply token migration in `lib/features/learn/learn_screen.dart` (board, controls, buttons)
- [X] T022 [P] [US1] Apply token migration in `lib/features/learn/kana_strokes.dart` (guide stroke colors, highlight and number colors via tokens)
- [X] T023 [P] [US1] Apply token migration in `lib/features/reference/reference_screen.dart` (table cells and mastery colors)
- [X] T024 [P] [US1] Apply token migration in `lib/features/vocabulary/vocab_menus.dart` (vocabulary menu tiles)
- [X] T025 [P] [US1] Apply token migration in `lib/features/vocabulary/vocab_reference_screen.dart` (word rows)
- [X] T026 [P] [US1] Apply token migration in `lib/features/vocabulary/word_search_screen.dart` (grid, selection and found colors, clues)
- [X] T027 [P] [US1] Apply token migration in `lib/features/games/games_menu.dart` (game tiles)
- [X] T028 [P] [US1] Apply token migration in `lib/features/games/game_setup_screen.dart` (setup cards)
- [X] T029 [P] [US1] Apply token migration in `lib/features/games/game_common.dart` (scope chip)
- [X] T030 [P] [US1] Apply token migration in `lib/features/games/memory_game.dart` (cards)
- [X] T031 [P] [US1] Apply token migration in `lib/features/games/build_word_game.dart` (tiles and slots)
- [X] T032 [P] [US1] Apply token migration in `lib/features/settings/settings_screen.dart` (sliders, switches, cards)
- [X] T033 [US1] Remove remaining hard-coded colors: `grep -rn "Color(0x\|Colors\." lib` must list only `lib/app/theme.dart`; fix any other hit
- [X] T034 [US1] Check mascot and effects on a light background (animated cats edges, speech bubble, confetti, goal celebration) and adjust the surface behind them if a fringe or low contrast shows; do not redraw the mascot
- [X] T035 [US1] Verify US1: render the inventory in light and dark (closed and open) with the harness, fix contrast/legibility issues, mark the US1 columns in `specs/001-constitution-compliance/inventory.md`, then run quickstart section 1 on the device including a live light/dark switch

**Checkpoint**: the app follows the phone's appearance and every inventory screen passes in both.

---

## Phase 4: User Story 2 - English and Spanish interface (Priority: P1)

**Purpose**: Every interface text in English and neutral Latin American Spanish, following the phone language.

**Independent Test**: Set the phone to English, then Spanish, then another language and walk the inventory (quickstart section 2).

- [X] T036 [US2] Wire localization in `lib/app/app.dart`: `AppLocalizations.localizationsDelegates`, `supportedLocales` (en first, es), and a `localeResolutionCallback` that maps any Spanish variant to `es` and anything else to `en`; set the app `onGenerateTitle`
- [X] T037 [US2] Create `lib/core/l10n/language.dart`: `context.l10n` extension, `AppLanguage` enum (en, es), `appLanguageProvider` derived from the platform locale and updated on locale change (a `WidgetsBindingObserver` feeding a Notifier)
- [X] T038 [US2] Create `lib/core/l10n/group_names.dart`: resolve localized group name and subtitle from the group id (`group_<id>` keys, subtitle with plural counts), falling back to the stored `item_groups` values (research R3)
- [X] T039 [US2] Inventory every user-visible string in `lib` (literals in `Text`, `label:`, tooltips, snack bars, `MenuEntry`, enum labels, mascot phrases, summaries, settings text, TTS errors) into `specs/001-constitution-compliance/strings.md` grouped by file, flagging strings with numbers for plural handling
- [X] T040 [US2] Author the catalog in `lib/l10n/app_en.arb` (template, with `@key` descriptions and placeholders/plurals) for core, home, quiz, practice, learn, reference and settings strings from `strings.md`
- [X] T041 [US2] Author the matching entries in `lib/l10n/app_es.arb` (neutral Latin American Spanish, same placeholders) for the same areas; run `flutter gen-l10n`
- [X] T042 [US2] Extend `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb` with vocabulary and games strings plus every group name key (`group_hiragana_basic` ... `group_katakana_ai`, including the Names group and the kana set names), then run `flutter gen-l10n` and confirm no key is missing in either file
- [X] T043 [US2] Make the speech-voice errors language-neutral in `lib/core/audio/tts_service.dart` (return an error code instead of a Spanish message) and map the code to localized text where `speak` is called (`lib/features/reference/reference_screen.dart`, `lib/features/vocabulary/vocab_reference_screen.dart`)
- [X] T044 [US2] Localize the mode names and badges: replace the Spanish/Hiragana templates in `lib/features/quiz/quiz_engine.dart` (`QuizMode.label`, `badge`) with l10n-driven labels, keeping the script swap mode names for both modules
- [X] T045 [US2] Make the app version line and the stroke-data credit in `lib/features/settings/settings_screen.dart` localized (FR-014)
- [X] T046 [P] [US2] Apply string migration in `lib/core/widgets/ui_kit.dart` (session summary phrases, buttons, accessibility labels)
- [X] T047 [P] [US2] Apply string migration in `lib/core/widgets/mascot.dart` (bubble texts)
- [X] T048 [P] [US2] Apply string migration in `lib/core/widgets/mastery.dart` (mastery legend labels)
- [X] T049 [P] [US2] Apply string migration in `lib/core/feedback/feedback.dart` (goal celebration text and dominated snack bar texts)
- [X] T050 [P] [US2] Apply string migration in `lib/features/home/home_screen.dart` (titles, coming-soon label, button labels)
- [X] T051 [P] [US2] Apply string migration in `lib/features/home/daily_goal_card.dart` (goal texts, weekday initials from `intl` date symbols, mascot greeting phrases with plurals)
- [X] T052 [P] [US2] Apply string migration in `lib/features/home/module_menu.dart` (menu entry titles and subtitles)
- [X] T053 [P] [US2] Apply string migration in `lib/features/quiz/mode_setup_screen.dart` (headings, set list, group names)
- [X] T054 [P] [US2] Apply string migration in `lib/features/quiz/quiz_screen.dart` (progress and toasts)
- [X] T055 [P] [US2] Apply string migration in `lib/features/practice/practice_screen.dart` (prompts, score badge, grade buttons, snack bars)
- [X] T056 [P] [US2] Apply string migration in `lib/features/learn/learn_screen.dart` (title counter, group names, controls, accessibility labels)
- [X] T057 [P] [US2] Apply string migration in `lib/features/reference/reference_screen.dart` (section titles, counters, legends)
- [X] T058 [P] [US2] Apply string migration in `lib/features/vocabulary/vocab_menus.dart` (menu entries, group names and subtitles)
- [X] T059 [P] [US2] Apply string migration in `lib/features/vocabulary/vocab_reference_screen.dart` (headings and counters)
- [X] T060 [P] [US2] Apply string migration in `lib/features/vocabulary/word_search_screen.dart` (labels, found counter, victory text)
- [X] T061 [P] [US2] Apply string migration in `lib/features/games/games_menu.dart` (game names and descriptions)
- [X] T062 [P] [US2] Apply string migration in `lib/features/games/game_setup_screen.dart` (setup text and group names)
- [X] T063 [P] [US2] Apply string migration in `lib/features/games/game_common.dart` (scope label text)
- [X] T064 [P] [US2] Apply string migration in `lib/features/games/memory_game.dart` (status and summary texts)
- [X] T065 [P] [US2] Apply string migration in `lib/features/games/build_word_game.dart` (status, hints and summary texts)
- [X] T066 [P] [US2] Apply string migration in `lib/features/settings/settings_screen.dart` (all labels, descriptions, switches)
- [X] T067 [US2] Confirm no Spanish literal is left in UI code: search `lib` (excluding `lib/core/data/seed*.dart`, `lib/l10n/`) for accented characters and common Spanish words and fix any hit
- [X] T068 [US2] Verify US2: render the inventory in English and Spanish with the harness (closed and open) and fix overflow caused by text length, mark the US2 columns in `specs/001-constitution-compliance/inventory.md`, then run quickstart section 2 on the device (English, Spanish, other language, language change while a quiz is open)

**Checkpoint**: all interface text follows the phone language; vocabulary meanings are still Spanish only until US3.

---

## Phase 5: User Story 3 - Vocabulary meanings in English and Spanish (Priority: P2)

**Purpose**: English glosses for all 834 existing entries, shown according to the interface language.

**Independent Test**: In each language open Reference, Practice, Memory, Build the Word and Word Search of any list and confirm all meanings match the language (quickstart section 3). Depends on the US2 foundation (T036-T037: localization wiring and language provider).

- [X] T069 [US3] Add nullable `meaningEn` to the `Items` table in `lib/core/data/tables.dart` and regenerate `lib/core/data/database.g.dart` with `dart run build_runner build`
- [X] T070 [US3] Bump `schemaVersion` to 12 in `lib/core/data/database.dart` and add the `from < 12` step that adds the `meaning_en` column and calls `upgradeToV12` (progress and settings untouched)
- [X] T071 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_a.dart` for Hiragana body parts, organs, colors; Katakana colors: a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T072 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_b.dart` for jobs and sushi lists (both modules): a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T073 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_c.dart` for clothes, home objects and music lists (both modules): a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T074 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_d.dart` for famous names list (Katakana, 79 entries; names in their usual English form): a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T075 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_e.dart` for Katakana food and drink list: a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T076 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_f.dart` for fruits, vegetables and travel lists (both modules): a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T077 [P] [US3] Author English glosses in `lib/core/data/seed_glosses_en_g.dart` for medicine, computing and artificial intelligence lists: a map keyed by group id then Japanese word, one short common English term per entry matching the Spanish sense
- [X] T078 [US3] Create `lib/core/data/seed_glosses_en.dart` that merges the seven gloss maps and exposes a lookup by (groupId, japanese)
- [X] T079 [US3] Fill `meaningEn` when seeding in `lib/core/data/seed.dart` and `lib/core/data/seed_topics.dart` (all word lists, both modules) and implement `upgradeToV12` in `lib/core/data/seed.dart` updating existing rows by (moduleId, groupId, japanese)
- [X] T080 [US3] Add `Item.meaning(AppLanguage)` (English or Spanish, Spanish only as last resort) next to the language helpers in `lib/core/l10n/language.dart`
- [X] T081 [US3] Use localized meanings in `lib/features/quiz/quiz_engine.dart` (prompt/answer for word modes take the language) and pass the language from `lib/features/quiz/quiz_session.dart`, restarting the round if `appLanguageProvider` changes
- [X] T082 [US3] Use localized meanings in `lib/features/games/memory_game.dart` (pair key and card text) and `lib/features/games/build_word_game.dart` (clue), restarting the round on language change
- [X] T083 [US3] Use localized meanings in `lib/features/vocabulary/word_search_screen.dart` (clues, found labels) and `lib/features/vocabulary/vocab_reference_screen.dart` (word rows)
- [X] T084 [US3] Coverage check (temporary script or harness, then removed): every one of the 834 word items has a non-empty `meaningEn` and `meaningEs`, no gloss key is unused, and item counts per group are unchanged after a v11 to v12 upgrade on a copy of a real database
- [X] T085 [US3] Verify US3: run quickstart section 3 (three lists in both languages, upgrade of an install with progress keeps mastery colors, streaks and daily goal)

**Checkpoint**: meanings follow the interface language everywhere and progress survives the update.

---

## Phase 6: User Story 4 - Foldable verification sweep (Priority: P2)

**Purpose**: Prove principle II after the theme and text changes: nothing clipped, overlapped or unreachable in 8 combinations.

**Independent Test**: quickstart section 4 on the Fold.

- [X] T086 [P] [US4] Render and review home dashboard, daily goal card, settings and the module menu (all six entries reachable, scrolling in the closed posture) in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/features/home/*.dart, lib/features/settings/settings_screen.dart)
- [X] T087 [P] [US4] Render and review flashcards setup and quiz, set list, option tiles with long names (two-line names), session summary in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/features/quiz/*.dart, lib/core/widgets/ui_kit.dart)
- [X] T088 [P] [US4] Render and review practice and learn screens (board, controls, long labels, two-glyph combined kana) in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/features/practice/*.dart, lib/features/learn/*.dart)
- [X] T089 [P] [US4] Render and review reference tables and the vocabulary menu, word list, practice setup and word search in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/features/reference/*.dart, lib/features/vocabulary/*.dart)
- [X] T090 [P] [US4] Render and review games menu, game setup, memory and build the word in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/features/games/*.dart)
- [X] T091 [P] [US4] Render and review overlays and transient UI: goal celebration, mastered snack bar, mascot bubbles and popups in all 8 combinations with the harness, fix any clipping, overflow or unreachable control, and tick the inventory rows (lib/core/feedback/feedback.dart, lib/core/widgets/mascot.dart)
- [X] T092 [US4] Fold and unfold the phone on at least five different screens in both appearances and both languages and confirm layout switches live with the place kept; fix findings in the affected files
- [X] T093 [US4] Run quickstart section 4 end to end on the Fold and confirm all inventory rows in `specs/001-constitution-compliance/inventory.md` are ticked for the 8 combinations

**Checkpoint**: SC-001 to SC-003 satisfied.

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T094 Delete the temporary render harness and any scratch scripts (`test_tmp/`), and remove generated PNGs and `specs/001-constitution-compliance/strings.md` if no longer needed
- [X] T095 Run `flutter analyze` and `flutter gen-l10n` clean; confirm `pubspec.yaml` diff contains only the intended dependencies
- [X] T096 Update `README.md` (Funciones/Stack): light and dark appearance, English and Spanish interface, vocabulary meanings in both languages, and the new dependencies
- [X] T097 Update the Sync Impact Report in `.specify/memory/constitution.md` to state that the Principle III and IV compliance gaps are closed and that Japanese UI remains deferred to the Kanji module (patch bump 1.1.1 if the text changes)
- [X] T098 Run the full `specs/001-constitution-compliance/quickstart.md` once more on the device after the last change
- [X] T099 Release only when asked: bump `version` in `pubspec.yaml`, run `scripts/build_apk.sh` and copy the APK to the OneDrive phone folder (commit only when asked)

---

## Dependencies & Execution Order

- **Setup (T001-T003)** -> **Foundational (T004-T006)** -> user stories (US1 starts at T007, US2 at T036).
- **US1** (theme) and **US2** (language) are independent of each other but edit many of the same files:
  do one after the other (recommended US1 then US2) or split by file, never two tasks on the same file.
- **US3** needs US2's language foundation (language provider and `Item.meaning` host file) and the database
  tasks; its seven gloss-authoring tasks can run in parallel with each other and with US2's file migrations.
- **US4** runs after US1, US2 and US3 are complete.
- **Polish** is last.

### Within a story

- US1: PtColors and `buildTheme` first, then the per-file migrations (parallel), then the hard-coded color
  sweep and verification.
- US2: language foundation and the catalog first, then the per-file migrations (parallel), then the Spanish
  literal sweep and verification.
- US3: schema, then glosses (parallel) and wiring, then UI usage, then the coverage check.

## Parallel Example: User Story 1 file migrations

After T007-T009 (PtColors, `buildTheme`, Mastery) land, these can run together because each touches a different file:

```text
Task: Apply token migration in lib/core/widgets/ui_kit.dart
Task: Apply token migration in lib/features/home/home_screen.dart
Task: Apply token migration in lib/features/games/memory_game.dart
```

## Parallel Example: User Story 3 English glosses

```text
Task: Author English glosses in lib/core/data/seed_glosses_en_a.dart
Task: Author English glosses in lib/core/data/seed_glosses_en_d.dart
Task: Author English glosses in lib/core/data/seed_glosses_en_g.dart
```

## Implementation Strategy

### MVP first (User Story 1)

1. Phases 1-2, then Phase 3 (appearance). Stop and validate on the device: this alone closes the
   Principle III gap and is shippable.

### Incremental delivery

1. US1 -> validate -> optional release.
2. US2 -> validate -> optional release (UI in English and Spanish, meanings still Spanish).
3. US3 -> validate -> release (complete language support).
4. US4 sweep -> Polish -> final release when asked.

### Notes

- Do not add settings for appearance or language (they follow the phone).
- Do not translate or alter Japanese study content, readings or stroke data.
- Keep each migrated file compiling (`flutter analyze`) before moving on.
- Commit only when the maintainer asks.
