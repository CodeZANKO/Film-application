import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/domain/entities/actor.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/movies/presentation/pages/movie_details_screen.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor actor;

  const ActorDetailScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    final actorMovies = MockMovieData.allMovies
        .where((movie) => actor.movieIds.contains(movie.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIdentitySection(),
                    const SizedBox(height: 32),
                    _buildBiographySection(),
                    const SizedBox(height: 32),
                    if (actorMovies.isNotEmpty) ...[
                      const Text(
                        "Known For",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      _buildMoviesList(context, actorMovies),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'actor_${actor.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: actor.profilePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.5),
                      AppColors.background,
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

  Widget _buildIdentitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          actor.name,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.cake_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(actor.birthDate, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                actor.placeOfBirth,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBiographySection() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Biography",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            actor.biography,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(BuildContext context, List<Movie> movies) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
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
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GlassContainer(
                      borderRadius: 16,
                      padding: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


