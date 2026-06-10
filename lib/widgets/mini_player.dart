import 'package:flutter/material.dart';
import '../models/music_model.dart';

class MiniPlayer extends StatelessWidget {
  final Music music;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onOpen;

  const MiniPlayer({
    super.key,
    required this.music,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                music.cover,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    music.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: onPlayPause,
            ),
          ],
        ),
      ),
    );
  }
}