import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

class MusicService {
  Future<List<Music>> searchMusic(String term) async {
    final url = Uri.parse(
      'https://itunes.apple.com/search?term=$term&entity=song',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List results = data['results'];

      return results
          .map((music) => Music.fromJson(music))
          .toList();
    }

    throw Exception('Erro ao buscar músicas');
  }
}