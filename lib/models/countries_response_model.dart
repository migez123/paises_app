import 'country_model.dart';

/// Modelo de la respuesta completa de la API.
/// Los países llegan dentro de data.objects:
///   { "data": { "objects": [ {país}, {país}, ... ] } }
class CountriesResponseModel {
  final List<CountryModel> objects;

  CountriesResponseModel({required this.objects});

  factory CountriesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final objects = data['objects'] as List<dynamic>? ?? [];

    return CountriesResponseModel(
      objects: objects
          .whereType<Map<String, dynamic>>()
          .map(CountryModel.fromJson)
          .toList(),
    );
  }
}
