import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:film_app/features/movies/data/models/movie_model.dart';

abstract class WatchlistLocalDataSource {
  Future<List<MovieModel>> getWatchlist();
  Future<void> addToWatchlist(MovieModel movie);
  Future<void> removeFromWatchlist(int movieId);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final Box _box;
  static const String _key = 'movies';

  WatchlistLocalDataSourceImpl(this._box);

  @override
  Future<List<MovieModel>> getWatchlist() async {
    final String? jsonString = _box.get(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => MovieModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> addToWatchlist(MovieModel movie) async {
    final movies = await getWatchlist();
    if (!movies.any((m) => m.id == movie.id)) {
      movies.add(movie);
      await _box.put(_key, json.encode(movies.map((m) => m.toJson()).toList()));
    }
  }

  @override
  Future<void> removeFromWatchlist(int movieId) async {
    final movies = await getWatchlist();
    movies.removeWhere((m) => m.id == movieId);
    await _box.put(_key, json.encode(movies.map((m) => m.toJson()).toList()));
  }
}

