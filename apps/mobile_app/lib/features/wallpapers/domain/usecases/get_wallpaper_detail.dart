import 'package:injectable/injectable.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

@injectable
class GetWallpaperDetail {
  final WallpaperRepository _repository;
  const GetWallpaperDetail(this._repository);

  Future<Wallpaper?> call(String id) => _repository.getWallpaperDetail(id);
}
