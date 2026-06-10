import 'package:flutter/material.dart';

import '../models/music_model.dart';
import '../service/audio_player_service.dart';
import '../service/favorites_service.dart';

class PlayerPage extends StatefulWidget {
  final List<Music> musics;
  final int initialIndex;

  const PlayerPage({
    super.key,
    required this.musics,
    required this.initialIndex,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayerService _audioService = AudioPlayerService.instance;
  final FavoritesService _favoritesService = FavoritesService();
  late int index;

  Stream<Duration> get _positionStream => _audioService.player.positionStream;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    
    // Verifica se a música atual é diferente da que está no player
    if (_audioService.currentIndex != index) {
      _loadSong();
    }
  }

  Future<void> _loadSong() async {
    await _audioService.player.setUrl(widget.musics[index].previewUrl);
    await _audioService.player.play();
    
    setState(() {
      _audioService.currentMusic = widget.musics[index];
      _audioService.currentIndex = index;
      _audioService.isPlaying = true;
    });
  }

  void _next() {
    if (index < widget.musics.length - 1) {
      index++;
      _loadSong();
    }
  }

  void _previous() {
    if (index > 0) {
      index--;
      _loadSong();
    }
  }

  void _toggle() {
    if (_audioService.player.playing) {
      _audioService.player.pause();
    } else {
      _audioService.player.play();
    }
    setState(() {
      _audioService.isPlaying = _audioService.player.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final music = widget.musics[index];

    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Capa do Álbum com sombra suave de profundidade
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 35,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  music.cover,
                  width: 280,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Informações da Música (Título, Artista e Botão de Favorito)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          music.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _favoritesService.listenable,
                    builder: (context, box, child) {
                      final isFav = _favoritesService.isFavorite(music.previewUrl);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _favoritesService.toggleFavorite(music),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Slider de Progresso da Música Customizado
            StreamBuilder<Duration>(
              stream: _positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioService.player.duration ?? Duration.zero;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: const Color(0x26FFFFFF),
                          thumbColor: Colors.white,
                          overlayColor: const Color(0x1AFFFFFF),
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble() == 0
                              ? 1
                              : duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioService.player.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _format(position),
                            style: const TextStyle(
                              color: Color(0x80FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _format(duration),
                            style: const TextStyle(
                              color: Color(0x80FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const Spacer(),
            
            // Controles de Reprodução (Mídia)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                  onPressed: _previous,
                ),
                const SizedBox(width: 24),
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _audioService.player.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 38,
                    ),
                    onPressed: _toggle,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                  onPressed: _next,
                ),
              ],
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}