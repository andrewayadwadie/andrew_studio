import 'package:jaspr_test/jaspr_test.dart';
import 'package:dashboard/components/toast.dart';
import 'package:dashboard/components/sidebar.dart';
import 'package:dashboard/utils/app_state.dart';

void main() {
  group('ToastContainer', () {
    testComponents('renders empty toast container', (tester) async {
      appState.toasts.clear();
      tester.pumpComponent(const ToastContainer());

      expect(find.tag('div'), findsComponents);
    });

    testComponents('renders toast messages', (tester) async {
      appState.toasts.clear();
      appState.toasts.add(Toast('Hello!'));
      tester.pumpComponent(const ToastContainer());

      expect(find.text('Hello!'), findsOneComponent);
      appState.toasts.clear();
    });
  });

  group('Sidebar', () {
    testComponents('renders brand name', (tester) async {
      tester.pumpComponent(
        Sidebar(activePage: 'dashboard', onNavigate: (_) {}),
      );

      expect(find.text('Andrew Studio'), findsOneComponent);
    });

    testComponents('renders all nav items', (tester) async {
      tester.pumpComponent(
        Sidebar(activePage: 'apps', onNavigate: (_) {}),
      );

      // 9 nav buttons + 3 footer buttons = 12 total
      expect(find.tag('button'), findsNComponents(12));
    });

    testComponents('calls onNavigate when nav button clicked', (tester) async {
      String? navigatedTo;
      tester.pumpComponent(
        Sidebar(
          activePage: 'dashboard',
          onNavigate: (page) => navigatedTo = page,
        ),
      );

      await tester.click(
        find.ancestor(of: find.text('📱'), matching: find.tag('button')),
      );
      expect(navigatedTo, equals('apps'));
    });
  });
}
