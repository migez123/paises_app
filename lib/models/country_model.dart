/// Modelo: copia fiel del JSON que manda la API para un país.
/// Respeta los nombres y el anidamiento de la API (names.common,
/// flag.url_png, capitals[]...). La app no lo usa directo: el mapper
/// lo convierte en la entidad Country.
class CountryModel {
  final String? alpha3;
  final NamesModel names;
  final FlagModel flag;
  final List<CapitalModel> capitals;
  final String? region;
  final String? subregion;
  final int? population;
  final double? areaKm;
  final List<LanguageModel> languages;
  final List<CurrencyModel> currencies;
  final List<String> borders;

  CountryModel({
    required this.alpha3,
    required this.names,
    required this.flag,
    required this.capitals,
    required this.region,
    required this.subregion,
    required this.population,
    required this.areaKm,
    required this.languages,
    required this.currencies,
    required this.borders,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final codes = json['codes'] as Map<String, dynamic>? ?? {};
    final area = json['area'] as Map<String, dynamic>? ?? {};

    return CountryModel(
      alpha3: codes['alpha_3'] as String?,
      names: NamesModel.fromJson(json['names'] as Map<String, dynamic>? ?? {}),
      flag: FlagModel.fromJson(json['flag'] as Map<String, dynamic>? ?? {}),
      capitals: _list(json['capitals'], CapitalModel.fromJson),
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      population: (json['population'] as num?)?.toInt(),
      areaKm: (area['kilometers'] as num?)?.toDouble(),
      languages: _list(json['languages'], LanguageModel.fromJson),
      currencies: _list(json['currencies'], CurrencyModel.fromJson),
      borders: (json['borders'] as List<dynamic>? ?? [])
          .map((code) => code.toString())
          .toList(),
    );
  }

  /// Convierte una lista JSON de objetos en una lista de modelos.
  /// Si el campo no viene, devuelve una lista vacía en vez de fallar.
  static List<T> _list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return [];
    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
}

class NamesModel {
  final String? common;
  final String? official;

  NamesModel({this.common, this.official});

  factory NamesModel.fromJson(Map<String, dynamic> json) => NamesModel(
        common: json['common'] as String?,
        official: json['official'] as String?,
      );
}

class FlagModel {
  final String? emoji;
  final String? urlPng;
  final String? urlSvg;

  FlagModel({this.emoji, this.urlPng, this.urlSvg});

  factory FlagModel.fromJson(Map<String, dynamic> json) => FlagModel(
        emoji: json['emoji'] as String?,
        urlPng: json['url_png'] as String?,
        urlSvg: json['url_svg'] as String?,
      );
}

class CapitalModel {
  final String? name;
  final bool primary;

  CapitalModel({this.name, this.primary = false});

  factory CapitalModel.fromJson(Map<String, dynamic> json) => CapitalModel(
        name: json['name'] as String?,
        primary: json['primary'] as bool? ?? false,
      );
}

class LanguageModel {
  final String? name;

  LanguageModel({this.name});

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(name: json['name'] as String?);
}

class CurrencyModel {
  final String? code;
  final String? name;
  final String? symbol;

  CurrencyModel({this.code, this.name, this.symbol});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        code: json['code'] as String?,
        name: json['name'] as String?,
        symbol: json['symbol'] as String?,
      );
}
