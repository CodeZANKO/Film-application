import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/entities/genre.dart';
import 'package:film_app/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getTrendingMovies() async {
    try {
      final movies = await remoteDataSource.getTrendingMovies();
      return Right(movies);
    } catch (e) {
      // Fallback to mock data if API fails or key is missing
      return Right(MockMovieData.trendingMovies);
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final movies = await remoteDataSource.getPopularMovies();
      return Right(movies);
    } catch (e) {
      // Fallback to mock data if API fails or key is missing
      return Right(MockMovieData.popularMovies);
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);
      return Right(movies);
    } catch (e) {
      final results = MockMovieData.allMovies.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase()) ||
               movie.genres.any((g) => g.toLowerCase().contains(query.toLowerCase()));
      }).toList();
      return Right(results);
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int id) async {
    try {
      final movie = await remoteDataSource.getMovieDetails(id);
      return Right(movie);
    } catch (e) {
      final movie = MockMovieData.allMovies.firstWhere(
        (m) => m.id == id,
        orElse: () => MockMovieData.allMovies.first,
      );
      return Right(movie);
    }
  }

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final genres = await remoteDataSource.getGenres();
      return Right(genres);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    try {
      final movies = await remoteDataSource.getMoviesByGenre(genreId);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

