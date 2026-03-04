import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/l10n.dart';
import '../components/modal.dart';
import '../components/toast.dart';

class AppsPage extends StatefulComponent {
  const AppsPage();
  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  List<Map<String, dynamic>> _apps = [];
  bool _loading = true;
  bool _showModal = false;
  Map<String, dynamic>? _editingApp;
  String _name = '';
  String _slug = '';
  String _desc = '';
  bool _saving = false;

  @override
  void initState() { super.initState(); _loadApps(); }

  Future<void> _loadApps() async {
    try {
      final data = await api.get('/apps');
      setState(() { _apps = List<Map<String, dynamic>>.from(data['data'] as List); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      showToast(e.toString(), isError: true);
    }
  }

  void _openAdd() => setState(() { _editingApp = null; _name = ''; _slug = ''; _desc = ''; _showModal = true; });
  void _openEdit(Map<String, dynamic> app) => setState(() {
    _editingApp = app; _name = app['name'] ?? ''; _slug = app['slug'] ?? ''; _desc = app['description'] ?? ''; _showModal = true;
  });

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_editingApp == null) {
        await api.post('/apps', {'name': _name, 'slug': _slug, 'description': _desc});
      } else {
        await api.put('/apps/${_editingApp!['slug']}', {'name': _name, 'description': _desc});
      }
      setState(() { _showModal = false; _saving = false; });
      showToast(t('saved'));
      await _loadApps();
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _delete(String slug) async {
    try {
      await api.delete('/apps/$slug');
      showToast(t('deleted'));
      await _loadApps();
    } catch (e) { showToast(e.toString(), isError: true); }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([
        h2([Component.text(t('apps'))]),
        button([Component.text('+ ${t("new_app")}')], classes: 'btn btn-primary', onClick: _openAdd),
      ], classes: 'page-header'),
      if (_loading)
        div([Component.text('...')], classes: 'loading')
      else if (_apps.isEmpty)
        div([Component.text(t('no_items'))], classes: 'empty')
      else
        div([
          for (final app in _apps)
            div([
              div([
                h3([Component.text(app['name'] as String? ?? '')]),
                p([Component.text(app['slug'] as String? ?? '')], classes: 'text-muted'),
                if (app['description'] != null) p([Component.text(app['description'] as String)]),
              ], classes: 'card-body'),
              div([
                button([Component.text(t('edit'))], classes: 'btn btn-ghost btn-sm', onClick: () => _openEdit(app)),
                button([Component.text(t('delete'))], classes: 'btn btn-danger btn-sm', onClick: () => _delete(app['slug'] as String)),
              ], classes: 'card-actions'),
            ], classes: 'card'),
        ], classes: 'grid grid-3'),
      if (_showModal)
        Modal(
          title: _editingApp == null ? t('new_app') : t('edit'),
          onClose: () => setState(() => _showModal = false),
          onSave: _save,
          isLoading: _saving,
          children: [
            div([
              label([Component.text(t('app_name'))], htmlFor: 'app-name'),
              input<String>(id: 'app-name', type: InputType.text, classes: 'form-input', value: _name, onInput: (v) => setState(() => _name = v)),
            ], classes: 'form-group'),
            if (_editingApp == null)
              div([
                label([Component.text(t('app_slug'))], htmlFor: 'app-slug'),
                input<String>(id: 'app-slug', type: InputType.text, classes: 'form-input', value: _slug, onInput: (v) => setState(() => _slug = v)),
              ], classes: 'form-group'),
            div([
              label([Component.text(t('description'))], htmlFor: 'app-desc'),
              input<String>(id: 'app-desc', type: InputType.text, classes: 'form-input', value: _desc, onInput: (v) => setState(() => _desc = v)),
            ], classes: 'form-group'),
          ],
        ),
    ], classes: 'page');
  }
}
