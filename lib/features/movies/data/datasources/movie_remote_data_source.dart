import 'package:film_app/core/network/dio_client.dart';
import 'package:film_app/features/movies/data/models/movie_model.dart';
import 'package:film_app/features/movies/data/models/genre_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieModel> getMovieDetails(int id);
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getMoviesByGenre(int genreId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await client.get('/trending/movie/day');
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get('/movie/popular');
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get('/search/movie', queryParameters: {'query': query});
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    final response = await client.get('/movie/$id');
    return MovieModel.fromJson(response.data);
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await client.get('/genre/movie/list');
    final List results = response.data['genres'];
    return results.map((json) => GenreModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final response = await client.get('/discover/movie', queryParameters: {
      'with_genres': genreId.toString(),
    });
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }
}

