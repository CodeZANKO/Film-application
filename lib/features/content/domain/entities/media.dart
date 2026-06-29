import 'package:equatable/equatable.dart';

/// [Media] represents a common structure for both Movies and TV Series.
/// 
/// This entity follows Clean Architecture principles by remaining independent
/// of any data source or framework details.
class Media extends Equatable {
  /// Unique identifier from the TMDB database.
  final int id;

  /// The title of the movie or name of the TV show.
  final String title;

  /// A brief plot summary.
  final String overview;

  /// The relative path to the poster image.
  final String posterPath;

  /// The relative path to the backdrop image.
  final String backdropPath;

  /// The average user rating (0.0 to 10.0).
  final double voteAverage;

  /// The date it was first released.
  final String releaseDate;

  /// Whether this media is a TV series or a movie.
  final bool isTVSeries;

  const Media({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.isTVSeries = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        isTVSeries,
      ];
}

