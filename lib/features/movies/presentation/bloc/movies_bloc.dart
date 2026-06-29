import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:film_app/core/error/failures.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/entities/genre.dart';
import 'package:film_app/features/movies/domain/usecases/get_trending_movies.dart';
import 'package:film_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:film_app/features/movies/domain/usecases/get_genres.dart';
import 'package:film_app/features/movies/domain/usecases/get_movies_by_genre.dart';

// Events
abstract class MoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMoviesStarted extends MoviesEvent {}

class FilterByGenre extends MoviesEvent {
  final Genre genre;
  FilterByGenre(this.genre);
  @override
  List<Object> get props => [genre];
}

// States
abstract class MoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;
  final List<Genre> genres;
  final Genre? selectedGenre;
  final List<Movie>? filteredMovies;

  MoviesLoaded({
    required this.trendingMovies,
    required this.popularMovies,
    required this.genres,
    this.selectedGenre,
    this.filteredMovies,
  });

  MoviesLoaded copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Genre>? genres,
    Genre? selectedGenre,
    List<Movie>? filteredMovies,
  }) {
    return MoviesLoaded(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      genres: genres ?? this.genres,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      filteredMovies: filteredMovies ?? this.filteredMovies,
    );
  }

  @override
  List<Object?> get props => [trendingMovies, popularMovies, genres, selectedGenre, filteredMovies];
}

class MoviesError extends MoviesState {
  final String message;

  MoviesError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetTrendingMovies getTrendingMovies;
  final GetPopularMovies getPopularMovies;
  final GetGenres getGenres;
  final GetMoviesByGenre getMoviesByGenre;

  MoviesBloc({
    required this.getTrendingMovies,
    required this.getPopularMovies,
    required this.getGenres,
    required this.getMoviesByGenre,
  }) : super(MoviesInitial()) {
    on<GetMoviesStarted>((event, emit) async {
      emit(MoviesLoading());

      final results = await Future.wait([
        getTrendingMovies(),
        getPopularMovies(),
        getGenres(),
      ]);

      final trendingResult = results[0] as Either<Failure, List<Movie>>;
      final popularResult = results[1] as Either<Failure, List<Movie>>;
      final genresResult = results[2] as Either<Failure, List<Genre>>;

      String? errorMessage;
      List<Movie>? trendingMovies;
      List<Movie>? popularMovies;
      List<Genre>? genres;

      trendingResult.fold((f) => errorMessage = f.message, (m) => trendingMovies = m);
      if (errorMessage == null) {
        popularResult.fold((f) => errorMessage = f.message, (m) => popularMovies = m);
      }
      if (errorMessage == null) {
        genresResult.fold((f) => errorMessage = f.message, (m) => genres = m);
      }

      if (errorMessage != null) {
        emit(MoviesError(errorMessage!));
      } else {
        emit(MoviesLoaded(
          trendingMovies: trendingMovies!,
          popularMovies: popularMovies!,
          genres: genres!,
        ));
      }
    });

    on<FilterByGenre>((event, emit) async {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        
        // If the same genre is clicked, we might want to clear the filter (optional)
        if (currentState.selectedGenre?.id == event.genre.id) {
          emit(currentState.copyWith(selectedGenre: null, filteredMovies: null));
          return;
        }

        emit(currentState.copyWith(selectedGenre: event.genre, filteredMovies: null));
        
        final result = await getMoviesByGenre(event.genre.id);
        
        result.fold(
          (failure) => emit(MoviesError(failure.message)),
          (movies) => emit(currentState.copyWith(
            selectedGenre: event.genre,
            filteredMovies: movies,
          )),
        );
      }
    });
  }
}

