import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/app_state.dart';
import '../utils/l10n.dart';
import '../components/toast.dart';

class UnsplashPage extends StatefulComponent {
  const UnsplashPage();
  @override
  State<UnsplashPage> createState() => _UnsplashPageState();
}

class _UnsplashPageState extends State<UnsplashPage> {
  String _query = '';
  List<Map<String, dynamic>> _results = [];
  bool _searching = false;
  final Set<String> _saving = {};

  Future<void> _search() async {
    if (_query.isEmpty) return;
    setState(() { _searching = true; _results = []; });
    try {
      final res = await api.get('/unsplash/search?query=${Uri.encodeComponent(_query)}&per_page=24');
      setState(() { _results = List<Map<String, dynamic>>.from(res['data'] as List); _searching = false; });
    } catch (e) {
      setState(() => _searching = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _addToLibrary(Map<String, dynamic> photo) async {
    final id = photo['id'] as String;
    setState(() => _saving.add(id));
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final imageUrl = (photo['urls'] as Map)['regular'] as String;
      final uploadRes = await api.post('/upload', {'image_url': imageUrl, 'folder': 'unsplash/$slug'});
      final storedUrl = uploadRes['data']['image_url'] as String;
      await api.post('/apps/$slug/wallpapers', {
        'image_url': storedUrl,
        'thumbnail_url': (photo['urls'] as Map)['thumb'] as String,
        'title': photo['description'] ?? photo['alt_description'] ?? 'Unsplash',
        'source': 'unsplash',
      });
      showToast(t('saved'));
    } catch (e) {
      showToast(e.toString(), isError: true);
    } finally {
      setState(() => _saving.remove(id));
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([h2([Component.text(t('unsplash'))])], classes: 'page-header'),
      div([
        input<String>(
          type: InputType.text,
          classes: 'form-input search-input',
          attributes: {'placeholder': t('search')},
          value: _query,
          onInput: (v) => setState(() => _query = v),
          events: {'keydown': (e) { if ((e as dynamic).key == 'Enter') _search(); }},
        ),
        button([Component.text(_searching ? '...' : t('search'))], classes: 'btn btn-primary', onClick: _searching ? null : _search),
      ], classes: 'search-bar'),
      if (_searching)
        div([Component.text('...')], classes: 'loading')
      else if (_results.isEmpty && _query.isNotEmpty)
        div([Component.text(t('no_items'))], classes: 'empty')
      else
        div([
          for (final photo in _results)
            div([
              div([
                img(
                  src: (photo['urls'] as Map)['thumb'] as String,
                  alt: photo['alt_description'] as String? ?? '',
                  classes: 'wallpaper-img',
                ),
              ], classes: 'wallpaper-img-wrap'),
              div([
                p([Component.text('by ${(photo['user'] as Map)['name'] as String? ?? ''}')], classes: 'text-muted text-xs'),
              ], classes: 'wallpaper-info'),
              div([
                button(
                  [Component.text(_saving.contains(photo['id']) ? '...' : '+ Add')],
                  classes: 'btn btn-primary btn-xs',
                  onClick: () => _addToLibrary(photo),
                ),
              ], classes: 'wallpaper-actions'),
            ], classes: 'wallpaper-card'),
        ], classes: 'grid grid-4'),
    ], classes: 'page');
  }
}
