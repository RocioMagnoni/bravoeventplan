import 'package:flutter/material.dart';
import '../data/model/ranking_entry.dart';

class RankingViewModel extends ChangeNotifier {
  final List<RankingEntry> _ranking = [
    RankingEntry(name: 'Johnny Bravo', image: 'bravo.jpg', points: 1000),
    RankingEntry(name: 'Suzy', image: 'suzy.jpg', points: 0),
    RankingEntry(name: 'Carl', image: 'carl.jpg', points: 0),
    RankingEntry(name: 'Bunny', image: 'bunny.jpg', points: 0),
    RankingEntry(name: 'Marcia', image: 'heather.jpg', points: 0),
  ];

  List<RankingEntry> get ranking => _ranking;

  void addPoints(int index) {
    if (index < 0 || index >= _ranking.length) return;
    _ranking[index].points += 100;
    _ranking.sort((a, b) => b.points.compareTo(a.points));
    notifyListeners();
  }
}
