import '../../domain/entities/wallpaper.dart';

class WallpaperModel extends Wallpaper {
  const WallpaperModel({
    required super.id,
    required super.imageUrl,
    super.thumbnailUrl,
    super.title,
    super.categoryId,
    super.source,
    super.tags,
    super.downloadCount,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      title: json['title'] as String?,
      categoryId: json['category_id'] as String?,
      source: json['source'] as String? ?? 'upload',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      downloadCount: json['download_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'thumbnail_url': thumbnailUrl,
    'title': title,
    'category_id': categoryId,
    'source': source,
    'tags': tags,
    'download_count': downloadCount,
  };
}
