# Data Model: Kanji Module (Grade 1)

## Existing tables used (no column change)

| Table | Use for kanji |
|-------|---------------|
| `modules` | Row `kanji` (glyph 字) set `enabled = 1` |
| `item_groups` | Group `kanji_g1` (module `kanji`, kind `kanji`, name "Grade 1"/"Grado 1", 80 kanji); vocabulary groups `kanji_<topic>` (kind `word`) |
| `items` | One row per kanji (kind `kanji`) and per word (kind `word`) |
| `review_stats` | Same attempts and streak per item id; mastered = streak >= 5 |
| `settings` | Active sets (`active_groups:kanji`), last position of Learn, last route |

## New table: `kanji_details`

| Column | Type | Meaning |
|--------|------|---------|
| `item_id` | integer, primary key, references `items.id` | The kanji item |
| `grade` | integer | School grade (1 for now) |
| `stroke_count` | integer | Number of strokes (from KANJIDIC2) |
| `on_readings` | text | On readings in katakana separated by `、` (may be empty) |
| `kun_readings` | text | Kun readings in hiragana separated by `、` (may be empty), okurigana marked with `.` as in the dictionary |

Relationship: one `kanji_details` row per kanji item; none for words and kana.

## Item fields for a kanji

| Field | Value (example 山) |
|-------|--------------------|
| `japanese` | 山 |
| `reading` | `yama` (romaji of the main reading) |
| `audioText` | やま (main reading in hiragana; used for speech and for the Kanji to Reading answer) |
| `meaningEn` / `meaningEs` | mountain / montaña (primary meaning; unique across the 80) |

Main reading rule: first kun reading (without okurigana marks) if present, otherwise the first on reading in hiragana.

## Item fields for a word

| Field | Value (example 日本) |
|-------|----------------------|
| `japanese` | 日本 |
| `reading` | `nihon` (romaji, like the kana vocabulary) |
| `audioText` | にほん (hiragana reading, shown in the Reference and used for speech) |
| `meaningEn` / `meaningEs` | Japan / Japón |

Validation: every character of `japanese` is one of the 80 grade 1 kanji; each section has at least 8 words.

## Validation rules (checked by `tool/make_kanji.py`)

- Exactly 80 kanji, all with grade 1, a non-empty English and Spanish meaning, at least one reading, a stroke count and strokes.
- Primary meanings are unique per language (so no two options in a question mean the same).
- The number of strokes in `strokes.json` equals `stroke_count`.
- No word has a character outside the 80 kanji; no duplicate word.

## Migration (schema 13)

1. Create `kanji_details`.
2. Set `modules.kanji.enabled = 1`.
3. Insert the group, the 80 kanji items, their details, the word groups and words (same pattern as `upgradeToV7`).
4. No existing row is changed, so progress, streaks and settings are preserved.
5. On a fresh install `seedDatabase` inserts the same rows with the module already enabled.
