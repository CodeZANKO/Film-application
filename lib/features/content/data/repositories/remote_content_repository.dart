import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/content_repository.dart';
import '../models/media_model.dart';

/// [RemoteContentRepository] fetches live data from the TMDB API.
/// 
/// This implementation uses the [Dio] package for HTTP requests and
/// leverages [AppConfig] for the API key and base URL.
class RemoteContentRepository implements ContentRepository {
  final Dio _dio;

  /// Constructor requires a [Dio] instance, typically provided via DI.
  RemoteContentRepository(this._dio);

  @override
  Future<List<Media>> getTrendingMovies() async {
    try {
      // 1. Execute GET request to trending movies endpoint
      final response = await _dio.get(
        "${AppConfig.baseUrl}/trending/movie/day",
        queryParameters: {'api_key': AppConfig.tmdbApiKey},
      );

      // 2. Extract results list from response data
      final List results = response.data['results'];

      // 3. Map JSON objects to MediaModel and return as Media entities
      return results.map((json) => MediaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // Step-by-step error handling could be expanded here
      throw Exception("Failed to load trending movies: ${e.message}");
    }
  }

  @override
  Future<List<Media>> getPopularTVSeries() async {
    try {
      // 1. Execute GET request to popular TV series endpoint
      final response = await _dio.get(
        "${AppConfig.baseUrl}/tv/popular",
        queryParameters: {'api_key': AppConfig.tmdbApiKey},
      );

      // 2. Map JSON objects ensuring 'isTVSeries' is true for proper field mapping
      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json, isTVSeries: true)).toList();
    } on DioException catch (e) {
      throw Exception("Failed to load popular TV series: ${e.message}");
    }
  }

  @override
  Future<Media> getMediaDetails(int id, {bool isTVSeries = false}) async {
    final type = isTVSeries ? 'tv' : 'movie';
    try {
      final response = await _dio.get(
        "${AppConfig.baseUrl}/$type/$id",
        queryParameters: {'api_key': AppConfig.tmdbApiKey},
      );

      return MediaModel.fromJson(response.data, isTVSeries: isTVSeries);
    } on DioException catch (e) {
      throw Exception("Failed to load media details: ${e.message}");
    }
  }
}

