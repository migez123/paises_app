part of 'country_detail_bloc.dart';

sealed class CountryDetailState extends Equatable {
  const CountryDetailState();

  @override
  List<Object?> get props => [];
}

class CountryDetailLoading extends CountryDetailState {
  const CountryDetailLoading();
}

class CountryDetailSuccess extends CountryDetailState {
  final Country country;

  const CountryDetailSuccess(this.country);

  @override
  List<Object?> get props => [country];
}

class CountryDetailError extends CountryDetailState {
  final String message;

  const CountryDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
