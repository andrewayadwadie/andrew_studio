// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mobile_app/core/network/api_client.dart' as _i1072;
import 'package:mobile_app/features/categories/data/datasources/category_remote_datasource.dart'
    as _i834;
import 'package:mobile_app/features/categories/data/repositories/category_repository_impl.dart'
    as _i969;
import 'package:mobile_app/features/categories/domain/repositories/category_repository.dart'
    as _i388;
import 'package:mobile_app/features/categories/domain/usecases/get_categories.dart'
    as _i174;
import 'package:mobile_app/features/categories/presentation/cubit/category_cubit.dart'
    as _i293;
import 'package:mobile_app/features/wallpapers/data/datasources/wallpaper_remote_datasource.dart'
    as _i351;
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart'
    as _i551;
import 'package:mobile_app/features/wallpapers/domain/repositories/wallpaper_repository.dart'
    as _i920;
import 'package:mobile_app/features/wallpapers/domain/usecases/get_wallpaper_detail.dart'
    as _i623;
import 'package:mobile_app/features/wallpapers/domain/usecases/get_wallpapers.dart'
    as _i442;
import 'package:mobile_app/features/wallpapers/presentation/bloc/wallpaper_bloc.dart'
    as _i803;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i1072.ApiClient>(() => _i1072.ApiClient());
    gh.factory<_i834.CategoryRemoteDataSource>(
        () => _i834.CategoryRemoteDataSourceImpl(gh<_i1072.ApiClient>()));
    gh.factory<_i388.CategoryRepository>(() =>
        _i969.CategoryRepositoryImpl(gh<_i834.CategoryRemoteDataSource>()));
    gh.factory<_i351.WallpaperRemoteDataSource>(
        () => _i351.WallpaperRemoteDataSourceImpl(gh<_i1072.ApiClient>()));
    gh.factory<_i920.WallpaperRepository>(() =>
        _i551.WallpaperRepositoryImpl(gh<_i351.WallpaperRemoteDataSource>()));
    gh.factory<_i174.GetCategories>(
        () => _i174.GetCategories(gh<_i388.CategoryRepository>()));
    gh.factory<_i623.GetWallpaperDetail>(
        () => _i623.GetWallpaperDetail(gh<_i920.WallpaperRepository>()));
    gh.factory<_i442.GetWallpapers>(
        () => _i442.GetWallpapers(gh<_i920.WallpaperRepository>()));
    gh.factory<_i293.CategoryCubit>(
        () => _i293.CategoryCubit(gh<_i174.GetCategories>()));
    gh.factory<_i803.WallpaperBloc>(
        () => _i803.WallpaperBloc(gh<_i442.GetWallpapers>()));
    return this;
  }
}
