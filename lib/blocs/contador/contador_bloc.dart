import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/contador_repository.dart';
import 'contador_event.dart';
import 'contador_state.dart';

class ContadorBloc extends Bloc<ContadorEvent, ContadorState> {
  final ContadorRepository _contadorRepository;

  ContadorBloc({required ContadorRepository contadorRepository})
      : _contadorRepository = contadorRepository,
        super(ContadorInitial()) {
    on<LoadContador>(_onLoadContador);
    on<AddManualMoney>(_onAddManualMoney);
    on<SubtractManualMoney>(_onSubtractManualMoney);
  }

  Future<void> _onLoadContador(LoadContador event, Emitter<ContadorState> emit) async {
    emit(ContadorLoading());
    try {
      await emit.forEach(
        _contadorRepository.getContadorStream(),
        onData: (contador) => ContadorLoaded(
          gananciasDeEventos: contador.gananciasDeEventos,
          manualMoney: contador.manualMoney,
          historialEventos: contador.historialEventos,
        ),
        onError: (error, _) => ContadorError(error.toString()),
      );
    } catch (e) {
      emit(ContadorError(e.toString()));
    }
  }

  Future<void> _onAddManualMoney(AddManualMoney event, Emitter<ContadorState> emit) async {
    if (state is ContadorLoaded) {
      final currentState = state as ContadorLoaded;
      final newManualMoney = currentState.manualMoney + event.amount;
      await _contadorRepository.updateManualMoney(newManualMoney);
      // No need to emit here, the stream will do it.
    }
  }

  Future<void> _onSubtractManualMoney(
      SubtractManualMoney event, Emitter<ContadorState> emit) async {
    if (state is ContadorLoaded) {
      final currentState = state as ContadorLoaded;
      final newAmount = currentState.manualMoney - event.amount;
      final finalAmount = newAmount >= 0 ? newAmount : 0.0;
      await _contadorRepository.updateManualMoney(finalAmount);
      // No need to emit here, the stream will do it.
    }
  }
}
