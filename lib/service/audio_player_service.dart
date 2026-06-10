import 'package:just_audio/just_audio.dart';
import '../models/music_model.dart';

class AudioPlayerService {
  static final AudioPlayerService instance = AudioPlayerService._internal();
  AudioPlayerService._internal();

  final AudioPlayer player = AudioPlayer();
  
  Music? currentMusic;
  bool isPlaying = false;
  int currentIndex = -1;
  List<Music> playlist = [];
}