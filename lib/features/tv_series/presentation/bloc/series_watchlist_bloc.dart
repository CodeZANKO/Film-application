import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'package:film_app/features/tv_series/data/datasources/series_watchlist_local_data_source.dart';

// Events
abstract class SeriesWatchlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSeriesWatchlist extends SeriesWatchlistEvent {}

class ToggleSeriesWatchlist extends SeriesWatchlistEvent {
  final TVSeries series;
  ToggleSeriesWatchlist(this.series);
  @override
  List<Object> get props => [series];
}

// States
class SeriesWatchlistState extends Equatable {
  final List<TVSeries> series;
  const SeriesWatchlistState({this.series = const []});

  bool isInWatchlist(String id) => series.any((s) => s.id == id);

  @override
  List<Object> get props => [series];
}

// BLoC
class SeriesWatchlistBloc extends Bloc<SeriesWatchlistEvent, SeriesWatchlistState> {
  final SeriesWatchlistLocalDataSource localDataSource;

  SeriesWatchlistBloc({required this.localDataSource}) : super(const SeriesWatchlistState()) {
    on<LoadSeriesWatchlist>((event, emit) async {
      final series = await localDataSource.getWatchlist();
      emit(SeriesWatchlistState(series: series));
    });

    on<ToggleSeriesWatchlist>((event, emit) async {
      final currentSeries = List<TVSeries>.from(state.series);
      
      if (currentSeries.any((s) => s.id == event.series.id)) {
        currentSeries.removeWhere((s) => s.id == event.series.id);
        await localDataSource.removeFromWatchlist(event.series.id);
      } else {
        currentSeries.add(event.series);
        await localDataSource.addToWatchlist(event.series);
      }
      emit(SeriesWatchlistState(series: currentSeries));
    });
  }
}

