# Feature Specification: Constitution Compliance

**Feature Branch**: `001-constitution-compliance`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "has la lista de tareas faltantes para cumplir la constitucion"
(refined: ignore Japanese interface support until the Kanji module and remove it from the
constitution)

## User Scenarios & Testing *(mandatory)*

<!--
  Scope: close the compliance gaps recorded in the constitution (principles II, III and IV,
  v1.1.0) and prove them with a full sweep of every screen. A Japanese interface is out of
  scope until the Kanji module.
-->

### User Story 1 - Light and dark appearance (Priority: P1)

A learner uses Petru FC in daylight and at night. The app follows the phone's light or dark
setting, so the learner never has to change anything inside the app, and every screen stays
readable and good-looking in both.

**Why this priority**: Today the app only has a dark look. It is the most visible gap, it
touches every screen, and it is independent of translation work.

**Independent Test**: Switch the phone between light and dark while the app is open and walk
through every screen; each one changes live and nothing is unreadable.

**Acceptance Scenarios**:

1. **Given** the phone is set to light mode, **When** the learner opens the app, **Then** every
   screen shows a light appearance with readable text and clear controls.
2. **Given** the phone is set to dark mode, **When** the learner opens the app, **Then** every
   screen shows the dark appearance it has today, with no visual regression.
3. **Given** the app is open, **When** the phone switches between light and dark, **Then** the
   app changes appearance immediately without restarting and without losing the current screen
   or session.
4. **Given** either appearance, **When** the learner sees the mascot, confetti, mastery colors
   (white, red, yellow, green), progress ring, drawing board and guide strokes, **Then** all of
   them remain clearly distinguishable from their background.

---

### User Story 2 - English and Spanish interface (Priority: P1)

A learner whose phone is set to English or Spanish opens the app and finds every label,
button, message, mascot phrase and setting in that language.

**Why this priority**: The interface is Spanish-only today; the constitution makes English and
Spanish mandatory, and every later feature depends on strings being translatable.

**Independent Test**: Set the phone to each of the two languages in turn, open the app and
visit every screen; no text from the other language appears anywhere in the interface.

**Acceptance Scenarios**:

1. **Given** the phone language is English or Spanish, **When** the app opens, **Then** all
   interface text is shown in that language.
2. **Given** the phone language is neither, **When** the app opens, **Then** the interface is
   shown in English.
3. **Given** the language changes while the app is open, **When** the learner returns to the
   app, **Then** the interface shows the new language without losing progress.
4. **Given** any language, **When** messages with numbers appear (for example "N minutes left",
   "N mastered", "12/46"), **Then** they read naturally in that language, including singular
   and plural forms.
5. **Given** the Spanish interface, **When** text is read, **Then** it is neutral Latin American
   Spanish with no regional dialect.

---

### User Story 3 - Vocabulary meanings in English and Spanish (Priority: P2)

The meaning shown for each vocabulary word (and used in practice, games and word search) is
shown in the interface language, so an English-speaking learner sees English meanings and a
Spanish-speaking learner sees Spanish ones.

**Why this priority**: It depends on Story 2 and requires writing content for every existing
list, so it is delivered after the interface itself.

**Independent Test**: In each interface language, open Reference, Practice, Memory, Build the
Word and Word Search of any vocabulary list and confirm every meaning is in that language.

**Acceptance Scenarios**:

1. **Given** the English interface, **When** a vocabulary list or exercise shows a meaning,
   **Then** it is in English; the same holds for Spanish.
2. **Given** a vocabulary list that exists today, **When** the update is installed, **Then**
   every entry has a meaning in both languages and no entry is lost or duplicated.
3. **Given** the learner already has study progress, **When** the update is installed, **Then**
   all progress, mastery colors, streaks and daily-goal history are preserved.

---

### User Story 4 - Foldable verification sweep (Priority: P2)

After the appearance and language work, the learner can fold and unfold the phone on any
screen, in any appearance and language, and nothing is cut off, overlapped or unreachable.

**Why this priority**: Foldable support already exists on every screen; the risk is that the
new themes and the different text lengths of two languages break it, as a past menu clipping
bug showed.

**Independent Test**: For each screen, check closed and open postures in light and dark and in
both languages, and confirm every control and text is fully visible or reachable by scrolling.

**Acceptance Scenarios**:

1. **Given** any screen, **When** viewed closed or open, in light or dark, in English or
   Spanish, **Then** no text or control is clipped, overlapped or unreachable.
2. **Given** any screen whose content can be taller than the display, **When** the learner
   scrolls, **Then** every item, including the last one, can be reached.
3. **Given** any screen, **When** the phone is folded or unfolded, **Then** the layout changes
   immediately and the learner keeps their place.

---

### Edge Cases

- A phone language is set to a variant (for example Latin American or European Spanish, or a
  regional English): the closest of the two languages is used.
- Very long translated labels (menu subtitles, game and mode names, settings descriptions);
  English and Spanish differ in length, especially in the narrow closed posture.
- Japanese study content (kana, readings, words) mixed with Latin text in the same label; it
  is never translated or altered.
- The app is open on a study session when the appearance or language changes.
- Vocabulary words with more than one meaning or a note in parentheses.
- Content with no natural equivalent in a language (for example a food or cultural item): the
  closest common term is used.
- Drawing surface and guide strokes in light mode, where the board itself is light.
- Existing installs that upgrade: no setting or progress is reset.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST follow the phone's light or dark setting and change appearance live.
- **FR-002**: Every screen, dialog, message bar, overlay and mascot bubble MUST be readable and
  visually consistent in both appearances, with no color that works in only one of them.
- **FR-003**: Mastery colors, progress indicators, the drawing board, guide strokes and
  celebration effects MUST stay distinguishable in both appearances.
- **FR-004**: All interface text MUST be available in English and Spanish and MUST follow the
  phone language, falling back to English for any other language.
- **FR-005**: No interface text MAY remain fixed in a single language, including settings
  descriptions, game and mode names, section and group names, mascot phrases, summary screens,
  errors and accessibility labels.
- **FR-006**: Texts containing numbers MUST read naturally in each language, including plurals.
- **FR-007**: Spanish text MUST be neutral Latin American Spanish.
- **FR-008**: Vocabulary meanings MUST be available in English and Spanish for every existing
  entry and MUST follow the interface language everywhere meanings appear.
- **FR-009**: Japanese study content (kana, readings, words, stroke guides) MUST NOT be
  translated or changed by this feature.
- **FR-010**: Any vocabulary list added in the future MUST include its meanings in both
  supported languages (a standing rule for later features).
- **FR-011**: Every screen MUST remain fully usable in the closed and open postures, in both
  appearances and both languages, with scrolling wherever content can exceed the display.
- **FR-012**: The update MUST preserve all existing progress, statistics, settings and
  daily-goal history.
- **FR-013**: The app MUST keep working fully offline and MUST NOT add accounts, analytics or
  new user-facing settings for appearance or language (they follow the phone).
- **FR-014**: The Settings screen MUST keep showing the app version and the stroke-data
  credit, localized in both languages.
- **FR-015**: A Japanese interface and Japanese-language meanings are out of scope (deferred to
  the Kanji module).

### Key Entities

- **Interface text**: Any label, message or phrase the learner reads; exists once per
  supported language.
- **Vocabulary entry**: A Japanese word with its reading and one meaning per supported
  language; belongs to a vocabulary list in the hiragana or katakana module.
- **Appearance**: The light or dark look in force, chosen by the phone.
- **Screen inventory**: The list of every screen and state (home dashboard, module menu,
  flashcards setup and quiz, practice, learn, reference, vocabulary menu, list, practice and
  word search, games menu, setup, memory and build the word, settings, session summaries,
  goal celebration, mascot bubbles) used to prove compliance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of screens in the screen inventory are readable and visually consistent in
  both light and dark appearances, confirmed by a walkthrough of the full inventory.
- **SC-002**: With the phone set to each of the two languages, 0 interface texts in the other
  language remain on any screen of the inventory.
- **SC-003**: For every screen in the inventory, 0 clipped, overlapped or unreachable elements
  across the 8 combinations of posture (2) x appearance (2) x language (2).
- **SC-004**: 100% of existing vocabulary entries have meanings in English and Spanish.
- **SC-005**: After updating an existing install, 100% of progress and settings are preserved.
- **SC-006**: Changing appearance or language while the app is open takes effect in under 2
  seconds without restarting or leaving the current screen.
- **SC-007**: The constitution's compliance gaps (appearance and languages) are closed, and
  the Sync Impact Report can be updated to state that no known gaps remain.

## Assumptions

- Appearance and language follow the phone; no in-app switches are added (constitution
  principle VI and the maintainer's preference for no unnecessary choices).
- English is the fallback language for any unsupported phone language.
- Foldable support already exists structurally on every screen (each screen has closed and
  open layouts); this feature verifies and repairs it, it does not redesign it.
- The existing dark look is the reference for the dark appearance; the light appearance is
  designed to match it in character (same color family, shapes and mascot).
- Japanese study content, mascot artwork and sound are not translated or redrawn.
- The mascot art is used unchanged in both appearances unless a drawing is unreadable on a
  light background.
- Kanji, furigana, a Japanese interface and Japanese-language meanings are out of scope; they
  return with the Kanji module (constitution v1.1.0, principle IV).
- Dependencies: the constitution v1.1.0 principles II, III, IV and VII define what "done" means.
