import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../../lib/middleware/auth_middleware.dart';
import '../../../lib/utils/response_helper.dart';

// GET  /apps/:slug  — fetch app
// PUT  /apps/:slug  — update app
// DELETE /apps/:slug — delete app
Future<Response> onRequest(RequestContext context, String slug) async {
  return authMiddleware((ctx) => _handle(ctx, slug))(context);
}

Future<Response> _handle(RequestContext context, String slug) async {
  final db = context.read<SupabaseClient>();

  switch (context.request.method) {
    case HttpMethod.get:
      final app = await db
          .from('apps')
          .select()
          .eq('slug', slug)
          .maybeSingle();
      if (app == null) return notFound('App not found');
      return okJson(app);

    case HttpMethod.put:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');
      final updated = await db
          .from('apps')
          .update(body)
          .eq('slug', slug)
          .select()
          .single();
      return okJson(updated);

    case HttpMethod.delete:
      await db.from('apps').delete().eq('slug', slug);
      return Response(statusCode: 204);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
