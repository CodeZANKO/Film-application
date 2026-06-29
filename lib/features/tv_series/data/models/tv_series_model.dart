import 'package:film_app/features/tv_series/domain/entities/tv_series.dart' as entity;

class TVSeries extends entity.TVSeries {
  const TVSeries({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterUrl,
    required super.backdropUrl,
    required super.rating,
    required super.genre,
    required super.releaseYear,
    required super.totalSeasons,
    required super.seasons,
    super.cast,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'rating': rating,
      'genre': genre,
      'releaseYear': releaseYear,
      'totalSeasons': totalSeasons,
      'seasons': seasons.map((x) => (x as Season).toJson()).toList(),
      'cast': cast.map((x) => (x as SeriesCast).toJson()).toList(),
    };
  }

  factory TVSeries.fromJson(Map<String, dynamic> json) {
    return TVSeries(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      rating: json['rating'].toDouble(),
      genre: json['genre'],
      releaseYear: json['releaseYear'],
      totalSeasons: json['totalSeasons'],
      seasons: List<Season>.from(json['seasons'].map((x) => Season.fromJson(x))),
      cast: json['cast'] != null 
          ? List<SeriesCast>.from(json['cast'].map((x) => SeriesCast.fromJson(x)))
          : [],
    );
  }
}

class SeriesCast extends entity.SeriesCast {
  const SeriesCast({
    required super.id,
    required super.name,
    required super.character,
    required super.profileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profileUrl': profileUrl,
    };
  }

  factory SeriesCast.fromJson(Map<String, dynamic> json) {
    return SeriesCast(
      id: json['id'],
      name: json['name'],
      character: json['character'],
      profileUrl: json['profileUrl'],
    );
  }
}

class Season extends entity.Season {
  const Season({
    required super.seasonNumber,
    required super.episodes,
  });

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'episodes': episodes.map((x) => (x as Episode).toJson()).toList(),
    };
  }

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'],
      episodes: List<Episode>.from(json['episodes'].map((x) => Episode.fromJson(x))),
    );
  }
}

class Episode extends entity.Episode {
  const Episode({
    required super.episodeNumber,
    required super.title,
    required super.duration,
    required super.thumbnailUrl,
    required super.videoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'episodeNumber': episodeNumber,
      'title': title,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
    };
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'],
      title: json['title'],
      duration: json['duration'],
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
    );
  }
}

