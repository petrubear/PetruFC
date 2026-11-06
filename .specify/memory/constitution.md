<!--
SYNC IMPACT REPORT
Version change: 1.2.0 -> 1.3.0
Amendment 1.3.0 (2026-11-06): Kanji module (grade 1). Vocabulary rule now covers Kanji words (only
  kanji of the module, hiragana reading plus romaji); KANJIDIC2 (EDRDG, CC BY-SA 4.0) added to the
  credited data sources. Minor bump: nothing that complied with 1.2.0 stops complying.
Amendment 1.2.0 (2026-11-06): style system (washi) and optional sounds. Principle III now says
  every style MUST keep principles II to IV; Technology adds audioplayers; sounds are original,
  offline and switchable. Minor bump: nothing that complied with 1.1.0 stops complying.
Amendment 1.1.0 (2026-11-06): Principle IV no longer requires a Japanese interface; it is
  deferred to the Kanji module. Minor bump: nothing that complied with 1.0.0 stops complying.
Modified principles: IV. English, Spanish and Japanese -> IV. English and Spanish;
  VII. Verification (languages narrowed to English and Spanish)
Principles at first ratification (1.0.0): I. Preserve the Existing Architecture; II. Foldable Support Is Mandatory;
  III. Modern Look, Light and Dark; IV. English, Spanish and Japanese; V. Offline and Private;
  VI. Low-Friction, Attention-Friendly Study; VII. Verification Without Unit-Test Overhead
Added sections: Technology and Content Constraints; Development Workflow; Governance
Removed sections: none
Templates:
  - .specify/templates/plan-template.md: updated (Constitution Check gates; gate IV in 1.1.0)
  - .specify/templates/tasks-template.md: updated (Polish phase; languages in 1.1.0)
  - specs/001-constitution-compliance/spec.md: updated to drop the Japanese interface scope
  - .specify/templates/spec-template.md: reviewed, no change needed
  - .specify/templates/checklist-template.md: reviewed, no change needed
  - .claude/skills/speckit-*/SKILL.md: reviewed, no agent-specific references to fix
Compliance gaps recorded at 1.1.0 are closed by specs/001-constitution-compliance
  (light/dark theme following the phone; English/Spanish UI and vocabulary meanings). Japanese UI
  remains deferred to the Kanji module.
Follow-up TODOs: none (placeholders all resolved)
-->
# Petru FC Constitution

## Core Principles

### I. Preserve the Existing Architecture (NON-NEGOTIABLE)
The app is a Flutter, Android-only project and its structure MUST be preserved:
`lib/app` (theme, router), `lib/core` (data, audio, layout, activity, feedback, shared
widgets) and `lib/features/<feature>` (home, quiz, practice, learn, reference, vocabulary,
games, settings). State uses Riverpod 2.x, navigation uses go_router, persistence uses
Drift over SQLite with data seeded from Dart code. New work MUST fit these layers and follow
the surrounding code's naming, comment density and idioms. Replacing or adding a competing
state-management, navigation, persistence or dependency-injection library requires a
constitution amendment first. Any schema change MUST bump `schemaVersion`, add an
incremental `onUpgrade` step and keep the user's progress intact.
Rationale: the app is a single-maintainer project with real study history on the device;
consistency and safe upgrades matter more than novelty.

### II. Foldable Support Is Mandatory
Every screen MUST work on the Galaxy Z Fold in both postures: slab (closed) and extended
(open). Layouts switch on window width using the existing `isExpanded` helper (600 dp) and
MUST change live when the device folds or unfolds. No screen may clip, overflow or hide
content in either posture: content that can exceed the viewport MUST scroll, and fixed
heights MUST be justified. A feature is not complete until it was checked in both postures.
Rationale: the device is a foldable and hidden or clipped options have already shipped once.

### III. Modern Look, Light and Dark
The visual design MUST be modern and consistent, and MUST support both light and dark themes,
following the system setting. Colors, typography and shapes MUST come from the shared theme
tokens (`lib/app/theme.dart`); widgets MUST NOT hard-code colors that break in one theme.
Text and controls MUST keep readable contrast in both themes, and mascot, confetti, mastery
colors and the stroke board MUST remain legible in both. Visual styles are named sets of
tokens (`AppStyle`); any additional style MUST keep principles II to IV (foldable, light/dark,
languages) and screens MUST NOT depend on a specific style.
Rationale: one visual language, comfortable in any lighting, without per-screen exceptions.

### IV. English and Spanish
The user interface MUST be available in English and Spanish, selected from the device
language, with English as the fallback. User-visible strings MUST go through the Flutter
localization mechanism and MUST NOT be hard-coded in widgets. Spanish MUST be neutral Latin
American Spanish with no regional dialects. Vocabulary glosses MUST be available in both
languages, and any new vocabulary list MUST ship with them. Study content (kana, readings and
the Japanese words themselves) is not translated. Layouts MUST tolerate the longer strings of
either language. A Japanese-language interface is deliberately out of scope for now: the Kanji
module's feature MUST amend this principle to add it (including what a gloss means for a
Japanese reader) before any Japanese UI work starts.
Rationale: the app serves English and Spanish learners; text length varies between languages,
and Japanese UI needs decisions that belong with the Kanji module.

### V. Offline and Private
The app MUST work fully offline: all data, fonts, stroke data and media are bundled, and the
app MUST NOT require network access, accounts, analytics or telemetry. Third-party data MUST
keep its license and attribution (for example KanjiVG under CC BY-SA 3.0 and KANJIDIC2 under
CC BY-SA 4.0 are credited in Settings, in `assets/kana/LICENSE-KanjiVG.txt` and in
`assets/kanji/LICENSE-KANJIDIC2.txt`).
Rationale: it is a personal study tool that must always open and never leak data.

### VI. Low-Friction, Attention-Friendly Study
The experience MUST stay light for a learner with attention deficit: finite rounds,
immediate feedback, a daily goal and visible progress, with no unnecessary choices.
Anything the app can decide (for example the mascot) MUST NOT become a user setting.
Haptics, confetti and animations MUST respect their Settings toggles. Study progress (streak
and mastery colors) MUST reflect real answers only.
Rationale: every extra decision or distraction costs the learner focus.

### VII. Verification Without Unit-Test Overhead
Automated unit tests are not required for this project. Every change MUST pass
`flutter analyze` with no issues and MUST be checked in both foldable postures and in both
themes, and in both languages once Principle IV is in place. Release builds MUST use
`scripts/build_apk.sh`. Temporary test code used for verification MUST be removed before
finishing.
Rationale: a lean workflow that still catches the layout and theme regressions that matter.

## Technology and Content Constraints

- Stack: Flutter 3.35 / Dart 3.9, flutter_riverpod 2.6, go_router, Drift 2.31 with
  drift_flutter, flutter_tts (Japanese voice), audioplayers (interface sounds), Gradle 9.1 / AGP 8.13 / Kotlin 2.2. Interface sounds
  MUST be original or properly licensed, work offline, and be switchable in Settings.
  Dependency
  additions MUST be justified in the plan and MUST work offline on Android.
- Hiragana vocabulary MUST contain only words written entirely in hiragana; Katakana
  vocabulary MUST contain only katakana words. Readings are lowercase romaji and each list
  entry MUST have a gloss. Kanji vocabulary MUST contain only words written with the kanji of the
  module (grade 1 for now), each with its hiragana reading and romaji, and has no word search.
  Word-search content MUST fit its 8x8 board (8 characters maximum).
- Settings are stored in the database settings table; new settings MUST be justified by
  Principle VI.

## Development Workflow

- Commits and version bumps happen only when the maintainer asks. A release bumps `version`
  in `pubspec.yaml`, builds with `scripts/build_apk.sh` (which regenerates
  `lib/core/app_version.dart`) and copies the APK to the maintainer's OneDrive phone folder.
- Commit messages MUST NOT carry attribution lines.
- Maintainer-facing communication uses neutral Latin American Spanish, concise and without
  em dashes.
- Out-of-scope issues noticed during a task MUST be reported, not silently fixed.

## Governance

This constitution supersedes other practices. Amendments require a written change to this
file, a version bump under semantic versioning (MAJOR: a principle removed or redefined
incompatibly; MINOR: a principle or section added or materially expanded; PATCH: wording
and clarifications), an updated Sync Impact Report and propagation to the Spec Kit
templates. Plans MUST pass the Constitution Check in `plan-template.md` before research and
again after design; unavoidable violations MUST be recorded in Complexity Tracking with a
justification. Known compliance gaps listed in the Sync Impact Report MUST be closed through
their own specs, and no new feature may widen them (new screens MUST already support both
themes and both languages once the supporting infrastructure exists).

**Version**: 1.3.0 | **Ratified**: 2026-11-06 | **Last Amended**: 2026-11-06
