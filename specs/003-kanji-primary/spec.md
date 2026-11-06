# Feature Specification: Kanji Module (Primary School Kanji)

**Feature Branch**: `003-kanji-primary`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "Kanji section with the primary school kanji (kyoiku kanji, 1006 in total, grades 1 to 6; this first delivery covers grade 1 only, 80 kanji), following the same structure as Hiragana and Katakana: a Kanji module with the six functions (Reference, Learn stroke by stroke, Practice drawing with the finger, Flashcards, Vocabulary by topic and Games), progress per module, and the existing daily goals and mascot. Each kanji with on and kun readings, meaning in English and Spanish, and strokes. Offline, light and dark, English and Spanish, Fold open and closed, with the current washi style, without losing any existing function."

## Clarifications

### Session 2026-11-06

- Q: En "Kanji a Lectura", ¿qué lectura es la correcta y cómo se evitan ambigüedades? → A: Una lectura principal por kanji, con el tipo (kun u on) indicado en la pregunta; cualquier lectura válida del kanji cuenta como correcta y las opciones erróneas nunca son una lectura válida de ese kanji.
- Q: ¿Qué tamaño tiene el vocabulario con kanji en la primera entrega? → A: Mediano por tema (10 secciones), solo con kanji de primaria; reajustado por la respuesta siguiente a las palabras que se pueden escribir solo con los kanji de grado 1.
- Q: ¿Cómo se entrega el módulo (1006 kanji)? → A: Solo grado 1 (80 kanji) en esta entrega, con las seis funciones completas; los grados 2 a 6 se agregan después con la misma estructura, solo con datos nuevos.
- Q: ¿Qué juegos tiene Kanji? → A: Memorama (kanji con significado o lectura) y Arma la palabra (ordenar los kanji de una palabra); sin Sopa de letras, ni en Juegos ni en Vocabulario, por ahora.
- Q: ¿Qué se espera de la comparación de Practicar con kanji? → A: Lo mismo que en kana: porcentaje de parecido orientativo y la persona decide si lo logró; no se valida el orden ni el número de trazos.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open the Kanji module and browse the kanji (Priority: P1)

The person opens the Kanji card on the home screen (today marked "soon") and finds the same module menu as Hiragana and Katakana, with the six functions. In Reference they see the grade 1 kanji (80) in a table, in a structure that already supports grades 2 to 6 to be added later; tapping a kanji shows its meaning in the app language, its on and kun readings, its stroke count and its grade, and plays its pronunciation.

**Why this priority**: Without the module and its data nothing else works; it is also useful alone as a lookup chart.

**Independent Test**: Open Kanji from home, open Reference, scroll the grade 1 table, tap a kanji and see its meaning, readings and stroke count; do it in light and dark, English and Spanish, Fold open and closed.

**Acceptance Scenarios**:

1. **Given** the home screen, **When** the person taps Kanji, **Then** the module menu opens with Reference, Learn, Practice, Flashcards, Vocabulary and Games, in the same order and style as Hiragana and Katakana.
2. **Given** the Kanji Reference, **When** the person looks at it, **Then** the 80 grade 1 kanji appear in a table with the count, colored by mastery as in the kana reference.
3. **Given** a kanji in the Reference, **When** the person taps it, **Then** a detail shows the kanji, meaning in the app language, on readings, kun readings, stroke count and grade, and the pronunciation can be played.
4. **Given** the Fold open, **When** the person opens the module, **Then** the two-pane layout with the 2x3 function grid is used, as for kana.

---

### User Story 2 - Learn and practice writing kanji stroke by stroke (Priority: P1)

In Learn, each kanji is shown with a grey guide, numbered strokes and an animation of the stroke order; the person draws over it with the finger, with Previous, Next and Clear, and the app remembers where they stopped. In Practice, the person sees the meaning or reading, draws the kanji from memory, taps Check, sees the correct kanji and a similarity percentage, and decides whether they got it.

**Why this priority**: Writing is the core skill of the module and the main reason kanji need strokes.

**Independent Test**: Open Learn on a grade 1 kanji, watch the stroke animation, draw it, move to the next one, leave and return to the same place; in Practice draw a kanji from memory and see the check result.

**Acceptance Scenarios**:

1. **Given** Learn, **When** a kanji is shown, **Then** its strokes are numbered and the stroke order can be animated and hidden or shown.
2. **Given** Learn, **When** the person leaves and returns, **Then** the same kanji is shown.
3. **Given** Practice, **When** the person draws and taps Check, **Then** the correct kanji, a similarity percentage and the grading buttons are shown, and the answer is saved.
4. **Given** the dark appearance, **When** Learn or Practice is open, **Then** the drawing board uses the dark paper style like the kana ones.
5. **Given** kanji with many strokes, **When** they are drawn, **Then** the board stays usable (no clipped strokes) on phone and Fold.

---

### User Story 3 - Study kanji with flashcards by grade (Priority: P1)

In Flashcards the person chooses which grade sets to practice (only grade 1 exists for now, selected), and a mode: Kanji to Meaning, Meaning to Kanji, and Kanji to Reading. Each round has four options, the pronunciation button, finite rounds with score and combo, and a summary, as in the kana flashcards. There is also the multiple selection option (9 kanji in 3 blocks of 3) like kana.

**Why this priority**: Flashcards are the main daily-use activity and give the mastery colors and the daily goal progress.

**Independent Test**: Start a round with grade 1, answer correct and wrong, see the combo, the summary and the mastery color change in the Reference; repeat with multiple selection.

**Acceptance Scenarios**:

1. **Given** Flashcards setup, **When** the person opens it, **Then** the available grade sets are listed with their kanji count (grade 1: 80) and at least one set always stays on; later grades appear automatically when their data is added.
2. **Given** a round, **When** the person answers, **Then** correct and wrong are marked with an icon and color, combo and progress update, and results are saved to the mastery data.
3. **Given** a round finished, **When** the summary shows, **Then** it offers again and exit, and the time counts for the daily goal.
4. **Given** the app language is Spanish or English, **When** a meaning mode is used, **Then** options use the meaning in that language, and the round restarts if the language changes.

---

### User Story 4 - Vocabulary with kanji by topic (Priority: P2)

Vocabulary offers sections by topic (for example numbers, nature, body, people, school, time) with words written only with the grade 1 kanji. Each section has a Reference (word, reading, meaning), and a Practice in both directions, like the kana vocabulary (no Word search for kanji in this delivery).

**Why this priority**: Gives context to the kanji and reuses the vocabulary structure, but the module is useful without it.

**Independent Test**: Open Vocabulary in Kanji, open a section, see its word list, run a practice round.

**Acceptance Scenarios**:

1. **Given** Kanji Vocabulary, **When** it opens, **Then** the sections are listed with their word count.
2. **Given** a section, **When** its Reference opens, **Then** each word shows the kanji form, its reading in hiragana and its meaning in the app language.
3. **Given** a word list, **When** a Practice starts, **Then** it works as in the kana vocabulary and uses the same mastery and daily goal.

---

### User Story 5 - Games, progress and daily goal with kanji (Priority: P2)

Games offers Memory (kanji with meaning or reading) and Build the Word (with kanji words); there is no Word search for kanji in this delivery. The home shows the progress of the Kanji module like Hiragana and Katakana, the Kanji time counts for the daily goal, and the mascot and sound cues behave the same.

**Why this priority**: Completes parity with the other modules; each part reuses existing mechanisms.

**Independent Test**: Play Memory and Build the Word with kanji, then check the home: the Kanji card shows a progress percentage that grows with mastered kanji and the day minutes grow.

**Acceptance Scenarios**:

1. **Given** Games, **When** the person starts Memory with kanji, **Then** pairs match kanji with meaning (or reading) and the result is saved.
2. **Given** the home, **When** kanji are mastered, **Then** the Kanji card progress updates as a percentage of the 80 available kanji.
3. **Given** the Fold open, **When** the person selects Kanji on the left, **Then** the right panel shows its header and the function grid.

---

### Edge Cases

- Kanji with several readings or many on/kun readings must show all of them without clipping, on phone and Fold, in both languages and large system font.
- Kanji with many strokes (up to about 20) must have the guide, numbers and animation legible, and the stroke comparison in Practice must still give a fair percentage.
- Multiple-choice options must not repeat the same meaning twice (kanji with identical or near-identical meanings must not appear together as options).
- Spanish meanings missing for a kanji must fall back to English, never to an empty text.
- Vocabulary words use only grade 1 kanji for now; a section with too few words that can be written this way is not created, and words that need other kanji are left out.
- The upgrade from the previous version must keep all kana and vocabulary progress, streaks, settings and the daily goal.
- With celebrations or sound off, the module behaves like the other modules.
- The module must keep opening and scrolling without noticeable delay when grades 2 to 6 (1006 kanji) are added later.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST provide a Kanji module, enabled in the home and in the Fold module panel, replacing the "soon" card, with the same six functions in the same order and routes pattern as Hiragana and Katakana.
- **FR-002**: The module MUST include the 80 grade 1 primary school kanji in this delivery, organized as a grade set so that grades 2 to 6 (160, 200, 200, 185 and 181 kanji, 1006 in total) can be added later with data only and no screen changes.
- **FR-003**: Each kanji MUST have: its character, a meaning in English and in Spanish, its on readings, its kun readings, its stroke count, its grade and its stroke data.
- **FR-004**: Reference MUST list the available kanji by grade with mastery colors, a count per grade, and a detail with meaning (app language), readings, stroke count, grade and pronunciation.
- **FR-005**: Learn MUST show each kanji with guide, numbered strokes, stroke-order animation, drawing with the finger, Previous, Next, Clear, and remember the last position.
- **FR-006**: Practice MUST ask for the kanji from its meaning or reading, accept a finger drawing, reveal the correct kanji with a similarity percentage and let the person grade themselves.
- **FR-007**: Flashcards MUST allow choosing grade sets (grade 1 is the only one for now, at least one on), the modes Kanji to Meaning, Meaning to Kanji and Kanji to Reading, four options per question, finite rounds, combo, summary, and the multiple selection option. In Kanji to Reading the question states the reading type (kun or on), any valid reading of the kanji is correct, and wrong options are never a valid reading of that kanji.
- **FR-008**: Vocabulary MUST offer topic sections of words written only with the grade 1 kanji (about 8 to 20 words per section, only sections that reach at least 8 words), each with Reference and two-way Practice (no Word search for kanji in this delivery), with readings and meanings in the app language.
- **FR-009**: Games MUST include Memory (kanji matched with meaning or reading) and Build the Word (ordering the kanji of a word, for example 山 and 川) with kanji content and the grade or section scope selector used by the kana games; Word search is not offered for kanji in this delivery.
- **FR-010**: Answers, mastery colors (unseen, missed, learning, mastered), the daily goal time, the last position and the progress percentage MUST work for Kanji the same way as for kana, stored on the device.
- **FR-011**: The home MUST show Kanji progress as a percentage (mastered kanji over the kanji available, 80 for now) like the other modules, and the "continue where you left off" button MUST work for Kanji study screens.
- **FR-012**: The module MUST follow the washi style in light and dark, the single-column layout when folded and the two-pane layout when open, 48 dp touch targets, and keep all sounds, haptics, effects and mascot settings.
- **FR-013**: All interface text MUST exist in English and Spanish; meanings follow the app language, falling back to English when a Spanish meaning is missing.
- **FR-014**: The module MUST work fully offline; all data, stroke data and sounds ship with the app and no new permission is added.
- **FR-015**: No existing function of Hiragana, Katakana, the home, settings or games MUST be removed or made harder to reach, and existing progress and settings MUST be preserved on update.
- **FR-016**: Third-party kanji and stroke data MUST be credited in the app (Settings credit line) according to their license.

### Key Entities *(include if feature involves data)*

- **Kanji**: character, grade, stroke count, on readings, kun readings, meaning in English, meaning in Spanish, stroke paths.
- **Kanji group**: a grade (only 1 for now, up to 6) used as a set in Flashcards, Practice and Games, with name and count.
- **Kanji word**: a vocabulary word written with kanji, with its hiragana reading, meanings in both languages and the topic section it belongs to.
- **Study record**: for each kanji or word, attempts, correct streak and last result, used for mastery colors, progress percentage and daily goal (existing mechanism).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the 80 grade 1 kanji are present, each with a non-empty English and Spanish meaning, at least one reading and stroke data.
- **SC-002**: From the home, the person reaches any of the six Kanji functions in no more taps than for Hiragana or Katakana.
- **SC-003**: The Reference opens and scrolls without visible delay on the Fold and on a phone.
- **SC-004**: 100% of the kanji can be drawn in Learn and Practice with their stroke order animation legible, including those with the most strokes.
- **SC-005**: In Flashcards, no question shows two options with the same meaning, and the answer is graded and saved 100% of the time.
- **SC-006**: Every screen of the module passes the 8-combination check (Fold open or closed, light or dark, English or Spanish) with no clipped content, including a large system font.
- **SC-007**: After updating from the previous version, 100% of kana progress, streaks and settings are intact.
- **SC-008**: The credits for third-party data are visible in Settings and the app size grows by less than 25 MB.

## Assumptions

- The kanji list is the Japanese Ministry of Education list of 1006 primary school kanji (80, 160, 200, 200, 185, 181 per grade); the grade assignment follows that list. This delivery includes only grade 1; grades 2 to 6 are future deliveries that reuse the same structure.
- Stroke data comes from the same open source used for kana (KanjiVG), and readings and meanings come from an open dictionary of kanji data (such as KANJIDIC2) with its license credited; Spanish meanings are produced during implementation and reviewed, falling back to English if one is missing.
- Words for Vocabulary are a curated set of common words written only with the 80 grade 1 kanji (an estimated 100 to 150 words in about 6 to 8 topic sections such as numbers, nature, body, people, school and time, each with at least 8 words), built in the same way as the kana vocabulary; the exact topics are decided during planning. The earlier target of about 350 words is not reachable with grade 1 alone and grows when later grades are added.
- Mastery uses the same rule as kana (streak of 5 correct answers), and progress is mastered kanji over the total.
- Flashcards mode "Kanji to Reading" asks for one main reading per kanji (kun when available, otherwise on), states its type (kun or on) in the question, accepts any valid reading of the kanji as correct, and never offers as a wrong option a reading that is valid for that kanji.
- The pronunciation voice reads the kanji or the word with the installed Japanese voice, as for kana.
- Learn follows the Reference order (by grade, then by the list order); the first run opens on the first kanji of grade 1.
- The stroke comparison in Practice uses the same local approach as for kana, applied to the kanji font and shapes: the percentage is indicative only, the person decides if they got it, and the order and number of strokes are not validated.
- The Japanese interface remains out of scope; kanji are content, not interface text.
- No new Settings are needed; the existing sound, effects, haptics and mascot settings apply.
