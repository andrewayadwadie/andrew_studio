import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;
import '../lib/services/cloudinary_service.dart';
import '../lib/services/gemini_service.dart';
import '../lib/services/pinterest_service.dart';
import '../lib/services/unsplash_service.dart';

// dart_frog dev auto-loads .env; Vercel sets env vars at build time.
Handler middleware(Handler handler) {
  return handler
      .use(provider<SupabaseClient>(
        (_) => SupabaseClient(
          Platform.environment['SUPABASE_URL']!,
          Platform.environment['SUPABASE_SERVICE_ROLE_KEY']!,
        ),
      ))
      .use(provider<CloudinaryService>((_) => CloudinaryService()))
      .use(provider<GeminiService>((_) => GeminiService()))
      .use(provider<PinterestService>((_) => PinterestService()))
      .use(provider<UnsplashService>((_) => UnsplashService()))
      .use(corsHeaders());
}

Middleware corsHeaders() {
  return (handler) => (context) async {
        final response = await handler(context);
        return response.copyWith(headers: {
          ...response.headers,
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type,Authorization',
        });
      };
}
