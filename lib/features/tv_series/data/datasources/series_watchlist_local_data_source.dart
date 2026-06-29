import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:film_app/features/tv_series/domain/entities/tv_series.dart' as entity;
import 'package:film_app/features/tv_series/data/models/tv_series_model.dart' as model;

abstract class SeriesWatchlistLocalDataSource {
  Future<List<entity.TVSeries>> getWatchlist();
  Future<void> addToWatchlist(entity.TVSeries series);
  Future<void> removeFromWatchlist(String seriesId);
}

class SeriesWatchlistLocalDataSourceImpl implements SeriesWatchlistLocalDataSource {
  final Box _box;
  static const String _key = 'series_watchlist';

  SeriesWatchlistLocalDataSourceImpl(this._box);

  @override
  Future<List<entity.TVSeries>> getWatchlist() async {
    final String? jsonString = _box.get(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => model.TVSeries.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> addToWatchlist(entity.TVSeries series) async {
    final watchlist = await getWatchlist();
    if (!watchlist.any((s) => s.id == series.id)) {
      watchlist.add(series);
      final modelList = watchlist.map((s) => _toModel(s)).toList();
      await _box.put(_key, json.encode(modelList.map((s) => s.toJson()).toList()));
    }
  }

  @override
  Future<void> removeFromWatchlist(String seriesId) async {
    final watchlist = await getWatchlist();
    watchlist.removeWhere((s) => s.id == seriesId);
    final modelList = watchlist.map((s) => _toModel(s)).toList();
    await _box.put(_key, json.encode(modelList.map((s) => s.toJson()).toList()));
  }

  model.TVSeries _toModel(entity.TVSeries e) {
    if (e is model.TVSeries) return e;
    return model.TVSeries(
      id: e.id,
      title: e.title,
      overview: e.overview,
      posterUrl: e.posterUrl,
      backdropUrl: e.backdropUrl,
      rating: e.rating,
      genre: e.genre,
      releaseYear: e.releaseYear,
      totalSeasons: e.totalSeasons,
      seasons: e.seasons.map((s) => model.Season(
        seasonNumber: s.seasonNumber,
        episodes: s.episodes.map((ep) => model.Episode(
          episodeNumber: ep.episodeNumber,
          title: ep.title,
          duration: ep.duration,
          thumbnailUrl: ep.thumbnailUrl,
          videoUrl: ep.videoUrl,
        )).toList(),
      )).toList(),
      cast: e.cast.map((c) => model.SeriesCast(
        id: c.id,
        name: c.name,
        character: c.character,
        profileUrl: c.profileUrl,
      )).toList(),
    );
  }
}

