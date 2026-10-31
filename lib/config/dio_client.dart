import 'package:dio/dio.dart';

import 'api_config.dart';

/// Crea una sola instancia de Dio ya configurada para toda la app,
/// así no repetimos la URL base ni la cabecera en cada petición.
class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
      ),
    );
  }
}
