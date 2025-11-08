import 'package:equatable/equatable.dart';
import '../../data/model/event.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {}

class AddEvent extends EventEvent {
  final Event event;

  const AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEvent extends EventEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class UpdateEvent extends EventEvent {
  final Event event;

  const UpdateEvent(this.event);

  @override
  List<Object> get props => [event];
}
