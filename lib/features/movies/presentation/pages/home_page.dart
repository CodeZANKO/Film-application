import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/movie_shimmer.dart';
import 'package:film_app/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/navigation_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/presentation/pages/movie_details_screen.dart';
import 'package:film_app/features/movies/presentation/pages/movie_list_page.dart';
import 'package:film_app/features/movies/presentation/pages/video_player_page.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/features/tv_series/presentation/bloc/tv_series_bloc.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart' as tv;
import 'package:film_app/features/tv_series/presentation/pages/tv_series_details_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is MoviesLoading) {
          return _buildLoadingState();
        } else if (state is MoviesLoaded) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildFeaturedCarousel(state.trendingMovies),
                    const SizedBox(height: 30),
                    _buildSectionHeader(
                        context, "Popular Movies", state.popularMovies),
                    _buildMovieHorizontalList(context, state.popularMovies),
                    const SizedBox(height: 30),
                    _buildSectionHeader(
                        context, "New Films", state.trendingMovies),
                    _buildMovieHorizontalList(context, state.trendingMovies),
                    const SizedBox(height: 30),
                    BlocBuilder<TVSeriesBloc, TVSeriesState>(
                      builder: (context, seriesState) {
                        if (seriesState is TVSeriesLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Popular Series",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<NavigationBloc>()
                                            .getNavBarItem(NavbarItem.tvSeries);
                                      },
                                      child: const Text("See All",
                                          style: TextStyle(
                                              color: AppColors.primary)),
                                    ),
                                  ],
                                ),
                              ),
                              _buildSeriesHorizontalList(
                                  context, seriesState.series),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildSectionHeader(
                        context, "Continue Watching", state.popularMovies),
                    _buildContinueWatchingList(context),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          );
        } else if (state is MoviesError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
        child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text(
        "FILM APP",
        style: GoogleFonts.bebasNeue(
          fontSize: 32,
          color: AppColors.primary,
          letterSpacing: 2,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () =>
              context.read<NavigationBloc>().getNavBarItem(NavbarItem.profile),
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surface,
              backgroundImage: CachedNetworkImageProvider(
                  'https://t3.ftcdn.net/jpg/01/73/77/00/360_F_173770068_LRQyNUZQn9WtQyJoJsOEwK8qwBzypBm0.jpg'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCarousel(List<Movie> movies) {
    return CarouselSlider.builder(
      itemCount: movies.length,
      options: CarouselOptions(
        height: 450,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = movies[index];
        final imageUrl = movie.posterPath;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movie: MockMovieData.getExtendedMovie(movie as dynamic),
                ),
              ),
            );
          },
          child: Hero(
            tag: 'movie_${movie.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GlassContainer(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(20),
                      opacity: 0.15,
                      blur: 10,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(movie.releaseDate.split('-').first,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.7))),
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
      },
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieListPage(title: title, movies: movies),
                ),
              );
            },
            child: const Text("See All",
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieHorizontalList(BuildContext context, List<Movie> movies) {
    return SizedBox(
      height: 220,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieHorizontalItem(movie: movie, index: index);
          },
        ),
      ),
    );
  }

  Widget _buildSeriesHorizontalList(BuildContext context, List<tv.TVSeries> seriesList) {
    return SizedBox(
      height: 220,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: seriesList.length,
          itemBuilder: (context, index) {
            final series = seriesList[index];
            return _SeriesHorizontalItem(series: series, index: index);
          },
        ),
      ),
    );
  }

  Widget _buildContinueWatchingList(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (context, index) {
            final imageUrls = [
              'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=500',
              'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?q=80&w=500',
              'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?q=80&w=500',
            ];

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPlayerPage(
                      videoUrl:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      title: 'Continue Watching',
                    ),
                  ),
                );
              },
              child: Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls[index],
                        width: 280,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16)),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.6,
                          child: Container(color: AppColors.primary),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MovieHorizontalItem extends StatelessWidget {
  final Movie movie;
  final int index;

  const _MovieHorizontalItem({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {
    final staggeredDelay = (index % 10) * 50;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + staggeredDelay),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(
                movie: MockMovieData.getExtendedMovie(movie as dynamic),
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
                  borderRadius: 20,
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const MovieShimmer(width: 140, height: 180),
                      errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.error)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeriesHorizontalItem extends StatelessWidget {
  final tv.TVSeries series;
  final int index;

  const _SeriesHorizontalItem({required this.series, required this.index});

  @override
  Widget build(BuildContext context) {
    final staggeredDelay = (index % 10) * 50;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + staggeredDelay),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TVSeriesDetailsScreen(series: series),
            ),
          );
        },
        child: Container(
          width: 150,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'series_poster_${series.id}',
                      child: GlassContainer(
                        borderRadius: 20,
                        padding: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: series.posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) =>
                                const MovieShimmer(width: 140, height: 180),
                            errorWidget: (context, url, error) => Container(
                                color: AppColors.surface,
                                child: const Icon(Icons.error)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GlassContainer(
                        borderRadius: 8,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        opacity: 0.2,
                        blur: 5,
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              series.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                series.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                '${series.totalSeasons} Seasons',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

