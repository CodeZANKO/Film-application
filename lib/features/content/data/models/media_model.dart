import '../../domain/entities/media.dart';

/// [MediaModel] extends [Media] to add JSON serialization capabilities.
/// 
/// This class is used in the Data layer to map raw JSON responses from TMDB
/// into our domain-level [Media] entities.
class MediaModel extends Media {
  const MediaModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    super.isTVSeries = false,
  });

  /// Factory constructor to create a [MediaModel] from a JSON map.
  /// 
  /// Handles field mapping (e.g., 'name' for TV shows vs 'title' for movies).
  factory MediaModel.fromJson(Map<String, dynamic> json, {bool isTVSeries = false}) {
    return MediaModel(
      id: json['id'] ?? 0,
      // TMDB uses 'name' for TV series and 'title' for movies
      title: (isTVSeries ? json['name'] : json['title']) ?? "Unknown",
      overview: json['overview'] ?? "",
      posterPath: json['poster_path'] ?? "",
      backdropPath: json['backdrop_path'] ?? "",
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      // TMDB uses 'first_air_date' for TV series and 'release_date' for movies
      releaseDate: (isTVSeries ? json['first_air_date'] : json['release_date']) ?? "",
      isTVSeries: isTVSeries,
    );
  }

  /// Converts the [MediaModel] back into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
    };
  }
}

