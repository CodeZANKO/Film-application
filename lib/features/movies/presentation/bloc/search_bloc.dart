import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/domain/entities/actor.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'package:film_app/features/movies/domain/usecases/search_movies.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:film_app/features/tv_series/data/mock/mock_tv_series_data.dart';

// Events
abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

// States
abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final List<TVSeries> tvSeries;
  final List<Actor> actors;
  
  SearchLoaded({
    required this.movies,
    required this.tvSeries,
    required this.actors,
  });

  bool get isEmpty => movies.isEmpty && tvSeries.isEmpty && actors.isEmpty;

  @override
  List<Object> get props => [movies, tvSeries, actors];
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchInitial());
        return;
      }
      emit(SearchLoading());
      
      final movieResult = await searchMovies(event.query);
      
      final query = event.query.toLowerCase();
      
      // Search Series (Mock)
      final matchedSeries = mockTVSeriesData.where((s) {
        return s.title.toLowerCase().contains(query) || 
               s.genre.toLowerCase().contains(query);
      }).toList();

      // Search Actors (Mock)
      final matchedActors = MockMovieData.allActors.where((a) {
        return a.name.toLowerCase().contains(query);
      }).toList();

      movieResult.fold(
        (failure) => emit(SearchError(failure.message)),
        (movies) => emit(SearchLoaded(
          movies: movies,
          tvSeries: matchedSeries,
          actors: matchedActors,
        )),
      );
    });
  }
}

