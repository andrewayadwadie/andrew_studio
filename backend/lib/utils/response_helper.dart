import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Response okJson(dynamic data) => Response.json(body: {'data': data});

Response createdJson(dynamic data) =>
    Response.json(body: {'data': data}, statusCode: HttpStatus.created);

Response errorJson(String message, {int statusCode = HttpStatus.badRequest}) =>
    Response.json(body: {'error': message}, statusCode: statusCode);

Response notFound([String message = 'Not found']) =>
    errorJson(message, statusCode: HttpStatus.notFound);

Response serverError([String message = 'Internal server error']) =>
    errorJson(message, statusCode: HttpStatus.internalServerError);

Future<Map<String, dynamic>?> parseBody(Request request) async {
  try {
    final body = await request.body();
    if (body.isEmpty) return null;
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
