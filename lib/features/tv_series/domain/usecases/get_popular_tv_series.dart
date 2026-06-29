import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/core/usecase/usecase.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetPopularTVSeries implements UseCase<List<TVSeries>, NoParams> {
  final TVSeriesRepository repository;

  GetPopularTVSeries(this.repository);

  @override
  Future<Either<Failure, List<TVSeries>>> call(NoParams params) async {
    return await repository.getPopularTVSeries();
  }
}

