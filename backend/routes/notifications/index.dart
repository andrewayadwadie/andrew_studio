import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/utils/response_helper.dart';

// POST /notifications  — send push notification via Supabase Edge Functions
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return errorJson('Method not allowed', statusCode: 405);
  }
  return authMiddleware(_handle)(context);
}

Future<Response> _handle(RequestContext context) async {
  final body = await parseBody(context.request);
  if (body == null) return errorJson('Invalid body');

  final title = body['title'] as String?;
  final message = body['message'] as String?;
  final appSlug = body['app_slug'] as String?;

  if (title == null || message == null) {
    return errorJson('title and message are required');
  }

  final db = context.read<SupabaseClient>();

  try {
    // Store notification in DB for history
    final notification = await db.from('notifications').insert({
      'title': title,
      'message': message,
      'app_slug': appSlug,
      'data': body['data'] ?? {},
    }).select().single();

    // Trigger Supabase Edge Function for actual push delivery
    // The edge function reads from notifications table and sends FCM
    await db.functions.invoke('send-notification', body: {
      'notification_id': notification['id'],
    });

    return createdJson(notification);
  } catch (e) {
    return serverError(e.toString());
  }
}
