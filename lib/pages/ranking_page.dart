import 'package:flutter/material.dart';

// ----------------- Ranking Page -----------------
class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final List<Map<String, dynamic>> _ranking = [
    {'name': 'Johnny Bravo', 'image': 'bravo.jpg', 'points': 1000},
    {'name': 'Suzy', 'image': 'suzy.jpg', 'points': 0},
    {'name': 'Carl', 'image': 'carl.jpg', 'points': 0},
    {'name': 'Bunny', 'image': 'bunny.jpg', 'points': 0},
    {'name': 'Marcia', 'image': 'heather.jpg', 'points': 0},
  ];

  void _addPoints(int index) {
    setState(() {
      _ranking[index]['points'] += 100;
      _ranking.sort((a, b) => b['points'].compareTo(a['points']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Ranking',
          style: TextStyle(color: Colors.black),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: _ranking.length,
          itemBuilder: (context, index) {
            final user = _ranking[index];
            return Card(
              color: Colors.yellow,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 100, // Aumentamos la altura de la card
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/${user['image']}',
                      width: 70,  // imagen más grande
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${user['name']} - ${user['points']} pts',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _addPoints(index),
                      child: Text('+100'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E3A5F)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}