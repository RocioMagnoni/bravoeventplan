import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/contador_repository.dart';
import 'contador_event.dart';
import 'contador_state.dart';
import '../../data/model/event.dart';

class ContadorBloc extends Bloc<ContadorEvent, ContadorState> {
  final EventRepository _eventRepository;
  final ContadorRepository _contadorRepository;

  ContadorBloc({
    required EventRepository eventRepository,
    required ContadorRepository contadorRepository,
  })  : _eventRepository = eventRepository,
        _contadorRepository = contadorRepository,
        super(ContadorInitial()) {

    on<LoadContador>(_onLoadContador);
    on<AddManualMoney>(_onAddManualMoney);
    on<SubtractManualMoney>(_onSubtractManualMoney);
  }

  void _onLoadContador(LoadContador event, Emitter<ContadorState> emit) async {
    emit(ContadorLoading());
    try {
      // First, load the initial manual money to have a starting point.
      final initialContador = await _contadorRepository.getContador();

      // Then, listen to the events stream for automatic updates.
      await emit.forEach<List<Event>>(
        _eventRepository.getEvents(),
        onData: (events) {
          final finishedEvents = events.where((e) => e.status == EventStatus.finished).toList();
          final totalEventos = finishedEvents.fold<double>(0.0, (sum, e) => sum + e.totalEarned);

          // Get the most recent manual money from the CURRENT state, or use initial if not loaded yet.
          double currentManualMoney = initialContador.manualMoney;
          if (state is ContadorLoaded) {
            currentManualMoney = (state as ContadorLoaded).manualMoney;
          }

          return ContadorLoaded(
            gananciasDeEventos: totalEventos,
            manualMoney: currentManualMoney, // Use the up-to-date value!
            historialEventos: finishedEvents,
          );
        },
        onError: (error, stackTrace) => ContadorError(error.toString()),
      );
    } catch (e) {
      emit(ContadorError(e.toString()));
    }
  }

  void _onAddManualMoney(AddManualMoney event, Emitter<ContadorState> emit) async {
    if (state is ContadorLoaded) {
      final currentState = state as ContadorLoaded;
      final newManualMoney = currentState.manualMoney + event.amount;
      await _contadorRepository.updateManualMoney(newManualMoney);
      emit(currentState.copyWith(manualMoney: newManualMoney));
    }
  }

  void _onSubtractManualMoney(SubtractManualMoney event, Emitter<ContadorState> emit) async {
    if (state is ContadorLoaded) {
      final currentState = state as ContadorLoaded;
      final newAmount = currentState.manualMoney - event.amount;
      final finalAmount = newAmount >= 0 ? newAmount : 0.0; // Corrected to use 0.0
      await _contadorRepository.updateManualMoney(finalAmount);
      emit(currentState.copyWith(manualMoney: finalAmount));
    }
  }
}
