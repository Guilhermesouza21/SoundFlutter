import 'package:flutter/material.dart';
import '../pages/favorites_page.dart';
import '../models/music_model.dart';
import '../service/music_service.dart';
import '../service/audio_player_service.dart';
import '../service/favorites_service.dart';
import '../widgets/mini_player.dart';
import '../pages/player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final MusicService _musicService = MusicService();
  final AudioPlayerService _audioService = AudioPlayerService.instance;
  final FavoritesService _favoritesService = FavoritesService();

  List<Music> musics = [];

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;
    try {
      final result = await _musicService.searchMusic(
        _searchController.text,
      );

      setState(() {
        musics = result;
      });
    } catch (e) {
      debugPrint('Erro: $e');
    }
  }

  Future<void> _playPreview(Music music, int index) async {
    try {
      await _audioService.player.stop();

      setState(() {
        _audioService.currentMusic = music;
        _audioService.currentIndex = index;
        _audioService.playlist = musics; // Salva a playlist de resultados no singleton
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PESQUISA',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: _audioService.currentMusic == null
          ? null
          : MiniPlayer(
              music: _audioService.currentMusic!,
              isPlaying: _audioService.isPlaying,
              onPlayPause: _togglePlayPause,
              onOpen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(
                      musics: musics,
                      initialIndex: _audioService.currentIndex,
                    ),
                  ),
                );
              },
            ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _performSearch(),
              decoration: const InputDecoration(
                labelText: 'Digite uma música ou artista',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Buscar'),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: musics.length,
                itemBuilder: (context, index) {
                  final music = musics[index];

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
                          ValueListenableBuilder(
                            valueListenable: _favoritesService.listenable,
                            builder: (context, box, child) {
                              final isFav = _favoritesService.isFavorite(music.previewUrl);
                              return IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : null,
                                ),
                                onPressed: () => _favoritesService.toggleFavorite(music),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_arrow_rounded),
                            onPressed: () => _playPreview(
                              music,
                              index,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
