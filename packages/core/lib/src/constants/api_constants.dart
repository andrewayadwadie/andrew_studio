class ApiConstants {
  static const String baseUrl = 'https://api.andrewstudio.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
