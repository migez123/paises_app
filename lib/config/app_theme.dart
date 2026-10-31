import 'package:flutter/material.dart';

/// Tema de la app: Material 3 generado a partir de un solo color,
/// con versión clara y oscura.
class AppTheme {
  static const Color seed = Color(0xFF1E6091); // azul océano

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),
    );
  }

  /// Color propio para cada región, usado en las insignias.
  static Color regionColor(String region) {
    switch (region.toLowerCase()) {
      case 'americas':
        return const Color(0xFFE76F51);
      case 'europe':
        return const Color(0xFF4361EE);
      case 'africa':
        return const Color(0xFFF4A261);
      case 'asia':
        return const Color(0xFFE63946);
      case 'oceania':
        return const Color(0xFF2A9D8F);
      case 'antarctic':
        return const Color(0xFF8D99AE);
      default:
        return seed;
    }
  }
}
