# Contract: Localization

- Files: `lib/l10n/app_en.arb` (template) and `lib/l10n/app_es.arb`; config in `l10n.yaml`.
- Supported locales: `en` (first, fallback) and `es`; any Spanish variant resolves to `es`.
- Keys: lowerCamelCase by area, e.g. `homeGreetingStart`, `settingsGoalTitle`, `modeKanaToRomaji`,
  `groupHiraganaOrgans`; every key has a `@key` description in the template.
- Plurals: counts use ICU plural syntax, never string concatenation (for example minutes left,
  mastered words, "N words" in group subtitles, "12/46" stays a placeholder pair).
- Spanish: neutral Latin American Spanish; no regional vocabulary.
- Study content (kana, readings, Japanese words, names in katakana) is never in the catalog.
- Build rule: a key missing from either file fails `flutter gen-l10n`/`flutter analyze`.
- Vocabulary glosses are data (`meaning_es`, `meaning_en`), not catalog keys.
