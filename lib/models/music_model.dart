class Music {
  final String title;
  final String artist;
  final String cover;
  final String previewUrl;

  Music({
    required this.title,
    required this.artist,
    required this.cover,
    required this.previewUrl,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['trackName'] ?? '',
      artist: json['artistName'] ?? '',
      cover: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}