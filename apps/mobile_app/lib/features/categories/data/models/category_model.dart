import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.coverImageUrl,
    super.wallpaperCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      wallpaperCount: json['wallpaper_count'] as int? ?? 0,
    );
  }
}
