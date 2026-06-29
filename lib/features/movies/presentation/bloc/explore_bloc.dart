import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';

enum ExploreViewType { grid, list }
enum ExploreSortType { releaseDate, rating, alphabetical, genre }

// Events
abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreStarted extends ExploreEvent {}

class ExploreToggleView extends ExploreEvent {}

class ExploreSortChanged extends ExploreEvent {
  final ExploreSortType sortType;
  ExploreSortChanged(this.sortType);
  @override
  List<Object?> get props => [sortType];
}

class ExploreFiltersApplied extends ExploreEvent {
  final List<String> selectedGenres;
  final double minRating;

  ExploreFiltersApplied({required this.selectedGenres, required this.minRating});
  @override
  List<Object?> get props => [selectedGenres, minRating];
}

class ExploreFiltersReset extends ExploreEvent {}

class ExploreSearchQueryChanged extends ExploreEvent {
  final String query;
  ExploreSearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ExploreFilterRemoved extends ExploreEvent {
  final String? genre;
  final bool isRating;
  ExploreFilterRemoved({this.genre, this.isRating = false});
  @override
  List<Object?> get props => [genre, isRating];
}

class ExploreGenreToggled extends ExploreEvent {
  final String genre;
  ExploreGenreToggled(this.genre);
  @override
  List<Object?> get props => [genre];
}

// State
class ExploreState extends Equatable {
  final List<Movie> allMovies;
  final List<Movie> filteredMovies;
  final ExploreViewType viewType;
  final ExploreSortType sortType;
  final List<String> selectedGenres;
  final double minRating;
  final String searchQuery;
  final bool isLoading;

  const ExploreState({
    required this.allMovies,
    required this.filteredMovies,
    this.viewType = ExploreViewType.grid,
    this.sortType = ExploreSortType.releaseDate,
    this.selectedGenres = const [],
    this.minRating = 0.0,
    this.searchQuery = '',
    this.isLoading = false,
  });

  ExploreState copyWith({
    List<Movie>? allMovies,
    List<Movie>? filteredMovies,
    ExploreViewType? viewType,
    ExploreSortType? sortType,
    List<String>? selectedGenres,
    double? minRating,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ExploreState(
      allMovies: allMovies ?? this.allMovies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      viewType: viewType ?? this.viewType,
      sortType: sortType ?? this.sortType,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      minRating: minRating ?? this.minRating,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [allMovies, filteredMovies, viewType, sortType, selectedGenres, minRating, searchQuery, isLoading];
}

// BLoC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(const ExploreState(allMovies: [], filteredMovies: [])) {
    on<ExploreStarted>((event, emit) {
      emit(state.copyWith(isLoading: true));
      final movies = MockMovieData.allMovies;
      final sortedMovies = _sortMovies(movies, state.sortType);
      emit(state.copyWith(
        allMovies: movies,
        filteredMovies: sortedMovies,
        isLoading: false,
      ));
    });

    on<ExploreToggleView>((event, emit) {
      emit(state.copyWith(
        viewType: state.viewType == ExploreViewType.grid ? ExploreViewType.list : ExploreViewType.grid,
      ));
    });

    on<ExploreSortChanged>((event, emit) {
      final sortedMovies = _sortMovies(state.filteredMovies, event.sortType);
      emit(state.copyWith(
        sortType: event.sortType,
        filteredMovies: sortedMovies,
      ));
    });

    on<ExploreFiltersApplied>((event, emit) {
      final newState = state.copyWith(
        selectedGenres: event.selectedGenres,
        minRating: event.minRating,
      );
      _applyFilteringAndSorting(emit, newState);
    });

    on<ExploreFiltersReset>((event, emit) {
      final newState = state.copyWith(
        selectedGenres: const [],
        minRating: 0.0,
      );
      _applyFilteringAndSorting(emit, newState);
    });

    on<ExploreSearchQueryChanged>((event, emit) {
      final newState = state.copyWith(searchQuery: event.query);
      _applyFilteringAndSorting(emit, newState);
    });

    on<ExploreFilterRemoved>((event, emit) {
      List<String> updatedGenres = List.from(state.selectedGenres);
      double updatedRating = state.minRating;

      if (event.isRating) {
        updatedRating = 0.0;
      } else if (event.genre != null) {
        updatedGenres.remove(event.genre);
      }

      final newState = state.copyWith(
        selectedGenres: updatedGenres,
        minRating: updatedRating,
      );
      _applyFilteringAndSorting(emit, newState);
    });

    on<ExploreGenreToggled>((event, emit) {
      List<String> updatedGenres = List.from(state.selectedGenres);
      if (updatedGenres.contains(event.genre)) {
        updatedGenres.remove(event.genre);
      } else {
        updatedGenres.add(event.genre);
      }
      final newState = state.copyWith(selectedGenres: updatedGenres);
      _applyFilteringAndSorting(emit, newState);
    });
  }

  void _applyFilteringAndSorting(Emitter<ExploreState> emit, ExploreState newState) {
    final filtered = newState.allMovies.where((movie) {
      final matchesRating = movie.voteAverage >= newState.minRating;
      final matchesGenres = newState.selectedGenres.isEmpty || 
          newState.selectedGenres.any((genre) => movie.genres.contains(genre));
      final matchesSearch = newState.searchQuery.isEmpty || 
          movie.title.toLowerCase().contains(newState.searchQuery.toLowerCase());
      return matchesRating && matchesGenres && matchesSearch;
    }).toList();

    final sortedAndFiltered = _sortMovies(filtered, newState.sortType);

    emit(newState.copyWith(
      filteredMovies: sortedAndFiltered,
    ));
  }

  List<Movie> _sortMovies(List<Movie> movies, ExploreSortType sortType) {
    final List<Movie> sorted = List.from(movies);
    switch (sortType) {
      case ExploreSortType.releaseDate:
        sorted.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case ExploreSortType.rating:
        sorted.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        break;
      case ExploreSortType.alphabetical:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case ExploreSortType.genre:
        sorted.sort((a, b) => (a.genres.isNotEmpty ? a.genres.first : "").compareTo(b.genres.isNotEmpty ? b.genres.first : ""));
        break;
    }
    return sorted;
  }
}

