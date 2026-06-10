import 'package:flutter/material.dart';
import '../models/music_model.dart';
import '../service/audio_player_service.dart';
import '../service/favorites_service.dart';
import '../widgets/mini_player.dart';
import 'player_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService();
  final AudioPlayerService _audioService = AudioPlayerService.instance;

  @override
  void initState() {
    super.initState();
    _audioService.player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioService.isPlaying = state.playing;
      });
    });
  }

  Future<void> _playPreview(Music music, int index) async {
    try {
      await _audioService.player.stop();

      setState(() {
        _audioService.currentMusic = music;
        _audioService.currentIndex = index;
        _audioService.isPlaying = false;
      });

      await _audioService.player.setUrl(music.previewUrl);
      await _audioService.player.play();

      setState(() {
        _audioService.isPlaying = true;
      });
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_audioService.player.playing) {
      await _audioService.player.pause();
    } else {
      await _audioService.player.play();
    }
    setState(() {
      _audioService.isPlaying = _audioService.player.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _favoritesService.listenable,
      builder: (context, box, child) {
        final favorites = _favoritesService.getFavorites();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'FAVORITOS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          bottomNavigationBar: _audioService.currentMusic == null
              ? null
              : MiniPlayer(
                  music: _audioService.currentMusic!,
                  isPlaying: _audioService.isPlaying,
                  onPlayPause: _togglePlayPause,
                  onOpen: () {
                    final currentMusic = _audioService.currentMusic;
                    if (currentMusic == null) return;
                    final favIndex = favorites.indexWhere(
                      (m) => m.previewUrl == currentMusic.previewUrl,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerPage(
                          musics: favIndex != -1 ? favorites : [currentMusic],
                          initialIndex: favIndex != -1 ? favIndex : 0,
                        ),
                      ),
                    );
                  },
                ),
          body: favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 64, color: Color(0x80FFFFFF)),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma música favorita ainda ❤️',
                        style: TextStyle(fontSize: 16, color: Color(0x80FFFFFF)),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final music = favorites[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              music.cover,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            music.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            music.artist,
                            style: const TextStyle(color: Color(0x80FFFFFF)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () => _favoritesService.toggleFavorite(music),
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_arrow_rounded),
                                onPressed: () => _playPreview(music, index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}