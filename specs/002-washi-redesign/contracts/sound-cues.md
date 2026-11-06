# Contract: Sound Cues

All cues are original, synthesized plucked-string phrases in the Japanese in/hirajoshi scale
(D, E-flat, G, A, B-flat), shamisen-inspired. Mono, 22.05 kHz Ogg Vorbis, under 25 KB each.

| Cue | Fires when | Character | Target length |
|-----|------------|-----------|---------------|
| tap | tap on a shared button, menu tile or navigation icon | single soft pluck, quick decay | 0.15-0.25 s |
| correct | a correct answer (flashcard, practice grade "got it", memory pair, build word) | two rising plucks | 0.45 s |
| wrong | a wrong answer | one low damped note | 0.35 s |
| combo | combo milestone (every 5 correct) and mastery | three-note rising run with a short tremolo | 0.8 s |
| goal | daily goal reached | arpeggio flourish ending in a sustained note | 1.4 s |

## Behavior rules

1. Nothing plays when `soundOn` is false (FR-010).
2. A cue never delays the action that triggers it; playback is fire-and-forget.
3. Repeats of the same cue closer than 80 ms are dropped.
4. Playback does not take audio focus and mixes with other audio, so the speech voice and other apps are not cut.
5. If an asset or the player fails, the failure is swallowed; the screen continues.
6. Cues respect device silence (media volume 0 or do-not-disturb), verified in the quickstart.
7. Haptics keep their own setting; a moment may produce a haptic, a sound, both or neither.

## Assets

`assets/sfx/tap.wav`, `correct.wav`, `wrong.wav`, `combo.wav`, `goal.wav`, produced by `tool/make_sfx.py`
(kept in the repo for reproducibility; not shipped in the APK).
