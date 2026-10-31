part of 'countries_bloc.dart';

/// Estados: lo que la pantalla debe dibujar.
/// Al ser "sealed", el switch de la pantalla está obligado a
/// cubrir los tres casos: cargando, éxito y error.
sealed class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object?> get props => [];
}

class CountriesLoading extends CountriesState {
  const CountriesLoading();
}

class CountriesSuccess extends CountriesState {
  final List<Country> countries;
  final bool hasMore; // ¿quedan páginas por pedir?
  final bool isLoadingMore; // ¿se está pidiendo la siguiente página?
  final String query; // texto del buscador

  const CountriesSuccess({
    required this.countries,
    required this.hasMore,
    this.isLoadingMore = false,
    this.query = '',
  });

  /// Países que se muestran: todos, o solo los que coinciden con la
  /// búsqueda (por nombre o capital).
  List<Country> get visibleCountries {
    final text = query.trim().toLowerCase();
    if (text.isEmpty) return countries;
    return countries
        .where((c) =>
            c.commonName.toLowerCase().contains(text) ||
            c.capital.toLowerCase().contains(text))
        .toList();
  }

  CountriesSuccess copyWith({
    List<Country>? countries,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
  }) {
    return CountriesSuccess(
      countries: countries ?? this.countries,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [countries, hasMore, isLoadingMore, query];
}

class CountriesError extends CountriesState {
  final String message;

  const CountriesError(this.message);

  @override
  List<Object?> get props => [message];
}
