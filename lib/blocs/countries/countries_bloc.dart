import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/api_config.dart';
import '../../entities/country.dart';
import '../../services/countries_service.dart';

part 'countries_event.dart';
part 'countries_state.dart';

/// BLoC de la lista: recibe eventos, llama al servicio y emite estados.
class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final CountriesService _service;

  CountriesBloc(this._service) : super(const CountriesLoading()) {
    on<CountriesRequested>(_onRequested);
    on<CountriesNextPageRequested>(_onNextPageRequested);
    on<CountriesSearchChanged>(_onSearchChanged);
  }

  /// Buscar no llama a la API: filtra los países ya cargados.
  void _onSearchChanged(
    CountriesSearchChanged event,
    Emitter<CountriesState> emit,
  ) {
    final current = state;
    if (current is CountriesSuccess) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onRequested(
    CountriesRequested event,
    Emitter<CountriesState> emit,
  ) async {
    emit(const CountriesLoading());
    try {
      final countries = await _service.getCountries(offset: 0);
      emit(CountriesSuccess(
        countries: countries,
        // Si llegó una página completa, probablemente hay más.
        hasMore: countries.length == ApiConfig.pageSize,
      ));
    } on CountriesException catch (e) {
      emit(CountriesError(e.message));
    }
  }

  Future<void> _onNextPageRequested(
    CountriesNextPageRequested event,
    Emitter<CountriesState> emit,
  ) async {
    final current = state;
    // Solo pedimos más si ya hay lista, quedan páginas y no
    // hay otra petición en curso (evita pedir la misma página 2 veces).
    if (current is! CountriesSuccess ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final next = await _service.getCountries(
        offset: current.countries.length,
      );
      // Mientras esperábamos, el usuario pudo escribir en el buscador
      // o recargar: partimos del estado actual, no del de antes.
      final latest = state;
      if (latest is! CountriesSuccess) return;
      emit(latest.copyWith(
        countries: [...latest.countries, ...next],
        hasMore: next.length == ApiConfig.pageSize,
        isLoadingMore: false,
      ));
    } on CountriesException {
      // Si falla la página extra, conservamos la lista que ya teníamos.
      final latest = state;
      if (latest is CountriesSuccess) {
        emit(latest.copyWith(isLoadingMore: false));
      }
    }
  }
}
