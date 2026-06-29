import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart';
import 'package:film_app/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:film_app/core/usecase/usecase.dart';

// Events
abstract class TVSeriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPopularTVSeriesEvent extends TVSeriesEvent {}

// States
abstract class TVSeriesState extends Equatable {
  @override
  List<Object> get props => [];
}

class TVSeriesInitial extends TVSeriesState {}

class TVSeriesLoading extends TVSeriesState {}

class TVSeriesLoaded extends TVSeriesState {
  final List<TVSeries> series;
  TVSeriesLoaded(this.series);
  @override
  List<Object> get props => [series];
}

class TVSeriesError extends TVSeriesState {
  final String message;
  TVSeriesError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class TVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetPopularTVSeries getPopularTVSeries;

  TVSeriesBloc({required this.getPopularTVSeries}) : super(TVSeriesInitial()) {
    on<GetPopularTVSeriesEvent>((event, emit) async {
      emit(TVSeriesLoading());
      final result = await getPopularTVSeries(NoParams());
      result.fold(
        (failure) => emit(TVSeriesError("Failed to fetch TV series")),
        (series) => emit(TVSeriesLoaded(series)),
      );
    });
  }
}

