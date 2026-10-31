import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/country.dart';
import '../../services/countries_service.dart';

part 'country_detail_event.dart';
part 'country_detail_state.dart';

/// BLoC del detalle: cada vez que se abre /country/:code se crea uno
/// nuevo y pide ese país a la API.
class CountryDetailBloc extends Bloc<CountryDetailEvent, CountryDetailState> {
  final CountriesService _service;

  CountryDetailBloc(this._service) : super(const CountryDetailLoading()) {
    on<CountryDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
    CountryDetailRequested event,
    Emitter<CountryDetailState> emit,
  ) async {
    emit(const CountryDetailLoading());
    try {
      final country = await _service.getCountryByCode(event.code);
      emit(CountryDetailSuccess(country));
    } on CountriesException catch (e) {
      emit(CountryDetailError(e.message));
    }
  }
}
