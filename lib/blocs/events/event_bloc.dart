import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/event.dart';
import '../../data/repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;
  StreamSubscription? _eventsSubscription;

  EventBloc(this._eventRepository) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<_UpdateEvents>(_onUpdateEvents);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventState> emit) {
    emit(EventsLoading());
    _eventsSubscription?.cancel();
    // Listen to the stream from the repository and add an internal event
    _eventsSubscription = _eventRepository.getEvents().listen(
          (events) => add(_UpdateEvents(events)),
        );
  }

  void _onAddEvent(AddEvent event, Emitter<EventState> emit) {
    _eventRepository.addEvent(event.event);
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) {
    _eventRepository.updateEvent(event.event);
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) {
    _eventRepository.deleteEvent(event.eventId);
  }

  // This private event receives the list of events from the stream
  // and emits the EventsLoaded state.
  void _onUpdateEvents(_UpdateEvents event, Emitter<EventState> emit) {
    emit(EventsLoaded(event.events));
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}

// Private event to handle updates from the stream
class _UpdateEvents extends EventEvent {
  final List<Event> events;

  const _UpdateEvents(this.events);

  @override
  List<Object> get props => [events];
}
