import 'dart:convert';
import 'package:http/http.dart' as http;

class PinterestService {
  static const String _baseUrl = 'https://api.pinterest.com/v5';

  Future<Map<String, dynamic>> createPin({
    required String accessToken,
    required String boardId,
    required String imageUrl,
    required String title,
    String? description,
    String? link,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pins'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'board_id': boardId,
        'title': title,
        if (description != null) 'description': description,
        if (link != null) 'link': link,
        'media_source': {
          'source_type': 'image_url',
          'url': imageUrl,
        },
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Pinterest pin failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getBoards(String accessToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/boards'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Pinterest boards error: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;
    return items.cast<Map<String, dynamic>>();
  }
}
