import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? coverImageUrl;
  final int wallpaperCount;

  const Category({
    required this.id,
    required this.name,
    this.coverImageUrl,
    this.wallpaperCount = 0,
  });

  @override
  List<Object?> get props => [id, name];
}
