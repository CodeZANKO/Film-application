import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/movies/presentation/bloc/watchlist_bloc.dart';
import 'package:film_app/features/movies/presentation/pages/video_player_page.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/presentation/bloc/downloads_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieExtendedModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> with SingleTickerProviderStateMixin {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  Timer? _downloadTimer;
  YoutubePlayerController? _youtubePlayerController;
  bool _isTrailerPlaying = false;

  @override
  void dispose() {
    _downloadTimer?.cancel();
    _youtubePlayerController?.close();
    super.dispose();
  }

  void _playTrailer() {
    setState(() {
      _youtubePlayerController = YoutubePlayerController.fromVideoId(
        videoId: widget.movie.youtubeVideoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          enableJavaScript: true,
        ),
      );
      _isTrailerPlaying = true;
    });
  }

  void _startDownload() {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    const duration = Duration(seconds: 4);
    const interval = Duration(milliseconds: 50);
    final totalSteps = duration.inMilliseconds / interval.inMilliseconds;
    var currentStep = 0;

    _downloadTimer = Timer.periodic(interval, (timer) {
      currentStep++;
      setState(() {
        _downloadProgress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _isDownloading = false;
        });
        context.read<DownloadsBloc>().add(AddToDownloads(widget.movie));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${widget.movie.title} downloaded successfully!"),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackdrop(context),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(context),
                    const SizedBox(height: 24),
                    _buildMetadata(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                    const SizedBox(height: 32),
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          Text(widget.movie.overview, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16, height: 1.6)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text("Official Trailer", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildTrailerCard(),
                    const SizedBox(height: 32),
                    const Text("Cast", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildCastList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailerCard() {
    if (_isTrailerPlaying && _youtubePlayerController != null) {
      return YoutubePlayerControllerProvider(
        controller: _youtubePlayerController!,
        child: GlassContainer(
          borderRadius: 24,
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: YoutubePlayer(
              controller: _youtubePlayerController!,
              aspectRatio: 16 / 9,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _playTrailer,
      child: GlassContainer(
        borderRadius: 24,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: "https://img.youtube.com/vi/${widget.movie.youtubeVideoId}/maxresdefault.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: widget.movie.backdropPath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black38,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ),
            ),
            const Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                "PLAY TRAILER INLINE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildWatchNowButton(context),
        const SizedBox(height: 16),
        BlocBuilder<DownloadsBloc, DownloadsState>(
          builder: (context, state) {
            final isDownloaded = state.downloadedMovies.any((m) => m.id == widget.movie.id);
            
            if (isDownloaded) {
              return GlassContainer(
                borderRadius: 20,
                blur: 10,
                opacity: 0.1,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text("DOWNLOADED", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              );
            }

            if (_isDownloading) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      minHeight: 12,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Downloading... ${(_downloadProgress * 100).toInt()}%",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }

            return GlassContainer(
              borderRadius: 20,
              blur: 10,
              opacity: 0.1,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startDownload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_download_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text("DOWNLOAD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWatchNowButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(videoUrl: widget.movie.videoUrl, title: widget.movie.title),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Text("Watch Now", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(widget.movie.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            final isInWatchlist = state.movies.any((m) => m.id == widget.movie.id);
            return GlassContainer(
              borderRadius: 16,
              blur: 5,
              opacity: 0.1,
              child: IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: () => context.read<WatchlistBloc>().add(ToggleWatchlist(widget.movie)),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetadata() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 4),
            Text(widget.movie.voteAverage.toString(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Text("${widget.movie.releaseYear}  •  ${widget.movie.duration}", style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16)),
      ],
    );
  }

  Widget _buildCastList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.movie.cast.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=actor'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(widget.movie.cast[index], style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackdrop(BuildContext context) {
    return Stack(
      children: [
        // Backdrop Background
        CachedNetworkImage(
          imageUrl: widget.movie.backdropPath,
          height: 500,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        
        // Gradient Overlay for depth and text readability
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                AppColors.background.withValues(alpha: 0.8),
                AppColors.background,
              ],
            ),
          ),
        ),

        // Foreground Content: Poster and Back Button
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassContainer(
                      borderRadius: 15,
                      blur: 10,
                      opacity: 0.2,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // The Poster Image in the center of the header
              Center(
                child: Hero(
                  tag: 'movie_${widget.movie.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.movie.posterPath,
                        height: 300,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


