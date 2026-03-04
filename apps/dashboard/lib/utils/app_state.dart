/// Simple in-memory reactive state for the dashboard.
/// Jaspr uses StatefulComponent for local state; this handles global state.
class AppState {
  // Auth
  String? token;
  String? userEmail;
  bool get isLoggedIn => token != null;

  // Theme & locale
  bool isDark = true;
  String locale = 'en'; // 'en' | 'ar'

  // Currently selected app slug
  String? selectedAppSlug;

  // Toast notifications queue
  final List<Toast> toasts = [];

  // Singleton
  static final AppState instance = AppState._();
  AppState._();
}

class Toast {
  final String message;
  final bool isError;
  Toast(this.message, {this.isError = false});
}

final appState = AppState.instance;
