import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/presentation/bloc/downloads_bloc.dart';
import 'package:film_app/features/movies/presentation/pages/video_player_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Downloads", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LiquidBackground(
        child: BlocBuilder<DownloadsBloc, DownloadsState>(
          builder: (context, state) {
            if (state.downloadedMovies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download_for_offline_rounded, size: 80, color: Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(height: 16),
                    Text("No downloaded movies", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Movies you download will appear here", style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 14)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.downloadedMovies.length,
              itemBuilder: (context, index) {
                final movie = state.downloadedMovies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassContainer(
                    borderRadius: 20,
                    blur: 10,
                    opacity: 0.1,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath,
                            width: 80,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 6),
                              Text("Offline • 1.2 GB", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPage(
                                        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                                        title: movie.title,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                                      SizedBox(width: 4),
                                      Text("PLAY", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white30),
                          onPressed: () => context.read<DownloadsBloc>().add(RemoveFromDownloads(movie.id)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


