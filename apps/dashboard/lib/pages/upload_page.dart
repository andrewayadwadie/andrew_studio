import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/app_state.dart';
import '../utils/l10n.dart';
import '../components/toast.dart';

class UploadPage extends StatefulComponent {
  const UploadPage();
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _previewUrl;
  String? _base64Data;
  String _title = '';
  String _description = '';
  String _link = '';
  bool _uploading = false;

  void _pickFile() {
    final input = web.HTMLInputElement()
      ..type = 'file'
      ..accept = 'image/*';
    input.addEventListener('change', (web.Event _) {
      final files = input.files;
      if (files == null || files.length == 0) return;
      final file = files.item(0)!;
      final reader = web.FileReader();
      reader.addEventListener('load', (web.Event _) {
        final dataUrl = (reader.result as JSString).toDart;
        final base64 = dataUrl.split(',').last;
        setState(() { _base64Data = base64; _previewUrl = dataUrl; });
      }.toJS);
      reader.readAsDataURL(file);
    }.toJS);
    input.click();
  }

  Future<void> _upload() async {
    if (_base64Data == null) return;
    setState(() => _uploading = true);
    try {
      final slug = appState.selectedAppSlug ?? 'walluxe';
      final uploadRes = await api.post('/upload', {'image_base64': _base64Data, 'folder': 'uploads/$slug'});
      final imageUrl = uploadRes['data']['image_url'] as String;
      await api.post('/apps/$slug/wallpapers', {
        'image_url': imageUrl, 'title': _title, 'description': _description, 'attached_link': _link, 'source': 'upload',
      });
      setState(() { _uploading = false; _previewUrl = null; _base64Data = null; });
      showToast(t('saved'));
    } catch (e) {
      setState(() => _uploading = false);
      showToast(e.toString(), isError: true);
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([h2([Component.text(t('upload'))])], classes: 'page-header'),
      div([
        div([
          if (_previewUrl == null)
            div([
              p([Component.text('Click to select image')]),
              p([Component.text('PNG, JPG, WEBP')], classes: 'text-muted'),
            ], classes: 'drop-zone', events: {'click': (e) => _pickFile()})
          else
            div([
              img(src: _previewUrl!, alt: 'Preview', classes: 'preview-img'),
              button([Component.text('Change')], classes: 'btn btn-ghost btn-sm', onClick: _pickFile),
            ], classes: 'upload-preview'),
          div([], classes: 'divider'),
          div([
            label([Component.text(t('title'))], htmlFor: 'up-title'),
            input<String>(id: 'up-title', type: InputType.text, classes: 'form-input', value: _title, onInput: (v) => setState(() => _title = v)),
          ], classes: 'form-group'),
          div([
            label([Component.text(t('description'))], htmlFor: 'up-desc'),
            input<String>(id: 'up-desc', type: InputType.text, classes: 'form-input', value: _description, onInput: (v) => setState(() => _description = v)),
          ], classes: 'form-group'),
          div([
            label([Component.text(t('link'))], htmlFor: 'up-link'),
            input<String>(id: 'up-link', type: InputType.url, classes: 'form-input', value: _link, onInput: (v) => setState(() => _link = v)),
          ], classes: 'form-group'),
          if (_previewUrl != null)
            button(
              [Component.text(_uploading ? t('uploading') : t('save'))],
              classes: 'btn btn-primary btn-full',
              onClick: _uploading ? null : _upload,
            ),
        ], classes: 'upload-panel'),
      ], classes: 'upload-layout'),
    ], classes: 'page');
  }
}
