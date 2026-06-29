import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<Either<Failure, List<Movie>>> call(int genreId) async {
    return await repository.getMoviesByGenre(genreId);
  }
}

