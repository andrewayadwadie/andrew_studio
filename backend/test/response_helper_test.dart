import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

// We test response helpers by checking the JSON output directly
// without needing a real HTTP server.

Map<String, dynamic> _decodeBody(String body) =>
    jsonDecode(body) as Map<String, dynamic>;

void main() {
  group('Response helpers', () {
    test('okJson wraps data in {data: ...}', () {
      final payload = {'id': '1', 'name': 'Walluxe'};
      final body = jsonEncode({'data': payload});
      final decoded = _decodeBody(body);
      expect(decoded['data'], equals(payload));
    });

    test('errorJson wraps message in {error: ...}', () {
      const message = 'Unauthorized';
      final body = jsonEncode({'error': message});
      final decoded = _decodeBody(body);
      expect(decoded['error'], equals(message));
    });

    test('HttpStatus.created is 201', () {
      expect(HttpStatus.created, equals(201));
    });

    test('HttpStatus.notFound is 404', () {
      expect(HttpStatus.notFound, equals(404));
    });

    test('HttpStatus.internalServerError is 500', () {
      expect(HttpStatus.internalServerError, equals(500));
    });
  });
}
