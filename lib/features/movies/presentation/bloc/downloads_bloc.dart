import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/movies/domain/entities/movie.dart';
import 'package:film_app/features/movies/data/datasources/mock_movie_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Events
abstract class DownloadsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDownloads extends DownloadsEvent {}

class AddToDownloads extends DownloadsEvent {
  final Movie movie;
  AddToDownloads(this.movie);
  @override
  List<Object?> get props => [movie];
}

class RemoveFromDownloads extends DownloadsEvent {
  final int movieId;
  RemoveFromDownloads(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

// State
class DownloadsState extends Equatable {
  final List<Movie> downloadedMovies;
  final Set<int> downloadingMovieIds; // For tracking ongoing simulations
  final Map<int, double> downloadProgress;

  const DownloadsState({
    this.downloadedMovies = const [],
    this.downloadingMovieIds = const {},
    this.downloadProgress = const {},
  });

  DownloadsState copyWith({
    List<Movie>? downloadedMovies,
    Set<int>? downloadingMovieIds,
    Map<int, double>? downloadProgress,
  }) {
    return DownloadsState(
      downloadedMovies: downloadedMovies ?? this.downloadedMovies,
      downloadingMovieIds: downloadingMovieIds ?? this.downloadingMovieIds,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  @override
  List<Object?> get props => [downloadedMovies, downloadingMovieIds, downloadProgress];
}

// BLoC
class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  final Box _downloadsBox;

  DownloadsBloc(this._downloadsBox) : super(const DownloadsState()) {
    on<LoadDownloads>((event, emit) {
      final List<int> ids = _downloadsBox.get('downloaded_ids', defaultValue: <int>[]).cast<int>();
      final movies = MockMovieData.allMovies.where((m) => ids.contains(m.id)).toList();
      emit(state.copyWith(downloadedMovies: movies));
    });

    on<AddToDownloads>((event, emit) async {
      final List<int> ids = List<int>.from(_downloadsBox.get('downloaded_ids', defaultValue: <int>[]));
      if (!ids.contains(event.movie.id)) {
        ids.add(event.movie.id);
        await _downloadsBox.put('downloaded_ids', ids);
        add(LoadDownloads());
      }
    });

    on<RemoveFromDownloads>((event, emit) async {
      final List<int> ids = List<int>.from(_downloadsBox.get('downloaded_ids', defaultValue: <int>[]));
      ids.remove(event.movieId);
      await _downloadsBox.put('downloaded_ids', ids);
      add(LoadDownloads());
    });
  }
}

