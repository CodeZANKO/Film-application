import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'package:film_app/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:film_app/features/tv_series/data/mock/mock_tv_series_data.dart';

class TVSeriesRepositoryImpl implements TVSeriesRepository {
  @override
  Future<Either<Failure, List<TVSeries>>> getPopularTVSeries() async {
    try {
      return const Right(mockTVSeriesData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> searchTVSeries(String query) async {
    try {
      final results = mockTVSeriesData.where((series) {
        return series.title.toLowerCase().contains(query.toLowerCase()) ||
               series.genre.toLowerCase().contains(query.toLowerCase());
      }).toList();
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

