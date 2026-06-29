import 'package:flutter/material.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/tv_series/data/mock/mock_tv_series_data.dart';

class HistoryEntry {
  final String title;
  final String imageUrl;
  final String date;
  final double progress;
  final bool isMovie;

  HistoryEntry({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.progress,
    this.isMovie = true,
  });
}

class StreamingHistoryScreen extends StatelessWidget {
  const StreamingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistoryEntry> history = [
      HistoryEntry(
        title: MockMovieData.allMovies[0].title,
        imageUrl: MockMovieData.allMovies[0].posterPath,
        date: "Today, 10:45 AM",
        progress: 0.85,
      ),
      HistoryEntry(
        title: mockTVSeriesData[0].title,
        imageUrl: mockTVSeriesData[0].posterUrl,
        date: "Yesterday, 09:30 PM",
        progress: 0.45,
        isMovie: false,
      ),
      HistoryEntry(
        title: MockMovieData.allMovies[1].title,
        imageUrl: MockMovieData.allMovies[1].posterPath,
        date: "Yesterday, 02:15 PM",
        progress: 1.0,
      ),
      HistoryEntry(
        title: MockMovieData.allMovies[2].title,
        imageUrl: MockMovieData.allMovies[2].posterPath,
        date: "Oct 12, 2026",
        progress: 1.0,
      ),
      HistoryEntry(
        title: mockTVSeriesData[1].title,
        imageUrl: mockTVSeriesData[1].posterUrl,
        date: "Oct 10, 2026",
        progress: 0.2,
        isMovie: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Streaming History",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Clear All",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: LiquidBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return _buildHistoryCard(history[index]);
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(HistoryEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 20,
        blur: 10,
        opacity: 0.05,
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: entry.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            entry.isMovie
                                ? Icons.movie_rounded
                                : Icons.tv_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.isMovie ? "MOVIE" : "SERIES",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.date,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: entry.progress,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                entry.progress == 1.0
                                    ? Colors.greenAccent
                                    : AppColors.primary,
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.progress == 1.0
                                ? "Completed"
                                : "${(entry.progress * 100).toInt()}% watched",
                            style: TextStyle(
                              color: (entry.progress == 1.0
                                      ? Colors.greenAccent
                                      : Colors.white)
                                  .withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

