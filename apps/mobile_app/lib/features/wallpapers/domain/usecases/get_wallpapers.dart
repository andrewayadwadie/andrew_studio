import 'package:injectable/injectable.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

@injectable
class GetWallpapers {
  final WallpaperRepository _repository;
  const GetWallpapers(this._repository);

  Future<List<Wallpaper>> call({
    required String appSlug,
    String? categoryId,
    int page = 0,
  }) => _repository.getWallpapers(appSlug: appSlug, categoryId: categoryId, page: page);
}
