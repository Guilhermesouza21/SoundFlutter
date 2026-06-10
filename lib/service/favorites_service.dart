import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/music_model.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final Box _box = Hive.box('favorites');

  ValueListenable<Box> get listenable => _box.listenable();

  List<Music> getFavorites() {
    return _box.values.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return Music(
        title: map['title'] ?? '',
        artist: map['artist'] ?? '',
        cover: map['cover'] ?? '',
        previewUrl: map['previewUrl'] ?? '',
      );
    }).toList();
  }

  bool isFavorite(String previewUrl) {
    return _box.containsKey(previewUrl);
  }

  Future<void> toggleFavorite(Music music) async {
    if (isFavorite(music.previewUrl)) {
      await _box.delete(music.previewUrl);
    } else {
      await _box.put(music.previewUrl, {
        'title': music.title,
        'artist': music.artist,
        'cover': music.cover,
        'previewUrl': music.previewUrl,
      });
    }
  }
}
