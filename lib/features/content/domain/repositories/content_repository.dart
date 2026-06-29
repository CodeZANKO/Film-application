import '../entities/media.dart';

/// [ContentRepository] defines the contract for fetching media content.
/// 
/// This interface follows the Repository Pattern, abstracting the data source
/// details from the rest of the application.
abstract class ContentRepository {
  /// Fetches a list of currently trending movies from the data source.
  /// 
  /// Returns a [Future] that resolves to a [List] of [Media] entities.
  Future<List<Media>> getTrendingMovies();

  /// Fetches a list of popular TV series from the data source.
  /// 
  /// Returns a [Future] that resolves to a [List] of [Media] entities.
  Future<List<Media>> getPopularTVSeries();

  /// Fetches details for a specific media item by its [id].
  /// 
  /// [isTVSeries] indicates whether to search in TV or Movie database.
  Future<Media> getMediaDetails(int id, {bool isTVSeries = false});
}

