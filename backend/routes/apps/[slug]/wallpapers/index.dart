import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../../../lib/middleware/auth_middleware.dart';
import '../../../../lib/utils/response_helper.dart';

Future<Response> onRequest(RequestContext context, String slug) async {
  return authMiddleware((ctx) => _handle(ctx, slug))(context);
}

Future<Response> _handle(RequestContext context, String slug) async {
  final db = context.read<SupabaseClient>();

  final app = await db.from('apps').select('id').eq('slug', slug).maybeSingle();
  if (app == null) return notFound('App not found');
  final appId = app['id'] as String;

  switch (context.request.method) {
    case HttpMethod.get:
      final params = context.request.uri.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final perPage = int.tryParse(params['per_page'] ?? '20') ?? 20;
      final categoryId = params['category_id'];
      final offset = (page - 1) * perPage;

      var query = db.from('wallpapers').select().eq('app_id', appId);
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      final wallpapers = await query
          .order('created_at', ascending: false)
          .range(offset, offset + perPage - 1);
      return okJson(wallpapers);

    case HttpMethod.post:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');
      final result = await db.from('wallpapers').insert({
        'app_id': appId,
        'image_url': body['image_url'],
        'thumbnail_url': body['thumbnail_url'],
        'title': body['title'],
        'description': body['description'],
        'attached_link': body['attached_link'],
        'category_id': body['category_id'],
        'source': body['source'] ?? 'upload',
        'tags': body['tags'] ?? [],
        'pinterest_pin_id': body['pinterest_pin_id'],
        'pinterest_board_id': body['pinterest_board_id'],
      }).select().single();
      return createdJson(result);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
