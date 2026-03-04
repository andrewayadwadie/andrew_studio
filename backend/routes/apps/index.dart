import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/utils/response_helper.dart';

// GET /apps  — list all apps
// POST /apps — create new app
Future<Response> onRequest(RequestContext context) async {
  final authed = authMiddleware((ctx) async => _handle(ctx))(context);
  return authed;
}

Future<Response> _handle(RequestContext context) async {
  final db = context.read<SupabaseClient>();

  switch (context.request.method) {
    case HttpMethod.get:
      final apps = await db.from('apps').select().order('created_at');
      return okJson(apps);

    case HttpMethod.post:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');

      final name = body['name'] as String?;
      final slug = body['slug'] as String?;
      if (name == null || slug == null) {
        return errorJson('name and slug are required');
      }

      final result = await db.from('apps').insert({
        'name': name,
        'slug': slug,
        'description': body['description'],
        'icon_url': body['icon_url'],
        'is_active': body['is_active'] ?? true,
      }).select().single();

      return createdJson(result);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
