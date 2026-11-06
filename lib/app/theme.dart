import 'package:flutter/material.dart';

/// Nombres de fuente (no cambian con el tema).
class Pt {
  static const ui = 'ZenMaruGothic';
  static const kana = 'ShipporiMincho';
}

/// Paleta de la app, en version oscura y clara. Se lee con `context.pt`.
@immutable
class PtColors extends ThemeExtension<PtColors> {
  const PtColors({
    required this.base,
    required this.mantle,
    required this.crust,
    required this.surface0,
    required this.surface1,
    required this.surface2,
    required this.text,
    required this.subtext,
    required this.flamingo,
    required this.pink,
    required this.teal,
    required this.yellow,
    required this.green,
    required this.red,
    required this.greenTint,
    required this.redTint,
    required this.yellowTint,
    required this.paper,
    required this.ink,
    required this.paperLine,
    required this.paperBorder,
    required this.guide,
    required this.guideNumber,
  });

  final Color base, mantle, crust, surface0, surface1, surface2, text, subtext;
  final Color flamingo, pink, teal, yellow, green, red;
  final Color greenTint, redTint, yellowTint;
  final Color paper, ink, paperLine, paperBorder, guide, guideNumber;

  /// `crust` es el color del texto/icono sobre un relleno de acento.
  static const dark = PtColors(
    base: Color(0xFF13171B),
    mantle: Color(0xFF0C0E11),
    crust: Color(0xFF060809),
    surface0: Color(0xFF1F262D),
    surface1: Color(0xFF2C363F),
    surface2: Color(0xFF3B4754),
    text: Color(0xFFEEF0F2),
    subtext: Color(0xFFA4ADB7),
    flamingo: Color(0xFFFC8783),
    pink: Color(0xFFFC83DC),
    teal: Color(0xFF83FCE8),
    yellow: Color(0xFFFCD583),
    green: Color(0xFF8DFC83),
    red: Color(0xFFFC83A5),
    greenTint: Color(0x248DFC83),
    redTint: Color(0x24FC83A5),
    yellowTint: Color(0x24FCD583),
    paper: Color(0xFFF7F7F8),
    ink: Color(0xFF1D1D20),
    paperLine: Color(0xFFD1D0DD),
    paperBorder: Color(0xFF3B4754),
    guide: Color(0xFFC9CCD8),
    guideNumber: Color(0xFF7D8296),
  );

  static const light = PtColors(
    base: Color(0xFFF7F5F2),
    mantle: Color(0xFFEDEAE5),
    crust: Color(0xFFFFFFFF),
    surface0: Color(0xFFFFFFFF),
    surface1: Color(0xFFE2DED8),
    surface2: Color(0xFFC4BFB7),
    text: Color(0xFF1B1E22),
    subtext: Color(0xFF59616A),
    flamingo: Color(0xFFC93D39),
    pink: Color(0xFFB02394),
    teal: Color(0xFF0B7A6E),
    yellow: Color(0xFF8A5F00),
    green: Color(0xFF1F7A2B),
    red: Color(0xFFC01F4E),
    greenTint: Color(0x1F1F7A2B),
    redTint: Color(0x1FC01F4E),
    yellowTint: Color(0x1F8A5F00),
    paper: Color(0xFFFFFFFF),
    ink: Color(0xFF1D1D20),
    paperLine: Color(0xFFD1D0DD),
    paperBorder: Color(0xFFE2DED8),
    guide: Color(0xFFC9CCD8),
    guideNumber: Color(0xFF7D8296),
  );

  @override
  PtColors copyWith() => this;

  @override
  PtColors lerp(ThemeExtension<PtColors>? other, double t) {
    if (other is! PtColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PtColors(
      base: l(base, other.base),
      mantle: l(mantle, other.mantle),
      crust: l(crust, other.crust),
      surface0: l(surface0, other.surface0),
      surface1: l(surface1, other.surface1),
      surface2: l(surface2, other.surface2),
      text: l(text, other.text),
      subtext: l(subtext, other.subtext),
      flamingo: l(flamingo, other.flamingo),
      pink: l(pink, other.pink),
      teal: l(teal, other.teal),
      yellow: l(yellow, other.yellow),
      green: l(green, other.green),
      red: l(red, other.red),
      greenTint: l(greenTint, other.greenTint),
      redTint: l(redTint, other.redTint),
      yellowTint: l(yellowTint, other.yellowTint),
      paper: l(paper, other.paper),
      ink: l(ink, other.ink),
      paperLine: l(paperLine, other.paperLine),
      paperBorder: l(paperBorder, other.paperBorder),
      guide: l(guide, other.guide),
      guideNumber: l(guideNumber, other.guideNumber),
    );
  }
}

extension PtContext on BuildContext {
  PtColors get pt => Theme.of(this).extension<PtColors>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? PtColors.dark : PtColors.light;
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
      backgroundColor: c.surface1,
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
