# Implementation Plan: Constitution Compliance

**Branch**: `001-constitution-compliance` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-constitution-compliance/spec.md`

## Summary

Close the two known gaps of constitution v1.1.0 and prove the foldable principle holds
afterwards: (1) add a light appearance and follow the phone's light/dark setting, by turning
the static color class `Pt` into a theme extension with light and dark palettes; (2) add
English next to Spanish for all interface text and vocabulary meanings, using Flutter's
built-in localization (ARB files, English template, ICU plurals) and a new `meaning_en`
column filled by a schema migration; (3) run a screen-by-screen verification sweep (posture x
appearance x language). Japanese interface support is out of scope (deferred to Kanji).

## Technical Context

**Language/Version**: Dart 3.9 / Flutter 3.35.2

**Primary Dependencies**: flutter_riverpod 2.6, go_router 17, drift 2.31 (existing); adds
`flutter_localizations` (SDK) and `intl` (required by it) - see Constitution Check

**Storage**: SQLite via Drift; `schemaVersion` 11 -> 12 (new nullable `items.meaning_en`)

**Testing**: no unit tests (constitution VII); `flutter analyze`; temporary widget-render
harness for the verification sweep (removed afterwards); manual run on the Fold

**Target Platform**: Android (Galaxy Z Fold, slab and extended postures)

**Project Type**: mobile-app (single Flutter project)

**Performance Goals**: appearance or language change visible in under 2 s with no restart

**Constraints**: offline-only; no new user-facing settings (appearance and language follow
the phone); existing progress preserved; APK size growth under 1 MB

**Scale/Scope**: ~25 files using color tokens (~220 uses), ~25 files with UI strings (about
150 strings), 834 vocabulary entries needing English meanings, ~25 screens/states in the
verification inventory

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Architecture**: stays in `lib/app` (theme, router), `lib/core`, `lib/features`; new
  `lib/l10n` for ARB files is a resource folder, not a layer. Riverpod/go_router/Drift only.
  Schema change is v12 with an incremental `onUpgrade` step that keeps progress. New
  dependencies `flutter_localizations` (SDK) and `intl` are the standard Flutter mechanism the
  constitution names ("Flutter localization mechanism") and work offline; justified.
- [x] **II. Foldable**: no layout redesign; the sweep (User Story 4) verifies and repairs both
  postures; changes that alter sizes (text length, new theme) are re-checked in both.
- [x] **III. Look**: this feature delivers the light/dark requirement; tokens only.
- [x] **IV. Languages**: this feature delivers English + Spanish UI and glosses; Japanese UI
  explicitly deferred by the constitution itself.
- [x] **V. Offline**: no network, accounts or telemetry; assets and ARB files bundled.
- [x] **VI. Low friction**: no new settings; appearance and language follow the phone.
- [x] **VII. Verification**: `flutter analyze` clean; sweep in both postures, both themes and
  both languages; temporary harness removed.

No violations; Complexity Tracking not needed. Post-design re-check: still passes (design in
`research.md` and `data-model.md` introduces no new layer, setting or network use).

## Project Structure

### Documentation (this feature)

```text
specs/001-constitution-compliance/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── theme-tokens.md
│   └── localization.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── app.dart            # theme/darkTheme/themeMode, localization delegates, supportedLocales
│   └── theme.dart          # PtColors ThemeExtension (light + dark), context.pt accessor
├── l10n/
│   ├── app_en.arb          # template (source of truth for keys)
│   └── app_es.arb
├── core/
│   ├── data/
│   │   ├── tables.dart         # Items.meaningEn
│   │   ├── database.dart       # schemaVersion 12, upgradeToV12
│   │   ├── seed.dart / seed_topics.dart   # meaning_en on insert
│   │   └── seed_glosses_en.dart            # English glosses keyed by group and word
│   ├── l10n/language.dart      # context.l10n, appLanguageProvider, Item.meaning()
│   └── widgets/ ...            # migrated to context.pt and l10n
└── features/ ...               # migrated to context.pt and l10n
l10n.yaml                       # gen_l10n config
```

**Structure Decision**: single Flutter project, existing layout kept. The only new top-level
resource is `lib/l10n/` (ARB files) plus `l10n.yaml`; a small `lib/core/l10n/language.dart`
holds the language helpers next to the other core services.

## Complexity Tracking

No constitution violations to justify.
