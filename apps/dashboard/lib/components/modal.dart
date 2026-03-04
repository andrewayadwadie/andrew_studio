import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/l10n.dart';

class Modal extends StatelessComponent {
  final String title;
  final List<Component> children;
  final void Function() onClose;
  final void Function()? onSave;
  final bool isLoading;

  const Modal({
    required this.title,
    required this.children,
    required this.onClose,
    this.onSave,
    this.isLoading = false,
  });

  @override
  Component build(BuildContext context) {
    return div([
      div([
        div([
          h3([Component.text(title)]),
          button([Component.text('✕')], classes: 'modal-close', onClick: onClose),
        ], classes: 'modal-header'),
        div(children, classes: 'modal-body'),
        div([
          button([Component.text(t('cancel'))], classes: 'btn btn-ghost', onClick: onClose),
          if (onSave != null)
            button([Component.text(isLoading ? '...' : t('save'))], classes: 'btn btn-primary', onClick: onSave),
        ], classes: 'modal-footer'),
      ], classes: 'modal', events: {'click': (e) => e.stopPropagation()}),
    ], classes: 'modal-overlay', events: {'click': (e) => onClose()});
  }
}
