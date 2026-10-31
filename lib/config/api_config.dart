/// Datos de conexión con la API de REST Countries.
///
/// La API key NO se escribe en el código: se lee al compilar desde
/// env.json (que está en .gitignore) con:
///   flutter run --dart-define-from-file=env.json
class ApiConfig {
  static const String baseUrl = 'https://api.restcountries.com';
  static const String countriesPath = '/countries/v5';

  static const String apiKey = String.fromEnvironment('API_KEY');

  /// La API permite máximo 100 países por página.
  static const int pageSize = 100;
}
