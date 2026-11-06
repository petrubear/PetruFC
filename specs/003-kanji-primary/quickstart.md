# Quickstart: Verify the Kanji Module

Prerequisites: the app installed on the emulator (Pixel_7_Pro_API_34) and on the real Fold (USB debugging).
Data generation: `python3 tool/make_kanji.py` (needs network once), then `flutter run`.

## 1. Data checks (generator output)

- 80 kanji, grade 1, each with English and Spanish meaning, a reading, a stroke count and strokes.
- Unique primary meanings per language. Word list valid (only the 80 kanji, at least 8 words per section).

## 2. Module

1. Home shows Kanji enabled with 0% (open layout: selectable in the left panel).
2. Module menu: Reference, Learn, Practice, Flashcards, Vocabulary, Games.
3. Reference: 80 tiles in one grade section; tap 山: meaning, サン/セン, やま, 3 strokes, grade 1, sound.
4. Learn: 山 with numbered strokes and the animation; draw; Next; leave and return to the same kanji.
5. Practice: prompt with meaning and reading; draw; Check; percentage; grade.
6. Flashcards: set list grade 1; the 3 modes; no duplicate option; reading type shown in Kanji to Reading; summary.
7. Vocabulary: sections list; Reference with readings and meanings; Practice both ways; no Word search.
8. Games: Memory (kanji and meaning), Build the Word (2+ character words); no Word search.
9. After mastering some kanji (5 correct in a row) the home percentage rises and the Reference tile turns green.

## 3. Matrix (8 combinations)

Fold open/closed x light/dark x English/Spanish on at least: home, Reference with detail, Learn, Practice, a Flashcards
round, Vocabulary Reference, a game, plus a large system font. Fold and unfold keep the place (device state emulation).

## 4. Upgrade safety

Install the previous release with progress, then install this build over it: kana progress, streaks, settings, daily goal
and the last route are intact, and Kanji appears enabled.

## 5. Credits and size

Settings shows the KanjiVG and KANJIDIC2 credits in both languages; the APK grows by less than 1 MB of data.
