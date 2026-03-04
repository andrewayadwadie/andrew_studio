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
      final categories = await db
          .from('categories')
          .select('*, wallpapers(count)')
          .eq('app_id', appId)
          .order('created_at');
      return okJson(categories);

    case HttpMethod.post:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');

      final result = await db.from('categories').insert({
        'app_id': appId,
        'name': body['name'],
        'description': body['description'],
        'cover_image_url': body['cover_image_url'],
      }).select().single();

      return createdJson(result);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
