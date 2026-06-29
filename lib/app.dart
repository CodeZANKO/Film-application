import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/watchlist_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/navigation_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/explore_bloc.dart';
import 'package:film_app/features/movies/presentation/bloc/downloads_bloc.dart';
import 'package:film_app/features/tv_series/presentation/bloc/series_watchlist_bloc.dart';
import 'package:film_app/features/tv_series/presentation/bloc/tv_series_bloc.dart';
import 'package:film_app/core/routes/app_routes.dart';
import 'package:film_app/core/di/injection_container.dart' as di;

class FilmApp extends StatelessWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(
            create: (_) => di.sl<WatchlistBloc>()..add(LoadWatchlist())),
        BlocProvider(create: (_) => di.sl<NavigationBloc>()),
        BlocProvider(create: (_) => di.sl<MoviesBloc>()..add(GetMoviesStarted())),
        BlocProvider(
            create: (_) => di.sl<ExploreBloc>()..add(ExploreStarted())),
        BlocProvider(
            create: (_) => di.sl<DownloadsBloc>()..add(LoadDownloads())),
        BlocProvider(
            create: (_) =>
                di.sl<SeriesWatchlistBloc>()..add(LoadSeriesWatchlist())),
        BlocProvider(
            create: (_) =>
                di.sl<TVSeriesBloc>()..add(GetPopularTVSeriesEvent())),
      ],
      child: MaterialApp(
        title: 'FILM APP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.login,
      ),
    );
  }
}

