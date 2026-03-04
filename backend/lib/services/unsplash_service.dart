import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UnsplashService {
  final String _accessKey = Platform.environment['UNSPLASH_ACCESS_KEY']!;
  static const String _baseUrl = 'https://api.unsplash.com';

  Future<List<Map<String, dynamic>>> searchPhotos(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    final url = Uri.parse('$_baseUrl/search/photos').replace(
      queryParameters: {
        'query': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unsplash error: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>;
    return results.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getPhotosByCategory(
    String category, {
    int page = 1,
    int perPage = 20,
  }) async {
    final url = Uri.parse('$_baseUrl/search/photos').replace(
      queryParameters: {
        'query': category,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'orientation': 'portrait',
      },
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unsplash error: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>;
    return results.cast<Map<String, dynamic>>();
  }
}
