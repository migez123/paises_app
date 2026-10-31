part of 'countries_bloc.dart';

/// Eventos: lo que la pantalla le pide al BLoC.
sealed class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar la primera página (al abrir la app o al reintentar).
class CountriesRequested extends CountriesEvent {
  const CountriesRequested();
}

/// Cargar la siguiente página al llegar al final de la lista.
class CountriesNextPageRequested extends CountriesEvent {
  const CountriesNextPageRequested();
}

/// El usuario escribió en el buscador.
class CountriesSearchChanged extends CountriesEvent {
  final String query;

  const CountriesSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
