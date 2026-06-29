import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/movies/presentation/pages/video_player_page.dart';
import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/movies/presentation/pages/actor_detail_screen.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';

class TVSeriesDetailsScreen extends StatefulWidget {
  final TVSeries series;
  const TVSeriesDetailsScreen({super.key, required this.series});

  @override
  State<TVSeriesDetailsScreen> createState() => _TVSeriesDetailsScreenState();
}

class _TVSeriesDetailsScreenState extends State<TVSeriesDetailsScreen> {
  late Season selectedSeason;

  @override
  void initState() {
    super.initState();
    selectedSeason = widget.series.seasons.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSeriesInfo(),
                  const SizedBox(height: 24),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.series.overview,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  if (widget.series.cast.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Cast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.series.cast.length,
                        itemBuilder: (context, index) {
                          final actor = widget.series.cast[index];
                          return GestureDetector(
                            onTap: () {
                              try {
                                final fullActor = MockMovieData.allActors
                                    .firstWhere((a) => a.name == actor.name);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ActorDetailScreen(actor: fullActor),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Profile for ${actor.name} not available yet"),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        CachedNetworkImageProvider(actor.profileUrl),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    actor.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    actor.character,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildEpisodeHeader(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final episode = selectedSeason.episodes[index];
                return _EpisodeItem(episode: episode);
              },
              childCount: selectedSeason.episodes.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.26),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SeriesWatchlistBloc, SeriesWatchlistState>(
            builder: (context, state) {
              final isInWatchlist = state.isInWatchlist(widget.series.id);
              return CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.26),
                child: IconButton(
                  icon: Icon(
                    isInWatchlist ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isInWatchlist ? AppColors.primary : Colors.white,
                  ),
                  onPressed: () {
                    context.read<SeriesWatchlistBloc>().add(ToggleSeriesWatchlist(widget.series));
                  },
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.series.backdropUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.surface),
              errorWidget: (context, url, error) => Container(color: AppColors.surface),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.series.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildInfoBadge(widget.series.releaseYear.toString()),
            _buildInfoBadge(widget.series.genre),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.series.rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }

  Widget _buildEpisodeHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Episodes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildSeasonDropdown(),
      ],
    );
  }

  Widget _buildSeasonDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Season>(
          value: selectedSeason,
          dropdownColor: AppColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          items: widget.series.seasons.map((season) {
            return DropdownMenuItem<Season>(
              value: season,
              child: Text('Season ${season.seasonNumber}'),
            );
          }).toList(),
          onChanged: (season) {
            if (season != null) {
              setState(() {
                selectedSeason = season;
              });
            }
          },
        ),
      ),
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final Episode episode;
  const _EpisodeItem({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                videoUrl: episode.videoUrl,
                title: 'Ep ${episode.episodeNumber}: ${episode.title}',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: episode.thumbnailUrl,
                    width: 140,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 140,
                      height: 80,
                      color: AppColors.surface,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 140,
                      height: 80,
                      color: AppColors.surface,
                      child: const Icon(Icons.movie, color: Colors.white24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ep ${episode.episodeNumber}: ${episode.title}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    episode.duration,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
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

