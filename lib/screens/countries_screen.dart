import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/countries/countries_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

/// Pantalla 1 (ruta "/"): lista de países.
class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Cuando faltan ~300 px para el final, pedimos la siguiente página.
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<CountriesBloc>().add(const CountriesNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BlocBuilder redibuja solo esta parte cuando cambia el estado.
      body: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          return switch (state) {
            CountriesLoading() =>
              const LoadingView(message: 'Cargando países...'),
            CountriesError(:final message) => ErrorView(
                message: message,
                onRetry: () => context
                    .read<CountriesBloc>()
                    .add(const CountriesRequested()),
              ),
            CountriesSuccess() => _buildList(context, state),
          };
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, CountriesSuccess state) {
    final colors = Theme.of(context).colorScheme;
    final visible = state.visibleCountries; // filtramos una sola vez

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<CountriesBloc>().add(const CountriesRequested()),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar.large(
            title: const Text('Países del mundo'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(Icons.public, size: 18, color: colors.primary),
                  label: Text('${state.countries.length}'),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBar(
                hintText: 'Buscar país o capital',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                onChanged: (text) => context
                    .read<CountriesBloc>()
                    .add(CountriesSearchChanged(text)),
              ),
            ),
          ),
          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No hay países que coincidan con "${state.query}"',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final country = visible[index];
                return CountryCard(
                  country: country,
                  // Pasamos el país en "extra" para mostrar la bandera
                  // de inmediato mientras carga el detalle.
                  onTap: () =>
                      context.push('/country/${country.code}', extra: country),
                );
              },
            ),
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
