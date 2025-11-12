import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class LoadMusic extends MusicEvent {}

class PlaySong extends MusicEvent {}

class PauseSong extends MusicEvent {}

class SeekSong extends MusicEvent {
  final Duration position;

  const SeekSong(this.position);

  @override
  List<Object> get props => [position];
}

class NextSong extends MusicEvent {}

class PreviousSong extends MusicEvent {}

class SelectSong extends MusicEvent {
  final int songIndex;

  const SelectSong(this.songIndex);

  @override
  List<Object> get props => [songIndex];
}
