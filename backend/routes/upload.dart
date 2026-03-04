import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../lib/middleware/auth_middleware.dart';
import '../lib/services/cloudinary_service.dart';
import '../lib/utils/response_helper.dart';

// POST /upload  — upload image bytes (base64) or URL to Cloudinary
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return errorJson('Method not allowed', statusCode: 405);
  }
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final body = await parseBody(context.request);
  if (body == null) return errorJson('Invalid body');

  final cloudinary = context.read<CloudinaryService>();
  final folder = body['folder'] as String? ?? 'uploads';

  try {
    String imageUrl;

    if (body.containsKey('image_base64')) {
      final base64Data = body['image_base64'] as String;
      final bytes = base64Decode(base64Data);
      imageUrl = await cloudinary.uploadBytes(bytes, folder: folder);
    } else if (body.containsKey('image_url')) {
      final url = body['image_url'] as String;
      imageUrl = await cloudinary.uploadFromUrl(url, folder: folder);
    } else {
      return errorJson('image_base64 or image_url is required');
    }

    return okJson({'image_url': imageUrl});
  } catch (e) {
    return serverError(e.toString());
  }
}
