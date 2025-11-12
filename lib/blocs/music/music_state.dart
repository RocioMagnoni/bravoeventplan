import 'package:equatable/equatable.dart';
import '../../data/model/song.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Song> songs;
  final Song currentSong;
  final int currentIndex;
  final bool isPlaying;
  final Duration duration;

  const MusicLoaded({
    required this.songs,
    required this.currentSong,
    required this.currentIndex,
    this.isPlaying = false,
    this.duration = Duration.zero,
  });

  MusicLoaded copyWith({
    List<Song>? songs,
    Song? currentSong,
    int? currentIndex,
    bool? isPlaying,
    Duration? duration,
  }) {
    return MusicLoaded(
      songs: songs ?? this.songs,
      currentSong: currentSong ?? this.currentSong,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [songs, currentSong, currentIndex, isPlaying, duration];
}

class MusicError extends MusicState {
  final String message;

  const MusicError(this.message);

  @override
  List<Object> get props => [message];
}
