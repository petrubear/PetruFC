# Data Model: Constitution Compliance

## Items (existing table, one new column)

| Field | Type | Notes |
|-------|------|-------|
| id | int (PK) | unchanged; review progress is keyed by it |
| moduleId, groupId, kind | text | unchanged |
| japanese, reading | text | study content, never translated |
| meaningEs | text, nullable | existing Spanish gloss (kept) |
| **meaningEn** | text, nullable | NEW English gloss (schema v12) |
| audioText | text, nullable | unchanged |

**Rules**
- Words (`kind = 'word'`) MUST have both glosses after the migration; kana rows have neither.
- `Item.meaning(language)` returns the gloss for the language, or the other one only as a
  last resort (never empty for words).
- Migration `upgradeToV12`: add the column, then fill it from the English gloss map by
  (groupId, japanese). Rows with no match keep `null` and are reported by the verification
  sweep (success criterion SC-004 requires zero).
- No other table changes; `review_stats`, `daily_activity` and `settings` keep their data.

## Item groups (existing; no schema change)

`item_groups.name` and `subtitle` stay as stored (Spanish). The UI shows names and subtitles
from ARB keys by group id with the stored values as fallback (see research R3).

## Localized message catalog (new resource, not a table)

| Entity | Fields | Rules |
|--------|--------|-------|
| Message | key, English text (template), Spanish text, placeholders | every key exists in both ARB files; placeholders identical in both |
| Plural message | key, count placeholder, forms | English: one/other; Spanish: one/other |

## Appearance and language state

Both are derived from the platform and are not stored: no settings rows are added.
