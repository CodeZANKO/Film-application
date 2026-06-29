import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/presentation/bloc/explore_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/features/movies/presentation/pages/movie_details_screen.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SafeArea(
          child: BlocBuilder<ExploreBloc, ExploreState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(context, state),
                  _buildSearchBar(context, state),
                  _buildCategoryRibbon(context, state),
                  _buildActiveFilters(context, state),
                  Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary))
                        : _buildMovieContent(context, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ExploreState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  "Showing ${state.filteredMovies.length} movies",
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlassContainer(
            borderRadius: 16,
            blur: 10,
            opacity: 0.1,
            child: IconButton(
              icon: Icon(
                state.viewType == ExploreViewType.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                color: Colors.white,
              ),
              onPressed: () =>
                  context.read<ExploreBloc>().add(ExploreToggleView()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ExploreState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              borderRadius: 16,
              blur: 10,
              opacity: 0.1,
              child: TextField(
                onChanged: (query) {
                  context.read<ExploreBloc>().add(ExploreSearchQueryChanged(query));
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search movies...",
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.7)),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GlassContainer(
            borderRadius: 16,
            blur: 10,
            opacity: 0.1,
            child: IconButton(
              icon: const Icon(Icons.tune_rounded, color: Colors.white),
              onPressed: () => _showFilterSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRibbon(BuildContext context, ExploreState state) {
    final List<String> categories = [
      "Action",
      "Adventure",
      "Sci-Fi",
      "Drama",
      "Crime",
      "Animation",
      "History"
    ];

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = state.selectedGenres.contains(category);

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => context
                  .read<ExploreBloc>()
                  .add(ExploreGenreToggled(category)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context, ExploreState state) {
    // We only show rating here now as genres are in the ribbon
    if (state.minRating == 0) return const SizedBox.shrink();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip(
            context,
            "Rating: ${state.minRating.toStringAsFixed(1)}+",
            onDeleted: () => context
                .read<ExploreBloc>()
                .add(ExploreFilterRemoved(isRating: true)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      {required VoidCallback onDeleted}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GlassContainer(
        borderRadius: 10,
        blur: 5,
        opacity: 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDeleted,
              child: const Icon(Icons.close_rounded,
                  size: 14, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieContent(BuildContext context, ExploreState state) {
    if (state.filteredMovies.isEmpty) {
      return Center(
        child: Text("No movies match your filters",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
      );
    }

    if (state.viewType == ExploreViewType.grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: state.filteredMovies.length,
        itemBuilder: (context, index) => _AnimatedItem(
          key: ValueKey('${state.viewType}_${state.filteredMovies[index].id}'),
          index: index,
          child: _MovieGridTile(movie: state.filteredMovies[index]),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: state.filteredMovies.length,
        itemBuilder: (context, index) => _AnimatedItem(
          key: ValueKey('${state.viewType}_${state.filteredMovies[index].id}'),
          index: index,
          child: _MovieListTile(movie: state.filteredMovies[index]),
        ),
      );
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ExploreBloc>(),
        child: const _FilterSheet(),
      ),
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedItem({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index % 10 * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _MovieGridTile extends StatelessWidget {
  final Movie movie;
  const _MovieGridTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(
                    movie: MockMovieData.getExtendedMovie(movie),
                  ))),
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(movie.voteAverage.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
              Text(movie.releaseDate.split('-').first,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MovieListTile extends StatelessWidget {
  final Movie movie;
  const _MovieListTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(
                        movie: MockMovieData.getExtendedMovie(movie),
                      ))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                    imageUrl: movie.posterPath,
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover),
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
                    Text(movie.genres.join(" • "),
                        style: TextStyle(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                            height: 1.4)),
                    const SizedBox(height: 12),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(movie.voteAverage.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(movie.releaseDate.split('-').first,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4))),
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

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late List<String> selectedGenres;
  late double minRating;
  final List<String> allGenres = [
    "Action",
    "Adventure",
    "Sci-Fi",
    "Drama",
    "Crime",
    "Animation",
    "History"
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<ExploreBloc>().state;
    selectedGenres = List.from(state.selectedGenres);
    minRating = state.minRating;
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 40,
      blur: 20,
      opacity: 0.15,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filters",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextButton(
                onPressed: () {
                  context.read<ExploreBloc>().add(ExploreFiltersReset());
                  Navigator.pop(context);
                },
                child: const Text("Reset",
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text("Categories",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: allGenres.map((genre) {
              final isSelected = selectedGenres.contains(genre);
              return FilterChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedGenres.add(genre);
                    } else {
                      selectedGenres.remove(genre);
                    }
                  });
                },
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Minimum Rating",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70)),
              Text(minRating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: minRating,
            min: 0,
            max: 10,
            divisions: 100,
            activeColor: AppColors.primary,
            inactiveColor: Colors.white.withValues(alpha: 0.1),
            onChanged: (value) => setState(() => minRating = value),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<ExploreBloc>().add(ExploreFiltersApplied(
                  selectedGenres: selectedGenres, minRating: minRating));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text("Apply Filters",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

