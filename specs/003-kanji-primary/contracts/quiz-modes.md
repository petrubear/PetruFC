# Contract: Kanji Quiz Modes

New `QuizMode` values with `kind = 'kanji'`, used by Flashcards when the module is Kanji.

| Mode | Prompt | Correct answer | Wrong options |
|------|--------|----------------|---------------|
| kanjiToMeaning | the kanji | primary meaning in the app language | other kanji meanings (all primary meanings are unique) |
| meaningToKanji | the meaning in the app language | the kanji | other kanji |
| kanjiToReading | the kanji, with the reading type shown ("kun" or "on") | main reading in hiragana (katakana for on); any valid reading of the kanji is also accepted | readings of other kanji that are not valid readings of the asked kanji |

## Rules

1. Four options per question, no duplicates, the correct option in a random position.
2. For kanjiToReading, the question label states the reading type of the asked reading. Options are of the same type.
3. Multiple selection (9 kanji in 3 blocks of 3) works as for kana.
4. The set list shows the available grade sets (grade 1 now); at least one stays on.
5. A language change restarts the round (the session already watches the language).
6. Badges in the mode tiles: `山→mountain`, `mountain→山`, `山→やま`.
7. Words use the existing `wordToMeaning` and `meaningToWord` modes unchanged.

## Games

- Memory, scope Characters: pairs of the kanji and its meaning (app language). Scope Vocabulary: word and meaning.
- Build the Word, scope Vocabulary: only words of two or more characters.
- Word search is not offered for Kanji (games menu and vocabulary section menu).
