import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:film_app/core/network/dio_client.dart';
import 'package:film_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:film_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:film_app/features/movies/data/datasources/watchlist_local_data_source.dart';
import 'package:film_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:film_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:film_app/features/movies/domain/usecases/get_trending_movies.dart';
import 'package:film_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:film_app/features/movies/domain/usecases/search_movies.dart';
import 'package:film_app/features/movies/domain/usecases/get_movie_details.dart';
import 'package:film_app/features/movies/domain/usecases/get_genres.dart';
import 'package:film_app/features/movies/domain/usecases/get_movies_by_genre.dart';
import 'package:film_app/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/watchlist_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/navigation_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/search_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/explore_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/downloads_bloc.dart';

import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/tv_series/presentation/bloc/tv_series_bloc.dart';
import 'package:film_app/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:film_app/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:film_app/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:film_app/features/tv_series/data/datasources/series_watchlist_local_data_source.dart';

import 'package:film_app/core/config/app_config.dart';
import 'package:film_app/features/content/domain/repositories/content_repository.dart';
import 'package:film_app/features/content/data/repositories/mock_content_repository.dart';
import 'package:film_app/features/content/data/repositories/remote_content_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Repositories ---
  
  // Dynamic Data Switch: Injecting the appropriate implementation based on config
  if (AppConfig.useLiveAPI) {
    // Inject Remote Repository for live data fetching
    sl.registerLazySingleton<ContentRepository>(
      () => RemoteContentRepository(sl()),
    );
  } else {
    // Inject Mock Repository for local hardcoded data
    sl.registerLazySingleton<ContentRepository>(
      () => MockContentRepository(),
    );
  }

  // Blocs
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => WatchlistBloc(localDataSource: sl()));
  sl.registerFactory(() => NavigationBloc());
  sl.registerFactory(() => SearchBloc(searchMovies: sl()));
  sl.registerFactory(() => ExploreBloc());
  sl.registerFactory(() => DownloadsBloc(sl(instanceName: 'downloads_box')));
  sl.registerFactory(() => SeriesWatchlistBloc(localDataSource: sl()));
  sl.registerFactory(() => TVSeriesBloc(getPopularTVSeries: sl()));
  sl.registerFactory(() => MoviesBloc(
        getTrendingMovies: sl(),
        getPopularMovies: sl(),
        getGenres: sl(),
        getMoviesByGenre: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => GetPopularTVSeries(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TVSeriesRepository>(
    () => TVSeriesRepositoryImpl(),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SeriesWatchlistLocalDataSource>(
    () => SeriesWatchlistLocalDataSourceImpl(sl(instanceName: 'series_watchlist_box')),
  );

  // Core
  sl.registerLazySingleton(() => DioClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());

  final box = await Hive.openBox('watchlist_box');
  sl.registerLazySingleton(() => box);

  final downloadsBox = await Hive.openBox('downloads_box');
  sl.registerLazySingleton(() => downloadsBox, instanceName: 'downloads_box');

  final seriesWatchlistBox = await Hive.openBox('series_watchlist_box');
  sl.registerLazySingleton(() => seriesWatchlistBox, instanceName: 'series_watchlist_box');
}

