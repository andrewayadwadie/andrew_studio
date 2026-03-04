import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';
import '../bloc/wallpaper_state.dart';

class WallpapersPage extends StatelessWidget {
  final String? categoryId;
  const WallpapersPage({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WallpaperBloc>()..add(LoadWallpapers(categoryId: categoryId)),
      child: const _WallpapersView(),
    );
  }
}

class _WallpapersView extends StatefulWidget {
  const _WallpapersView();
  @override
  State<_WallpapersView> createState() => _WallpapersViewState();
}

class _WallpapersViewState extends State<_WallpapersView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<WallpaperBloc>().add(LoadMoreWallpapers());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallpapers')),
      body: BlocBuilder<WallpaperBloc, WallpaperState>(
        builder: (context, state) {
          if (state is WallpaperLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WallpaperError) {
            return Center(child: Text(state.message));
          }
          if (state is WallpaperLoaded) {
            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.wallpapers.length,
              itemBuilder: (context, i) {
                final w = state.wallpapers[i];
                return GestureDetector(
                  onTap: () => context.push('/wallpaper/${w.id}'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: w.thumbnailUrl ?? w.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const ColoredBox(color: Colors.grey),
                      errorWidget: (_, __, ___) => const ColoredBox(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
