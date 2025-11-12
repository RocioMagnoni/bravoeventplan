import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../blocs/music/music_bloc.dart';
import '../../blocs/music/music_event.dart';
import '../../blocs/music/music_state.dart';
import '../../data/model/song.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming MusicBloc is provided above in the widget tree
    context.read<MusicBloc>().add(LoadMusic());
    return const _MusicPageView();
  }
}

class _MusicPageView extends StatelessWidget {
  const _MusicPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text('Música Cool', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading || state is MusicInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MusicLoaded) {
            return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                final song = state.songs[index];
                final isCurrentSong = state.currentIndex == index;
                return _SongCard(song: song, isCurrentSong: isCurrentSong);
              },
            );
          } else if (state is MusicError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final Song song;
  final bool isCurrentSong;

  const _SongCard({required this.song, required this.isCurrentSong});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.read<MusicBloc>();
    
    return Card(
      color: const Color(0xFF1E3A5F),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(song.imagePath, width: 80, height: 80, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Expanded(
              child: BlocBuilder<MusicBloc, MusicState>(
                builder: (context, state) {
                  if (state is! MusicLoaded) return const SizedBox.shrink();
                  final duration = isCurrentSong ? state.duration : Duration.zero;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.name, style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
                      StreamBuilder<Duration>(
                        stream: musicBloc.positionStream, // Expose positionStream from BLoC
                        builder: (context, snapshot) {
                          final position = isCurrentSong ? snapshot.data ?? Duration.zero : Duration.zero;
                          return Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                            onChanged: (value) {
                              if (isCurrentSong) {
                                musicBloc.add(SeekSong(Duration(seconds: value.toInt())));
                              }
                            },
                            activeColor: Colors.yellow,
                            inactiveColor: Colors.grey,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: const Icon(Icons.skip_previous, color: Colors.yellow), onPressed: () => musicBloc.add(PreviousSong())),
                          IconButton(
                            icon: Icon(isCurrentSong && state.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.yellow),
                            onPressed: () {
                              if (isCurrentSong && state.isPlaying) {
                                musicBloc.add(PauseSong());
                              } else {
                                musicBloc.add(SelectSong(state.songs.indexOf(song)));
                              }
                            },
                          ),
                          IconButton(icon: const Icon(Icons.skip_next, color: Colors.yellow), onPressed: () => musicBloc.add(NextSong())),
                        ],
                      ),
                      StreamBuilder<Duration>(
                         stream: musicBloc.positionStream,
                         builder: (context, snapshot) {
                            final position = isCurrentSong ? snapshot.data ?? Duration.zero : Duration.zero;
                            return Text(
                              "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / "
                              "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.yellow, fontSize: 12),
                            );
                         }
                      )
                    ],
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
