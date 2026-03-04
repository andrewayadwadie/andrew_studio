import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = Platform.environment['GEMINI_API_KEY']!;
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Generate an image using Gemini 2.0 Flash Imagen.
  /// Returns raw bytes of the generated image.
  Future<List<int>> generateImage(String prompt) async {
    final url = Uri.parse('$_baseUrl/gemini-2.0-flash-exp-image-generation'
        ':generateContent?key=$_apiKey');

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {'responseModalities': ['IMAGE', 'TEXT']},
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates =
        json['candidates'] as List<dynamic>;
    final parts =
        (candidates.first as Map)['content']['parts'] as List<dynamic>;

    for (final part in parts) {
      final map = part as Map<String, dynamic>;
      if (map.containsKey('inlineData')) {
        final base64Data = map['inlineData']['data'] as String;
        return base64Decode(base64Data);
      }
    }

    throw Exception('No image returned from Gemini');
  }
}
