import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/model/song.dart';

class MusicViewModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _songs = [
    Song(
      name: 'Johnny Bravo (Opening)',
      audioPath: 'assets/audio/mis_canciones/Johnny Bravo (opening español latino).mp3',
      imagePath: 'assets/images/song1.jpg',
    ),
    Song(
      name: 'La canción de Johnny Bravo (Mujer)',
      audioPath: 'assets/audio/mis_canciones/La canción de johnny Bravo  (mujer).mp3',
      imagePath: 'assets/images/song22.jpg',
    ),
    Song(
      name: 'Hay un tipo guapo en mi casa',
      audioPath: 'assets/audio/mis_canciones/Johnny Bravo -  Hay un tipo guapo en mi casa.mp3',
      imagePath: 'assets/images/song5.jpg',
    ),
  ];

  int _currentIndex = 0;
  Duration? _duration;

  List<Song> get songs => _songs;
  int get currentIndex => _currentIndex;
  Duration? get duration => _duration;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  MusicViewModel() {
    _loadSong();
  }

  Future<void> _loadSong() async {
    if (_currentIndex >= 0 && _currentIndex < _songs.length) {
      try {
        _duration = await _audioPlayer.setAsset(_songs[_currentIndex].audioPath);
        notifyListeners();
      } catch (e) {
        print("Error loading audio source: $e");
      }
    }
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void playSong(int index) {
    _currentIndex = index;
    _loadSong().then((_) => play());
  }

  void next() {
    _currentIndex = (_currentIndex + 1) % _songs.length;
    playSong(_currentIndex);
  }

  void previous() {
    _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    playSong(_currentIndex);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
