# Research: Constitution Compliance

All Technical Context items were resolved from the codebase; no NEEDS CLARIFICATION remain.

## R1 - How to make colors theme-aware

- **Decision**: Replace the static `Pt` color constants with a `ThemeExtension<PtColors>`
  holding a light and a dark palette, read as `context.pt.<token>`. Keep `Pt.ui` and `Pt.kana`
  font names static. `buildTheme()` becomes `buildTheme(Brightness)`; `MaterialApp.router`
  sets `theme`, `darkTheme` and `themeMode: ThemeMode.system`.
- **Rationale**: Flutter rebuilds dependents when the theme changes, so appearance switches
  live without restart; one token set stays the single source (constitution III). Current use:
  about 220 references in 25 files, of which about 26 sit inside `const` expressions that must
  lose `const`; mechanical but contained.
- **Alternatives considered**: (a) a global "is dark" flag read by static getters: no automatic
  rebuilds and still breaks `const`; (b) two copies of each widget: duplication; (c) Material
  `ColorScheme` only: the app's tokens (mastery tints, paper, tints) do not map to it.
- **Token rules**: tokens used as text (accent text, subtext) get darker light-mode variants to
  keep contrast of at least 4.5:1 on light surfaces; accent fills keep their pastel hue with
  dark label text. `paper`/`ink`/`paperLine` (drawing surface) stay light in both appearances
  and gain a border in dark so the board reads as a sheet; mastery tints get light-mode values.
  `Mastery` and `MasteryLegend` (constants today) read tokens from context.

## R2 - Localization mechanism

- **Decision**: Flutter `gen_l10n` with `lib/l10n/app_en.arb` as template and `app_es.arb`,
  `flutter_localizations` + `intl`, generated class `AppLocalizations`, accessed through a
  `context.l10n` extension. English listed first in `supportedLocales`, so it is the fallback.
  Plurals and numbers use ICU placeholders (`{count, plural, ...}`).
- **Rationale**: the constitution requires "the Flutter localization mechanism"; it is
  offline, compile-time checked (missing keys fail the build) and handles plurals.
- **Alternatives considered**: hand-rolled map lookup (no plural support, no compile-time
  check); `easy_localization` or similar packages (new dependency with no benefit here).
- **Spanish rule**: ARB `app_es.arb` is written in neutral Latin American Spanish; the existing
  Spanish strings are the starting point.
- **What counts as a string**: widget text, button labels, snack bars, mascot phrases, mode
  and game names, settings text, summary screens, accessibility labels (`label:` on icon
  buttons), the speech-voice error messages (returned as codes and mapped in the UI), weekday
  initials (from `intl` date symbols), and the app-version line.

## R3 - Database-stored names (groups, sections)

- **Decision**: Do not migrate `item_groups.name/subtitle`. The UI resolves a localized name
  and subtitle from the group id through l10n (`group_<id>` keys, subtitle built from counts
  with plural messages), falling back to the stored Spanish name if a key is missing.
- **Rationale**: avoids rewriting 40+ rows and a second source of truth; new lists only need
  ARB keys. The stored columns remain as an internal fallback.
- **Alternatives considered**: `name_en` columns (more schema, same lookups); rewriting names
  on each language change (fragile).

## R4 - Vocabulary meanings in English

- **Decision**: Add nullable `items.meaning_en` (schema v12). English glosses live in a
  `seed_glosses_en.dart` map keyed by group id and Japanese word, applied (a) at seed time and
  (b) in `upgradeToV12` with `UPDATE ... WHERE module_id/group_id/japanese`. A single
  `Item.meaning(language)` helper returns English or Spanish (Spanish as last resort).
- **Rationale**: 834 entries; a column keeps queries and ordering unchanged and lets the
  progress rows (keyed by item id) stay valid. Matching by (group, word) never reorders ids.
- **Alternatives considered**: translation table (extra joins for every list); ARB keys per
  word (834 keys, poor ownership); machine translation at runtime (needs network, forbidden).
- **Content rule**: English glosses are short common terms equal in sense to the Spanish ones;
  proper names keep their usual English form.

## R5 - Current language inside sessions

- **Decision**: A Riverpod `appLanguageProvider` (en or es) derived from the platform locale
  and updated when it changes. Sessions that bake meanings into generated questions (quiz,
  memory, build word, word search) read it and restart their current round if it changes.
- **Rationale**: language changes are rare; restarting a round on that event is simpler than
  re-deriving every in-flight string and still satisfies the spec (interface chrome updates
  immediately, no progress is lost because answers are already saved).
- **Alternatives considered**: storing ids and resolving text at render time everywhere
  (invasive for the quiz engine); ignoring changes until the session ends (leaves mixed
  languages on screen).

## R6 - Verification approach (no unit tests)

- **Decision**: A temporary widget-render harness (removed before finishing) renders the screen
  inventory in 2 postures x 2 appearances x 2 languages (8 combinations) to PNGs for review,
  using overridden providers for data; plus a manual pass on the Fold. This is the same
  technique used earlier for the Learn and menu screens.
- **Rationale**: catches clipping and contrast problems quickly without adding test code to
  the repository (constitution VII).
- **Alternatives considered**: permanent golden tests (violates VII's spirit and adds upkeep).

## R7 - Order of work

Appearance and language touch the same files, so migrating each file once is cheaper:
foundation first (theme extension, l10n setup, language provider, schema), then one pass per
feature area that applies tokens and strings together, then English glosses, then the sweep.
Stories 1 and 2 stay independently shippable because each file can be migrated for tokens or
strings separately if needed.
