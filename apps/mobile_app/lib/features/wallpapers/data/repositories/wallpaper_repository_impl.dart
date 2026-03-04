import 'package:injectable/injectable.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../datasources/wallpaper_remote_datasource.dart';

@Injectable(as: WallpaperRepository)
class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperRemoteDataSource _remote;
  const WallpaperRepositoryImpl(this._remote);

  @override
  Future<List<Wallpaper>> getWallpapers({
    required String appSlug,
    String? categoryId,
    int page = 0,
    int limit = 20,
  }) => _remote.getWallpapers(categoryId: categoryId, page: page, limit: limit);

  @override
  Future<Wallpaper?> getWallpaperDetail(String id) => _remote.getWallpaperDetail(id);
}
