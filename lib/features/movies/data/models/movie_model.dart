import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/core/constants/api_constants.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String posterPath = json['poster_path'] ?? '';
    if (posterPath.isNotEmpty && !posterPath.startsWith('http')) {
      posterPath = ApiConstants.baseImageUrl + posterPath;
    }

    String backdropPath = json['backdrop_path'] ?? '';
    if (backdropPath.isNotEmpty && !backdropPath.startsWith('http')) {
      backdropPath = ApiConstants.baseBackdropUrl + backdropPath;
    }

    List<String> genresList = [];
    if (json['genres'] != null) {
      genresList = List<String>.from(json['genres'].map((x) => x is Map ? x['name'] : x.toString()));
    } else if (json['genre_ids'] != null) {
      // In a real app, you'd map these IDs to names using a cached genre list.
      // For now, we'll store them as string representations of IDs or empty.
      genresList = List<String>.from(json['genre_ids'].map((x) => x.toString()));
    }

    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: genresList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genres': genres,
    };
  }
}

