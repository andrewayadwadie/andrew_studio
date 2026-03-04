import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/l10n.dart';
import '../components/modal.dart';
import '../components/toast.dart';

class PinterestPage extends StatefulComponent {
  const PinterestPage();
  @override
  State<PinterestPage> createState() => _PinterestPageState();
}

class _PinterestPageState extends State<PinterestPage> {
  List<Map<String, dynamic>> _accounts = [];
  bool _loading = true;
  bool _showModal = false;
  String _username = '';
  String _accessToken = '';
  bool _saving = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final res = await api.get('/pinterest');
      setState(() { _accounts = List<Map<String, dynamic>>.from(res['data'] as List); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await api.post('/pinterest', {'username': _username, 'access_token': _accessToken});
      setState(() { _showModal = false; _saving = false; });
      showToast(t('saved'));
      await _load();
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([
        h2([Component.text(t('pinterest'))]),
        button([Component.text('+ ${t("add_account")}')], classes: 'btn btn-primary',
          onClick: () => setState(() { _username = ''; _accessToken = ''; _showModal = true; })),
      ], classes: 'page-header'),
      if (_loading)
        div([Component.text('...')], classes: 'loading')
      else if (_accounts.isEmpty)
        div([Component.text(t('no_items'))], classes: 'empty')
      else
        div([
          for (final acc in _accounts)
            div([
              div([
                h3([Component.text('@${acc['username'] as String? ?? ''}')]),
                span([Component.text((acc['is_active'] as bool? ?? false) ? 'Active' : 'Inactive')],
                  classes: 'badge ${(acc['is_active'] as bool? ?? false) ? "badge-success" : "badge-muted"}'),
              ], classes: 'card-body'),
            ], classes: 'card'),
        ], classes: 'grid grid-3'),
      if (_showModal)
        Modal(
          title: t('add_account'),
          onClose: () => setState(() => _showModal = false),
          onSave: _save,
          isLoading: _saving,
          children: [
            div([
              label([Component.text(t('account'))], htmlFor: 'pin-user'),
              input<String>(id: 'pin-user', type: InputType.text, classes: 'form-input', value: _username, onInput: (v) => setState(() => _username = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('access_token'))], htmlFor: 'pin-token'),
              input<String>(id: 'pin-token', type: InputType.text, classes: 'form-input', value: _accessToken, onInput: (v) => setState(() => _accessToken = v)),
            ], classes: 'form-group'),
          ],
        ),
    ], classes: 'page');
  }
}
