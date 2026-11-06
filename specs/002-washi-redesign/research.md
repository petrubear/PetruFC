# Research: Washi Redesign (Style A)

All Technical Context items are resolved; no NEEDS CLARIFICATION remain.

## R1 - Modeling the style

- **Decision**: Evolve the existing `PtColors` `ThemeExtension` into `PtStyle`: the same color
  token names (so `context.pt.<token>` keeps working in all screens) plus shape tokens (`radius`
  small/medium/large/pill, `border` width, `shadowOffset`) and type tokens (`display` font, body
  font). `AppStyle` is an enum with one value (`washi`); `buildTheme(style, brightness)` picks the
  light or dark variant. The active style id is stored in settings (`style`, default `washi`).
- **Rationale**: Screens already read tokens, so a new style only supplies a new set of values
  (SC-007). Keeping token names means the redesign is mostly value changes plus a few new tokens.
- **Alternatives considered**: a parallel widget set per style (duplication); only a color
  scheme (cannot carry shapes, borders and fonts).

## R2 - Where the look lives

- **Decision**: Put the style in the shared widgets (`PillButton`, `RoundIconButton`, `SurfaceCard`,
  `SectionLabel`, `ScoreChips`, `SessionProgress`, `SessionSummary`, `MenuEntryTile`) and two new
  widgets: `InkRing` (goal/progress ring) and `SealMark` (red seal). Screens keep their structure and
  only change where the boards differ (home, module menu, flashcard/practice headers).
- **Rationale**: ~80% of what is visible comes from these widgets; this keeps the 25 screens small diffs.
- **Alternatives considered**: rewriting every screen to the boards (high risk of losing functions,
  contradicts principle I).

## R3 - Fold layout

- **Decision**: The existing wide home already has two panes; change the left pane to the module panel
  (greeting ring, mascot message, module list with Kanji "soon") and the right pane to the selected
  module header, the continue button and a 2x3 `FunctionGrid` (kanji, title, subtitle). Slab keeps the
  single-column module menu with the same entries, restyled. Both use `isExpanded` (600 dp).
- **Rationale**: Matches the style A Fold boards and the current behavior (selected module follows the route).
- **Alternatives considered**: a navigation rail (not in the boards).

## R4 - Typography

- **Decision**: No new fonts. Display text uses Shippori Mincho Bold (already bundled for kana);
  body text keeps Zen Maru Gothic. Add a `display` text style helper in the style.
- **Rationale**: Offline and no size increase. ExtraBold of the boards is approximated with Bold.
- **Alternatives considered**: bundling Shippori Mincho ExtraBold (~8 MB each weight, not worth it).

## R5 - Sound production

- **Decision**: Synthesize the cues with a Karplus-Strong plucked-string model in a stdlib-only Python
  script (`tool/make_sfx.py`), using the Japanese in/hirajoshi scale (D, E-flat, G, A, B-flat) so it
  reads as shamisen-like: soft pluck for tap, two rising plucks for correct, low damped note for wrong,
  rising three-note run with a quick tremolo for combo, and an arpeggio flourish with a sustained final
  note for goal. Encode to mono 22.05 kHz Ogg Vorbis with ffmpeg (about 5-20 KB each) and ship as assets.
- **Rationale**: Original audio means no licensing or attribution, works offline, and stays tiny. Sounds
  inspired by (not recordings of) a shamisen satisfy the request.
- **Alternatives considered**: licensed sample packs (attribution/licensing and larger); real-time
  synthesis in Dart (CPU, latency, more code); recording a real shamisen (not available).

## R6 - Playback

- **Decision**: `audioplayers` with one low-latency player per cue, `AudioContext` set to mix with
  others and not take audio focus (so speech and other audio are not cut), usage for UI/sonification
  sounds. A `SoundService` (Riverpod provider) exposes `play(SoundCue)`, ignores calls when the sound
  setting is off, and debounces repeats under ~80 ms so rapid taps do not pile up.
- **Rationale**: Low latency and focus control without custom platform code; it is a well maintained package.
- **Alternatives considered**: `soundpool` (less maintained), `just_audio` (heavier, streaming oriented),
  platform channels (more code).
- **Open verification**: that sounds respect device silence (media volume 0 / do not disturb): checked on the emulator in quickstart.

## R7 - Where cues fire

- **Decision**: Add the cue next to each existing haptic call (`buzz` in `lib/core/feedback/feedback.dart`):
  correct/wrong in quiz, practice, memory and build; combo milestone; goal reached in the goal overlay.
  The tap cue is played by the shared buttons/tiles (`PillButton`, `RoundIconButton`, `MenuEntryTile`).
  Haptics and sound remain independent settings.
- **Rationale**: The feedback moments are already centralized; no new call sites to discover.
- **Alternatives considered**: a global gesture listener (would play on non-actions and on scrolls).

## R8 - Sound setting

- **Decision**: `AppSettings.soundOn` (default true), stored as `sound` in the settings table; a switch in
  Settings under "Feedback" and a sound button in the home header that toggles the same value.
- **Rationale**: One source of truth; no schema change.
- **Alternatives considered**: separate switches per cue (more choices, against principle VI).

## R9 - Contrast of the red accent

- **Decision**: The boards' shu red (#D2402B) is 4.0:1 on the paper, below 4.5:1 for small text.
  Use #C23A26 (4.6:1) for accent text and fills in light mode; dark mode uses #E8604A on ink.
- **Rationale**: Keeps the look and meets the readable-contrast requirement (SC-006).

## R10 - Verification

- **Decision**: Use the Android emulator (already proven in this project) with `wm size` to emulate
  the open Fold, `cmd uimode night` for appearance and app locale for language; screenshot each screen
  of the inventory in the 8 combinations. The desktop widget harness is not used (it timed out).
- **Rationale**: Real rendering, real fonts and real audio focus behavior.
