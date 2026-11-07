import 'package:equatable/equatable.dart';

/// Entidad: el país tal como lo usa la app (no como llega de la API).
/// Solo tiene los datos que las pantallas necesitan, ya limpios.
class Country extends Equatable {
  final String code; // alpha_3, ej: COL
  final String commonName;
  final String officialName;
  final String flagUrl;
  final String flagEmoji;
  final String subregion; // respaldo si la imagen no existe
  final String region;
  final String capital;
  final int population;
  final double area; // km²
  final List<String> languages;
  final List<String> currencies;
  final List<String> borders; // códigos alpha_3 de los vecinos

  const Country({
    required this.code,
    required this.commonName,
    required this.officialName,
    required this.flagUrl,
    required this.flagEmoji,
    required this.subregion,
    required this.region,
    required this.capital,
    required this.population,
    required this.area,
    required this.languages,
    required this.currencies,
    required this.borders,
  });

  /// Equatable compara dos países por estos campos en vez de por
  /// referencia en memoria. Con el código basta para identificarlo.
  @override
  List<Object?> get props => [code];
}
