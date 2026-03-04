import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallpaper_model.dart';

abstract class WallpaperRemoteDataSource {
  Future<List<WallpaperModel>> getWallpapers({String? categoryId, int page = 0, int limit = 20});
  Future<WallpaperModel?> getWallpaperDetail(String id);
}

@Injectable(as: WallpaperRemoteDataSource)
class WallpaperRemoteDataSourceImpl implements WallpaperRemoteDataSource {
  final ApiClient _client;
  const WallpaperRemoteDataSourceImpl(this._client);

  @override
  Future<List<WallpaperModel>> getWallpapers({String? categoryId, int page = 0, int limit = 20}) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (categoryId != null) params['category_id'] = categoryId;
    final response = await _client.get(
      '/apps/${AppConstants.appSlug}/wallpapers',
      queryParameters: params,
    );
    final data = (response['data'] as List<dynamic>);
    return data.map((e) => WallpaperModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<WallpaperModel?> getWallpaperDetail(String id) async {
    final response = await _client.get('/apps/${AppConstants.appSlug}/wallpapers/$id');
    final data = response['data'];
    if (data == null) return null;
    return WallpaperModel.fromJson(data as Map<String, dynamic>);
  }
}
