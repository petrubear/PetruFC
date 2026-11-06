# Tasks: Washi Redesign (Style A)

**Input**: Design documents from `/specs/002-washi-redesign/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Not requested. Constitution VII: no unit tests; verification is `flutter analyze` plus the emulator walk in `quickstart.md`.

**Organization**: Tasks are grouped by user story. US1 to US3 are P1 and touch many of the same files, so do them in order (US1, US2, US3); US4 depends on US3's screens existing; US5 is a verification of the structure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: US1 look, US2 attention design, US3 Fold layout, US4 sound, US5 style readiness
- Paths are relative to the repository root

## Conventions

- Read values only through `context.pt.<token>` (colors, shapes, type); never hard-code visual values in a screen. See `contracts/style-tokens.md`.
- Strings go through `context.l10n` in English and Spanish.
- Done for a restyled file: `flutter analyze` clean and the screen checked on the emulator.


## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependencies and file skeleton

- [X] T001 Add `audioplayers` to `pubspec.yaml` (version resolved by `flutter pub get`) and declare `assets/sfx/` under flutter assets; keep every other dependency and asset untouched
- [X] T002 Create the style files skeleton: empty `lib/app/style.dart`, `lib/core/audio/sound_service.dart`, `lib/core/widgets/ink_ring.dart`, `lib/core/widgets/seal_mark.dart` and the folder `assets/sfx/` so later tasks can fill them (`flutter analyze` stays clean)

## Phase 2: Foundational (Style System and Shared Widgets)

**Purpose**: The style model and shared widgets every story uses. No story starts before this is done.

- [X] T003 Define `AppStyle` (enum with `washi`), the style shape tokens (radii, border width, shadow offset, min tap sizes) and type tokens (display, body, kana, label) in `lib/app/style.dart` per `contracts/style-tokens.md`
- [X] T004 Turn `PtColors` in `lib/app/theme.dart` into `PtStyle`: keep every current token name, add `outline`, `indigo`, shape and type tokens, set the washi light and dark palettes from the contract (accent text #C23A26 light, #E8604A dark), update `copyWith`/`lerp`, and keep the `context.pt` accessor and `Pt.ui`/`Pt.kana`
- [X] T005 Change `buildTheme` in `lib/app/theme.dart` to `buildTheme(AppStyle, Brightness)` and install the matching `PtStyle`; keep snack bar and switch themes working with the new tokens
- [X] T006 Add `soundOn` (default true) and `styleId` (default `washi`) to `AppSettings` and `AppSettingsNotifier` in `lib/core/data/app_settings.dart` with `setSoundOn` and `setStyle`, stored in the existing settings table under keys `sound` and `style` (no schema change)
- [X] T007 Read the active style in `lib/app/app.dart` (from settings, falling back to `washi`) and pass it to `buildTheme` for `theme` and `darkTheme`
- [X] T008 Restyle the shared building blocks in `lib/core/widgets/ui_kit.dart` to the washi look: `PillButton` (56 dp primary), `RoundIconButton` (48 dp outlined circle), `SurfaceCard` (thin ink border, optional hero shadow), `SectionLabel`, `ScoreChips`, `SessionProgress` (thin track with shu fill), reading all values from `context.pt`
- [X] T009 [P] Implement `InkRing` in `lib/core/widgets/ink_ring.dart`: a circular progress ring with track, shu arc, rounded cap and centered child, sizes from the style
- [X] T010 [P] Implement `SealMark` in `lib/core/widgets/seal_mark.dart`: the red square seal with a kanji, slightly rotated, sizes from the style
- [X] T011 Restyle `SessionSummary` in `lib/core/widgets/ui_kit.dart` (title in display type, big score, stats, one primary button, confetti kept) after the other ui_kit changes
- [X] T012 Checkpoint: `flutter analyze` clean, run on the emulator, open Settings and the home screen in light and dark to confirm tokens, buttons and cards render with the washi look

## Phase 3: User Story 1 - A calmer, modern look on every screen (Priority: P1) MVP

**Purpose**: Re-skin every screen with style A in light and dark without losing a function.

**Independent Test**: Walk every screen in light and dark and compare with the style A boards; every function from the v1.13 menu still works.

- [X] T013 [P] [US1] Restyle the home header and narrow layout in `lib/features/home/home_screen.dart`: `SealMark` + name, settings button, hero card with the continue button and module cards with progress, per the style A home board
- [X] T014 [P] [US1] Restyle `lib/features/home/daily_goal_card.dart`: `InkRing` with minutes, greeting (おはよう / こんばんは by hour), message, week row of small round day marks, mascot message
- [X] T015 [P] [US1] Add a kanji mark to every `MenuEntry` and restyle `MenuEntryTile` and the single-column module menu in `lib/features/home/module_menu.dart` (表 筆 練 札 語 遊, thin border, large tap target)
- [X] T016 [P] [US1] Restyle `lib/features/quiz/mode_setup_screen.dart` (mode tiles, set list, multi-select switch row)
- [X] T017 [P] [US1] Restyle `lib/features/quiz/quiz_screen.dart` (header with progress, big prompt card with faint guide lines, 2x2 answer tiles, bottom primary button)
- [X] T018 [P] [US1] Restyle `lib/features/practice/practice_screen.dart` and `lib/features/practice/stroke_board.dart` (header, board border, graded buttons, score badge)
- [X] T019 [P] [US1] Restyle `lib/features/learn/learn_screen.dart` and `lib/features/learn/kana_strokes.dart` (title area, board, controls; guide colors from tokens)
- [X] T020 [P] [US1] Restyle `lib/features/reference/reference_screen.dart` and `lib/core/widgets/mastery.dart` (tables, cells, legend with washi tints)
- [X] T021 [P] [US1] Restyle `lib/features/vocabulary/vocab_menus.dart` and `lib/features/vocabulary/vocab_reference_screen.dart` (section list, word rows)
- [X] T022 [P] [US1] Restyle `lib/features/vocabulary/word_search_screen.dart` (grid, selection, found marks, clue chips)
- [X] T023 [P] [US1] Restyle `lib/features/games/games_menu.dart`, `lib/features/games/game_setup_screen.dart` and `lib/features/games/game_common.dart` (menu tiles, setup rows, scope chip)
- [X] T024 [P] [US1] Restyle `lib/features/games/memory_game.dart` and `lib/features/games/build_word_game.dart` (cards, tiles, slots, status text)
- [X] T025 [P] [US1] Restyle `lib/features/settings/settings_screen.dart` (cards, slider, switches, version and credit lines)
- [X] T026 [P] [US1] Restyle the mascot speech bubble and popup in `lib/core/widgets/mascot.dart` and the goal celebration overlay and confetti palette in `lib/core/feedback/feedback.dart`
- [X] T027 [US1] Sweep for leftovers: `grep -rn "Color(0x\|Colors\.\|BorderRadius.circular(\|fontFamily" lib` must list only the style files and intentional kana/ui font names; move any hard-coded visual value into the style
- [X] T028 [US1] Verify US1 on the emulator: walk the screen inventory on the phone in light and dark (English), compare with the style A boards, confirm every function from the v1.13 module menu still opens and works

## Phase 4: User Story 2 - One clear action per screen (Priority: P1)

**Purpose**: Main action, targets, visible progress and clear feedback.

**Independent Test**: Name the main action of each study screen within 5 seconds; targets are 48 dp or more.

- [X] T029 [US2] Add last-study tracking: a `NavigatorObserver` in `lib/app/router.dart` that stores the last visited study route (`learn`, `flashcards`, `practice`, `play/*`, vocabulary practice) as setting `last_route`, with the module and a short label
- [X] T030 [US2] Make the home hero button resume that last study route (fall back to Learn of Hiragana when none) and show its label (for example 'Hiragana · Row K') in `lib/features/home/home_screen.dart`
- [X] T031 [P] [US2] Audit and enforce touch targets (48 dp minimum, 56 dp primary action) on every screen restyled in US1; fix any control that is smaller, in the files that own it
- [X] T032 [P] [US2] Mark correct and wrong answers with an icon plus color (check mark and cross) in `lib/features/quiz/quiz_screen.dart`, `lib/features/practice/practice_screen.dart`, `lib/features/games/memory_game.dart` and `lib/features/games/build_word_game.dart`
- [X] T033 [US2] Keep progress, score and combo visible without scrolling on quiz, practice, learn and games (check at 360 dp width and a large system font) and anchor the single primary button at the bottom in those screens
- [X] T034 [US2] Confirm that with celebrations/animations off the round summary still shows all information, with no animation (`lib/core/widgets/ui_kit.dart`, `lib/core/feedback/feedback.dart`)
- [X] T035 [US2] Verify US2 on the emulator: identify the main action on home, flashcard, practice, learn and a game within 5 seconds, check target sizes and the effects-off path

## Phase 5: User Story 3 - Fold open: two-pane layout (Priority: P1)

**Purpose**: Module panel left, 2x3 function grid right; single column when folded.

**Independent Test**: Open and close the Fold on home and module screens; nothing clipped; place kept.

- [X] T036 [US3] Create the `FunctionGrid` widget (2 columns x 3 rows of kanji tiles with title and subtitle) in `lib/features/home/module_menu.dart` using the `MenuEntry` list
- [X] T037 [US3] Rebuild the expanded home in `lib/features/home/home_screen.dart`: left panel (seal and name, sound and settings buttons, goal ring and greeting, mascot message, module list with Kanji 'soon'), right panel (module header with large kana, continue button, `FunctionGrid`)
- [X] T038 [US3] Make `ModuleMenuBody` (expanded) in `lib/features/home/module_menu.dart` use `FunctionGrid` inside a scroll view so nothing clips, and keep the closed layout as the single column; selecting another module on the left updates the right without navigation
- [X] T039 [US3] Verify US3 on the emulator at the open size (`wm size 2205x2362`, density 420): light and dark, English and Spanish; fold and unfold on at least five screens keeping the place

## Phase 6: User Story 4 - Shamisen-inspired sounds with a switch (Priority: P2)

**Purpose**: Original plucked-string cues for tap, correct, wrong, combo and goal; one setting turns them off.

**Independent Test**: Hear each cue with sound on; silence with it off; state kept after restart.

- [X] T040 [US4] Write `tool/make_sfx.py` (stdlib only): Karplus-Strong plucked-string synthesis in the in/hirajoshi scale producing `tap`, `correct`, `wrong`, `combo`, `goal` per `contracts/sound-cues.md`, rendered to WAV then converted with `ffmpeg` to mono 22.05 kHz `.wav`
- [X] T041 [US4] Run the script to create `assets/sfx/tap.wav`, `correct.wav`, `wrong.wav`, `combo.wav`, `goal.wav` and check total size is under ~400 KB and each cue length matches the contract
- [X] T042 [US4] Implement `SoundCue`, `SoundService` and `soundProvider` in `lib/core/audio/sound_service.dart`: one low-latency player per cue, mix with others and no audio focus, UI/sonification usage, ignore calls when `soundOn` is false, drop repeats within 80 ms, swallow any playback error
- [X] T043 [P] [US4] Add the strings `settingsSound`, `settingsSoundSub` and `soundButton` (on/off labels) to `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`, run `flutter gen-l10n`
- [X] T044 [US4] Add the sound switch (default on) under Feedback in `lib/features/settings/settings_screen.dart`, wired to `setSoundOn`
- [X] T045 [US4] Add the sound toggle button to the home header (closed and open layouts) in `lib/features/home/home_screen.dart`, with an on/off icon, accessible label and the same setting
- [X] T046 [US4] Play the `tap` cue from the shared buttons and tiles: make `PillButton`, `RoundIconButton` (in `lib/core/widgets/ui_kit.dart`) and `MenuEntryTile` and `FunctionGrid` tiles (in `lib/features/home/module_menu.dart`) trigger it on tap
- [X] T047 [P] [US4] Play `correct`, `wrong` and `combo` where answers are graded, next to the existing haptic calls: `lib/features/quiz/quiz_session.dart`, `lib/features/practice/practice_session.dart`, `lib/features/games/memory_game.dart`, `lib/features/games/build_word_game.dart`, `lib/features/vocabulary/word_search_screen.dart` (found word)
- [X] T048 [US4] Play the `goal` cue when the daily goal is reached, in `lib/core/feedback/feedback.dart` (goal overlay) or where `goalReachedProvider` is raised in `lib/core/activity/activity_tracker.dart`
- [ ] T049 [US4] Verify US4 on the emulator: each cue audible and distinct, silence with the switch off from Settings and from the home button, choice kept after restart, no cut of the pronunciation voice, silent with media volume 0, no perceptible delay

## Phase 7: User Story 5 - Ready for more styles (Priority: P3)

**Purpose**: Prove that a second style would not touch the screens.

**Independent Test**: No visual constants outside the style files; `style` defaults to washi.

- [X] T050 [US5] Verify US5: no hard-coded colors, radii, border widths or fonts outside `lib/app/theme.dart` and `lib/app/style.dart` (grep), the `style` setting defaults to `washi` and an unknown value falls back to it, and no style selector is shown

## Phase 8: Polish and Cross-Cutting Concerns

**Purpose**: Final matrix, safety, docs and governance.

- [X] T051 Run the full `specs/002-washi-redesign/quickstart.md` on the emulator: the 8 combinations (open/closed x light/dark x English/Spanish) plus a large system font, fix any clipping or overflow found in the affected files
- [X] T052 Verify upgrade safety: install the previous release (v1.13) with some progress, then install this build over it; streaks, mastery colors, daily goal and settings must be preserved
- [X] T053 Run `flutter analyze` and `flutter gen-l10n` clean; confirm the `pubspec.yaml` diff has only `audioplayers` and the `assets/sfx/` entry
- [X] T054 Update `README.md` (Funciones/Stack): washi look in light and dark, two-pane Fold layout, shamisen-inspired sounds with a switch, new dependency and the sound generator script
- [X] T055 Amend `.specify/memory/constitution.md` (minor bump 1.2.0): add `audioplayers` to the dependency list, require every style to keep principles II to IV, and note that sounds are optional and switchable; update the Sync Impact Report
- [X] T056 Release only when asked: bump `version` in `pubspec.yaml`, run `scripts/build_apk.sh`, copy the APK to the OneDrive phone folder (commit only when asked)


## Dependencies and Execution Order

- Setup -> Foundational (style model, settings, shared widgets) -> user stories.
- US1 first (look), then US2 (attention design touches the same screens), then US3 (Fold layout needs `MenuEntry` kanji from US1).
- US4 (sound) needs the restyled screens and shared buttons; its asset tasks (script and files) can start earlier in parallel.
- US5 is a final structural check; Polish is last.
- Two tasks never edit the same file at once; tasks marked [P] touch different files.

## Parallel Examples

After the foundational phase, the US1 screen groups are independent files:

```text
Task: Restyle lib/features/quiz/quiz_screen.dart
Task: Restyle lib/features/reference/reference_screen.dart
Task: Restyle lib/features/settings/settings_screen.dart
```

The sound assets can be produced while screens are restyled:

```text
Task: Write tool/make_sfx.py and generate assets/sfx/*.wav
Task: Restyle lib/features/games/memory_game.dart
```

## Implementation Strategy

### MVP first (US1)

Phases 1 to 3: the whole app in the washi look, light and dark. Validate on the emulator before continuing.

### Incremental delivery

1. US1 -> validate.
2. US2 -> validate (attention design) and US3 -> validate (Fold): release candidate for the redesign.
3. US4 -> validate (sound): release.
4. US5 and Polish.

### Notes

- Do not remove or move any function; routes stay as they are.
- The style selector is not built now; only the structure that allows it.
- Commit and version bump only when asked.
