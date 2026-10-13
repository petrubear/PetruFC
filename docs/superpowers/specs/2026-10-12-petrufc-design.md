# Petru FC - Diseno

App Flutter solo para Android, de uso personal, para estudiar japones con flashcards. Empieza con Hiragana y debe crecer (Katakana, Kanji, etc.).

Mockups aprobados (lienzo): https://claude.ai/artifact/51QinWbKsXVbQiku2H3w36

## Alcance v1

- Menu principal generado desde la tabla `modules`. Hoy solo "Hiragana"; Katakana y Kanji se muestran como "Proximamente".
- Menu Hiragana: Flashcards, Practica, Vocabulario.
- 100% offline, sin cuentas. Sin pantallas de progreso (solo se registran estadisticas).

### Flashcards
- Dos modos: Hiragana -> Romaji y Romaji -> Hiragana.
- Una tarjeta con 4 opciones aleatorias (1 correcta). Sesion infinita: verde/rojo al responder, boton "Siguiente", contador de aciertos y errores de la sesion.
- Boton de pronunciacion cuando se muestra hiragana en la tarjeta.
- Selector de sets (interruptores): Basicos (46), Dakuten y handakuten (25), Combinados (33). El pool de preguntas sale de los sets activos. Se guarda en `settings`.

### Practica
- Se muestra el romaji; el estudiante dibuja el hiragana con el dedo en un lienzo; "Borrar" limpia; "Check" muestra el caracter correcto junto al trazo.
- Autoevaluacion: "Lo logre" / "Repasar". Sin reconocimiento automatico (decision: todo offline, sin ML Kit).
- Usa los mismos sets activos que Flashcards.

### Vocabulario
- Palabras solo en hiragana (sin kanji ni katakana). Set inicial: partes del cuerpo, del cabello a los pies (ojos, nariz, boca, etc.).
- Dos modos: Hiragana -> Espanol y Espanol -> Hiragana, 4 opciones, sin romaji visible. Mismo motor y sesion infinita que Flashcards. Boton de pronunciacion cuando se muestra la palabra en hiragana.

## Arquitectura

Capas: UI -> motores -> repositorios (interfaces) -> SQLite (Drift).

- Drift sobre SQLite, Riverpod (estado e inyeccion), go_router (rutas con modulo como parametro, p. ej. `/m/hiragana/flashcards`).
- Los datos se siembran directamente en SQLite desde codigo Dart en `onCreate` de Drift (sin archivos JSON). Migraciones futuras agregan datos nuevos.

```
lib/
  app/        router, tema PetruTheme, breakpoints
  core/
    data/     Drift: tablas, sembrado, repositorios
    audio/    TtsService (flutter_tts)
    layout/   AdaptiveScaffold: slab (<600 dp) o dos paneles (>=600 dp)
  features/
    home/ flashcards/ practice/ vocabulary/
```

### Esquema v1
- `modules`: areas de estudio ("hiragana"; luego "katakana").
- `item_groups`: grupos seleccionables (basicos, dakuten_handakuten, combinados, cuerpo).
- `items`: `module`, `group`, `kind` (kana | word), `text` (japones), `reading` (romaji, unico por item), `meaning_es` (solo palabras), `audio_text` (override de lo que se pronuncia).
- `settings`: clave/valor (grupos activos).
- `review_stats`: `item_id`, `attempts`, `correct`, `last_seen`. Se escribe en cada respuesta; ninguna pantalla la muestra todavia.

### Motor de quiz
Recibe un pool de items y una direccion. Elige un objetivo al azar y 3 distractores con respuesta distinta a la correcta; registra el resultado en `review_stats`. Compartido por Flashcards y Vocabulario.

Romaji duplicado: para que "Romaji -> Hiragana" no sea ambiguo, `reading` es unico. Hepburn repite ji/zu/o, asi que: ぢ = `di`, づ = `du`, を = `wo`.

### Audio
`flutter_tts` en `ja-JP`, offline si el telefono tiene la voz japonesa de Google. Si falta, el boton muestra como instalarla. `audio_text` permite corregir lecturas raras de kana sueltos (p. ej. は).

### Practica (lienzo)
`Listener` + `CustomPainter` con lista de trazos. "Check" revela el caracter correcto; la autoevaluacion se guarda en `review_stats`.

## Diseno visual

- Tema oscuro basado en PetruTheme Dark (`/Users/edison/tools/PetruTheme/design/palette.md`): Base `#13171B`, Mantle `#0C0E11`, Surface0 `#1F262D`, Surface1 `#2C363F`, Text `#EEF0F2`, Subtext0 `#A4ADB7`. Acento Flamingo `#FC8783`; Pink `#FC83DC` (Practica), Teal `#83FCE8` (Vocabulario), Green `#8DFC83` (acierto), Red `#FC83A5` (error). Lienzo de dibujo en Base de PetruTheme Light (`#F7F7F8`), trazo `#1D1D20`.
- Tipografia: Zen Maru Gothic (UI) y Shippori Mincho (caracteres japoneses grandes).
- Pantallas: 8 en slab (390x844) y 5 extendidas (884x820) en el lienzo de mockups.

### Galaxy Z Fold 8
- Un solo codigo con dos disposiciones, elegidas por ancho de ventana (`LayoutBuilder`, corte en 600 dp); cambia en vivo al plegar o desplegar sin reiniciar.
- El estado de la sesion vive en Riverpod, asi sobrevive al cambio de tamano.
- La bisagra se evita con `MediaQuery.displayFeatures`.
- Fuera de v1: postura de mesa y modo apaisado del Fold abierto.

## Verificacion

Sin pruebas automatizadas (decision del usuario: app personal y sencilla). Verificacion manual en emulador de Android plegable: cambio en vivo entre slab y extendida, voz japonesa, dibujo en el lienzo y los dos modos de Flashcards y Vocabulario.
