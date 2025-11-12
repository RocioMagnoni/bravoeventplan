import 'package:cloud_firestore/cloud_firestore.dart';

class Contador {
  final double manualMoney;

  Contador({this.manualMoney = 0.0});

  factory Contador.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?; // Data can be null
    return Contador(
      manualMoney: (data?['manualMoney'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manualMoney': manualMoney,
    };
  }
}
