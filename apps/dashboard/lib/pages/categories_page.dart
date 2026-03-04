import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/app_state.dart';
import '../utils/l10n.dart';
import '../components/modal.dart';
import '../components/toast.dart';

class CategoriesPage extends StatefulComponent {
  const CategoriesPage();
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;
  bool _showModal = false;
  Map<String, dynamic>? _editingCat;
  String _name = '';
  String _desc = '';
  bool _saving = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final res = await api.get('/apps/$slug/categories');
      setState(() { _categories = List<Map<String, dynamic>>.from(res['data'] as List); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      showToast(e.toString(), isError: true);
    }
  }

  void _openAdd() => setState(() { _editingCat = null; _name = ''; _desc = ''; _showModal = true; });
  void _openEdit(Map<String, dynamic> c) => setState(() {
    _editingCat = c; _name = c['name'] ?? ''; _desc = c['description'] ?? ''; _showModal = true;
  });

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      if (_editingCat == null) {
        await api.post('/apps/$slug/categories', {'name': _name, 'description': _desc});
      } else {
        await api.put('/apps/$slug/categories/${_editingCat!['id']}', {'name': _name, 'description': _desc});
      }
      setState(() { _showModal = false; _saving = false; });
      showToast(t('saved'));
      await _load();
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _delete(String id) async {
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      await api.delete('/apps/$slug/categories/$id');
      showToast(t('deleted'));
      await _load();
    } catch (e) { showToast(e.toString(), isError: true); }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([
        h2([Component.text(t('categories'))]),
        button([Component.text('+ ${t("new_category")}')], classes: 'btn btn-primary', onClick: _openAdd),
      ], classes: 'page-header'),
      if (_loading)
        div([Component.text('...')], classes: 'loading')
      else if (_categories.isEmpty)
        div([Component.text(t('no_items'))], classes: 'empty')
      else
        div([
          for (final cat in _categories)
            div([
              div([
                h3([Component.text(cat['name'] as String? ?? '')]),
                if (cat['description'] != null) p([Component.text(cat['description'] as String)], classes: 'text-muted'),
              ], classes: 'card-body'),
              div([
                button([Component.text(t('edit'))], classes: 'btn btn-ghost btn-sm', onClick: () => _openEdit(cat)),
                button([Component.text(t('delete'))], classes: 'btn btn-danger btn-sm', onClick: () => _delete(cat['id'] as String)),
              ], classes: 'card-actions'),
            ], classes: 'card'),
        ], classes: 'grid grid-3'),
      if (_showModal)
        Modal(
          title: _editingCat == null ? t('new_category') : t('edit'),
          onClose: () => setState(() => _showModal = false),
          onSave: _save,
          isLoading: _saving,
          children: [
            div([
              label([Component.text(t('title'))], htmlFor: 'cat-name'),
              input<String>(id: 'cat-name', type: InputType.text, classes: 'form-input', value: _name, onInput: (v) => setState(() => _name = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('description'))], htmlFor: 'cat-desc'),
              input<String>(id: 'cat-desc', type: InputType.text, classes: 'form-input', value: _desc, onInput: (v) => setState(() => _desc = v)),
            ], classes: 'form-group'),
          ],
        ),
    ], classes: 'page');
  }
}
