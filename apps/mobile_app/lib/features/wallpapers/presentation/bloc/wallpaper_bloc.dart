import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/get_wallpapers.dart';
import 'wallpaper_event.dart';
import 'wallpaper_state.dart';

@injectable
class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final GetWallpapers _getWallpapers;

  WallpaperBloc(this._getWallpapers) : super(WallpaperInitial()) {
    on<LoadWallpapers>(_onLoadWallpapers);
    on<LoadMoreWallpapers>(_onLoadMore);
  }

  Future<void> _onLoadWallpapers(LoadWallpapers event, Emitter<WallpaperState> emit) async {
    emit(WallpaperLoading());
    try {
      final wallpapers = await _getWallpapers(
        appSlug: AppConstants.appSlug,
        categoryId: event.categoryId,
        page: 0,
      );
      emit(WallpaperLoaded(wallpapers: wallpapers, hasMore: wallpapers.length >= 20));
    } catch (e) {
      emit(WallpaperError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreWallpapers event, Emitter<WallpaperState> emit) async {
    final current = state;
    if (current is! WallpaperLoaded || !current.hasMore) return;
    try {
      final more = await _getWallpapers(
        appSlug: AppConstants.appSlug,
        page: current.page + 1,
      );
      emit(WallpaperLoaded(
        wallpapers: [...current.wallpapers, ...more],
        hasMore: more.length >= 20,
        page: current.page + 1,
      ));
    } catch (_) {}
  }
}
