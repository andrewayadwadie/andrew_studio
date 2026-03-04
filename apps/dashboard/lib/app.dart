import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'components/sidebar.dart';
import 'components/toast.dart';
import 'pages/login_page.dart';
import 'pages/apps_page.dart';
import 'pages/wallpapers_page.dart';
import 'pages/categories_page.dart';
import 'pages/generate_page.dart';
import 'pages/upload_page.dart';
import 'pages/unsplash_page.dart';
import 'pages/pinterest_page.dart';
import 'pages/notifications_page.dart';
import 'utils/app_state.dart';

class App extends StatefulComponent {
  const App();
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String _page = 'login';
  void _navigate(String page) => setState(() => _page = page);

  Component _buildPage() {
    switch (_page) {
      case 'apps': return const AppsPage();
      case 'wallpapers': return const WallpapersPage();
      case 'categories': return const CategoriesPage();
      case 'generate': return const GeneratePage();
      case 'upload': return const UploadPage();
      case 'unsplash': return const UnsplashPage();
      case 'pinterest': return const PinterestPage();
      case 'notifications': return const NotificationsPage();
      default: return _buildDashboard();
    }
  }

  Component _buildDashboard() {
    return div([
      div([h2([Component.text('Dashboard')])], classes: 'page-header'),
      div([
        _statCard('Apps', '📱', 'apps'),
        _statCard('Wallpapers', '🖼', 'wallpapers'),
        _statCard('Categories', '🗂', 'categories'),
        _statCard('Generate AI', '✨', 'generate'),
        _statCard('Upload', '⬆', 'upload'),
        _statCard('Unsplash', '🔍', 'unsplash'),
        _statCard('Pinterest', '📌', 'pinterest'),
        _statCard('Notifications', '🔔', 'notifications'),
      ], classes: 'grid grid-3'),
    ], classes: 'page');
  }

  Component _statCard(String label, String icon, String page) {
    return div([
      button([
        span([Component.text(icon)], classes: 'stat-icon'),
        span([Component.text(label)], classes: 'stat-label'),
      ], classes: 'stat-card-btn', onClick: () => _navigate(page)),
    ], classes: 'card stat-card');
  }

  @override
  Component build(BuildContext context) {
    if (_page == 'login' || !appState.isLoggedIn) {
      return div([
        LoginPage(onLogin: () => setState(() => _page = 'dashboard')),
        const ToastContainer(),
      ], classes: appState.isDark ? '' : 'light', id: 'app');
    }
    return div([
      Sidebar(activePage: _page, onNavigate: _navigate),
      main_([_buildPage()], classes: 'content'),
      const ToastContainer(),
    ], classes: appState.isDark ? 'layout' : 'layout light', id: 'app');
  }
}
