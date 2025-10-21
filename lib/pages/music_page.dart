import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// ----------------- Música (barra independiente por canción) -----------------
class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = 0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  final List<Map<String, String>> songs = [
    {
      'name': 'Johnny Bravo (Opening)',
      'audio': 'assets/audio/mis_canciones/Johnny Bravo (opening español latino).mp3',
      'image': 'assets/images/song1.jpg',
    },
    {
      'name': 'La canción de Johnny Bravo (Mujer)',
      'audio': 'assets/audio/mis_canciones/La canción de johnny Bravo  (mujer).mp3',
      'image': 'assets/images/song22.jpg',
    },
    {
      'name': 'Hay un tipo guapo en mi casa',
      'audio': 'assets/audio/mis_canciones/Johnny Bravo -  Hay un tipo guapo en mi casa.mp3',
      'image': 'assets/images/song5.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSong();
    _player.positionStream.listen((pos) {
      if (_player.playing) setState(() => _position = pos);
    });
    _player.durationStream.listen((dur) {
      setState(() => _duration = dur ?? Duration.zero);
    });
  }

  Future<void> _loadSong() async {
    await _player.setAsset(songs[_currentIndex]['audio']!);
    setState(() {
      _position = Duration.zero;
      _duration = _player.duration ?? Duration.zero;
    });
  }

  void _play() async => await _player.play();
  void _pause() async => await _player.pause();

  void _next() async {
    _currentIndex = (_currentIndex + 1) % songs.length;
    await _loadSong();
    _play();
  }

  void _previous() async {
    _currentIndex = (_currentIndex - 1 + songs.length) % songs.length;
    await _loadSong();
    _play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          bool isPlaying = _player.playing && _currentIndex == index;
          Duration sliderPosition = _currentIndex == index ? _position : Duration.zero;
          Duration sliderDuration = _currentIndex == index ? _duration : Duration.zero;

          return Card(
            color: Color(0xFF1E3A5F),
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(songs[index]['image']!, width: 80, height: 80, fit: BoxFit.cover),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[index]['name']!,
                          style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          min: 0,
                          max: sliderDuration.inSeconds.toDouble(),
                          value: sliderPosition.inSeconds.toDouble().clamp(0, sliderDuration.inSeconds.toDouble()),
                          onChanged: _currentIndex == index
                              ? (value) => _player.seek(Duration(seconds: value.toInt()))
                              : null,
                          activeColor: Colors.yellow,
                          inactiveColor: Colors.grey,
                        ),
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.skip_previous, color: Colors.yellow), onPressed: _previous),
                            IconButton(
                              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.yellow),
                              onPressed: () {
                                if (isPlaying) _pause();
                                else {
                                  _currentIndex = index;
                                  _loadSong().then((_) => _play());
                                }
                                setState(() {});
                              },
                            ),
                            IconButton(icon: Icon(Icons.skip_next, color: Colors.yellow), onPressed: _next),
                          ],
                        ),
                        Text(
                          "${sliderPosition.inMinutes}:${(sliderPosition.inSeconds % 60).toString().padLeft(2,'0')} / "
                              "${sliderDuration.inMinutes}:${(sliderDuration.inSeconds % 60).toString().padLeft(2,'0')}",
                          style: TextStyle(color: Colors.yellow, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
