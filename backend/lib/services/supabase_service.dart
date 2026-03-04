import 'dart:io';
import 'package:supabase/supabase.dart';

SupabaseClient createSupabaseClient() {
  final url = Platform.environment['SUPABASE_URL']!;
  final serviceKey = Platform.environment['SUPABASE_SERVICE_ROLE_KEY']!;
  return SupabaseClient(url, serviceKey);
}
