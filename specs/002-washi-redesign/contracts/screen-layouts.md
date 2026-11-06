# Contract: Screen Layouts

Reference: the style A boards of the Petru FC canvas. Where a board and the app differ in function,
the app's function wins (spec Assumptions).

## Home, closed (single column)

Header (seal + name, sound button, settings) -> greeting with `InkRing` (12 of 20 min) -> hero card
"Continue where you left off" with one dominant button -> Hiragana and Katakana cards with progress
-> week row. Kanji "soon" card stays below the fold when present.

## Home, open (two panes, `isExpanded`)

Left (about 312 dp): seal and name, sound and settings buttons, ring with greeting, mascot message,
module list (Hiragana selected, Katakana, Kanji "soon"). Right: selected module header with its
large kana, the continue button, and the function grid.

## Module menu (closed) and function grid (open)

Six entries, same order and routes as today: Reference, Learn, Practice, Flashcards, Vocabulary,
Games. Closed: one entry per row with its kanji. Open: 2 columns x 3 rows, each tile with kanji,
title, subtitle.

| Entry | Kanji | Route |
|-------|-------|-------|
| Reference | 表 | `/m/:module/reference` |
| Learn | 筆 | `/m/:module/learn` |
| Practice | 練 | `/m/:module/practice` |
| Flashcards | 札 | `/m/:module/flashcards` |
| Vocabulary | 語 | `/m/:module/vocabulary` |
| Games | 遊 | `/m/:module/games` |

## Study screens (flashcards, practice, learn, vocabulary practice, games)

Top row: close, mode label, progress bar and count, score chips. One large card with the prompt
(kana in display type with faint guide lines), pronunciation button on the card, four answer tiles
(2x2, at least 72 dp tall), one primary "Next" button anchored at the bottom. Correct tile: matcha
tint plus check mark; wrong: shu tint plus cross mark.

## Settings

Adds "Sound" (switch, default on) under Feedback. A style selector is not shown while one style exists.

## Constraints common to all

48 dp minimum touch targets, 56 dp for the primary action; scrolling where content can exceed the
viewport; layouts tolerate long English and Spanish text (famous names on two lines).
