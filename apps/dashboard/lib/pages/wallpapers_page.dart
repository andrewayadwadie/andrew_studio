import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/app_state.dart';
import '../utils/l10n.dart';
import '../components/modal.dart';
import '../components/toast.dart';

class WallpapersPage extends StatefulComponent {
  const WallpapersPage();
  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  List<Map<String, dynamic>> _wallpapers = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _pinterestAccounts = [];
  bool _loading = true;
  bool _showEditModal = false;
  bool _showPinModal = false;
  Map<String, dynamic>? _selectedWallpaper;
  String _title = '';
  String _description = '';
  String _link = '';
  String _categoryId = '';
  String _pinAccountId = '';
  String _pinBoardId = '';
  bool _saving = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final futures = await Future.wait([
        api.get('/apps/$slug/wallpapers'),
        api.get('/apps/$slug/categories'),
        api.get('/pinterest'),
      ]);
      setState(() {
        _wallpapers = List<Map<String, dynamic>>.from(futures[0]['data'] as List);
        _categories = List<Map<String, dynamic>>.from(futures[1]['data'] as List);
        _pinterestAccounts = List<Map<String, dynamic>>.from(futures[2]['data'] as List);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      showToast(e.toString(), isError: true);
    }
  }

  void _openEdit(Map<String, dynamic> w) => setState(() {
    _selectedWallpaper = w;
    _title = w['title'] as String? ?? '';
    _description = w['description'] as String? ?? '';
    _link = w['attached_link'] as String? ?? '';
    _categoryId = w['category_id'] as String? ?? '';
    _showEditModal = true;
  });

  void _openPin(Map<String, dynamic> w) => setState(() {
    _selectedWallpaper = w;
    _pinAccountId = _pinterestAccounts.isNotEmpty ? _pinterestAccounts.first['id'] as String : '';
    _showPinModal = true;
  });

  Future<void> _saveEdit() async {
    setState(() => _saving = true);
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final id = _selectedWallpaper!['id'] as String;
      await api.put('/apps/$slug/wallpapers/$id', {
        'title': _title, 'description': _description, 'attached_link': _link,
        if (_categoryId.isNotEmpty) 'category_id': _categoryId,
      });
      setState(() { _showEditModal = false; _saving = false; });
      showToast(t('saved'));
      await _load();
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _createPin() async {
    setState(() => _saving = true);
    try {
      await api.post('/pinterest/pin', {
        'account_id': _pinAccountId,
        'board_id': _pinBoardId,
        'image_url': _selectedWallpaper!['image_url'],
        'title': _selectedWallpaper!['title'] ?? 'Wallpaper',
        'description': _selectedWallpaper!['description'],
        'link': _selectedWallpaper!['attached_link'],
        'wallpaper_id': _selectedWallpaper!['id'],
      });
      setState(() { _showPinModal = false; _saving = false; });
      showToast('Pinned!');
      await _load();
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _delete(String id) async {
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      await api.delete('/apps/$slug/wallpapers/$id');
      showToast(t('deleted'));
      await _load();
    } catch (e) { showToast(e.toString(), isError: true); }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([h2([Component.text(t('wallpapers'))])], classes: 'page-header'),
      if (_loading)
        div([Component.text('...')], classes: 'loading')
      else if (_wallpapers.isEmpty)
        div([Component.text(t('no_items'))], classes: 'empty')
      else
        div([
          for (final w in _wallpapers)
            div([
              div([
                img(
                  src: w['thumbnail_url'] as String? ?? w['image_url'] as String,
                  alt: w['title'] as String? ?? '',
                  classes: 'wallpaper-img',
                ),
              ], classes: 'wallpaper-img-wrap'),
              div([
                if (w['title'] != null) p([Component.text(w['title'] as String)], classes: 'wallpaper-title'),
                p([Component.text(w['source'] as String? ?? 'upload')], classes: 'text-muted text-xs'),
              ], classes: 'wallpaper-info'),
              div([
                button([Component.text(t('edit'))], classes: 'btn btn-ghost btn-xs', onClick: () => _openEdit(w)),
                button([Component.text('📌')], classes: 'btn btn-ghost btn-xs', onClick: () => _openPin(w)),
                a([Component.text('⬇')], href: w['image_url'] as String, download: w['title'] as String? ?? 'wallpaper', classes: 'btn btn-ghost btn-xs'),
                button([Component.text('✕')], classes: 'btn btn-danger btn-xs', onClick: () => _delete(w['id'] as String)),
              ], classes: 'wallpaper-actions'),
            ], classes: 'wallpaper-card'),
        ], classes: 'grid grid-4'),
      if (_showEditModal)
        Modal(
          title: t('edit'),
          onClose: () => setState(() => _showEditModal = false),
          onSave: _saveEdit,
          isLoading: _saving,
          children: [
            div([
              label([Component.text(t('title'))], htmlFor: 'w-title'),
              input<String>(id: 'w-title', type: InputType.text, classes: 'form-input', value: _title, onInput: (v) => setState(() => _title = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('description'))], htmlFor: 'w-desc'),
              textarea([Component.text(_description)], id: 'w-desc', classes: 'form-input', rows: 3, onInput: (v) => setState(() => _description = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('link'))], htmlFor: 'w-link'),
              input<String>(id: 'w-link', type: InputType.url, classes: 'form-input', value: _link, onInput: (v) => setState(() => _link = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('category'))], htmlFor: 'w-cat'),
              select([
                option([Component.text('—')], value: '', selected: _categoryId.isEmpty),
                for (final c in _categories)
                  option([Component.text(c['name'] as String)], value: c['id'] as String, selected: _categoryId == c['id']),
              ], id: 'w-cat', classes: 'form-input', onChange: (v) => setState(() => _categoryId = v.isEmpty ? '' : v.first)),
            ], classes: 'form-group'),
          ],
        ),
      if (_showPinModal)
        Modal(
          title: t('pin_to_pinterest'),
          onClose: () => setState(() => _showPinModal = false),
          onSave: _createPin,
          isLoading: _saving,
          children: [
            div([
              label([Component.text(t('account'))], htmlFor: 'pin-acc'),
              select([
                for (final acc in _pinterestAccounts)
                  option([Component.text(acc['username'] as String)], value: acc['id'] as String, selected: _pinAccountId == acc['id']),
              ], id: 'pin-acc', classes: 'form-input', onChange: (v) => setState(() => _pinAccountId = v.isEmpty ? '' : v.first)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('board'))], htmlFor: 'pin-board'),
              input<String>(id: 'pin-board', type: InputType.text, classes: 'form-input', value: _pinBoardId, onInput: (v) => setState(() => _pinBoardId = v)),
            ], classes: 'form-group'),
          ],
        ),
    ], classes: 'page');
  }
}
