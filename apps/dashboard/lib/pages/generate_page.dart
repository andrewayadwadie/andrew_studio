import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/app_state.dart';
import '../utils/l10n.dart';
import '../components/toast.dart';

class GeneratePage extends StatefulComponent {
  const GeneratePage();
  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String _prompt = '';
  String? _generatedUrl;
  bool _generating = false;
  bool _saving = false;
  String _title = '';
  String _description = '';
  String _link = '';

  Future<void> _generate() async {
    if (_prompt.isEmpty) return;
    setState(() { _generating = true; _generatedUrl = null; });
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final res = await api.post('/generate', {'prompt': _prompt, 'folder': 'generated/$slug'});
      setState(() { _generatedUrl = res['data']['image_url'] as String; _generating = false; });
    } catch (e) {
      setState(() => _generating = false);
      showToast(e.toString(), isError: true);
    }
  }

  Future<void> _saveToLibrary() async {
    if (_generatedUrl == null) return;
    setState(() => _saving = true);
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      await api.post('/apps/$slug/wallpapers', {
        'image_url': _generatedUrl,
        'title': _title,
        'description': _description,
        'attached_link': _link,
        'source': 'ai',
      });
      setState(() { _saving = false; _generatedUrl = null; _prompt = ''; });
      showToast(t('saved'));
    } catch (e) {
      setState(() => _saving = false);
      showToast(e.toString(), isError: true);
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([h2([Component.text(t('generate'))])], classes: 'page-header'),
      div([
        div([
          div([
            label([Component.text(t('prompt'))], htmlFor: 'prompt'),
            textarea([Component.text(_prompt)],
              id: 'prompt', classes: 'form-input prompt-input', rows: 5,
              onInput: (v) => setState(() => _prompt = v),
            ),
          ], classes: 'form-group'),
          button(
            [Component.text(_generating ? t('generating') : t('generate'))],
            classes: 'btn btn-primary btn-full',
            onClick: _generating ? null : _generate,
          ),
          if (_generatedUrl != null) ...[
            div([], classes: 'divider'),
            div([
              label([Component.text(t('title'))], htmlFor: 'gen-title'),
              input<String>(id: 'gen-title', type: InputType.text, classes: 'form-input', value: _title, onInput: (v) => setState(() => _title = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('description'))], htmlFor: 'gen-desc'),
              input<String>(id: 'gen-desc', type: InputType.text, classes: 'form-input', value: _description, onInput: (v) => setState(() => _description = v)),
            ], classes: 'form-group'),
            div([
              label([Component.text(t('link'))], htmlFor: 'gen-link'),
              input<String>(id: 'gen-link', type: InputType.url, classes: 'form-input', value: _link, onInput: (v) => setState(() => _link = v)),
            ], classes: 'form-group'),
            button(
              [Component.text(_saving ? t('uploading') : t('save'))],
              classes: 'btn btn-success btn-full',
              onClick: _saving ? null : _saveToLibrary,
            ),
          ],
        ], classes: 'generate-panel'),
        div([
          if (_generating)
            div([div([], classes: 'spinner'), p([Component.text(t('generating'))])], classes: 'generating-placeholder')
          else if (_generatedUrl != null)
            div([
              img(src: _generatedUrl!, alt: 'Generated', classes: 'preview-img'),
              div([
                a([Component.text('⬇ ${t("download")}')], href: _generatedUrl!, download: 'generated.jpg', classes: 'btn btn-ghost'),
              ], classes: 'preview-actions'),
            ], classes: 'preview-result')
          else
            div([p([Component.text('Your generated image will appear here')])], classes: 'preview-empty'),
        ], classes: 'generate-preview'),
      ], classes: 'generate-layout'),
    ], classes: 'page');
  }
}
