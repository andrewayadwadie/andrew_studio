import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/api_client.dart';
import '../utils/l10n.dart';
import '../components/toast.dart';

class NotificationsPage extends StatefulComponent {
  const NotificationsPage();
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _title = '';
  String _message = '';
  String _targetApp = '';
  bool _sending = false;

  Future<void> _send() async {
    if (_title.isEmpty || _message.isEmpty) return;
    setState(() => _sending = true);
    try {
      await api.post('/notifications', {
        'title': _title, 'message': _message,
        if (_targetApp.isNotEmpty) 'app_slug': _targetApp,
      });
      setState(() { _sending = false; _title = ''; _message = ''; });
      showToast('Notification sent!');
    } catch (e) {
      setState(() => _sending = false);
      showToast(e.toString(), isError: true);
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      div([h2([Component.text(t('notifications'))])], classes: 'page-header'),
      div([
        div([
          label([Component.text(t('target_app'))], htmlFor: 'notif-app'),
          input<String>(
            id: 'notif-app', type: InputType.text, classes: 'form-input',
            attributes: {'placeholder': t('all_apps')},
            value: _targetApp,
            onInput: (v) => setState(() => _targetApp = v),
          ),
        ], classes: 'form-group'),
        div([
          label([Component.text(t('title'))], htmlFor: 'notif-title'),
          input<String>(id: 'notif-title', type: InputType.text, classes: 'form-input', value: _title, onInput: (v) => setState(() => _title = v)),
        ], classes: 'form-group'),
        div([
          label([Component.text(t('message'))], htmlFor: 'notif-msg'),
          textarea([Component.text(_message)], id: 'notif-msg', classes: 'form-input', rows: 4, onInput: (v) => setState(() => _message = v)),
        ], classes: 'form-group'),
        button([Component.text(_sending ? '...' : t('send_notification'))], classes: 'btn btn-primary', onClick: _sending ? null : _send),
      ], classes: 'notification-form'),
    ], classes: 'page');
  }
}
