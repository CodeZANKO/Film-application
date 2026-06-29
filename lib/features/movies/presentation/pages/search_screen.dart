import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/movies/presentation/bloc/search_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/entities/actor.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/movies/presentation/pages/movie_details_screen.dart';
import 'package:film_app/features/movies/presentation/pages/actor_detail_screen.dart';
import 'package:film_app/features/tv_series/presentation/pages/tv_series_details_screen.dart';
import 'package:film_app/core/di/injection_container.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:film_app/core/widgets/glass_container.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSearchField(context),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Builder(builder: (context) {
      return GlassContainer(
        borderRadius: 16,
        blur: 10,
        opacity: 0.1,
        child: TextField(
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search movies, series, actors...",
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(Icons.search_rounded,
                color: Colors.white.withValues(alpha: 0.7)),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      );
    });
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is SearchError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        } else if (state is SearchLoaded) {
          if (state.isEmpty) {
            return Center(
                child: Text("No results found.",
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.5))));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              if (state.movies.isNotEmpty) ...[
                _buildSectionTitle("Movies"),
                ...state.movies.map((m) => MovieSearchTile(movie: m)),
              ],
              if (state.tvSeries.isNotEmpty) ...[
                _buildSectionTitle("TV Series"),
                ...state.tvSeries.map((s) => SeriesSearchTile(series: s)),
              ],
              if (state.actors.isNotEmpty) ...[
                _buildSectionTitle("Actors"),
                _buildActorsSection(state.actors),
              ],
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore_outlined, 
                   size: 80, 
                   color: Colors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 16),
              Text(
                "Find your favorite content",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildActorsSection(List<Actor> actors) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return ActorSearchTile(actor: actor);
        },
      ),
    );
  }
}

class MovieSearchTile extends StatelessWidget {
  final Movie movie;
  const MovieSearchTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassContainer(
        borderRadius: 20,
        blur: 5,
        opacity: 0.05,
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
                  width: 80,
                  height: 110,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 110,
                    color: AppColors.surface,
                    child: const Icon(Icons.error_outline_rounded,
                        color: Colors.white30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genres.join(" • "),
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          movie.releaseDate.split('-').first,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SeriesSearchTile extends StatelessWidget {
  final TVSeries series;
  const SeriesSearchTile({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassContainer(
        borderRadius: 20,
        blur: 5,
        opacity: 0.05,
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
                  width: 80,
                  height: 110,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 110,
                    color: AppColors.surface,
                    child: const Icon(Icons.error_outline_rounded,
                        color: Colors.white30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${series.genre} • ${series.totalSeasons} Seasons',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              series.rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          series.releaseYear.toString(),
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActorSearchTile extends StatelessWidget {
  final Actor actor;
  const ActorSearchTile({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActorDetailScreen(actor: actor),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: CachedNetworkImageProvider(actor.profilePath),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              actor.name.split(' ').first,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}


