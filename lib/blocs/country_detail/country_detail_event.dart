part of 'country_detail_bloc.dart';

sealed class CountryDetailEvent extends Equatable {
  const CountryDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Pedir el detalle de un país por su código alpha_3 (ej: COL).
class CountryDetailRequested extends CountryDetailEvent {
  final String code;

  const CountryDetailRequested(this.code);

  @override
  List<Object?> get props => [code];
}
