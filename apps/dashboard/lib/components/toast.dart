import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/app_state.dart';

class ToastContainer extends StatefulComponent {
  const ToastContainer();
  @override
  State<ToastContainer> createState() => _ToastContainerState();
}

class _ToastContainerState extends State<ToastContainer> {
  @override
  Component build(BuildContext context) {
    return div([
      for (final toast in appState.toasts)
        div([Component.text(toast.message)], classes: 'toast ${toast.isError ? "toast-error" : "toast-success"}'),
    ], classes: 'toast-container');
  }
}

void showToast(String message, {bool isError = false}) {
  final toast = Toast(message, isError: isError);
  appState.toasts.add(toast);
  Future.delayed(const Duration(seconds: 3), () {
    appState.toasts.remove(toast);
  });
}
