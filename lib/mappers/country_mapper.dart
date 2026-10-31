import '../entities/country.dart';
import '../models/country_model.dart';

/// Mapper: traduce el CountryModel (forma de la API) a la entidad
/// Country (forma que usa la app). Aquí se deciden los valores por
/// defecto y cómo se "aplanan" los datos anidados.
class CountryMapper {
  static Country toEntity(CountryModel model) {
    return Country(
      code: model.alpha3 ?? '',
      commonName: model.names.common ?? 'Sin nombre',
      officialName: model.names.official ?? model.names.common ?? 'Sin nombre',
      // Usamos PNG porque Image.network no dibuja SVG.
      flagUrl: model.flag.urlPng ?? '',
      flagEmoji: model.flag.emoji ?? '',
      region: model.region ?? 'Sin región',
      capital: _capital(model.capitals),
      population: model.population ?? 0,
      area: model.areaKm ?? 0,
      languages: model.languages
          .map((language) => language.name)
          .whereType<String>()
          .toList(),
      currencies: model.currencies.map(_currency).toList(),
      borders: model.borders,
    );
  }

  /// Algunos países tienen varias capitales (ej: Sudáfrica).
  /// Tomamos la marcada como principal; si no hay, la primera.
  static String _capital(List<CapitalModel> capitals) {
    if (capitals.isEmpty) return 'Sin capital';
    final primary = capitals.where((capital) => capital.primary);
    return (primary.isNotEmpty ? primary.first : capitals.first).name ??
        'Sin capital';
  }

  /// Ej: "Peso colombiano (COP $)"
  static String _currency(CurrencyModel currency) {
    final details = [currency.code, currency.symbol]
        .whereType<String>()
        .join(' ');
    final name = currency.name ?? 'Moneda';
    return details.isEmpty ? name : '$name ($details)';
  }
}
