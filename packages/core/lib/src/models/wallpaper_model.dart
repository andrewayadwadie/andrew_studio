import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallpaper_model.freezed.dart';
part 'wallpaper_model.g.dart';

@freezed
class WallpaperModel with _$WallpaperModel {
  const factory WallpaperModel({
    required String id,
    required String appId,
    String? categoryId,
    required String imageUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    String? attachedLink,
    @Default('ai') String source, // 'ai', 'upload', 'unsplash'
    String? pinterestPinId,
    String? pinterestBoardId,
    @Default([]) List<String> tags,
    @Default(0) int downloadCount,
    required DateTime createdAt,
  }) = _WallpaperModel;

  factory WallpaperModel.fromJson(Map<String, dynamic> json) =>
      _$WallpaperModelFromJson(json);
}
