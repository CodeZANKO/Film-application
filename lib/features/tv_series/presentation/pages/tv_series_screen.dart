import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/tv_series/presentation/bloc/tv_series_bloc.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'tv_series_details_screen.dart';

class TVSeriesScreen extends StatefulWidget {
  const TVSeriesScreen({super.key});

  @override
  State<TVSeriesScreen> createState() => _TVSeriesScreenState();
}

class _TVSeriesScreenState extends State<TVSeriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  double _minRating = 0;
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<TVSeriesBloc, TVSeriesState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context),
                _buildSearchBar(context),
                _buildActiveFilters(context),
                Expanded(
                  child: _buildContent(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  "Series",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  "Discover the best TV shows",
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search series or genres...",
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

  Widget _buildActiveFilters(BuildContext context) {
    if (_minRating == 0 && _selectedGenre == null) return const SizedBox.shrink();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (_selectedGenre != null)
            _buildFilterChip(
              context,
              "Genre: $_selectedGenre",
              onDeleted: () => setState(() => _selectedGenre = null),
            ),
          if (_minRating > 0)
            _buildFilterChip(
              context,
              "Rating: ${_minRating.toStringAsFixed(1)}+",
              onDeleted: () => setState(() => _minRating = 0),
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

  Widget _buildContent(TVSeriesState state) {
    if (state is TVSeriesLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    } else if (state is TVSeriesLoaded) {
      final filteredSeries = state.series.where((series) {
        final matchesSearch = series.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            series.genre.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesGenre = _selectedGenre == null || series.genre == _selectedGenre;
        final matchesRating = series.rating >= _minRating;
        return matchesSearch && matchesGenre && matchesRating;
      }).toList();

      if (filteredSeries.isEmpty) {
        return const Center(
          child: Text(
            "No series found",
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
        ),
        itemCount: filteredSeries.length,
        itemBuilder: (context, index) {
          final series = filteredSeries[index];
          return _SeriesCard(series: series);
        },
      );
    } else if (state is TVSeriesError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
    }
    return const SizedBox.shrink();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SeriesFilterSheet(
        initialGenre: _selectedGenre,
        initialRating: _minRating,
        onApplied: (genre, rating) {
          setState(() {
            _selectedGenre = genre;
            _minRating = rating;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SeriesFilterSheet extends StatefulWidget {
  final String? initialGenre;
  final double initialRating;
  final Function(String?, double) onApplied;

  const _SeriesFilterSheet({
    required this.initialGenre,
    required this.initialRating,
    required this.onApplied,
  });

  @override
  State<_SeriesFilterSheet> createState() => _SeriesFilterSheetState();
}

class _SeriesFilterSheetState extends State<_SeriesFilterSheet> {
  late String? selectedGenre;
  late double minRating;
  final List<String> genres = [
    "Action",
    "Drama",
    "Crime",
    "Sci-Fi",
    "Adventure",
    "Comedy",
    "Fantasy"
  ];

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.initialGenre;
    minRating = widget.initialRating;
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
                  setState(() {
                    selectedGenre = null;
                    minRating = 0;
                  });
                },
                child: const Text("Reset",
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text("Genres",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: genres.map((genre) {
              final isSelected = selectedGenre == genre;
              return ChoiceChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedGenre = selected ? genre : null;
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
            divisions: 10,
            activeColor: AppColors.primary,
            inactiveColor: Colors.white.withValues(alpha: 0.1),
            onChanged: (value) => setState(() => minRating = value),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              widget.onApplied(selectedGenre, minRating);
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

class _SeriesCard extends StatelessWidget {
  final TVSeries series;
  const _SeriesCard({required this.series});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TVSeriesDetailsScreen(series: series),
        ),
      ),
      child: GlassContainer(
        borderRadius: 24,
        padding: EdgeInsets.zero,
        opacity: 0.05,
        blur: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'series_poster_${series.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: CachedNetworkImage(
                        imageUrl: series.posterUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.broken_image, color: Colors.white24),
                        ),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GlassContainer(
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      opacity: 0.2,
                      blur: 8,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            series.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Watchlist Button
                  Positioned(
                    top: 12,
                    left: 12,
                    child: BlocBuilder<SeriesWatchlistBloc, SeriesWatchlistState>(
                      builder: (context, state) {
                        final isInWatchlist = state.isInWatchlist(series.id);
                        return GlassContainer(
                          borderRadius: 12,
                          padding: const EdgeInsets.all(4),
                          opacity: 0.2,
                          blur: 8,
                          child: GestureDetector(
                            onTap: () {
                              context.read<SeriesWatchlistBloc>().add(ToggleSeriesWatchlist(series));
                            },
                            child: Icon(
                              isInWatchlist ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isInWatchlist ? AppColors.primary : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Seasons Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        '${series.totalSeasons} SEASONS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    series.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${series.releaseYear} • ${series.genre}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

