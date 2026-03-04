import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/l10n.dart';
import '../utils/app_state.dart';

class Sidebar extends StatefulComponent {
  final String activePage;
  final void Function(String page) onNavigate;
  const Sidebar({required this.activePage, required this.onNavigate});
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final _navItems = const [
    ('dashboard', '⊞'),
    ('apps', '📱'),
    ('wallpapers', '🖼'),
    ('categories', '🗂'),
    ('generate', '✨'),
    ('upload', '⬆'),
    ('unsplash', '🔍'),
    ('pinterest', '📌'),
    ('notifications', '🔔'),
  ];

  @override
  Component build(BuildContext context) {
    return nav([
      div([span([Component.text('Andrew Studio')], classes: 'logo-text')], classes: 'sidebar-logo'),
      ul([
        for (final (key, icon) in _navItems)
          li([
            button([span([Component.text(icon)]), span([Component.text(t(key))])],
              classes: 'nav-btn',
              onClick: () => component.onNavigate(key),
            ),
          ], classes: 'nav-item ${component.activePage == key ? "active" : ""}'),
      ], classes: 'nav-list'),
      div([
        button([Component.text(appState.isDark ? '☀ ${t("light_mode")}' : '🌙 ${t("dark_mode")}')],
          classes: 'nav-btn theme-btn',
          onClick: () => setState(() { appState.isDark = !appState.isDark; }),
        ),
        button([Component.text(appState.locale == 'en' ? t('arabic') : t('english'))],
          classes: 'nav-btn lang-btn',
          onClick: () => setState(() { appState.locale = appState.locale == 'en' ? 'ar' : 'en'; }),
        ),
        button([Component.text('🚪 ${t("logout")}')],
          classes: 'nav-btn logout-btn',
          onClick: () { appState.token = null; component.onNavigate('login'); },
        ),
      ], classes: 'sidebar-footer'),
    ], classes: 'sidebar');
  }
}
