import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import '../entities/tv_series.dart';

abstract class TVSeriesRepository {
  Future<Either<Failure, List<TVSeries>>> getPopularTVSeries();
  Future<Either<Failure, List<TVSeries>>> searchTVSeries(String query);
}

