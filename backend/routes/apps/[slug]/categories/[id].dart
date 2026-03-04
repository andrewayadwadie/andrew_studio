import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../../../lib/middleware/auth_middleware.dart';
import '../../../../lib/utils/response_helper.dart';

Future<Response> onRequest(RequestContext context, String slug, String id) async {
  return authMiddleware((ctx) => _handle(ctx, id))(context);
}

Future<Response> _handle(RequestContext context, String id) async {
  final db = context.read<SupabaseClient>();

  switch (context.request.method) {
    case HttpMethod.get:
      final cat = await db.from('categories').select().eq('id', id).maybeSingle();
      if (cat == null) return notFound();
      return okJson(cat);

    case HttpMethod.put:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');
      final updated = await db
          .from('categories')
          .update(body)
          .eq('id', id)
          .select()
          .single();
      return okJson(updated);

    case HttpMethod.delete:
      await db.from('categories').delete().eq('id', id);
      return Response(statusCode: 204);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
