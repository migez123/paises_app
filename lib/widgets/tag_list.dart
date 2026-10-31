import 'package:flutter/material.dart';

/// Lista de etiquetas que se acomodan en varias filas (idiomas,
/// monedas, fronteras). Si se pasa onTap, cada etiqueta es tocable.
class TagList extends StatelessWidget {
  final List<String> items;
  final String emptyText;
  final ValueChanged<String>? onTap;

  const TagList({
    super.key,
    required this.items,
    this.emptyText = 'No disponible',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        emptyText,
        style: TextStyle(color: Theme.of(context).colorScheme.outline),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          onTap == null
              ? Chip(label: Text(item))
              : ActionChip(
                  label: Text(item),
                  avatar: const Icon(Icons.flag_outlined, size: 18),
                  onPressed: () => onTap!(item),
                ),
      ],
    );
  }
}
