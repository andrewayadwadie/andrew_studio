import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/utils/response_helper.dart';

// GET  /pinterest        — list Pinterest accounts
// POST /pinterest        — add Pinterest account
Future<Response> onRequest(RequestContext context) async {
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final db = context.read<SupabaseClient>();

  switch (context.request.method) {
    case HttpMethod.get:
      final accounts = await db
          .from('pinterest_accounts')
          .select('id,username,is_active,created_at')
          .order('created_at');
      return okJson(accounts);

    case HttpMethod.post:
      final body = await parseBody(context.request);
      if (body == null) return errorJson('Invalid body');

      final result = await db.from('pinterest_accounts').insert({
        'username': body['username'],
        'access_token': body['access_token'],
        'refresh_token': body['refresh_token'],
        'token_expires_at': body['token_expires_at'],
        'is_active': body['is_active'] ?? true,
      }).select('id,username,is_active,created_at').single();

      return createdJson(result);

    default:
      return errorJson('Method not allowed', statusCode: 405);
  }
}
