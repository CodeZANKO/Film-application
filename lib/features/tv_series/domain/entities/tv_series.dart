import 'package:equatable/equatable.dart';

class TVSeries extends Equatable {
  final String id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final String genre;
  final int releaseYear;
  final int totalSeasons;
  final List<Season> seasons;
  final List<SeriesCast> cast;

  const TVSeries({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.genre,
    required this.releaseYear,
    required this.totalSeasons,
    required this.seasons,
    this.cast = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterUrl,
        backdropUrl,
        rating,
        genre,
        releaseYear,
        totalSeasons,
        seasons,
        cast,
      ];
}

class SeriesCast extends Equatable {
  final String id;
  final String name;
  final String character;
  final String profileUrl;

  const SeriesCast({
    required this.id,
    required this.name,
    required this.character,
    required this.profileUrl,
  });

  @override
  List<Object?> get props => [id, name, character, profileUrl];
}

class Season extends Equatable {
  final int seasonNumber;
  final List<Episode> episodes;

  const Season({
    required this.seasonNumber,
    required this.episodes,
  });

  @override
  List<Object?> get props => [seasonNumber, episodes];
}

class Episode extends Equatable {
  final int episodeNumber;
  final String title;
  final String duration;
  final String thumbnailUrl;
  final String videoUrl;

  const Episode({
    required this.episodeNumber,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [episodeNumber, title, duration, thumbnailUrl, videoUrl];
}

