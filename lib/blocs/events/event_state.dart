import 'package:equatable/equatable.dart';
import '../../data/model/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventState {}

class EventsLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;

  const EventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

// New state for successful event creation
class EventCreationSuccess extends EventsLoaded {
  const EventCreationSuccess(List<Event> events) : super(events);

  @override
  List<Object> get props => [events, identityHashCode(this)]; // To make it unique
}

class EventsError extends EventState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object> get props => [message];
}
