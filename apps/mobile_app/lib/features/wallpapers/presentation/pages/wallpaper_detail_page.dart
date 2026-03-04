import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_state.dart';

class WallpaperDetailPage extends StatelessWidget {
  final String wallpaperId;
  const WallpaperDetailPage({super.key, required this.wallpaperId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WallpaperBloc>(),
      child: _WallpaperDetailView(wallpaperId: wallpaperId),
    );
  }
}

class _WallpaperDetailView extends StatelessWidget {
  final String wallpaperId;
  const _WallpaperDetailView({required this.wallpaperId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (context, state) {
        if (state is WallpaperLoaded) {
          final wallpaper = state.wallpapers.where((w) => w.id == wallpaperId).firstOrNull;
          if (wallpaper == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Wallpaper not found')),
            );
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: wallpaper.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ColoredBox(color: Colors.black),
                  errorWidget: (_, __, ___) => const ColoredBox(color: Colors.black),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (wallpaper.title != null)
                          Text(
                            wallpaper.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.download, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${wallpaper.downloadCount}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
