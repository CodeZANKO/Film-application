import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:film_app/core/theme/app_theme.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isFullScreen = false;

  // Gesture Feedback
  bool _showSkipForward = false;
  bool _showRewind = false;
  Timer? _feedbackTimer;

  // Subtitles & Playback Settings
  String _selectedSubtitle = 'Off';
  double _playbackSpeed = 1.0;
  String _selectedQuality = 'Auto';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_videoListener);
    WakelockPlus.enable();
    _startHideTimer();
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _hideTimer?.cancel();
    _feedbackTimer?.cancel();
    WakelockPlus.disable();
    // Reset orientations when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _videoListener() {
    if (!mounted) return;
    
    // Auto-show controls if the video has ended
    if (_controller.value.isInitialized && 
        _controller.value.position >= _controller.value.duration && 
        !_controller.value.isPlaying &&
        !_showControls) {
      setState(() {
        _showControls = true;
      });
    } else {
      setState(() {});
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideTimer();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  void _onDoubleTap(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition > screenWidth * 2 / 3) {
      _skipForward();
    } else if (tapPosition < screenWidth / 3) {
      _rewind();
    }
  }

  void _skipForward() {
    _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
    _showFeedback(isForward: true);
  }

  void _rewind() {
    _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
    _showFeedback(isForward: false);
  }

  void _showFeedback({required bool isForward}) {
    _feedbackTimer?.cancel();
    setState(() {
      if (isForward) {
        _showSkipForward = true;
        _showRewind = false;
      } else {
        _showRewind = true;
        _showSkipForward = false;
      }
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showSkipForward = false;
          _showRewind = false;
        });
      }
    });
  }

  String _getSubtitleText(Duration position) {
    if (_selectedSubtitle == 'Off') return '';
    
    final seconds = position.inSeconds;
    if (seconds >= 1 && seconds < 3) {
      return _selectedSubtitle == 'English' 
          ? "Look at this beautiful bee!" 
          : _selectedSubtitle == 'Spanish'
              ? "¡Mira esta hermosa abeja!"
              : "Regardez cette belle abeille !";
    } else if (seconds >= 3 && seconds < 6) {
      return _selectedSubtitle == 'English' 
          ? "It is collecting nectar from the flower." 
          : _selectedSubtitle == 'Spanish'
              ? "Está recolectando néctar de la flor."
              : "Elle récolte le nectar de la fleur.";
    } else if (seconds >= 6 && seconds < 8) {
      return _selectedSubtitle == 'English' 
          ? "Nature is truly amazing." 
          : _selectedSubtitle == 'Spanish'
              ? "La naturaleza es realmente asombrosa."
              : "La nature est vraiment incroyable.";
    }
    return '';
  }

  void _showSettingsSheet() {
    _hideTimer?.cancel(); // Pause auto-hide while sheet is open
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Playback Settings",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text("Playback Speed", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [0.5, 1.0, 1.5, 2.0].map((speed) {
                      final isSelected = _playbackSpeed == speed;
                      return ChoiceChip(
                        label: Text("${speed}x"),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _playbackSpeed = speed;
                              _controller.setPlaybackSpeed(speed);
                            });
                            setSheetState(() {});
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white10,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Video Quality", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Auto', '1080p', '720p', '480p'].map((quality) {
                      final isSelected = _selectedQuality == quality;
                      return ChoiceChip(
                        label: Text(quality),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedQuality = quality;
                            });
                            setSheetState(() {});
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white10,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => _startHideTimer()); // Resume auto-hide on close
  }

  void _showSubtitlesSheet() {
    _hideTimer?.cancel(); // Pause auto-hide
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Subtitles",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...['Off', 'English', 'Spanish', 'French'].map((lang) {
                    final isSelected = _selectedSubtitle == lang;
                    return ListTile(
                      title: Text(
                        lang,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        setState(() {
                          _selectedSubtitle = lang;
                        });
                        setSheetState(() {});
                        Navigator.pop(context);
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => _startHideTimer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        onDoubleTapDown: _onDoubleTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_controller.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const CircularProgressIndicator(color: AppColors.primary),
            
            // Gesture Overlays
            if (_showSkipForward) _buildGestureFeedback(Icons.forward_10, "10s", isRight: true),
            if (_showRewind) _buildGestureFeedback(Icons.replay_10, "10s", isRight: false),

            // Subtitles Overlay
            if (_selectedSubtitle != 'Off' && 
                _controller.value.isInitialized && 
                _getSubtitleText(_controller.value.position).isNotEmpty)
              Positioned(
                bottom: _showControls ? 140 : 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getSubtitleText(_controller.value.position),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Premium Controls Overlay
            IgnorePointer(
              ignoring: !_showControls,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildControlsOverlay(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureFeedback(IconData icon, String text, {required bool isRight}) {
    return Align(
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isRight ? Alignment.centerLeft : Alignment.centerRight,
            end: isRight ? Alignment.centerRight : Alignment.centerLeft,
            colors: [
              Colors.transparent,
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 48),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTopBar(),
          _buildCenterControls(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.subtitles,
            color: _selectedSubtitle == 'Off' ? Colors.white : AppColors.primary,
          ),
          onPressed: _showSubtitlesSheet,
        ),
        IconButton(
          icon: Icon(
            Icons.settings,
            color: (_playbackSpeed != 1.0 || _selectedQuality != 'Auto') ? AppColors.primary : Colors.white,
          ),
          onPressed: _showSettingsSheet,
        ),
      ],
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircularIconButton(
          icon: Icons.replay_10,
          onPressed: () {
            _rewind();
            _startHideTimer();
          },
        ),
        const SizedBox(width: 40),
        _buildCircularIconButton(
          icon: _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          size: 70,
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
            _startHideTimer();
          },
        ),
        const SizedBox(width: 40),
        _buildCircularIconButton(
          icon: Icons.forward_10,
          onPressed: () {
            _skipForward();
            _startHideTimer();
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Column(
      children: [
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: AppColors.primary,
            bufferedColor: Colors.white24,
            backgroundColor: Colors.white12,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_controller.value.position),
              style: const TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Text(
                  _formatDuration(_controller.value.duration),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularIconButton({required IconData icon, double size = 50, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.6),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$minutes:$seconds";
  }
}


