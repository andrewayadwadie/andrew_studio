import 'package:equatable/equatable.dart';

abstract class WallpaperEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWallpapers extends WallpaperEvent {
  final String? categoryId;
  LoadWallpapers({this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class LoadMoreWallpapers extends WallpaperEvent {}
