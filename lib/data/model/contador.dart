import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:responsive_magnoni/data/model/event.dart';

class Contador extends Equatable {
  final double manualMoney;
  final double gananciasDeEventos;
  final List<Event> historialEventos;

  const Contador({
    this.manualMoney = 0.0,
    this.gananciasDeEventos = 0.0,
    this.historialEventos = const [],
  });

  double get gananciaTotalBruta => manualMoney + gananciasDeEventos;

  factory Contador.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;
    return Contador(
      manualMoney: (data?['manualMoney'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manualMoney': manualMoney,
    };
  }

  Contador copyWith({
    double? manualMoney,
    double? gananciasDeEventos,
    List<Event>? historialEventos,
  }) {
    return Contador(
      manualMoney: manualMoney ?? this.manualMoney,
      gananciasDeEventos: gananciasDeEventos ?? this.gananciasDeEventos,
      historialEventos: historialEventos ?? this.historialEventos,
    );
  }

  @override
  List<Object?> get props => [manualMoney, gananciasDeEventos, historialEventos];
}
