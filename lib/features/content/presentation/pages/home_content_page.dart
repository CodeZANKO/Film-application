import 'package:flutter/material.dart';
import 'package:film_app/core/di/injection_container.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/content_repository.dart';

/// [HomeContentPage] demonstrates how the UI interacts with the [ContentRepository].
/// 
/// The UI is completely agnostic of whether data is coming from [MockContentRepository]
/// or [RemoteContentRepository]. It only cares about the abstract contract.
class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  // We obtain the repository from our Service Locator (GetIt)
  final ContentRepository _repository = sl<ContentRepository>();

  // Lists to hold our fetched data
  List<Media> _trendingMovies = [];
  List<Media> _popularSeries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  /// Loads content from the repository.
  /// 
  /// This method demonstrates the clean separation of concerns.
  Future<void> _loadContent() async {
    setState(() => _isLoading = true);
    try {
      // Fetch data in parallel for efficiency
      final results = await Future.wait([
        _repository.getTrendingMovies(),
        _repository.getPopularTVSeries(),
      ]);

      setState(() {
        _trendingMovies = results[0];
        _popularSeries = results[1];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium Streaming"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContent,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Trending Movies", _trendingMovies),
                  const SizedBox(height: 24),
                  _buildSection("Popular TV Series", _popularSeries),
                ],
              ),
            ),
    );
  }

  /// Helper widget to build horizontal scrolling sections.
  Widget _buildSection(String title, List<Media> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildMediaCard(item);
            },
          ),
        ),
      ],
    );
  }

  /// Helper widget for individual media cards.
  Widget _buildMediaCard(Media item) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder for poster image
          const Icon(Icons.movie, size: 50, color: Colors.grey),
          
          // Gradient overlay for text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

