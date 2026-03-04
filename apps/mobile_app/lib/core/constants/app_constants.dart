const String _kAppSlug = String.fromEnvironment('APP_SLUG', defaultValue: 'walluxe');
const String _kAppName = String.fromEnvironment('APP_NAME', defaultValue: 'Walluxe');
const String _kBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://10.0.2.2:8080');
const String _kSupabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://yusygjecjjecrerctven.supabase.co');
const String _kSupabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

class AppConstants {
  static const String appSlug = _kAppSlug;
  static const String appName = _kAppName;
  static const String baseUrl = _kBaseUrl;
  static const String supabaseUrl = _kSupabaseUrl;
  static const String supabaseAnonKey = _kSupabaseAnonKey;
}
