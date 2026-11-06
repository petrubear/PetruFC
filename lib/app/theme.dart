import 'package:flutter/material.dart';

import 'style.dart';

/// Nombres de fuente (no cambian con el tema).
class Pt {
  static const ui = 'ZenMaruGothic';
  static const kana = 'ShipporiMincho';
}

/// Estilo de la app (colores, forma, tipografia) en version clara y oscura.
/// Se lee con `context.pt`.
@immutable
class PtStyle extends ThemeExtension<PtStyle> {
  const PtStyle({
    required this.base,
    required this.mantle,
    required this.crust,
    required this.surface0,
    required this.surface1,
    required this.surface2,
    required this.outline,
    required this.text,
    required this.subtext,
    required this.flamingo,
    required this.pink,
    required this.teal,
    required this.yellow,
    required this.green,
    required this.red,
    required this.indigo,
    required this.greenTint,
    required this.redTint,
    required this.yellowTint,
    required this.paper,
    required this.ink,
    required this.paperLine,
    required this.paperBorder,
    required this.guide,
    required this.guideNumber,
    required this.shape,
    required this.shadow,
  });

  final Color base, mantle, crust, surface0, surface1, surface2, outline, text, subtext;
  final Color flamingo, pink, teal, yellow, green, red, indigo;
  final Color greenTint, redTint, yellowTint;
  final Color paper, ink, paperLine, paperBorder, guide, guideNumber;
  final ShapeTokens shape;

  /// Color de la sombra plana de las tarjetas destacadas.
  final Color shadow;

  /// Titulos y numeros grandes (Shippori Mincho).
  TextStyle display(double size, {Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: Pt.kana, fontSize: size, fontWeight: weight, color: color ?? text, height: 1.1);

  /// Etiqueta de seccion en mayusculas.
  TextStyle get label => TextStyle(
      color: subtext, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.7);

  /// `crust` es el color del texto/icono sobre un relleno de acento.
  static const washiDark = PtStyle(
    base: Color(0xFF14120F),
    mantle: Color(0xFF0E0D0B),
    crust: Color(0xFF14120F),
    surface0: Color(0xFF1F1C17),
    surface1: Color(0xFF3A362F),
    surface2: Color(0xFF4A453B),
    outline: Color(0x8CEFE7D6),
    text: Color(0xFFEFE7D6),
    subtext: Color(0xFFB3AA98),
    flamingo: Color(0xFFE8604A),
    pink: Color(0xFFE58FAF),
    teal: Color(0xFF7FC9CF),
    yellow: Color(0xFFE3B65A),
    green: Color(0xFFB5DB8C),
    red: Color(0xFFF29A8A),
    indigo: Color(0xFF9FB0DE),
    greenTint: Color(0x2EB5DB8C),
    redTint: Color(0x2EF29A8A),
    yellowTint: Color(0x2EE3B65A),
    paper: Color(0xFF1F1C17),
    ink: Color(0xFFEFE7D6),
    paperLine: Color(0xFF3A362F),
    paperBorder: Color(0x8CEFE7D6),
    guide: Color(0xFF4A453B),
    guideNumber: Color(0xFFB3AA98),
    shape: ShapeTokens.washi,
    shadow: Color(0x59EFE7D6),
  );

  static const washiLight = PtStyle(
    base: Color(0xFFF4EEE1),
    mantle: Color(0xFFEDE5D3),
    crust: Color(0xFFFFFDF7),
    surface0: Color(0xFFFFFDF7),
    surface1: Color(0xFFE2DCCB),
    surface2: Color(0xFFC9C1AE),
    outline: Color(0xFF1B1A17),
    text: Color(0xFF1B1A17),
    subtext: Color(0xFF5A554B),
    flamingo: Color(0xFFC23A26),
    pink: Color(0xFFA63D63),
    teal: Color(0xFF1F6F77),
    yellow: Color(0xFF8A5F00),
    green: Color(0xFF3E5C25),
    red: Color(0xFF9A2B1B),
    indigo: Color(0xFF2E3A59),
    greenTint: Color(0x243E5C25),
    redTint: Color(0x249A2B1B),
    yellowTint: Color(0x248A5F00),
    paper: Color(0xFFFFFDF7),
    ink: Color(0xFF1B1A17),
    paperLine: Color(0xFFD8D0BD),
    paperBorder: Color(0xFF1B1A17),
    guide: Color(0xFFCFC7B4),
    guideNumber: Color(0xFF857D6B),
    shape: ShapeTokens.washi,
    shadow: Color(0xE61B1A17),
  );

  static PtStyle of(AppStyle style, Brightness b) =>
      b == Brightness.dark ? washiDark : washiLight;

  @override
  PtStyle copyWith() => this;

  @override
  PtStyle lerp(ThemeExtension<PtStyle>? other, double t) {
    if (other is! PtStyle) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PtStyle(
      base: l(base, other.base),
      mantle: l(mantle, other.mantle),
      crust: l(crust, other.crust),
      surface0: l(surface0, other.surface0),
      surface1: l(surface1, other.surface1),
      surface2: l(surface2, other.surface2),
      outline: l(outline, other.outline),
      text: l(text, other.text),
      subtext: l(subtext, other.subtext),
      flamingo: l(flamingo, other.flamingo),
      pink: l(pink, other.pink),
      teal: l(teal, other.teal),
      yellow: l(yellow, other.yellow),
      green: l(green, other.green),
      red: l(red, other.red),
      indigo: l(indigo, other.indigo),
      greenTint: l(greenTint, other.greenTint),
      redTint: l(redTint, other.redTint),
      yellowTint: l(yellowTint, other.yellowTint),
      paper: l(paper, other.paper),
      ink: l(ink, other.ink),
      paperLine: l(paperLine, other.paperLine),
      paperBorder: l(paperBorder, other.paperBorder),
      guide: l(guide, other.guide),
      guideNumber: l(guideNumber, other.guideNumber),
      shape: shape,
      shadow: l(shadow, other.shadow),
    );
  }
}

extension PtContext on BuildContext {
  PtStyle get pt => Theme.of(this).extension<PtStyle>()!;
}

ThemeData buildTheme(AppStyle style, Brightness brightness) {
  final c = PtStyle.of(style, brightness);
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.flamingo,
    onPrimary: c.crust,
    secondary: c.teal,
    onSecondary: c.crust,
    error: c.red,
    onError: c.crust,
    surface: c.base,
    onSurface: c.text,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: Pt.ui,
    scaffoldBackgroundColor: c.base,
    colorScheme: scheme,
    extensions: [c],
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.surface0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(c.shape.small),
        side: BorderSide(color: c.outline, width: c.shape.border),
      ),
      contentTextStyle: TextStyle(color: c.text, fontFamily: Pt.ui),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.crust : c.subtext,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.flamingo : c.surface2,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
  );
}
