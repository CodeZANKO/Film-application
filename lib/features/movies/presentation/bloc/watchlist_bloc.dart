import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/data/datasources/watchlist_local_data_source.dart';
import 'package:film_app/features/movies/data/models/movie_model.dart';

// Events
abstract class WatchlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadWatchlist extends WatchlistEvent {}

class ToggleWatchlist extends WatchlistEvent {
  final Movie movie;
  ToggleWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

// States
class WatchlistState extends Equatable {
  final List<Movie> movies;
  const WatchlistState({this.movies = const []});
  @override
  List<Object> get props => [movies];
}

// BLoC
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistLocalDataSource localDataSource;

  WatchlistBloc({required this.localDataSource}) : super(const WatchlistState()) {
    on<LoadWatchlist>((event, emit) async {
      final movies = await localDataSource.getWatchlist();
      emit(WatchlistState(movies: movies));
    });

    on<ToggleWatchlist>((event, emit) async {
      final currentMovies = List<Movie>.from(state.movies);
      final movieModel = MovieModel(
        id: event.movie.id,
        title: event.movie.title,
        overview: event.movie.overview,
        posterPath: event.movie.posterPath,
        backdropPath: event.movie.backdropPath,
        voteAverage: event.movie.voteAverage,
        releaseDate: event.movie.releaseDate,
        genres: event.movie.genres,
      );

      if (currentMovies.any((m) => m.id == event.movie.id)) {
        currentMovies.removeWhere((m) => m.id == event.movie.id);
        await localDataSource.removeFromWatchlist(event.movie.id);
      } else {
        currentMovies.add(event.movie);
        await localDataSource.addToWatchlist(movieModel);
      }
      emit(WatchlistState(movies: currentMovies));
    });
  }
}

