# Contract: Style Tokens (washi)

Screens read values only through `context.pt.<token>`. No `Color(0x...)`, hard-coded radius or
border width outside `lib/app/theme.dart` / `lib/app/style.dart`. Existing token names are kept so the
screens migrate by value; new tokens are marked (new).

## Colors

| Token | Role | Light (paper) | Dark (ink) |
|-------|------|---------------|------------|
| base | page background | #F4EEE1 | #14120F |
| mantle | side panel background | #EDE5D3 | #0E0D0B |
| crust | text/icon on accent fills | #FFFDF7 | #14120F |
| surface0 | cards | #FFFDF7 | #1F1C17 |
| surface1 | soft lines, tracks | #E2DCCB | rgba(239,231,214,.16) as solid #3A362F |
| surface2 | stronger lines, disabled | #C9C1AE | #4A453B |
| outline (new) | thin ink border | #1B1A17 | #EFE7D6 at 55% |
| text | primary text | #1B1A17 | #EFE7D6 |
| subtext | secondary text | #5A554B | #B3AA98 |
| flamingo (shu) | primary accent | #C23A26 | #E8604A |
| teal (asagi) | vocabulary accent | #1F6F77 | #7FC9CF |
| pink (sakura) | practice accent | #A63D63 | #E58FAF |
| yellow (kincha) | reference accent | #8A5F00 | #E3B65A |
| green (matcha) | correct, success | #3E5C25 | #B5DB8C |
| red | wrong, error | #9A2B1B | #F29A8A |
| indigo (new) | Katakana accent | #2E3A59 | #9FB0DE |
| greenTint / redTint / yellowTint | mastery tints | accent at 14% over paper | accent at 18% over ink |
| paper / ink / paperLine / paperBorder | stroke board | unchanged from today | unchanged, border from outline |
| guide / guideNumber | learn guide | unchanged | unchanged |

Acceptance: body text and small accent text reach 4.5:1 in both modes; large text and marks 3:1.
Correct and wrong answers always carry an icon or mark as well as color.

## Shape (new)

| Token | Value |
|-------|-------|
| radiusSmall / radiusMedium / radiusLarge | 14 / 22 / 28-32 dp |
| radiusPill | 999 |
| borderWidth | 1.5 dp |
| shadowOffset | 0 14 dp spread -8 dp at 90% ink (light), 35% paper (dark); used on hero cards only |
| minTap | 48 dp; primary action 56 dp |

## Type (new)

| Token | Value |
|-------|-------|
| display | Shippori Mincho, Bold, for titles and numbers |
| body | Zen Maru Gothic (existing `Pt.ui`) |
| kana | Shippori Mincho (existing `Pt.kana`) |
| label | 12 sp, letter-spacing .14 em, bold, subtext, uppercase labels |

## Style selection

`AppStyle.washi` is the only value. `buildTheme(style, brightness)` installs the matching `PtStyle`
in the theme extensions. Adding a style means adding an enum value and its two palettes/shape/type
set; no screen changes (SC-007).
