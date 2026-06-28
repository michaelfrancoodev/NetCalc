import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart';
import '../models/favorite_model.dart';

class LocalStorage {
  static const String _historyKey   = 'calc_history';
  static const String _favoritesKey = 'calc_favorites';
  static const int _maxEntries = 100;

  // ---- History ----
  static List<HistoryEntry> _histCache = [];
  static bool _histLoaded = false;

  static Future<List<HistoryEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    _histCache = raw.map((s) {
      try {
        return HistoryEntry.fromMap(jsonDecode(s) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<HistoryEntry>().toList();
    _histLoaded = true;
    return List.unmodifiable(_histCache.reversed.toList());
  }

  static void addHistory(HistoryEntry entry) {
    _histCache.add(entry);
    if (_histCache.length > _maxEntries) _histCache.removeAt(0);
    _persistHistory();
  }

  static Future<void> removeHistoryAt(int reversedIndex) async {
    final realIndex = _histCache.length - 1 - reversedIndex;
    if (realIndex >= 0 && realIndex < _histCache.length) {
      _histCache.removeAt(realIndex);
      await _persistHistory();
    }
  }

  static Future<void> clearHistory() async {
    _histCache.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static List<HistoryEntry> getCachedHistory() =>
      List.unmodifiable(_histCache.reversed.toList());

  static bool get isLoaded => _histLoaded;

  static Future<void> _persistHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _histCache.map((e) => jsonEncode(e.toMap())).toList();
      await prefs.setStringList(_historyKey, data);
    } catch (_) {}
  }

  // ---- Favorites ----
  static List<FavoriteEntry> _favCache = [];
  static bool _favLoaded = false;

  static Future<List<FavoriteEntry>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    _favCache = raw.map((s) {
      try {
        return FavoriteEntry.fromMap(jsonDecode(s) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<FavoriteEntry>().toList();
    _favLoaded = true;
    return List.unmodifiable(_favCache.reversed.toList());
  }

  static Future<void> addFavorite(FavoriteEntry entry) async {
    final alreadyExists = _favCache.any(
      (e) => e.expression == entry.expression && e.result == entry.result,
    );
    if (alreadyExists) return;
    _favCache.add(entry);
    await _persistFavorites();
  }

  static Future<void> removeFavoriteAt(int reversedIndex) async {
    final realIndex = _favCache.length - 1 - reversedIndex;
    if (realIndex >= 0 && realIndex < _favCache.length) {
      _favCache.removeAt(realIndex);
      await _persistFavorites();
    }
  }

  static bool isFavorite(String expression, String result) {
    return _favCache.any(
      (e) => e.expression == expression && e.result == result,
    );
  }

  static Future<void> clearFavorites() async {
    _favCache.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  static List<FavoriteEntry> getCachedFavorites() =>
      List.unmodifiable(_favCache.reversed.toList());

  static bool get favLoaded => _favLoaded;

  static Future<void> _persistFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _favCache.map((e) => jsonEncode(e.toMap())).toList();
      await prefs.setStringList(_favoritesKey, data);
    } catch (_) {}
  }
}
