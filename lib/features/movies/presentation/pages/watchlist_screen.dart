import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/presentation/bloc/watchlist_bloc.dart';
import 'package:film_app/features/movies/presentation/pages/movie_details_screen.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/tv_series/presentation/pages/tv_series_details_screen.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("My Watchlist",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "Movies"),
              Tab(text: "Series"),
            ],
          ),
        ),
        body: LiquidBackground(
          child: TabBarView(
            children: [
              _MoviesWatchlistTab(),
              _SeriesWatchlistTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoviesWatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state.movies.isEmpty) {
          return const _EmptyWatchlist(message: "Your movie watchlist is empty");
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: state.movies.length,
          itemBuilder: (context, index) {
            final movie = state.movies[index];
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
                        builder: (context) => MovieDetailsScreen(
                          movie: MockMovieData.getExtendedMovie(movie),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterPath,
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.white10),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(movie.releaseDate.split('-')[0],
                                style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.primary),
                        onPressed: () => context
                            .read<WatchlistBloc>()
                            .add(ToggleWatchlist(movie)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SeriesWatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesWatchlistBloc, SeriesWatchlistState>(
      builder: (context, state) {
        if (state.series.isEmpty) {
          return const _EmptyWatchlist(message: "Your series watchlist is empty");
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        builder: (context) =>
                            TVSeriesDetailsScreen(series: series),
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
                          placeholder: (context, url) => Container(color: Colors.white10),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(series.title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text('${series.releaseYear} • ${series.genre}',
                                style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.primary),
                        onPressed: () => context
                            .read<SeriesWatchlistBloc>()
                            .add(ToggleSeriesWatchlist(series)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  final String message;
  const _EmptyWatchlist({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded,
              size: 80, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 18)),
        ],
      ),
    );
  }
}

