import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper.dart';

abstract class WallpaperState extends Equatable {
  const WallpaperState();
  @override
  List<Object?> get props => [];
}

class WallpaperInitial extends WallpaperState {}
class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<Wallpaper> wallpapers;
  final bool hasMore;
  final int page;
  const WallpaperLoaded({required this.wallpapers, this.hasMore = false, this.page = 0});
  @override
  List<Object?> get props => [wallpapers, hasMore, page];
}

class WallpaperError extends WallpaperState {
  final String message;
  const WallpaperError(this.message);
  @override
  List<Object?> get props => [message];
}
