# Contract: Kanji Screens and Flows

Same module menu and routes as the kana modules (`/m/kanji/...`); the six entries keep order and kanji marks.

| Entry | Route | Kanji behavior |
|-------|-------|----------------|
| Reference | `/m/kanji/reference` | New screen: section per grade (80 kanji now) with mastery-colored tiles and a bottom sheet detail |
| Learn | `/m/kanji/learn` | Same screen with `assets/kanji/strokes.json`; the label shows the meaning; speaker plays the main reading |
| Practice | `/m/kanji/practice` | Prompt shows meaning and main reading; draw; Check; same percentage and grading |
| Flashcards | `/m/kanji/flashcards` | Set list of grades + the 3 kanji modes |
| Vocabulary | `/m/kanji/vocabulary` | About 6 sections; each with Reference and Practice only |
| Games | `/m/kanji/games` | Memory and Build the Word |

## Kanji detail sheet

Opens from a Reference tile. Shows: the kanji large (display type), meaning in the app language, on readings, kun readings,
stroke count, grade, and a speaker button (speaks the main reading). Closes with the back gesture. Scrolls if it does not fit.

## Home

The Kanji card is enabled with a progress bar and percentage (mastered over 80). In the open layout it is selectable in the
left panel and shows its header (漢字 / かんじ label, kanji glyph) and the 2x3 grid on the right.

## Common constraints

48 dp touch targets, washi tokens only, light and dark, English and Spanish (meanings with English fallback), long
reading lists wrap and never clip, the Fold keeps the place.
