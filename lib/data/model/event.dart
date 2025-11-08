import 'package:equatable/equatable.dart';

enum EventStatus { upcoming, inProgress, finished }

class Event extends Equatable {
  final String? id;
  final String title;
  final String description;
  final List<String> guests;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;

  const Event({
    this.id,
    required this.title,
    required this.description,
    required this.guests,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
  });

  // Getter to determine the status of the event
  EventStatus get status {
    // Use UTC for all comparisons to avoid timezone issues
    final now = DateTime.now().toUtc();
    final start = startTime.toUtc();
    final end = endTime.toUtc();

    if (now.isBefore(start)) {
      return EventStatus.upcoming;
    } else if (now.isAfter(start) && now.isBefore(end)) {
      return EventStatus.inProgress;
    } else {
      return EventStatus.finished;
    }
  }

  @override
  List<Object?> get props => [id, title, description, guests, startTime, endTime, imageUrl];
}
