import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/movies/domain/entities/genre.dart';
import 'package:film_app/features/movies/domain/repositories/movie_repository.dart';

class GetGenres {
  final MovieRepository repository;

  GetGenres(this.repository);

  Future<Either<Failure, List<Genre>>> call() async {
    return await repository.getGenres();
  }
}

