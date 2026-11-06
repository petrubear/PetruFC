# Contract: Theme Tokens

UI code reads colors only through `context.pt.<token>`; no `Color(0x...)`, `Colors.white` or
`Colors.black` outside the theme file (the stroke-guide and score code included).

| Token | Role | Dark (today) | Light (to define, same family) |
|-------|------|--------------|---------------------------------|
| base | page background | #13171B | warm near-white |
| mantle | side panel background | #0C0E11 | slightly darker than base |
| crust | text/icon on accent fills | #060809 | dark ink |
| surface0 / surface1 / surface2 | cards, borders, strong borders | #1F262D / #2C363F / #3B4754 | white / light gray / mid gray |
| text / subtext | primary and secondary text | #EEF0F2 / #A4ADB7 | dark ink / dark gray (>= 4.5:1) |
| flamingo, pink, teal, yellow, green, red | accent fills | pastel set | same hues; text uses of them get a darker variant |
| greenTint / redTint / yellowTint | mastery tints | 14% alpha of accent | light-mode alpha values |
| paper / ink / paperLine | drawing surface | light paper, dark ink | same paper, border added in dark |

Acceptance: every text/background pair used in the inventory meets contrast 4.5:1 (3:1 for
large text and icons) in both palettes. `Pt.ui` and `Pt.kana` remain static font names.
