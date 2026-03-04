import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/services/unsplash_service.dart';
import '../../lib/utils/response_helper.dart';

// GET /unsplash/search?query=...&page=1&per_page=20
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return errorJson('Method not allowed', statusCode: 405);
  }
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final params = context.request.uri.queryParameters;
  final query = params['query'];
  if (query == null || query.isEmpty) return errorJson('query is required');

  final page = int.tryParse(params['page'] ?? '1') ?? 1;
  final perPage = int.tryParse(params['per_page'] ?? '20') ?? 20;

  try {
    final unsplash = context.read<UnsplashService>();
    final photos = await unsplash.searchPhotos(query, page: page, perPage: perPage);
    return okJson(photos);
  } catch (e) {
    return serverError(e.toString());
  }
}
