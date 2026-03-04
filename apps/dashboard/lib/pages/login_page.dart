import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:supabase/supabase.dart';
import '../utils/app_state.dart';
import '../utils/api_client.dart';
import '../utils/l10n.dart';

class LoginPage extends StatefulComponent {
  final void Function() onLogin;
  const LoginPage({required this.onLogin});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _supabase = SupabaseClient(
    'https://yusygjecjjecrerctven.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl1c3lnamVjamplY3JlcmN0dmVuIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MjU4NjU0NCwiZXhwIjoyMDg4MTYyNTQ0fQ.syX1spTkLqxO4aIBNBnxCvI2PgGBCYxboTbhJ9kmlN0',
  );
  String _email = '';
  String _password = '';
  String? _error;
  bool _loading = false;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await _supabase.auth.signInWithPassword(email: _email, password: _password);
      final token = res.session?.accessToken;
      if (token == null) throw Exception('No session token');
      appState.token = token;
      appState.userEmail = res.user?.email;
      api.setToken(token);
      component.onLogin();
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([
        div([
          h1([Component.text('Andrew Studio')]),
          p([Component.text('Dashboard')]),
        ], classes: 'login-logo'),
        if (_error != null) div([Component.text(_error!)], classes: 'error-banner'),
        div([
          label([Component.text(t('email'))], htmlFor: 'email'),
          input<String>(
            id: 'email',
            type: InputType.email,
            classes: 'form-input',
            value: _email,
            onInput: (v) => setState(() => _email = v),
          ),
        ], classes: 'form-group'),
        div([
          label([Component.text(t('password'))], htmlFor: 'password'),
          input<String>(
            id: 'password',
            type: InputType.password,
            classes: 'form-input',
            value: _password,
            onInput: (v) => setState(() => _password = v),
            events: {
              'keydown': (e) { if ((e as dynamic).key == 'Enter') _login(); },
            },
          ),
        ], classes: 'form-group'),
        button(
          [Component.text(_loading ? '...' : t('login'))],
          classes: 'btn btn-primary btn-full',
          onClick: _loading ? null : _login,
        ),
      ], classes: 'login-card'),
    ], classes: 'login-page');
  }
}
