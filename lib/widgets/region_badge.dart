import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../config/formatters.dart';

/// Etiqueta de color con el nombre de la región.
class RegionBadge extends StatelessWidget {
  final String region;

  const RegionBadge({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.regionColor(region);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        regionName(region),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
