import 'package:equatable/equatable.dart';
import '../../data/model/event.dart';

abstract class ContadorState extends Equatable {
  const ContadorState();

  @override
  List<Object> get props => [];
}

class ContadorInitial extends ContadorState {}

class ContadorLoading extends ContadorState {}

class ContadorLoaded extends ContadorState {
  final double gananciasDeEventos;
  final double manualMoney;
  final List<Event> historialEventos;

  const ContadorLoaded({
    this.gananciasDeEventos = 0.0,
    this.manualMoney = 0.0, 
    this.historialEventos = const [],
  });

  // Helper to get the grand total
  double get gananciaTotalBruta => gananciasDeEventos + manualMoney;

  ContadorLoaded copyWith({
    double? gananciasDeEventos,
    double? manualMoney,
    List<Event>? historialEventos,
  }) {
    return ContadorLoaded(
      gananciasDeEventos: gananciasDeEventos ?? this.gananciasDeEventos,
      manualMoney: manualMoney ?? this.manualMoney,
      historialEventos: historialEventos ?? this.historialEventos,
    );
  }

  @override
  List<Object> get props => [gananciasDeEventos, manualMoney, historialEventos];
}

class ContadorError extends ContadorState {
  final String message;

  const ContadorError(this.message);

  @override
  List<Object> get props => [message];
}
