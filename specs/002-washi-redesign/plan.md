# Implementation Plan: Washi Redesign (Style A)

**Branch**: `002-washi-redesign` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-washi-redesign/spec.md`

## Summary

Re-skin the whole app with style A "Washi y tinta" in light and dark, rebuild the module menu as a
2x3 kanji grid with a two-pane Fold layout, and add shamisen-inspired sound cues behind a Settings
switch. The look is built on the existing theme extension (`PtColors`): it grows into a `PtStyle`
extension that also carries shape (radii, borders, shadows) and type, with `washi` the only
style and the active style stored as a setting, so a selector can be added later without touching
screens. Shared widgets in `ui_kit.dart` carry most of the look, so the 25 screens change lightly.
Sounds are original plucked-string phrases synthesized offline by a script, shipped as short assets
and played through a small `SoundService` in `lib/core/audio`.

## Technical Context

**Language/Version**: Dart 3.9 / Flutter 3.35.2 (Android only)

**Primary Dependencies**: flutter_riverpod 2.6, go_router 17, drift 2.31, flutter_tts, flutter_localizations/intl; new: `audioplayers` (low-latency asset playback)

**Storage**: Drift/SQLite; no schema change (new preferences use the existing key-value `settings` table: `sound`, `style`)

**Testing**: no unit tests (constitution VII); `flutter analyze`, emulator pass (Pixel 7 Pro API 34, phone and Fold-sized) in the 8 combinations, manual pass on the Fold

**Target Platform**: Android (Galaxy Z Fold closed and open; slab and extended layouts, breakpoint 600 dp)

**Project Type**: mobile-app

**Performance Goals**: sound starts within ~100 ms of the action and never blocks the UI thread; 60 fps on the Fold during the new menu and ink-ring animations

**Constraints**: fully offline, no new permissions, assets small (all sounds together under ~400 KB), no new fonts (Shippori Mincho and Zen Maru Gothic are already bundled)

**Scale/Scope**: ~25 screen files, 1 shared widget kit, 6 sound cues, 2 palettes (light, dark)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Architecture**: new code in `lib/app` (style), `lib/core/audio` (sound), `lib/features/*` (screen updates); Riverpod/go_router/Drift only; no schema change, so no migration. `audioplayers` is an audio package, not a state/navigation/persistence library (allowed by the Technology constraints).
- [x] **II. Foldable**: the two-pane home and 2x3 grid are specified for `isExpanded`; single column kept for the slab; scrolling kept where content can exceed the viewport.
- [x] **III. Look**: all colors and shapes come from the active style; light and dark both defined; accent text uses a darker shu in light mode to pass contrast.
- [x] **IV. Languages**: no new text except the sound setting labels, which go in both ARB files; kanji marks are decoration.
- [x] **V. Offline**: assets only, no network, no new permissions; sounds are original, so no attribution is needed.
- [x] **VI. Low friction**: one main action per screen, finite rounds unchanged, sound on by default with a single switch.
- [x] **VII. Verification**: no unit tests; analyze plus the emulator matrix (see quickstart).

Post-design re-check (after Phase 1): all gates still pass. The constitution text (Technology
constraints list and the new look/sound rules) needs a minor amendment, recorded as a polish task.

## Project Structure

### Documentation (this feature)

```text
specs/002-washi-redesign/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── style-tokens.md
│   ├── sound-cues.md
│   └── screen-layouts.md
└── tasks.md             # /speckit-tasks (not created here)
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── theme.dart            # PtStyle extension (colors + shape + type), buildTheme(style, brightness)
│   ├── style.dart            # AppStyle enum (washi), style definitions
│   └── app.dart              # active style from settings
├── core/
│   ├── audio/
│   │   ├── tts_service.dart  # unchanged
│   │   └── sound_service.dart  # SoundCue enum, SoundService, soundProvider
│   ├── data/app_settings.dart  # + soundOn, styleId
│   ├── feedback/feedback.dart  # cue next to each buzz()
│   └── widgets/
│       ├── ui_kit.dart       # restyled buttons/cards/summary; tap cue
│       ├── ink_ring.dart     # new: goal/progress ring
│       └── seal_mark.dart    # new: red seal logo
├── features/                 # screens updated to the new widgets/tokens
│   ├── home/ (home_screen, daily_goal_card, module_menu: 2x3 grid + two-pane)
│   ├── quiz/ practice/ learn/ reference/ vocabulary/ games/ settings/
└── l10n/                     # + sound setting strings

assets/sfx/                   # tap, correct, wrong, combo, goal (.ogg)
tool/make_sfx.py              # offline synthesis script (kept, not shipped)
```

**Structure Decision**: single Flutter project following the constitution's layout. The style lives
in `lib/app` beside the theme; sound in `lib/core/audio` where the speech service already is.

## Complexity Tracking

No gate violations. One note: a second dependency (`audioplayers`) is added; the alternative of
playing sounds through the speech service or platform channels was rejected as more code for the same result.
