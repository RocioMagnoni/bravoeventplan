import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/model/song.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
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

  // Stream for the UI to listen to the song's position
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  MusicBloc() : super(MusicInitial()) {
    on<LoadMusic>(_onLoadMusic);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<SeekSong>(_onSeekSong);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
    on<SelectSong>(_onSelectSong);

    _audioPlayer.playerStateStream.listen((playerState) {
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        if (currentState.isPlaying != playerState.playing) {
           emit(currentState.copyWith(isPlaying: playerState.playing));
        }
      }
    });
  }

  Future<void> _onLoadMusic(LoadMusic event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final firstSong = _songs[0];
      final duration = await _audioPlayer.setAsset(firstSong.audioPath) ?? Duration.zero;
      emit(MusicLoaded(
        songs: _songs,
        currentSong: firstSong,
        currentIndex: 0,
        duration: duration,
      ));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  void _onPlaySong(PlaySong event, Emitter<MusicState> emit) {
    _audioPlayer.play();
  }

  void _onPauseSong(PauseSong event, Emitter<MusicState> emit) {
    _audioPlayer.pause();
  }

  void _onSeekSong(SeekSong event, Emitter<MusicState> emit) {
    _audioPlayer.seek(event.position);
  }

  Future<void> _onSelectSong(SelectSong event, Emitter<MusicState> emit) async {
    await _playSongAtIndex(event.songIndex, emit);
  }

  Future<void> _onNextSong(NextSong event, Emitter<MusicState> emit) async {
     if (state is MusicLoaded) {
      final newIndex = ((state as MusicLoaded).currentIndex + 1) % _songs.length;
      await _playSongAtIndex(newIndex, emit);
    }
  }

  Future<void> _onPreviousSong(PreviousSong event, Emitter<MusicState> emit) async {
     if (state is MusicLoaded) {
      final newIndex = ((state as MusicLoaded).currentIndex - 1 + _songs.length) % _songs.length;
      await _playSongAtIndex(newIndex, emit);
    }
  }

  Future<void> _playSongAtIndex(int index, Emitter<MusicState> emit) async {
    try {
      final song = _songs[index];
      final duration = await _audioPlayer.setAsset(song.audioPath) ?? Duration.zero;
      
      // Get the current playing state to persist it across song changes
      final bool isPlaying = (state is MusicLoaded) ? (state as MusicLoaded).isPlaying : false;

      emit(MusicLoaded(
          songs: _songs, 
          currentSong: song, 
          currentIndex: index, 
          duration: duration,
          isPlaying: isPlaying,
      ));
      _audioPlayer.play();
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
