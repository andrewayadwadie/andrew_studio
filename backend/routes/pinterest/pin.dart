import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/services/pinterest_service.dart';
import '../../lib/utils/response_helper.dart';

// POST /pinterest/pin  — create a pin on Pinterest
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return errorJson('Method not allowed', statusCode: 405);
  }
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final body = await parseBody(context.request);
  if (body == null) return errorJson('Invalid body');

  final accountId = body['account_id'] as String?;
  final boardId = body['board_id'] as String?;
  final imageUrl = body['image_url'] as String?;
  final title = body['title'] as String?;

  if (accountId == null || boardId == null || imageUrl == null || title == null) {
    return errorJson('account_id, board_id, image_url, title are required');
  }

  final db = context.read<SupabaseClient>();
  final account = await db
      .from('pinterest_accounts')
      .select('access_token')
      .eq('id', accountId)
      .maybeSingle();

  if (account == null) return notFound('Pinterest account not found');

  try {
    final pinterest = context.read<PinterestService>();
    final pin = await pinterest.createPin(
      accessToken: account['access_token'] as String,
      boardId: boardId,
      imageUrl: imageUrl,
      title: title,
      description: body['description'] as String?,
      link: body['link'] as String?,
    );

    // optionally update wallpaper with pin id
    if (body.containsKey('wallpaper_id')) {
      await db.from('wallpapers').update({
        'pinterest_pin_id': pin['id'],
        'pinterest_board_id': boardId,
      }).eq('id', body['wallpaper_id']);
    }

    return createdJson(pin);
  } catch (e) {
    return serverError(e.toString());
  }
}
