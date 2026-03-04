import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Handler authMiddleware(Handler handler) {
  return (context) async {
    final authHeader = context.request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        body: {'error': 'Missing or invalid authorization header'},
        statusCode: HttpStatus.unauthorized,
      );
    }

    final token = authHeader.substring(7);
    try {
      final secret = Platform.environment['SUPABASE_JWT_SECRET']!;
      final jwt = JWT.verify(token, SecretKey(secret));
      final payload = jwt.payload as Map<String, dynamic>;
      return handler(context.provide<Map<String, dynamic>>(() => payload));
    } on JWTException catch (e) {
      return Response.json(
        body: {'error': 'Invalid token: ${e.message}'},
        statusCode: HttpStatus.unauthorized,
      );
    }
  };
}
