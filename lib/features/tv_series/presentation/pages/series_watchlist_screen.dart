import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/tv_series/presentation/pages/tv_series_details_screen.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SeriesWatchlistScreen extends StatelessWidget {
  const SeriesWatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Series Watchlist", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LiquidBackground(
        child: BlocBuilder<SeriesWatchlistBloc, SeriesWatchlistState>(
          builder: (context, state) {
            if (state.series.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(height: 16),
                    Text("Your series watchlist is empty", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 18)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.series.length,
              itemBuilder: (context, index) {
                final series = state.series[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassContainer(
                    borderRadius: 20,
                    blur: 10,
                    opacity: 0.1,
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TVSeriesDetailsScreen(series: series),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: series.posterUrl,
                              width: 70,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(series.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text('${series.releaseYear} • ${series.genre}', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.primary),
                            onPressed: () => context.read<SeriesWatchlistBloc>().add(ToggleSeriesWatchlist(series)),
                          ),
                        ],
                      ),
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

