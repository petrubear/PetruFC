# Quickstart: Verifying the Washi Redesign

Run on the Android emulator (Pixel 7 Pro API 34) or the Fold; no desktop harness is used.

## Setup

1. `flutter pub get`, `flutter gen-l10n`, `flutter analyze` (must be clean).
2. Start the emulator and install: `flutter run -d emulator-5554`.
3. Appearance: `adb shell cmd uimode night yes|no`. Language: `adb shell cmd locale set-app-locales com.petru.petru_fc --locales en|es`.
4. Open Fold: `adb shell wm size 2205x2362` and `adb shell wm density 420`; reset with `wm size reset` and `wm density reset`.
5. Screenshots: `adb exec-out screencap -p > file.png`.

## 1. Look (US1)

Walk every screen in the inventory in light and dark: home, module menu, reference, learn, practice,
flashcards, vocabulary menu/list/practice, word search, games menu/setup/memory/build, settings,
summaries, goal celebration. Expect the style A look from the boards; no screen missing a function
that existed in v1.13.

## 2. Attention design (US2)

Home, flashcard, practice, learn and game screens: one dominant main action, progress visible without
scrolling, primary targets at least 56 dp tall, correct/wrong marked with icon plus color, celebrations
off still shows results.

## 3. Fold (US3)

Open size: home shows module panel left and the 2x3 grid right; pick another module on the left and the
right updates; fold and unfold on at least five screens in both appearances and both languages keeping
the place.

## 4. Sound (US4)

With sound on: a tap, a correct answer, a wrong answer, a combo (5 correct in a row), a goal completion
each play their own cue. Turn sound off in Settings and with the home sound button: silence everywhere;
restart: the choice is kept. Check speech pronunciation is not cut by a cue, and that cues are silent with
media volume at 0 (`adb shell cmd media_session volume --stream 3 --set 0`).

## 5. Upgrade safety

Install v1.13 with some progress, then install this build over it: streaks, mastery colors, daily goal and
settings are preserved.

## 6. Matrix

Repeat the screen walk for: phone/open x light/dark x English/Spanish (8 combinations) and check for
clipping, overflow and unreachable controls; also with a large system font size.

## 7. Future style readiness (US5)

Search `lib` for hard-coded colors, radii and border widths outside the style files: none. The
`style` setting exists with `washi` as the only value and no selector is shown.
