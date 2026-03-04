import 'package:dart_frog/dart_frog.dart';
import '../lib/middleware/auth_middleware.dart';
import '../lib/services/cloudinary_service.dart';
import '../lib/services/gemini_service.dart';
import '../lib/utils/response_helper.dart';

// POST /generate  — generate image with Gemini, upload to Cloudinary
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return errorJson('Method not allowed', statusCode: 405);
  }
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final body = await parseBody(context.request);
  if (body == null) return errorJson('Invalid body');

  final prompt = body['prompt'] as String?;
  if (prompt == null || prompt.isEmpty) return errorJson('prompt is required');

  final folder = body['folder'] as String? ?? 'generated';

  try {
    final gemini = context.read<GeminiService>();
    final cloudinary = context.read<CloudinaryService>();

    final imageBytes = await gemini.generateImage(prompt);
    final imageUrl = await cloudinary.uploadBytes(imageBytes, folder: folder);

    return okJson({'image_url': imageUrl, 'prompt': prompt});
  } catch (e) {
    return serverError(e.toString());
  }
}
