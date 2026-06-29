import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<Either<Failure, Movie>> call(int id) async {
    return await repository.getMovieDetails(id);
  }
}

