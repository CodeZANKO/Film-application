import 'package:film_app/features/movies/data/models/movie_model.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/entities/actor.dart';

class MovieExtendedModel extends MovieModel {
  final List<String> cast;
  final String duration;
  final int releaseYear;
  final String videoUrl;
  final String youtubeVideoId;

  const MovieExtendedModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required this.cast,
    required this.duration,
    required this.releaseYear,
    required this.videoUrl,
    required this.youtubeVideoId,
    required super.genres,
  });

  factory MovieExtendedModel.fromMovie(
    Movie movie, {
    List<String>? cast,
    String? duration,
    int? releaseYear,
    String? videoUrl,
    String? youtubeVideoId,
  }) {
    return MovieExtendedModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      genres: movie.genres,
      cast: cast ?? ["Unknown Cast"],
      duration: duration ?? "2h 0m",
      releaseYear: releaseYear ??
          (movie.releaseDate.isNotEmpty
              ? int.tryParse(movie.releaseDate.split('-').first) ?? 2024
              : 2024),
      videoUrl: videoUrl ??
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      youtubeVideoId: youtubeVideoId ?? "Way9Dexny3w",
    );
  }
}

class MockMovieData {
  static MovieExtendedModel getExtendedMovie(Movie movie) {
    try {
      return allMovies.firstWhere((m) => m.id == movie.id);
    } catch (e) {
      return MovieExtendedModel.fromMovie(movie);
    }
  }

  static List<MovieExtendedModel> get allMovies => [
        const MovieExtendedModel(
          id: 1,
          title: "Dune: Part Two",
          overview:
              "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family.",
          posterPath:
              "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500",
          backdropPath:
              "https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=1200",
          voteAverage: 8.3,
          releaseDate: "2024-02-27",
          releaseYear: 2024,
          duration: "2h 46m",
          cast: ["Timothée Chalamet", "Zendaya", "Rebecca Ferguson"],
          videoUrl: "https://streamer.tvplus.box.ca/12043/index.m3u8",
          youtubeVideoId: "Way9Dexny3w",
          genres: ["Sci-Fi", "Adventure"],
        ),
        const MovieExtendedModel(
          id: 2,
          title: "Oppenheimer",
          overview:
              "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during World War II.",
          posterPath:
              "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?q=80&w=500",
          backdropPath:
              "https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=1200",
          voteAverage: 8.1,
          releaseDate: "2023-07-19",
          releaseYear: 2023,
          duration: "3h 0m",
          cast: ["Cillian Murphy", "Emily Blunt", "Matt Damon"],
          videoUrl: "https://streamer.tvplus.box.ca/12043/index.m3u8",
          youtubeVideoId: "uYPbbksJxIg",
          genres: ["Drama", "History"],
        ),
        const MovieExtendedModel(
          id: 3,
          title: "Spider-Man",
          overview:
              "Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence.",
          posterPath:
              "https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?q=80&w=500",
          backdropPath:
              "https://images.unsplash.com/photo-1509248961158-e54f6934749c?q=80&w=1200",
          voteAverage: 8.4,
          releaseDate: "2023-05-31",
          releaseYear: 2023,
          duration: "2h 20m",
          cast: ["Shameik Moore", "Hailee Steinfeld", "Oscar Isaac"],
          videoUrl: "https://streamer.tvplus.box.ca/12043/index.m3u8",
          youtubeVideoId: "cqGjhVJWtEg",
          genres: ["Animation", "Action"],
        ),
        const MovieExtendedModel(
          id: 4,
          title: "The Dark Knight",
          overview:
              "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
          posterPath:
              "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?q=80&w=500",
          backdropPath:
              "https://images.unsplash.com/photo-1531259683007-016a7b628fc3?q=80&w=1200",
          voteAverage: 8.5,
          releaseDate: "2008-07-16",
          releaseYear: 2008,
          duration: "2h 32m",
          cast: ["Christian Bale", "Heath Ledger", "Aaron Eckhart"],
          videoUrl: "https://youtu.be/EXeTwQWrcwY",
          youtubeVideoId: "EXeTwQWrcwY",
          genres: ["Action", "Crime", "Drama"],
        ),
      ];

  static List<Actor> get allActors => [
        const Actor(
          id: 1,
          name: "Timothée Chalamet",
          profilePath:
              "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=500",
          biography:
              "Timothée Hal Chalamet is an American and French actor. He has received various accolades, including nominations for an Academy Award, two Golden Globe Awards, and three BAFTA Film Awards.",
          birthDate: "1995-12-27",
          placeOfBirth: "New York City, New York, USA",
          movieIds: [1],
        ),
        const Actor(
          id: 2,
          name: "Zendaya",
          profilePath:
              "https://images.unsplash.com/photo-1594819047050-99defca82545?q=80&w=500",
          biography:
              "Zendaya Maree Stoermer Coleman is an American actress and singer. She has received various accolades, including two Primetime Emmy Awards and a Golden Globe Award.",
          birthDate: "1996-09-01",
          placeOfBirth: "Oakland, California, USA",
          movieIds: [1, 3],
        ),
        const Actor(
          id: 3,
          name: "Cillian Murphy",
          profilePath:
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=500",
          biography:
              "Cillian Murphy is an Irish actor. He made his professional debut in Enda Walsh's 1996 play Disco Pigs, a role he later reprised in the 2001 screen adaptation.",
          birthDate: "1976-05-25",
          placeOfBirth: "Douglas, Cork, Ireland",
          movieIds: [2, 4],
        ),
        const Actor(
          id: 4,
          name: "Christian Bale",
          profilePath:
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=500",
          biography:
              "Christian Charles Philip Bale is an English actor. Known for his versatility and physical transformations for his roles, he has been a leading man in films of several genres.",
          birthDate: "1974-01-30",
          placeOfBirth: "Haverfordwest, Pembrokeshire, Wales",
          movieIds: [4],
        ),
        const Actor(
          id: 5,
          name: "Millie Bobby Brown",
          profilePath:
              "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=500",
          biography:
              "Millie Bobby Brown is a British actress and producer. She gained recognition for playing the character Eleven in the Netflix science fiction series Stranger Things, for which she received nominations for two Primetime Emmy Awards.",
          birthDate: "2004-02-19",
          placeOfBirth: "Marbella, Spain",
          movieIds: [],
        ),
      ];

  static List<MovieExtendedModel> get trendingMovies => allMovies.sublist(0, 3);
  static List<MovieExtendedModel> get popularMovies => allMovies;
}
