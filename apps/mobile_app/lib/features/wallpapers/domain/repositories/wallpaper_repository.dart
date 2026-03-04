import '../entities/wallpaper.dart';

abstract class WallpaperRepository {
  Future<List<Wallpaper>> getWallpapers({
    required String appSlug,
    String? categoryId,
    int page = 0,
    int limit = 20,
  });

  Future<Wallpaper?> getWallpaperDetail(String id);
}
