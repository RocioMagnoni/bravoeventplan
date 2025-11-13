import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_magnoni/data/model/event.dart';
import 'package:responsive_magnoni/data/repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;

  EventBloc(this._eventRepository) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  int _getStatusSortPriority(EventStatus status) {
    switch (status) {
      case EventStatus.inProgress:
        return 0;
      case EventStatus.upcoming:
        return 1;
      case EventStatus.finished:
        return 2;
    }
  }

  List<Event> _sortEvents(List<Event> events) {
    final sorted = List<Event>.from(events);
    sorted.sort((a, b) {
      final priorityA = _getStatusSortPriority(a.status);
      // THE CULPRIT IS EXORCISED!
      final priorityB = _getStatusSortPriority(b.status);
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      return a.startTime.compareTo(b.startTime);
    });
    return sorted;
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      await emit.forEach<List<Event>>(
        _eventRepository.getEvents(),
        onData: (events) {
          final sortedEvents = _sortEvents(events);
          if (state is EventCreationSuccess) {
            return EventsLoaded(sortedEvents);
          }
          return EventsLoaded(sortedEvents);
        },
        onError: (error, _) => EventsError(error.toString()),
      );
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    try {
      await _eventRepository.addEvent(event.event);
      if (state is EventsLoaded) {
        final currentEvents = (state as EventsLoaded).events;
        emit(EventCreationSuccess(_sortEvents(currentEvents)));
      }
    } catch (e) {
      emit(EventsError("Failed to add event: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    try {
      await _eventRepository.updateEvent(event.event);
    } catch (e) {
      emit(EventsError("Failed to update event: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      await _eventRepository.deleteEvent(event.eventId);
    } catch (e) {
      emit(EventsError("Failed to delete event: ${e.toString()}"));
    }
  }
}
