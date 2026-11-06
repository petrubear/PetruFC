# Contract: Kanji Data Files

## Sources and licenses

| Data | Source | License | Credit |
|------|--------|---------|--------|
| List, grade, readings, stroke count, meanings (EN, ES) | KANJIDIC2 (EDRDG) | CC BY-SA 4.0 | Settings credit line and `assets/kanji/LICENSE-KANJIDIC2.txt` |
| Stroke paths and numbers | KanjiVG | CC BY-SA 3.0 | Already in Settings; same license file as kana |

## `assets/kanji/strokes.json`

Same format as `assets/kana/strokes.json`:

```json
{ "山": { "p": ["M..c..", "M..c.."], "n": [[x, y], [x, y]] } }
```

- Key: the kanji character. `p`: one path per stroke in drawing order, KanjiVG `M` and `c` commands in a 109 x 109 box.
  `n`: where each stroke number is drawn. The count of `p` equals the stroke count of the kanji.

## Generated seed (`lib/core/data/seed_kanji.dart`)

- One group record: id `kanji_g1`, module `kanji`, kind `kanji`, names "Grade 1" / "Grado 1" (localized by id suffix like other groups).
- 80 item records and 80 detail records as in data-model.md.
- Order = KANJIDIC2 grade 1 order by the usual school sequence (the generator keeps the Ministry list order).

## `tool/kanji_words.txt`

One word per line, tab separated: `section<TAB>word<TAB>hiragana<TAB>romaji<TAB>english<TAB>spanish`.
Sections (ids): `numbers`, `nature`, `body_people`, `school`, `time`, `animals_colors`. The generator rejects a word with a
character outside the grade 1 set, a duplicate, or a section with fewer than 8 words.

## Reproducibility

`python3 tool/make_kanji.py` needs the network once (development only), is idempotent, and rewrites
`seed_kanji.dart`, `seed_kanji_words.dart` and `assets/kanji/strokes.json`. The app never uses the network.
