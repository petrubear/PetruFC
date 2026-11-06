# Feature Specification: Washi Redesign (Style A)

**Feature Branch**: `002-washi-redesign`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "Redesign the app with style A 'Washi y tinta' (cream paper and ink, red seal, Shippori Mincho type, thin borders, ink rings), in light and dark, and with the Fold open in two panes (modules on the left, a 2x3 function grid with kanji on the right). No existing function may be lost. Built for people with attention deficit: one main action per screen, big buttons, clear progress and feedback, little visual noise. Include shamisen-inspired sounds for menus and actions (taps, correct, wrong, combo, goal reached) that can be turned off in Settings and work offline. Design reference: the Petru FC canvas, board set A. One style for now; the design must allow more styles later as a Settings selector."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A calmer, modern look on every screen (Priority: P1)

The person opens the app and sees a warm paper-and-ink look with a red seal accent, large Japanese-flavored type, thin ink borders and ink-ring progress, instead of the current plain, square, dark look. Every existing screen (home, module menu, reference, learn, practice, flashcards, vocabulary, word search, games, settings, summaries, celebrations) follows the same visual language, in light and in dark, and nothing that worked before is missing or harder to reach.

**Why this priority**: The look is the reason for this work and touches every screen; the other stories depend on it.

**Independent Test**: Walk every screen of the app in light and dark on the phone and compare it with the style A boards; confirm every function listed in the current module menu is still reachable and works.

**Acceptance Scenarios**:

1. **Given** the app in light appearance, **When** the person opens the home screen, **Then** it shows the paper background, seal mark, daily-goal ink ring with the greeting, one large continue button, the module cards with progress, and the week row, matching the style A light board.
2. **Given** the phone set to dark, **When** the person opens the same screens, **Then** they show the ink-dark variant of style A with readable text and the same layout.
3. **Given** any screen of the previous version, **When** the person looks for its function, **Then** it still exists and every action it offered is still available.
4. **Given** the flashcard screen, **When** the person answers, **Then** the correct answer is clearly marked and the combo, score and progress are visible without scrolling.

---

### User Story 2 - Built for attention: one clear action per screen (Priority: P1)

On each screen there is one obvious main action (continue, next, start) that is bigger than the rest, secondary items are quieter, and progress and results are always visible. Answering a question gives immediate, unmistakable feedback. Decorative elements never compete with the task.

**Why this priority**: The audience is people with attention deficit; reducing friction and noise is the purpose of the redesign, not a nice-to-have.

**Independent Test**: On the home, flashcard, practice, learn and game screens, a person can name the main action within a few seconds, and all primary buttons are comfortably tappable.

**Acceptance Scenarios**:

1. **Given** the home screen, **When** the person looks at it, **Then** exactly one button is visually dominant ("continue where you left off") and it resumes the last study position.
2. **Given** any list or menu, **When** the person taps the primary controls, **Then** each tap target is at least 48 dp tall and 48 dp wide.
3. **Given** a study round in progress, **When** the person answers, **Then** result, combo and progress update within one visible step and no extra dismissal is needed to continue.
4. **Given** the setting for celebrations and animations is off, **When** the person finishes a round, **Then** the round still shows its results without animation.

---

### User Story 3 - Fold open: two-pane layout (Priority: P1)

With the Fold open, the home screen shows a module panel on the left (greeting, daily goal, mascot message, module list) and the selected module's functions on the right as a two-column by three-row grid, each with its kanji, title and one-line description, plus the continue button. Folding and unfolding keeps the place. Closed, the app keeps its single-column layout.

**Why this priority**: Foldable support is mandatory (constitution principle II) and the redesign changes the layout of the most important screens.

**Independent Test**: Open and close the Fold on the home and module screens in light and dark; verify nothing is clipped or unreachable and the open layout matches the style A Fold boards.

**Acceptance Scenarios**:

1. **Given** the Fold open, **When** the person views a module, **Then** the six functions appear in a 2x3 grid on the right while the module panel stays on the left.
2. **Given** the Fold open, **When** the person picks another module on the left, **Then** the right side shows that module's functions without leaving the screen.
3. **Given** a screen open on the folded phone, **When** the person unfolds, **Then** the matching open layout appears with the same place and state, and vice versa.

---

### User Story 4 - Shamisen-inspired sounds with a switch (Priority: P2)

Menus and actions play short sounds inspired by the shamisen: a soft pluck for taps and navigation, a bright phrase for a correct answer, a muted note for a wrong one, a rising phrase for combos and a short flourish when the daily goal is reached. A single setting in Settings turns all of them off, and a quick sound button on the home screen shows the current state. The sounds work with no connection and never block or delay an action.

**Why this priority**: It adds atmosphere and feedback but the app works fully without it; it depends on the redesigned screens existing.

**Independent Test**: With sound on, perform a tap, a correct answer, a wrong answer, a combo and a goal completion and hear the matching sound; turn the setting off and repeat with silence; restart the app and confirm the choice is kept.

**Acceptance Scenarios**:

1. **Given** sound on, **When** the person taps a menu entry or button, **Then** a short pluck plays and the screen responds without waiting for it to end.
2. **Given** sound on, **When** the person answers correctly, wrongly, reaches a combo, or reaches the daily goal, **Then** the corresponding distinct sound plays.
3. **Given** the person turns sound off in Settings (or with the home sound button), **When** they use the app, **Then** no sound plays anywhere.
4. **Given** the app is restarted, **When** it opens, **Then** the sound setting keeps its last value.
5. **Given** the phone has no connection, **When** sounds are triggered, **Then** they play normally.

---

### User Story 5 - Ready for more styles later (Priority: P3)

The look is organized so that colors, shapes, fonts and sounds belong to a named style, and style A is the first and only one for now. Adding another style later means providing a new set of those values and offering it in a Settings selector, without redoing the screens.

**Why this priority**: It does not change what the person sees today but avoids a second rewrite; it is satisfied by how the redesign is structured.

**Independent Test**: Review that every screen takes its colors, shapes, fonts and sounds from the active style, and that the active style is stored as a preference with style A as the only value.

**Acceptance Scenarios**:

1. **Given** the redesigned app, **When** a reviewer inspects any screen's visual values, **Then** none are fixed per screen; all come from the active style.
2. **Given** only style A exists, **When** the person opens Settings, **Then** no style selector is shown yet (it appears when a second style exists).

---

### Edge Cases

- Long text in Spanish or English (group names, famous names on two lines) must not clip in the new cards, buttons or the 2x3 grid.
- A very small phone width or large system font size must still show the main action and keep all functions reachable by scrolling.
- Light and dark must both pass readable contrast for text, the red accent and the correct/wrong marks, which must differ by shape or icon as well as color.
- With the mascot turned off, the home and summary screens must still look balanced.
- Sounds must not play while the system is in silent mode, must not overlap into noise when the person taps quickly, and must not stop the speech voice used for pronunciation.
- A first launch or an upgrade keeps all progress, streaks and settings.
- The sound or mascot assets failing to load must never block the screen.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every screen MUST follow style A "Washi y tinta" in light and dark: paper/ink palette, red seal accent, Shippori Mincho for display text, thin ink borders, ink-ring progress, as in the design boards.
- **FR-002**: No existing function MAY be removed or made harder to reach: Reference, Learn, Practice, Flashcards (including script swap), Vocabulary (all lists), Word Search, Memory, Build the Word, Settings, daily goal, mascot, pronunciation and summaries MUST remain.
- **FR-003**: Each screen MUST present one visually dominant main action; secondary actions MUST be visibly quieter.
- **FR-004**: Interactive controls MUST have a touch target of at least 48 dp and the primary action at least 56 dp tall.
- **FR-005**: Progress (position in the round, score, combo, daily goal) MUST be visible on the study screens without scrolling.
- **FR-006**: Correct and wrong answers MUST be distinguishable by more than color (icon or mark plus color) and shown immediately.
- **FR-007**: With the Fold open, the home screen MUST use the two-pane layout (module panel left, function grid 2x3 with kanji right); folded, the single-column layout MUST remain. Both MUST keep the place when folding or unfolding.
- **FR-008**: The six module functions MUST each show a kanji mark, title and one-line description in the grid and in the single-column menu.
- **FR-009**: The app MUST play shamisen-inspired sounds for: tap/navigation, correct answer, wrong answer, combo milestone, and daily goal reached.
- **FR-010**: The person MUST be able to turn all sounds off and on from Settings and from a sound button on the home screen; the choice MUST persist.
- **FR-011**: Sounds MUST work offline, MUST be short enough not to delay actions, MUST not play when the device is silent, and MUST not block or cut the pronunciation voice.
- **FR-012**: All interface text MUST stay available in English and Spanish and all screens MUST keep supporting both light and dark (constitution III and IV).
- **FR-013**: Colors, shapes, fonts and sounds MUST come from a single active style definition, with style A the only style now, so another style can be added later and chosen from Settings.
- **FR-014**: Existing progress, streaks, settings and downloaded data MUST be preserved across the update.
- **FR-015**: Existing settings for vibration, celebrations/animations and mascot MUST keep working; turning celebrations off MUST remove animation but not information.
- **FR-016**: The app MUST remain fully offline and add no new permissions beyond what it has.

### Key Entities *(include if feature involves data)*

- **Visual style**: A named set of palettes (light and dark), type, shapes, spacing and sounds; style A now. One is active.
- **Sound preference**: Whether sounds are on; persisted with the other settings.
- **Sound cue**: One of tap, correct, wrong, combo, goal; each mapped to a short audio phrase of the active style.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the screens in the screen inventory match the style A language in light and dark, with the Fold open and closed (checked with the verification matrix of 8 combinations: posture x appearance x language).
- **SC-002**: 100% of the functions available before the redesign remain reachable from the same module menu in no more taps than before.
- **SC-003**: On the home, flashcard, practice, learn and game screens, a first-time viewer identifies the main action in under 5 seconds.
- **SC-004**: No clipped or overlapping content in any combination of posture, appearance, language and a large system font size.
- **SC-005**: All five sound cues are audible and distinct with sound on, and silent everywhere with sound off, with no delay perceived between action and screen response.
- **SC-006**: Text and key marks reach readable contrast (4.5:1 body text, 3:1 large text and marks) in both appearances.
- **SC-007**: Adding a second style requires no change to any individual screen, only a new style definition and the selector.

## Assumptions

- The audience is the maintainer and similar learners; the app stays Android-only, offline and without accounts.
- The design reference is the style A boards of the Petru FC canvas; where the boards and the current app differ in function, the app's functions win and the boards guide only the look.
- Kanji marks on the function grid (表 筆 練 札 語 遊) replace the previous icons; they are decoration only and are not translated.
- The mascot art stays as is; its placement follows the boards.
- Sounds are short original recordings or synthesized phrases made for this app (no network, no third-party licensing issue); the exact audio is produced during implementation.
- The sound default is on; the haptics setting stays separate from sound.
- The style selector in Settings is not shown while only one style exists.
- The bottom navigation bar of the other style proposals is not part of style A.
- Japanese UI text remains deferred to the Kanji module.
