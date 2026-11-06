# Data Model: Washi Redesign (Style A)

No database schema change (`schemaVersion` stays 12, no migration). Everything below is in-app
model or a row in the existing key-value `settings` table.

## VisualStyle (in code, not stored)

| Field | Meaning |
|-------|---------|
| id | `washi` (only value now) |
| palettes | one `PtStyle` color set for light, one for dark (token list in `contracts/style-tokens.md`) |
| shape | radii (small, medium, large, pill), border width, shadow offset |
| type | display font (Shippori Mincho Bold), body font (Zen Maru Gothic) |
| sounds | the set of sound cues for this style (`contracts/sound-cues.md`) |

Relationships: the active `VisualStyle` plus the system appearance (light/dark) selects the `PtStyle`
extension installed in the theme. `context.pt` reads it.

## Preferences (rows in `settings`)

| Key | Type | Default | Notes |
|-----|------|---------|-------|
| `sound` | `'1'` / `'0'` | `'1'` | Master switch for every sound cue. Read like the other flags (`!= '0'` means on). |
| `style` | text | `washi` | Active style id. Unknown or missing values fall back to `washi`. No selector is shown while one style exists. |

`AppSettings` gains `soundOn` (bool) and `styleId` (string); `AppSettingsNotifier` gets
`setSoundOn(bool)` and `setStyle(String)`, following the existing setter pattern.

## SoundCue (enum, in code)

`tap`, `correct`, `wrong`, `combo`, `goal`. Each maps to one asset under `assets/sfx/`.

## State transitions

- `soundOn`: on <-> off from Settings or the home sound button; persists; takes effect immediately.
- Language, appearance and posture changes do not touch these preferences.
