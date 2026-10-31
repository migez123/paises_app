import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../config/dio_client.dart';
import '../entities/country.dart';
import '../mappers/country_mapper.dart';
import '../models/countries_response_model.dart';
import '../models/country_model.dart';

/// Error con un mensaje listo para mostrarle al usuario.
class CountriesException implements Exception {
  final String message;
  const CountriesException(this.message);

  @override
  String toString() => message;
}

/// Servicio: el único lugar de la app que habla con la API.
/// Pide los datos con Dio, los convierte en modelos y los devuelve
/// como entidades. Los BLoC lo usan sin saber nada de HTTP ni JSON.
class CountriesService {
  final Dio _dio;

  CountriesService({Dio? dio}) : _dio = dio ?? DioClient.create();

  /// GET /countries/v5?limit=100&offset=0
  Future<List<Country>> getCountries({int offset = 0}) async {
    try {
      final response = await _dio.get(
        ApiConfig.countriesPath,
        queryParameters: {'limit': ApiConfig.pageSize, 'offset': offset},
      );
      final body = CountriesResponseModel.fromJson(response.data);
      return body.objects.map(CountryMapper.toEntity).toList();
    } on DioException catch (e) {
      throw CountriesException(_messageFor(e));
    } on TypeError {
      // El JSON no tiene la forma que espera el modelo.
      throw const CountriesException('Respuesta inesperada de la API.');
    }
  }

  /// GET /countries/v5/codes.alpha_3/COL
  Future<Country> getCountryByCode(String code) async {
    try {
      final response =
          await _dio.get('${ApiConfig.countriesPath}/codes.alpha_3/$code');
      final body = CountriesResponseModel.fromJson(response.data);

      if (body.objects.isNotEmpty) {
        return CountryMapper.toEntity(body.objects.first);
      }
      // Por si el detalle llega como un solo objeto en "data"
      // en vez de una lista en "data.objects".
      final data = response.data['data'];
      if (data is Map<String, dynamic> && data['names'] != null) {
        return CountryMapper.toEntity(CountryModel.fromJson(data));
      }
      throw CountriesException('No se encontró el país $code.');
    } on DioException catch (e) {
      throw CountriesException(_messageFor(e));
    } on TypeError {
      throw const CountriesException('Respuesta inesperada de la API.');
    }
  }

  /// Traduce los errores técnicos de Dio a mensajes entendibles.
  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La conexión tardó demasiado. Intenta de nuevo.';
      case DioExceptionType.connectionError:
        return 'Sin conexión a internet.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          return 'API key inválida o ausente. Revisa env.json.';
        }
        if (status == 404) return 'País no encontrado.';
        if (status == 429) return 'Demasiadas peticiones. Espera un momento.';
        return 'Error del servidor ($status).';
      default:
        return 'Ocurrió un error inesperado.';
    }
  }
}
