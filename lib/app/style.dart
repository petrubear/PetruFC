/// Estilos visuales disponibles. Hoy solo existe `washi`; agregar otro estilo
/// es sumar un valor aqui y su paleta en `theme.dart` (sin tocar pantallas).
enum AppStyle {
  washi;

  static AppStyle fromId(String? id) =>
      AppStyle.values.where((s) => s.name == id).firstOrNull ?? AppStyle.washi;
}

/// Tokens de forma de un estilo.
class ShapeTokens {
  const ShapeTokens({
    required this.small,
    required this.medium,
    required this.large,
    required this.pill,
    required this.border,
    required this.minTap,
    required this.primaryTap,
  });
  final double small, medium, large, pill, border, minTap, primaryTap;

  static const washi = ShapeTokens(
    small: 14,
    medium: 22,
    large: 30,
    pill: 999,
    border: 1.5,
    minTap: 48,
    primaryTap: 56,
  );
}
