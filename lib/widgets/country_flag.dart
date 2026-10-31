import 'package:flutter/material.dart';

/// Bandera con esquinas redondeadas. Se usa pequeña en la lista y
/// grande en el detalle. El Hero hace que la bandera "vuele" de una
/// pantalla a la otra al navegar (por eso ambas usan el mismo tag).
class CountryFlag extends StatelessWidget {
  final String url;
  final String emoji;
  final String heroTag;
  final double width;
  final double radius;

  const CountryFlag({
    super.key,
    required this.url,
    required this.heroTag,
    this.emoji = '',
    this.width = 64,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Hero(
      tag: heroTag,
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: url.isEmpty
                ? _fallback(colors)
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : _placeholder(colors),
                    errorBuilder: (context, error, stack) => _fallback(colors),
                  ),
          ),
        ),
      ),
    );
  }

  /// Fondo gris mientras la imagen descarga.
  Widget _placeholder(ColorScheme colors) {
    return ColoredBox(color: colors.surfaceContainerHighest);
  }

  /// Si no hay imagen: el emoji de la bandera, o un ícono si
  /// tampoco hay emoji. FittedBox lo escala al tamaño de la bandera.
  Widget _fallback(ColorScheme colors) {
    return Container(
      color: colors.surfaceContainerHighest,
      padding: const EdgeInsets.all(6),
      child: FittedBox(
        child: emoji.isNotEmpty
            ? Text(emoji)
            : Icon(Icons.flag_outlined, color: colors.outline),
      ),
    );
  }
}
