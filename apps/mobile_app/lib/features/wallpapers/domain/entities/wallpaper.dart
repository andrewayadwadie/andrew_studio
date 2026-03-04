import 'package:equatable/equatable.dart';

class Wallpaper extends Equatable {
  final String id;
  final String imageUrl;
  final String? thumbnailUrl;
  final String? title;
  final String? categoryId;
  final String source;
  final List<String> tags;
  final int downloadCount;

  const Wallpaper({
    required this.id,
    required this.imageUrl,
    this.thumbnailUrl,
    this.title,
    this.categoryId,
    this.source = 'upload',
    this.tags = const [],
    this.downloadCount = 0,
  });

  @override
  List<Object?> get props => [id, imageUrl, title, categoryId];
}
