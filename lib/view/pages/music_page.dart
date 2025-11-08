import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/music_viewmodel.dart';
import '../../data/model/song.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MusicPageView();
  }
}

class _MusicPageView extends StatelessWidget {
  const _MusicPageView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MusicViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Musica',
          style: TextStyle(color: Colors.black),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: ListView.builder(
        itemCount: viewModel.songs.length,
        itemBuilder: (context, index) {
          final song = viewModel.songs[index];
          return _SongCard(song: song, index: index);
        },
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final Song song;
  final int index;

  const _SongCard({required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MusicViewModel>();
    final isCurrentSong = viewModel.currentIndex == index;
    final duration = isCurrentSong ? viewModel.duration ?? Duration.zero : Duration.zero;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: const TextStyle(
                        color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<Duration>(
                    stream: viewModel.positionStream,
                    builder: (context, snapshot) {
                      final position = isCurrentSong ? snapshot.data ?? Duration.zero : Duration.zero;
                      return Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                        onChanged: (value) {
                          if (isCurrentSong) {
                            viewModel.seek(Duration(seconds: value.toInt()));
                          }
                        },
                        activeColor: Colors.yellow,
                        inactiveColor: Colors.grey,
                      );
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.yellow),
                          onPressed: viewModel.previous),
                      StreamBuilder<PlayerState>(
                        stream: viewModel.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final isPlaying = playerState?.playing ?? false;

                          return IconButton(
                            icon: Icon(
                              isCurrentSong && isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              if (isCurrentSong && isPlaying) {
                                viewModel.pause();
                              } else {
                                viewModel.playSong(index);
                              }
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.yellow),
                        onPressed: viewModel.next,
                      ),
                    ],
                  ),
                  StreamBuilder<Duration>(
                    stream: viewModel.positionStream,
                    builder: (context, snapshot) {
                      final position = isCurrentSong ? snapshot.data ?? Duration.zero : Duration.zero;
                      return Text(
                        "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / "
                        "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.yellow, fontSize: 12),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
