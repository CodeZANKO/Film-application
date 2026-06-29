import '../../domain/entities/media.dart';
import '../../domain/repositories/content_repository.dart';

/// [MockContentRepository] provides hardcoded data for testing and development.
/// 
/// This implementation allows the app to run without an internet connection
/// or an API key, providing a consistent environment for UI design.
class MockContentRepository implements ContentRepository {
  
  // Simulated delay to mimic network latency
  final Duration _mockDelay = const Duration(milliseconds: 800);

  @override
  Future<List<Media>> getTrendingMovies() async {
    // 1. Simulate network delay
    await Future.delayed(_mockDelay);

    // 2. Return hardcoded list of movies
    return [
      const Media(
        id: 1,
        title: "Inception",
        overview: "A thief who steals corporate secrets through the use of dream-sharing technology...",
        posterPath: "/edv3bs1_mock_inception.jpg",
        backdropPath: "/inception_backdrop.jpg",
        voteAverage: 8.8,
        releaseDate: "2010-07-16",
      ),
      const Media(
        id: 2,
        title: "The Dark Knight",
        overview: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham...",
        posterPath: "/dark_knight_mock.jpg",
        backdropPath: "/dark_knight_backdrop.jpg",
        voteAverage: 9.0,
        releaseDate: "2008-07-18",
      ),
      const Media(
        id: 3,
        title: "Interstellar",
        overview: "The adventures of a group of explorers who make use of a newly discovered wormhole...",
        posterPath: "/interstellar_mock.jpg",
        backdropPath: "/interstellar_backdrop.jpg",
        voteAverage: 8.6,
        releaseDate: "2014-11-07",
      ),
    ];
  }

  @override
  Future<List<Media>> getPopularTVSeries() async {
    // 1. Simulate network delay
    await Future.delayed(_mockDelay);

    // 2. Return hardcoded list of TV shows
    return [
      const Media(
        id: 101,
        title: "Breaking Bad",
        overview: "A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing methamphetamine...",
        posterPath: "/breaking_bad_mock.jpg",
        backdropPath: "/breaking_bad_backdrop.jpg",
        voteAverage: 9.5,
        releaseDate: "2008-01-20",
        isTVSeries: true,
      ),
      const Media(
        id: 102,
        title: "Stranger Things",
        overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments...",
        posterPath: "/stranger_things_mock.jpg",
        backdropPath: "/stranger_things_backdrop.jpg",
        voteAverage: 8.7,
        releaseDate: "2016-07-15",
        isTVSeries: true,
      ),
    ];
  }

  @override
  Future<Media> getMediaDetails(int id, {bool isTVSeries = false}) async {
    await Future.delayed(_mockDelay);
    
    // In a real mock, you'd find by ID, but for this demo:
    return Media(
      id: id,
      title: isTVSeries ? "Mock TV Series" : "Mock Movie",
      overview: "This is a detailed overview of the selected mock media item.",
      posterPath: "/mock_poster.jpg",
      backdropPath: "/mock_backdrop.jpg",
      voteAverage: 7.5,
      releaseDate: "2023-01-01",
      isTVSeries: isTVSeries,
    );
  }
}

