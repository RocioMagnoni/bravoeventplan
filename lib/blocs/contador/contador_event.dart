import 'package:equatable/equatable.dart';

abstract class ContadorEvent extends Equatable {
  const ContadorEvent();

  @override
  List<Object> get props => [];
}

class LoadContador extends ContadorEvent {}

// Event to add a specific amount manually
class AddManualMoney extends ContadorEvent {
  final double amount;

  const AddManualMoney(this.amount);

  @override
  List<Object> get props => [amount];
}

// Event to subtract a specific amount manually
class SubtractManualMoney extends ContadorEvent {
  final double amount;

  const SubtractManualMoney(this.amount);

  @override
  List<Object> get props => [amount];
}
