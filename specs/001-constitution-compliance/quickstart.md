# Quickstart: Validating Constitution Compliance

Prerequisites: Galaxy Z Fold (or the Android emulator with a foldable profile), the APK from
`scripts/build_apk.sh`, and `flutter analyze` clean.

## 1. Appearance (User Story 1)

1. Set the phone to light mode, open the app, visit every screen in the inventory.
2. Switch to dark mode with the app open; confirm the screen changes live and keeps its place.
3. Confirm mascot, confetti, mastery colors, progress ring, drawing board and guide strokes
   remain distinguishable in both.

## 2. Languages (User Story 2)

1. Set the phone language to English and visit every screen: no Spanish text anywhere.
2. Set it to Spanish: no English text anywhere; wording is neutral Latin American Spanish.
3. Set it to another language (for example French): the app shows English.
4. Change the language while a quiz is open: the screen updates and the round restarts without
   losing saved answers.

## 3. Vocabulary meanings (User Story 3)

1. In English, open Reference, Practice, Memory, Build the Word and Word Search for three
   different lists: every meaning is English. Repeat in Spanish.
2. Update an install that has progress: mastery colors, streaks and the daily goal are intact,
   and the number of vocabulary items is unchanged.

## 4. Foldable sweep (User Story 4)

For each of the 8 combinations (closed/open x light/dark x English/Spanish) walk the screen
inventory: home, module menu (all six entries reachable), flashcards setup and quiz, practice,
learn, reference, vocabulary menu/list/practice/word search, games menu/setup/memory/build,
settings, session summary, goal celebration, mascot bubbles. Nothing may be clipped,
overlapped or unreachable; fold and unfold on at least five screens.

## Done

All four sections pass, `flutter analyze` is clean, the temporary render harness is removed,
and the constitution's Sync Impact Report is updated to say no known gaps remain.
