import 'package:go_router/go_router.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/wallpapers/presentation/pages/wallpapers_page.dart';
import 'features/wallpapers/presentation/pages/wallpaper_detail_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/categories',
    routes: [
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: '/wallpapers',
        builder: (context, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          return WallpapersPage(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/wallpaper/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WallpaperDetailPage(wallpaperId: id);
        },
      ),
    ],
  );
}
