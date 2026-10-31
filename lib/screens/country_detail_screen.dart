import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/country_detail/country_detail_bloc.dart';
import '../config/formatters.dart';
import '../entities/country.dart';
import '../widgets/country_flag.dart';
import '../widgets/error_view.dart';
import '../widgets/info_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/region_badge.dart';
import '../widgets/section_card.dart';
import '../widgets/tag_list.dart';

/// Pantalla 2 (ruta "/country/:code"): detalle de un país.
class CountryDetailScreen extends StatelessWidget {
  final String code;

  /// País que ya teníamos de la lista (puede ser null si se llegó
  /// por una frontera o escribiendo la ruta). Solo sirve para mostrar
  /// la bandera mientras llega el detalle completo.
  final Country? preview;

  const CountryDetailScreen({super.key, required this.code, this.preview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(preview?.commonName ?? code)),
      body: BlocBuilder<CountryDetailBloc, CountryDetailState>(
        builder: (context, state) {
          return switch (state) {
            CountryDetailLoading() => Column(
                children: [
                  if (preview != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _BigFlag(country: preview!),
                    ),
                  const Expanded(
                    child: LoadingView(message: 'Cargando detalle...'),
                  ),
                ],
              ),
            CountryDetailError(:final message) => ErrorView(
                message: message,
                onRetry: () => context
                    .read<CountryDetailBloc>()
                    .add(CountryDetailRequested(code)),
              ),
            CountryDetailSuccess(:final country) => _DetailBody(country),
          };
        },
      ),
    );
  }
}

class _BigFlag extends StatelessWidget {
  final Country country;

  const _BigFlag({required this.country});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CountryFlag(
        url: country.flagUrl,
        emoji: country.flagEmoji,
        heroTag: 'flag-${country.code}',
        width: double.infinity,
        radius: 20,
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Country country;

  const _DetailBody(this.country);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _BigFlag(country: country),
        const SizedBox(height: 20),

        // Nombre común y oficial
        Text(
          country.commonName,
          style: textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          country.officialName,
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            RegionBadge(region: country.region),
            const SizedBox(width: 8),
            Text(
              country.code,
              style: textTheme.labelLarge?.copyWith(color: colors.outline),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Datos principales en dos columnas
        _TwoTiles(
          left: InfoTile(
            icon: Icons.location_city,
            label: 'Capital',
            value: country.capital,
          ),
          right: InfoTile(
            icon: Icons.public,
            label: 'Región',
            value: regionName(country.region),
          ),
        ),
        const SizedBox(height: 12),
        _TwoTiles(
          left: InfoTile(
            icon: Icons.groups,
            label: 'Población',
            value: formatNumber(country.population),
          ),
          right: InfoTile(
            icon: Icons.straighten,
            label: 'Área',
            value: '${formatNumber(country.area)} km²',
          ),
        ),
        const SizedBox(height: 16),

        SectionCard(
          title: 'Idiomas',
          icon: Icons.translate,
          child: TagList(items: country.languages),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Monedas',
          icon: Icons.payments_outlined,
          child: TagList(items: country.currencies),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Fronteras',
          icon: Icons.border_all_rounded,
          child: TagList(
            items: country.borders,
            emptyText: 'No tiene fronteras terrestres',
            // Tocar un vecino abre su propio detalle.
            onTap: (borderCode) => context.push('/country/$borderCode'),
          ),
        ),
      ],
    );
  }
}

/// Dos InfoTile lado a lado con la misma altura.
class _TwoTiles extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _TwoTiles({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }
}
